import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { requireAdmin, corsHeaders, createErrorResponse, createSuccessResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

function isoDate(value?: string) {
  if (!value) return null
  const d = new Date(value)
  if (Number.isNaN(d.getTime())) return null
  return d.toISOString().slice(0, 10)
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    await requireAdmin(req, supabaseAdmin)

    const body = await req.json().catch(() => ({}))
    const unitId = (body?.unit_id as string | undefined)?.trim()
    const propertyId = (body?.property_id as string | undefined)?.trim()
    const cityCode = (body?.city_code as string | undefined)?.trim().toUpperCase()
    const startDate = isoDate(body?.start_date) || new Date().toISOString().slice(0, 10)
    const endDate = isoDate(body?.end_date) || new Date(Date.now() + 1000 * 60 * 60 * 24 * 30).toISOString().slice(0, 10)

    const { data, error } = await supabaseAdmin.rpc('admin_s1_list_availability', {
      p_unit_id: unitId || null,
      p_property_id: propertyId || null,
      p_city_code: cityCode || null,
      p_start_date: startDate,
      p_end_date: endDate,
      p_limit: 1000,
    })
    if (error) throw error
    return createSuccessResponse(data || [])
  } catch (error) {
    console.error('admin_list_availability error:', (error as Error).message)
    return createErrorResponse('ADMIN_AVAILABILITY_001', (error as Error).message, 401)
  }
})
