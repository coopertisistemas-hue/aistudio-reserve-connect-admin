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
    await requireAdminPermission(req, supabaseAdmin, 'ops', 'read')
    const { data, error } = await supabaseAdmin.rpc('admin_list_city_rollouts')
    if (error) throw error
    return createSuccessResponse(data || [])
  } catch (error) {
    return createErrorResponse('ADMIN_ROLLOUT_003', (error as Error).message, 401)
  }
})
