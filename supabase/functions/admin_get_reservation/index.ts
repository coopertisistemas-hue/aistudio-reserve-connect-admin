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
    
    const { reservation_id } = await req.json()
    if (!reservation_id) {
      return createErrorResponse('ADMIN_004', 'Reservation ID required', 400)
    }

    const { data, error } = await supabaseAdmin
      .from('reservations')
      .select('*')
      .eq('id', reservation_id)
      .single()

    if (error || !data) {
      return createErrorResponse('ADMIN_005', 'Reservation not found', 404)
    }

    return createSuccessResponse(data)
  } catch (error) {
    console.error('admin_get_reservation error:', error.message)
    return createErrorResponse('ADMIN_006', error.message, 401)
  }
})
