import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
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
    await requireAdmin(req, supabaseAdmin)

    const body = await req.json().catch(() => ({}))
    const cityCode = (body?.city_code as string | undefined)?.trim()
    const status = (body?.status as string | undefined)?.trim()
    const search = (body?.search as string | undefined)?.trim()

    const { data, error } = await supabaseAdmin.rpc('admin_list_payouts', {
      p_city_code: cityCode || null,
      p_status: status || null,
      p_search: search || null,
      p_limit: 300,
    })

    if (error) {
      throw error
    }

    return createSuccessResponse(data || [])
  } catch (error) {
    console.error('admin_list_payouts error:', error.message)
    return createErrorResponse('ADMIN_008', error.message, 401)
  }
})
