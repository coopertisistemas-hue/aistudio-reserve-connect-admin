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
    
    // Get social links from database
    const { data, error } = await supabaseAdmin
      .from('social_links')
      .select('*')
      .single()
    
    if (error && error.code !== 'PGRST116') { // PGRST116 = no rows
      throw error
    }

    // Return default links if none found
    const links = data || {
      facebook: '',
      instagram: '',
      twitter: '',
      youtube: '',
      whatsapp: ''
    }

    return createSuccessResponse(links)
  } catch (error) {
    console.error('get_social_links error:', error.message)
    return createErrorResponse('SOCIAL_LINKS_001', error.message, 401)
  }
})
