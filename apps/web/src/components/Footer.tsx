import { useTranslation } from 'react-i18next'

export default function Footer() {
  const { t } = useTranslation()

  return (
    <footer style={{ marginTop: 'auto', padding: '2rem 0', borderTop: '1px solid var(--sand-200)' }}>
      <div className="container" style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
        <strong>{t('common.brand')}</strong>
        <span className="muted">Política de privacidade · Cookies · suporte@reserveconnect.com</span>
      </div>
    </footer>
  )
}
