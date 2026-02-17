import { Outlet, Navigate, Link } from 'react-router-dom'
import { useAuth } from '../lib/auth'
import LoadingState from '../components/LoadingState'
import { useTranslation } from 'react-i18next'
import { useState, useEffect } from 'react'
import { postJson } from '../lib/apiClient'
import AdminSidebar from '../components/admin/AdminSidebar'
import AdminTopbar from '../components/admin/AdminTopbar'

export default function AdminLayout() {
  const { session, loading } = useAuth()
  const { t } = useTranslation()
  const [isAuthorized, setIsAuthorized] = useState<boolean | null>(null)
  const [authLoading, setAuthLoading] = useState(false)

  useEffect(() => {
    if (!session) {
      setIsAuthorized(null)
      return
    }

    let active = true
    const checkAuth = async () => {
      setAuthLoading(true)
      try {
        // Try to call an admin endpoint to verify authorization
        await postJson('admin_ops_summary', {}, { auth: true })
        if (active) setIsAuthorized(true)
      } catch (error: any) {
        // If we get a 403 or similar, user is not authorized
        if (active) setIsAuthorized(false)
      } finally {
        if (active) setAuthLoading(false)
      }
    }
    checkAuth()
    return () => { active = false }
  }, [session])

  if (loading || authLoading) {
    return (
      <div className="app-shell">
        <div className="container" style={{ padding: '2rem 0' }}>
          <LoadingState />
        </div>
      </div>
    )
  }

  if (!session) {
    return <Navigate to="/login" replace />
  }

  if (isAuthorized === false) {
    return (
      <div className="app-shell">
        <div className="container" style={{ padding: '4rem 0' }}>
          <div className="card" style={{ maxWidth: '480px', margin: '0 auto', textAlign: 'center' }}>
            <h1 className="headline">{t('admin.notAuthorized')}</h1>
            <p className="muted" style={{ marginTop: '1rem' }}>{t('admin.notAuthorizedMessage')}</p>
            <Link to="/" className="button-primary" style={{ marginTop: '1.5rem', display: 'inline-block' }}>
              {t('common.back')}
            </Link>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="app-shell" style={{ display: 'flex', flexDirection: 'column' }}>
      <AdminTopbar />
      <div style={{ display: 'flex', flex: 1 }}>
        <AdminSidebar />
        <main
          style={{
            flex: 1,
            padding: '2rem',
            background: 'var(--sand-100)',
            minHeight: 'calc(100vh - 64px)'
          }}
        >
          <Outlet />
        </main>
      </div>
    </div>
  )
}
