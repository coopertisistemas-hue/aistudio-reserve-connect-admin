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
    // Validate admin authentication (bypass removed)
    await requireAdmin(req, supabaseAdmin)
    
    const { city_code } = await req.json().catch(() => ({}))

    let query = supabaseAdmin
      .from('properties_map')
      .select('id, slug, name, city, state_province, is_active, is_published')
      .is('deleted_at', null)
      .order('created_at', { ascending: false })
      .limit(100)

    if (city_code) {
      query = query.eq('city_code', city_code)
    }

    const { data, error } = await query
    if (error) {
      throw error
    }

    const response = (data || []).map((property) => ({
      id: property.id,
      slug: property.slug,
      name: property.name,
      city: `${property.city}, ${property.state_province}`,
      status: property.is_active && property.is_published ? 'active' : 'draft'
    }))

    return createSuccessResponse(response)
  } catch (error) {
    console.error('admin_list_properties error:', error.message)
    return createErrorResponse('ADMIN_001', error.message, 401)
  }
})
