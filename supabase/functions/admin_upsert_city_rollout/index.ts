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
    const cityCode = String(body?.city_code || '').trim().toUpperCase()
    if (!cityCode) throw new Error('city_code is required')

    const { data, error } = await supabaseAdmin.rpc('admin_upsert_city_rollout', {
      p_city_code: cityCode,
      p_is_enabled: Boolean(body?.is_enabled),
      p_phase: body?.phase || 'pilot',
      p_note: body?.note || null,
      p_updated_by: actor.email || 'admin_api',
    })
    if (error) throw error
    return createSuccessResponse(data)
  } catch (error) {
    return createErrorResponse('ADMIN_ROLLOUT_004', (error as Error).message, 400)
  }
})
