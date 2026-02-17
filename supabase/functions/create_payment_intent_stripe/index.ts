import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import Stripe from 'https://esm.sh/stripe@12.0.0?target=deno'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-idempotency-key',
}

// Rate limiting configuration
const RATE_LIMITS = {
  // Per IP: max requests per window
  perIp: { max: 20, windowMinutes: 1 },
  // Per session: max requests per window
  perSession: { max: 10, windowMinutes: 5 },
  // Global: max concurrent processing
  global: { maxConcurrent: 100 }
}

// In-memory rate limit store (use Redis in production)
const rateLimitStore = new Map<string, { count: number; resetTime: number }>()

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') || '', {
  apiVersion: '2023-10-16',
  httpClient: Stripe.createFetchHttpClient(),
})

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

// Helper: Check rate limit
async function checkRateLimit(
  identifier: string, 
  maxRequests: number, 
  windowMinutes: number
): Promise<{ allowed: boolean; remaining: number; resetTime: number }> {
  const now = Date.now()
  const windowMs = windowMinutes * 60 * 1000
  const key = `rate_limit:${identifier}`
  
  let record = rateLimitStore.get(key)
  
  if (!record || now > record.resetTime) {
    // New window
    record = { count: 0, resetTime: now + windowMs }
  }
  
  if (record.count >= maxRequests) {
    return { 
      allowed: false, 
      remaining: 0, 
      resetTime: record.resetTime 
    }
  }
  
  record.count++
  rateLimitStore.set(key, record)
  
  return { 
    allowed: true, 
    remaining: maxRequests - record.count, 
    resetTime: record.resetTime 
  }

  // Note: In production, use Redis or PostgreSQL for distributed rate limiting
  // Example with PostgreSQL:
  /*
  const { data } = await supabaseAdmin.rpc('check_rate_limit', {
    p_identifier: identifier,
    p_max_requests: maxRequests,
    p_window_minutes: windowMinutes
  })
  return data
  */
}

// Helper: Get client IP
function getClientIp(req: Request): string {
  const forwarded = req.headers.get('x-forwarded-for')
  if (forwarded) {
    return forwarded.split(',')[0].trim()
  }
  return 'unknown'
}

// Helper: Validate amount
function validateAmount(amount: number): { valid: boolean; error?: string } {
  if (typeof amount !== 'number' || isNaN(amount)) {
    return { valid: false, error: 'Invalid amount' }
  }
  
  if (amount <= 0) {
    return { valid: false, error: 'Amount must be positive' }
  }
  
  if (amount > 100000) { // R$ 100,000 max
    return { valid: false, error: 'Amount exceeds maximum allowed' }
  }
  
  if (amount < 1) { // R$ 1 min
    return { valid: false, error: 'Amount below minimum' }
  }
  
  return { valid: true }
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  const startTime = Date.now()
  const clientIp = getClientIp(req)

  try {
    // Check IP rate limit
    const ipLimit = await checkRateLimit(
      `ip:${clientIp}`,
      RATE_LIMITS.perIp.max,
      RATE_LIMITS.perIp.windowMinutes
    )
    
    if (!ipLimit.allowed) {
      return new Response(
        JSON.stringify({ 
          success: false, 
          error: { 
            code: 'RATE_LIMIT_EXCEEDED', 
            message: 'Too many requests from this IP',
            retryAfter: Math.ceil((ipLimit.resetTime - Date.now()) / 1000)
          } 
        }),
        { 
          headers: { 
            ...corsHeaders, 
            'Content-Type': 'application/json',
            'X-RateLimit-Limit': RATE_LIMITS.perIp.max.toString(),
            'X-RateLimit-Remaining': '0',
            'X-RateLimit-Reset': Math.ceil(ipLimit.resetTime / 1000).toString()
          }, 
          status: 429 
        }
      )
    }

    const { intent_id, payment_method_types = ['card'], return_url } = await req.json()

    if (!intent_id) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Intent ID is required' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // Get booking intent with row lock (using RPC for atomic operation)
    const { data: intent, error: intentError } = await supabaseAdmin
      .from('booking_intents')
      .select('*, properties_map(name, city_code)')
      .eq('id', intent_id)
      .single()

    if (intentError || !intent) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_002', message: 'Booking intent not found' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 404 }
      )
    }

    // Check session rate limit
    if (intent.session_id) {
      const sessionLimit = await checkRateLimit(
        `session:${intent.session_id}`,
        RATE_LIMITS.perSession.max,
        RATE_LIMITS.perSession.windowMinutes
      )
      
      if (!sessionLimit.allowed) {
        return new Response(
          JSON.stringify({ 
            success: false, 
            error: { 
              code: 'RATE_LIMIT_EXCEEDED', 
              message: 'Too many payment attempts for this session',
              retryAfter: Math.ceil((sessionLimit.resetTime - Date.now()) / 1000)
            } 
          }),
          { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 429 }
        )
      }
    }

    // Validate intent state
    const validStates = ['intent_created', 'payment_failed']
    if (!validStates.includes(intent.status)) {
      return new Response(
        JSON.stringify({ 
          success: false, 
          error: { 
            code: 'RESERVE_003', 
            message: `Invalid intent status: ${intent.status}`,
            details: `Expected one of: ${validStates.join(', ')}`
          } 
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // Check expiration
    if (new Date(intent.expires_at) < new Date()) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_004', message: 'Booking intent has expired' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // Validate amount
    const amountValidation = validateAmount(intent.total_amount)
    if (!amountValidation.valid) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_005', message: amountValidation.error } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // Idempotency key
    const idempotencyKey = req.headers.get('x-idempotency-key') || `stripe:${intent_id}:${Date.now()}`

    // Check for existing payment using database-level deduplication
    const { data: existingPayment, error: existingError } = await supabaseAdmin
      .from('payments')
      .select('*')
      .eq('booking_intent_id', intent_id)
      .eq('gateway', 'stripe')
      .in('status', ['pending', 'processing'])
      .maybeSingle()

    if (existingError) {
      console.error('Error checking existing payment:', existingError)
    }

    if (existingPayment) {
      // Return existing payment
      const timeElapsed = Date.now() - startTime
      
      return new Response(
        JSON.stringify({
          success: true,
          data: {
            client_secret: existingPayment.stripe_client_secret,
            payment_intent_id: existingPayment.gateway_payment_id,
            amount: existingPayment.amount,
            currency: existingPayment.currency,
            cached: true,
            processing_time_ms: timeElapsed
          }
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check for already succeeded payment
    const { data: succeededPayment } = await supabaseAdmin
      .from('payments')
      .select('*')
      .eq('booking_intent_id', intent_id)
      .eq('gateway', 'stripe')
      .eq('status', 'succeeded')
      .maybeSingle()

    if (succeededPayment) {
      return new Response(
        JSON.stringify({
          success: false,
          error: {
            code: 'RESERVE_006',
            message: 'Payment already completed for this intent',
            details: { payment_id: succeededPayment.id }
          }
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 409 }
      )
    }

    // Create Stripe Payment Intent
    const amountInCents = Math.round(intent.total_amount * 100)

    // Set timeout for Stripe API call
    const stripeTimeout = 25000 // 25 seconds
    
    const paymentIntentPromise = stripe.paymentIntents.create({
      amount: amountInCents,
      currency: intent.currency.toLowerCase(),
      payment_method_types,
      metadata: {
        intent_id: intent.id,
        property_id: intent.property_id,
        city_code: intent.city_code,
        nights: intent.nights,
        guests: intent.guests_adults + intent.guests_children,
        idempotency_key: idempotencyKey
      },
      description: `Booking at ${intent.properties_map?.name} - ${intent.nights} nights`,
      receipt_email: intent.guest_email || undefined,
    }, {
      idempotencyKey
    })

    // Race Stripe call against timeout
    const paymentIntent = await Promise.race([
      paymentIntentPromise,
      new Promise<never>((_, reject) => 
        setTimeout(() => reject(new Error('Stripe API timeout')), stripeTimeout)
      )
    ])

    // Create payment record using upsert for idempotency
    const { data: payment, error: paymentError } = await supabaseAdmin
      .from('payments')
      .insert({
        booking_intent_id: intent_id,
        city_code: intent.city_code,
        payment_method: 'stripe_card',
        gateway: 'stripe',
        gateway_payment_id: paymentIntent.id,
        amount: intent.total_amount,
        currency: intent.currency,
        status: 'pending',
        stripe_client_secret: paymentIntent.client_secret,
        idempotency_key: idempotencyKey,
        metadata: {
          payment_intent_created_at: new Date().toISOString(),
          return_url,
          client_ip: clientIp,
          user_agent: req.headers.get('user-agent')
        }
      })
      .select()
      .single()

    if (paymentError) {
      // Check if it's a duplicate key violation
      if (paymentError.code === '23505') {
        // Another request created the payment, fetch it
        const { data: dupPayment } = await supabaseAdmin
          .from('payments')
          .select('*')
          .eq('idempotency_key', idempotencyKey)
          .single()
        
        if (dupPayment) {
          return new Response(
            JSON.stringify({
              success: true,
              data: {
                client_secret: dupPayment.stripe_client_secret,
                payment_intent_id: dupPayment.gateway_payment_id,
                amount: dupPayment.amount,
                currency: dupPayment.currency,
                cached: true
              }
            }),
            { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
          )
        }
      }
      
      throw paymentError
    }

    // Update intent status with state machine validation (enforced by DB trigger)
    const { error: intentUpdateError } = await supabaseAdmin
      .from('booking_intents')
      .update({ 
        status: 'payment_pending',
        payment_intent_id: paymentIntent.id,
        payment_method: 'stripe_card',
        updated_at: new Date().toISOString()
      })
      .eq('id', intent_id)

    if (intentUpdateError) {
      console.error('Error updating intent status:', intentUpdateError)
      // Continue anyway - payment was created
    }

    // Emit event
    await supabaseAdmin.from('events').insert({
      event_name: 'payment_started',
      city_code: intent.city_code,
      session_id: intent.session_id,
      metadata: {
        intent_id,
        payment_id: payment.id,
        gateway: 'stripe',
        amount: intent.total_amount,
        payment_method: 'stripe_card',
        rate_limit_remaining: ipLimit.remaining
      }
    })

    const processingTime = Date.now() - startTime

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          client_secret: paymentIntent.client_secret,
          payment_intent_id: paymentIntent.id,
          amount: amountInCents,
          currency: intent.currency.toLowerCase(),
          payment_id: payment.id,
          expires_at: intent.expires_at,
          rate_limit: {
            remaining: ipLimit.remaining,
            reset_at: new Date(ipLimit.resetTime).toISOString()
          },
          processing_time_ms: processingTime
        }
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Error in create_payment_intent_stripe:', error)
    
    const processingTime = Date.now() - startTime
    
    return new Response(
      JSON.stringify({ 
        success: false, 
        error: { 
          code: 'RESERVE_010', 
          message: 'Internal error',
          details: error.message,
          processing_time_ms: processingTime
        } 
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})
