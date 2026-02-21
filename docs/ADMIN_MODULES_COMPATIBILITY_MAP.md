# Reserve Connect Admin - Mapa de Modulos e Compatibilidade

Data: 2026-02-20  
Projeto: `aistudio-reserve-connect-admin`

## Objetivo

Mapear, por categoria, todos os modulos que devem existir no Admin para manter aderencia ao dominio Reserve Connect, classificando o estado atual e os gaps para implementacao.

## Fontes auditadas

- Frontend admin: `apps/web/src/pages/admin/`, `apps/web/src/components/admin/`, `apps/web/src/layouts/AdminLayout.tsx`
- Rotas: `apps/web/src/App.tsx`
- Backend BFF: `supabase/functions/*/index.ts`
- Base funcional e roadmap: `docs/MASTER_EXECUTION_PLAN_v1.2.md`, `docs/FRONTEND_EXEC_PLAN_REPORT.md`, `docs/SPRINT_2_CLOSEOUT_CHECKLIST.md`, `docs/SPRINT_3_CLOSEOUT_CHECKLIST.md`, `docs/SPRINT_4_PHASE1_SUMMARY.md`
- Estrutura de dados: `supabase/migrations/*.sql`

## Criterio de classificacao

- `implemented`: UI + rota + edge functions operacionais
- `partial`: parte relevante pronta, mas sem UX completa ou sem governanca/config
- `placeholder`: rota/tela criada sem implementacao de dominio
- `missing`: modulo esperado pelo dominio, sem implementacao
- `roadmap`: previsto para sprints futuras no plano mestre

## Inventario de modulos por categoria

| Categoria | Modulo | Status | Evidencia principal |
|---|---|---|---|
| Operacao de Reservas | Dashboard Operacional | partial | `apps/web/src/pages/admin/DashboardPage.tsx` |
| Operacao de Reservas | Reservas (lista + cancelamento) | implemented | `apps/web/src/pages/admin/ReservationsPage.tsx`, `supabase/functions/admin_list_reservations/index.ts`, `supabase/functions/cancel_reservation/index.ts` |
| Operacao de Reservas | Propriedades (lista/filtro) | implemented | `apps/web/src/pages/admin/PropertiesPage.tsx`, `supabase/functions/admin_list_properties/index.ts` |
| Operacao de Reservas | Unidades/Tipologias | missing | `reserve.unit_map` existe, sem pagina admin dedicada |
| Operacao de Reservas | Calendario de disponibilidade | missing | `reserve.availability_calendar` existe, sem UI admin dedicada |
| Operacao de Reservas | Rate plans e precificacao | missing | `reserve.rate_plans` existe, sem UI admin dedicada |
| Operacao de Reservas | Intents/Holds (observabilidade) | missing | `create_booking_intent` existe, sem console de holds/TTL |
| Pagamentos e Financeiro | Pagamentos (lista + detalhe + refund) | implemented | `apps/web/src/pages/admin/PaymentsPage.tsx`, `admin_list_payments`, `admin_get_payment_detail`, `admin_refund_payment` |
| Pagamentos e Financeiro | Ledger (lista + drilldown transacao) | implemented | `apps/web/src/pages/admin/FinancialPage.tsx`, `admin_list_ledger_entries`, `admin_get_ledger_transaction` |
| Pagamentos e Financeiro | Payouts (lista + detalhe) | implemented | `apps/web/src/pages/admin/PayoutsPage.tsx`, `apps/web/src/pages/admin/PayoutDetailPage.tsx`, `admin_list_payouts`, `admin_get_payout_detail` |
| Pagamentos e Financeiro | Comissoes (tiers) | missing | `reserve.commission_tiers` existe, sem modulo admin |
| Pagamentos e Financeiro | Regras de repasse (schedules) | missing | `reserve.payout_schedules` existe, sem modulo admin |
| Ops e Confiabilidade | Ops Center (kpis, alertas, health, recon, retention) | implemented | `apps/web/src/pages/admin/OpsPage.tsx`, `admin_list_ops_alerts`, `admin_ops_reconciliation_status`, `admin_ops_retention_preview`, `reconciliation_job_placeholder` |
| Ops e Confiabilidade | Exception Queue de integracao | partial | base operacional existe, UX de fila/processamento ainda nao |
| Ops e Confiabilidade | Ack/owner/SLA de alerta | missing | alertas listados, sem workflow de ownership |
| Conteudo e Canal | Site Settings | implemented | `apps/web/src/pages/admin/marketing/SiteSettingsPage.tsx`, `get_site_settings`, `update_site_settings` |
| Conteudo e Canal | Social Links | implemented | `apps/web/src/pages/admin/marketing/SocialLinksPage.tsx`, `get_social_links`, `update_social_links` |
| Conteudo e Canal | Home Hero publico | partial | `get_public_home_hero` existe, sem tela admin dedicada |
| Governanca e Seguranca | RBAC (verificacao de role) | partial | `supabase/functions/admin_check_role/index.ts`, `_shared/auth.ts` |
| Governanca e Seguranca | Usuarios admin | missing | sem pagina CRUD/gestao de usuarios |
| Governanca e Seguranca | Permissoes/Roles UI | missing | sem pagina para matriz de permissoes |
| Governanca e Seguranca | Auditoria operacional | missing | tabelas de audit existem, sem UI consultiva |
| Governanca e Seguranca | Integracoes/Webhooks console | missing | webhooks existem, sem modulo de governanca |
| Menu ADS replicado | Leads/Sites/Ads/Criativos/etc. | placeholder | `apps/web/src/pages/admin/AdminPlaceholderPage.tsx` + rotas em `apps/web/src/App.tsx` |
| Owner Portal | Owner Dashboards read-only | roadmap | previsto em Sprint 9-10 no plano mestre |
| AP/AR e Servicos | AP/AR + catalogo servicos | roadmap | previsto Sprint 11-12 + placeholders em migrations `006`/`008` |

## Modulos atualmente reais no frontend admin

- Reais (dominio conectado): `Dashboard`, `Properties`, `Reservations`, `Payments`, `Financial`, `Payouts`, `PayoutDetail`, `Ops`, `SiteSettings`, `SocialLinks`
- Placeholder (apenas estrutura visual): modulos da navegacao ADS adicionados via `AdminPlaceholderPage`

## Compatibilidade com o dominio Reserve Connect

### Compatibilidade alta (ja aderente)

- Nucleo de reservas e cancelamento
- Nucleo financeiro (pagamentos, ledger, payouts)
- Nucleo de operacoes (alertas, reconciliacao, health, retention)
- Configuracao de canal (site/social)

### Compatibilidade media (precisa completar)

- Dashboard executivo ainda com dados sinteticos e componentes visuais nao 100% orientados a reserva
- RBAC sem modulo de administracao (somente validacao backend)
- Recon/ops sem workflow de tratativa (ack/owner/sla)

### Compatibilidade baixa / desalinhamento atual

- Taxonomia ADS no menu principal (Leads/Ads/Criativos) nao representa o dominio principal de hospedagem/reserva
- Falta de modulos de disponibilidade, unidades e rate plans, que sao centrais para operacao de reservas

## Gaps criticos para fechar compatibilidade

1. Substituir navegacao placeholder por modulos de dominio Reserve (Unidades, Calendario, Rate Plans, Comissoes, Schedules).
2. Criar governanca admin completa (Usuarios, Roles, Auditoria, Integracoes).
3. Implementar observabilidade de booking intents e inventory holds no admin.
4. Evoluir Ops com ciclo completo de excecao (owner assignment, status workflow, evidencias).
5. Reposicionar menu final por dominio (Operacao, Financeiro, Ops, Conteudo, Governanca, Roadmap).

## Modelo recomendado de categorias finais do Admin

### 1) Operacao

- Dashboard
- Reservas
- Propriedades
- Unidades
- Disponibilidade
- Rate Plans

### 2) Financeiro

- Pagamentos
- Ledger
- Payouts
- Comissoes
- Regras de Repasse

### 3) Ops e Confiabilidade

- Ops Center
- Alertas
- Reconciliacao
- Exception Queue
- Runbooks

### 4) Conteudo e Canal

- Site Settings
- Social Links
- Hero/Home
- SEO

### 5) Governanca

- Usuarios
- Roles e Permissoes
- Auditoria
- Integracoes e Webhooks

### 6) Roadmap

- Owner Portal (read-only)
- AP/AR
- Servicos

## Decisao arquitetural recomendada

- Manter o visual Connect/ADS (excelencia de UX), mas tornar a informacao e os modulos 100% orientados ao dominio Reserve Connect.
- Tratar os modulos ADS genericos como referencia de layout/padroes, nao como IA de negocio primaria.
- Evoluir por sprints com trilhas paralelas: dominio (dados/processos), UX (layout), governanca (seguranca/compliance).
