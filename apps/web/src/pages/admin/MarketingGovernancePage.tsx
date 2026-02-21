import { useEffect, useMemo, useState } from 'react'
import { postJson } from '../../lib/apiClient'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'

type SeoOverride = {
  id: string
  tenant_id: string
  city_code: string
  lang: string
  meta_title: string | null
  meta_description: string | null
  canonical_url: string | null
  og_image_url: string | null
  noindex: boolean
  is_active: boolean
  updated_at: string
}

type BrandingAssets = {
  tenant_id: string
  logo_url: string | null
  favicon_url: string | null
}

type SocialLink = {
  platform: string
  url: string
  active: boolean
}

const TENANT_ID = '00000000-0000-0000-0000-000000000000'

function safeUrl(value: string | null | undefined): URL | null {
  if (!value) return null
  try {
    return new URL(value)
  } catch {
    return null
  }
}

export default function MarketingGovernancePage() {
  const [loading, setLoading] = useState(false)
  const [savingSeo, setSavingSeo] = useState(false)
  const [savingBrand, setSavingBrand] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const [seoItems, setSeoItems] = useState<SeoOverride[]>([])
  const [socialLinks, setSocialLinks] = useState<SocialLink[]>([])
  const [branding, setBranding] = useState<BrandingAssets>({ tenant_id: TENANT_ID, logo_url: '', favicon_url: '' })

  const [seoForm, setSeoForm] = useState({
    city_code: 'URB',
    lang: 'pt',
    meta_title: '',
    meta_description: '',
    canonical_url: '',
    og_image_url: '',
    noindex: false,
    is_active: true,
  })

  const load = async () => {
    setLoading(true)
    setError(null)
    try {
      const [seoRes, brandRes, socialRes] = await Promise.all([
        postJson<{ success: boolean; data: SeoOverride[] }>('admin_list_seo_overrides', { tenant_id: TENANT_ID }, { auth: true }),
        postJson<{ success: boolean; data: BrandingAssets }>('admin_get_branding_assets', { tenant_id: TENANT_ID }, { auth: true }),
        postJson<{ success: boolean; data: SocialLink[] }>('get_social_links', { tenant_id: TENANT_ID }, { auth: true }),
      ])

      setSeoItems(seoRes.data || [])
      setBranding(brandRes.data || { tenant_id: TENANT_ID, logo_url: '', favicon_url: '' })
      setSocialLinks(socialRes.data || [])
    } catch (err: any) {
      setError(err.message || 'Falha ao carregar governanca de marketing')
      setSeoItems([])
      setSocialLinks([])
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
  }, [])

  const socialHealth = useMemo(() => {
    return socialLinks.map((item) => {
      const url = safeUrl(item.url)
      const valid = Boolean(url && (url.protocol === 'https:' || url.protocol === 'http:'))
      return {
        ...item,
        valid,
        host: url?.host || '-',
      }
    })
  }, [socialLinks])

  const saveSeo = async () => {
    setSavingSeo(true)
    setError(null)
    try {
      await postJson('admin_upsert_seo_override', {
        tenant_id: TENANT_ID,
        ...seoForm,
      }, { auth: true })
      await load()
    } catch (err: any) {
      setError(err.message || 'Falha ao salvar override de SEO')
    } finally {
      setSavingSeo(false)
    }
  }

  const saveBranding = async () => {
    setSavingBrand(true)
    setError(null)
    try {
      await postJson('admin_upsert_branding_assets', {
        tenant_id: TENANT_ID,
        logo_url: branding.logo_url || '',
        favicon_url: branding.favicon_url || '',
      }, { auth: true })
      await load()
    } catch (err: any) {
      setError(err.message || 'Falha ao salvar assets de branding')
    } finally {
      setSavingBrand(false)
    }
  }

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '1rem', flexWrap: 'wrap' }}>
        <h1 className="headline">Marketing Governance</h1>
        <button className="button-secondary" onClick={load} disabled={loading || savingSeo || savingBrand}>Atualizar</button>
      </div>

      {error && (
        <div className="card" style={{ marginTop: '1rem', background: 'rgba(200,50,50,0.1)', borderLeft: '4px solid #c83232' }}>
          <p style={{ color: '#c83232', margin: 0 }}>{error}</p>
        </div>
      )}

      {loading && <LoadingState />}

      {!loading && (
        <>
          <div className="card" style={{ marginTop: '1rem' }}>
            <h3 style={{ marginTop: 0 }}>SEO por cidade e idioma</h3>
            <div className="grid grid-3">
              <div>
                <label className="muted">city_code</label>
                <input value={seoForm.city_code} onChange={(e) => setSeoForm((prev) => ({ ...prev, city_code: e.target.value.toUpperCase() }))} />
              </div>
              <div>
                <label className="muted">lang</label>
                <select value={seoForm.lang} onChange={(e) => setSeoForm((prev) => ({ ...prev, lang: e.target.value }))}>
                  <option value="pt">pt</option>
                  <option value="en">en</option>
                  <option value="es">es</option>
                </select>
              </div>
              <div style={{ display: 'flex', alignItems: 'flex-end' }}>
                <label style={{ display: 'inline-flex', gap: '0.5rem', alignItems: 'center' }}>
                  <input type="checkbox" checked={seoForm.noindex} onChange={(e) => setSeoForm((prev) => ({ ...prev, noindex: e.target.checked }))} />
                  noindex
                </label>
              </div>
            </div>
            <div style={{ marginTop: '0.75rem' }}>
              <label className="muted">meta_title</label>
              <input value={seoForm.meta_title} onChange={(e) => setSeoForm((prev) => ({ ...prev, meta_title: e.target.value }))} />
            </div>
            <div style={{ marginTop: '0.75rem' }}>
              <label className="muted">meta_description</label>
              <textarea rows={3} value={seoForm.meta_description} onChange={(e) => setSeoForm((prev) => ({ ...prev, meta_description: e.target.value }))} />
            </div>
            <div className="grid grid-2" style={{ marginTop: '0.75rem' }}>
              <div>
                <label className="muted">canonical_url</label>
                <input value={seoForm.canonical_url} onChange={(e) => setSeoForm((prev) => ({ ...prev, canonical_url: e.target.value }))} />
              </div>
              <div>
                <label className="muted">og_image_url</label>
                <input value={seoForm.og_image_url} onChange={(e) => setSeoForm((prev) => ({ ...prev, og_image_url: e.target.value }))} />
              </div>
            </div>
            <div style={{ marginTop: '1rem', display: 'flex', justifyContent: 'flex-end' }}>
              <button className="button-primary" onClick={saveSeo} disabled={savingSeo || !seoForm.city_code || !seoForm.lang}>
                {savingSeo ? 'Salvando...' : 'Salvar override SEO'}
              </button>
            </div>
          </div>

          <div className="card" style={{ marginTop: '1rem' }}>
            <h3 style={{ marginTop: 0 }}>Branding assets</h3>
            <div className="grid grid-2">
              <div>
                <label className="muted">logo_url</label>
                <input value={branding.logo_url || ''} onChange={(e) => setBranding((prev) => ({ ...prev, logo_url: e.target.value }))} />
              </div>
              <div>
                <label className="muted">favicon_url</label>
                <input value={branding.favicon_url || ''} onChange={(e) => setBranding((prev) => ({ ...prev, favicon_url: e.target.value }))} />
              </div>
            </div>
            <div style={{ marginTop: '1rem', display: 'flex', justifyContent: 'flex-end' }}>
              <button className="button-primary" onClick={saveBranding} disabled={savingBrand}>
                {savingBrand ? 'Salvando...' : 'Salvar branding'}
              </button>
            </div>
          </div>

          <div className="card" style={{ marginTop: '1rem' }}>
            <h3 style={{ marginTop: 0 }}>Validador de links sociais</h3>
            {socialHealth.length === 0 && <EmptyState message="Sem links sociais configurados." />}
            {socialHealth.length > 0 && (
              <div style={{ display: 'grid', gap: '0.6rem' }}>
                {socialHealth.map((item) => (
                  <div key={item.platform} style={{ display: 'flex', justifyContent: 'space-between', gap: '0.5rem', borderBottom: '1px solid var(--sand-200)', paddingBottom: '0.45rem' }}>
                    <div>
                      <strong>{item.platform}</strong>
                      <div className="muted">{item.url || '-'}</div>
                    </div>
                    <div style={{ textAlign: 'right' }}>
                      <span className="chip">{item.active ? 'active' : 'inactive'}</span>
                      <div className="muted">{item.valid ? `host: ${item.host}` : 'url invalida'}</div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>

          <div className="card" style={{ marginTop: '1rem' }}>
            <h3 style={{ marginTop: 0 }}>Overrides atuais</h3>
            {seoItems.length === 0 && <EmptyState message="Sem overrides de SEO." />}
            {seoItems.length > 0 && (
              <div style={{ display: 'grid', gap: '0.5rem' }}>
                {seoItems.map((item) => (
                  <button
                    key={item.id}
                    className="card"
                    style={{ textAlign: 'left', cursor: 'pointer' }}
                    onClick={() => setSeoForm({
                      city_code: item.city_code,
                      lang: item.lang,
                      meta_title: item.meta_title || '',
                      meta_description: item.meta_description || '',
                      canonical_url: item.canonical_url || '',
                      og_image_url: item.og_image_url || '',
                      noindex: item.noindex,
                      is_active: item.is_active,
                    })}
                  >
                    <div style={{ display: 'flex', justifyContent: 'space-between', gap: '0.75rem' }}>
                      <strong>{item.city_code} / {item.lang}</strong>
                      <span className="chip">{item.is_active ? 'active' : 'inactive'}</span>
                    </div>
                    <div className="muted" style={{ marginTop: '0.35rem' }}>{item.meta_title || '-'}</div>
                  </button>
                ))}
              </div>
            )}
          </div>
        </>
      )}
    </section>
  )
}
