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

    // Use service role for database operations
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { 
      session_id,
      city_code,
      property_slug,
      unit_id,
      rate_plan_id,
      check_in,
      check_out,
      guests_adults = 2,
      guests_children = 0,
      guests_infants = 0
    } = await req.json()

    // Validate required fields
    if (!session_id || !city_code || !property_slug || !unit_id || !check_in || !check_out) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Missing required fields' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // Calculate nights
    const checkInDate = new Date(check_in)
    const checkOutDate = new Date(check_out)
    const nights = Math.ceil((checkOutDate.getTime() - checkInDate.getTime()) / (1000 * 60 * 60 * 24))

    if (nights <= 0) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Invalid date range' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // Idempotency check - look for existing intent with same parameters
    const idempotencyKey = req.headers.get('x-idempotency-key') || `${session_id}:${property_slug}:${unit_id}:${check_in}:${check_out}`
    
    const { data: existingIntent } = await supabaseAdmin
      .from('booking_intents')
      .select('*')
      .eq('session_id', session_id)
      .eq('property_id', (await supabaseAdmin.from('properties_map').select('id').eq('slug', property_slug).single()).data?.id)
      .eq('unit_id', unit_id)
      .eq('check_in', check_in)
      .eq('check_out', check_out)
      .in('status', ['intent_created', 'payment_pending'])
      .gt('expires_at', new Date().toISOString())
      .single()

    if (existingIntent) {
      return new Response(
        JSON.stringify({
          success: true,
          data: {
            intent_id: existingIntent.id,
            session_id: existingIntent.session_id,
            status: existingIntent.status,
            expires_at: existingIntent.expires_at,
            pricing: {
              nightly_rate: Math.round((existingIntent.total_amount || 0) / nights),
              nights,
              subtotal: existingIntent.subtotal,
              taxes: existingIntent.taxes,
              fees: existingIntent.fees,
              discount_amount: existingIntent.discount_amount,
              total: existingIntent.total_amount,
              currency: existingIntent.currency
            },
            idempotency_key: idempotencyKey,
            cached: true
          }
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Get property and unit info
    const { data: property } = await supabaseAdmin
      .from('properties_map')
      .select('id, city_code')
      .eq('slug', property_slug)
      .single()

    if (!property) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_002', message: 'Property not found' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 404 }
      )
    }

    const { data: unit } = await supabaseAdmin
      .from('unit_map')
      .select('id, max_occupancy, property_id')
      .eq('id', unit_id)
      .single()

    if (!unit) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_002', message: 'Unit not found' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 404 }
      )
    }

    // Check capacity
    const totalGuests = guests_adults + guests_children
    if (totalGuests > unit.max_occupancy) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: `Maximum occupancy is ${unit.max_occupancy} guests` } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // Get availability and calculate pricing
    const dates: string[] = []
    for (let i = 0; i < nights; i++) {
      const date = new Date(checkInDate)
      date.setDate(date.getDate() + i)
      dates.push(date.toISOString().split('T')[0])
    }

    const { data: availability } = await supabaseAdmin
      .from('availability_calendar')
      .select('base_price, discounted_price, is_available, is_blocked, allotment, bookings_count, temp_holds, min_stay_override')
      .eq('unit_id', unit_id)
      .in('date', dates)

    // Check availability
    if (!availability || availability.length !== nights) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_002', message: 'Not all dates are available' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    for (const day of availability) {
      if (!day.is_available || day.is_blocked) {
        return new Response(
          JSON.stringify({ success: false, error: { code: 'RESERVE_002', message: 'Selected dates are not available' } }),
          { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
        )
      }

      if ((day.allotment - day.bookings_count - day.temp_holds) <= 0) {
        return new Response(
          JSON.stringify({ success: false, error: { code: 'RESERVE_002', message: 'No availability for selected dates' } }),
          { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
        )
      }

      const minStay = day.min_stay_override || 1
      if (nights < minStay) {
        return new Response(
          JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: `Minimum stay is ${minStay} nights` } }),
          { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
        )
      }
    }

    // Calculate pricing
    let subtotal = 0
    for (const day of availability) {
      subtotal += (day.discounted_price || day.base_price)
    }

    const taxes = 0 // Calculate based on local tax rules
    const fees = 50 // Cleaning fee, etc.
    const discount_amount = 0 // Apply promo codes here
    const total_amount = subtotal + taxes + fees - discount_amount

    // Create soft holds on availability
    for (const day of availability) {
      await supabaseAdmin
        .from('availability_calendar')
        .update({ temp_holds: day.temp_holds + 1 })
        .eq('unit_id', unit_id)
        .eq('date', day.date)
    }

    // Create booking intent
    const expiresAt = new Date()
    expiresAt.setMinutes(expiresAt.getMinutes() + 15) // 15 minute TTL

    const { data: intent, error: intentError } = await supabaseAdmin
      .from('booking_intents')
      .insert({
        session_id,
        city_code,
        property_id: property.id,
        unit_id,
        rate_plan_id: rate_plan_id || null,
        check_in,
        check_out,
        nights,
        guests_adults,
        guests_children,
        guests_infants,
        status: 'intent_created',
        subtotal,
        taxes,
        fees,
        discount_amount,
        total_amount,
        currency: 'BRL',
        expires_at: expiresAt.toISOString(),
        metadata: {
          idempotency_key: idempotencyKey,
          user_agent: req.headers.get('user-agent'),
          ip_address: req.headers.get('x-forwarded-for')
        }
      })
      .select()
      .single()

    if (intentError) {
      throw intentError
    }

    // Emit event
    await supabaseAdmin.from('events').insert({
      event_name: 'booking_intent_created',
      city_code,
      property_id: property.id,
      unit_id,
      session_id,
      metadata: {
        intent_id: intent.id,
        nights,
        guests: totalGuests,
        total_amount
      }
    })

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          intent_id: intent.id,
          session_id: intent.session_id,
          status: intent.status,
          expires_at: intent.expires_at,
          pricing: {
            nightly_rate: Math.round(subtotal / nights),
            nights,
            subtotal,
            taxes,
            fees,
            discount_amount,
            total: total_amount,
            currency: 'BRL'
          },
          idempotency_key: idempotencyKey
        }
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Error in create_booking_intent:', error)
    return new Response(
      JSON.stringify({ success: false, error: { code: 'RESERVE_010', message: 'Internal error', details: error.message } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})
