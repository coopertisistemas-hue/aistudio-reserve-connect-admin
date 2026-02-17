import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type OpsSummaryResponse = {
  success: boolean
  data: {
    health: Array<{ check_name: string; status: string; severity: string }>
    snapshot: {
      ledger_imbalances: number
      stuck_payments: number
      failed_webhooks: number
    }
  }
}

export default function DashboardPage() {
  const { t } = useTranslation()
  const [data, setData] = useState<OpsSummaryResponse['data'] | null>(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    let active = true
    const load = async () => {
      setLoading(true)
      try {
        const response = await postJson<OpsSummaryResponse>('admin_ops_summary', {}, { auth: true })
        if (active) setData(response.data)
      } catch (error) {
        if (active) setData(null)
      } finally {
        if (active) setLoading(false)
      }
    }
    load()
    return () => {
      active = false
    }
  }, [])

  return (
    <section>
      <h1 className="headline">{t('admin.dashboard')}</h1>
      {loading && <LoadingState />}
      {!loading && !data && <EmptyState message={t('admin.noOpsData')} />}
      {data && (
        <div className="grid grid-2" style={{ marginTop: '1.5rem' }}>
          <div className="card">
            <h3>{t('admin.health')}</h3>
            <div style={{ display: 'grid', gap: '0.6rem', marginTop: '1rem' }}>
              {data.health.map((item) => (
                <div key={item.check_name} style={{ display: 'flex', justifyContent: 'space-between' }}>
                  <span>{item.check_name}</span>
                  <span className="chip">{item.status}</span>
                </div>
              ))}
            </div>
          </div>
          <div className="card">
            <h3>{t('admin.opsSummary')}</h3>
            <div style={{ display: 'grid', gap: '0.6rem', marginTop: '1rem' }}>
              <div>Ledger imbalances: {data.snapshot.ledger_imbalances}</div>
              <div>Pagamentos travados: {data.snapshot.stuck_payments}</div>
              <div>Webhooks falhos: {data.snapshot.failed_webhooks}</div>
            </div>
          </div>
        </div>
      )}
    </section>
  )
}
