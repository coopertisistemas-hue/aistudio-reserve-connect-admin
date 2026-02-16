import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import Stripe from 'https://esm.sh/stripe@12.0.0?target=deno'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-idempotency-key',
}

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') || '', {
  apiVersion: '2023-10-16',
  httpClient: Stripe.createFetchHttpClient(),
})

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
    )

    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { intent_id, payment_method_types = ['card'], return_url } = await req.json()

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

    // Check if intent is still valid
    if (intent.status !== 'intent_created') {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: `Invalid intent status: ${intent.status}` } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    if (new Date(intent.expires_at) < new Date()) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Booking intent has expired' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // Idempotency key
    const idempotencyKey = req.headers.get('x-idempotency-key') || `stripe_${intent_id}_${Date.now()}`

    // Check for existing payment
    const { data: existingPayment } = await supabaseAdmin
      .from('payments')
      .select('*')
      .eq('booking_intent_id', intent_id)
      .eq('gateway', 'stripe')
      .in('status', ['pending', 'processing'])
      .single()

    if (existingPayment?.stripe_client_secret) {
      return new Response(
        JSON.stringify({
          success: true,
          data: {
            client_secret: existingPayment.stripe_client_secret,
            payment_intent_id: existingPayment.gateway_payment_id,
            amount: existingPayment.amount,
            currency: existingPayment.currency,
            cached: true
          }
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Create Stripe Payment Intent
    const amountInCents = Math.round(intent.total_amount * 100) // Convert to cents

    const paymentIntent = await stripe.paymentIntents.create({
      amount: amountInCents,
      currency: intent.currency.toLowerCase(),
      payment_method_types,
      metadata: {
        intent_id: intent.id,
        property_id: intent.property_id,
        city_code: intent.city_code,
        nights: intent.nights,
        guests: intent.guests_adults + intent.guests_children
      },
      description: `Booking at ${intent.properties_map?.name} - ${intent.nights} nights`,
      receipt_email: intent.guest_email || undefined,
    }, {
      idempotencyKey
    })

    // Create payment record
    const { data: payment } = await supabaseAdmin
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
          return_url
        }
      })
      .select()
      .single()

    // Update intent status
    await supabaseAdmin
      .from('booking_intents')
      .update({ 
        status: 'payment_pending',
        payment_intent_id: paymentIntent.id,
        payment_method: 'stripe_card',
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
        gateway: 'stripe',
        amount: intent.total_amount,
        payment_method: 'stripe_card'
      }
    })

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          client_secret: paymentIntent.client_secret,
          payment_intent_id: paymentIntent.id,
          amount: amountInCents,
          currency: intent.currency.toLowerCase(),
          payment_id: payment.id
        }
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Error in create_payment_intent_stripe:', error)
    return new Response(
      JSON.stringify({ success: false, error: { code: 'RESERVE_010', message: 'Internal error', details: error.message } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})
