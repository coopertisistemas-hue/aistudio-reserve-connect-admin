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

    const payload = {
      property_id: propertyId,
      host_rate_plan_id: body?.host_rate_plan_id || null,
      name,
      code: body?.code || null,
      is_default: body?.is_default === true,
      channels_enabled: Array.isArray(body?.channels_enabled) && body.channels_enabled.length > 0
        ? body.channels_enabled
        : ['direct'],
      min_stay_nights: minStay,
      max_stay_nights: body?.max_stay_nights ?? null,
      advance_booking_days: body?.advance_booking_days ?? null,
      cancellation_policy_code: body?.cancellation_policy_code || null,
      is_active: body?.is_active !== false,
    }

    if (id) {
      const { data, error } = await supabaseAdmin
        .from('rate_plans')
        .update(payload)
        .eq('id', id)
        .select('id, property_id, name, code, is_default, channels_enabled, min_stay_nights, max_stay_nights, advance_booking_days, cancellation_policy_code, is_active, updated_at')
        .single()

      if (error) throw error
      return createSuccessResponse({ mode: 'updated', rate_plan: data })
    }

    const { data, error } = await supabaseAdmin
      .from('rate_plans')
      .insert(payload)
      .select('id, property_id, name, code, is_default, channels_enabled, min_stay_nights, max_stay_nights, advance_booking_days, cancellation_policy_code, is_active, created_at')
      .single()

    if (error) throw error
    return createSuccessResponse({ mode: 'created', rate_plan: data })
  } catch (error) {
    console.error('admin_upsert_rate_plan error:', (error as Error).message)
    return createErrorResponse('ADMIN_RATE_PLAN_002', (error as Error).message, 400)
  }
})
