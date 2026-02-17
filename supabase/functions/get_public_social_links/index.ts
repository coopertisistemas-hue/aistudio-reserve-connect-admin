import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { corsHeaders, createErrorResponse } from '../_shared/auth.ts'

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
    
    // Get active social links for tenant
    const { data, error } = await supabaseAdmin
      .from('social_links')
      .select('platform, url, active')
      .eq('tenant_id', tenantId)
      .eq('active', true)
      .order('platform')
    
    if (error) {
      throw error
    }

    // Return with cache headers
    return new Response(
      JSON.stringify({
        success: true,
        data: data || []
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
    console.error('get_public_social_links error:', error.message)
    return createErrorResponse('PUBLIC_SOCIAL_LINKS_001', error.message, 500)
  }
})
