import type { CSSProperties } from 'react'

interface BadgeProps {
  children: React.ReactNode
  variant?: 'default' | 'success' | 'warning' | 'error' | 'info'
  size?: 'sm' | 'md'
  style?: CSSProperties
}

export function Badge({ 
  children, 
  variant = 'default', 
  size = 'md',
  style 
}: BadgeProps) {
  const variants = {
    default: {
      background: 'var(--sage-100)',
      color: 'var(--sage-500)'
    },
    success: {
      background: '#e4eee8',
      color: '#3f5a4d'
    },
    warning: {
      background: '#fff4e6',
      color: '#b0662b'
    },
    error: {
      background: '#ffeaea',
      color: '#c83232'
    },
    info: {
      background: '#e8f4ff',
      color: '#0066cc'
    }
  }

  const sizes = {
    sm: {
      padding: '0.2rem 0.5rem',
      fontSize: '0.7rem'
    },
    md: {
      padding: '0.3rem 0.7rem',
      fontSize: '0.75rem'
    }
  }

  const variantStyle = variants[variant]
  const sizeStyle = sizes[size]

  return (
    <span
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '0.4rem',
        borderRadius: '999px',
        fontWeight: 600,
        textTransform: 'capitalize',
        ...variantStyle,
        ...sizeStyle,
        ...style
      }}
    >
      {children}
    </span>
  )
}
