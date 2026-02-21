import { useLocation } from 'react-router-dom'
import { useAuth } from '../../lib/auth'

export default function AdminTopbar() {
  const { pathname } = useLocation()
  const { signOut } = useAuth()

  const titleByPath: Array<{ prefix: string; title: string }> = [
    { prefix: '/admin/reservations', title: 'Reservas' },
    { prefix: '/admin/properties', title: 'Propriedades' },
    { prefix: '/admin/units', title: 'Unidades' },
    { prefix: '/admin/availability', title: 'Disponibilidade' },
    { prefix: '/admin/rate-plans', title: 'Rate Plans' },
    { prefix: '/admin/booking-holds', title: 'Booking Holds' },
    { prefix: '/admin/payments', title: 'Pagamentos' },
    { prefix: '/admin/financial', title: 'Razao / Ledger' },
    { prefix: '/admin/payouts', title: 'Repasses' },
    { prefix: '/admin/commission-tiers', title: 'Comissoes' },
    { prefix: '/admin/payout-schedules', title: 'Regras de Repasse' },
    { prefix: '/admin/ops', title: 'Ops Center' },
    { prefix: '/admin/marketing/site-settings', title: 'Site Settings' },
    { prefix: '/admin/marketing/social-links', title: 'Social Links' },
    { prefix: '/admin/sites', title: 'Home Hero' },
    { prefix: '/admin/insights', title: 'Insights IA' },
    { prefix: '/admin/marketing-view', title: 'Marketing View' },
    { prefix: '/admin/reports', title: 'Relatorios' },
    { prefix: '/admin/clients', title: 'Gestao de Clientes' },
    { prefix: '/admin/contracts', title: 'Contratos Juridico' },
    { prefix: '/admin/plans', title: 'Planos & Pricing' },
    { prefix: '/admin/subscriptions', title: 'Assinaturas' },
    { prefix: '/admin/billing', title: 'Faturamento' },
    { prefix: '/admin/users', title: 'Usuarios' },
    { prefix: '/admin/permissions', title: 'Permissoes (Roles)' },
    { prefix: '/admin/integrations', title: 'Integracoes API' },
    { prefix: '/admin/audit', title: 'Logs / Auditoria' },
    { prefix: '/admin/help', title: 'Suporte / Ajuda' },
    { prefix: '/admin/settings', title: 'Configuracoes' },
  ]
  const current = titleByPath.find((item) => pathname.startsWith(item.prefix))
  const title = current?.title || 'Dashboard'

  return (
    <header className="admin-topbar">
      <div>
        <h1>{title}</h1>
        <p>
          Console Principal <span>AMBIENTE LIVE</span>
        </p>
      </div>

      <div className="admin-topbar-actions">
        <button className="admin-icon-btn" aria-label="Notifications">◔</button>
        <button className="admin-icon-btn" aria-label="Settings">◌</button>
        <div className="admin-topbar-divider" />
        <div className="admin-topbar-profile">
          <div>
            <strong>JOSE ALEXANDRE</strong>
            <small>SUPER ADMIN</small>
          </div>
          <div className="admin-topbar-avatar">JA</div>
        </div>
        <button className="admin-signout" onClick={signOut}>Sair</button>
      </div>
    </header>
  )
}
