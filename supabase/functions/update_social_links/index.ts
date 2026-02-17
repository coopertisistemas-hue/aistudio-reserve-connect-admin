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
    const { tenant_id, social_links } = body

    const tenantId = tenant_id || '00000000-0000-0000-0000-000000000000'

    // Validate input
    if (!Array.isArray(social_links)) {
      throw new Error('social_links must be an array')
    }

    // Get old data for audit log
    const { data: oldData } = await supabaseAdmin
      .from('social_links')
      .select('*')
      .eq('tenant_id', tenantId)

    // Delete existing links for this tenant
    await supabaseAdmin
      .from('social_links')
      .delete()
      .eq('tenant_id', tenantId)

    // Insert new links
    const linksToInsert = social_links
      .filter((link: { platform: string; url: string; active?: boolean }) => 
        link.platform && link.url
      )
      .map((link: { platform: string; url: string; active?: boolean }) => ({
        tenant_id: tenantId,
        platform: link.platform,
        url: link.url,
        active: link.active !== false // default to true
      }))

    let data = []
    if (linksToInsert.length > 0) {
      const { data: insertedData, error } = await supabaseAdmin
        .from('social_links')
        .insert(linksToInsert)
        .select()
      
      if (error) throw error
      data = insertedData || []
    }

    // Log admin action
    await logAdminAction(
      admin.id,
      'UPDATE',
      'social_links',
      undefined,
      oldData,
      data,
      req
    )

    return createSuccessResponse(data)
  } catch (error) {
    console.error('update_social_links error:', error.message)
    return createErrorResponse('SOCIAL_LINKS_002', error.message, 400)
  }
})
