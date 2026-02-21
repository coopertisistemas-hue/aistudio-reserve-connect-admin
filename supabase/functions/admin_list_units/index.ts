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

    const { data, error } = await supabaseAdmin.rpc('admin_s1_list_units', {
      p_property_id: propertyId || null,
      p_city_code: cityCode || null,
      p_active_only: activeOnly,
      p_limit: 300,
    })
    if (error) throw error
    return createSuccessResponse(data || [])
  } catch (error) {
    console.error('admin_list_units error:', (error as Error).message)
    return createErrorResponse('ADMIN_UNITS_001', (error as Error).message, 401)
  }
})
