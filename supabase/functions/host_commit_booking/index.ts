import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-idempotency-key',
}

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

async function insertAuditLog(
  reservationId: string,
  cityCode: string,
  oldData: Record<string, unknown>,
  newData: Record<string, unknown>
) {
  await supabaseAdmin.from('audit_logs').insert({
    table_name: 'reservations',
    record_id: reservationId,
    action: 'UPDATE',
    old_data: oldData,
    new_data: newData,
    actor_type: 'system',
    city_code: cityCode,
    reservation_id: reservationId
  })
}

async function postHostBooking(payload: Record<string, unknown>, idempotencyKey: string) {
  const apiUrl = Deno.env.get('HOST_CONNECT_API_URL')
  const apiKey = Deno.env.get('HOST_CONNECT_API_KEY')

  if (!apiUrl || !apiKey) {
    throw new Error('Host Connect API is not configured')
  }

  const controller = new AbortController()
  const timeout = setTimeout(() => controller.abort(), 25000)

  try {
    const response = await fetch(`${apiUrl}/bookings`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${apiKey}`,
        'Idempotency-Key': idempotencyKey,
        'X-Idempotency-Key': idempotencyKey,
      },
      body: JSON.stringify(payload),
      signal: controller.signal
    })

    const body = await response.json().catch(() => ({}))
    if (!response.ok) {
      const message = body?.error || body?.message || 'Host commit failed'
      throw new Error(message)
    }

    return body
  } finally {
    clearTimeout(timeout)
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

  let reservationId: string | null = null
  let idempotencyKeyInput: string | null = null

  try {
    const body = await req.json()
    reservationId = body?.reservation_id || null
    idempotencyKeyInput = body?.idempotency_key || null

    if (!reservationId) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Reservation ID is required' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    const { data: reservation, error: reservationError } = await supabaseAdmin
      .from('reservations')
      .select(
        'id, status, host_booking_id, city_code, property_id, unit_id, check_in, check_out, guests_adults, guests_children, guests_infants, guest_first_name, guest_last_name, guest_email, guest_phone, total_amount, currency, confirmation_code, metadata'
      )
      .eq('id', reservationId)
      .single()

    if (reservationError || !reservation) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_002', message: 'Reservation not found' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 404 }
      )
    }

    if (
      ['confirmed', 'checkin_pending', 'checked_in', 'checked_out', 'completed'].includes(reservation.status) &&
      reservation.host_booking_id
    ) {
      return new Response(
        JSON.stringify({
          success: true,
          data: {
            reservation_id: reservation.id,
            host_booking_id: reservation.host_booking_id,
            status: reservation.status,
            idempotent: true
          }
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    if (['cancelled', 'refund_pending'].includes(reservation.status)) {
      return new Response(
        JSON.stringify({
          success: false,
          error: { code: 'RESERVE_004', message: `Reservation status does not allow host commit: ${reservation.status}` }
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 409 }
      )
    }

    const idempotencyKey =
      req.headers.get('x-idempotency-key') || idempotencyKeyInput || `reservation-${reservation.id}`

    const payload = {
      reservation_id: reservation.id,
      confirmation_code: reservation.confirmation_code,
      property_id: reservation.property_id,
      unit_id: reservation.unit_id,
      check_in: reservation.check_in,
      check_out: reservation.check_out,
      guests: {
        adults: reservation.guests_adults,
        children: reservation.guests_children,
        infants: reservation.guests_infants,
      },
      guest: {
        first_name: reservation.guest_first_name,
        last_name: reservation.guest_last_name,
        email: reservation.guest_email,
        phone: reservation.guest_phone,
      },
      amount: reservation.total_amount,
      currency: reservation.currency,
      source: 'reserve_connect'
    }

    const hostResponse = await postHostBooking(payload, idempotencyKey)
    const hostBookingId = hostResponse?.booking_id || hostResponse?.id || hostResponse?.reservation_id

    if (!hostBookingId) {
      throw new Error('Host commit response missing booking id')
    }

    const oldData = { status: reservation.status, host_booking_id: reservation.host_booking_id }
    const newData = { status: 'confirmed', host_booking_id: hostBookingId }

    await supabaseAdmin
      .from('reservations')
      .update({
        status: 'confirmed',
        host_booking_id: hostBookingId,
        confirmed_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
        metadata: { ...reservation.metadata, host_commit: hostResponse }
      })
      .eq('id', reservation.id)

    await insertAuditLog(reservation.id, reservation.city_code, oldData, newData)

    await supabaseAdmin.from('events').insert({
      event_name: 'host_commit_succeeded',
      city_code: reservation.city_code,
      property_id: reservation.property_id,
      metadata: {
        reservation_id: reservation.id,
        host_booking_id: hostBookingId
      }
    })

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          reservation_id: reservation.id,
          host_booking_id: hostBookingId,
          status: 'confirmed'
        }
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Error in host_commit_booking:', error)

    if (reservationId) {
      const { data: reservation } = await supabaseAdmin
        .from('reservations')
        .select('id, status, city_code, metadata')
        .eq('id', reservationId)
        .single()

      if (reservation) {
        const oldData = { status: reservation.status }
        const newData = { status: 'host_commit_failed' }

        await supabaseAdmin
          .from('reservations')
          .update({
            status: 'host_commit_failed',
            updated_at: new Date().toISOString(),
            metadata: { ...reservation.metadata, host_commit_error: error.message }
          })
          .eq('id', reservation.id)

        await insertAuditLog(reservation.id, reservation.city_code, oldData, newData)

        await supabaseAdmin.from('events').insert({
          event_name: 'host_commit_failed',
          city_code: reservation.city_code,
          metadata: {
            reservation_id: reservation.id,
            error: error.message
          }
        })
      }
    }

    return new Response(
      JSON.stringify({ success: false, error: { code: 'RESERVE_005', message: error.message } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 502 }
    )
  }
})
