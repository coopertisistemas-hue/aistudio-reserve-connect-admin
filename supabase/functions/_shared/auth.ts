// Shared authentication helper for admin Edge Functions
// Validates JWT and enforces admin privileges

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

export type AdminUser = {
  id: string
  email?: string | null
  app_metadata?: Record<string, unknown>
  user_metadata?: Record<string, unknown>
}

export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-session-id, x-idempotency-key',
}

/**
 * Validates JWT token and returns user
 * @param supabaseAdmin - Supabase client with service_role
 * @param token - JWT token from Authorization header
 */
export async function validateJWT(
  supabaseAdmin: ReturnType<typeof createClient>,
  token: string
): Promise<AdminUser> {
  const { data, error } = await supabaseAdmin.auth.getUser(token)
  
  if (error) {
    console.error('JWT validation error:', error.message)
    throw new Error('Invalid authentication token')
  }
  
  if (!data.user) {
    throw new Error('User not found')
  }
  
  return data.user as AdminUser
}

/**
 * Checks if user has admin privileges
 * Supports: role claim, email allowlist
 */
export function isAdmin(user: AdminUser): boolean {
  // Check role claim in JWT
  const role = user.app_metadata?.role || user.user_metadata?.role
  if (role === 'admin') {
    return true
  }
  
  // Check email allowlist
  const allowlistEnv = Deno.env.get('ADMIN_EMAIL_ALLOWLIST') ?? ''
  if (!allowlistEnv || !user.email) {
    return false
  }
  
  const allowlist = allowlistEnv
    .split(',')
    .map((email) => email.trim().toLowerCase())
    .filter(Boolean)
  
  return allowlist.includes(user.email.toLowerCase())
}

/**
 * Full auth validation pipeline
 * @throws Error if authentication fails or user is not admin
 */
export async function requireAdmin(
  req: Request,
  supabaseAdmin: ReturnType<typeof createClient>
): Promise<AdminUser> {
  const authHeader = req.headers.get('Authorization')
  
  if (!authHeader) {
    throw new Error('Missing authorization header')
  }
  
  const token = authHeader.replace('Bearer ', '').trim()
  
  if (!token) {
    throw new Error('Missing bearer token')
  }
  
  // Validate JWT
  const user = await validateJWT(supabaseAdmin, token)
  
  // Check admin privileges
  if (!isAdmin(user)) {
    console.warn(`Non-admin access attempt: ${user.email}`)
    throw new Error('Admin access required')
  }
  
  console.log(`Admin access granted: ${user.email}`)
  return user
}

/**
 * Creates standardized error response
 */
export function createErrorResponse(
  code: string,
  message: string,
  status: number = 401
): Response {
  return new Response(
    JSON.stringify({
      success: false,
      error: {
        code,
        message,
      },
    }),
    {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status,
    }
  )
}

/**
 * Creates standardized success response
 */
export function createSuccessResponse(data: unknown): Response {
  return new Response(
    JSON.stringify({
      success: true,
      data,
    }),
    {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    }
  )
}
