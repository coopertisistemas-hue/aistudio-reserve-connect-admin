import { useTranslation } from 'react-i18next'
import { SkeletonText } from './ui/Skeleton'

interface LoadingStateProps {
  message?: string
  variant?: 'text' | 'skeleton'
}

export default function LoadingState({ message, variant = 'text' }: LoadingStateProps) {
  const { t } = useTranslation()
  
  if (variant === 'skeleton') {
    return (
      <div style={{ padding: '2rem 0' }}>
        <SkeletonText lines={3} />
      </div>
    )
  }
  
  return (
    <div 
      className="card" 
      style={{ 
        textAlign: 'center',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        gap: '1rem'
      }}
    >
      <div 
        style={{ 
          width: '40px',
          height: '40px',
          border: '3px solid var(--sand-200)',
          borderTopColor: 'var(--accent-500)',
          borderRadius: '50%',
          animation: 'spin 1s linear infinite'
        }} 
      />
      <div style={{ fontSize: '0.95rem', color: 'var(--ink-500)' }}>
        {message || t('common.loading')}
      </div>
    </div>
  )
}
