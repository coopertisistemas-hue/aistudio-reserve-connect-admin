import { useTranslation } from 'react-i18next'
import { useSiteSettings, useSocialLinks } from '../hooks/useSiteSettings'
import { SkeletonText } from './ui/Skeleton'

const PLATFORM_ICONS: Record<string, string> = {
  instagram: '📷',
  facebook: '👥',
  tiktok: '🎵',
  youtube: '▶️',
  linkedin: '💼',
  twitter: '🐦'
}

const PLATFORM_LABELS: Record<string, string> = {
  instagram: 'Instagram',
  facebook: 'Facebook',
  tiktok: 'TikTok',
  youtube: 'YouTube',
  linkedin: 'LinkedIn',
  twitter: 'Twitter'
}

export default function Footer() {
  const { t } = useTranslation()
  const { settings, loading: settingsLoading } = useSiteSettings()
  const { links, loading: linksLoading } = useSocialLinks()

  const siteName = settings?.site_name || t('common.brand')
  const contactEmail = settings?.contact_email
  const contactPhone = settings?.contact_phone
  const whatsapp = settings?.whatsapp

  const loading = settingsLoading || linksLoading

  return (
    <footer style={{ marginTop: 'auto', padding: '2rem 0', borderTop: '1px solid var(--sand-200)' }}>
      <div className="container">
        {loading ? (
          <SkeletonText lines={3} />
        ) : (
          <>
            <div style={{ 
              display: 'flex', 
              flexDirection: 'column', 
              gap: '1.5rem',
              marginBottom: '2rem'
            }}>
              <strong style={{ fontSize: '1.1rem' }}>{siteName}</strong>
              
              {/* Contact Info */}
              {(contactEmail || contactPhone || whatsapp) && (
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: '1rem' }}>
                  {contactEmail && (
                    <a 
                      href={`mailto:${contactEmail}`}
                      className="muted"
                      style={{ textDecoration: 'none' }}
                    >
                      📧 {contactEmail}
                    </a>
                  )}
                  {contactPhone && (
                    <a 
                      href={`tel:${contactPhone}`}
                      className="muted"
                      style={{ textDecoration: 'none' }}
                    >
                      📞 {contactPhone}
                    </a>
                  )}
                  {whatsapp && (
                    <a 
                      href={`https://wa.me/${whatsapp.replace(/\D/g, '')}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="muted"
                      style={{ textDecoration: 'none' }}
                    >
                      💬 WhatsApp
                    </a>
                  )}
                </div>
              )}

              {/* Social Links */}
              {links.length > 0 && (
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: '1rem', alignItems: 'center' }}>
                  <span className="muted">{t('admin.socialLinks.title')}:</span>
                  {links.map((link) => (
                    <a
                      key={link.platform}
                      href={link.url}
                      target="_blank"
                      rel="noopener noreferrer"
                      style={{
                        display: 'flex',
                        alignItems: 'center',
                        gap: '0.25rem',
                        textDecoration: 'none',
                        color: 'var(--ink-700)',
                        fontSize: '0.9rem'
                      }}
                      aria-label={PLATFORM_LABELS[link.platform] || link.platform}
                    >
                      <span>{PLATFORM_ICONS[link.platform] || '🔗'}</span>
                      <span>{PLATFORM_LABELS[link.platform] || link.platform}</span>
                    </a>
                  ))}
                </div>
              )}
            </div>

            <div className="divider" />
            
            <div style={{ 
              display: 'flex', 
              flexDirection: 'column', 
              gap: '0.5rem',
              fontSize: '0.875rem'
            }}>
              <span className="muted">
                {t('landing.trustTitle')} · {new Date().getFullYear()}
              </span>
            </div>
          </>
        )}
      </div>
    </footer>
  )
}
