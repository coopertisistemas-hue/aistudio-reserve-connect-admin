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
      facebook,
      instagram,
      twitter,
      youtube,
      whatsapp
    } = body

    // Upsert social links
    const { data, error } = await supabaseAdmin
      .from('social_links')
      .upsert({
        id: 1, // Single row for social links
        facebook,
        instagram,
        twitter,
        youtube,
        whatsapp,
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
    console.error('update_social_links error:', error.message)
    return createErrorResponse('SOCIAL_LINKS_002', error.message, 400)
  }
})
