import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'
import { formatCurrency } from '../../lib/utils'

type Item = {
  id: string
  unit_id: string
  unit_name: string | null
  property_id: string | null
  property_name: string | null
  rate_plan_id: string
  rate_plan_name: string | null
  date: string
  is_available: boolean
  is_blocked: boolean
  block_reason: string | null
  min_stay_override: number | null
  base_price: number
  discounted_price: number | null
  currency: string
  allotment: number
  temp_holds: number
}

export default function AvailabilityPage() {
  const { t } = useTranslation()
  const [items, setItems] = useState<Item[]>([])
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [startDate, setStartDate] = useState(() => new Date().toISOString().slice(0, 10))
  const [endDate, setEndDate] = useState(() => new Date(Date.now() + 1000 * 60 * 60 * 24 * 14).toISOString().slice(0, 10))

  const [selected, setSelected] = useState<Item | null>(null)
  const [edit, setEdit] = useState({
    base_price: '',
    discounted_price: '',
    min_stay_override: '',
    is_available: true,
    is_blocked: false,
    block_reason: '',
  })

  const load = async () => {
    setLoading(true)
    setError(null)
    try {
      const response = await postJson<{ success: boolean; data: Item[] }>('admin_list_availability', {
        start_date: startDate,
        end_date: endDate,
      }, { auth: true })
      setItems(response.data || [])
    } catch (err: any) {
      setItems([])
      setError(err.message || t('admin.s1.availability.errors.load'))
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const selectItem = (item: Item) => {
    setSelected(item)
    setEdit({
      base_price: String(item.base_price),
      discounted_price: item.discounted_price === null ? '' : String(item.discounted_price),
      min_stay_override: item.min_stay_override === null ? '' : String(item.min_stay_override),
      is_available: item.is_available,
      is_blocked: item.is_blocked,
      block_reason: item.block_reason || '',
    })
  }

  const save = async () => {
    if (!selected) return
    setSaving(true)
    setError(null)
    try {
      await postJson('admin_upsert_availability', {
        unit_id: selected.unit_id,
        rate_plan_id: selected.rate_plan_id,
        date: selected.date,
        base_price: Number(edit.base_price),
        discounted_price: edit.discounted_price ? Number(edit.discounted_price) : null,
        min_stay_override: edit.min_stay_override ? Number(edit.min_stay_override) : null,
        is_available: edit.is_available,
        is_blocked: edit.is_blocked,
        block_reason: edit.block_reason || null,
        currency: selected.currency,
        allotment: selected.allotment,
      }, { auth: true })
      setSelected(null)
      await load()
    } catch (err: any) {
      setError(err.message || t('admin.s1.availability.errors.save'))
    } finally {
      setSaving(false)
    }
  }

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
        <h1 className="headline">{t('admin.s1.availability.title')}</h1>
        <button className="button-secondary" onClick={load} disabled={loading}>{t('admin.s1.common.refresh')}</button>
      </div>

      <div className="card" style={{ marginBottom: '1rem' }}>
        <div className="grid grid-2">
          <div>
            <label className="muted">{t('admin.s1.availability.startDate')}</label>
            <input className="input" type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} />
          </div>
          <div>
            <label className="muted">{t('admin.s1.availability.endDate')}</label>
            <input className="input" type="date" value={endDate} onChange={(e) => setEndDate(e.target.value)} />
          </div>
        </div>
        <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: '0.75rem' }}>
          <button className="button-primary" onClick={load}>{t('admin.applyFilters')}</button>
        </div>
      </div>

      {selected && (
        <div className="card" style={{ marginBottom: '1rem' }}>
          <h3 style={{ marginTop: 0 }}>{t('admin.s1.availability.editSlot')}</h3>
          <p className="muted" style={{ marginTop: 0 }}>{selected.property_name} • {selected.unit_name} • {selected.date}</p>
          <div className="grid grid-3">
            <div>
              <label className="muted">{t('admin.s1.availability.basePrice')}</label>
              <input className="input" type="number" min={0} step="0.01" value={edit.base_price} onChange={(e) => setEdit((prev) => ({ ...prev, base_price: e.target.value }))} />
            </div>
            <div>
              <label className="muted">{t('admin.s1.availability.discountedPrice')}</label>
              <input className="input" type="number" min={0} step="0.01" value={edit.discounted_price} onChange={(e) => setEdit((prev) => ({ ...prev, discounted_price: e.target.value }))} />
            </div>
            <div>
              <label className="muted">{t('admin.s1.availability.minStayOverride')}</label>
              <input className="input" type="number" min={1} value={edit.min_stay_override} onChange={(e) => setEdit((prev) => ({ ...prev, min_stay_override: e.target.value }))} />
            </div>
          </div>
          <div style={{ display: 'flex', gap: '0.75rem', marginTop: '0.75rem' }}>
            <label><input type="checkbox" checked={edit.is_available} onChange={(e) => setEdit((prev) => ({ ...prev, is_available: e.target.checked }))} /> {t('admin.s1.availability.available')}</label>
            <label><input type="checkbox" checked={edit.is_blocked} onChange={(e) => setEdit((prev) => ({ ...prev, is_blocked: e.target.checked }))} /> {t('admin.s1.availability.blocked')}</label>
          </div>
          <div style={{ marginTop: '0.75rem' }}>
            <label className="muted">{t('admin.s1.availability.blockReason')}</label>
            <input className="input" value={edit.block_reason} onChange={(e) => setEdit((prev) => ({ ...prev, block_reason: e.target.value }))} />
          </div>
          <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.5rem', marginTop: '0.75rem' }}>
            <button className="button-secondary" onClick={() => setSelected(null)}>{t('common.cancel')}</button>
            <button className="button-primary" onClick={save} disabled={saving}>{saving ? t('admin.saving') : t('admin.save')}</button>
          </div>
        </div>
      )}

      {error && (
        <div className="card" style={{ background: 'rgba(200,50,50,0.1)', borderLeft: '4px solid #c83232', marginBottom: '1rem' }}>
          <p style={{ color: '#c83232' }}>{error}</p>
        </div>
      )}

      {loading && <LoadingState />}
      {!loading && items.length === 0 && <EmptyState message={t('admin.s1.availability.empty')} />}

      {!loading && items.length > 0 && (
        <div className="grid" style={{ marginTop: '1rem' }}>
          {items.map((item) => (
            <button key={item.id} className="card" onClick={() => selectItem(item)} style={{ textAlign: 'left', cursor: 'pointer' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <strong>{item.unit_name}</strong>
                <span className="chip">{item.date}</span>
              </div>
              <div className="muted" style={{ marginTop: '0.4rem' }}>{item.property_name} • {item.rate_plan_name}</div>
              <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap', marginTop: '0.5rem' }}>
                <span className="chip">{item.is_available ? t('admin.s1.availability.available') : t('admin.s1.availability.unavailable')}</span>
                {item.is_blocked && <span className="chip">{t('admin.s1.availability.blocked')}</span>}
                <span className="chip">{t('admin.s1.availability.holds')}: {item.temp_holds}</span>
              </div>
              <div style={{ marginTop: '0.5rem' }}>
                <strong>{formatCurrency(item.discounted_price ?? item.base_price, item.currency)}</strong>
                {item.discounted_price !== null && (
                  <span className="muted" style={{ marginLeft: '0.4rem' }}>({t('admin.s1.availability.baseShort')} {formatCurrency(item.base_price, item.currency)})</span>
                )}
              </div>
            </button>
          ))}
        </div>
      )}
    </section>
  )
}
