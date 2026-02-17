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
    // Validate admin authentication
    await requireAdmin(req, supabaseAdmin)
    
    // Get tenant_id from request or use default
    const body = await req.json().catch(() => ({}))
    const tenantId = body.tenant_id || '00000000-0000-0000-0000-000000000000'
    
    // Get social links for tenant
    const { data, error } = await supabaseAdmin
      .from('social_links')
      .select('*')
      .eq('tenant_id', tenantId)
      .order('platform')
    
    if (error) {
      throw error
    }

    // Return empty array if none found
    return createSuccessResponse(data || [])
  } catch (error) {
    console.error('get_social_links error:', error.message)
    return createErrorResponse('SOCIAL_LINKS_001', error.message, 401)
  }
})
