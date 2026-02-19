import { useEffect, useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { Modal } from '../../components/ui'
import { postJson } from '../../lib/apiClient'
import { formatCurrency, formatDate } from '../../lib/utils'

type LedgerEntry = {
  id: string
  transaction_id: string
  entry_type: string
  booking_id?: string | null
  payment_id?: string | null
  confirmation_code?: string | null
  city_code?: string | null
  account: string
  counterparty?: string | null
  direction: 'debit' | 'credit'
  amount: number
  description?: string | null
  created_at: string
}

type ListLedgerResponse = {
  success: boolean
  data: LedgerEntry[]
}

type LedgerTransactionDetail = {
  transaction_id: string
  entries: LedgerEntry[]
  totals: {
    debits: number
    credits: number
    imbalance: number
  }
}

type GetLedgerTransactionResponse = {
  success: boolean
  data: LedgerTransactionDetail
}

export default function FinancialPage() {
  const { t } = useTranslation()
  const [data, setData] = useState<LedgerEntry[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const [cityCode, setCityCode] = useState('')
  const [account, setAccount] = useState('')
  const [entryType, setEntryType] = useState('')
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedTransactionId, setSelectedTransactionId] = useState<string | null>(null)
  const [transactionLoading, setTransactionLoading] = useState(false)
  const [transactionDetail, setTransactionDetail] = useState<LedgerTransactionDetail | null>(null)

  const loadLedgerEntries = async () => {
    setLoading(true)
    setError(null)
    try {
      const response = await postJson<ListLedgerResponse>(
        'admin_list_ledger_entries',
        {
          city_code: cityCode || undefined,
          account: account || undefined,
          entry_type: entryType || undefined,
          search: searchTerm || undefined,
        },
        { auth: true }
      )
      setData(response.data)
    } catch (err: any) {
      setData([])
      setError(err.message || 'Failed to load ledger entries')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    loadLedgerEntries()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const totals = useMemo(() => {
    return data.reduce(
      (acc, entry) => {
        if (entry.direction === 'debit') {
          acc.debits += entry.amount || 0
        } else {
          acc.credits += entry.amount || 0
        }
        return acc
      },
      { debits: 0, credits: 0 }
    )
  }, [data])

  const balanceDelta = totals.debits - totals.credits

  const loadTransactionDetail = async (transactionId: string) => {
    setSelectedTransactionId(transactionId)
    setTransactionLoading(true)
    setError(null)
    try {
      const response = await postJson<GetLedgerTransactionResponse>(
        'admin_get_ledger_transaction',
        { transaction_id: transactionId },
        { auth: true }
      )
      setTransactionDetail(response.data)
    } catch (err: any) {
      setTransactionDetail(null)
      setError(err.message || 'Failed to load transaction details')
    } finally {
      setTransactionLoading(false)
    }
  }

  return (
    <section>
      <h1 className="headline">{t('admin.financial')}</h1>

      <div className="grid grid-4" style={{ marginTop: '1.5rem', marginBottom: '1.25rem' }}>
        <div className="card">
          <label className="muted">{t('admin.search')}</label>
          <input
            type="text"
            className="input"
            placeholder={t('admin.searchLedgerPlaceholder')}
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
          <label className="muted">{t('admin.account')}</label>
          <input
            type="text"
            className="input"
            placeholder="cash_reserve"
            value={account}
            onChange={(e) => setAccount(e.target.value)}
          />
        </div>

        <div className="card">
          <label className="muted">{t('admin.entryType')}</label>
          <input
            type="text"
            className="input"
            placeholder="refund_processed"
            value={entryType}
            onChange={(e) => setEntryType(e.target.value)}
          />
        </div>
      </div>

      <div style={{ display: 'flex', justifyContent: 'flex-end', marginBottom: '1rem' }}>
        <button className="button-primary" onClick={loadLedgerEntries} disabled={loading}>
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
          <div className="muted">{t('admin.debits')}</div>
          <strong style={{ fontSize: '1.2rem' }}>{formatCurrency(totals.debits)}</strong>
        </div>
        <div className="card">
          <div className="muted">{t('admin.credits')}</div>
          <strong style={{ fontSize: '1.2rem' }}>{formatCurrency(totals.credits)}</strong>
        </div>
        <div className="card">
          <div className="muted">{t('admin.imbalance')}</div>
          <strong style={{ fontSize: '1.2rem', color: balanceDelta === 0 ? '#3f5a4d' : '#c83232' }}>
            {formatCurrency(balanceDelta)}
          </strong>
        </div>
      </div>

      {loading && <LoadingState />}

      {!loading && data.length === 0 && <EmptyState message={t('admin.emptyLedgerEntries')} />}

      {!loading && data.length > 0 && (
        <div className="grid" style={{ marginTop: '1rem' }}>
          {data.map((entry) => (
            <button
              key={entry.id}
              className="card"
              onClick={() => loadTransactionDetail(entry.transaction_id)}
              style={{ display: 'grid', gap: '0.7rem', textAlign: 'left', cursor: 'pointer' }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <strong>{entry.entry_type}</strong>
                <span className="chip">{entry.direction}</span>
              </div>

              <div className="muted" style={{ fontSize: '0.85rem' }}>
                {t('admin.transactionId')}: {entry.transaction_id}
              </div>

              <div style={{ display: 'flex', gap: '0.6rem', flexWrap: 'wrap' }}>
                <span className="chip">{entry.account}</span>
                {entry.city_code && <span className="chip">{entry.city_code}</span>}
                {entry.confirmation_code && <span className="chip">{entry.confirmation_code}</span>}
              </div>

              {entry.description && (
                <div className="muted" style={{ fontSize: '0.9rem' }}>
                  {entry.description}
                </div>
              )}

              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div className="muted" style={{ fontSize: '0.85rem' }}>{formatDate(entry.created_at)}</div>
                <strong style={{ color: entry.direction === 'debit' ? '#3f5a4d' : '#4f46e5' }}>
                  {formatCurrency(entry.amount)}
                </strong>
              </div>
            </button>
          ))}
        </div>
      )}

      <Modal
        isOpen={!!selectedTransactionId}
        onClose={() => {
          setSelectedTransactionId(null)
          setTransactionDetail(null)
        }}
        title={t('admin.transactionDetails')}
        size="lg"
      >
        {transactionLoading && <LoadingState />}

        {!transactionLoading && transactionDetail && (
          <>
            <div className="grid grid-3" style={{ marginBottom: '1rem' }}>
              <div className="card">
                <div className="muted">{t('admin.debits')}</div>
                <strong>{formatCurrency(transactionDetail.totals.debits)}</strong>
              </div>
              <div className="card">
                <div className="muted">{t('admin.credits')}</div>
                <strong>{formatCurrency(transactionDetail.totals.credits)}</strong>
              </div>
              <div className="card">
                <div className="muted">{t('admin.imbalance')}</div>
                <strong style={{ color: transactionDetail.totals.imbalance === 0 ? '#3f5a4d' : '#c83232' }}>
                  {formatCurrency(transactionDetail.totals.imbalance)}
                </strong>
              </div>
            </div>

            <div className="card" style={{ marginBottom: '1rem' }}>
              <div className="muted" style={{ fontSize: '0.85rem' }}>
                {t('admin.transactionId')}: {transactionDetail.transaction_id}
              </div>
            </div>

            <div style={{ display: 'grid', gap: '0.75rem' }}>
              {transactionDetail.entries.map((entry) => (
                <div key={entry.id} className="card" style={{ display: 'grid', gap: '0.5rem' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <strong>{entry.entry_type}</strong>
                    <span className="chip">{entry.direction}</span>
                  </div>
                  <div className="muted" style={{ fontSize: '0.85rem' }}>{entry.account}</div>
                  {entry.description && <div className="muted">{entry.description}</div>}
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div className="muted" style={{ fontSize: '0.85rem' }}>{formatDate(entry.created_at)}</div>
                    <strong>{formatCurrency(entry.amount)}</strong>
                  </div>
                </div>
              ))}
            </div>
          </>
        )}
      </Modal>
    </section>
  )
}
