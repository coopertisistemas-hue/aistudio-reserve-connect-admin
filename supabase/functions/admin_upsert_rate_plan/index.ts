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
    const propertyId = (body?.property_id as string | undefined)?.trim()
    const name = (body?.name as string | undefined)?.trim()

    if (!propertyId) throw new Error('property_id is required')
    if (!name) throw new Error('name is required')

    const minStay = Number(body?.min_stay_nights ?? 1)
    if (!Number.isFinite(minStay) || minStay < 1) {
      throw new Error('min_stay_nights must be >= 1')
    }

    const { data, error } = await supabaseAdmin.rpc('admin_s1_upsert_rate_plan', {
      p_id: id || null,
      p_property_id: propertyId,
      p_host_rate_plan_id: body?.host_rate_plan_id || null,
      p_name: name,
      p_code: body?.code || null,
      p_is_default: body?.is_default === true,
      p_channels_enabled: Array.isArray(body?.channels_enabled) && body.channels_enabled.length > 0
        ? body.channels_enabled
        : ['direct'],
      p_min_stay_nights: minStay,
      p_max_stay_nights: body?.max_stay_nights ?? null,
      p_advance_booking_days: body?.advance_booking_days ?? null,
      p_cancellation_policy_code: body?.cancellation_policy_code || null,
      p_is_active: body?.is_active !== false,
    })

    if (error) throw error
    const row = Array.isArray(data) ? data[0] : null
    return createSuccessResponse({ mode: row?.mode || (id ? 'updated' : 'created'), rate_plan: row })
  } catch (error) {
    console.error('admin_upsert_rate_plan error:', (error as Error).message)
    return createErrorResponse('ADMIN_RATE_PLAN_002', (error as Error).message, 400)
  }
})
