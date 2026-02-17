import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { postJson } from '../../../lib/apiClient'
import { useToast } from '../../../components/ui/Toast'
import { SkeletonText } from '../../../components/ui/Skeleton'

interface SiteSettings {
  site_name: string
  site_description: string
  contact_email: string
  phone: string
  address: string
  meta_title: string
  meta_description: string
}

export default function SiteSettingsPage() {
  const { t } = useTranslation()
  const { addToast } = useToast()
  const [settings, setSettings] = useState<SiteSettings>({
    site_name: '',
    site_description: '',
    contact_email: '',
    phone: '',
    address: '',
    meta_title: '',
    meta_description: ''
  })
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    let active = true
    const loadSettings = async () => {
      setLoading(true)
      setError(null)
      try {
        const response = await postJson<{ success: boolean; data: SiteSettings }>(
          'get_site_settings',
          {},
          { auth: true }
        )
        if (active && response.success) {
          setSettings(response.data)
        }
      } catch (err: any) {
        if (active) {
          setError(err.message || t('common.error'))
          addToast(err.message || t('common.error'), 'error')
        }
      } finally {
        if (active) setLoading(false)
      }
    }
    loadSettings()
    return () => { active = false }
  }, [t, addToast])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setSaving(true)
    setError(null)
    
    try {
      const response = await postJson<{ success: boolean }>(
        'update_site_settings',
        settings,
        { auth: true }
      )
      
      if (response.success) {
        addToast(t('admin.saved'), 'success')
      }
    } catch (err: any) {
      setError(err.message || t('common.error'))
      addToast(err.message || t('common.error'), 'error')
    } finally {
      setSaving(false)
    }
  }

  const handleChange = (field: keyof SiteSettings, value: string) => {
    setSettings(prev => ({ ...prev, [field]: value }))
  }

  if (loading) {
    return (
      <div className="card" style={{ maxWidth: '800px' }}>
        <h1 className="headline" style={{ marginBottom: '2rem' }}>{t('admin.siteSettings')}</h1>
        <SkeletonText lines={8} />
      </div>
    )
  }

  return (
    <div style={{ maxWidth: '800px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem' }}>
        <h1 className="headline">{t('admin.siteSettings')}</h1>
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
            Informações Gerais
          </h2>
          
          <div style={{ display: 'grid', gap: '1.5rem' }}>
            <div>
              <label className="muted" style={{ display: 'block', marginBottom: '0.5rem' }}>
                {t('admin.siteName')}
              </label>
              <input
                type="text"
                className="input"
                value={settings.site_name}
                onChange={(e) => handleChange('site_name', e.target.value)}
                required
              />
            </div>

            <div>
              <label className="muted" style={{ display: 'block', marginBottom: '0.5rem' }}>
                {t('admin.siteDescription')}
              </label>
              <textarea
                className="input"
                rows={3}
                value={settings.site_description}
                onChange={(e) => handleChange('site_description', e.target.value)}
                style={{ resize: 'vertical' }}
              />
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
              <div>
                <label className="muted" style={{ display: 'block', marginBottom: '0.5rem' }}>
                  {t('admin.contactEmail')}
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
                  {t('admin.phone')}
                </label>
                <input
                  type="tel"
                  className="input"
                  value={settings.phone}
                  onChange={(e) => handleChange('phone', e.target.value)}
                />
              </div>
            </div>

            <div>
              <label className="muted" style={{ display: 'block', marginBottom: '0.5rem' }}>
                {t('admin.address')}
              </label>
              <input
                type="text"
                className="input"
                value={settings.address}
                onChange={(e) => handleChange('address', e.target.value)}
              />
            </div>
          </div>
        </div>

        <div className="card" style={{ marginBottom: '1.5rem' }}>
          <h2 style={{ fontSize: '1.1rem', marginBottom: '1.5rem', color: 'var(--ink-900)' }}>
            SEO
          </h2>
          
          <div style={{ display: 'grid', gap: '1.5rem' }}>
            <div>
              <label className="muted" style={{ display: 'block', marginBottom: '0.5rem' }}>
                {t('admin.metaTitle')}
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
                {t('admin.metaDescription')}
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

        <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
          <button
            type="submit"
            className="button-primary"
            disabled={saving}
            style={{ minWidth: '120px' }}
          >
            {saving ? t('admin.saving') : t('admin.save')}
          </button>
        </div>
      </form>
    </div>
  )
}
