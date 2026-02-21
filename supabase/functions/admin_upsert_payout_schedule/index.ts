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

    const payload = {
      entity_type: entityType,
      entity_id: entityId,
      city_code: cityCode,
      frequency,
      day_of_week: body?.day_of_week ?? null,
      day_of_month: body?.day_of_month ?? null,
      min_threshold: body?.min_threshold ?? 0,
      hold_days: body?.hold_days ?? 0,
      is_active: body?.is_active !== false,
    }

    if (id) {
      const { data, error } = await supabaseAdmin
        .from('payout_schedules')
        .update(payload)
        .eq('id', id)
        .select('id, entity_type, entity_id, city_code, frequency, day_of_week, day_of_month, min_threshold, hold_days, is_active, updated_at')
        .single()

      if (error) throw error
      return createSuccessResponse({ mode: 'updated', payout_schedule: data })
    }

    const { data, error } = await supabaseAdmin
      .from('payout_schedules')
      .insert(payload)
      .select('id, entity_type, entity_id, city_code, frequency, day_of_week, day_of_month, min_threshold, hold_days, is_active, created_at')
      .single()

    if (error) throw error
    return createSuccessResponse({ mode: 'created', payout_schedule: data })
  } catch (error) {
    console.error('admin_upsert_payout_schedule error:', (error as Error).message)
    return createErrorResponse('ADMIN_SCHEDULE_002', (error as Error).message, 400)
  }
})
