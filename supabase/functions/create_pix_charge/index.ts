import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-idempotency-key, x-session-id',
}

// Rate limiting configuration
const RATE_LIMITS = {
  perIp: { max: 15, windowMinutes: 1 },
  perSession: { max: 8, windowMinutes: 5 },
}

// In-memory rate limit store
const rateLimitStore = new Map<string, { count: number; resetTime: number }>()

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
    record = { count: 0, resetTime: now + windowMs }
  }
  
  if (record.count >= maxRequests) {
    return { allowed: false, remaining: 0, resetTime: record.resetTime }
  }
  
  record.count++
  rateLimitStore.set(key, record)
  
  return { allowed: true, remaining: maxRequests - record.count, resetTime: record.resetTime }
}

// Helper: Get client IP
function getClientIp(req: Request): string {
  const forwarded = req.headers.get('x-forwarded-for')
  if (forwarded) return forwarded.split(',')[0].trim()
  return 'unknown'
}

// Helper: Validate amount
function validateAmount(amount: number): { valid: boolean; error?: string } {
  if (typeof amount !== 'number' || isNaN(amount)) {
    return { valid: false, error: 'Invalid amount' }
  }
  if (amount <= 0) return { valid: false, error: 'Amount must be positive' }
  if (amount > 100000) return { valid: false, error: 'Amount exceeds maximum allowed (R$ 100,000)' }
  if (amount < 1) return { valid: false, error: 'Amount below minimum (R$ 1)' }
  return { valid: true }
}

// Helper: Calculate IOF (Brazilian tax)
function calculateIof(amount: number): number {
  return Math.round(amount * 0.0038 * 100) / 100
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
      `ip:${clientIp}:pix`,
      RATE_LIMITS.perIp.max,
      RATE_LIMITS.perIp.windowMinutes
    )
    
    if (!ipLimit.allowed) {
      return new Response(
        JSON.stringify({ 
          success: false, 
          error: { 
            code: 'RATE_LIMIT_EXCEEDED', 
            message: 'Too many PIX requests from this IP',
            retryAfter: Math.ceil((ipLimit.resetTime - Date.now()) / 1000)
          } 
        }),
        { 
          headers: { 
            ...corsHeaders, 
            'Content-Type': 'application/json',
            'Retry-After': Math.ceil((ipLimit.resetTime - Date.now()) / 1000).toString()
          }, 
          status: 429 
        }
      )
    }

    const { intent_id, expires_in_minutes = 15 } = await req.json()

    if (!intent_id) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Intent ID is required' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // Get booking intent
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
        `session:${intent.session_id}:pix`,
        RATE_LIMITS.perSession.max,
        RATE_LIMITS.perSession.windowMinutes
      )
      
      if (!sessionLimit.allowed) {
        return new Response(
          JSON.stringify({ 
            success: false, 
            error: { 
              code: 'RATE_LIMIT_EXCEEDED', 
              message: 'Too many PIX attempts for this session',
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
    const idempotencyKey = req.headers.get('x-idempotency-key') || `pix:${intent_id}:${Date.now()}`

    // Check for existing PIX payment
    const { data: existingPayment } = await supabaseAdmin
      .from('payments')
      .select('*')
      .eq('booking_intent_id', intent_id)
      .eq('gateway', 'mercadopago')
      .eq('payment_method', 'pix')
      .in('status', ['pending', 'processing'])
      .maybeSingle()

    if (existingPayment?.pix_qr_code) {
      const timeElapsed = Date.now() - startTime
      return new Response(
        JSON.stringify({
          success: true,
          data: {
            pix_id: existingPayment.gateway_payment_id,
            qr_code_base64: existingPayment.pix_qr_code,
            copy_paste_key: existingPayment.pix_copy_paste_key,
            expires_at: existingPayment.pix_expires_at,
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
      .eq('payment_method', 'pix')
      .eq('status', 'succeeded')
      .maybeSingle()

    if (succeededPayment) {
      return new Response(
        JSON.stringify({
          success: false,
          error: {
            code: 'RESERVE_006',
            message: 'PIX payment already completed for this intent',
            details: { payment_id: succeededPayment.id }
          }
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 409 }
      )
    }

    // Calculate IOF and total
    const iofAmount = calculateIof(intent.total_amount)
    const totalWithIof = intent.total_amount + iofAmount

    // Get PIX provider configuration
    const pixProvider = Deno.env.get('PIX_PROVIDER') || 'mercadopago'
    const pixApiKey = Deno.env.get('PIX_API_KEY')

    if (!pixApiKey) {
      throw new Error('PIX API key not configured')
    }

    let pixResponse: any
    const providerTimeout = 20000 // 20 seconds

    if (pixProvider === 'mercadopago') {
      const mpPromise = fetch('https://api.mercadopago.com/v1/payments', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${pixApiKey}`,
          'Content-Type': 'application/json',
          'X-Idempotency-Key': idempotencyKey
        },
        body: JSON.stringify({
          transaction_amount: totalWithIof,
          description: `Booking at ${intent.properties_map?.name}`,
          payment_method_id: 'pix',
          payer: {
            email: intent.guest_email || 'guest@reserveconnect.com',
            first_name: intent.guest_first_name || 'Guest',
            last_name: intent.guest_last_name || ''
          },
          notification_url: `${Deno.env.get('SUPABASE_URL')}/functions/v1/webhook_pix`,
          external_reference: intent_id
        })
      })

      const mpResponse = await Promise.race([
        mpPromise,
        new Promise<never>((_, reject) => 
          setTimeout(() => reject(new Error('PIX provider timeout')), providerTimeout)
        )
      ]) as Response

      if (!mpResponse.ok) {
        const error = await mpResponse.json()
        throw new Error(`MercadoPago error: ${JSON.stringify(error)}`)
      }

      pixResponse = await mpResponse.json()

    } else if (pixProvider === 'openpix') {
      const opPromise = fetch('https://api.openpix.com.br/api/v1/charge', {
        method: 'POST',
        headers: {
          'Authorization': pixApiKey,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          correlationID: intent_id,
          value: Math.round(totalWithIof * 100),
          comment: `Booking at ${intent.properties_map?.name}`,
          customer: {
            name: `${intent.guest_first_name || 'Guest'} ${intent.guest_last_name || ''}`.trim(),
            email: intent.guest_email || 'guest@reserveconnect.com'
          }
        })
      })

      const opResponse = await Promise.race([
        opPromise,
        new Promise<never>((_, reject) => 
          setTimeout(() => reject(new Error('PIX provider timeout')), providerTimeout)
        )
      ]) as Response

      if (!opResponse.ok) {
        const error = await opResponse.json()
        throw new Error(`OpenPIX error: ${JSON.stringify(error)}`)
      }

      pixResponse = await opResponse.json()
    } else {
      throw new Error(`Unsupported PIX provider: ${pixProvider}`)
    }

    // Calculate expiration
    const expiresAt = new Date()
    expiresAt.setMinutes(expiresAt.getMinutes() + expires_in_minutes)

    // Create payment record
    const { data: payment, error: paymentError } = await supabaseAdmin
      .from('payments')
      .insert({
        booking_intent_id: intent_id,
        city_code: intent.city_code,
        payment_method: 'pix',
        gateway: pixProvider,
        gateway_payment_id: pixResponse.id || pixResponse.charge?.correlationID,
        amount: intent.total_amount,
        currency: intent.currency,
        tax_amount: iofAmount,
        status: 'pending',
        pix_qr_code: pixResponse.point_of_interaction?.transaction_data?.qr_code_base64 || pixResponse.charge?.qrCodeImage,
        pix_copy_paste_key: pixResponse.point_of_interaction?.transaction_data?.qr_code || pixResponse.charge?.brCode,
        pix_expires_at: expiresAt.toISOString(),
        idempotency_key: idempotencyKey,
        metadata: {
          pix_provider: pixProvider,
          iof_amount: iofAmount,
          total_with_iof: totalWithIof,
          client_ip: clientIp,
          user_agent: req.headers.get('user-agent')
        }
      })
      .select()
      .single()

    if (paymentError) {
      if (paymentError.code === '23505') {
        // Duplicate - fetch existing
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
                pix_id: dupPayment.gateway_payment_id,
                qr_code_base64: dupPayment.pix_qr_code,
                copy_paste_key: dupPayment.pix_copy_paste_key,
                expires_at: dupPayment.pix_expires_at,
                cached: true
              }
            }),
            { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
          )
        }
      }
      throw paymentError
    }

    // Update intent status
    await supabaseAdmin
      .from('booking_intents')
      .update({ 
        status: 'payment_pending',
        pix_charge_id: payment.gateway_payment_id,
        payment_method: 'pix',
        updated_at: new Date().toISOString()
      })
      .eq('id', intent_id)

    // Emit event
    await supabaseAdmin.from('events').insert({
      event_name: 'payment_started',
      city_code: intent.city_code,
      session_id: intent.session_id,
      metadata: {
        intent_id,
        payment_id: payment.id,
        gateway: pixProvider,
        amount: intent.total_amount,
        iof_amount: iofAmount,
        payment_method: 'pix',
        rate_limit_remaining: ipLimit.remaining
      }
    })

    const processingTime = Date.now() - startTime

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          pix_id: payment.gateway_payment_id,
          qr_code_base64: payment.pix_qr_code,
          copy_paste_key: payment.pix_copy_paste_key,
          expires_at: payment.pix_expires_at,
          amount: intent.total_amount,
          iof_amount: iofAmount,
          total_with_iof: totalWithIof,
          payment_id: payment.id,
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
    console.error('Error in create_pix_charge:', error)
    
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
