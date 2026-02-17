import { NavLink, Outlet, Navigate } from 'react-router-dom'
import Header from '../components/Header'
import { useAuth } from '../lib/auth'
import LoadingState from '../components/LoadingState'
import { useTranslation } from 'react-i18next'

export default function AdminLayout() {
  const { session, loading } = useAuth()
  const { t } = useTranslation()

  if (loading) {
    return (
      <div className="container" style={{ padding: '2rem 0' }}>
        <LoadingState />
      </div>
    )
  }

  if (!session) {
    return <Navigate to="/login" replace />
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
