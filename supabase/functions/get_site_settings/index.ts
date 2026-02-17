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
    
    // Get site settings from database
    const { data, error } = await supabaseAdmin
      .from('site_settings')
      .select('*')
      .single()
    
    if (error && error.code !== 'PGRST116') { // PGRST116 = no rows
      throw error
    }

    // Return default settings if none found
    const settings = data || {
      site_name: 'Reserve Connect',
      site_description: '',
      contact_email: '',
      phone: '',
      address: '',
      meta_title: '',
      meta_description: ''
    }

    return createSuccessResponse(settings)
  } catch (error) {
    console.error('get_site_settings error:', error.message)
    return createErrorResponse('SITE_SETTINGS_001', error.message, 401)
  }
})
