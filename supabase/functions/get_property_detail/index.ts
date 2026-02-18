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

    const { slug, check_in, check_out, session_id } = await req.json()

    if (!slug) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Property slug is required' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // Get property details
    const { data: property, error: propertyError } = await supabaseClient
      .from('properties_map')
      .select(`
        id,
        slug,
        host_property_id,
        city_code,
        name,
        description,
        property_type,
        address_line_1,
        city,
        state_province,
        postal_code,
        latitude,
        longitude,
        phone,
        email,
        website,
        amenities_cached,
        images_cached,
        rating_cached,
        review_count_cached,
        unit_map!inner (
          id,
          slug,
          name,
          description,
          unit_type,
          max_occupancy,
          base_capacity,
          size_sqm,
          bed_configuration,
          amenities_cached,
          images_cached,
          rate_plans (
            id,
            name,
            is_default,
            min_stay_nights,
            cancellation_policy_code
          )
        ),
        cities (code, name, state_province)
      `)
      .eq('slug', slug)
      .eq('is_active', true)
      .eq('is_published', true)
      .is('deleted_at', null)
      .single()

    if (propertyError || !property) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_002', message: 'Property not found' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 404 }
      )
    }

    // Get reviews
    const { data: reviews } = await supabaseClient
      .from('reviews')
      .select('overall_rating, cleanliness_rating, service_rating, location_rating, value_rating, title, content, created_at, is_verified')
      .eq('property_id', property.id)
      .eq('is_published', true)
      .order('created_at', { ascending: false })
      .limit(6)

    // Calculate availability and pricing if dates provided
    let availabilityData = null
    if (check_in && check_out) {
      const checkInDate = new Date(check_in)
      const checkOutDate = new Date(check_out)
      const nights = Math.ceil((checkOutDate.getTime() - checkInDate.getTime()) / (1000 * 60 * 60 * 24))

      if (nights > 0) {
        const dates: string[] = []
        for (let i = 0; i < nights; i++) {
          const date = new Date(checkInDate)
          date.setDate(date.getDate() + i)
          dates.push(date.toISOString().split('T')[0])
        }

        const unitsWithAvailability = []

        for (const unit of property.unit_map) {
          const { data: availability } = await supabaseClient
            .from('availability_calendar')
            .select('date, base_price, discounted_price, is_available, is_blocked, min_stay_override, allotment, bookings_count, temp_holds')
            .eq('unit_id', unit.id)
            .in('date', dates)

          let allDatesAvailable = true
          let totalPrice = 0
          const dailyPrices = []

          for (const date of dates) {
            const dayAvail = availability?.find(a => a.date === date)
            
            if (!dayAvail || !dayAvail.is_available || dayAvail.is_blocked) {
              allDatesAvailable = false
              break
            }

            if ((dayAvail.allotment - dayAvail.bookings_count - dayAvail.temp_holds) <= 0) {
              allDatesAvailable = false
              break
            }

            const price = dayAvail.discounted_price || dayAvail.base_price
            totalPrice += price
            dailyPrices.push({
              date,
              price,
              is_available: true
            })
          }

          unitsWithAvailability.push({
            ...unit,
            is_available: allDatesAvailable,
            total_price: allDatesAvailable ? totalPrice : null,
            nightly_price: allDatesAvailable ? Math.round(totalPrice / nights) : null,
            daily_prices: dailyPrices,
            min_stay: Math.max(...(availability?.map(a => a.min_stay_override || 1) || [1]))
          })
        }

        availabilityData = {
          check_in,
          check_out,
          nights,
          units: unitsWithAvailability
        }
      }
    }

    // Format property for response
    const propertyResponse = {
      id: property.id,
      slug: property.slug,
      name: property.name,
      description: property.description,
      type: property.property_type,
      location: {
        address: property.address_line_1,
        city: property.city,
        state: property.state_province,
        postal_code: property.postal_code,
        coordinates: {
          lat: property.latitude,
          lng: property.longitude
        }
      },
      rating: property.rating_cached,
      review_count: property.review_count_cached,
      images: property.images_cached || [],
      amenities: property.amenities_cached || [],
      contact: {
        phone: property.phone,
        email: property.email,
        website: property.website
      },
      room_types: property.unit_map.map(u => ({
        id: u.id,
        slug: u.slug,
        name: u.name,
        description: u.description,
        type: u.unit_type,
        max_occupancy: u.max_occupancy,
        base_capacity: u.base_capacity,
        size_sqm: u.size_sqm,
        bed_configuration: u.bed_configuration,
        amenities: u.amenities_cached || [],
        images: u.images_cached || [],
        rate_plans: u.rate_plans
      })),
      reviews: reviews || [],
      availability: availabilityData,
      city: property.cities
    }

    // Emit property viewed event
    await supabaseClient.from('events').insert({
      event_name: 'property_viewed',
      city_code: property.city_code,
      property_id: property.id,
      session_id: session_id || req.headers.get('x-session-id') || 'anonymous',
      metadata: {
        slug,
        from_search: !!check_in && !!check_out,
        check_in,
        check_out
      },
      device_type: req.headers.get('user-agent')?.includes('Mobile') ? 'mobile' : 'desktop'
    })

    return new Response(
      JSON.stringify({
        success: true,
        data: propertyResponse
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Error in get_property_detail:', error)
    return new Response(
      JSON.stringify({ success: false, error: { code: 'RESERVE_010', message: 'Internal error', details: error.message } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})
