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
    const cityCode = (body?.city_code as string | undefined)?.trim().toUpperCase()
    const entityType = (body?.entity_type as string | undefined)?.trim().toLowerCase()
    const activeOnly = body?.active_only !== false

    const { data, error } = await supabaseAdmin.rpc('admin_s2_list_payout_schedules', {
      p_city_code: cityCode || null,
      p_entity_type: entityType || null,
      p_active_only: activeOnly,
      p_limit: 300,
    })
    if (error) throw error

    const response = (data || []).map((item: any) => ({
      id: item.id,
      entity_type: item.entity_type,
      entity_id: item.entity_id,
      city_code: item.city_code,
      frequency: item.frequency,
      day_of_week: item.day_of_week,
      day_of_month: item.day_of_month,
      min_threshold: Number(item.min_threshold || 0),
      hold_days: item.hold_days,
      is_active: item.is_active,
      created_at: item.created_at,
      updated_at: item.updated_at,
    }))

    return createSuccessResponse(response)
  } catch (error) {
    console.error('admin_list_payout_schedules error:', (error as Error).message)
    return createErrorResponse('ADMIN_SCHEDULE_001', (error as Error).message, 401)
  }
})
