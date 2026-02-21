import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { requireAdmin, corsHeaders, createErrorResponse, createSuccessResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    await requireAdmin(req, supabaseAdmin)

    const body = await req.json().catch(() => ({}))
    const propertyId = (body?.property_id as string | undefined)?.trim()
    const cityCode = (body?.city_code as string | undefined)?.trim().toUpperCase()
    const activeOnly = body?.active_only === true

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
      .from('unit_map')
      .select('id, host_unit_id, property_id, name, slug, unit_type, description, max_occupancy, base_capacity, size_sqm, is_active, created_at, updated_at, properties_map!inner(id, name, city, state_province, city_id)')
      .order('updated_at', { ascending: false })
      .limit(300)

    if (propertyId) query = query.eq('property_id', propertyId)
    if (cityId) query = query.eq('properties_map.city_id', cityId)
    if (activeOnly) query = query.eq('is_active', true)

    const { data, error } = await query
    if (error) throw error

    const response = (data || []).map((item: any) => ({
      id: item.id,
      host_unit_id: item.host_unit_id,
      property_id: item.property_id,
      property_name: item.properties_map?.name || null,
      property_city: item.properties_map
        ? `${item.properties_map.city || ''}${item.properties_map.state_province ? `, ${item.properties_map.state_province}` : ''}`.trim()
        : null,
      name: item.name,
      slug: item.slug,
      unit_type: item.unit_type,
      description: item.description,
      max_occupancy: item.max_occupancy,
      base_capacity: item.base_capacity,
      size_sqm: item.size_sqm,
      is_active: item.is_active,
      created_at: item.created_at,
      updated_at: item.updated_at,
    }))

    return createSuccessResponse(response)
  } catch (error) {
    console.error('admin_list_units error:', (error as Error).message)
    return createErrorResponse('ADMIN_UNITS_001', (error as Error).message, 401)
  }
})
