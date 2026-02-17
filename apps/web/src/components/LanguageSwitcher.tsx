import { useTranslation } from 'react-i18next'
import { setLanguage } from '../i18n'

const languages = [
  { code: 'pt', label: 'PT' },
  { code: 'en', label: 'EN' },
  { code: 'es', label: 'ES' },
]

export default function LanguageSwitcher() {
  const { i18n } = useTranslation()

  return (
    <div style={{ display: 'flex', gap: '0.5rem' }}>
      {languages.map((lang) => (
        <button
          key={lang.code}
          onClick={() => setLanguage(lang.code)}
          style={{
            border: '1px solid var(--sand-200)',
            padding: '0.35rem 0.6rem',
            borderRadius: '999px',
            background: i18n.language === lang.code ? 'var(--ink-900)' : 'transparent',
            color: i18n.language === lang.code ? '#fff' : 'var(--ink-700)',
            fontSize: '0.75rem',
            cursor: 'pointer',
          }}
        >
          {lang.label}
        </button>
      ))}
    </div>
  )
}
