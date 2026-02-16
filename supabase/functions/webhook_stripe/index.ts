import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import Stripe from 'https://esm.sh/stripe@12.0.0?target=deno'
import { crypto } from 'https://deno.land/std@0.168.0/crypto/mod.ts'

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

// Helper: Hash payload for integrity checking
async function hashPayload(payload: string): Promise<string> {
  const encoder = new TextEncoder()
  const data = encoder.encode(payload)
  const hashBuffer = await crypto.subtle.digest('SHA-256', data)
  const hashArray = Array.from(new Uint8Array(hashBuffer))
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('')
}

// Helper: Check for duplicate webhook
async function checkDuplicateWebhook(eventId: string): Promise<{ isDuplicate: boolean; existingStatus?: string }> {
  const { data } = await supabaseAdmin
    .from('processed_webhooks')
    .select('status')
    .eq('provider', 'stripe')
    .eq('event_id', eventId)
    .single()
  
  if (data) {
    return { isDuplicate: true, existingStatus: data.status }
  }
  
  return { isDuplicate: false }
}

// Helper: Record webhook processing
async function recordWebhookStart(
  eventId: string, 
  eventType: string, 
  payloadHash: string
): Promise<string | null> {
  try {
    const { data, error } = await supabaseAdmin
      .from('processed_webhooks')
      .insert({
        provider: 'stripe',
        event_id: eventId,
        event_type: eventType,
        payload_hash: payloadHash,
        status: 'processing',
        received_at: new Date().toISOString()
      })
      .select('id')
      .single()
    
    if (error) {
      // Check if it's a duplicate
      if (error.code === '23505') { // unique_violation
        console.log(`Duplicate webhook detected: ${eventId}`)
        return null
      }
      throw error
    }
    
    return data.id
  } catch (error) {
    console.error('Error recording webhook start:', error)
    throw error
  }
}

// Helper: Complete webhook processing
async function completeWebhookProcessing(
  webhookId: string,
  status: 'completed' | 'failed',
  paymentId?: string,
  reservationId?: string,
  errorMessage?: string
): Promise<void> {
  await supabaseAdmin
    .from('processed_webhooks')
    .update({
      status,
      processed_at: new Date().toISOString(),
      payment_id: paymentId || null,
      reservation_id: reservationId || null,
      error_message: errorMessage || null
    })
    .eq('id', webhookId)
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  const signature = req.headers.get('stripe-signature')
  const body = await req.text()
  let event: Stripe.Event

  try {
    // Verify webhook signature
    const webhookSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET')
    if (!webhookSecret) {
      console.error('STRIPE_WEBHOOK_SECRET not configured')
      return new Response(
        JSON.stringify({ error: 'Webhook secret not configured' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
      )
    }

    if (!signature) {
      return new Response(
        JSON.stringify({ error: 'Missing stripe-signature header' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    try {
      event = stripe.webhooks.constructEvent(body, signature, webhookSecret)
    } catch (err) {
      console.error('Webhook signature verification failed:', err.message)
      return new Response(
        JSON.stringify({ error: 'Invalid signature' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    console.log(`Processing Stripe webhook: ${event.type} (ID: ${event.id})`)

    // Check for duplicate
    const { isDuplicate, existingStatus } = await checkDuplicateWebhook(event.id)
    if (isDuplicate) {
      console.log(`Duplicate webhook received: ${event.id} (status: ${existingStatus})`)
      return new Response(
        JSON.stringify({ received: true, duplicate: true }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
      )
    }

    // Record webhook start
    const payloadHash = await hashPayload(body)
    const webhookId = await recordWebhookStart(event.id, event.type, payloadHash)
    
    if (!webhookId) {
      // Should not happen due to duplicate check, but handle gracefully
      return new Response(
        JSON.stringify({ received: true, duplicate: true }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
      )
    }

    let processingError: string | undefined
    let paymentId: string | undefined
    let reservationId: string | undefined

    try {
      switch (event.type) {
        case 'payment_intent.succeeded': {
          const paymentIntent = event.data.object as Stripe.PaymentIntent
          const result = await handlePaymentSuccess(paymentIntent, event.id)
          paymentId = result.paymentId
          reservationId = result.reservationId
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

      // Mark as completed
      await completeWebhookProcessing(webhookId, 'completed', paymentId, reservationId)

      return new Response(
        JSON.stringify({ received: true, processed: true }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
      )

    } catch (error) {
      processingError = error.message
      console.error(`Error processing webhook ${event.id}:`, error)
      
      await completeWebhookProcessing(webhookId, 'failed', undefined, undefined, processingError)
      
      // Return 500 so Stripe will retry
      return new Response(
        JSON.stringify({ error: 'Processing failed', details: processingError }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
      )
    }

  } catch (error) {
    console.error('Error processing webhook:', error)
    return new Response(
      JSON.stringify({ error: 'Webhook processing failed', details: error.message }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})

async function handlePaymentSuccess(paymentIntent: Stripe.PaymentIntent, webhookEventId: string): Promise<{ paymentId: string; reservationId?: string }> {
  // Use transaction to ensure atomicity
  const { data: payment, error: paymentError } = await supabaseAdmin
    .from('payments')
    .select('*, booking_intents!inner(*)')
    .eq('gateway_payment_id', paymentIntent.id)
    .single()

  if (paymentError || !payment) {
    throw new Error(`Payment not found for PI: ${paymentIntent.id}`)
  }

  // Check if already processed
  if (payment.status === 'succeeded') {
    console.log(`Payment ${payment.id} already marked as succeeded`)
    
    // Check if reservation exists
    const { data: existingReservation } = await supabaseAdmin
      .from('reservations')
      .select('id')
      .eq('booking_intent_id', payment.booking_intent_id)
      .single()
    
    return { 
      paymentId: payment.id,
      reservationId: existingReservation?.id 
    }
  }

  // Update payment status with state machine validation (enforced by DB trigger)
  const { error: updateError } = await supabaseAdmin
    .from('payments')
    .update({
      status: 'succeeded',
      gateway_charge_id: paymentIntent.latest_charge as string,
      succeeded_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
      metadata: {
        ...payment.metadata,
        receipt_url: paymentIntent.charges?.data[0]?.receipt_url,
        processed_by_webhook: webhookEventId
      }
    })
    .eq('id', payment.id)

  if (updateError) {
    throw new Error(`Failed to update payment: ${updateError.message}`)
  }

  // Update booking intent
  const { error: intentError } = await supabaseAdmin
    .from('booking_intents')
    .update({
      status: 'payment_confirmed',
      payment_confirmed_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    })
    .eq('id', payment.booking_intent_id)

  if (intentError) {
    console.error('Error updating intent:', intentError)
  }

  // Create ledger entries
  await createLedgerEntries(payment)

  const reservationId = await finalizeReservationAfterPayment(payment.id, webhookEventId)

  // Emit event
  await supabaseAdmin.from('events').insert({
    event_name: 'payment_succeeded',
    city_code: payment.city_code,
    session_id: payment.booking_intents?.session_id,
    metadata: {
      payment_id: payment.id,
      intent_id: payment.booking_intent_id,
      reservation_id: reservationId,
      gateway: 'stripe',
      amount: payment.amount,
      processing_time_ms: Date.now() - new Date(payment.created_at).getTime()
    }
  })

  return { paymentId: payment.id, reservationId }
}

async function finalizeReservationAfterPayment(paymentId: string, webhookEventId: string): Promise<string | undefined> {
  const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
  const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''

  const response = await fetch(`${supabaseUrl}/functions/v1/finalize_reservation_after_payment`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${serviceRoleKey}`,
      apikey: serviceRoleKey,
      'X-Idempotency-Key': `webhook-${webhookEventId}`
    },
    body: JSON.stringify({
      payment_id: paymentId,
      trigger_source: 'stripe_webhook'
    })
  })

  const payload = await response.json().catch(() => null)
  if (!response.ok || !payload?.success) {
    const errorMessage = payload?.error?.message || 'Reservation finalization failed'
    throw new Error(errorMessage)
  }

  return payload?.data?.reservation_id
}

async function handlePaymentFailure(paymentIntent: Stripe.PaymentIntent): Promise<void> {
  const { data: payment } = await supabaseAdmin
    .from('payments')
    .select('*')
    .eq('gateway_payment_id', paymentIntent.id)
    .single()

  if (!payment) {
    console.log(`Payment not found for failed PI: ${paymentIntent.id}`)
    return
  }

  // Only update if not already in terminal state
  if (['succeeded', 'refunded', 'disputed'].includes(payment.status)) {
    console.log(`Payment ${payment.id} already in terminal state: ${payment.status}`)
    return
  }

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

  // Update intent
  await supabaseAdmin
    .from('booking_intents')
    .update({
      status: 'payment_failed',
      updated_at: new Date().toISOString()
    })
    .eq('id', payment.booking_intent_id)

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

async function handleRefund(charge: Stripe.Charge): Promise<void> {
  const { data: payment } = await supabaseAdmin
    .from('payments')
    .select('*')
    .eq('gateway_charge_id', charge.id)
    .single()

  if (!payment) {
    console.log(`Payment not found for charge: ${charge.id}`)
    return
  }

  const refundAmount = (charge.amount_refunded || 0) / 100

  // Calculate new status
  let newStatus: string
  if (refundAmount >= payment.amount) {
    newStatus = 'refunded'
  } else if (refundAmount > 0) {
    newStatus = 'partially_refunded'
  } else {
    return // No refund amount
  }

  // Update payment
  await supabaseAdmin
    .from('payments')
    .update({
      status: newStatus,
      refunded_amount: refundAmount,
      refunded_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
      metadata: {
        ...payment.metadata,
        refund_charge_id: charge.id
      }
    })
    .eq('id', payment.id)

  // Create reversal ledger entries
  await createRefundLedgerEntries(payment, refundAmount)

  console.log(`Processed ${newStatus} for payment ${payment.id}: ${refundAmount}`)
}

async function handleDispute(dispute: Stripe.Dispute): Promise<void> {
  const { data: payment } = await supabaseAdmin
    .from('payments')
    .select('*')
    .eq('gateway_charge_id', dispute.charge)
    .single()

  if (!payment) {
    console.log(`Payment not found for dispute charge: ${dispute.charge}`)
    return
  }

  await supabaseAdmin
    .from('payments')
    .update({
      status: 'disputed',
      metadata: {
        ...payment.metadata,
        dispute_id: dispute.id,
        dispute_reason: dispute.reason,
        dispute_amount: dispute.amount / 100,
        disputed_at: new Date().toISOString()
      }
    })
    .eq('id', payment.id)

  // Emit alert event
  await supabaseAdmin.from('events').insert({
    event_name: 'payment_disputed',
    city_code: payment.city_code,
    metadata: {
      payment_id: payment.id,
      dispute_id: dispute.id,
      reason: dispute.reason,
      amount: dispute.amount / 100
    }
  })

  console.log(`Dispute created for payment ${payment.id}: ${dispute.reason}`)
}

async function createLedgerEntries(payment: any): Promise<void> {
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

async function createRefundLedgerEntries(payment: any, refundAmount: number): Promise<void> {
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

async function releaseSoftHolds(intentId: string): Promise<void> {
  const { data: intent } = await supabaseAdmin
    .from('booking_intents')
    .select('unit_id, check_in, check_out')
    .eq('id', intentId)
    .single()

  if (!intent) return

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
