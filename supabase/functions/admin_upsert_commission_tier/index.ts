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
    const cityCode = (body?.city_code as string | undefined)?.trim().toUpperCase()
    const name = (body?.name as string | undefined)?.trim()
    const commissionRate = Number(body?.commission_rate)

    if (!cityCode) throw new Error('city_code is required')
    if (!name) throw new Error('name is required')
    if (!Number.isFinite(commissionRate) || commissionRate < 0 || commissionRate > 1) {
      throw new Error('commission_rate must be between 0 and 1')
    }

    const { data, error } = await supabaseAdmin.rpc('admin_s2_upsert_commission_tier', {
      p_id: id || null,
      p_city_code: cityCode,
      p_property_id: body?.property_id || null,
      p_name: name,
      p_min_properties: body?.min_properties ?? 0,
      p_max_properties: body?.max_properties ?? null,
      p_commission_rate: commissionRate,
      p_effective_from: body?.effective_from || new Date().toISOString().slice(0, 10),
      p_effective_to: body?.effective_to || null,
      p_is_active: body?.is_active !== false,
    })

    if (error) throw error
    const row = Array.isArray(data) ? data[0] : null
    return createSuccessResponse({ mode: row?.mode || (id ? 'updated' : 'created'), commission_tier: row })
  } catch (error) {
    console.error('admin_upsert_commission_tier error:', (error as Error).message)
    return createErrorResponse('ADMIN_COMMISSION_002', (error as Error).message, 400)
  }
})
