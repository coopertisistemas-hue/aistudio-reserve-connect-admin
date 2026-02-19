import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-session-id, x-idempotency-key',
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

    const { intent_id, payment_id } = await req.json()

    if (!intent_id && !payment_id) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Intent ID or Payment ID is required' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    let payment: any
    let intent: any

    // Get payment by ID or intent_id
    if (payment_id) {
      const { data } = await supabaseAdmin
        .from('payments')
        .select('*, booking_intents!inner(*)')
        .eq('id', payment_id)
        .single()
      payment = data
      intent = data?.booking_intents
    } else {
      const { data } = await supabaseAdmin
        .from('payments')
        .select('*, booking_intents!inner(*)')
        .eq('booking_intent_id', intent_id)
        .in('status', ['pending', 'processing'])
        .order('created_at', { ascending: false })
        .limit(1)
        .single()
      payment = data
      intent = data?.booking_intents
    }

    if (!payment) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_002', message: 'Payment not found' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 404 }
      )
    }

    // Check gateway status for pending payments
    if (payment.status === 'pending' || payment.status === 'processing') {
      if (payment.gateway === 'stripe' && payment.gateway_payment_id) {
        // Check Stripe status (would need Stripe SDK)
        // For now, rely on webhooks
      } else if (payment.payment_method === 'pix' && payment.pix_expires_at) {
        // Check if PIX expired
        if (new Date(payment.pix_expires_at) < new Date()) {
          // Update payment status to expired
          await supabaseAdmin
            .from('payments')
            .update({ 
              status: 'expired',
              updated_at: new Date().toISOString()
            })
            .eq('id', payment.id)

          // Update intent status
          await supabaseAdmin
            .from('booking_intents')
            .update({ 
              status: 'expired',
              updated_at: new Date().toISOString()
            })
            .eq('id', payment.booking_intent_id)

          return new Response(
            JSON.stringify({
              success: true,
              data: {
                intent_id: payment.booking_intent_id,
                payment_id: payment.id,
                status: 'expired',
                payment_method: payment.payment_method,
                message: 'Payment expired'
              }
            }),
            { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
          )
        }
      }
    }

    // Return current status
    return new Response(
      JSON.stringify({
        success: true,
        data: {
          intent_id: payment.booking_intent_id,
          payment_id: payment.id,
          status: payment.status,
          payment_method: payment.payment_method,
          gateway: payment.gateway,
          amount: payment.amount,
          currency: payment.currency,
          paid_at: payment.succeeded_at,
          expires_at: payment.pix_expires_at,
          next_action: getNextAction(payment.status)
        }
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Error in poll_payment_status:', error)
    return new Response(
      JSON.stringify({ success: false, error: { code: 'RESERVE_010', message: 'Internal error', details: error.message } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})

function getNextAction(status: string): string | null {
  switch (status) {
    case 'pending':
      return 'awaiting_payment'
    case 'processing':
      return 'confirming_payment'
    case 'succeeded':
      return 'creating_reservation'
    case 'failed':
      return 'retry_payment'
    case 'expired':
      return 'create_new_intent'
    default:
      return null
  }
}
