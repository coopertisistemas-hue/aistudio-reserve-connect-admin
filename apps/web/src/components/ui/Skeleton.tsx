import type { CSSProperties } from 'react'

interface SkeletonProps {
  width?: string | number
  height?: string | number
  borderRadius?: string | number
  className?: string
  style?: CSSProperties
}

export function Skeleton({ 
  width = '100%', 
  height = '20px', 
  borderRadius = '8px',
  className = '',
  style
}: SkeletonProps) {
  return (
    <div
      className={`skeleton ${className}`}
      style={{
        width,
        height,
        borderRadius,
        background: 'linear-gradient(90deg, var(--sand-200) 25%, var(--sand-100) 50%, var(--sand-200) 75%)',
        backgroundSize: '200% 100%',
        animation: 'skeleton-loading 1.5s ease-in-out infinite',
        ...style
      }}
    />
  )
}

export function SkeletonCard() {
  return (
    <div className="card" style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
      <Skeleton height="180px" borderRadius="12px" />
      <Skeleton width="70%" height="24px" />
      <Skeleton width="50%" height="16px" />
      <div style={{ display: 'flex', gap: '0.5rem', marginTop: '0.5rem' }}>
        <Skeleton width="80px" height="32px" borderRadius="999px" />
        <Skeleton width="80px" height="32px" borderRadius="999px" />
      </div>
    </div>
  )
}

export function SkeletonText({ lines = 3 }: { lines?: number }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
      {Array.from({ length: lines }).map((_, i) => (
        <Skeleton 
          key={i} 
          width={i === lines - 1 ? '60%' : '100%'} 
          height="16px" 
        />
      ))}
    </div>
  )
}

export function SkeletonKpi() {
  return (
    <div className="card" style={{ textAlign: 'center' }}>
      <Skeleton width="60px" height="40px" style={{ margin: '0 auto' }} />
      <Skeleton width="100px" height="16px" style={{ margin: '0.5rem auto 0' }} />
    </div>
  )
}
