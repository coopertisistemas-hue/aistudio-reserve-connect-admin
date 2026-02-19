import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { corsHeaders, createSuccessResponse, createErrorResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

// Cache duration in seconds (5 minutes)
const CACHE_MAX_AGE = 300

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
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

    // Return settings or defaults
    const settings = {
      site_name: data?.site_name || 'Reserve Connect',
      primary_cta_label: data?.primary_cta_label || '',
      primary_cta_link: data?.primary_cta_link || '/search',
      contact_email: data?.contact_email || '',
      contact_phone: data?.contact_phone || '',
      whatsapp: data?.whatsapp || '',
      meta_title: data?.meta_title || '',
      meta_description: data?.meta_description || ''
    }

    // Return with cache headers
    return new Response(
      JSON.stringify({
        success: true,
        data: settings
      }),
      {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
          'Cache-Control': `public, max-age=${CACHE_MAX_AGE}`,
          'CDN-Cache-Control': `public, max-age=${CACHE_MAX_AGE}`
        }
      }
    )
  } catch (error) {
    console.error('get_public_site_settings error:', error.message)
    return createErrorResponse('PUBLIC_SITE_SETTINGS_001', error.message, 500)
  }
})
