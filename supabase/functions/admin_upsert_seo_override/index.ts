import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { requireAdminPermission, corsHeaders, createErrorResponse, createSuccessResponse } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    await requireAdminPermission(req, supabaseAdmin, 'marketing', 'write')
    const body = await req.json().catch(() => ({}))

    const cityCode = String(body?.city_code || '').trim().toUpperCase()
    const lang = String(body?.lang || '').trim().toLowerCase()
    if (!cityCode || !lang) {
      throw new Error('city_code and lang are required')
    }

    const { data, error } = await supabaseAdmin.rpc('admin_upsert_seo_override', {
      p_tenant_id: body?.tenant_id || '00000000-0000-0000-0000-000000000000',
      p_city_code: cityCode,
      p_lang: lang,
      p_meta_title: body?.meta_title || null,
      p_meta_description: body?.meta_description || null,
      p_canonical_url: body?.canonical_url || null,
      p_og_image_url: body?.og_image_url || null,
      p_noindex: Boolean(body?.noindex),
      p_is_active: body?.is_active === undefined ? true : Boolean(body?.is_active),
    })

    if (error) throw error
    return createSuccessResponse(data)
  } catch (error) {
    console.error('admin_upsert_seo_override error:', (error as Error).message)
    return createErrorResponse('ADMIN_MARKETING_002', (error as Error).message, 400)
  }
})
