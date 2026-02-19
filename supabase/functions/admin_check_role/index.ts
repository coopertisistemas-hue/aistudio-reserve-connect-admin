import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { requireAdmin, corsHeaders, createErrorResponse, createSuccessResponse, isAdmin } from '../_shared/auth.ts'

const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Get user from JWT
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      throw new Error('Missing authorization header')
    }
    
    const token = authHeader.replace('Bearer ', '').trim()
    const { data: { user }, error: userError } = await supabaseAdmin.auth.getUser(token)
    
    if (userError || !user) {
      throw new Error('Invalid authentication token')
    }

    // Determine role
    const role = user.app_metadata?.role || user.user_metadata?.role || 'viewer'
    const adminStatus = isAdmin(user)
    
    // Define permissions based on role
    let permissions: string[] = []
    
    if (adminStatus || role === 'admin') {
      permissions = [
        'dashboard:view',
        'properties:read',
        'properties:write',
        'reservations:read',
        'reservations:write',
        'reservations:cancel',
        'operations:run',
        'marketing:read',
        'marketing:write'
      ]
    } else if (role === 'manager') {
      permissions = [
        'dashboard:view',
        'properties:read',
        'reservations:read',
        'reservations:write',
        'reservations:cancel',
        'marketing:read',
        'marketing:write'
      ]
    } else {
      permissions = [
        'dashboard:view',
        'properties:read',
        'reservations:read'
      ]
    }

    return createSuccessResponse({
      role: adminStatus ? 'admin' : role,
      permissions,
      user: {
        id: user.id,
        email: user.email
      }
    })
  } catch (error) {
    console.error('admin_check_role error:', error.message)
    return createErrorResponse('RBAC_001', error.message, 401)
  }
})
