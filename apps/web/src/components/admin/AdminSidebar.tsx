import { NavLink } from 'react-router-dom'

type NavItemProps = {
  to: string
  label: string
  icon: string
  end?: boolean
}

type NavGroup = {
  title: string
  items: NavItemProps[]
}

function NavItem({ to, label, icon, end = false }: NavItemProps) {
  return (
    <NavLink to={to} end={end} className={({ isActive }) => `admin-nav-item${isActive ? ' active' : ''}`}>
      <span className="admin-nav-icon" aria-hidden="true">{icon}</span>
      <span>{label}</span>
    </NavLink>
  )
}

function SectionTitle({ children }: { children: string }) {
  return <p className="admin-nav-section">{children}</p>
}

export default function AdminSidebar() {
  const menuGroups: NavGroup[] = [
    {
      title: 'OPERACAO',
      items: [
        { to: '/admin', label: 'Dashboard', icon: '◉', end: true },
        { to: '/admin/reservations', label: 'Reservas', icon: '◎' },
        { to: '/admin/properties', label: 'Propriedades', icon: '◍' },
        { to: '/admin/units', label: 'Unidades', icon: '◌' },
        { to: '/admin/availability', label: 'Disponibilidade', icon: '◈' },
        { to: '/admin/rate-plans', label: 'Rate Plans', icon: '◻' },
        { to: '/admin/booking-holds', label: 'Booking Holds', icon: '◧' },
      ],
    },
    {
      title: 'FINANCEIRO',
      items: [
        { to: '/admin/payments', label: 'Pagamentos', icon: '◔' },
        { to: '/admin/financial', label: 'Razao / Ledger', icon: '◕' },
        { to: '/admin/payouts', label: 'Repasses', icon: '◑' },
        { to: '/admin/commission-tiers', label: 'Comissoes', icon: '◐' },
        { to: '/admin/payout-schedules', label: 'Regras de Repasse', icon: '◒' },
      ],
    },
    {
      title: 'OPS',
      items: [
        { to: '/admin/ops', label: 'Ops Center', icon: '◇' },
        { to: '/admin/exceptions', label: 'Exception Queue', icon: '◩' },
        { to: '/admin/release-control', label: 'Release Control', icon: '◫' },
        { to: '/admin/insights', label: 'Insights', icon: '◬' },
        { to: '/admin/reports', label: 'Relatorios', icon: '◭' },
      ],
    },
    {
      title: 'CONTEUDO',
      items: [
        { to: '/admin/marketing/site-settings', label: 'Site Settings', icon: '◐' },
        { to: '/admin/marketing/social-links', label: 'Social Links', icon: '◒' },
        { to: '/admin/sites', label: 'Home Hero', icon: '◉' },
      ],
    },
    {
      title: 'SISTEMA',
      items: [
        { to: '/admin/users', label: 'Usuarios', icon: '◉' },
        { to: '/admin/permissions', label: 'Permissoes (Roles)', icon: '◎' },
        { to: '/admin/integrations', label: 'Integracoes API', icon: '◍' },
        { to: '/admin/audit', label: 'Logs / Auditoria', icon: '◌' },
        { to: '/admin/help', label: 'Suporte / Ajuda', icon: '◈' },
        { to: '/admin/settings', label: 'Configuracoes', icon: '◻' },
      ],
    },
  ]

  return (
    <aside className="admin-sidebar">
      <div className="admin-brand">
        <div className="admin-brand-badge">A</div>
        <div>
          <strong>ADS CONNECT</strong>
          <small>ADMIN CONSOLE</small>
        </div>
      </div>

      {menuGroups.map((group) => (
        <nav className="admin-nav-group" key={group.title}>
          <SectionTitle>{group.title}</SectionTitle>
          {group.items.map((item) => (
            <NavItem key={item.to} to={item.to} end={item.end} icon={item.icon} label={item.label} />
          ))}
        </nav>
      ))}

      <div className="admin-sidebar-user">
        <div className="admin-sidebar-user-avatar">JA</div>
        <div>
          <strong>Jose Alexandre</strong>
          <small>Super Admin</small>
        </div>
      </div>
    </aside>
  )
}
