import { useEffect, useState } from 'react'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type AuditEvent = {
  id: string
  table_name: string
  action: string
  actor_type: string
  actor_id: string | null
  city_code: string | null
  created_at: string
}

export default function AuditLogPage() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [events, setEvents] = useState<AuditEvent[]>([])
  const [actorFilter, setActorFilter] = useState('')
  const [tableFilter, setTableFilter] = useState('')
  const [limit, setLimit] = useState('200')

  const load = async () => {
    setLoading(true)
    setError(null)
    try {
      const response = await postJson<{ success: boolean; data: AuditEvent[] }>('admin_list_audit_events', {
        actor: actorFilter || null,
        table_name: tableFilter || null,
        limit: Number(limit) || 200,
      }, { auth: true })
      setEvents(response.data || [])
    } catch (err: any) {
      setEvents([])
      setError(err.message || 'Falha ao carregar auditoria')
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
        <h1 className="headline">Logs de Auditoria</h1>
        <button className="button-secondary" onClick={load} disabled={loading}>Atualizar</button>
      </div>

      <div className="card" style={{ marginTop: '1rem', marginBottom: '1rem' }}>
        <div className="grid grid-4">
          <div>
            <label className="muted">Actor contains</label>
            <input value={actorFilter} onChange={(e) => setActorFilter(e.target.value)} placeholder="email / id" />
          </div>
          <div>
            <label className="muted">Table name</label>
            <input value={tableFilter} onChange={(e) => setTableFilter(e.target.value)} placeholder="payments" />
          </div>
          <div>
            <label className="muted">Limite</label>
            <input type="number" min={10} max={1000} value={limit} onChange={(e) => setLimit(e.target.value)} />
          </div>
          <div style={{ display: 'flex', alignItems: 'flex-end' }}>
            <button className="button-primary" onClick={load} disabled={loading}>Aplicar filtros</button>
          </div>
        </div>
        <div style={{ marginTop: '0.75rem', display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
          {['payments', 'reservations', 'payouts', 'commission_tiers', 'payout_schedules'].map((table) => (
            <button
              key={table}
              className="button-secondary"
              onClick={() => {
                setTableFilter(table)
                setTimeout(load, 0)
              }}
            >
              {table}
            </button>
          ))}
          <button
            className="button-secondary"
            onClick={() => {
              setActorFilter('')
              setTableFilter('')
              setLimit('200')
              setTimeout(load, 0)
            }}
          >
            Limpar
          </button>
        </div>
      </div>

      {error && <div className="card"><p style={{ color: '#c83232' }}>{error}</p></div>}
      {loading && <LoadingState />}
      {!loading && events.length === 0 && <EmptyState message="Sem eventos para os filtros aplicados." />}

      {!loading && events.length > 0 && (
        <div className="grid">
          {events.map((event) => (
            <article className="card" key={event.id}>
              <div style={{ display: 'flex', justifyContent: 'space-between', gap: '0.75rem' }}>
                <strong>{event.table_name}</strong>
                <span className="chip">{event.action}</span>
              </div>
              <div className="muted" style={{ marginTop: '0.4rem' }}>actor: {event.actor_id || '-'} ({event.actor_type})</div>
              <div className="muted">city: {event.city_code || '-'}</div>
              <div className="muted">{new Date(event.created_at).toLocaleString()}</div>
            </article>
          ))}
        </div>
      )}
    </section>
  )
}
