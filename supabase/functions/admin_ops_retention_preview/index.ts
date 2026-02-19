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
    const auditDays = Number(body?.audit_days ?? 180)
    const webhookDays = Number(body?.webhook_days ?? 60)
    const reconDays = Number(body?.recon_days ?? 90)

    const { data, error } = await supabaseAdmin.rpc('admin_ops_retention_preview', {
      p_audit_days: auditDays,
      p_webhook_days: webhookDays,
      p_recon_days: reconDays,
    })

    if (error) {
      throw error
    }

    return createSuccessResponse(data)
  } catch (error) {
    console.error('admin_ops_retention_preview error:', error.message)
    return createErrorResponse('ADMIN_012', error.message, 401)
  }
})
