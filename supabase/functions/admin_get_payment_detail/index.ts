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
    const paymentId = body?.payment_id as string | undefined

    if (!paymentId) {
      return createErrorResponse('ADMIN_005', 'payment_id is required', 400)
    }

    const { data, error } = await supabaseAdmin.rpc('admin_get_payment_detail', {
      p_payment_id: paymentId,
    })

    if (error) {
      throw error
    }

    return createSuccessResponse(data)
  } catch (error) {
    console.error('admin_get_payment_detail error:', error.message)
    return createErrorResponse('ADMIN_005', error.message, 401)
  }
})
