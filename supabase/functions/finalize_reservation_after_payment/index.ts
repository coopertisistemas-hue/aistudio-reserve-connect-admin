import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-idempotency-key',
}

type LedgerEntry = {
  transaction_id: string
  entry_type: string
  booking_id: string
  property_id: string
  city_code: string
  payment_id: string
  account: string
  counterparty: string
  direction: string
  amount: number
  description: string
}

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

function roundCurrency(value: number): number {
  return Math.round(value * 100) / 100
}

async function fetchCommissionRate(cityCode: string, propertyId: string): Promise<number> {
  const { data: propertyTier } = await supabaseAdmin
    .from('commission_tiers')
    .select('commission_rate')
    .eq('property_id', propertyId)
    .eq('is_active', true)
    .order('created_at', { ascending: false })
    .limit(1)
    .maybeSingle()

  if (propertyTier?.commission_rate) {
    return Number(propertyTier.commission_rate)
  }

  const { data: cityTier } = await supabaseAdmin
    .from('commission_tiers')
    .select('commission_rate')
    .eq('city_code', cityCode)
    .is('property_id', null)
    .eq('is_active', true)
    .order('min_properties', { ascending: true })
    .limit(1)
    .maybeSingle()

  if (cityTier?.commission_rate) {
    return Number(cityTier.commission_rate)
  }

  return 0.15
}

async function ensureLedgerEntries(
  paymentId: string,
  reservationId: string,
  propertyId: string,
  cityCode: string,
  commissionAmount: number,
  payoutAmount: number
): Promise<void> {
  const { data: existingEntries } = await supabaseAdmin
    .from('ledger_entries')
    .select('entry_type')
    .eq('payment_id', paymentId)
    .in('entry_type', ['commission_taken', 'payout_due'])

  const existingTypes = new Set((existingEntries ?? []).map((entry) => entry.entry_type))

  const entries: LedgerEntry[] = []

  if (!existingTypes.has('commission_taken') && commissionAmount > 0) {
    const transactionId = crypto.randomUUID()
    entries.push(
      {
        transaction_id: transactionId,
        entry_type: 'commission_taken',
        booking_id: reservationId,
        property_id: propertyId,
        city_code: cityCode,
        payment_id: paymentId,
        account: 'customer_deposits',
        counterparty: 'customer',
        direction: 'debit',
        amount: commissionAmount,
        description: 'Commission deducted from customer deposit'
      },
      {
        transaction_id: transactionId,
        entry_type: 'commission_taken',
        booking_id: reservationId,
        property_id: propertyId,
        city_code: cityCode,
        payment_id: paymentId,
        account: 'commissions_payable',
        counterparty: 'owner',
        direction: 'credit',
        amount: commissionAmount,
        description: 'Commission payable to Reserve Connect'
      }
    )
  }

  if (!existingTypes.has('payout_due') && payoutAmount > 0) {
    const transactionId = crypto.randomUUID()
    entries.push(
      {
        transaction_id: transactionId,
        entry_type: 'payout_due',
        booking_id: reservationId,
        property_id: propertyId,
        city_code: cityCode,
        payment_id: paymentId,
        account: 'customer_deposits',
        counterparty: 'customer',
        direction: 'debit',
        amount: payoutAmount,
        description: 'Owner share (gross minus commission)'
      },
      {
        transaction_id: transactionId,
        entry_type: 'payout_due',
        booking_id: reservationId,
        property_id: propertyId,
        city_code: cityCode,
        payment_id: paymentId,
        account: 'payouts_receivable',
        counterparty: 'owner',
        direction: 'credit',
        amount: payoutAmount,
        description: 'Amount due to property owner'
      }
    )
  }

  if (entries.length > 0) {
    const { error } = await supabaseAdmin.from('ledger_entries').insert(entries)
    if (error) {
      throw new Error(`Ledger insert failed: ${error.message}`)
    }
  }
}

async function insertAuditLog(reservationId: string, cityCode: string, action: string, newData: Record<string, unknown>) {
  await supabaseAdmin.from('audit_logs').insert({
    table_name: 'reservations',
    record_id: reservationId,
    action,
    new_data: newData,
    actor_type: 'system',
    city_code: cityCode,
    reservation_id: reservationId
  })
}

async function triggerHostCommit(reservationId: string, idempotencyKey?: string) {
  const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
  const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''

  const response = await fetch(`${supabaseUrl}/functions/v1/host_commit_booking`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${serviceRoleKey}`,
      apikey: serviceRoleKey,
      'X-Idempotency-Key': idempotencyKey || `reservation-${reservationId}`,
    },
    body: JSON.stringify({ reservation_id: reservationId })
  })

  const payload = await response.json()
  if (!response.ok || !payload?.success) {
    const errorMessage = payload?.error?.message || 'Host commit failed'
    throw new Error(errorMessage)
  }

  return payload.data
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

  try {
    const { payment_id, gateway_payment_id, trigger_source, auto_host_commit } = await req.json()

    if (!payment_id && !gateway_payment_id) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Payment identifier is required' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    let paymentQuery = supabaseAdmin.from('payments').select('*, booking_intents(*)')
    if (payment_id) {
      paymentQuery = paymentQuery.eq('id', payment_id)
    } else {
      paymentQuery = paymentQuery.eq('gateway_payment_id', gateway_payment_id)
    }

    const { data: payment, error: paymentError } = await paymentQuery.single()
    if (paymentError || !payment) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_002', message: 'Payment not found' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 404 }
      )
    }

    if (payment.status !== 'succeeded') {
      return new Response(
        JSON.stringify({
          success: false,
          error: { code: 'RESERVE_004', message: `Payment not succeeded (status: ${payment.status})` }
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 409 }
      )
    }

    const { data: finalizeResult, error: finalizeError } = await supabaseAdmin
      .rpc('finalize_reservation', {
        p_payment_id: payment.id,
        p_webhook_id: null
      })

    if (finalizeError) {
      throw new Error(`Finalize reservation failed: ${finalizeError.message}`)
    }

    const reservationId = finalizeResult?.[0]?.reservation_id
    if (!reservationId) {
      throw new Error('Reservation creation did not return an id')
    }

    const { data: reservation, error: reservationError } = await supabaseAdmin
      .from('reservations')
      .select('id, status, property_id, city_code, total_amount, commission_rate, commission_amount')
      .eq('id', reservationId)
      .single()

    if (reservationError || !reservation) {
      throw new Error('Reservation not found after finalization')
    }

    const totalAmount = Number(reservation.total_amount)
    const commissionRate = await fetchCommissionRate(reservation.city_code, reservation.property_id)
    const commissionAmount = roundCurrency(totalAmount * commissionRate)
    const payoutAmount = roundCurrency(Math.max(totalAmount - commissionAmount, 0))

    const { error: reservationUpdateError } = await supabaseAdmin
      .from('reservations')
      .update({
        commission_rate: commissionRate,
        commission_amount: commissionAmount,
        updated_at: new Date().toISOString()
      })
      .eq('id', reservationId)

    if (reservationUpdateError) {
      throw new Error(`Reservation update failed: ${reservationUpdateError.message}`)
    }

    await ensureLedgerEntries(
      payment.id,
      reservationId,
      reservation.property_id,
      reservation.city_code,
      commissionAmount,
      payoutAmount
    )

    await insertAuditLog(reservationId, reservation.city_code, 'UPDATE', {
      status: reservation.status,
      commission_rate: commissionRate,
      commission_amount: commissionAmount
    })

    await supabaseAdmin.from('events').insert({
      event_name: 'reservation_finalized',
      city_code: reservation.city_code,
      property_id: reservation.property_id,
      metadata: {
        reservation_id: reservationId,
        payment_id: payment.id,
        commission_rate: commissionRate,
        commission_amount: commissionAmount,
        payout_amount: payoutAmount,
        trigger_source: trigger_source || 'system'
      }
    })

    const autoHostCommit =
      typeof auto_host_commit === 'boolean'
        ? auto_host_commit
        : (Deno.env.get('AUTO_HOST_COMMIT') ?? 'true') === 'true'
    let hostCommitResult: Record<string, unknown> | null = null

    if (autoHostCommit && reservation.status === 'host_commit_pending') {
      hostCommitResult = await triggerHostCommit(reservationId, req.headers.get('x-idempotency-key') || undefined)
    }

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          reservation_id: reservationId,
          commission_rate: commissionRate,
          commission_amount: commissionAmount,
          payout_amount: payoutAmount,
          host_commit: hostCommitResult
        }
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Error in finalize_reservation_after_payment:', error)
    return new Response(
      JSON.stringify({
        success: false,
        error: { code: 'RESERVE_010', message: 'Internal error', details: error.message }
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})
