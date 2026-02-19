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
    // Validate admin authentication (bypass removed)
    await requireAdmin(req, supabaseAdmin)

    const { data: health, error: healthError } = await supabaseAdmin
      .rpc('admin_ops_health_checks')

    if (healthError) {
      throw healthError
    }

    const { data: summary, error: summaryError } = await supabaseAdmin
      .rpc('admin_ops_snapshot')

    if (summaryError) {
      throw summaryError
    }

    return createSuccessResponse({
      health: health || [],
      snapshot: summary
    })
  } catch (error) {
    console.error('admin_ops_summary error:', error.message)
    return createErrorResponse('ADMIN_003', error.message, 401)
  }
})
