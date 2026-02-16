import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import Stripe from 'https://esm.sh/stripe@12.0.0?target=deno'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-idempotency-key',
}

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') || '', {
  apiVersion: '2023-10-16',
  httpClient: Stripe.createFetchHttpClient(),
})

type CancellationResponse = {
  reservation_id: string
  status: string
  refund_status: string
  refund_amount: number
  payment_id?: string | null
  payment_gateway?: string | null
  idempotent: boolean
}

function roundCurrency(value: number): number {
  return Math.round(value * 100) / 100
}

async function fetchCityCode(propertyId: string): Promise<string | null> {
  const { data: property } = await supabaseAdmin
    .from('properties_map')
    .select('city_id')
    .eq('id', propertyId)
    .single()

  if (!property?.city_id) {
    return null
  }

  const { data: city } = await supabaseAdmin
    .from('cities')
    .select('code')
    .eq('id', property.city_id)
    .single()

  return city?.code ?? null
}

async function insertAuditLog(
  reservationId: string,
  actorType: string,
  actorId: string | null,
  beforeData: Record<string, unknown>,
  afterData: Record<string, unknown>,
  metadata: Record<string, unknown>
) {
  await supabaseAdmin.from('audit_logs').insert({
    actor_type: actorType,
    actor_id: actorId,
    action: 'cancel',
    resource_type: 'reservation',
    resource_id: reservationId,
    before_data: beforeData,
    after_data: afterData,
    metadata,
    created_at: new Date().toISOString()
  })
}

async function upsertCancellationRequest(params: {
  reservation_id: string
  idempotency_key: string
  request_id?: string | null
  status: string
  refund_status?: string
  refund_amount?: number
  payment_id?: string | null
  refund_provider?: string | null
  response_payload?: Record<string, unknown>
  error_message?: string | null
  metadata?: Record<string, unknown>
}) {
  const { data, error } = await supabaseAdmin
    .from('cancellation_requests')
    .upsert({
      reservation_id: params.reservation_id,
      idempotency_key: params.idempotency_key,
      request_id: params.request_id ?? null,
      status: params.status,
      refund_status: params.refund_status ?? null,
      refund_amount: params.refund_amount ?? null,
      payment_id: params.payment_id ?? null,
      refund_provider: params.refund_provider ?? null,
      response_payload: params.response_payload ?? {},
      error_message: params.error_message ?? null,
      metadata: params.metadata ?? {},
      updated_at: new Date().toISOString()
    }, { onConflict: 'idempotency_key' })
    .select()
    .single()

  if (error) {
    throw error
  }

  return data
}

async function fetchExistingCancellation(idempotencyKey: string) {
  const { data } = await supabaseAdmin
    .from('cancellation_requests')
    .select('*')
    .eq('idempotency_key', idempotencyKey)
    .maybeSingle()

  return data
}

async function reverseLedgerEntries(paymentId: string, reservationId: string): Promise<void> {
  const { data: existingReversals } = await supabaseAdmin
    .from('ledger_entries')
    .select('id')
    .eq('payment_id', paymentId)
    .eq('entry_type', 'refund_reversed')
    .limit(1)

  if (existingReversals && existingReversals.length > 0) {
    return
  }

  const { data: ledgerEntries } = await supabaseAdmin
    .from('ledger_entries')
    .select('*')
    .eq('payment_id', paymentId)
    .in('entry_type', ['commission_taken', 'payout_due'])

  if (!ledgerEntries || ledgerEntries.length === 0) {
    return
  }

  const entriesByTransaction = new Map<string, typeof ledgerEntries>()
  for (const entry of ledgerEntries) {
    const txId = entry.transaction_id as string
    const existing = entriesByTransaction.get(txId) ?? []
    existing.push(entry)
    entriesByTransaction.set(txId, existing)
  }

  const reversalEntries = []
  for (const [, entries] of entriesByTransaction) {
    const reversalTransactionId = crypto.randomUUID()
    for (const entry of entries) {
      reversalEntries.push({
        transaction_id: reversalTransactionId,
        entry_type: 'refund_reversed',
        booking_id: reservationId,
        property_id: entry.property_id,
        city_code: entry.city_code,
        payment_id: paymentId,
        account: entry.account,
        counterparty: entry.counterparty,
        direction: entry.direction === 'debit' ? 'credit' : 'debit',
        amount: entry.amount,
        description: 'Reversal due to reservation cancellation'
      })
    }
  }

  if (reversalEntries.length > 0) {
    const { error } = await supabaseAdmin.from('ledger_entries').insert(reversalEntries)
    if (error) {
      throw new Error(`Ledger reversal failed: ${error.message}`)
    }
  }
}

async function createRefundLedgerEntries(paymentId: string, refundAmount: number, cityCode: string, reservationId: string) {
  const { data: existingRefunds } = await supabaseAdmin
    .from('ledger_entries')
    .select('id')
    .eq('payment_id', paymentId)
    .eq('entry_type', 'refund_processed')
    .limit(1)

  if (existingRefunds && existingRefunds.length > 0) {
    return
  }

  const transactionId = crypto.randomUUID()

  const { error } = await supabaseAdmin.from('ledger_entries').insert([
    {
      transaction_id: transactionId,
      entry_type: 'refund_processed',
      booking_id: reservationId,
      city_code: cityCode,
      payment_id: paymentId,
      account: 'refunds_payable',
      counterparty: 'customer',
      direction: 'debit',
      amount: refundAmount,
      description: 'Refund to customer'
    },
    {
      transaction_id: transactionId,
      entry_type: 'refund_processed',
      booking_id: reservationId,
      city_code: cityCode,
      payment_id: paymentId,
      account: 'cash_reserve',
      counterparty: 'customer',
      direction: 'credit',
      amount: refundAmount,
      description: 'Refund processed'
    }
  ])

  if (error) {
    throw new Error(`Refund ledger insert failed: ${error.message}`)
  }
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  if (req.method !== 'POST') {
    return new Response(
      JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Method not allowed' } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 405 }
    )
  }

  const startedAt = Date.now()
  let cancellationKey: string | null = null
  let cancellationReservationId: string | null = null

  try {
    const body = await req.json()
    const reservationId = body?.reservation_id as string | undefined
    const cancellationReason = body?.cancellation_reason as string | undefined
    const cancellationRequestId = body?.cancellation_request_id as string | undefined
    const actorType = (body?.actor_type as string | undefined) ?? 'system'
    const actorId = (body?.actor_id as string | undefined) ?? null
    const refundOverride = body?.refund_amount as number | undefined

    if (!reservationId) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Reservation ID is required' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    const idempotencyKey =
      req.headers.get('x-idempotency-key') || cancellationRequestId || `cancel:${reservationId}`

    cancellationKey = idempotencyKey
    cancellationReservationId = reservationId

    const existingCancellation = await fetchExistingCancellation(idempotencyKey)
    if (existingCancellation?.status === 'completed') {
      return new Response(
        JSON.stringify({ success: true, data: existingCancellation.response_payload }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    if (existingCancellation?.status === 'processing') {
      return new Response(
        JSON.stringify({ success: true, data: existingCancellation.response_payload, processing: true }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 202 }
      )
    }

    await upsertCancellationRequest({
      reservation_id: reservationId,
      idempotency_key: idempotencyKey,
      request_id: cancellationRequestId,
      status: 'processing',
      refund_status: 'pending',
      metadata: {
        cancellation_reason: cancellationReason ?? null,
        actor_type: actorType,
        actor_id: actorId
      }
    })

    const { data: reservation, error: reservationError } = await supabaseAdmin
      .from('reservations')
      .select('id, status, property_id, unit_id, rate_plan_id, check_in, check_out, total_amount, amount_paid, payment_status, cancelled_at, metadata')
      .eq('id', reservationId)
      .single()

    if (reservationError || !reservation) {
      throw new Error('Reservation not found')
    }

    if (reservation.status === 'cancelled') {
      const responsePayload: CancellationResponse = {
        reservation_id: reservationId,
        status: 'cancelled',
        refund_status: 'completed',
        refund_amount: 0,
        idempotent: true
      }

      await upsertCancellationRequest({
        reservation_id: reservationId,
        idempotency_key: idempotencyKey,
        request_id: cancellationRequestId,
        status: 'completed',
        refund_status: 'completed',
        refund_amount: 0,
        response_payload: responsePayload
      })

      return new Response(
        JSON.stringify({ success: true, data: responsePayload }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const cancellableStatuses = ['pending', 'confirmed']
    if (!cancellableStatuses.includes(reservation.status)) {
      throw new Error(`Reservation status does not allow cancellation: ${reservation.status}`)
    }

    const cityCode = await fetchCityCode(reservation.property_id)

    const { data: payment } = await supabaseAdmin
      .from('payments')
      .select('*')
      .eq('reservation_id', reservationId)
      .order('created_at', { ascending: false })
      .limit(1)
      .maybeSingle()

    let refundStatus = 'not_required'
    let refundAmount = 0
    let paymentId: string | null = null
    let refundProvider: string | null = null
    let refundExecuted = false

    if (payment) {
      paymentId = payment.id
      refundProvider = payment.gateway
      const paymentAmount = Number(payment.amount)
      const requestedRefund = typeof refundOverride === 'number' ? refundOverride : paymentAmount
      refundAmount = roundCurrency(Math.min(Math.max(requestedRefund, 0), paymentAmount))

      if (['refunded', 'partially_refunded'].includes(payment.status)) {
        refundStatus = 'completed'
        refundExecuted = true
      } else if (payment.gateway === 'stripe' && payment.payment_method === 'stripe_card') {
        const refundParams: Stripe.RefundCreateParams = {
          amount: Math.round(refundAmount * 100),
          reason: 'requested_by_customer',
          metadata: {
            reservation_id: reservationId,
            cancellation_request_id: cancellationRequestId ?? idempotencyKey
          }
        }

        if (payment.gateway_charge_id) {
          refundParams.charge = payment.gateway_charge_id
        } else {
          refundParams.payment_intent = payment.gateway_payment_id
        }

        const refund = await stripe.refunds.create(refundParams, {
          idempotencyKey: `refund:${idempotencyKey}`
        })

        const newStatus = refundAmount >= paymentAmount ? 'refunded' : 'partially_refunded'
        const { error: paymentUpdateError } = await supabaseAdmin
          .from('payments')
          .update({
            status: newStatus,
            refunded_amount: refundAmount,
            refunded_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
            metadata: {
              ...payment.metadata,
              refund_id: refund.id,
              refund_status: refund.status
            }
          })
          .eq('id', payment.id)

        if (paymentUpdateError) {
          throw new Error(`Failed to update payment refund status: ${paymentUpdateError.message}`)
        }

        refundStatus = 'completed'
        refundExecuted = true
      } else if (payment.payment_method === 'pix') {
        refundStatus = 'pending'
        const { error: paymentUpdateError } = await supabaseAdmin
          .from('payments')
          .update({
            status: 'refund_pending',
            updated_at: new Date().toISOString(),
            metadata: {
              ...payment.metadata,
              refund_status: 'pending'
            }
          })
          .eq('id', payment.id)

        if (paymentUpdateError) {
          await supabaseAdmin
            .from('payments')
            .update({
              updated_at: new Date().toISOString(),
              metadata: {
                ...payment.metadata,
                refund_status: 'pending',
                refund_status_error: paymentUpdateError.message
              }
            })
            .eq('id', payment.id)
        }
      }
    }

    const beforeData = {
      status: reservation.status,
      payment_status: reservation.payment_status
    }

    const newPaymentStatus = refundStatus === 'completed' ? 'refunded' : reservation.payment_status
    const { error: reservationUpdateError } = await supabaseAdmin
      .from('reservations')
      .update({
        status: 'cancelled',
        cancellation_reason: cancellationReason ?? 'cancelled_by_request',
        cancelled_by: actorType,
        cancelled_at: new Date().toISOString(),
        payment_status: newPaymentStatus,
        updated_at: new Date().toISOString(),
        metadata: {
          ...reservation.metadata,
          cancellation_request_id: cancellationRequestId ?? idempotencyKey,
          refund_status: refundStatus
        }
      })
      .eq('id', reservationId)

    if (reservationUpdateError) {
      throw new Error(`Failed to update reservation: ${reservationUpdateError.message}`)
    }

    if (paymentId) {
      await reverseLedgerEntries(paymentId, reservationId)
      if (refundExecuted && cityCode) {
        await createRefundLedgerEntries(paymentId, refundAmount, cityCode, reservationId)
      }
    }

    await supabaseAdmin.rpc('release_reservation_inventory', { p_reservation_id: reservationId })

    const afterData = {
      status: 'cancelled',
      payment_status: newPaymentStatus,
      refund_status: refundStatus,
      refund_amount: refundAmount
    }

    await insertAuditLog(reservationId, actorType, actorId, beforeData, afterData, {
      cancellation_reason: cancellationReason ?? null,
      cancellation_request_id: cancellationRequestId ?? idempotencyKey,
      refund_status: refundStatus
    })

    const responsePayload: CancellationResponse = {
      reservation_id: reservationId,
      status: 'cancelled',
      refund_status: refundStatus,
      refund_amount: refundAmount,
      payment_id: paymentId,
      payment_gateway: refundProvider,
      idempotent: false
    }

    await upsertCancellationRequest({
      reservation_id: reservationId,
      idempotency_key: idempotencyKey,
      request_id: cancellationRequestId,
      status: 'completed',
      refund_status: refundStatus,
      refund_amount: refundAmount,
      payment_id: paymentId,
      refund_provider: refundProvider,
      response_payload: responsePayload
    })

    return new Response(
      JSON.stringify({ success: true, data: responsePayload, duration_ms: Date.now() - startedAt }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    if (cancellationReservationId && cancellationKey) {
      await upsertCancellationRequest({
        reservation_id: cancellationReservationId,
        idempotency_key: cancellationKey,
        status: 'failed',
        refund_status: 'failed',
        error_message: error.message
      })
    }

    console.error('Error in cancel_reservation:', error)
    return new Response(
      JSON.stringify({ success: false, error: { code: 'RESERVE_010', message: error.message } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})
