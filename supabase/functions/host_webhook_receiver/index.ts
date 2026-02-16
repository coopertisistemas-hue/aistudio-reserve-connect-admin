import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { crypto } from 'https://deno.land/std@0.168.0/crypto/mod.ts'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-host-signature, x-host-timestamp',
}

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

function timingSafeEqual(a: string, b: string): boolean {
  if (a.length !== b.length) return false
  let result = 0
  for (let i = 0; i < a.length; i++) {
    result |= a.charCodeAt(i) ^ b.charCodeAt(i)
  }
  return result === 0
}

async function hmacSha256(secret: string, payload: string): Promise<string> {
  const key = await crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode(secret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign']
  )
  const signature = await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(payload))
  const bytes = new Uint8Array(signature)
  return Array.from(bytes).map((b) => b.toString(16).padStart(2, '0')).join('')
}

async function hashPayload(payload: string): Promise<string> {
  const buffer = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(payload))
  const bytes = new Uint8Array(buffer)
  return Array.from(bytes).map((b) => b.toString(16).padStart(2, '0')).join('')
}

function normalizeStatus(status: string | null | undefined, eventType: string): string | null {
  if (!status) {
    if (eventType.includes('cancel')) return 'cancelled'
    if (eventType.includes('confirm')) return 'confirmed'
    return null
  }

  const value = status.toLowerCase()
  if (['cancelled', 'canceled'].includes(value)) return 'cancelled'
  if (['confirmed', 'committed', 'booked'].includes(value)) return 'confirmed'
  if (['checked_in', 'checkin'].includes(value)) return 'checked_in'
  if (['checked_out', 'checkout', 'completed'].includes(value)) return 'checked_out'
  return null
}

function isTransitionAllowed(currentStatus: string, targetStatus: string): boolean {
  const transitions: Record<string, string[]> = {
    pending: ['confirmed', 'cancelled'],
    confirmed: ['checked_in', 'cancelled'],
    checked_in: ['checked_out'],
    checked_out: [],
    cancelled: [],
    no_show: [],
  }

  return (transitions[currentStatus] ?? []).includes(targetStatus)
}

async function insertAuditLog(
  reservationId: string,
  beforeData: Record<string, unknown>,
  afterData: Record<string, unknown>,
  metadata: Record<string, unknown>
) {
  await supabaseAdmin.from('audit_logs').insert({
    actor_type: 'system',
    actor_id: 'host_webhook',
    action: 'host_webhook',
    resource_type: 'reservation',
    resource_id: reservationId,
    before_data: beforeData,
    after_data: afterData,
    metadata,
    created_at: new Date().toISOString()
  })
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

  const rawBody = await req.text()
  let payload: any

  try {
    payload = JSON.parse(rawBody)
  } catch (error) {
    return new Response(
      JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Invalid JSON payload' } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
    )
  }

  const webhookSecret = Deno.env.get('HOST_CONNECT_WEBHOOK_SECRET')
  if (webhookSecret) {
    const signature = req.headers.get('x-host-signature')
    const timestamp = req.headers.get('x-host-timestamp')

    if (!signature || !timestamp) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_003', message: 'Missing webhook signature headers' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 401 }
      )
    }

    const expected = await hmacSha256(webhookSecret, `${timestamp}.${rawBody}`)
    if (!timingSafeEqual(signature, expected)) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_003', message: 'Invalid webhook signature' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 401 }
      )
    }
  }

  const eventId =
    payload?.event_id ||
    payload?.id ||
    payload?.data?.event_id ||
    payload?.data?.id ||
    await hashPayload(rawBody)

  const eventType = (payload?.event_type || payload?.type || payload?.event || 'unknown').toString()
  const eventStatus = normalizeStatus(payload?.status || payload?.data?.status, eventType)
  const hostBookingId = payload?.booking_id || payload?.data?.booking_id || payload?.data?.reservation_id || payload?.data?.host_booking_id
  const reservationId = payload?.reservation_id || payload?.data?.reservation_id

  const headers = Object.fromEntries(req.headers.entries())

  const { data: existingEvent } = await supabaseAdmin
    .from('host_webhook_events')
    .select('id, status')
    .eq('event_id', eventId)
    .maybeSingle()

  if (existingEvent) {
    return new Response(
      JSON.stringify({ success: true, data: { event_id: eventId, duplicate: true, status: existingEvent.status } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }

  const { data: webhookEvent, error: webhookInsertError } = await supabaseAdmin
    .from('host_webhook_events')
    .insert({
      event_id: eventId,
      event_type: eventType,
      payload,
      headers,
      status: 'processing',
      processed_at: null,
      attempt_count: 1,
      last_attempt_at: new Date().toISOString()
    })
    .select('id')
    .single()

  if (webhookInsertError) {
    return new Response(
      JSON.stringify({ success: false, error: { code: 'RESERVE_010', message: webhookInsertError.message } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }

  try {
    if (!eventStatus) {
      await supabaseAdmin
        .from('host_webhook_events')
        .update({
          status: 'ignored',
          error_message: 'Unknown status',
          processed_at: new Date().toISOString()
        })
        .eq('id', webhookEvent.id)

      return new Response(
        JSON.stringify({ success: true, data: { event_id: eventId, ignored: true } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    let reservationQuery = supabaseAdmin
      .from('reservations')
      .select('id, status, host_booking_id, property_id, metadata')

    if (reservationId) {
      reservationQuery = reservationQuery.eq('id', reservationId)
    } else if (hostBookingId) {
      reservationQuery = reservationQuery.eq('host_booking_id', hostBookingId)
    }

    const { data: reservation, error: reservationError } = await reservationQuery.maybeSingle()

    if (reservationError || !reservation) {
      await supabaseAdmin
        .from('host_webhook_events')
        .update({
          status: 'failed',
          error_message: 'Reservation not found',
          processed_at: new Date().toISOString()
        })
        .eq('id', webhookEvent.id)

      return new Response(
        JSON.stringify({ success: true, data: { event_id: eventId, missing_reservation: true } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const currentStatus = reservation.status
    if (currentStatus === eventStatus) {
      await supabaseAdmin
        .from('host_webhook_events')
        .update({ status: 'completed', processed_at: new Date().toISOString() })
        .eq('id', webhookEvent.id)

      return new Response(
        JSON.stringify({ success: true, data: { event_id: eventId, status: currentStatus, idempotent: true } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    if (!isTransitionAllowed(currentStatus, eventStatus)) {
      await supabaseAdmin
        .from('host_webhook_events')
        .update({
          status: 'ignored',
          error_message: `Invalid transition: ${currentStatus} -> ${eventStatus}`,
          processed_at: new Date().toISOString()
        })
        .eq('id', webhookEvent.id)

      return new Response(
        JSON.stringify({ success: true, data: { event_id: eventId, ignored: true, current_status: currentStatus } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const updatePayload: Record<string, unknown> = {
      status: eventStatus,
      updated_at: new Date().toISOString(),
      metadata: { ...reservation.metadata, host_event_id: eventId }
    }

    if (eventStatus === 'cancelled') {
      updatePayload.cancelled_at = new Date().toISOString()
      updatePayload.cancellation_reason = 'host_cancelled'
      updatePayload.cancelled_by = 'host'
    }

    if (eventStatus === 'checked_in') {
      updatePayload.checked_in_at = new Date().toISOString()
    }

    if (eventStatus === 'checked_out') {
      updatePayload.checked_out_at = new Date().toISOString()
    }

    if (!reservation.host_booking_id && hostBookingId) {
      updatePayload.host_booking_id = hostBookingId
    }

    const { error: reservationUpdateError } = await supabaseAdmin
      .from('reservations')
      .update(updatePayload)
      .eq('id', reservation.id)

    if (reservationUpdateError) {
      throw new Error(reservationUpdateError.message)
    }

    await insertAuditLog(
      reservation.id,
      { status: currentStatus },
      { status: eventStatus },
      { event_id: eventId, event_type: eventType }
    )

    if (eventStatus === 'cancelled') {
      await supabaseAdmin
        .from('cancellation_requests')
        .upsert({
          reservation_id: reservation.id,
          idempotency_key: `host_cancel:${eventId}`,
          status: 'completed',
          refund_status: 'pending',
          metadata: { source: 'host_webhook', event_id: eventId }
        }, { onConflict: 'idempotency_key' })
    }

    await supabaseAdmin
      .from('host_webhook_events')
      .update({ status: 'completed', processed_at: new Date().toISOString() })
      .eq('id', webhookEvent.id)

    return new Response(
      JSON.stringify({ success: true, data: { event_id: eventId, status: eventStatus } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    await supabaseAdmin
      .from('host_webhook_events')
      .update({ status: 'failed', error_message: error.message, processed_at: new Date().toISOString() })
      .eq('id', webhookEvent.id)

    return new Response(
      JSON.stringify({ success: false, error: { code: 'RESERVE_010', message: error.message } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})
