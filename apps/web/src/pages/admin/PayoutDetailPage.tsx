import { useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import { postJson } from '../../lib/apiClient'
import { formatCurrency, formatDate } from '../../lib/utils'

type PayoutDetail = {
  payout: {
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

export default function PayoutDetailPage() {
  const { t } = useTranslation()
  const { id } = useParams<{ id: string }>()
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [detail, setDetail] = useState<PayoutDetail | null>(null)

  useEffect(() => {
    if (!id) return

    let active = true
    const load = async () => {
      setLoading(true)
      setError(null)
      try {
        const response = await postJson<PayoutDetailResponse>(
          'admin_get_payout_detail',
          { payout_id: id },
          { auth: true }
        )
        if (active) setDetail(response.data)
      } catch (err: any) {
        if (active) {
          setDetail(null)
          setError(err.message || 'Failed to load payout details')
        }
      } finally {
        if (active) setLoading(false)
      }
    }
    load()
    return () => {
      active = false
    }
  }, [id])

  if (loading) {
    return <LoadingState />
  }

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
        <h1 className="headline">{t('admin.payoutDetails')}</h1>
        <Link to="/admin/payouts" className="button-secondary" style={{ textDecoration: 'none' }}>
          {t('common.back')}
        </Link>
      </div>

      {error && (
        <div className="card" style={{ background: 'rgba(200,50,50,0.1)', borderLeft: '4px solid #c83232', marginBottom: '1rem' }}>
          <p style={{ color: '#c83232' }}>{error}</p>
        </div>
      )}

      {!error && detail && (
        <>
          <div className="grid grid-2" style={{ marginBottom: '1rem' }}>
            <div className="card">
              <div className="muted">{t('admin.totalGrossPayouts')}</div>
              <strong>{formatCurrency(detail.payout.gross_amount, detail.payout.currency || 'BRL')}</strong>
              <div className="muted" style={{ marginTop: '0.5rem' }}>
                {t('admin.totalNetPayouts')}: {formatCurrency(detail.payout.net_amount, detail.payout.currency || 'BRL')}
              </div>
              <div className="muted" style={{ marginTop: '0.5rem' }}>
                {t('admin.totalCommission')}: {formatCurrency(detail.payout.commission_amount, detail.payout.currency || 'BRL')}
              </div>
            </div>

            <div className="card">
              <div className="muted">{t('admin.status')}</div>
              <strong>{detail.payout.status}</strong>
              <div className="muted" style={{ marginTop: '0.5rem' }}>
                {detail.payout.property_name || detail.payout.property_id || '-'}
              </div>
              <div className="muted" style={{ marginTop: '0.5rem' }}>
                {t('admin.bookingCount')}: {detail.payout.booking_count || 0}
              </div>
            </div>
          </div>

          <div className="card" style={{ marginBottom: '1rem' }}>
            <div className="muted" style={{ marginBottom: '0.5rem' }}>{t('admin.transferReferences')}</div>
            <div className="muted">Gateway Ref: {detail.payout.gateway_reference || '-'}</div>
            <div className="muted">Transfer ID: {detail.payout.gateway_transfer_id || '-'}</div>
            <div className="muted">{t('admin.transferredAt')}: {detail.payout.transferred_at ? formatDate(detail.payout.transferred_at) : '-'}</div>
            <div className="muted">{t('admin.createdAt')}: {formatDate(detail.payout.created_at)}</div>
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
    </section>
  )
}
