import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type Tier = {
  id: string
  city_code: string
  property_id: string | null
  property_name: string | null
  name: string
  min_properties: number
  max_properties: number | null
  commission_rate: number
  effective_from: string
  effective_to: string | null
  is_active: boolean
}

type City = { code: string; name: string }

export default function CommissionTiersPage() {
  const { t } = useTranslation()
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [items, setItems] = useState<Tier[]>([])
  const [cities, setCities] = useState<City[]>([])
  const [cityCode, setCityCode] = useState('')
  const [form, setForm] = useState({
    id: '',
    city_code: 'URB',
    name: '',
    min_properties: 0,
    max_properties: '',
    commission_rate: '0.15',
    effective_from: new Date().toISOString().slice(0, 10),
    effective_to: '',
    is_active: true,
  })

  const load = async () => {
    setLoading(true)
    setError(null)
    try {
      const [tiersRes, citiesRes] = await Promise.all([
        postJson<{ success: boolean; data: Tier[] }>('admin_list_commission_tiers', {
          city_code: cityCode || undefined,
          active_only: false,
        }, { auth: true }),
        postJson<{ success: boolean; data: City[] }>('get_cities_list', {}, { auth: false }).catch(() => ({ data: [{ code: 'URB', name: 'Urubici' }] } as any)),
      ])
      setItems(tiersRes.data || [])
      setCities(citiesRes.data || [{ code: 'URB', name: 'Urubici' }])
    } catch (err: any) {
      setItems([])
      setError(err.message || t('admin.s2.commission.errors.load'))
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [cityCode])

  const edit = (item: Tier) => {
    setForm({
      id: item.id,
      city_code: item.city_code,
      name: item.name,
      min_properties: item.min_properties,
      max_properties: item.max_properties === null ? '' : String(item.max_properties),
      commission_rate: String(item.commission_rate),
      effective_from: item.effective_from,
      effective_to: item.effective_to || '',
      is_active: item.is_active,
    })
  }

  const reset = () => {
    setForm({
      id: '',
      city_code: cityCode || 'URB',
      name: '',
      min_properties: 0,
      max_properties: '',
      commission_rate: '0.15',
      effective_from: new Date().toISOString().slice(0, 10),
      effective_to: '',
      is_active: true,
    })
  }

  const save = async () => {
    if (!form.city_code || !form.name) return
    setSaving(true)
    setError(null)
    try {
      await postJson('admin_upsert_commission_tier', {
        id: form.id || undefined,
        city_code: form.city_code,
        name: form.name,
        min_properties: form.min_properties,
        max_properties: form.max_properties ? Number(form.max_properties) : null,
        commission_rate: Number(form.commission_rate),
        effective_from: form.effective_from,
        effective_to: form.effective_to || null,
        is_active: form.is_active,
      }, { auth: true })
      reset()
      await load()
    } catch (err: any) {
      setError(err.message || t('admin.s2.commission.errors.save'))
    } finally {
      setSaving(false)
    }
  }

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
        <h1 className="headline">{t('admin.s2.commission.title')}</h1>
        <button className="button-secondary" onClick={load} disabled={loading}>{t('admin.s1.common.refresh')}</button>
      </div>

      <div className="card" style={{ marginBottom: '1rem' }}>
        <label className="muted">{t('admin.cityCode')}</label>
        <select className="input" value={cityCode} onChange={(e) => setCityCode(e.target.value)}>
          <option value="">{t('admin.all')}</option>
          {cities.map((city) => (
            <option key={city.code} value={city.code}>{city.code} - {city.name}</option>
          ))}
        </select>
      </div>

      <div className="card" style={{ marginBottom: '1rem' }}>
        <h3 style={{ marginTop: 0 }}>{form.id ? t('admin.s2.common.edit') : t('admin.s2.common.new')}</h3>
        <div className="grid grid-3" style={{ marginTop: '0.75rem' }}>
          <div>
            <label className="muted">{t('admin.cityCode')}</label>
            <input className="input" value={form.city_code} onChange={(e) => setForm((prev) => ({ ...prev, city_code: e.target.value.toUpperCase() }))} />
          </div>
          <div>
            <label className="muted">{t('admin.s1.common.name')}</label>
            <input className="input" value={form.name} onChange={(e) => setForm((prev) => ({ ...prev, name: e.target.value }))} />
          </div>
          <div>
            <label className="muted">{t('admin.s2.commission.rate')}</label>
            <input className="input" type="number" min={0} max={1} step="0.0001" value={form.commission_rate} onChange={(e) => setForm((prev) => ({ ...prev, commission_rate: e.target.value }))} />
          </div>
          <div>
            <label className="muted">{t('admin.s2.commission.minProperties')}</label>
            <input className="input" type="number" min={0} value={form.min_properties} onChange={(e) => setForm((prev) => ({ ...prev, min_properties: Number(e.target.value) }))} />
          </div>
          <div>
            <label className="muted">{t('admin.s2.commission.maxProperties')}</label>
            <input className="input" type="number" min={0} value={form.max_properties} onChange={(e) => setForm((prev) => ({ ...prev, max_properties: e.target.value }))} />
          </div>
          <div>
            <label className="muted">{t('admin.s2.commission.effectiveFrom')}</label>
            <input className="input" type="date" value={form.effective_from} onChange={(e) => setForm((prev) => ({ ...prev, effective_from: e.target.value }))} />
          </div>
        </div>
        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.5rem', marginTop: '1rem' }}>
          <button className="button-secondary" onClick={reset}>{t('admin.s1.common.clear')}</button>
          <button className="button-primary" onClick={save} disabled={saving || !form.city_code || !form.name}>
            {saving ? t('admin.saving') : form.id ? t('admin.s1.common.update') : t('admin.s1.common.create')}
          </button>
        </div>
      </div>

      {error && <div className="card"><p style={{ color: '#c83232' }}>{error}</p></div>}
      {loading && <LoadingState />}
      {!loading && items.length === 0 && <EmptyState message={t('admin.s2.commission.empty')} />}
      {!loading && items.length > 0 && (
        <div className="grid">
          {items.map((item) => (
            <button key={item.id} className="card" style={{ textAlign: 'left', cursor: 'pointer' }} onClick={() => edit(item)}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <strong>{item.name}</strong>
                <span className="chip">{item.is_active ? t('admin.active') : t('admin.inactive')}</span>
              </div>
              <div className="muted" style={{ marginTop: '0.4rem' }}>{item.city_code}</div>
              <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap', marginTop: '0.5rem' }}>
                <span className="chip">rate: {(item.commission_rate * 100).toFixed(2)}%</span>
                <span className="chip">min: {item.min_properties}</span>
                {item.max_properties !== null && <span className="chip">max: {item.max_properties}</span>}
              </div>
            </button>
          ))}
        </div>
      )}
    </section>
  )
}
