import { useTranslation } from 'react-i18next'
import { useAuth } from '../../lib/auth'
import LanguageSwitcher from '../LanguageSwitcher'

interface AdminTopbarProps {
  title?: string
}

export default function AdminTopbar({ title }: AdminTopbarProps) {
  const { t } = useTranslation()
  const { signOut } = useAuth()

  return (
    <header
      style={{
        height: '64px',
        background: '#fff',
        borderBottom: '1px solid var(--sand-200)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: '0 1.5rem',
        position: 'sticky',
        top: 0,
        zIndex: 100
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
        {title && (
          <h1
            style={{
              fontSize: '1.25rem',
              fontWeight: 600,
              color: 'var(--ink-900)',
              margin: 0
            }}
          >
            {title}
          </h1>
        )}
      </div>

      <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
        <LanguageSwitcher />
        <div style={{ width: '1px', height: '24px', background: 'var(--sand-200)' }} />
        <button
          onClick={signOut}
          className="button-secondary"
          style={{
            fontSize: '0.875rem',
            padding: '0.5rem 1rem'
          }}
        >
          {t('admin.signOut')}
        </button>
      </div>
    </header>
  )
}
