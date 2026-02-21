import { useMemo } from 'react'
import { useLocation } from 'react-router-dom'

const labels: Record<string, { title: string; description: string }> = {
  '/admin/leads': {
    title: 'Leads de Vendas',
    description: 'Modulo replicado do ADS Connect. Aqui voce gerencia funil, qualificacao e distribuicao de leads.',
  },
  '/admin/sites': {
    title: 'Sites & Landing',
    description: 'Modulo para publicar paginas, acompanhar performance e ajustar conversao.',
  },
  '/admin/ads': {
    title: 'Anuncios / Ads',
    description: 'Modulo de campanhas e integracoes de midia paga.',
  },
  '/admin/creatives': {
    title: 'Criativos / Midia',
    description: 'Biblioteca de pecas criativas e assets para anuncios.',
  },
  '/admin/inventory': {
    title: 'Inventario Geral',
    description: 'Visao consolidada de ativos e capacidade de operacao.',
  },
  '/admin/slots': {
    title: 'Slots de Ad',
    description: 'Gestao de espacos de anuncio e disponibilidade.',
  },
  '/admin/insights': {
    title: 'Insights IA',
    description: 'Sugestoes e alertas de estrategia alimentados por IA.',
  },
  '/admin/marketing-view': {
    title: 'Marketing View',
    description: 'Painel de visao executiva para crescimento e performance.',
  },
  '/admin/reports': {
    title: 'Relatorios',
    description: 'Relatorios operacionais e executivos para acompanhamento.',
  },
  '/admin/clients': {
    title: 'Gestao de Clientes',
    description: 'Cadastro, status de contas e historico de relacionamento.',
  },
  '/admin/contracts': {
    title: 'Contratos Juridico',
    description: 'Fluxo de contratos e documentos juridicos.',
  },
  '/admin/plans': {
    title: 'Planos & Pricing',
    description: 'Definicao de planos, limites e regras de cobranca.',
  },
  '/admin/subscriptions': {
    title: 'Assinaturas',
    description: 'Ciclo de vida de assinaturas e status de renovacao.',
  },
  '/admin/billing': {
    title: 'Faturamento',
    description: 'Faturas, conciliacao e metricas de receita.',
  },
  '/admin/users': {
    title: 'Usuarios',
    description: 'Cadastro de usuarios e controle de acesso.',
  },
  '/admin/permissions': {
    title: 'Permissoes (Roles)',
    description: 'Perfis de permissao e governanca do painel.',
  },
  '/admin/integrations': {
    title: 'Integracoes API',
    description: 'Conectores e webhooks para sistemas externos.',
  },
  '/admin/audit': {
    title: 'Logs / Auditoria',
    description: 'Rastreabilidade de eventos e seguranca operacional.',
  },
  '/admin/help': {
    title: 'Suporte / Ajuda',
    description: 'Documentacao e atendimento para operacao.',
  },
  '/admin/settings': {
    title: 'Configuracoes',
    description: 'Preferencias gerais, ambiente e parametros globais.',
  },
}

export default function AdminPlaceholderPage() {
  const { pathname } = useLocation()
  const content = useMemo(() => labels[pathname] || {
    title: 'Modulo em Preparacao',
    description: 'Esta area foi replicada no shell visual do ADS Connect e sera conectada ao dominio do Reserve Connect.',
  }, [pathname])

  return (
    <section className="admin-placeholder">
      <h2>{content.title}</h2>
      <p>{content.description}</p>
      <div className="admin-placeholder-grid">
        <article>
          <strong>Status</strong>
          <span>Shell replicado</span>
        </article>
        <article>
          <strong>Integracao</strong>
          <span>Backlog de dados</span>
        </article>
        <article>
          <strong>Prioridade</strong>
          <span>Alta</span>
        </article>
      </div>
    </section>
  )
}
