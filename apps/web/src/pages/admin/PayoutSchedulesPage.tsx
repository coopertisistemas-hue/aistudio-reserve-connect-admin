import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type Schedule = {
  id: string
  entity_type: 'owner' | 'property'
  entity_id: string
  city_code: string
  frequency: 'weekly' | 'biweekly' | 'monthly' | 'on_checkout'
  day_of_week: number | null
  day_of_month: number | null
  min_threshold: number
  hold_days: number
  is_active: boolean
}

export default function PayoutSchedulesPage() {
  const { t } = useTranslation()
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [items, setItems] = useState<Schedule[]>([])
  const [cityCode, setCityCode] = useState('')
  const [form, setForm] = useState({
    id: '',
    entity_type: 'property',
    entity_id: '',
    city_code: 'URB',
    frequency: 'weekly',
    day_of_week: '1',
    day_of_month: '',
    min_threshold: '0',
    hold_days: '0',
    is_active: true,
  })

  const load = async () => {
    setLoading(true)
    setError(null)
    try {
      const response = await postJson<{ success: boolean; data: Schedule[] }>('admin_list_payout_schedules', {
        city_code: cityCode || undefined,
        active_only: false,
      }, { auth: true })
      setItems(response.data || [])
    } catch (err: any) {
      setItems([])
      setError(err.message || t('admin.s2.schedules.errors.load'))
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [cityCode])

  const edit = (item: Schedule) => {
    setForm({
      id: item.id,
      entity_type: item.entity_type,
      entity_id: item.entity_id,
      city_code: item.city_code,
      frequency: item.frequency,
      day_of_week: item.day_of_week === null ? '' : String(item.day_of_week),
      day_of_month: item.day_of_month === null ? '' : String(item.day_of_month),
      min_threshold: String(item.min_threshold),
      hold_days: String(item.hold_days),
      is_active: item.is_active,
    })
  }

  const reset = () => {
    setForm({
      id: '',
      entity_type: 'property',
      entity_id: '',
      city_code: cityCode || 'URB',
      frequency: 'weekly',
      day_of_week: '1',
      day_of_month: '',
      min_threshold: '0',
      hold_days: '0',
      is_active: true,
    })
  }

  const save = async () => {
    if (!form.entity_id || !form.city_code) return
    setSaving(true)
    setError(null)
    try {
      await postJson('admin_upsert_payout_schedule', {
        id: form.id || undefined,
        entity_type: form.entity_type,
        entity_id: form.entity_id,
        city_code: form.city_code,
        frequency: form.frequency,
        day_of_week: form.day_of_week === '' ? null : Number(form.day_of_week),
        day_of_month: form.day_of_month === '' ? null : Number(form.day_of_month),
        min_threshold: Number(form.min_threshold),
        hold_days: Number(form.hold_days),
        is_active: form.is_active,
      }, { auth: true })
      reset()
      await load()
    } catch (err: any) {
      setError(err.message || t('admin.s2.schedules.errors.save'))
    } finally {
      setSaving(false)
    }
  }

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
        <h1 className="headline">{t('admin.s2.schedules.title')}</h1>
        <button className="button-secondary" onClick={load} disabled={loading}>{t('admin.s1.common.refresh')}</button>
      </div>

      <div className="card" style={{ marginBottom: '1rem' }}>
        <label className="muted">{t('admin.cityCode')}</label>
        <input className="input" value={cityCode} onChange={(e) => setCityCode(e.target.value.toUpperCase())} placeholder={t('admin.all')} />
      </div>

      <div className="card" style={{ marginBottom: '1rem' }}>
        <h3 style={{ marginTop: 0 }}>{form.id ? t('admin.s2.common.edit') : t('admin.s2.common.new')}</h3>
        <div className="grid grid-3" style={{ marginTop: '0.75rem' }}>
          <div>
            <label className="muted">entity_type</label>
            <select className="input" value={form.entity_type} onChange={(e) => setForm((prev) => ({ ...prev, entity_type: e.target.value as any }))}>
              <option value="property">property</option>
              <option value="owner">owner</option>
            </select>
          </div>
          <div>
            <label className="muted">entity_id</label>
            <input className="input" value={form.entity_id} onChange={(e) => setForm((prev) => ({ ...prev, entity_id: e.target.value }))} />
          </div>
          <div>
            <label className="muted">{t('admin.cityCode')}</label>
            <input className="input" value={form.city_code} onChange={(e) => setForm((prev) => ({ ...prev, city_code: e.target.value.toUpperCase() }))} />
          </div>
          <div>
            <label className="muted">frequency</label>
            <select className="input" value={form.frequency} onChange={(e) => setForm((prev) => ({ ...prev, frequency: e.target.value as any }))}>
              <option value="weekly">weekly</option>
              <option value="biweekly">biweekly</option>
              <option value="monthly">monthly</option>
              <option value="on_checkout">on_checkout</option>
            </select>
          </div>
          <div>
            <label className="muted">day_of_week</label>
            <input className="input" type="number" min={0} max={6} value={form.day_of_week} onChange={(e) => setForm((prev) => ({ ...prev, day_of_week: e.target.value }))} />
          </div>
          <div>
            <label className="muted">day_of_month</label>
            <input className="input" type="number" min={1} max={31} value={form.day_of_month} onChange={(e) => setForm((prev) => ({ ...prev, day_of_month: e.target.value }))} />
          </div>
          <div>
            <label className="muted">min_threshold</label>
            <input className="input" type="number" min={0} step="0.01" value={form.min_threshold} onChange={(e) => setForm((prev) => ({ ...prev, min_threshold: e.target.value }))} />
          </div>
          <div>
            <label className="muted">hold_days</label>
            <input className="input" type="number" min={0} value={form.hold_days} onChange={(e) => setForm((prev) => ({ ...prev, hold_days: e.target.value }))} />
          </div>
        </div>
        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.5rem', marginTop: '1rem' }}>
          <button className="button-secondary" onClick={reset}>{t('admin.s1.common.clear')}</button>
          <button className="button-primary" onClick={save} disabled={saving || !form.entity_id || !form.city_code}>
            {saving ? t('admin.saving') : form.id ? t('admin.s1.common.update') : t('admin.s1.common.create')}
          </button>
        </div>
      </div>

      {error && <div className="card"><p style={{ color: '#c83232' }}>{error}</p></div>}
      {loading && <LoadingState />}
      {!loading && items.length === 0 && <EmptyState message={t('admin.s2.schedules.empty')} />}
      {!loading && items.length > 0 && (
        <div className="grid">
          {items.map((item) => (
            <button key={item.id} className="card" style={{ textAlign: 'left', cursor: 'pointer' }} onClick={() => edit(item)}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <strong>{item.entity_type}: {item.entity_id.slice(0, 8)}...</strong>
                <span className="chip">{item.is_active ? t('admin.active') : t('admin.inactive')}</span>
              </div>
              <div className="muted" style={{ marginTop: '0.4rem' }}>{item.city_code} • {item.frequency}</div>
              <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap', marginTop: '0.5rem' }}>
                {item.day_of_week !== null && <span className="chip">dow: {item.day_of_week}</span>}
                {item.day_of_month !== null && <span className="chip">dom: {item.day_of_month}</span>}
                <span className="chip">hold: {item.hold_days}</span>
              </div>
            </button>
          ))}
        </div>
      )}
    </section>
  )
}
