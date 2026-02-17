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
    
    // Get request body
    const body = await req.json()
    const {
      tenant_id,
      site_name,
      primary_cta_label,
      primary_cta_link,
      contact_email,
      contact_phone,
      whatsapp,
      meta_title,
      meta_description
    } = body

    const tenantId = tenant_id || '00000000-0000-0000-0000-000000000000'

    // Get old data for audit log
    const { data: oldData } = await supabaseAdmin
      .from('site_settings')
      .select('*')
      .eq('tenant_id', tenantId)
      .single()

    // Upsert site settings
    const { data, error } = await supabaseAdmin
      .from('site_settings')
      .upsert({
        tenant_id: tenantId,
        site_name,
        primary_cta_label,
        primary_cta_link,
        contact_email,
        contact_phone,
        whatsapp,
        meta_title,
        meta_description,
        updated_at: new Date().toISOString()
      }, {
        onConflict: 'tenant_id'
      })
      .select()
      .single()
    
    if (error) {
      throw error
    }

    // Log admin action
    await logAdminAction(
      admin.id,
      oldData ? 'UPDATE' : 'CREATE',
      'site_settings',
      data.id,
      oldData,
      data,
      req
    )

    return createSuccessResponse(data)
  } catch (error) {
    console.error('update_site_settings error:', error.message)
    return createErrorResponse('SITE_SETTINGS_002', error.message, 400)
  }
})
