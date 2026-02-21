import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { requireAdmin, corsHeaders, createErrorResponse, createSuccessResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

const ACTIVE_STATUSES = ['intent_created', 'payment_pending']

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    await requireAdmin(req, supabaseAdmin)

    const body = await req.json().catch(() => ({}))
    const cityCode = (body?.city_code as string | undefined)?.trim().toUpperCase()
    const propertyId = (body?.property_id as string | undefined)?.trim()
    const status = (body?.status as string | undefined)?.trim()
    const onlyActive = body?.only_active !== false

    let query = supabaseAdmin
      .from('booking_intents')
      .select('id, session_id, city_code, property_id, unit_id, rate_plan_id, check_in, check_out, nights, guests_adults, guests_children, guests_infants, status, subtotal, taxes, fees, total_amount, currency, expires_at, created_at, updated_at, properties_map!inner(id, name), unit_map!inner(id, name), rate_plans(id, name)')
      .order('created_at', { ascending: false })
      .limit(300)

    if (cityCode) query = query.eq('city_code', cityCode)
    if (propertyId) query = query.eq('property_id', propertyId)
    if (status) query = query.eq('status', status)
    else if (onlyActive) query = query.in('status', ACTIVE_STATUSES)

    const { data, error } = await query
    if (error) throw error

    const now = Date.now()
    const response = (data || []).map((row: any) => {
      const expiresAt = row.expires_at ? new Date(row.expires_at).getTime() : null
      const expiresInSeconds = expiresAt ? Math.max(0, Math.floor((expiresAt - now) / 1000)) : null

      return {
        id: row.id,
        session_id: row.session_id,
        city_code: row.city_code,
        property_id: row.property_id,
        property_name: row.properties_map?.name || null,
        unit_id: row.unit_id,
        unit_name: row.unit_map?.name || null,
        rate_plan_id: row.rate_plan_id,
        rate_plan_name: row.rate_plans?.name || null,
        check_in: row.check_in,
        check_out: row.check_out,
        nights: row.nights,
        guests_adults: row.guests_adults,
        guests_children: row.guests_children,
        guests_infants: row.guests_infants,
        status: row.status,
        subtotal: Number(row.subtotal || 0),
        taxes: Number(row.taxes || 0),
        fees: Number(row.fees || 0),
        total_amount: Number(row.total_amount || 0),
        currency: row.currency,
        expires_at: row.expires_at,
        expires_in_seconds: expiresInSeconds,
        created_at: row.created_at,
        updated_at: row.updated_at,
      }
    })

    return createSuccessResponse(response)
  } catch (error) {
    console.error('admin_list_booking_holds error:', (error as Error).message)
    return createErrorResponse('ADMIN_HOLDS_001', (error as Error).message, 401)
  }
})
