import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { requireAdminPermission, corsHeaders, createErrorResponse, createSuccessResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  try {
    const actor = await requireAdminPermission(req, supabaseAdmin, 'ops', 'write')
    const body = await req.json().catch(() => ({}))

    const { data, error } = await supabaseAdmin.rpc('admin_rollout_rollback', {
      p_scope: body?.scope || 'all',
      p_city_code: body?.city_code || null,
      p_triggered_by: actor.email || 'admin_api',
      p_reason: body?.reason || null,
    })
    if (error) throw error
    return createSuccessResponse(data)
  } catch (error) {
    return createErrorResponse('ADMIN_ROLLOUT_005', (error as Error).message, 400)
  }
})
