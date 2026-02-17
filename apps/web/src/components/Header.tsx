import { Link, NavLink, useLocation } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import LanguageSwitcher from './LanguageSwitcher'
import { useAuth } from '../lib/auth'

export default function Header() {
  const { t } = useTranslation()
  const { session, signOut } = useAuth()
  const location = useLocation()
  const isAdmin = location.pathname.startsWith('/admin')

  return (
    <header style={{ padding: '1.5rem 0' }}>
      <div className="container" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <Link to="/" style={{ fontWeight: 700, fontSize: '1.1rem' }}>
          {t('common.brand')}
        </Link>
        <nav style={{ display: 'flex', gap: '1rem', alignItems: 'center' }}>
          {!isAdmin && (
            <NavLink to="/search" className="chip">
              {t('common.search')}
            </NavLink>
          )}
          {isAdmin && session && (
            <button className="button-secondary" onClick={signOut}>
              {t('admin.signOut')}
            </button>
          )}
          {!session && (
            <NavLink to="/login" className="chip">
              {t('common.admin')}
            </NavLink>
          )}
          <LanguageSwitcher />
        </nav>
      </div>
    </header>
  )
}
