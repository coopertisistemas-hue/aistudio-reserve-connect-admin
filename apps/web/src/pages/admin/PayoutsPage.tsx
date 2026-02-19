import { useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { Modal } from '../../components/ui'
import { postJson } from '../../lib/apiClient'
import { formatCurrency, formatDate } from '../../lib/utils'

type Payout = {
  id: string
  batch_id?: string | null
  city_code?: string | null
  property_id?: string | null
  property_name?: string | null
  currency: string
  gross_amount: number
  commission_amount: number
  fee_amount: number
  tax_amount: number
  net_amount: number
  status: string
  booking_count: number
  gateway_reference?: string | null
  gateway_transfer_id?: string | null
  created_at: string
  processed_at?: string | null
  transferred_at?: string | null
}

type ListPayoutsResponse = {
  success: boolean
  data: Payout[]
}

type PayoutDetail = {
  payout: Payout & {
    reservation_ids?: string[] | null
  }
  ledger_entries: Array<{
    id: string
    transaction_id: string
    entry_type: string
    account: string
    direction: 'debit' | 'credit'
    amount: number
    description?: string | null
    created_at: string
  }>
}

type PayoutDetailResponse = {
  success: boolean
  data: PayoutDetail
}

function getStatusColor(status: string) {
  switch (status) {
    case 'completed':
      return { bg: 'rgba(63,90,77,0.1)', text: '#3f5a4d' }
    case 'processing':
      return { bg: 'rgba(176,102,43,0.1)', text: '#b0662b' }
    case 'failed':
    case 'cancelled':
      return { bg: 'rgba(200,50,50,0.1)', text: '#c83232' }
    default:
      return { bg: 'var(--sand-200)', text: 'var(--ink-700)' }
  }
}

export default function PayoutsPage() {
  const { t } = useTranslation()
  const [data, setData] = useState<Payout[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const [cityCode, setCityCode] = useState('')
  const [statusFilter, setStatusFilter] = useState('all')
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedPayoutId, setSelectedPayoutId] = useState<string | null>(null)
  const [detailLoading, setDetailLoading] = useState(false)
  const [detail, setDetail] = useState<PayoutDetail | null>(null)

  const openPayoutDetail = async (payoutId: string) => {
    setSelectedPayoutId(payoutId)
    setDetailLoading(true)
    setError(null)
    try {
      const response = await postJson<PayoutDetailResponse>(
        'admin_get_payout_detail',
        { payout_id: payoutId },
        { auth: true }
      )
      setDetail(response.data)
    } catch (err: any) {
      setDetail(null)
      setError(err.message || 'Failed to load payout details')
    } finally {
      setDetailLoading(false)
    }
  }

  const loadPayouts = async () => {
    setLoading(true)
    setError(null)
    try {
      const response = await postJson<ListPayoutsResponse>(
        'admin_list_payouts',
        {
          city_code: cityCode || undefined,
          status: statusFilter === 'all' ? undefined : statusFilter,
          search: searchTerm || undefined,
        },
        { auth: true }
      )
      setData(response.data)
    } catch (err: any) {
      setData([])
      setError(err.message || 'Failed to load payouts')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    loadPayouts()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const totals = useMemo(() => {
    return data.reduce(
      (acc, payout) => {
        acc.gross += payout.gross_amount || 0
        acc.net += payout.net_amount || 0
        acc.commission += payout.commission_amount || 0
        return acc
      },
      { gross: 0, net: 0, commission: 0 }
    )
  }, [data])

  return (
    <section>
      <h1 className="headline">{t('admin.payouts')}</h1>

      <div className="grid grid-3" style={{ marginTop: '1.5rem', marginBottom: '1.25rem' }}>
        <div className="card">
          <label className="muted">{t('admin.search')}</label>
          <input
            type="text"
            className="input"
            placeholder={t('admin.searchPayoutsPlaceholder')}
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>

        <div className="card">
          <label className="muted">{t('admin.cityCode')}</label>
          <input
            type="text"
            className="input"
            placeholder="URB"
            value={cityCode}
            onChange={(e) => setCityCode(e.target.value.toUpperCase())}
          />
        </div>

        <div className="card">
          <label className="muted">{t('admin.status')}</label>
          <select className="input" value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)}>
            <option value="all">{t('admin.all')}</option>
            <option value="pending">{t('admin.pending')}</option>
            <option value="processing">{t('admin.processing')}</option>
            <option value="completed">{t('admin.completed')}</option>
            <option value="failed">{t('admin.failed')}</option>
          </select>
        </div>
      </div>

      <div style={{ display: 'flex', justifyContent: 'flex-end', marginBottom: '1rem' }}>
        <button className="button-primary" onClick={loadPayouts} disabled={loading}>
          {loading ? '...' : t('admin.applyFilters')}
        </button>
      </div>

      {error && (
        <div className="card" style={{ background: 'rgba(200,50,50,0.1)', borderLeft: '4px solid #c83232', marginBottom: '1rem' }}>
          <p style={{ color: '#c83232' }}>{error}</p>
        </div>
      )}

      <div className="grid grid-3" style={{ marginBottom: '1.5rem' }}>
        <div className="card">
          <div className="muted">{t('admin.totalGrossPayouts')}</div>
          <strong style={{ fontSize: '1.2rem' }}>{formatCurrency(totals.gross)}</strong>
        </div>
        <div className="card">
          <div className="muted">{t('admin.totalNetPayouts')}</div>
          <strong style={{ fontSize: '1.2rem', color: '#3f5a4d' }}>{formatCurrency(totals.net)}</strong>
        </div>
        <div className="card">
          <div className="muted">{t('admin.totalCommission')}</div>
          <strong style={{ fontSize: '1.2rem', color: '#b0662b' }}>{formatCurrency(totals.commission)}</strong>
        </div>
      </div>

      {loading && <LoadingState />}
      {!loading && data.length === 0 && <EmptyState message={t('admin.emptyPayouts')} />}

      {!loading && data.length > 0 && (
        <div className="grid" style={{ marginTop: '1rem' }}>
          {data.map((payout) => {
            const statusColors = getStatusColor(payout.status)
            return (
              <div
                key={payout.id}
                className="card"
                style={{ display: 'grid', gap: '0.75rem', textAlign: 'left' }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <strong>{payout.property_name || payout.property_id || payout.id}</strong>
                  <span className="chip" style={{ background: statusColors.bg, color: statusColors.text, fontWeight: 600 }}>
                    {payout.status}
                  </span>
                </div>

                <div style={{ display: 'flex', gap: '0.6rem', flexWrap: 'wrap' }}>
                  {payout.city_code && <span className="chip">{payout.city_code}</span>}
                  <span className="chip">{t('admin.bookingCount')}: {payout.booking_count || 0}</span>
                </div>

                <div className="muted" style={{ fontSize: '0.9rem' }}>
                  {t('admin.totalGrossPayouts')}: {formatCurrency(payout.gross_amount, payout.currency || 'BRL')}
                </div>
                <div className="muted" style={{ fontSize: '0.9rem' }}>
                  {t('admin.totalNetPayouts')}: {formatCurrency(payout.net_amount, payout.currency || 'BRL')}
                </div>

                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <div className="muted" style={{ fontSize: '0.85rem' }}>
                    {formatDate(payout.created_at)}
                  </div>
                  {payout.transferred_at && (
                    <div className="muted" style={{ fontSize: '0.85rem' }}>
                      {t('admin.transferredAt')}: {formatDate(payout.transferred_at)}
                    </div>
                  )}
                </div>

                <div style={{ display: 'flex', gap: '0.5rem', justifyContent: 'flex-end' }}>
                  <button className="button-secondary" onClick={() => openPayoutDetail(payout.id)}>
                    {t('admin.quickView')}
                  </button>
                  <Link to={`/admin/payouts/${payout.id}`} className="button-primary" style={{ textDecoration: 'none' }}>
                    {t('admin.openPage')}
                  </Link>
                </div>
              </div>
            )
          })}
        </div>
      )}

      <Modal
        isOpen={!!selectedPayoutId}
        onClose={() => {
          setSelectedPayoutId(null)
          setDetail(null)
        }}
        title={t('admin.payoutDetails')}
        size="lg"
      >
        {detailLoading && <LoadingState />}

        {!detailLoading && detail && (
          <>
            <div className="grid grid-2" style={{ marginBottom: '1rem' }}>
              <div className="card">
                <div className="muted">{t('admin.totalGrossPayouts')}</div>
                <strong>{formatCurrency(detail.payout.gross_amount, detail.payout.currency || 'BRL')}</strong>
                <div className="muted" style={{ marginTop: '0.5rem' }}>
                  {t('admin.totalNetPayouts')}: {formatCurrency(detail.payout.net_amount, detail.payout.currency || 'BRL')}
                </div>
              </div>
              <div className="card">
                <div className="muted">{t('admin.status')}</div>
                <strong>{detail.payout.status}</strong>
                <div className="muted" style={{ marginTop: '0.5rem' }}>
                  {detail.payout.property_name || detail.payout.property_id || '-'}
                </div>
              </div>
            </div>

            <div className="card" style={{ marginBottom: '1rem' }}>
              <div className="muted" style={{ marginBottom: '0.5rem' }}>{t('admin.transferReferences')}</div>
              <div className="muted">Gateway Ref: {detail.payout.gateway_reference || '-'}</div>
              <div className="muted">Transfer ID: {detail.payout.gateway_transfer_id || '-'}</div>
              <div className="muted">{t('admin.transferredAt')}: {detail.payout.transferred_at ? formatDate(detail.payout.transferred_at) : '-'}</div>
            </div>

            <div className="card">
              <div className="muted" style={{ marginBottom: '0.75rem' }}>{t('admin.ledgerEntries')}</div>
              {detail.ledger_entries.length === 0 ? (
                <div className="muted">{t('admin.noLedgerEntries')}</div>
              ) : (
                <div style={{ display: 'grid', gap: '0.6rem' }}>
                  {detail.ledger_entries.map((entry) => (
                    <div key={entry.id} style={{ display: 'flex', justifyContent: 'space-between', borderBottom: '1px solid var(--sand-200)', paddingBottom: '0.4rem' }}>
                      <div>
                        <div style={{ fontWeight: 600 }}>{entry.entry_type}</div>
                        <div className="muted" style={{ fontSize: '0.85rem' }}>{entry.account} • {entry.direction}</div>
                      </div>
                      <div style={{ textAlign: 'right' }}>
                        <strong>{formatCurrency(entry.amount, detail.payout.currency || 'BRL')}</strong>
                        <div className="muted" style={{ fontSize: '0.8rem' }}>{formatDate(entry.created_at)}</div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </>
        )}
      </Modal>
    </section>
  )
}
