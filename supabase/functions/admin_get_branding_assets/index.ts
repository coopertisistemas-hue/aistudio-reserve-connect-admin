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
    const tenantId = body?.tenant_id || '00000000-0000-0000-0000-000000000000'

    const { data, error } = await supabaseAdmin
      .from('branding_assets')
      .select('*')
      .eq('tenant_id', tenantId)
      .maybeSingle()

    if (error) throw error

    return createSuccessResponse(data || {
      tenant_id: tenantId,
      logo_url: '',
      favicon_url: '',
    })
  } catch (error) {
    console.error('admin_get_branding_assets error:', (error as Error).message)
    return createErrorResponse('ADMIN_MARKETING_003', (error as Error).message, 401)
  }
})
