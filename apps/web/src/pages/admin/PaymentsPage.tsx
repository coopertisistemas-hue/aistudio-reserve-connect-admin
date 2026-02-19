import { useEffect, useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { Modal } from '../../components/ui'
import { postJson } from '../../lib/apiClient'
import { formatCurrency, formatDate } from '../../lib/utils'

type Payment = {
  id: string
  reservation_id?: string | null
  confirmation_code?: string | null
  guest_name?: string | null
  property_name?: string | null
  city_code?: string | null
  payment_method: string
  gateway: string
  gateway_payment_id: string
  currency: string
  amount: number
  gateway_fee: number
  tax_amount: number
  refunded_amount: number
  net_amount: number
  status: string
  created_at: string
}

type ListPaymentsResponse = {
  success: boolean
  data: Payment[]
}

type LedgerEntry = {
  id: string
  entry_type: string
  account: string
  direction: 'debit' | 'credit'
  amount: number
  description?: string | null
  created_at: string
}

type PaymentDetail = {
  payment: Payment & {
    metadata?: Record<string, unknown>
    succeeded_at?: string | null
    failed_at?: string | null
    refunded_at?: string | null
  }
  reservation?: {
    id: string
    confirmation_code?: string | null
    status?: string | null
    guest_name?: string | null
    property_name?: string | null
  } | null
  ledger_entries: LedgerEntry[]
}

type PaymentDetailResponse = {
  success: boolean
  data: PaymentDetail
}

type RefundResponse = {
  success: boolean
  data: {
    payment_id: string
    status: string
    refunded_amount: number
  }
}

function getStatusColor(status: string) {
  switch (status) {
    case 'succeeded':
      return { bg: 'rgba(63,90,77,0.1)', text: '#3f5a4d' }
    case 'pending':
    case 'processing':
      return { bg: 'rgba(176,102,43,0.1)', text: '#b0662b' }
    case 'failed':
    case 'cancelled':
      return { bg: 'rgba(200,50,50,0.1)', text: '#c83232' }
    case 'refunded':
    case 'partially_refunded':
      return { bg: 'rgba(99, 102, 241, 0.12)', text: '#4f46e5' }
    default:
      return { bg: 'var(--sand-200)', text: 'var(--ink-700)' }
  }
}

export default function PaymentsPage() {
  const { t } = useTranslation()
  const [data, setData] = useState<Payment[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const [cityCode, setCityCode] = useState('')
  const [statusFilter, setStatusFilter] = useState('all')
  const [searchTerm, setSearchTerm] = useState('')

  const [selectedPaymentId, setSelectedPaymentId] = useState<string | null>(null)
  const [detailLoading, setDetailLoading] = useState(false)
  const [detailError, setDetailError] = useState<string | null>(null)
  const [detail, setDetail] = useState<PaymentDetail | null>(null)

  const [refundOpen, setRefundOpen] = useState(false)
  const [refundAmount, setRefundAmount] = useState('0')
  const [refundReason, setRefundReason] = useState('')
  const [refundLoading, setRefundLoading] = useState(false)

  const loadPayments = async () => {
    setLoading(true)
    setError(null)
    try {
      const response = await postJson<ListPaymentsResponse>(
        'admin_list_payments',
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
      setError(err.message || 'Failed to load payments')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    loadPayments()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const totals = useMemo(() => {
    return data.reduce(
      (acc, payment) => {
        acc.gross += payment.amount || 0
        acc.net += payment.net_amount || 0
        acc.refunded += payment.refunded_amount || 0
        return acc
      },
      { gross: 0, net: 0, refunded: 0 }
    )
  }, [data])

  const openDetail = async (paymentId: string) => {
    setSelectedPaymentId(paymentId)
    setDetailLoading(true)
    setDetailError(null)
    setDetail(null)

    try {
      const response = await postJson<PaymentDetailResponse>(
        'admin_get_payment_detail',
        { payment_id: paymentId },
        { auth: true }
      )
      setDetail(response.data)
    } catch (err: any) {
      setDetailError(err.message || 'Failed to load payment details')
    } finally {
      setDetailLoading(false)
    }
  }

  const closeDetail = () => {
    setSelectedPaymentId(null)
    setDetail(null)
    setDetailError(null)
    setRefundOpen(false)
    setRefundAmount('0')
    setRefundReason('')
  }

  const refundableAmount = useMemo(() => {
    if (!detail?.payment) return 0
    return Math.max(0, (detail.payment.amount || 0) - (detail.payment.refunded_amount || 0))
  }, [detail])

  const canRefund = refundableAmount > 0 && detail?.payment.status !== 'failed' && detail?.payment.status !== 'cancelled'

  const submitRefund = async () => {
    if (!detail?.payment?.id) return

    const parsedAmount = Number(refundAmount)
    if (!Number.isFinite(parsedAmount) || parsedAmount <= 0 || parsedAmount > refundableAmount) {
      setDetailError(t('admin.refundAmountInvalid'))
      return
    }

    setRefundLoading(true)
    setDetailError(null)

    try {
      await postJson<RefundResponse>(
        'admin_refund_payment',
        {
          payment_id: detail.payment.id,
          amount: parsedAmount,
          reason: refundReason || undefined,
        },
        {
          auth: true,
          idempotencyKey: `admin-refund:${detail.payment.id}:${parsedAmount}`,
        }
      )

      await Promise.all([loadPayments(), openDetail(detail.payment.id)])
      setRefundOpen(false)
      setRefundReason('')
      setRefundAmount('0')
    } catch (err: any) {
      setDetailError(err.message || 'Failed to refund payment')
    } finally {
      setRefundLoading(false)
    }
  }

  return (
    <section>
      <h1 className="headline">{t('admin.payments')}</h1>

      <div className="grid grid-3" style={{ marginTop: '1.5rem', marginBottom: '1.5rem' }}>
        <div className="card">
          <label className="muted">{t('admin.search')}</label>
          <input
            type="text"
            className="input"
            placeholder={t('admin.searchPaymentsPlaceholder')}
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
          <select
            className="input"
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
          >
            <option value="all">{t('admin.all')}</option>
            <option value="pending">{t('admin.pending')}</option>
            <option value="processing">{t('admin.processing')}</option>
            <option value="succeeded">{t('admin.succeeded')}</option>
            <option value="failed">{t('admin.failed')}</option>
            <option value="refunded">{t('admin.refunded')}</option>
            <option value="partially_refunded">{t('admin.partiallyRefunded')}</option>
          </select>
        </div>
      </div>

      <div style={{ display: 'flex', justifyContent: 'flex-end', marginBottom: '1rem' }}>
        <button className="button-primary" onClick={loadPayments} disabled={loading}>
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
          <div className="muted">{t('admin.totalGross')}</div>
          <strong style={{ fontSize: '1.3rem' }}>{formatCurrency(totals.gross)}</strong>
        </div>
        <div className="card">
          <div className="muted">{t('admin.totalNet')}</div>
          <strong style={{ fontSize: '1.3rem', color: '#3f5a4d' }}>{formatCurrency(totals.net)}</strong>
        </div>
        <div className="card">
          <div className="muted">{t('admin.totalRefunded')}</div>
          <strong style={{ fontSize: '1.3rem', color: '#4f46e5' }}>{formatCurrency(totals.refunded)}</strong>
        </div>
      </div>

      {loading && <LoadingState />}

      {!loading && data.length === 0 && <EmptyState message={t('admin.emptyPayments')} />}

      {!loading && data.length > 0 && (
        <div className="grid" style={{ marginTop: '1rem' }}>
          {data.map((payment) => {
            const statusColors = getStatusColor(payment.status)
            return (
              <button
                key={payment.id}
                className="card"
                onClick={() => openDetail(payment.id)}
                style={{
                  textAlign: 'left',
                  border: '1px solid var(--sand-200)',
                  cursor: 'pointer',
                  display: 'grid',
                  gap: '0.75rem',
                }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <strong>{payment.confirmation_code || payment.gateway_payment_id}</strong>
                  <span
                    className="chip"
                    style={{
                      background: statusColors.bg,
                      color: statusColors.text,
                      fontWeight: 600,
                    }}
                  >
                    {payment.status}
                  </span>
                </div>

                <div className="muted" style={{ fontSize: '0.875rem' }}>
                  {payment.guest_name || '-'} {payment.property_name ? `• ${payment.property_name}` : ''}
                </div>

                <div style={{ display: 'flex', gap: '0.75rem', flexWrap: 'wrap' }}>
                  <span className="chip">{payment.payment_method}</span>
                  <span className="chip">{payment.gateway}</span>
                  {payment.city_code && <span className="chip">{payment.city_code}</span>}
                </div>

                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <div className="muted" style={{ fontSize: '0.875rem' }}>
                    {formatDate(payment.created_at)}
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <strong>{formatCurrency(payment.amount, payment.currency || 'BRL')}</strong>
                    <div className="muted" style={{ fontSize: '0.8rem' }}>
                      {t('admin.net')}: {formatCurrency(payment.net_amount, payment.currency || 'BRL')}
                    </div>
                  </div>
                </div>
              </button>
            )
          })}
        </div>
      )}

      <Modal
        isOpen={!!selectedPaymentId}
        onClose={closeDetail}
        title={t('admin.paymentDetails')}
        size="lg"
      >
        {detailLoading && <LoadingState />}

        {detailError && (
          <div className="card" style={{ background: 'rgba(200,50,50,0.1)', borderLeft: '4px solid #c83232', marginBottom: '1rem' }}>
            <p style={{ color: '#c83232' }}>{detailError}</p>
          </div>
        )}

        {!detailLoading && detail && (
          <>
            <div className="grid grid-2" style={{ marginBottom: '1.5rem' }}>
              <div className="card">
                <div className="muted">{t('admin.amount')}</div>
                <strong>{formatCurrency(detail.payment.amount, detail.payment.currency)}</strong>
                <div className="muted" style={{ marginTop: '0.5rem' }}>
                  {t('admin.refunded')}: {formatCurrency(detail.payment.refunded_amount || 0, detail.payment.currency)}
                </div>
              </div>
              <div className="card">
                <div className="muted">{t('admin.gatewayReference')}</div>
                <strong style={{ wordBreak: 'break-all' }}>{detail.payment.gateway_payment_id}</strong>
                <div className="muted" style={{ marginTop: '0.5rem' }}>
                  {detail.payment.gateway} • {detail.payment.payment_method}
                </div>
              </div>
            </div>

            <div className="card" style={{ marginBottom: '1.5rem' }}>
              <div className="muted" style={{ marginBottom: '0.5rem' }}>{t('admin.reservation')}</div>
              <div>
                <strong>{detail.reservation?.confirmation_code || '-'}</strong>
              </div>
              <div className="muted" style={{ marginTop: '0.25rem' }}>
                {detail.reservation?.guest_name || '-'} {detail.reservation?.property_name ? `• ${detail.reservation.property_name}` : ''}
              </div>
            </div>

            <div className="card" style={{ marginBottom: '1.5rem' }}>
              <div className="muted" style={{ marginBottom: '0.75rem' }}>{t('admin.ledgerEntries')}</div>
              {detail.ledger_entries.length === 0 ? (
                <div className="muted">{t('admin.noLedgerEntries')}</div>
              ) : (
                <div style={{ display: 'grid', gap: '0.5rem' }}>
                  {detail.ledger_entries.map((entry) => (
                    <div key={entry.id} style={{ display: 'flex', justifyContent: 'space-between', borderBottom: '1px solid var(--sand-200)', paddingBottom: '0.5rem' }}>
                      <div>
                        <div style={{ fontWeight: 600 }}>{entry.entry_type}</div>
                        <div className="muted" style={{ fontSize: '0.85rem' }}>{entry.account} • {entry.direction}</div>
                      </div>
                      <div style={{ textAlign: 'right' }}>
                        <strong>{formatCurrency(entry.amount, detail.payment.currency)}</strong>
                        <div className="muted" style={{ fontSize: '0.8rem' }}>{formatDate(entry.created_at)}</div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>

            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.75rem' }}>
              <button className="button-secondary" onClick={closeDetail}>
                {t('admin.close')}
              </button>
              {canRefund && (
                <button
                  className="button-primary"
                  onClick={() => {
                    setRefundOpen(true)
                    setRefundAmount(refundableAmount.toFixed(2))
                  }}
                >
                  {t('admin.refundPayment')}
                </button>
              )}
            </div>
          </>
        )}
      </Modal>

      <Modal
        isOpen={refundOpen}
        onClose={() => setRefundOpen(false)}
        title={t('admin.refundPayment')}
        size="sm"
      >
        <div className="card" style={{ marginBottom: '1rem' }}>
          <label className="muted">{t('admin.refundAmount')}</label>
          <input
            type="number"
            step="0.01"
            min="0"
            max={refundableAmount.toFixed(2)}
            className="input"
            value={refundAmount}
            onChange={(e) => setRefundAmount(e.target.value)}
          />
          <div className="muted" style={{ marginTop: '0.5rem', fontSize: '0.85rem' }}>
            {t('admin.refundable')}: {formatCurrency(refundableAmount, detail?.payment.currency || 'BRL')}
          </div>
        </div>

        <div className="card" style={{ marginBottom: '1rem' }}>
          <label className="muted">{t('admin.refundReason')}</label>
          <input
            type="text"
            className="input"
            placeholder={t('admin.refundReasonPlaceholder')}
            value={refundReason}
            onChange={(e) => setRefundReason(e.target.value)}
          />
        </div>

        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.75rem' }}>
          <button className="button-secondary" onClick={() => setRefundOpen(false)} disabled={refundLoading}>
            {t('admin.close')}
          </button>
          <button className="button-primary" onClick={submitRefund} disabled={refundLoading}>
            {refundLoading ? '...' : t('admin.confirmRefund')}
          </button>
        </div>
      </Modal>
    </section>
  )
}
