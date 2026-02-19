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
    const adminUser = await requireAdmin(req, supabaseAdmin)

    const body = await req.json().catch(() => ({}))
    const paymentId = body?.payment_id as string | undefined
    const amount = Number(body?.amount)
    const reason = (body?.reason as string | undefined)?.trim() || null

    if (!paymentId) {
      return createErrorResponse('ADMIN_006', 'payment_id is required', 400)
    }

    if (!Number.isFinite(amount) || amount <= 0) {
      return createErrorResponse('ADMIN_006', 'Invalid refund amount', 400)
    }

    const { data, error } = await supabaseAdmin.rpc('admin_apply_payment_refund', {
      p_payment_id: paymentId,
      p_amount: amount,
      p_reason: reason,
      p_admin_email: adminUser.email || null,
    })

    if (error) {
      throw error
    }

    const payload = Array.isArray(data) ? data[0] : data
    if (!payload) {
      throw new Error('Failed to apply refund')
    }

    return createSuccessResponse(payload)
  } catch (error) {
    console.error('admin_refund_payment error:', error.message)
    return createErrorResponse('ADMIN_006', error.message, 401)
  }
})
