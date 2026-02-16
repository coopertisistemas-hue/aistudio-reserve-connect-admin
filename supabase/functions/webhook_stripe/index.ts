import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import Stripe from 'https://esm.sh/stripe@12.0.0?target=deno'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, stripe-signature',
}

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') || '', {
  apiVersion: '2023-10-16',
  httpClient: Stripe.createFetchHttpClient(),
})

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  const signature = req.headers.get('stripe-signature')
  const body = await req.text()

  try {
    let event: Stripe.Event

    // Verify webhook signature if secret is configured
    const webhookSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET')
    if (webhookSecret && signature) {
      event = stripe.webhooks.constructEvent(body, signature, webhookSecret)
    } else {
      // For development/testing without signature verification
      event = JSON.parse(body)
    }

    console.log(`Processing Stripe webhook: ${event.type}`)

    switch (event.type) {
      case 'payment_intent.succeeded': {
        const paymentIntent = event.data.object as Stripe.PaymentIntent
        await handlePaymentSuccess(paymentIntent)
        break
      }

      case 'payment_intent.payment_failed': {
        const paymentIntent = event.data.object as Stripe.PaymentIntent
        await handlePaymentFailure(paymentIntent)
        break
      }

      case 'charge.refunded': {
        const charge = event.data.object as Stripe.Charge
        await handleRefund(charge)
        break
      }

      case 'charge.dispute.created': {
        const dispute = event.data.object as Stripe.Dispute
        await handleDispute(dispute)
        break
      }

      default:
        console.log(`Unhandled event type: ${event.type}`)
    }

    return new Response(JSON.stringify({ received: true }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200
    })

  } catch (error) {
    console.error('Error processing webhook:', error)
    return new Response(
      JSON.stringify({ error: 'Webhook processing failed', details: error.message }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
    )
  }
})

async function handlePaymentSuccess(paymentIntent: Stripe.PaymentIntent) {
  const { data: payment } = await supabaseAdmin
    .from('payments')
    .select('*, booking_intents!inner(*)')
    .eq('gateway_payment_id', paymentIntent.id)
    .single()

  if (!payment) {
    console.error(`Payment not found for PI: ${paymentIntent.id}`)
    return
  }

  // Update payment status
  await supabaseAdmin
    .from('payments')
    .update({
      status: 'succeeded',
      gateway_charge_id: paymentIntent.latest_charge as string,
      succeeded_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
      metadata: {
        ...payment.metadata,
        receipt_url: paymentIntent.charges?.data[0]?.receipt_url
      }
    })
    .eq('id', payment.id)

  // Update booking intent
  await supabaseAdmin
    .from('booking_intents')
    .update({
      status: 'payment_confirmed',
      updated_at: new Date().toISOString()
    })
    .eq('id', payment.booking_intent_id)

  // Create ledger entries
  await createLedgerEntries(payment)

  // Trigger reservation creation
  await triggerReservationCreation(payment)

  // Emit event
  await supabaseAdmin.from('events').insert({
    event_name: 'payment_succeeded',
    city_code: payment.city_code,
    session_id: payment.booking_intents?.session_id,
    metadata: {
      payment_id: payment.id,
      intent_id: payment.booking_intent_id,
      gateway: 'stripe',
      amount: payment.amount,
      processing_time_ms: Date.now() - new Date(payment.created_at).getTime()
    }
  })
}

async function handlePaymentFailure(paymentIntent: Stripe.PaymentIntent) {
  const { data: payment } = await supabaseAdmin
    .from('payments')
    .select('*')
    .eq('gateway_payment_id', paymentIntent.id)
    .single()

  if (!payment) return

  await supabaseAdmin
    .from('payments')
    .update({
      status: 'failed',
      failed_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
      metadata: {
        ...payment.metadata,
        failure_message: paymentIntent.last_payment_error?.message,
        failure_code: paymentIntent.last_payment_error?.code
      }
    })
    .eq('id', payment.id)

  // Release soft holds
  await releaseSoftHolds(payment.booking_intent_id)

  // Emit event
  await supabaseAdmin.from('events').insert({
    event_name: 'payment_failed',
    city_code: payment.city_code,
    metadata: {
      payment_id: payment.id,
      intent_id: payment.booking_intent_id,
      failure_code: paymentIntent.last_payment_error?.code
    }
  })
}

async function handleRefund(charge: Stripe.Charge) {
  // Find payment by charge ID
  const { data: payment } = await supabaseAdmin
    .from('payments')
    .select('*')
    .eq('gateway_charge_id', charge.id)
    .single()

  if (!payment) return

  const refundAmount = (charge.amount_refunded || 0) / 100 // Convert from cents

  await supabaseAdmin
    .from('payments')
    .update({
      status: refundAmount >= payment.amount ? 'refunded' : 'partially_refunded',
      refunded_amount: refundAmount,
      refunded_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    })
    .eq('id', payment.id)

  // Create reversal ledger entries
  await createRefundLedgerEntries(payment, refundAmount)

  console.log(`Processed refund for payment ${payment.id}: ${refundAmount}`)
}

async function handleDispute(dispute: Stripe.Dispute) {
  const { data: payment } = await supabaseAdmin
    .from('payments')
    .select('*')
    .eq('gateway_charge_id', dispute.charge)
    .single()

  if (!payment) return

  await supabaseAdmin
    .from('payments')
    .update({
      status: 'disputed',
      metadata: {
        ...payment.metadata,
        dispute_id: dispute.id,
        dispute_reason: dispute.reason,
        dispute_amount: dispute.amount / 100
      }
    })
    .eq('id', payment.id)

  console.log(`Dispute created for payment ${payment.id}: ${dispute.reason}`)
}

async function createLedgerEntries(payment: any) {
  const transactionId = crypto.randomUUID()

  // Entry 1: Payment received
  await supabaseAdmin.from('ledger_entries').insert([
    {
      transaction_id: transactionId,
      entry_type: 'payment_received',
      payment_id: payment.id,
      city_code: payment.city_code,
      account: 'cash_reserve',
      counterparty: 'customer',
      direction: 'debit',
      amount: payment.amount,
      description: 'Payment received from customer'
    },
    {
      transaction_id: transactionId,
      entry_type: 'payment_received',
      payment_id: payment.id,
      city_code: payment.city_code,
      account: 'customer_deposits',
      counterparty: 'customer',
      direction: 'credit',
      amount: payment.amount,
      description: 'Customer deposit liability'
    }
  ])

  // Entry 2: Gateway fee (if applicable)
  if (payment.gateway_fee > 0) {
    const feeTransactionId = crypto.randomUUID()
    await supabaseAdmin.from('ledger_entries').insert([
      {
        transaction_id: feeTransactionId,
        entry_type: 'gateway_fee',
        payment_id: payment.id,
        city_code: payment.city_code,
        account: 'gateway_fee_expense',
        counterparty: 'gateway',
        direction: 'debit',
        amount: payment.gateway_fee,
        description: 'Stripe processing fee'
      },
      {
        transaction_id: feeTransactionId,
        entry_type: 'gateway_fee',
        payment_id: payment.id,
        city_code: payment.city_code,
        account: 'gateway_fees_receivable',
        counterparty: 'gateway',
        direction: 'credit',
        amount: payment.gateway_fee,
        description: 'Fee payable to Stripe'
      }
    ])
  }
}

async function createRefundLedgerEntries(payment: any, refundAmount: number) {
  const transactionId = crypto.randomUUID()

  await supabaseAdmin.from('ledger_entries').insert([
    {
      transaction_id: transactionId,
      entry_type: 'refund_processed',
      payment_id: payment.id,
      city_code: payment.city_code,
      account: 'refunds_payable',
      counterparty: 'customer',
      direction: 'debit',
      amount: refundAmount,
      description: 'Refund to customer'
    },
    {
      transaction_id: transactionId,
      entry_type: 'refund_processed',
      payment_id: payment.id,
      city_code: payment.city_code,
      account: 'cash_reserve',
      counterparty: 'customer',
      direction: 'credit',
      amount: refundAmount,
      description: 'Refund processed'
    }
  ])
}

async function triggerReservationCreation(payment: any) {
  // Call the finalize_reservation_after_payment function
  await fetch(`${Deno.env.get('SUPABASE_URL')}/functions/v1/finalize_reservation_after_payment`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      payment_intent_id: payment.gateway_payment_id,
      gateway: 'stripe'
    })
  })
}

async function releaseSoftHolds(intentId: string) {
  // Get the intent to find unit and dates
  const { data: intent } = await supabaseAdmin
    .from('booking_intents')
    .select('unit_id, check_in, check_out')
    .eq('id', intentId)
    .single()

  if (!intent) return

  // Release soft holds
  const dates: string[] = []
  const start = new Date(intent.check_in)
  const end = new Date(intent.check_out)
  
  for (let d = new Date(start); d < end; d.setDate(d.getDate() + 1)) {
    dates.push(d.toISOString().split('T')[0])
  }

  for (const date of dates) {
    await supabaseAdmin.rpc('release_soft_hold', {
      p_unit_id: intent.unit_id,
      p_date: date
    })
  }
}
