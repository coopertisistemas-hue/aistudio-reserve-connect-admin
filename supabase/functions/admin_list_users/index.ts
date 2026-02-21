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
    await requireAdminPermission(req, supabaseAdmin, 'users', 'read')

    const { data: authData, error: authError } = await supabaseAdmin.auth.admin.listUsers({
      page: 1,
      perPage: 500,
    })

    if (authError) throw authError

    const { data: assignments, error: assignmentError } = await supabaseAdmin.rpc('admin_list_user_role_assignments')
    if (assignmentError) throw assignmentError

    const byEmail = new Map<string, { role_slug: string; role_name: string; is_active: boolean }[]>()
    for (const row of assignments || []) {
      const email = String(row.user_email || '').toLowerCase()
      const list = byEmail.get(email) || []
      list.push({
        role_slug: String(row.role_slug || ''),
        role_name: String(row.role_name || ''),
        is_active: Boolean(row.is_active),
      })
      byEmail.set(email, list)
    }

    const result = (authData?.users || []).map((user) => {
      const email = String(user.email || '').toLowerCase()
      const roles = byEmail.get(email) || []
      return {
        id: user.id,
        email: user.email,
        created_at: user.created_at,
        last_sign_in_at: user.last_sign_in_at,
        app_role: (user.app_metadata as Record<string, unknown> | null)?.role || null,
        roles,
      }
    })

    return createSuccessResponse(result)
  } catch (error) {
    console.error('admin_list_users error:', (error as Error).message)
    return createErrorResponse('ADMIN_RBAC_001', (error as Error).message, 401)
  }
})
