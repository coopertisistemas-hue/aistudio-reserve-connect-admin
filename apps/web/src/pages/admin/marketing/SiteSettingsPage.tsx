import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { postJson } from '../../../lib/apiClient'
import { useToast } from '../../../components/ui/Toast'
import { SkeletonText } from '../../../components/ui/Skeleton'
import { Badge } from '../../../components/ui/Badge'

interface SiteSettings {
  id?: string
  tenant_id: string
  site_name: string
  primary_cta_label: string
  primary_cta_link: string
  contact_email: string
  contact_phone: string
  whatsapp: string
  meta_title: string
  meta_description: string
  updated_at?: string
}

interface SocialLink {
  id?: string
  platform: string
  url: string
  active: boolean
}

const PLATFORMS = [
  { key: 'instagram', label: 'Instagram', icon: '📷' },
  { key: 'facebook', label: 'Facebook', icon: '👥' },
  { key: 'tiktok', label: 'TikTok', icon: '🎵' },
  { key: 'youtube', label: 'YouTube', icon: '▶️' },
  { key: 'linkedin', label: 'LinkedIn', icon: '💼' }
]

export default function SiteSettingsPage() {
  const { t } = useTranslation('admin_marketing')
  const { t: tCommon } = useTranslation('admin_common')
  const { addToast } = useToast()
  
  const [settings, setSettings] = useState<SiteSettings>({
    tenant_id: '00000000-0000-0000-0000-000000000000',
    site_name: '',
    primary_cta_label: '',
    primary_cta_link: '',
    contact_email: '',
    contact_phone: '',
    whatsapp: '',
    meta_title: '',
    meta_description: ''
  })
  
  const [socialLinks, setSocialLinks] = useState<SocialLink[]>([])
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [hasChanges, setHasChanges] = useState(false)

  useEffect(() => {
    let active = true
    const loadData = async () => {
      setLoading(true)
      setError(null)
      try {
        // Load site settings
        const settingsRes = await postJson<{ success: boolean; data: SiteSettings }>(
          'get_site_settings',
          { tenant_id: '00000000-0000-0000-0000-000000000000' },
          { auth: true }
        )
        
        // Load social links
        const linksRes = await postJson<{ success: boolean; data: SocialLink[] }>(
          'get_social_links',
          { tenant_id: '00000000-0000-0000-0000-000000000000' },
          { auth: true }
        )
        
        if (active) {
          if (settingsRes.success) {
            setSettings(settingsRes.data)
          }
          if (linksRes.success) {
            setSocialLinks(linksRes.data)
          }
        }
      } catch (err: any) {
        if (active) {
          setError(err.message || t('siteSettings.loadError'))
          addToast(err.message || t('siteSettings.loadError'), 'error')
        }
      } finally {
        if (active) setLoading(false)
      }
    }
    loadData()
    return () => { active = false }
  }, [t, addToast])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setSaving(true)
    setError(null)
    
    try {
      // Save site settings
      const settingsRes = await postJson<{ success: boolean }>(
        'update_site_settings',
        settings,
        { auth: true }
      )
      
      // Save social links
      const linksRes = await postJson<{ success: boolean }>(
        'update_social_links',
        {
          tenant_id: settings.tenant_id,
          social_links: socialLinks
        },
        { auth: true }
      )
      
      if (settingsRes.success && linksRes.success) {
        addToast(t('siteSettings.saveSuccess'), 'success')
        setHasChanges(false)
      }
    } catch (err: any) {
      setError(err.message || t('siteSettings.saveError'))
      addToast(err.message || t('siteSettings.saveError'), 'error')
    } finally {
      setSaving(false)
    }
  }

  const handleChange = (field: keyof SiteSettings, value: string) => {
    setSettings(prev => ({ ...prev, [field]: value }))
    setHasChanges(true)
  }

  const handleSocialLinkChange = (platform: string, url: string) => {
    setSocialLinks(prev => {
      const existing = prev.find(l => l.platform === platform)
      if (existing) {
        return prev.map(l => l.platform === platform ? { ...l, url } : l)
      }
      return [...prev, { platform, url, active: true }]
    })
    setHasChanges(true)
  }

  const handleSocialToggle = (platform: string) => {
    setSocialLinks(prev => {
      const existing = prev.find(l => l.platform === platform)
      if (existing) {
        return prev.map(l => l.platform === platform ? { ...l, active: !l.active } : l)
      }
      return prev
    })
    setHasChanges(true)
  }

  const getSocialUrl = (platform: string) => {
    const link = socialLinks.find(l => l.platform === platform)
    return link?.url || ''
  }

  const isSocialActive = (platform: string) => {
    const link = socialLinks.find(l => l.platform === platform)
    return link?.active || false
  }

  if (loading) {
    return (
      <div className="card" style={{ maxWidth: '800px' }}>
        <h1 className="headline" style={{ marginBottom: '2rem' }}>{t('siteSettings.title')}</h1>
        <SkeletonText lines={12} />
      </div>
    )
  }

  return (
    <div style={{ maxWidth: '800px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem' }}>
        <h1 className="headline">{t('siteSettings.title')}</h1>
        {hasChanges && <Badge variant="warning">{tCommon('unsaved')}</Badge>}
      </div>

      {error && (
        <div
          className="card"
          style={{
            marginBottom: '1.5rem',
            background: 'rgba(200,50,50,0.1)',
            borderLeft: '4px solid #c83232'
          }}
        >
          <p style={{ color: '#c83232', margin: 0 }}>{error}</p>
        </div>
      )}

      <form onSubmit={handleSubmit}>
        <div className="card" style={{ marginBottom: '1.5rem' }}>
          <h2 style={{ fontSize: '1.1rem', marginBottom: '1.5rem', color: 'var(--ink-900)' }}>
            {t('siteSettings.generalInfo')}
          </h2>
          
          <div style={{ display: 'grid', gap: '1.5rem' }}>
            <div>
              <label className="muted" style={{ display: 'block', marginBottom: '0.5rem' }}>
                {t('siteSettings.siteName')}
              </label>
              <input
                type="text"
                className="input"
                value={settings.site_name}
                onChange={(e) => handleChange('site_name', e.target.value)}
                required
              />
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
              <div>
                <label className="muted" style={{ display: 'block', marginBottom: '0.5rem' }}>
                  {t('siteSettings.primaryCtaLabel')}
                </label>
                <input
                  type="text"
                  className="input"
                  value={settings.primary_cta_label}
                  onChange={(e) => handleChange('primary_cta_label', e.target.value)}
                />
              </div>
              <div>
                <label className="muted" style={{ display: 'block', marginBottom: '0.5rem' }}>
                  {t('siteSettings.primaryCtaLink')}
                </label>
                <input
                  type="url"
                  className="input"
                  value={settings.primary_cta_link}
                  onChange={(e) => handleChange('primary_cta_link', e.target.value)}
                />
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
              <div>
                <label className="muted" style={{ display: 'block', marginBottom: '0.5rem' }}>
                  {t('siteSettings.contactEmail')}
                </label>
                <input
                  type="email"
                  className="input"
                  value={settings.contact_email}
                  onChange={(e) => handleChange('contact_email', e.target.value)}
                />
              </div>
              <div>
                <label className="muted" style={{ display: 'block', marginBottom: '0.5rem' }}>
                  {t('siteSettings.contactPhone')}
                </label>
                <input
                  type="tel"
                  className="input"
                  value={settings.contact_phone}
                  onChange={(e) => handleChange('contact_phone', e.target.value)}
                />
              </div>
            </div>

            <div>
              <label className="muted" style={{ display: 'block', marginBottom: '0.5rem' }}>
                {t('siteSettings.whatsapp')}
              </label>
              <input
                type="tel"
                className="input"
                value={settings.whatsapp}
                onChange={(e) => handleChange('whatsapp', e.target.value)}
                placeholder="+55 48 99999-9999"
              />
            </div>
          </div>
        </div>

        <div className="card" style={{ marginBottom: '1.5rem' }}>
          <h2 style={{ fontSize: '1.1rem', marginBottom: '1.5rem', color: 'var(--ink-900)' }}>
            {t('siteSettings.seo')}
          </h2>
          
          <div style={{ display: 'grid', gap: '1.5rem' }}>
            <div>
              <label className="muted" style={{ display: 'block', marginBottom: '0.5rem' }}>
                {t('siteSettings.metaTitle')}
              </label>
              <input
                type="text"
                className="input"
                value={settings.meta_title}
                onChange={(e) => handleChange('meta_title', e.target.value)}
              />
            </div>

            <div>
              <label className="muted" style={{ display: 'block', marginBottom: '0.5rem' }}>
                {t('siteSettings.metaDescription')}
              </label>
              <textarea
                className="input"
                rows={2}
                value={settings.meta_description}
                onChange={(e) => handleChange('meta_description', e.target.value)}
                style={{ resize: 'vertical' }}
              />
            </div>
          </div>
        </div>

        <div className="card" style={{ marginBottom: '1.5rem' }}>
          <h2 style={{ fontSize: '1.1rem', marginBottom: '1.5rem', color: 'var(--ink-900)' }}>
            {t('siteSettings.socialMedia')}
          </h2>
          
          <div style={{ display: 'grid', gap: '1rem' }}>
            {PLATFORMS.map((platform) => (
              <div key={platform.key} style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', minWidth: '120px' }}>
                  <span>{platform.icon}</span>
                  <span style={{ fontWeight: 500 }}>{platform.label}</span>
                </div>
                <input
                  type="url"
                  className="input"
                  placeholder={`https://${platform.key}.com/...`}
                  value={getSocialUrl(platform.key)}
                  onChange={(e) => handleSocialLinkChange(platform.key, e.target.value)}
                  style={{ flex: 1 }}
                />
                <button
                  type="button"
                  onClick={() => handleSocialToggle(platform.key)}
                  style={{
                    padding: '0.5rem 1rem',
                    borderRadius: '8px',
                    border: 'none',
                    cursor: 'pointer',
                    background: isSocialActive(platform.key) ? 'var(--sage-500)' : 'var(--sand-200)',
                    color: isSocialActive(platform.key) ? '#fff' : 'var(--ink-700)',
                    fontSize: '0.875rem'
                  }}
                >
                  {isSocialActive(platform.key) ? tCommon('active') : tCommon('inactive')}
                </button>
              </div>
            ))}
          </div>
        </div>

        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '1rem' }}>
          <button
            type="button"
            className="button-secondary"
            onClick={() => window.location.reload()}
            disabled={saving}
          >
            {tCommon('cancel')}
          </button>
          <button
            type="submit"
            className="button-primary"
            disabled={saving || !hasChanges}
            style={{ minWidth: '120px' }}
          >
            {saving ? tCommon('saving') : tCommon('save')}
          </button>
        </div>
      </form>
    </div>
  )
}
