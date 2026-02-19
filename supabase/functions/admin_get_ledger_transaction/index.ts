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
    const transactionId = body?.transaction_id as string | undefined

    if (!transactionId) {
      return createErrorResponse('ADMIN_009', 'transaction_id is required', 400)
    }

    const { data, error } = await supabaseAdmin.rpc('admin_get_ledger_transaction_entries', {
      p_transaction_id: transactionId,
    })

    if (error) {
      throw error
    }

    return createSuccessResponse(data)
  } catch (error) {
    console.error('admin_get_ledger_transaction error:', error.message)
    return createErrorResponse('ADMIN_009', error.message, 401)
  }
})
