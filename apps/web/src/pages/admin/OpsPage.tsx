import { useEffect, useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type HealthCheck = {
  check_name: string
  status: string
  details: string
  severity: string
  checked_at: string
}

type OpsSnapshot = {
  generated_at?: string
  ledger_imbalances: number
  stuck_payments: number
  failed_webhooks: number
  pending_cancellations?: number
  overbookings?: number
  expired_intents?: number
  blocked_locks?: number
}

type OpsSummaryResponse = {
  success: boolean
  data: {
    health: HealthCheck[]
    snapshot: OpsSnapshot
  }
}

type OpsAlert = {
  alert_code: string
  severity: 'CRITICAL' | 'WARNING' | 'INFO'
  description: string
  evidence_query: string
}

type OpsAlertsResponse = {
  success: boolean
  data: OpsAlert[]
}

type RetentionPreview = {
  audit_days: number
  webhook_days: number
  reconciliation_days: number
  audit_log_candidates: number
  webhook_candidates: number
  reconciliation_candidates: number
  dry_run: boolean
  generated_at: string
}

type RetentionPreviewResponse = {
  success: boolean
  data: RetentionPreview
}

type ReconciliationStatus = {
  last_run: {
    run_id: string
    status: string
    started_at?: string | null
    completed_at?: string | null
    error_message?: string | null
  } | null
  failed_last_7_days: number
  pending_cancellations: number
  failed_host_webhooks_last_24h: number
  failed_payment_webhooks_last_24h: number
  generated_at: string
}

type ReconciliationStatusResponse = {
  success: boolean
  data: ReconciliationStatus
}

type ReconResponse = {
  success: boolean
  data: {
    run_id: string
    summary: Record<string, number>
  }
}

function severityStyle(severity: string) {
  if (severity === 'CRITICAL') {
    return { bg: 'rgba(200,50,50,0.12)', text: '#c83232' }
  }
  if (severity === 'WARNING') {
    return { bg: 'rgba(176,102,43,0.12)', text: '#b0662b' }
  }
  return { bg: 'rgba(63,90,77,0.1)', text: '#3f5a4d' }
}

export default function OpsPage() {
  const { t } = useTranslation()
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [snapshot, setSnapshot] = useState<OpsSnapshot | null>(null)
  const [healthChecks, setHealthChecks] = useState<HealthCheck[]>([])
  const [alerts, setAlerts] = useState<OpsAlert[]>([])
  const [retentionPreview, setRetentionPreview] = useState<RetentionPreview | null>(null)
  const [reconciliationStatus, setReconciliationStatus] = useState<ReconciliationStatus | null>(null)

  const [reconLoading, setReconLoading] = useState(false)
  const [reconResult, setReconResult] = useState<ReconResponse['data'] | null>(null)

  const loadOpsData = async () => {
    setLoading(true)
    setError(null)
    try {
      const [summaryRes, alertsRes, retentionPreviewRes, reconciliationStatusRes] = await Promise.all([
        postJson<OpsSummaryResponse>('admin_ops_summary', {}, { auth: true }),
        postJson<OpsAlertsResponse>('admin_list_ops_alerts', {}, { auth: true }),
        postJson<RetentionPreviewResponse>('admin_ops_retention_preview', {}, { auth: true }),
        postJson<ReconciliationStatusResponse>('admin_ops_reconciliation_status', {}, { auth: true }),
      ])

      setSnapshot(summaryRes.data.snapshot)
      setHealthChecks(summaryRes.data.health || [])
      setAlerts(alertsRes.data || [])
      setRetentionPreview(retentionPreviewRes.data)
      setReconciliationStatus(reconciliationStatusRes.data)
    } catch (err: any) {
      setError(err.message || 'Failed to load ops data')
      setSnapshot(null)
      setHealthChecks([])
      setAlerts([])
      setRetentionPreview(null)
      setReconciliationStatus(null)
    } finally {
      setLoading(false)
    }
  }

  const triggerRecon = async () => {
    setReconLoading(true)
    try {
      const response = await postJson<ReconResponse>(
        'reconciliation_job_placeholder',
        {
          run_id: `admin_${Date.now()}`,
          dry_run: false,
        },
        { auth: true }
      )
      setReconResult(response.data)
      await loadOpsData()
    } catch {
      setReconResult(null)
    } finally {
      setReconLoading(false)
    }
  }

  useEffect(() => {
    loadOpsData()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const alertTotals = useMemo(() => {
    return alerts.reduce(
      (acc, alert) => {
        if (alert.severity === 'CRITICAL') acc.critical += 1
        else if (alert.severity === 'WARNING') acc.warning += 1
        else acc.info += 1
        return acc
      },
      { critical: 0, warning: 0, info: 0 }
    )
  }, [alerts])

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '1rem' }}>
        <h1 className="headline">{t('admin.ops')}</h1>
        <button className="button-secondary" onClick={loadOpsData} disabled={loading}>
          {t('admin.refreshOps')}
        </button>
      </div>

      {error && (
        <div className="card" style={{ background: 'rgba(200,50,50,0.1)', borderLeft: '4px solid #c83232', marginTop: '1rem' }}>
          <p style={{ color: '#c83232' }}>{error}</p>
        </div>
      )}

      {loading && <LoadingState />}

      {!loading && snapshot && (
        <div className="grid grid-4" style={{ marginTop: '1.25rem', marginBottom: '1.25rem' }}>
          <div className="card">
            <div className="muted">{t('admin.kpi.stuckPayments')}</div>
            <strong style={{ fontSize: '1.2rem' }}>{snapshot.stuck_payments || 0}</strong>
          </div>
          <div className="card">
            <div className="muted">{t('admin.kpi.failedWebhooks')}</div>
            <strong style={{ fontSize: '1.2rem' }}>{snapshot.failed_webhooks || 0}</strong>
          </div>
          <div className="card">
            <div className="muted">{t('admin.kpi.ledgerImbalances')}</div>
            <strong style={{ fontSize: '1.2rem' }}>{snapshot.ledger_imbalances || 0}</strong>
          </div>
          <div className="card">
            <div className="muted">{t('admin.opsAlerts')}</div>
            <strong style={{ fontSize: '1.2rem' }}>{alerts.length}</strong>
          </div>
        </div>
      )}

      {!loading && (
        <div className="grid grid-3" style={{ marginBottom: '1.25rem' }}>
          <div className="card">
            <div className="muted">{t('admin.criticalAlerts')}</div>
            <strong style={{ fontSize: '1.1rem', color: '#c83232' }}>{alertTotals.critical}</strong>
          </div>
          <div className="card">
            <div className="muted">{t('admin.warningAlerts')}</div>
            <strong style={{ fontSize: '1.1rem', color: '#b0662b' }}>{alertTotals.warning}</strong>
          </div>
          <div className="card">
            <div className="muted">{t('admin.infoAlerts')}</div>
            <strong style={{ fontSize: '1.1rem', color: '#3f5a4d' }}>{alertTotals.info}</strong>
          </div>
        </div>
      )}

      {!loading && alerts.length === 0 && <EmptyState message={t('admin.noOpsAlerts')} />}

      {!loading && alerts.length > 0 && (
        <div className="card" style={{ marginBottom: '1.25rem' }}>
          <div className="muted" style={{ marginBottom: '0.75rem' }}>{t('admin.opsAlerts')}</div>
          <div style={{ display: 'grid', gap: '0.75rem' }}>
            {alerts.map((alert) => {
              const style = severityStyle(alert.severity)
              return (
                <div key={alert.alert_code} style={{ borderBottom: '1px solid var(--sand-200)', paddingBottom: '0.65rem' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.25rem' }}>
                    <strong>{alert.alert_code}</strong>
                    <span className="chip" style={{ background: style.bg, color: style.text, fontWeight: 600 }}>
                      {alert.severity}
                    </span>
                  </div>
                  <div className="muted" style={{ marginBottom: '0.35rem' }}>{alert.description}</div>
                  <code style={{ fontSize: '0.78rem', color: 'var(--ink-500)' }}>{alert.evidence_query}</code>
                </div>
              )
            })}
          </div>
        </div>
      )}

      {!loading && healthChecks.length > 0 && (
        <div className="card" style={{ marginBottom: '1.25rem' }}>
          <div className="muted" style={{ marginBottom: '0.75rem' }}>{t('admin.opsHealthChecks')}</div>
          <div style={{ display: 'grid', gap: '0.6rem' }}>
            {healthChecks.map((check) => {
              const style = severityStyle(check.severity)
              return (
                <div key={check.check_name} style={{ display: 'flex', justifyContent: 'space-between', gap: '0.75rem', borderBottom: '1px solid var(--sand-200)', paddingBottom: '0.45rem' }}>
                  <div>
                    <strong>{check.check_name}</strong>
                    <div className="muted" style={{ fontSize: '0.85rem' }}>{check.details}</div>
                  </div>
                  <span className="chip" style={{ background: style.bg, color: style.text, fontWeight: 600, alignSelf: 'flex-start' }}>
                    {check.status}
                  </span>
                </div>
              )
            })}
          </div>
        </div>
      )}

      {!loading && reconciliationStatus && (
        <div className="card" style={{ marginBottom: '1.25rem' }}>
          <div className="muted" style={{ marginBottom: '0.75rem' }}>{t('admin.reconciliationStatus')}</div>
          <div className="grid grid-3" style={{ marginBottom: '0.75rem' }}>
            <div>
              <div className="muted">{t('admin.failedRecon7d')}</div>
              <strong>{reconciliationStatus.failed_last_7_days || 0}</strong>
            </div>
            <div>
              <div className="muted">{t('admin.pendingCancellations')}</div>
              <strong>{reconciliationStatus.pending_cancellations || 0}</strong>
            </div>
            <div>
              <div className="muted">{t('admin.failedWebhooks24h')}</div>
              <strong>{(reconciliationStatus.failed_host_webhooks_last_24h || 0) + (reconciliationStatus.failed_payment_webhooks_last_24h || 0)}</strong>
            </div>
          </div>
          <div className="muted" style={{ fontSize: '0.85rem' }}>
            {t('admin.lastReconRun')}: {reconciliationStatus.last_run?.run_id || '-'}
          </div>
        </div>
      )}

      {!loading && retentionPreview && (
        <div className="card" style={{ marginBottom: '1.25rem' }}>
          <div className="muted" style={{ marginBottom: '0.75rem' }}>{t('admin.retentionPreview')}</div>
          <div className="grid grid-3">
            <div>
              <div className="muted">{t('admin.auditLogCandidates')}</div>
              <strong>{retentionPreview.audit_log_candidates || 0}</strong>
            </div>
            <div>
              <div className="muted">{t('admin.webhookCandidates')}</div>
              <strong>{retentionPreview.webhook_candidates || 0}</strong>
            </div>
            <div>
              <div className="muted">{t('admin.reconCandidates')}</div>
              <strong>{retentionPreview.reconciliation_candidates || 0}</strong>
            </div>
          </div>
        </div>
      )}

      <div className="card">
        <button className="button-primary" onClick={triggerRecon} disabled={reconLoading}>
          {reconLoading ? '...' : t('admin.runRecon')}
        </button>
        {reconResult && (
          <div style={{ marginTop: '1rem' }}>
            <div className="muted">{t('admin.runId')}: {reconResult.run_id}</div>
            <pre style={{ background: 'var(--sand-200)', padding: '1rem', borderRadius: '12px' }}>
              {JSON.stringify(reconResult.summary, null, 2)}
            </pre>
          </div>
        )}
      </div>
    </section>
  )
}
