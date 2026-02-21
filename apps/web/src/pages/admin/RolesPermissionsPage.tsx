import { useEffect, useMemo, useState } from 'react'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type RoleItem = {
  slug: string
  name: string
  description: string
  is_active: boolean
}

type PermissionItem = {
  module_key: string
  action_key: string
  description: string
}

type MatrixItem = {
  role_slug: string
  module_key: string
  action_key: string
}

type MatrixResponse = {
  roles: RoleItem[]
  permissions: PermissionItem[]
  matrix: MatrixItem[]
}

export default function RolesPermissionsPage() {
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [data, setData] = useState<MatrixResponse | null>(null)
  const [roleSlug, setRoleSlug] = useState('')
  const [selected, setSelected] = useState<string[]>([])
  const [moduleFilter, setModuleFilter] = useState('')

  const load = async () => {
    setLoading(true)
    setError(null)
    try {
      const response = await postJson<{ success: boolean; data: MatrixResponse }>('admin_list_roles_permissions', {}, { auth: true })
      setData(response.data)
      if (!roleSlug && response.data?.roles?.length) {
        setRoleSlug(response.data.roles[0].slug)
      }
    } catch (err: any) {
      setError(err.message || 'Falha ao carregar matriz de permissoes')
      setData(null)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
  }, [])

  useEffect(() => {
    if (!data || !roleSlug) return
    const assigned = data.matrix
      .filter((item) => item.role_slug === roleSlug)
      .map((item) => `${item.module_key}:${item.action_key}`)
    setSelected(assigned)
  }, [data, roleSlug])

  const groupedPermissions = useMemo(() => {
    const map = new Map<string, PermissionItem[]>()
    for (const permission of data?.permissions || []) {
      const list = map.get(permission.module_key) || []
      list.push(permission)
      map.set(permission.module_key, list)
    }
    return Array.from(map.entries())
      .filter(([moduleKey]) => !moduleFilter || moduleKey === moduleFilter)
      .sort(([a], [b]) => a.localeCompare(b))
  }, [data, moduleFilter])

  const toggle = (value: string) => {
    setSelected((prev) => prev.includes(value) ? prev.filter((item) => item !== value) : [...prev, value])
  }

  const save = async () => {
    if (!roleSlug) return
    setSaving(true)
    setError(null)
    try {
      await postJson('admin_upsert_role_permissions', {
        role_slug: roleSlug,
        permissions: selected,
      }, { auth: true })
      await load()
    } catch (err: any) {
      setError(err.message || 'Falha ao salvar permissoes')
    } finally {
      setSaving(false)
    }
  }

  const setModuleState = (moduleKey: string, enabled: boolean) => {
    const values = (data?.permissions || [])
      .filter((permission) => permission.module_key === moduleKey)
      .map((permission) => `${permission.module_key}:${permission.action_key}`)

    setSelected((prev) => {
      if (enabled) {
        return Array.from(new Set([...prev, ...values]))
      }
      return prev.filter((value) => !values.includes(value))
    })
  }

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '1rem', flexWrap: 'wrap' }}>
        <h1 className="headline">Roles e Permissoes</h1>
        <button className="button-secondary" onClick={load} disabled={loading || saving}>Atualizar</button>
      </div>

      <div className="card" style={{ marginTop: '1rem', marginBottom: '1rem' }}>
        <div className="grid grid-3">
          <div>
            <label className="muted">Role</label>
            <select value={roleSlug} onChange={(e) => setRoleSlug(e.target.value)}>
              <option value="">Selecione</option>
              {(data?.roles || []).map((role) => (
                <option key={role.slug} value={role.slug}>{role.name} ({role.slug})</option>
              ))}
            </select>
          </div>
          <div>
            <label className="muted">Filtrar modulo</label>
            <select value={moduleFilter} onChange={(e) => setModuleFilter(e.target.value)}>
              <option value="">Todos</option>
              {Array.from(new Set((data?.permissions || []).map((permission) => permission.module_key))).sort().map((moduleKey) => (
                <option key={moduleKey} value={moduleKey}>{moduleKey}</option>
              ))}
            </select>
          </div>
          <div style={{ display: 'flex', alignItems: 'flex-end' }}>
            <span className="chip">selecionadas: {selected.length}</span>
          </div>
        </div>
      </div>

      {error && <div className="card"><p style={{ color: '#c83232' }}>{error}</p></div>}
      {loading && <LoadingState />}
      {!loading && !data && <EmptyState message="Sem dados de RBAC." />}

      {!loading && data && (
        <div className="card">
          {groupedPermissions.length === 0 && <EmptyState message="Sem permissoes cadastradas." />}
          {groupedPermissions.map(([moduleKey, permissions]) => (
            <div key={moduleKey} style={{ marginBottom: '1rem', borderBottom: '1px solid var(--sand-200)', paddingBottom: '0.75rem' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '0.5rem', flexWrap: 'wrap' }}>
                <strong>{moduleKey}</strong>
                <div style={{ display: 'flex', gap: '0.5rem' }}>
                  <button className="button-secondary" onClick={() => setModuleState(moduleKey, true)}>Selecionar modulo</button>
                  <button className="button-secondary" onClick={() => setModuleState(moduleKey, false)}>Limpar modulo</button>
                </div>
              </div>
              <div style={{ marginTop: '0.5rem', display: 'flex', gap: '0.75rem', flexWrap: 'wrap' }}>
                {permissions.map((permission) => {
                  const value = `${permission.module_key}:${permission.action_key}`
                  return (
                    <label key={value} style={{ display: 'flex', gap: '0.4rem', alignItems: 'center' }}>
                      <input type="checkbox" checked={selected.includes(value)} onChange={() => toggle(value)} />
                      <span>{permission.action_key}</span>
                    </label>
                  )
                })}
              </div>
            </div>
          ))}

          <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
            <button className="button-primary" onClick={save} disabled={saving || !roleSlug}>
              {saving ? 'Salvando...' : 'Salvar permissoes'}
            </button>
          </div>
        </div>
      )}
    </section>
  )
}
