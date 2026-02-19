import { useEffect, useState } from 'react'
import { useAuth } from './auth'
import { postJson } from './apiClient'

export type UserRole = 'admin' | 'manager' | 'viewer'

interface UserPermissions {
  role: UserRole
  permissions: string[]
  isAdmin: boolean
  isManager: boolean
  canEdit: boolean
}

export function useRBAC() {
  const { session } = useAuth()
  const [permissions, setPermissions] = useState<UserPermissions | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!session) {
      setPermissions(null)
      setLoading(false)
      return
    }

    let active = true
    const checkPermissions = async () => {
      setLoading(true)
      setError(null)
      try {
        // Try to call an admin endpoint to verify role
        const response = await postJson<{ data: { role: UserRole; permissions: string[] } }>(
          'admin_check_role',
          {},
          { auth: true }
        )
        
        if (active) {
          const role = response.data.role
          setPermissions({
            role,
            permissions: response.data.permissions || [],
            isAdmin: role === 'admin',
            isManager: role === 'admin' || role === 'manager',
            canEdit: role === 'admin' || role === 'manager'
          })
        }
      } catch (err: any) {
        if (active) {
          setPermissions(null)
          setError(err.message || 'Failed to check permissions')
        }
      } finally {
        if (active) setLoading(false)
      }
    }

    checkPermissions()
    return () => { active = false }
  }, [session])

  const hasPermission = (permission: string): boolean => {
    if (!permissions) return false
    if (permissions.isAdmin) return true
    return permissions.permissions.includes(permission)
  }

  const requirePermission = (permission: string): boolean => {
    return hasPermission(permission)
  }

  return {
    permissions,
    loading,
    error,
    hasPermission,
    requirePermission,
    isAuthenticated: !!session,
    isAdmin: permissions?.isAdmin || false,
    isManager: permissions?.isManager || false,
    canEdit: permissions?.canEdit || false
  }
}

// Route guard hook
export function useAdminGuard() {
  const { session, loading: authLoading } = useAuth()
  const { permissions, loading: rbacLoading, error } = useRBAC()
  
  const loading = authLoading || rbacLoading
  
  const isAuthorized = !!session && !!permissions && (permissions.isAdmin || permissions.isManager)
  
  return {
    loading,
    isAuthorized,
    error,
    session
  }
}
