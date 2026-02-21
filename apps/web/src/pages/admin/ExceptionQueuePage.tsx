import { useEffect, useMemo, useState } from 'react'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'
import { useAuth } from '../../lib/auth'

type ExceptionAlert = {
  alert_code: string
  severity: 'CRITICAL' | 'WARNING' | 'INFO'
  description: string
  evidence_query: string
  status: 'open' | 'ack' | 'in_progress' | 'resolved' | 'snoozed'
  priority: 'low' | 'medium' | 'high' | 'critical'
  owner_email: string | null
  notes: string | null
  snoozed_until: string | null
  first_seen_at: string
  last_seen_at: string
  aging_minutes: number
  sla_minutes: number
  sla_breached: boolean
}

type QueueResponse = {
  success: boolean
  data: ExceptionAlert[]
}

export default function ExceptionQueuePage() {
  const { session } = useAuth()
  const currentUser = session?.user?.email?.toLowerCase() || null

  const [loading, setLoading] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [alerts, setAlerts] = useState<ExceptionAlert[]>([])
  const [selected, setSelected] = useState<string[]>([])
  const [statusFilter, setStatusFilter] = useState('')
  const [severityFilter, setSeverityFilter] = useState('')
  const [ownerFilter, setOwnerFilter] = useState('')
  const [bulkOwner, setBulkOwner] = useState('')
  const [bulkNote, setBulkNote] = useState('')

  const loadQueue = async () => {
    setLoading(true)
    setError(null)
    try {
      const response = await postJson<QueueResponse>(
        'admin_list_exception_queue',
        {
          status: statusFilter || null,
          severity: severityFilter || null,
          owner_email: ownerFilter || null,
        },
        { auth: true }
      )
      setAlerts(response.data || [])
      setSelected((prev) => prev.filter((code) => response.data?.some((alert) => alert.alert_code === code)))
    } catch (err: any) {
      setError(err.message || 'Falha ao carregar fila de excecoes')
      setAlerts([])
      setSelected([])
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    loadQueue()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [statusFilter, severityFilter, ownerFilter])

  const runBulkAction = async (payload: Record<string, unknown>) => {
    if (!selected.length) return
    setSubmitting(true)
    setError(null)
    try {
      await postJson('admin_bulk_update_exception_alerts', { alert_codes: selected, ...payload }, { auth: true })
      setBulkNote('')
      await loadQueue()
    } catch (err: any) {
      setError(err.message || 'Falha ao executar acao em lote')
    } finally {
      setSubmitting(false)
    }
  }

  const toggleAll = () => {
    if (selected.length === alerts.length) {
      setSelected([])
      return
    }
    setSelected(alerts.map((alert) => alert.alert_code))
  }

  const selectedCount = selected.length
  const breachedCount = useMemo(() => alerts.filter((alert) => alert.sla_breached).length, [alerts])

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '1rem', flexWrap: 'wrap' }}>
        <div>
          <h1 className="headline">Exception Queue</h1>
          <p className="muted" style={{ marginTop: '0.35rem' }}>
            Tratativa operacional com owner, SLA e ciclo de vida.
          </p>
        </div>
        <button className="button-secondary" onClick={loadQueue} disabled={loading || submitting}>
          Atualizar
        </button>
      </div>

      <div className="grid grid-4" style={{ marginTop: '1rem', marginBottom: '1rem' }}>
        <div className="card"><div className="muted">Alertas na fila</div><strong>{alerts.length}</strong></div>
        <div className="card"><div className="muted">Selecionados</div><strong>{selectedCount}</strong></div>
        <div className="card"><div className="muted">SLA violado</div><strong style={{ color: breachedCount > 0 ? '#c83232' : undefined }}>{breachedCount}</strong></div>
        <div className="card"><div className="muted">Sem owner</div><strong>{alerts.filter((alert) => !alert.owner_email).length}</strong></div>
      </div>

      <div className="card" style={{ marginBottom: '1rem' }}>
        <div className="grid grid-4" style={{ alignItems: 'end' }}>
          <div>
            <label className="muted">Status</label>
            <select value={statusFilter} onChange={(event) => setStatusFilter(event.target.value)}>
              <option value="">Todos</option>
              <option value="open">open</option>
              <option value="ack">ack</option>
              <option value="in_progress">in_progress</option>
              <option value="resolved">resolved</option>
              <option value="snoozed">snoozed</option>
            </select>
          </div>
          <div>
            <label className="muted">Severidade</label>
            <select value={severityFilter} onChange={(event) => setSeverityFilter(event.target.value)}>
              <option value="">Todas</option>
              <option value="CRITICAL">CRITICAL</option>
              <option value="WARNING">WARNING</option>
              <option value="INFO">INFO</option>
            </select>
          </div>
          <div>
            <label className="muted">Owner</label>
            <select value={ownerFilter} onChange={(event) => setOwnerFilter(event.target.value)}>
              <option value="">Todos</option>
              <option value="__unassigned__">Sem owner</option>
              {currentUser && <option value={currentUser}>{currentUser}</option>}
            </select>
          </div>
          <div>
            <button className="button-secondary" onClick={() => { setStatusFilter(''); setSeverityFilter(''); setOwnerFilter('') }}>
              Limpar filtros
            </button>
          </div>
        </div>
      </div>

      <div className="card" style={{ marginBottom: '1rem' }}>
        <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
          <button className="button-secondary" disabled={!selectedCount || submitting} onClick={() => runBulkAction({ status: 'ack' })}>Ack em lote</button>
          <button className="button-secondary" disabled={!selectedCount || submitting} onClick={() => runBulkAction({ status: 'in_progress' })}>In progress em lote</button>
          <button className="button-secondary" disabled={!selectedCount || submitting} onClick={() => runBulkAction({ status: 'resolved' })}>Resolver em lote</button>
          <button className="button-secondary" disabled={!selectedCount || submitting || !currentUser} onClick={() => runBulkAction({ owner_email: currentUser })}>Atribuir para mim</button>
        </div>
        <div className="grid grid-2" style={{ marginTop: '0.75rem' }}>
          <div>
            <label className="muted">Definir owner (lote)</label>
            <input value={bulkOwner} onChange={(event) => setBulkOwner(event.target.value)} placeholder="owner@email.com" />
            <button
              className="button-secondary"
              style={{ marginTop: '0.5rem' }}
              disabled={!selectedCount || submitting || !bulkOwner.trim()}
              onClick={() => runBulkAction({ owner_email: bulkOwner.trim().toLowerCase() })}
            >
              Aplicar owner
            </button>
          </div>
          <div>
            <label className="muted">Nota operacional (lote)</label>
            <textarea value={bulkNote} onChange={(event) => setBulkNote(event.target.value)} rows={3} placeholder="Contexto da tratativa" />
            <button
              className="button-secondary"
              style={{ marginTop: '0.5rem' }}
              disabled={!selectedCount || submitting || !bulkNote.trim()}
              onClick={() => runBulkAction({ note: bulkNote.trim() })}
            >
              Anexar nota
            </button>
          </div>
        </div>
      </div>

      {error && (
        <div className="card" style={{ background: 'rgba(200,50,50,0.1)', borderLeft: '4px solid #c83232', marginBottom: '1rem' }}>
          <p style={{ color: '#c83232' }}>{error}</p>
        </div>
      )}

      {loading && <LoadingState />}

      {!loading && alerts.length === 0 && <EmptyState message="Sem excecoes no filtro atual." />}

      {!loading && alerts.length > 0 && (
        <div className="card">
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.75rem' }}>
            <label style={{ display: 'flex', gap: '0.4rem', alignItems: 'center' }}>
              <input type="checkbox" checked={selected.length === alerts.length} onChange={toggleAll} />
              Selecionar todos
            </label>
            <span className="muted">{alerts.length} itens</span>
          </div>

          <div style={{ display: 'grid', gap: '0.75rem' }}>
            {alerts.map((alert) => (
              <article key={alert.alert_code} style={{ border: '1px solid var(--sand-200)', borderRadius: '12px', padding: '0.9rem' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: '0.75rem' }}>
                  <div>
                    <label style={{ display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
                      <input
                        type="checkbox"
                        checked={selected.includes(alert.alert_code)}
                        onChange={(event) => {
                          if (event.target.checked) setSelected((prev) => [...prev, alert.alert_code])
                          else setSelected((prev) => prev.filter((code) => code !== alert.alert_code))
                        }}
                      />
                      <strong>{alert.alert_code}</strong>
                    </label>
                    <p className="muted" style={{ marginTop: '0.35rem' }}>{alert.description}</p>
                    <code style={{ fontSize: '0.78rem', color: 'var(--ink-500)' }}>{alert.evidence_query}</code>
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <span className="chip" style={{ fontWeight: 700 }}>{alert.severity}</span>
                    <div className="muted" style={{ marginTop: '0.25rem' }}>status: <strong>{alert.status}</strong></div>
                    <div className="muted">priority: <strong>{alert.priority}</strong></div>
                    <div className="muted">aging: <strong>{alert.aging_minutes}m</strong></div>
                    <div className="muted">SLA: <strong>{alert.sla_minutes}m</strong>{alert.sla_breached ? ' (violado)' : ''}</div>
                  </div>
                </div>

                <div className="grid grid-3" style={{ marginTop: '0.75rem' }}>
                  <div>
                    <div className="muted">Owner</div>
                    <strong>{alert.owner_email || 'Sem owner'}</strong>
                  </div>
                  <div>
                    <div className="muted">Primeira deteccao</div>
                    <strong>{new Date(alert.first_seen_at).toLocaleString()}</strong>
                  </div>
                  <div>
                    <div className="muted">Ultima deteccao</div>
                    <strong>{new Date(alert.last_seen_at).toLocaleString()}</strong>
                  </div>
                </div>
              </article>
            ))}
          </div>
        </div>
      )}
    </section>
  )
}
