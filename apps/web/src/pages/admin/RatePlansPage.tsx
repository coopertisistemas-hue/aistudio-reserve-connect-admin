import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type Property = { id: string; name: string }
type RatePlan = {
  id: string
  property_id: string
  property_name: string | null
  name: string
  code: string | null
  is_default: boolean
  min_stay_nights: number
  max_stay_nights: number | null
  advance_booking_days: number | null
  cancellation_policy_code: string | null
  is_active: boolean
}

export default function RatePlansPage() {
  const { t } = useTranslation()
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [propertyId, setPropertyId] = useState('')
  const [properties, setProperties] = useState<Property[]>([])
  const [items, setItems] = useState<RatePlan[]>([])
  const [form, setForm] = useState({
    id: '',
    property_id: '',
    name: '',
    code: '',
    min_stay_nights: 1,
    max_stay_nights: '',
    advance_booking_days: '',
    cancellation_policy_code: '',
    is_default: false,
    is_active: true,
  })

  const load = async () => {
    setLoading(true)
    setError(null)
    try {
      const [rateRes, propRes] = await Promise.all([
        postJson<{ success: boolean; data: RatePlan[] }>('admin_list_rate_plans', { property_id: propertyId || undefined }, { auth: true }),
        postJson<{ success: boolean; data: Property[] }>('admin_list_properties', {}, { auth: true }),
      ])
      setItems(rateRes.data || [])
      setProperties(propRes.data || [])
    } catch (err: any) {
      setItems([])
      setError(err.message || t('admin.s1.ratePlans.errors.load'))
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [propertyId])

  const edit = (item: RatePlan) => {
    setForm({
      id: item.id,
      property_id: item.property_id,
      name: item.name,
      code: item.code || '',
      min_stay_nights: item.min_stay_nights,
      max_stay_nights: item.max_stay_nights ? String(item.max_stay_nights) : '',
      advance_booking_days: item.advance_booking_days ? String(item.advance_booking_days) : '',
      cancellation_policy_code: item.cancellation_policy_code || '',
      is_default: item.is_default,
      is_active: item.is_active,
    })
  }

  const reset = () => {
    setForm({
      id: '',
      property_id: '',
      name: '',
      code: '',
      min_stay_nights: 1,
      max_stay_nights: '',
      advance_booking_days: '',
      cancellation_policy_code: '',
      is_default: false,
      is_active: true,
    })
  }

  const save = async () => {
    if (!form.property_id || !form.name) return
    setSaving(true)
    setError(null)
    try {
      await postJson('admin_upsert_rate_plan', {
        id: form.id || undefined,
        property_id: form.property_id,
        name: form.name,
        code: form.code || undefined,
        min_stay_nights: form.min_stay_nights,
        max_stay_nights: form.max_stay_nights ? Number(form.max_stay_nights) : undefined,
        advance_booking_days: form.advance_booking_days ? Number(form.advance_booking_days) : undefined,
        cancellation_policy_code: form.cancellation_policy_code || undefined,
        is_default: form.is_default,
        is_active: form.is_active,
      }, { auth: true })
      reset()
      await load()
    } catch (err: any) {
      setError(err.message || t('admin.s1.ratePlans.errors.save'))
    } finally {
      setSaving(false)
    }
  }

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
        <h1 className="headline">{t('admin.s1.ratePlans.title')}</h1>
        <button className="button-secondary" onClick={load} disabled={loading}>{t('admin.s1.common.refresh')}</button>
      </div>

      <div className="card" style={{ marginBottom: '1rem' }}>
        <label className="muted">{t('admin.s1.common.filterByProperty')}</label>
        <select className="input" value={propertyId} onChange={(e) => setPropertyId(e.target.value)}>
          <option value="">{t('admin.all')}</option>
          {properties.map((property) => (
            <option key={property.id} value={property.id}>{property.name}</option>
          ))}
        </select>
      </div>

      <div className="card" style={{ marginBottom: '1.25rem' }}>
        <h3 style={{ marginTop: 0 }}>{form.id ? t('admin.s1.ratePlans.editTitle') : t('admin.s1.ratePlans.newTitle')}</h3>
        <div className="grid grid-3" style={{ marginTop: '0.75rem' }}>
          <div>
            <label className="muted">{t('admin.properties')}</label>
            <select className="input" value={form.property_id} onChange={(e) => setForm((prev) => ({ ...prev, property_id: e.target.value }))}>
              <option value="">{t('admin.s1.common.select')}</option>
              {properties.map((property) => (
                <option key={property.id} value={property.id}>{property.name}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="muted">{t('admin.s1.common.name')}</label>
            <input className="input" value={form.name} onChange={(e) => setForm((prev) => ({ ...prev, name: e.target.value }))} />
          </div>
          <div>
            <label className="muted">{t('admin.s1.ratePlans.code')}</label>
            <input className="input" value={form.code} onChange={(e) => setForm((prev) => ({ ...prev, code: e.target.value }))} />
          </div>
          <div>
            <label className="muted">{t('admin.s1.ratePlans.minStayNights')}</label>
            <input className="input" type="number" min={1} value={form.min_stay_nights} onChange={(e) => setForm((prev) => ({ ...prev, min_stay_nights: Number(e.target.value) }))} />
          </div>
          <div>
            <label className="muted">{t('admin.s1.ratePlans.maxStayNights')}</label>
            <input className="input" type="number" min={1} value={form.max_stay_nights} onChange={(e) => setForm((prev) => ({ ...prev, max_stay_nights: e.target.value }))} />
          </div>
          <div>
            <label className="muted">{t('admin.s1.ratePlans.advanceBookingDays')}</label>
            <input className="input" type="number" min={0} value={form.advance_booking_days} onChange={(e) => setForm((prev) => ({ ...prev, advance_booking_days: e.target.value }))} />
          </div>
        </div>

        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.5rem', marginTop: '1rem' }}>
          <button className="button-secondary" onClick={reset}>{t('admin.s1.common.clear')}</button>
          <button className="button-primary" onClick={save} disabled={saving || !form.property_id || !form.name}>
            {saving ? t('admin.saving') : form.id ? t('admin.s1.common.update') : t('admin.s1.common.create')}
          </button>
        </div>
      </div>

      {error && (
        <div className="card" style={{ background: 'rgba(200,50,50,0.1)', borderLeft: '4px solid #c83232', marginBottom: '1rem' }}>
          <p style={{ color: '#c83232' }}>{error}</p>
        </div>
      )}

      {loading && <LoadingState />}
      {!loading && items.length === 0 && <EmptyState message={t('admin.s1.ratePlans.empty')} />}
      {!loading && items.length > 0 && (
        <div className="grid" style={{ marginTop: '1rem' }}>
          {items.map((item) => (
            <button key={item.id} className="card" onClick={() => edit(item)} style={{ textAlign: 'left', cursor: 'pointer' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <strong>{item.name}</strong>
                <span className="chip">{item.is_active ? t('admin.active') : t('admin.inactive')}</span>
              </div>
              <div className="muted" style={{ marginTop: '0.4rem' }}>{item.property_name}</div>
              <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap', marginTop: '0.5rem' }}>
                {item.code && <span className="chip">{item.code}</span>}
                <span className="chip">{t('admin.s1.ratePlans.minShort')}: {item.min_stay_nights}</span>
                {item.max_stay_nights && <span className="chip">{t('admin.s1.ratePlans.maxShort')}: {item.max_stay_nights}</span>}
                {item.is_default && <span className="chip">{t('admin.s1.ratePlans.default')}</span>}
              </div>
            </button>
          ))}
        </div>
      )}
    </section>
  )
}
