import { useEffect, useState } from 'react'
import { postJson } from '../../lib/apiClient'
import LoadingState from '../../components/LoadingState'

type FeatureFlag = {
  id: string
  module_key: string
  enabled: boolean
  rollout_percent: number
  note: string | null
}

type CityRollout = {
  id: string
  city_code: string
  is_enabled: boolean
  phase: string
  note: string | null
}

export default function RolloutControlPage() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [flags, setFlags] = useState<FeatureFlag[]>([])
  const [cities, setCities] = useState<CityRollout[]>([])

  const load = async () => {
    setLoading(true)
    setError(null)
    try {
      const [flagsRes, citiesRes] = await Promise.all([
        postJson<{ success: boolean; data: FeatureFlag[] }>('admin_list_feature_flags', {}, { auth: true }),
        postJson<{ success: boolean; data: CityRollout[] }>('admin_list_city_rollouts', {}, { auth: true }),
      ])
      setFlags(flagsRes.data || [])
      setCities(citiesRes.data || [])
    } catch (err: any) {
      setError(err.message || 'Falha ao carregar rollout control')
      setFlags([])
      setCities([])
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
  }, [])

  const upsertFlag = async (moduleKey: string, enabled: boolean, rolloutPercent: number) => {
    await postJson('admin_upsert_feature_flag', {
      module_key: moduleKey,
      enabled,
      rollout_percent: rolloutPercent,
      note: 'updated from rollout control',
    }, { auth: true })
    await load()
  }

  const upsertCity = async (cityCode: string, isEnabled: boolean, phase: string) => {
    await postJson('admin_upsert_city_rollout', {
      city_code: cityCode,
      is_enabled: isEnabled,
      phase,
      note: 'updated from rollout control',
    }, { auth: true })
    await load()
  }

  const rollbackAll = async () => {
    await postJson('admin_rollout_rollback', {
      scope: 'all',
      reason: 'manual rollback test from admin',
    }, { auth: true })
    await load()
  }

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '1rem', flexWrap: 'wrap' }}>
        <h1 className="headline">Rollout Control</h1>
        <div style={{ display: 'flex', gap: '0.5rem' }}>
          <button className="button-secondary" onClick={load} disabled={loading}>Atualizar</button>
          <button className="button-primary" onClick={rollbackAll} disabled={loading}>Rollback global</button>
        </div>
      </div>

      {error && (
        <div className="card" style={{ marginTop: '1rem', background: 'rgba(200,50,50,0.1)', borderLeft: '4px solid #c83232' }}>
          <p style={{ color: '#c83232', margin: 0 }}>{error}</p>
        </div>
      )}

      {loading && <LoadingState />}

      {!loading && (
        <>
          <div className="card" style={{ marginTop: '1rem' }}>
            <h3 style={{ marginTop: 0 }}>Feature flags por modulo</h3>
            {flags.length === 0 && <p className="muted">Sem flags cadastradas.</p>}
            {flags.length > 0 && (
              <div style={{ display: 'grid', gap: '0.6rem' }}>
                {flags.map((flag) => (
                  <div key={flag.id} style={{ display: 'flex', justifyContent: 'space-between', gap: '0.75rem', borderBottom: '1px solid var(--sand-200)', paddingBottom: '0.45rem' }}>
                    <div>
                      <strong>{flag.module_key}</strong>
                      <div className="muted">rollout: {flag.rollout_percent}%</div>
                    </div>
                    <div style={{ display: 'flex', gap: '0.4rem' }}>
                      <button className="button-secondary" onClick={() => upsertFlag(flag.module_key, !flag.enabled, flag.enabled ? 0 : Math.max(flag.rollout_percent, 10))}>
                        {flag.enabled ? 'Disable' : 'Enable'}
                      </button>
                      <button className="button-secondary" onClick={() => upsertFlag(flag.module_key, true, Math.min(flag.rollout_percent + 10, 100))}>+10%</button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>

          <div className="card" style={{ marginTop: '1rem' }}>
            <h3 style={{ marginTop: 0 }}>Rollout por cidade</h3>
            {cities.length === 0 && <p className="muted">Sem controles de cidade cadastrados.</p>}
            {cities.length > 0 && (
              <div style={{ display: 'grid', gap: '0.6rem' }}>
                {cities.map((city) => (
                  <div key={city.id} style={{ display: 'flex', justifyContent: 'space-between', gap: '0.75rem', borderBottom: '1px solid var(--sand-200)', paddingBottom: '0.45rem' }}>
                    <div>
                      <strong>{city.city_code}</strong>
                      <div className="muted">phase: {city.phase}</div>
                    </div>
                    <div style={{ display: 'flex', gap: '0.4rem' }}>
                      <button className="button-secondary" onClick={() => upsertCity(city.city_code, !city.is_enabled, city.is_enabled ? 'rollback' : 'pilot')}>
                        {city.is_enabled ? 'Disable city' : 'Enable city'}
                      </button>
                      <button className="button-secondary" onClick={() => upsertCity(city.city_code, true, 'ga')}>Set GA</button>
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
