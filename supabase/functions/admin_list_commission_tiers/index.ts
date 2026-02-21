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
    const propertyId = (body?.property_id as string | undefined)?.trim()
    const activeOnly = body?.active_only !== false

    const { data, error } = await supabaseAdmin.rpc('admin_s2_list_commission_tiers', {
      p_city_code: cityCode || null,
      p_property_id: propertyId || null,
      p_active_only: activeOnly,
      p_limit: 300,
    })
    if (error) throw error

    const response = (data || []).map((item: any) => ({
      id: item.id,
      city_code: item.city_code,
      property_id: item.property_id,
      property_name: item.property_name || null,
      name: item.name,
      min_properties: item.min_properties,
      max_properties: item.max_properties,
      commission_rate: Number(item.commission_rate || 0),
      effective_from: item.effective_from,
      effective_to: item.effective_to,
      is_active: item.is_active,
      created_at: item.created_at,
      updated_at: item.updated_at,
    }))

    return createSuccessResponse(response)
  } catch (error) {
    console.error('admin_list_commission_tiers error:', (error as Error).message)
    return createErrorResponse('ADMIN_COMMISSION_001', (error as Error).message, 401)
  }
})
