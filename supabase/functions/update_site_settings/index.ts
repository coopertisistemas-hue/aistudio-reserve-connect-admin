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
    
    // Get request body
    const body = await req.json()
    const {
      site_name,
      site_description,
      contact_email,
      phone,
      address,
      meta_title,
      meta_description
    } = body

    // Upsert site settings
    const { data, error } = await supabaseAdmin
      .from('site_settings')
      .upsert({
        id: 1, // Single row for site settings
        site_name,
        site_description,
        contact_email,
        phone,
        address,
        meta_title,
        meta_description,
        updated_at: new Date().toISOString()
      }, {
        onConflict: 'id'
      })
      .select()
      .single()
    
    if (error) {
      throw error
    }

    return createSuccessResponse(data)
  } catch (error) {
    console.error('update_site_settings error:', error.message)
    return createErrorResponse('SITE_SETTINGS_002', error.message, 400)
  }
})
