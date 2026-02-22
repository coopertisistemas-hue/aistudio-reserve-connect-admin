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
    const moduleKey = String(body?.module_key || '').trim().toLowerCase()
    if (!moduleKey) throw new Error('module_key is required')

    const { data, error } = await supabaseAdmin.rpc('admin_upsert_feature_flag', {
      p_module_key: moduleKey,
      p_enabled: Boolean(body?.enabled),
      p_rollout_percent: Number(body?.rollout_percent ?? 0),
      p_note: body?.note || null,
      p_updated_by: actor.email || 'admin_api',
    })
    if (error) throw error
    return createSuccessResponse(data)
  } catch (error) {
    return createErrorResponse('ADMIN_ROLLOUT_002', (error as Error).message, 400)
  }
})
