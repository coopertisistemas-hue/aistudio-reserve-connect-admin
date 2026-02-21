import { useEffect, useMemo, useState } from 'react'
import LoadingState from '../../components/LoadingState'
import EmptyState from '../../components/EmptyState'
import { postJson } from '../../lib/apiClient'

type UserRole = {
  role_slug: string
  role_name: string
  is_active: boolean
}

type AdminUser = {
  id: string
  email: string
  created_at: string
  last_sign_in_at: string | null
  app_role: string | null
  roles: UserRole[]
}

type RoleItem = {
  slug: string
  name: string
  is_active: boolean
}

export default function UsersAdminPage() {
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [users, setUsers] = useState<AdminUser[]>([])
  const [roles, setRoles] = useState<RoleItem[]>([])
  const [selectedEmail, setSelectedEmail] = useState('')
  const [selectedRole, setSelectedRole] = useState('')
  const [query, setQuery] = useState('')

  const load = async () => {
    setLoading(true)
    setError(null)
    try {
      const [usersRes, rolesRes] = await Promise.all([
        postJson<{ success: boolean; data: AdminUser[] }>('admin_list_users', {}, { auth: true }),
        postJson<{ success: boolean; data: { roles: RoleItem[] } }>('admin_list_roles_permissions', {}, { auth: true }),
      ])
      setUsers(usersRes.data || [])
      setRoles(rolesRes.data?.roles || [])
    } catch (err: any) {
      setUsers([])
      setRoles([])
      setError(err.message || 'Falha ao carregar usuarios admin')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    load()
  }, [])

  const assignRole = async () => {
    if (!selectedEmail || !selectedRole) return
    setSaving(true)
    setError(null)
    try {
      await postJson('admin_upsert_user_role', {
        user_email: selectedEmail,
        role_slug: selectedRole,
        is_active: true,
      }, { auth: true })
      setSelectedRole('')
      await load()
    } catch (err: any) {
      setError(err.message || 'Falha ao atribuir role')
    } finally {
      setSaving(false)
    }
  }

  const activeUsers = useMemo(() => users.filter((u) => u.roles.some((r) => r.is_active)).length, [users])
  const filteredUsers = useMemo(() => {
    const term = query.trim().toLowerCase()
    if (!term) return users
    return users.filter((user) => user.email.toLowerCase().includes(term))
  }, [users, query])

  const setRoleState = async (userEmail: string, roleSlug: string, isActive: boolean) => {
    setSaving(true)
    setError(null)
    try {
      await postJson('admin_upsert_user_role', {
        user_email: userEmail,
        role_slug: roleSlug,
        is_active: isActive,
      }, { auth: true })
      await load()
    } catch (err: any) {
      setError(err.message || 'Falha ao atualizar role do usuario')
    } finally {
      setSaving(false)
    }
  }

  return (
    <section>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '1rem', flexWrap: 'wrap' }}>
        <h1 className="headline">Usuarios Admin</h1>
        <button className="button-secondary" onClick={load} disabled={loading || saving}>Atualizar</button>
      </div>

      <div className="grid grid-3" style={{ marginTop: '1rem', marginBottom: '1rem' }}>
        <div className="card"><div className="muted">Total usuarios</div><strong>{users.length}</strong></div>
        <div className="card"><div className="muted">Com role ativa</div><strong>{activeUsers}</strong></div>
        <div className="card"><div className="muted">Roles cadastradas</div><strong>{roles.length}</strong></div>
      </div>

      <div className="card" style={{ marginBottom: '1rem' }}>
        <h3 style={{ marginTop: 0 }}>Atribuir role</h3>
        <div className="grid grid-4" style={{ marginTop: '0.75rem' }}>
          <div>
            <label className="muted">Buscar usuario</label>
            <input value={query} onChange={(e) => setQuery(e.target.value)} placeholder="email" />
          </div>
          <div>
            <label className="muted">Usuario</label>
            <select value={selectedEmail} onChange={(e) => setSelectedEmail(e.target.value)}>
              <option value="">Selecione</option>
              {filteredUsers.map((user) => (
                <option key={user.id} value={user.email}>{user.email}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="muted">Role</label>
            <select value={selectedRole} onChange={(e) => setSelectedRole(e.target.value)}>
              <option value="">Selecione</option>
              {roles.filter((role) => role.is_active).map((role) => (
                <option key={role.slug} value={role.slug}>{role.name} ({role.slug})</option>
              ))}
            </select>
          </div>
          <div style={{ display: 'flex', alignItems: 'flex-end' }}>
            <button className="button-primary" onClick={assignRole} disabled={saving || !selectedEmail || !selectedRole}>
              {saving ? 'Salvando...' : 'Aplicar role'}
            </button>
          </div>
        </div>
      </div>

      {error && <div className="card"><p style={{ color: '#c83232' }}>{error}</p></div>}
      {loading && <LoadingState />}
      {!loading && filteredUsers.length === 0 && <EmptyState message="Nenhum usuario encontrado." />}

      {!loading && filteredUsers.length > 0 && (
        <div className="grid">
          {filteredUsers.map((user) => (
            <article key={user.id} className="card">
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '0.75rem' }}>
                <strong>{user.email}</strong>
                <span className="chip">legacy: {user.app_role || '-'}</span>
              </div>
              <div className="muted" style={{ marginTop: '0.4rem' }}>
                ultimo login: {user.last_sign_in_at ? new Date(user.last_sign_in_at).toLocaleString() : '-'}
              </div>
              <div style={{ marginTop: '0.5rem', display: 'flex', gap: '0.5rem', flexWrap: 'wrap' }}>
                {user.roles.length === 0 && <span className="chip">sem role</span>}
                {user.roles.map((role) => (
                  <button
                    key={`${user.id}-${role.role_slug}`}
                    className="chip"
                    style={{ cursor: 'pointer', border: 'none' }}
                    onClick={() => setRoleState(user.email, role.role_slug, !role.is_active)}
                    disabled={saving}
                    title={role.is_active ? 'Clique para desativar' : 'Clique para ativar'}
                  >
                    {role.role_slug}{role.is_active ? '' : ' (inativo)'}
                  </button>
                ))}
              </div>
            </article>
          ))}
        </div>
      )}
    </section>
  )
}
