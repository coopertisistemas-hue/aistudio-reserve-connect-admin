import { NavLink } from 'react-router-dom'
import { useTranslation } from 'react-i18next'

interface NavItemProps {
  to: string
  icon: string
  label: string
  end?: boolean
}

function NavItem({ to, icon, label, end = false }: NavItemProps) {
  return (
    <NavLink
      to={to}
      end={end}
      style={({ isActive }) => ({
        display: 'flex',
        alignItems: 'center',
        gap: '0.75rem',
        padding: '0.75rem 1rem',
        borderRadius: '12px',
        textDecoration: 'none',
        color: isActive ? '#fff' : 'var(--ink-700)',
        background: isActive ? 'var(--accent-500)' : 'transparent',
        fontWeight: isActive ? 600 : 500,
        fontSize: '0.9rem',
        transition: 'all 0.2s ease'
      })}
    >
      <span style={{ fontSize: '1.1rem' }}>{icon}</span>
      <span>{label}</span>
    </NavLink>
  )
}

export default function AdminSidebar() {
  const { t } = useTranslation('admin_sidebar')

  return (
    <aside
      style={{
        width: '260px',
        minHeight: 'calc(100vh - 80px)',
        background: '#fff',
        borderRight: '1px solid var(--sand-200)',
        padding: '1.5rem',
        display: 'flex',
        flexDirection: 'column',
        gap: '0.5rem'
      }}
    >
      <div style={{ marginBottom: '1rem' }}>
        <h3
          style={{
            fontSize: '0.75rem',
            textTransform: 'uppercase',
            letterSpacing: '0.05em',
            color: 'var(--ink-500)',
            margin: '0 0 0.75rem 0',
            paddingLeft: '1rem'
          }}
        >
          {t('mainMenu')}
        </h3>
        <NavItem
          to="/admin"
          icon="📊"
          label={t('dashboard')}
          end
        />
        <NavItem
          to="/admin/reservations"
          icon="📅"
          label={t('reservations')}
        />
        <NavItem
          to="/admin/payments"
          icon="💳"
          label={t('payments')}
        />
        <NavItem
          to="/admin/financial"
          icon="💰"
          label={t('financial')}
        />
      </div>

      <div style={{ marginBottom: '1rem' }}>
        <h3
          style={{
            fontSize: '0.75rem',
            textTransform: 'uppercase',
            letterSpacing: '0.05em',
            color: 'var(--ink-500)',
            margin: '0 0 0.75rem 0',
            paddingLeft: '1rem'
          }}
        >
          {t('management')}
        </h3>
        <NavItem
          to="/admin/marketing"
          icon="📢"
          label={t('marketing')}
        />
        <NavItem
          to="/admin/tasks"
          icon="✓"
          label={t('tasks')}
        />
        <NavItem
          to="/admin/reports"
          icon="📈"
          label={t('reports')}
        />
        <NavItem
          to="/admin/users"
          icon="👥"
          label={t('users')}
        />
      </div>

      <div style={{ marginTop: 'auto' }}>
        <h3
          style={{
            fontSize: '0.75rem',
            textTransform: 'uppercase',
            letterSpacing: '0.05em',
            color: 'var(--ink-500)',
            margin: '0 0 0.75rem 0',
            paddingLeft: '1rem'
          }}
        >
          {t('support')}
        </h3>
        <NavItem
          to="/admin/settings"
          icon="⚙️"
          label={t('settings')}
        />
      </div>
    </aside>
  )
}
