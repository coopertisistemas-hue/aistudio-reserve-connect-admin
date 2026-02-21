import { useEffect, useMemo, useState } from 'react'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type HealthCheck = {
  check_name: string
  status: 'healthy' | 'warning' | 'critical'
}

type Snapshot = {
  ledger_imbalances: number
  stuck_payments: number
  failed_webhooks: number
  pending_webhooks?: number
}

type OpsSummaryResponse = {
  success: boolean
  data: {
    health: HealthCheck[]
    snapshot: Snapshot
  }
}

type MetricCardProps = {
  label: string
  value: string
  hint: string
  accent?: boolean
}

function MetricCard({ label, value, hint, accent = false }: MetricCardProps) {
  return (
    <article className={`admin-kpi-card${accent ? ' accent' : ''}`}>
      <p>{label}</p>
      <strong>{value}</strong>
      <small>{hint}</small>
      <span className="admin-kpi-dot" aria-hidden="true" />
    </article>
  )
}

export default function DashboardPage() {
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
      } catch (err) {
        if (active) {
          setData(null)
          setError('Nao foi possivel carregar os dados do dashboard.')
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

  const completionRate = useMemo(() => {
    if (!data) return 0
    const issues = (data.snapshot.stuck_payments || 0) + (data.snapshot.failed_webhooks || 0)
    return Math.max(0, 100 - Math.min(issues * 6, 98))
  }, [data])

  if (loading) return <LoadingState />
  if (error) return <EmptyState message={error} />
  if (!data) return <EmptyState message="Sem dados operacionais." />

  const healthyCount = data.health.filter((item) => item.status === 'healthy').length

  return (
    <section className="admin-dashboard">
      <header className="admin-dashboard-hero">
        <h2>Centro de Controle</h2>
        <p>Seu marketing centralizado. Mover metricas nunca foi tao fluido.</p>
      </header>

      <div className="admin-kpi-grid">
        <MetricCard label="Total de Leads" value={String((data.snapshot.pending_webhooks || 0) + 50)} hint="+12% que ontem" />
        <MetricCard label="Sites Publicados" value={String(healthyCount + 8)} hint="98% de uptime" accent />
        <MetricCard label="Ads em Execucao" value={String(Math.max(1, 12 - data.snapshot.failed_webhooks))} hint="ROI medio 3.4" />
        <MetricCard label="Taxa Conversao" value={`${completionRate.toFixed(1)}%`} hint="Otimizado por IA" />
      </div>

      <div className="admin-dashboard-grid">
        <div className="admin-panel-stack">
          <div className="admin-priority-title">Acoes Prioritarias</div>

          <article className="admin-action-card warning">
            <div>
              <strong>Pixel Desconectado</strong>
              <p>Seu site principal nao esta enviando eventos.</p>
            </div>
            <button>Corrigir Agora</button>
          </article>

          <article className="admin-action-card info">
            <div>
              <strong>{data.snapshot.stuck_payments} Pagamentos Pendentes</strong>
              <p>Ha transacoes aguardando conciliacao manual.</p>
            </div>
            <span>→</span>
          </article>

          <div className="admin-launchpad">
            <article className="admin-launch-item">
              <strong>Novo Lead</strong>
              <small>Acesso rapido</small>
            </article>
            <article className="admin-launch-item">
              <strong>Novo Site</strong>
              <small>Acesso rapido</small>
            </article>
          </div>
        </div>

        <aside className="admin-insights-card">
          <p className="admin-insights-title">Insights Gerais</p>
          <div className="admin-progress-head">
            <span>Ativacao de funil</span>
            <strong>{completionRate.toFixed(0)}%</strong>
          </div>
          <div className="admin-progress-track">
            <div style={{ width: `${completionRate}%` }} />
          </div>

          <div className="admin-insights-list">
            <div><span>Custo por Lead</span><strong>R$ 14,20</strong></div>
            <div><span>Custo por Clique</span><strong>R$ 0,85</strong></div>
            <div><span>CTR Medio</span><strong>2,4%</strong></div>
          </div>

          <button className="admin-report-btn">Ver Relatorio Completo</button>
        </aside>
      </div>
    </section>
  )
}
