import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
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

    const { city_code, check_in, check_out, guests_adults = 2, guests_children = 0, filters = {}, page = 1, limit = 20 } = await req.json()

    if (!city_code || !check_in || !check_out) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Missing required parameters: city_code, check_in, check_out' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    const checkInDate = new Date(check_in)
    const checkOutDate = new Date(check_out)
    const nights = Math.ceil((checkOutDate.getTime() - checkInDate.getTime()) / (1000 * 60 * 60 * 24))

    if (nights <= 0) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_001', message: 'Check-out must be after check-in' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    // Get city info
    const { data: cityData, error: cityError } = await supabaseClient
      .from('cities')
      .select('code, name, state_province')
      .eq('code', city_code)
      .single()

    if (cityError || !cityData) {
      return new Response(
        JSON.stringify({ success: false, error: { code: 'RESERVE_002', message: 'City not found' } }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 404 }
      )
    }

    // Calculate date range for availability
    const dates: string[] = []
    for (let i = 0; i < nights; i++) {
      const date = new Date(checkInDate)
      date.setDate(date.getDate() + i)
      dates.push(date.toISOString().split('T')[0])
    }

    // Search available properties
    let query = supabaseClient
      .from('properties_map')
      .select(`
        id,
        slug,
        name,
        property_type,
        city,
        state_province,
        rating_cached,
        review_count_cached,
        images_cached,
        amenities_cached,
        unit_map!inner (
          id,
          name,
          max_occupancy,
          availability_calendar!inner (
            date,
            base_price,
            discounted_price,
            is_available,
            is_blocked,
            allotment,
            bookings_count,
            temp_holds
          )
        )
      `)
      .eq('is_active', true)
      .eq('is_published', true)
      .eq('city_code', city_code)
      .is('deleted_at', null)

    // Apply filters
    if (filters.property_types?.length > 0) {
      query = query.in('property_type', filters.property_types)
    }

    if (filters.max_price) {
      query = query.lte('unit_map.availability_calendar.base_price', filters.max_price)
    }

    const { data: properties, error: propertiesError } = await query

    if (propertiesError) {
      throw propertiesError
    }

    // Process and filter available properties
    const availableProperties = []
    
    for (const property of properties || []) {
      const units = property.unit_map || []
      let minPrice = Infinity
      let totalUnits = 0

      for (const unit of units) {
        const availability = unit.availability_calendar || []
        const availabilityMap = new Map(availability.map((a: any) => [a.date, a]))
        
        let allDatesAvailable = true
        let unitTotalPrice = 0
        let minUnitPrice = Infinity

        for (const date of dates) {
          const dayAvailability = availabilityMap.get(date)
          
          if (!dayAvailability || 
              !dayAvailability.is_available || 
              dayAvailability.is_blocked ||
              (dayAvailability.allotment - dayAvailability.bookings_count - dayAvailability.temp_holds) <= 0) {
            allDatesAvailable = false
            break
          }

          const price = dayAvailability.discounted_price || dayAvailability.base_price
          unitTotalPrice += price
          minUnitPrice = Math.min(minUnitPrice, price)
        }

        if (allDatesAvailable && unit.max_occupancy >= (guests_adults + guests_children)) {
          totalUnits++
          minPrice = Math.min(minPrice, unitTotalPrice)
        }
      }

      if (totalUnits > 0 && minPrice !== Infinity) {
        availableProperties.push({
          id: property.id,
          slug: property.slug,
          name: property.name,
          type: property.property_type,
          city: property.city,
          state: property.state_province,
          rating: property.rating_cached,
          review_count: property.review_count_cached,
          images: property.images_cached?.slice(0, 5) || [],
          amenities: property.amenities_cached?.slice(0, 8) || [],
          price_per_night: Math.round(minPrice / nights),
          total_price: minPrice,
          currency: 'BRL',
          available_units: totalUnits
        })
      }
    }

    // Apply sorting
    if (filters.sort === 'price_asc') {
      availableProperties.sort((a, b) => a.price_per_night - b.price_per_night)
    } else if (filters.sort === 'price_desc') {
      availableProperties.sort((a, b) => b.price_per_night - a.price_per_night)
    } else if (filters.sort === 'rating') {
      availableProperties.sort((a, b) => (b.rating || 0) - (a.rating || 0))
    }

    // Pagination
    const total = availableProperties.length
    const start = (page - 1) * limit
    const end = start + limit
    const paginatedProperties = availableProperties.slice(start, end)

    // Emit search event
    await supabaseClient.from('events').insert({
      event_name: 'search_performed',
      city_code: city_code,
      session_id: req.headers.get('x-session-id') || 'anonymous',
      metadata: {
        check_in,
        check_out,
        nights,
        guests_adults,
        guests_children,
        result_count: total,
        filters
      },
      device_type: req.headers.get('user-agent')?.includes('Mobile') ? 'mobile' : 'desktop'
    })

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          city: cityData,
          search_params: {
            check_in,
            check_out,
            nights,
            guests: guests_adults + guests_children
          },
          properties: paginatedProperties,
          pagination: {
            total,
            page,
            limit,
            pages: Math.ceil(total / limit)
          }
        }
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Error in search_availability:', error)
    return new Response(
      JSON.stringify({ success: false, error: { code: 'RESERVE_010', message: 'Internal error', details: error.message } }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})
