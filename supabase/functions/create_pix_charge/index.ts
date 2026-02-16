import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-idempotency-key',
}

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
    const idempotencyKey = req.headers.get('x-idempotency-key') || `pix_${intent_id}_${Date.now()}`

    // Check for existing PIX charge
    const { data: existingPayment } = await supabaseAdmin
      .from('payments')
      .select('*')
      .eq('booking_intent_id', intent_id)
      .eq('gateway', 'mercadopago')
      .eq('payment_method', 'pix')
      .in('status', ['pending', 'processing'])
      .single()

    if (existingPayment?.pix_qr_code) {
      return new Response(
        JSON.stringify({
          success: true,
          data: {
            pix_id: existingPayment.gateway_payment_id,
            qr_code_base64: existingPayment.pix_qr_code,
            copy_paste_key: existingPayment.pix_copy_paste_key,
            expires_at: existingPayment.pix_expires_at,
            cached: true
          }
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Calculate IOF (0.38% for PIX in Brazil)
    const iofAmount = Math.round(intent.total_amount * 0.0038 * 100) / 100
    const totalWithIof = intent.total_amount + iofAmount

    // PIX Provider Integration (MercadoPago example)
    const pixProvider = Deno.env.get('PIX_PROVIDER') || 'mercadopago'
    const pixApiKey = Deno.env.get('PIX_API_KEY')

    if (!pixApiKey) {
      throw new Error('PIX API key not configured')
    }

    let pixResponse: any

    if (pixProvider === 'mercadopago') {
      // MercadoPago PIX integration
      const mpResponse = await fetch('https://api.mercadopago.com/v1/payments', {
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

      if (!mpResponse.ok) {
        const error = await mpResponse.json()
        throw new Error(`MercadoPago error: ${JSON.stringify(error)}`)
      }

      pixResponse = await mpResponse.json()
    } else if (pixProvider === 'openpix') {
      // OpenPIX integration
      const opResponse = await fetch('https://api.openpix.com.br/api/v1/charge', {
        method: 'POST',
        headers: {
          'Authorization': pixApiKey,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          correlationID: intent_id,
          value: Math.round(totalWithIof * 100), // In cents
          comment: `Booking at ${intent.properties_map?.name}`,
          customer: {
            name: `${intent.guest_first_name || 'Guest'} ${intent.guest_last_name || ''}`.trim(),
            email: intent.guest_email || 'guest@reserveconnect.com'
          }
        })
      })

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
    const { data: payment } = await supabaseAdmin
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
          raw_response: pixResponse
        }
      })
      .select()
      .single()

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
        payment_method: 'pix'
      }
    })

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
          payment_id: payment.id
        }
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Error in create_pix_charge:', error)
    return new Response(
      JSON.stringify({ success: false, error: { code: 'RESERVE_010', message: 'Internal error', details: error.message } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})
