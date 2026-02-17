import { useTranslation } from 'react-i18next'

export default function LoadingState({ message }: { message?: string }) {
  const { t } = useTranslation()
  return (
    <div className="card" style={{ textAlign: 'center' }}>
      <div style={{ fontSize: '0.95rem', color: 'var(--ink-500)' }}>
        {message || t('common.loading')}
      </div>
    </div>
  )
}
