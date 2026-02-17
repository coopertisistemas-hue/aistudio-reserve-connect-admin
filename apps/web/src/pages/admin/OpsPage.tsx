import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import LoadingState from '../../components/LoadingState'
import { postJson } from '../../lib/apiClient'

type ReconResponse = {
  success: boolean
  data: {
    run_id: string
    summary: Record<string, number>
  }
}

export default function OpsPage() {
  const { t } = useTranslation()
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<ReconResponse['data'] | null>(null)

  const triggerRecon = async () => {
    setLoading(true)
    try {
      const response = await postJson<ReconResponse>('reconciliation_job_placeholder', {
        run_id: `admin_${Date.now()}`,
        dry_run: false,
      }, { auth: true })
      setResult(response.data)
    } catch (error) {
      setResult(null)
    } finally {
      setLoading(false)
    }
  }

  return (
    <section>
      <h1 className="headline">{t('admin.ops')}</h1>
      <div className="card" style={{ marginTop: '1.5rem' }}>
        <button className="button-primary" onClick={triggerRecon}>
          {t('admin.runRecon')}
        </button>
        {loading && <LoadingState />}
        {result && (
          <div style={{ marginTop: '1rem' }}>
            <div className="muted">{t('admin.runId')}: {result.run_id}</div>
            <pre style={{ background: 'var(--sand-200)', padding: '1rem', borderRadius: '12px' }}>
              {JSON.stringify(result.summary, null, 2)}
            </pre>
          </div>
        )}
      </div>
    </section>
  )
}
