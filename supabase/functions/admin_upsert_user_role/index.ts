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
    const actor = await requireAdminPermission(req, supabaseAdmin, 'users', 'write')
    const body = await req.json().catch(() => ({}))

    const userEmail = String(body?.user_email || '').trim().toLowerCase()
    const roleSlug = String(body?.role_slug || '').trim()
    const isActive = body?.is_active === undefined ? true : Boolean(body.is_active)

    if (!userEmail || !roleSlug) {
      throw new Error('user_email and role_slug are required')
    }

    const { data, error } = await supabaseAdmin.rpc('admin_assign_user_role', {
      p_user_email: userEmail,
      p_role_slug: roleSlug,
      p_is_active: isActive,
      p_assigned_by: actor.email || 'admin_api',
    })

    if (error) throw error
    return createSuccessResponse(data)
  } catch (error) {
    console.error('admin_upsert_user_role error:', (error as Error).message)
    return createErrorResponse('ADMIN_RBAC_002', (error as Error).message, 400)
  }
})
