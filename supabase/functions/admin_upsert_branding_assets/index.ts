import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { requireAdminPermission, corsHeaders, createErrorResponse, createSuccessResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

function isValidHttpUrl(value: string) {
  if (!value) return true
  try {
    const url = new URL(value)
    return url.protocol === 'http:' || url.protocol === 'https:'
  } catch {
    return false
  }
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    await requireAdminPermission(req, supabaseAdmin, 'marketing', 'write')
    const body = await req.json().catch(() => ({}))

    const tenantId = body?.tenant_id || '00000000-0000-0000-0000-000000000000'
    const logoUrl = String(body?.logo_url || '').trim()
    const faviconUrl = String(body?.favicon_url || '').trim()

    if (!isValidHttpUrl(logoUrl) || !isValidHttpUrl(faviconUrl)) {
      throw new Error('logo_url and favicon_url must be valid http(s) URLs')
    }

    const { data, error } = await supabaseAdmin
      .from('branding_assets')
      .upsert({
        tenant_id: tenantId,
        logo_url: logoUrl || null,
        favicon_url: faviconUrl || null,
        updated_at: new Date().toISOString(),
      }, { onConflict: 'tenant_id' })
      .select('*')
      .single()

    if (error) throw error
    return createSuccessResponse(data)
  } catch (error) {
    console.error('admin_upsert_branding_assets error:', (error as Error).message)
    return createErrorResponse('ADMIN_MARKETING_004', (error as Error).message, 400)
  }
})
