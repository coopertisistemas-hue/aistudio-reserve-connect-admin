import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { postJson } from '../../../lib/apiClient'
import { useToast } from '../../../components/ui/Toast'
import { SkeletonText } from '../../../components/ui/Skeleton'

interface SocialLinks {
  facebook: string
  instagram: string
  twitter: string
  youtube: string
  whatsapp: string
}

export default function SocialLinksPage() {
  const { t } = useTranslation()
  const { addToast } = useToast()
  const [links, setLinks] = useState<SocialLinks>({
    facebook: '',
    instagram: '',
    twitter: '',
    youtube: '',
    whatsapp: ''
  })
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    let active = true
    const loadLinks = async () => {
      setLoading(true)
      setError(null)
      try {
        const response = await postJson<{ success: boolean; data: SocialLinks }>(
          'get_social_links',
          {},
          { auth: true }
        )
        if (active && response.success) {
          setLinks(response.data)
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
    loadLinks()
    return () => { active = false }
  }, [t, addToast])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setSaving(true)
    setError(null)
    
    try {
      const response = await postJson<{ success: boolean }>(
        'update_social_links',
        links,
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

  const handleChange = (field: keyof SocialLinks, value: string) => {
    setLinks(prev => ({ ...prev, [field]: value }))
  }

  if (loading) {
    return (
      <div className="card" style={{ maxWidth: '800px' }}>
        <h1 className="headline" style={{ marginBottom: '2rem' }}>{t('admin.socialLinks')}</h1>
        <SkeletonText lines={5} />
      </div>
    )
  }

  const socialPlatforms: { key: keyof SocialLinks; label: string; placeholder: string }[] = [
    { key: 'facebook', label: t('admin.facebook'), placeholder: 'https://facebook.com/...' },
    { key: 'instagram', label: t('admin.instagram'), placeholder: 'https://instagram.com/...' },
    { key: 'twitter', label: t('admin.twitter'), placeholder: 'https://twitter.com/...' },
    { key: 'youtube', label: t('admin.youtube'), placeholder: 'https://youtube.com/...' },
    { key: 'whatsapp', label: t('admin.whatsapp'), placeholder: 'https://wa.me/...' }
  ]

  return (
    <div style={{ maxWidth: '800px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem' }}>
        <h1 className="headline">{t('admin.socialLinks')}</h1>
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
          <div style={{ display: 'grid', gap: '1.5rem' }}>
            {socialPlatforms.map((platform) => (
              <div key={platform.key}>
                <label className="muted" style={{ display: 'block', marginBottom: '0.5rem' }}>
                  {platform.label}
                </label>
                <input
                  type="url"
                  className="input"
                  placeholder={platform.placeholder}
                  value={links[platform.key]}
                  onChange={(e) => handleChange(platform.key, e.target.value)}
                />
              </div>
            ))}
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
