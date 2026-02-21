import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'
import { formatCurrency } from '../../lib/utils'

type Hold = {
  id: string
  city_code: string
  property_name: string | null
  unit_name: string | null
  rate_plan_name: string | null
  check_in: string
  check_out: string
  nights: number
  guests_adults: number
  guests_children: number
  status: string
  total_amount: number
  currency: string
  expires_at: string
  expires_in_seconds: number | null
  created_at: string
}

function formatRemaining(value: number | null) {
  if (value === null) return '-'
  const m = Math.floor(value / 60)
  const s = value % 60
  return `${m}:${String(s).padStart(2, '0')}`
}

export default function BookingHoldsPage() {
  const { t } = useTranslation()
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [status, setStatus] = useState('')
  const [items, setItems] = useState<Hold[]>([])

  const load = async () => {
    setLoading(true)
    setError(null)
    try {
      const response = await postJson<{ success: boolean; data: Hold[] }>('admin_list_booking_holds', {
        status: status || undefined,
        only_active: status ? false : true,
      }, { auth: true })
      setItems(response.data || [])
    } catch (err: any) {
      setItems([])
      setError(err.message || t('admin.s1.holds.errors.load'))
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [status])

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
        <h1 className="headline">{t('admin.s1.holds.title')}</h1>
        <button className="button-secondary" onClick={load} disabled={loading}>{t('admin.s1.common.refresh')}</button>
      </div>

      <div className="card" style={{ marginBottom: '1rem' }}>
        <label className="muted">{t('admin.status')}</label>
        <select className="input" value={status} onChange={(e) => setStatus(e.target.value)}>
          <option value="">{t('admin.s1.holds.active')}</option>
          <option value="intent_created">intent_created</option>
          <option value="payment_pending">payment_pending</option>
          <option value="payment_confirmed">payment_confirmed</option>
          <option value="converted">converted</option>
          <option value="expired">expired</option>
          <option value="cancelled">cancelled</option>
        </select>
      </div>

      {error && (
        <div className="card" style={{ background: 'rgba(200,50,50,0.1)', borderLeft: '4px solid #c83232', marginBottom: '1rem' }}>
          <p style={{ color: '#c83232' }}>{error}</p>
        </div>
      )}

      {loading && <LoadingState />}
      {!loading && items.length === 0 && <EmptyState message={t('admin.s1.holds.empty')} />}
      {!loading && items.length > 0 && (
        <div className="grid" style={{ marginTop: '1rem' }}>
          {items.map((item) => (
            <article key={item.id} className="card">
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <strong>{item.property_name || '-'}</strong>
                <span className="chip">{item.status}</span>
              </div>
              <div className="muted" style={{ marginTop: '0.4rem' }}>{item.unit_name || '-'} • {item.rate_plan_name || '-'}</div>
              <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap', marginTop: '0.5rem' }}>
                <span className="chip">{item.check_in} → {item.check_out}</span>
                <span className="chip">{t('admin.s1.holds.nights')}: {item.nights}</span>
                <span className="chip">{t('admin.s1.holds.guests')}: {item.guests_adults + item.guests_children}</span>
                <span className="chip">{t('admin.s1.holds.city')}: {item.city_code}</span>
              </div>
              <div style={{ marginTop: '0.6rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <strong>{formatCurrency(item.total_amount, item.currency)}</strong>
                <span className="muted">{t('admin.s1.holds.expiresIn')} {formatRemaining(item.expires_in_seconds)}</span>
              </div>
            </article>
          ))}
        </div>
      )}
    </section>
  )
}
