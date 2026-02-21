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
    const activeOnly = body?.active_only === true

    let query = supabaseAdmin
      .from('rate_plans')
      .select('id, property_id, host_rate_plan_id, name, code, is_default, channels_enabled, min_stay_nights, max_stay_nights, advance_booking_days, cancellation_policy_code, is_active, created_at, updated_at, properties_map!inner(id, name, city, state_province)')
      .order('updated_at', { ascending: false })
      .limit(300)

    if (propertyId) query = query.eq('property_id', propertyId)
    if (activeOnly) query = query.eq('is_active', true)

    const { data, error } = await query
    if (error) throw error

    const response = (data || []).map((item: any) => ({
      id: item.id,
      property_id: item.property_id,
      property_name: item.properties_map?.name || null,
      property_city: item.properties_map
        ? `${item.properties_map.city || ''}${item.properties_map.state_province ? `, ${item.properties_map.state_province}` : ''}`.trim()
        : null,
      host_rate_plan_id: item.host_rate_plan_id,
      name: item.name,
      code: item.code,
      is_default: item.is_default,
      channels_enabled: item.channels_enabled || [],
      min_stay_nights: item.min_stay_nights,
      max_stay_nights: item.max_stay_nights,
      advance_booking_days: item.advance_booking_days,
      cancellation_policy_code: item.cancellation_policy_code,
      is_active: item.is_active,
      created_at: item.created_at,
      updated_at: item.updated_at,
    }))

    return createSuccessResponse(response)
  } catch (error) {
    console.error('admin_list_rate_plans error:', (error as Error).message)
    return createErrorResponse('ADMIN_RATE_PLAN_001', (error as Error).message, 401)
  }
})
