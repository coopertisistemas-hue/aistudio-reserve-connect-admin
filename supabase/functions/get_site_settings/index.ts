import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { requireAdmin, corsHeaders, createErrorResponse, createSuccessResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

async function logAdminAction(
  userId: string,
  action: string,
  tableName: string,
  recordId?: string,
  oldData?: unknown,
  newData?: unknown,
  req?: Request
) {
  try {
    await supabaseAdmin
      .from('admin_audit_log')
      .insert({
        user_id: userId,
        action,
        table_name: tableName,
        record_id: recordId,
        old_data: oldData,
        new_data: newData,
        ip_address: req?.headers.get('x-forwarded-for') || req?.headers.get('x-real-ip'),
        user_agent: req?.headers.get('user-agent')
      })
  } catch (error) {
    console.error('Failed to log admin action:', error)
  }
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Validate admin authentication
    const admin = await requireAdmin(req, supabaseAdmin)
    
    // Get tenant_id from request or use default
    const body = await req.json().catch(() => ({}))
    const tenantId = body.tenant_id || '00000000-0000-0000-0000-000000000000'
    
    // Get site settings for tenant
    const { data, error } = await supabaseAdmin
      .from('site_settings')
      .select('*')
      .eq('tenant_id', tenantId)
      .single()
    
    if (error && error.code !== 'PGRST116') { // PGRST116 = no rows
      throw error
    }

    // Return default settings if none found
    const settings = data || {
      tenant_id: tenantId,
      site_name: 'Reserve Connect',
      primary_cta_label: '',
      primary_cta_link: '',
      contact_email: '',
      contact_phone: '',
      whatsapp: '',
      meta_title: '',
      meta_description: ''
    }

    return createSuccessResponse(settings)
  } catch (error) {
    console.error('get_site_settings error:', error.message)
    return createErrorResponse('SITE_SETTINGS_001', error.message, 401)
  }
})
