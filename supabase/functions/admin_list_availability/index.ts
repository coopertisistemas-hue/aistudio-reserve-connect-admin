import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { requireAdmin, corsHeaders, createErrorResponse, createSuccessResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

function isoDate(value?: string) {
  if (!value) return null
  const d = new Date(value)
  if (Number.isNaN(d.getTime())) return null
  return d.toISOString().slice(0, 10)
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    await requireAdmin(req, supabaseAdmin)

    const body = await req.json().catch(() => ({}))
    const unitId = (body?.unit_id as string | undefined)?.trim()
    const propertyId = (body?.property_id as string | undefined)?.trim()
    const cityCode = (body?.city_code as string | undefined)?.trim().toUpperCase()
    const startDate = isoDate(body?.start_date) || new Date().toISOString().slice(0, 10)
    const endDate = isoDate(body?.end_date) || new Date(Date.now() + 1000 * 60 * 60 * 24 * 30).toISOString().slice(0, 10)

    let cityId: string | null = null
    if (cityCode) {
      const { data: cityData, error: cityError } = await supabaseAdmin
        .from('cities')
        .select('id')
        .eq('code', cityCode)
        .maybeSingle()

      if (cityError) throw cityError
      cityId = cityData?.id ?? null
      if (!cityId) return createSuccessResponse([])
    }

    let query = supabaseAdmin
      .from('availability_calendar')
      .select('id, unit_id, rate_plan_id, date, is_available, is_blocked, block_reason, min_stay_override, base_price, discounted_price, currency, allotment, bookings_count, temp_holds, updated_at, unit_map!inner(id, property_id, name, slug, properties_map!inner(id, name, city_id, city, state_province)), rate_plans!inner(id, name, code)')
      .gte('date', startDate)
      .lte('date', endDate)
      .order('date', { ascending: true })
      .limit(1000)

    if (unitId) query = query.eq('unit_id', unitId)
    if (propertyId) query = query.eq('unit_map.property_id', propertyId)
    if (cityId) query = query.eq('unit_map.properties_map.city_id', cityId)

    const { data, error } = await query
    if (error) throw error

    const response = (data || []).map((row: any) => ({
      id: row.id,
      unit_id: row.unit_id,
      unit_name: row.unit_map?.name || null,
      property_id: row.unit_map?.property_id || null,
      property_name: row.unit_map?.properties_map?.name || null,
      property_city: row.unit_map?.properties_map
        ? `${row.unit_map.properties_map.city || ''}${row.unit_map.properties_map.state_province ? `, ${row.unit_map.properties_map.state_province}` : ''}`.trim()
        : null,
      rate_plan_id: row.rate_plan_id,
      rate_plan_name: row.rate_plans?.name || null,
      date: row.date,
      is_available: row.is_available,
      is_blocked: row.is_blocked,
      block_reason: row.block_reason,
      min_stay_override: row.min_stay_override,
      base_price: Number(row.base_price || 0),
      discounted_price: row.discounted_price === null ? null : Number(row.discounted_price),
      currency: row.currency,
      allotment: row.allotment,
      bookings_count: row.bookings_count,
      temp_holds: row.temp_holds,
      updated_at: row.updated_at,
    }))

    return createSuccessResponse(response)
  } catch (error) {
    console.error('admin_list_availability error:', (error as Error).message)
    return createErrorResponse('ADMIN_AVAILABILITY_001', (error as Error).message, 401)
  }
})
