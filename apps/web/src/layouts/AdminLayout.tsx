import { NavLink, Outlet, Navigate, Link } from 'react-router-dom'
import Header from '../components/Header'
import { useAuth } from '../lib/auth'
import LoadingState from '../components/LoadingState'
import { useTranslation } from 'react-i18next'
import { useState, useEffect } from 'react'
import { postJson } from '../lib/apiClient'

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
        <Header />
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
        <Header />
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
    <div className="app-shell">
      <Header />
      <div className="container admin-grid" style={{ paddingBottom: '3rem' }}>
        <aside className="card" style={{ alignSelf: 'start' }}>
          <nav style={{ display: 'flex', flexDirection: 'column', gap: '0.8rem' }}>
            <NavLink to="/admin" end>{t('admin.dashboard')}</NavLink>
            <NavLink to="/admin/properties">{t('admin.properties')}</NavLink>
            <NavLink to="/admin/reservations">{t('admin.reservations')}</NavLink>
            <NavLink to="/admin/ops">{t('admin.ops')}</NavLink>
          </nav>
        </aside>
        <main style={{ minHeight: '60vh' }}>
          <Outlet />
        </main>
      </div>
    </div>
  )
}
