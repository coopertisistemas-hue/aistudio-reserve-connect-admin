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

    const payload = {
      city_code: cityCode,
      property_id: body?.property_id || null,
      name,
      min_properties: body?.min_properties ?? 0,
      max_properties: body?.max_properties ?? null,
      commission_rate: commissionRate,
      effective_from: body?.effective_from || new Date().toISOString().slice(0, 10),
      effective_to: body?.effective_to || null,
      is_active: body?.is_active !== false,
    }

    if (id) {
      const { data, error } = await supabaseAdmin
        .from('commission_tiers')
        .update(payload)
        .eq('id', id)
        .select('id, city_code, property_id, name, min_properties, max_properties, commission_rate, effective_from, effective_to, is_active, updated_at')
        .single()

      if (error) throw error
      return createSuccessResponse({ mode: 'updated', commission_tier: data })
    }

    const { data, error } = await supabaseAdmin
      .from('commission_tiers')
      .insert(payload)
      .select('id, city_code, property_id, name, min_properties, max_properties, commission_rate, effective_from, effective_to, is_active, created_at')
      .single()

    if (error) throw error
    return createSuccessResponse({ mode: 'created', commission_tier: data })
  } catch (error) {
    console.error('admin_upsert_commission_tier error:', (error as Error).message)
    return createErrorResponse('ADMIN_COMMISSION_002', (error as Error).message, 400)
  }
})
