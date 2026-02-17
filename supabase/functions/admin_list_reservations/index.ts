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
    // Validate admin authentication (bypass removed)
    await requireAdmin(req, supabaseAdmin)
    
    const { city_code } = await req.json().catch(() => ({}))

    let query = supabaseAdmin
      .from('reservations')
      .select('id, confirmation_code, status, check_in, check_out, guest_first_name, guest_last_name, total_amount, city_code')
      .order('created_at', { ascending: false })
      .limit(120)

    if (city_code) {
      query = query.eq('city_code', city_code)
    }

    const { data, error } = await query
    if (error) {
      throw error
    }

    const response = (data || []).map((reservation) => ({
      id: reservation.id,
      confirmation_code: reservation.confirmation_code,
      status: reservation.status,
      check_in: reservation.check_in,
      check_out: reservation.check_out,
      guest_name: `${reservation.guest_first_name || ''} ${reservation.guest_last_name || ''}`.trim(),
      total_amount: reservation.total_amount
    }))

    return createSuccessResponse(response)
  } catch (error) {
    console.error('admin_list_reservations error:', error.message)
    return createErrorResponse('ADMIN_002', error.message, 401)
  }
})
