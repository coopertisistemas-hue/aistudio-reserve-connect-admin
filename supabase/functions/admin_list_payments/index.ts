import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { requireAdmin, corsHeaders, createErrorResponse, createSuccessResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

type PaymentRow = {
  id: string
  reservation_id: string | null
  confirmation_code: string | null
  guest_name: string | null
  property_name: string | null
  city_code: string | null
  payment_method: string
  gateway: string
  gateway_payment_id: string
  currency: string
  amount: number
  gateway_fee: number
  tax_amount: number
  refunded_amount: number
  net_amount: number
  status: string
  created_at: string
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    await requireAdmin(req, supabaseAdmin)

    const body = await req.json().catch(() => ({}))
    const cityCode = (body?.city_code as string | undefined)?.trim()
    const status = (body?.status as string | undefined)?.trim()
    const search = (body?.search as string | undefined)?.trim().toLowerCase()

    const { data, error } = await supabaseAdmin.rpc('admin_list_payments', {
      p_city_code: cityCode || null,
      p_status: status || null,
      p_search: search || null,
      p_limit: 300,
    })

    if (error) {
      throw error
    }

    return createSuccessResponse((data || []) as PaymentRow[])
  } catch (error) {
    console.error('admin_list_payments error:', error.message)
    return createErrorResponse('ADMIN_004', error.message, 401)
  }
})
