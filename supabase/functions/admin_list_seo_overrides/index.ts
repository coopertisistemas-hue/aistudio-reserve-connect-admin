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
    await requireAdminPermission(req, supabaseAdmin, 'marketing', 'read')
    const body = await req.json().catch(() => ({}))

    const { data, error } = await supabaseAdmin.rpc('admin_list_seo_overrides', {
      p_tenant_id: body?.tenant_id || '00000000-0000-0000-0000-000000000000',
      p_city_code: body?.city_code || null,
      p_lang: body?.lang || null,
      p_active_only: Boolean(body?.active_only),
    })

    if (error) throw error
    return createSuccessResponse(data || [])
  } catch (error) {
    console.error('admin_list_seo_overrides error:', (error as Error).message)
    return createErrorResponse('ADMIN_MARKETING_001', (error as Error).message, 401)
  }
})
