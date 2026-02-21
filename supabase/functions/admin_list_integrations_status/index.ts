import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { requireAdminPermission, corsHeaders, createErrorResponse, createSuccessResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    await requireAdminPermission(req, supabaseAdmin, 'integrations', 'read')
    const body = await req.json().catch(() => ({}))
    const limit = Number(body?.limit || 40)

    const { data, error } = await supabaseAdmin.rpc('admin_list_integrations_status', {
      p_limit: Number.isFinite(limit) ? limit : 40,
    })

    if (error) throw error
    return createSuccessResponse(data)
  } catch (error) {
    console.error('admin_list_integrations_status error:', (error as Error).message)
    return createErrorResponse('ADMIN_RBAC_006', (error as Error).message, 401)
  }
})
