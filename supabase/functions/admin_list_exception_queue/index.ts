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
    const severity = (body?.severity as string | undefined)?.trim().toUpperCase()
    const status = (body?.status as string | undefined)?.trim().toLowerCase()
    const owner = (body?.owner_email as string | undefined)?.trim().toLowerCase()

    const { data, error } = await supabaseAdmin.rpc('admin_ops_alert_queue', {
      p_severity: severity || null,
      p_status: status || null,
      p_owner_email: owner || null,
      p_limit: 300,
    })

    if (error) {
      throw error
    }

    return createSuccessResponse(data || [])
  } catch (error) {
    console.error('admin_list_exception_queue error:', (error as Error).message)
    return createErrorResponse('ADMIN_OPS_QUEUE_001', (error as Error).message, 401)
  }
})
