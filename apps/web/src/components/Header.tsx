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
    <header 
      style={{ 
        padding: '1.25rem 0',
        position: 'sticky',
        top: 0,
        background: 'rgba(245, 243, 239, 0.9)',
        backdropFilter: 'blur(10px)',
        zIndex: 100,
        borderBottom: '1px solid var(--sand-200)'
      }}
    >
      <div className="container" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <Link 
          to="/" 
          style={{ 
            fontWeight: 700, 
            fontSize: '1.25rem',
            fontFamily: "'Playfair Display', serif",
            display: 'flex',
            alignItems: 'center',
            gap: '0.5rem'
          }}
        >
          <span style={{ 
            width: '32px', 
            height: '32px', 
            background: 'var(--accent-500)',
            borderRadius: '8px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: '#fff',
            fontSize: '1rem'
          }}>R</span>
          {t('common.brand')}
        </Link>
        
        <nav style={{ display: 'flex', gap: '1rem', alignItems: 'center' }}>
          {!isAdmin && (
            <NavLink 
              to="/search" 
              className="chip"
              style={({ isActive }) => ({
                background: isActive ? 'var(--accent-500)' : 'var(--sage-100)',
                color: isActive ? '#fff' : 'var(--sage-500)',
                transition: 'all 0.2s ease'
              })}
            >
              {t('common.search')}
            </NavLink>
          )}
          
          {isAdmin && session && (
            <button 
              className="button-secondary" 
              onClick={signOut}
              style={{ fontSize: '0.9rem' }}
            >
              {t('admin.signOut')}
            </button>
          )}
          
          {!session && !isAdmin && (
            <NavLink 
              to="/login" 
              className="chip"
              style={({ isActive }) => ({
                background: isActive ? 'var(--accent-500)' : 'var(--sage-100)',
                color: isActive ? '#fff' : 'var(--sage-500)',
                transition: 'all 0.2s ease'
              })}
            >
              {t('common.admin')}
            </NavLink>
          )}
          
          <LanguageSwitcher />
        </nav>
      </div>
    </header>
  )
}
