import { useEffect, useState } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type HealthCheck = {
  check_name: string
  status: 'healthy' | 'warning' | 'critical'
  severity: 'low' | 'medium' | 'high'
  message?: string
}

type Snapshot = {
  ledger_imbalances: number
  stuck_payments: number
  failed_webhooks: number
  last_recon_run?: string
  pending_webhooks?: number
  overbooking_count?: number
}

type OpsSummaryResponse = {
  success: boolean
  data: {
    health: HealthCheck[]
    snapshot: Snapshot
  }
}

function KpiCard({ title, value, status }: { title: string; value: number; status: 'good' | 'warning' | 'critical' }) {
  const statusColors = {
    good: { bg: 'rgba(63,90,77,0.1)', border: '#3f5a4d', text: '#3f5a4d' },
    warning: { bg: 'rgba(176,102,43,0.1)', border: '#b0662b', text: '#b0662b' },
    critical: { bg: 'rgba(200,50,50,0.1)', border: '#c83232', text: '#c83232' },
  }
  const colors = statusColors[status]
  
  return (
    <div 
      className="card" 
      style={{ 
        textAlign: 'center',
        background: colors.bg,
        borderLeft: `4px solid ${colors.border}`
      }}
    >
      <div style={{ fontSize: '2rem', fontWeight: 700, color: colors.text }}>{value}</div>
      <div style={{ fontSize: '0.875rem', color: 'var(--ink-600)', marginTop: '0.5rem' }}>{title}</div>
    </div>
  )
}

export default function DashboardPage() {
  const { t } = useTranslation()
  const [data, setData] = useState<OpsSummaryResponse['data'] | null>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    let active = true
    const load = async () => {
      setLoading(true)
      setError(null)
      try {
        const response = await postJson<OpsSummaryResponse>('admin_ops_summary', {}, { auth: true })
        if (active) setData(response.data)
      } catch (err: any) {
        if (active) {
          setData(null)
          setError(err.message || 'Failed to load dashboard data')
        }
      } finally {
        if (active) setLoading(false)
      }
    }
    load()
    return () => {
      active = false
    }
  }, [])

  const runReconciliation = async () => {
    setLoading(true)
    try {
      await postJson('reconciliation_job_placeholder', {
        run_id: `manual_${Date.now()}`,
        dry_run: false,
      }, { auth: true })
      // Refresh dashboard data
      const response = await postJson<OpsSummaryResponse>('admin_ops_summary', {}, { auth: true })
      setData(response.data)
    } catch (err: any) {
      setError(err.message || 'Failed to run reconciliation')
    } finally {
      setLoading(false)
    }
  }

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
        <h1 className="headline">{t('admin.dashboard')}</h1>
        <button className="button-secondary" onClick={runReconciliation} disabled={loading}>
          {t('admin.runRecon')}
        </button>
      </div>

      {loading && <LoadingState />}
      
      {error && (
        <div className="card" style={{ background: 'rgba(200,50,50,0.1)', borderLeft: '4px solid #c83232' }}>
          <p style={{ color: '#c83232' }}>{error}</p>
        </div>
      )}
      
      {!loading && !data && !error && <EmptyState message={t('admin.noOpsData')} />}
      
      {data && (
        <>
          {/* KPI Tiles */}
          <div className="grid grid-4" style={{ marginBottom: '2rem' }}>
            <KpiCard 
              title={t('admin.kpi.stuckPayments')} 
              value={data.snapshot.stuck_payments || 0} 
              status={data.snapshot.stuck_payments > 0 ? 'warning' : 'good'}
            />
            <KpiCard 
              title={t('admin.kpi.failedWebhooks')} 
              value={data.snapshot.failed_webhooks || 0} 
              status={data.snapshot.failed_webhooks > 0 ? 'critical' : 'good'}
            />
            <KpiCard 
              title={t('admin.kpi.ledgerImbalances')} 
              value={data.snapshot.ledger_imbalances || 0} 
              status={data.snapshot.ledger_imbalances > 0 ? 'critical' : 'good'}
            />
            <KpiCard 
              title={t('admin.kpi.lastRecon')} 
              value={data.snapshot.pending_webhooks || 0} 
              status={(data.snapshot.pending_webhooks || 0) > 5 ? 'warning' : 'good'}
            />
          </div>

          {/* Health Checks */}
          <div className="grid grid-2" style={{ marginTop: '1.5rem' }}>
            <div className="card">
              <h3>{t('admin.health')}</h3>
              <div style={{ display: 'grid', gap: '0.6rem', marginTop: '1rem' }}>
                {data.health.map((item) => (
                  <div 
                    key={item.check_name} 
                    style={{ 
                      display: 'flex', 
                      justifyContent: 'space-between',
                      padding: '0.75rem',
                      background: item.status === 'healthy' ? 'rgba(63,90,77,0.1)' : 
                                  item.status === 'warning' ? 'rgba(176,102,43,0.1)' : 'rgba(200,50,50,0.1)',
                      borderRadius: '8px'
                    }}
                  >
                    <span>{item.check_name}</span>
                    <span 
                      className="chip" 
                      style={{ 
                        background: item.status === 'healthy' ? '#3f5a4d' : 
                                   item.status === 'warning' ? '#b0662b' : '#c83232',
                        color: '#fff'
                      }}
                    >
                      {item.status}
                    </span>
                  </div>
                ))}
              </div>
            </div>
            <div className="card">
              <h3>{t('admin.opsSummary')}</h3>
              <div style={{ display: 'grid', gap: '0.6rem', marginTop: '1rem' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', padding: '0.5rem 0', borderBottom: '1px solid var(--sand-200)' }}>
                  <span className="muted">{t('admin.kpi.ledgerImbalances')}</span>
                  <strong>{data.snapshot.ledger_imbalances}</strong>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', padding: '0.5rem 0', borderBottom: '1px solid var(--sand-200)' }}>
                  <span className="muted">{t('admin.kpi.stuckPayments')}</span>
                  <strong>{data.snapshot.stuck_payments}</strong>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', padding: '0.5rem 0', borderBottom: '1px solid var(--sand-200)' }}>
                  <span className="muted">{t('admin.kpi.failedWebhooks')}</span>
                  <strong>{data.snapshot.failed_webhooks}</strong>
                </div>
                {data.snapshot.last_recon_run && (
                  <div style={{ display: 'flex', justifyContent: 'space-between', padding: '0.5rem 0' }}>
                    <span className="muted">{t('admin.kpi.lastRecon')}</span>
                    <strong>{new Date(data.snapshot.last_recon_run).toLocaleString()}</strong>
                  </div>
                )}
              </div>
            </div>
          </div>
        </>
      )}
    </section>
  )
}
