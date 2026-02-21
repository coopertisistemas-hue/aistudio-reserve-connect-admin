import { useEffect, useState } from 'react'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type WebhookEvent = {
  id: string
  status: string
  provider: string
  event_type: string
  created_at?: string
  received_at?: string
}

type IntegrationStatus = {
  host_webhooks_failed_24h: number
  payment_webhooks_failed_24h: number
  latest_host_webhooks: WebhookEvent[]
  latest_payment_webhooks: WebhookEvent[]
}

export default function IntegrationsPage() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [status, setStatus] = useState<IntegrationStatus | null>(null)
  const [showOnlyFailed, setShowOnlyFailed] = useState(false)

  const load = async () => {
    setLoading(true)
    setError(null)
    try {
      const response = await postJson<{ success: boolean; data: IntegrationStatus }>('admin_list_integrations_status', { limit: 30 }, { auth: true })
      setStatus(response.data)
    } catch (err: any) {
      setStatus(null)
      setError(err.message || 'Falha ao carregar status de integracoes')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
  }, [])

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '1rem', flexWrap: 'wrap' }}>
        <h1 className="headline">Integracoes API</h1>
        <button className="button-secondary" onClick={load} disabled={loading}>Atualizar</button>
      </div>

      <div style={{ marginTop: '0.75rem', marginBottom: '0.5rem' }}>
        <label style={{ display: 'inline-flex', gap: '0.5rem', alignItems: 'center' }}>
          <input type="checkbox" checked={showOnlyFailed} onChange={(e) => setShowOnlyFailed(e.target.checked)} />
          Mostrar apenas eventos com falha
        </label>
      </div>

      {error && <div className="card" style={{ marginTop: '1rem' }}><p style={{ color: '#c83232' }}>{error}</p></div>}
      {loading && <LoadingState />}
      {!loading && !status && <EmptyState message="Sem dados de integracao." />}

      {!loading && status && (
        <>
          <div className="grid grid-2" style={{ marginTop: '1rem', marginBottom: '1rem' }}>
            <div className="card">
              <div className="muted">Falhas host webhook (24h)</div>
              <strong style={{ color: status.host_webhooks_failed_24h > 0 ? '#c83232' : undefined }}>{status.host_webhooks_failed_24h}</strong>
            </div>
            <div className="card">
              <div className="muted">Falhas payment webhook (24h)</div>
              <strong style={{ color: status.payment_webhooks_failed_24h > 0 ? '#c83232' : undefined }}>{status.payment_webhooks_failed_24h}</strong>
            </div>
          </div>

          <div className="grid grid-2">
            <div className="card">
              <h3 style={{ marginTop: 0 }}>Host webhooks recentes</h3>
              {status.latest_host_webhooks?.filter((event) => !showOnlyFailed || event.status === 'failed').length ? status.latest_host_webhooks.filter((event) => !showOnlyFailed || event.status === 'failed').map((event) => (
                <div key={event.id} style={{ borderBottom: '1px solid var(--sand-200)', padding: '0.45rem 0' }}>
                  <strong>{event.provider}</strong> • <span>{event.event_type}</span>
                  <div className="muted">{event.status} • {event.created_at ? new Date(event.created_at).toLocaleString() : '-'}</div>
                </div>
              )) : <EmptyState message="Sem eventos." />}
            </div>
            <div className="card">
              <h3 style={{ marginTop: 0 }}>Payment webhooks recentes</h3>
              {status.latest_payment_webhooks?.filter((event) => !showOnlyFailed || event.status === 'failed').length ? status.latest_payment_webhooks.filter((event) => !showOnlyFailed || event.status === 'failed').map((event) => (
                <div key={event.id} style={{ borderBottom: '1px solid var(--sand-200)', padding: '0.45rem 0' }}>
                  <strong>{event.provider}</strong> • <span>{event.event_type}</span>
                  <div className="muted">{event.status} • {event.received_at ? new Date(event.received_at).toLocaleString() : '-'}</div>
                </div>
              )) : <EmptyState message="Sem eventos." />}
            </div>
          </div>
        </>
      )}
    </section>
  )
}
