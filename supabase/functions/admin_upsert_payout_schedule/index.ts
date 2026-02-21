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

    const body = await req.json()
    const id = (body?.id as string | undefined)?.trim()
    const entityType = (body?.entity_type as string | undefined)?.trim().toLowerCase()
    const entityId = (body?.entity_id as string | undefined)?.trim()
    const cityCode = (body?.city_code as string | undefined)?.trim().toUpperCase()
    const frequency = (body?.frequency as string | undefined)?.trim().toLowerCase() || 'weekly'

    if (!entityType || !['owner', 'property'].includes(entityType)) {
      throw new Error('entity_type must be owner or property')
    }
    if (!entityId) throw new Error('entity_id is required')
    if (!cityCode) throw new Error('city_code is required')

    const { data, error } = await supabaseAdmin.rpc('admin_s2_upsert_payout_schedule', {
      p_id: id || null,
      p_entity_type: entityType,
      p_entity_id: entityId,
      p_city_code: cityCode,
      p_frequency: frequency,
      p_day_of_week: body?.day_of_week ?? null,
      p_day_of_month: body?.day_of_month ?? null,
      p_min_threshold: body?.min_threshold ?? 0,
      p_hold_days: body?.hold_days ?? 0,
      p_is_active: body?.is_active !== false,
    })

    if (error) throw error
    const row = Array.isArray(data) ? data[0] : null
    return createSuccessResponse({ mode: row?.mode || (id ? 'updated' : 'created'), payout_schedule: row })
  } catch (error) {
    console.error('admin_upsert_payout_schedule error:', (error as Error).message)
    return createErrorResponse('ADMIN_SCHEDULE_002', (error as Error).message, 400)
  }
})
