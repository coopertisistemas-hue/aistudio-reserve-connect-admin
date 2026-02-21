# Connect Excellence - Backlog Executavel por Sprint

Data: 2026-02-20  
Projeto: `aistudio-reserve-connect-admin`

## Objetivo

Transformar o plano estrategico em backlog operacional, com pacotes implementaveis, estimativas e dependencias claras.

## Convencoes

- Escala de esforco: `S` (<= 2 dias), `M` (3-5 dias), `L` (6-10 dias)
- Story points (SP): 1, 2, 3, 5, 8, 13
- Tipo: `FE`, `BE`, `DB`, `QA`, `DEVOPS`, `PRODUCT`
- Criticidade: `P0`, `P1`, `P2`

## Sequencia macro

1. S0 Alinhamento e congelamento do escopo
2. S1 Operacao core de reservas
3. S2 Governanca financeira
4. S3 Ops workflow avancado
5. S4 RBAC + auditoria + integracoes
6. S5 Conteudo premium
7. S6 Estabilizacao e qualidade
8. S7 Rollout controlado

## Fases macro (agrupamento de sprints)

### Fase 1 - Foundation Domain

- S0: Arquitetura e backlog base
- S1: Operacao core de reservas
- S2: Governanca financeira

### Fase 2 - Reliability and Governance

- S3: Ops workflow avancado
- S4: RBAC, auditoria e integracoes

### Fase 3 - Experience and Launch Readiness

- S5: Conteudo premium
- S6: Estabilizacao e qualidade
- S7: Rollout controlado e handoff

## Gate de QA obrigatorio por sprint

Cada sprint so pode ser considerada encerrada quando passar por este fluxo:

1. `Dev Complete`: implementacao finalizada + build verde.
2. `QA Execute`: execucao dos smoke scripts e testes da trilha da sprint.
3. `QA Approve`: aprovacao formal (sem blocker aberto).
4. `Git Update`: apenas apos aprovacao, atualizar git (commit, push, PR/merge).

### Policy de update no git (apos QA)

- Nao finalizar sprint com merge sem aprovacao QA registrada.
- Commit message deve referenciar sprint e lote aprovado.
- PR deve conter evidencia de QA (logs, checklist, status smoke).
- Merge em `main` somente com status `QA Approved`.

Template oficial de signoff:

- `docs/templates/SPRINT_QA_SIGNOFF_TEMPLATE.md`

---

## Sprint S0 - Arquitetura de Modulos e Backlog Base

### Objetivo

Congelar taxonomia do admin Reserve e preparar backlog tecnico detalhado para execucao sem ambiguidade.

| ID | Item | Tipo | Criticidade | Estimativa | Dependencias |
|---|---|---|---|---|---|
| S0-01 | Congelar categorias finais do admin (Operacao, Financeiro, Ops, Conteudo, Governanca, Roadmap) | PRODUCT | P0 | M / 5 SP | Nenhuma |
| S0-02 | Revisar e aprovar `ADMIN_MODULES_COMPATIBILITY_MAP.md` com stakeholders | PRODUCT | P0 | S / 3 SP | S0-01 |
| S0-03 | Criar matriz de ownership (modulo -> owner produto/tech) | PRODUCT | P1 | S / 2 SP | S0-02 |
| S0-04 | Quebrar epicos em issues tecnicas por sprint | PRODUCT | P0 | M / 5 SP | S0-02 |
| S0-05 | Definir template padrao de DoD, riscos, rollback por issue | PRODUCT/QA | P1 | S / 2 SP | S0-04 |

### Criterio de pronto S0

- Escopo aprovado e backlog priorizado, sem itens "placeholder sem destino".
- QA do artefato documental aprovado e registrado.

---

## Sprint S1 - Operacao Core de Reservas

### Objetivo

Entregar modulos essenciais de operacao de hospedagem: unidades, disponibilidade, rate plans, holds.

| ID | Item | Tipo | Criticidade | Estimativa | Dependencias |
|---|---|---|---|---|---|
| S1-01 | Criar edge function `admin_list_units` + filtros por propriedade/cidade/status | BE | P0 | M / 5 SP | S0-04 |
| S1-02 | Criar edge function `admin_upsert_unit` com validacao de capacidade/ocupacao | BE | P0 | M / 5 SP | S1-01 |
| S1-03 | Criar edge function `admin_list_availability` com pagina e range de datas | BE | P0 | M / 5 SP | S0-04 |
| S1-04 | Criar edge function `admin_upsert_availability` (bloqueio, preco, min stay) | BE | P0 | L / 8 SP | S1-03 |
| S1-05 | Criar edge function `admin_list_rate_plans` + `admin_upsert_rate_plan` | BE/DB | P0 | L / 8 SP | S0-04 |
| S1-06 | Criar edge function `admin_list_booking_holds` (intents/locks/ttl) | BE | P1 | M / 5 SP | S0-04 |
| S1-07 | Implementar pagina Admin `UnitsPage` com filtros + CRUD basico | FE | P0 | L / 8 SP | S1-01,S1-02 |
| S1-08 | Implementar pagina Admin `AvailabilityPage` (grade por data) | FE | P0 | L / 8 SP | S1-03,S1-04 |
| S1-09 | Implementar pagina Admin `RatePlansPage` | FE | P0 | M / 5 SP | S1-05 |
| S1-10 | Implementar pagina Admin `BookingHoldsPage` | FE | P1 | M / 5 SP | S1-06 |
| S1-11 | Atualizar navegacao e i18n para modulos operacionais reais | FE | P0 | S / 3 SP | S1-07,S1-08,S1-09 |
| S1-12 | Smoke funcional operacao (units/availability/rate plans/holds) | QA | P0 | M / 5 SP | S1-07..S1-11 |

### Criterio de pronto S1

- Time operacional consegue editar disponibilidade e rate plans sem SQL manual.
- QA sprint S1 aprovado (smoke operacao + checklist de regressao).
- Git atualizado somente apos aprovacao QA.

---

## Sprint S2 - Governanca Financeira

### Objetivo

Completar financeiro com configuracao de comissoes e regras de repasse, com trilha auditavel.

| ID | Item | Tipo | Criticidade | Estimativa | Dependencias |
|---|---|---|---|---|---|
| S2-01 | Criar `admin_list_commission_tiers` e `admin_upsert_commission_tier` | BE/DB | P0 | M / 5 SP | S0-04 |
| S2-02 | Criar `admin_list_payout_schedules` e `admin_upsert_payout_schedule` | BE/DB | P0 | M / 5 SP | S0-04 |
| S2-03 | Criar auditoria de alteracao financeira (before/after, actor, reason) | BE/DB | P0 | M / 5 SP | S2-01,S2-02 |
| S2-04 | Pagina `CommissionTiersPage` com simulador de impacto | FE | P0 | M / 5 SP | S2-01 |
| S2-05 | Pagina `PayoutSchedulesPage` com validacao de conflitos | FE | P0 | M / 5 SP | S2-02 |
| S2-06 | Timeline de auditoria financeira no admin | FE | P1 | S / 3 SP | S2-03 |
| S2-07 | Testes de regressao de payouts e reconciliacao apos mudanca de regra | QA | P0 | M / 5 SP | S2-04,S2-05 |

### Criterio de pronto S2

- Comissoes e repasses configuraveis com rastreabilidade total.
- QA sprint S2 aprovado (financeiro + reconciliacao).
- Git atualizado somente apos aprovacao QA.

---

## Sprint S3 - Ops Workflow Excellence

### Objetivo

Evoluir Ops para fluxo ativo de tratativa com ownership, SLA e estado.

| ID | Item | Tipo | Criticidade | Estimativa | Dependencias |
|---|---|---|---|---|---|
| S3-01 | Modelo de estado para alertas (`open`, `ack`, `in_progress`, `resolved`, `snoozed`) | DB/BE | P0 | M / 5 SP | S0-04 |
| S3-02 | Endpoints para assign owner, atualizar status, adicionar notas | BE | P0 | M / 5 SP | S3-01 |
| S3-03 | Criar `ExceptionQueuePage` (host/webhook/payment/cancel) | FE | P0 | L / 8 SP | S3-02 |
| S3-04 | Incluir aging e SLA timers na OpsPage | FE | P1 | M / 5 SP | S3-02 |
| S3-05 | Acoes em lote (ack/resolver/reassign) | FE/BE | P1 | M / 5 SP | S3-03,S3-04 |
| S3-06 | Notificacao interna para alertas criticos sem owner | BE | P1 | S / 3 SP | S3-02 |
| S3-07 | Smoke script Ops lifecycle (open -> resolved) | QA | P0 | M / 5 SP | S3-03..S3-05 |

### Criterio de pronto S3

- Incidente operacional pode ser tratado fim-a-fim dentro do admin.
- QA sprint S3 aprovado (ciclo de alerta completo).
- Git atualizado somente apos aprovacao QA.

---

## Sprint S4 - Governanca, RBAC e Integracoes

### Objetivo

Fechar camada de seguranca operacional com RBAC granular, usuarios e auditoria consultiva.

| ID | Item | Tipo | Criticidade | Estimativa | Dependencias |
|---|---|---|---|---|---|
| S4-01 | Modelar permissoes granulares por acao e modulo | DB/BE | P0 | M / 5 SP | S0-04 |
| S4-02 | Expandir `admin_check_role` para matriz efetiva de permissoes | BE | P0 | M / 5 SP | S4-01 |
| S4-03 | Criar `UsersAdminPage` (listagem, ativacao, escopo) | FE/BE | P0 | M / 5 SP | S4-02 |
| S4-04 | Criar `RolesPermissionsPage` (matriz editavel) | FE/BE | P0 | L / 8 SP | S4-02 |
| S4-05 | Criar `AuditLogPage` com filtros por ator/entidade/periodo | FE/BE | P0 | M / 5 SP | S4-01 |
| S4-06 | Criar `IntegrationsPage` (status webhooks/chaves/ultimos erros) | FE/BE | P1 | M / 5 SP | S4-01 |
| S4-07 | Suite de testes de autorizacao negativa/positiva por role | QA | P0 | M / 5 SP | S4-03..S4-06 |

### Criterio de pronto S4

- Nenhuma acao sensivel sem permissao explicita e trilha de auditoria.
- QA sprint S4 aprovado (matriz RBAC positiva/negativa).
- Git atualizado somente apos aprovacao QA.

---

## Sprint S5 - Conteudo Premium e Canal

### Objetivo

Concluir operacao de conteudo do canal publico sem dependencia de deploy.

| ID | Item | Tipo | Criticidade | Estimativa | Dependencias |
|---|---|---|---|---|---|
| S5-01 | Criar `HomeHeroPage` para gestao de blocos hero | FE/BE | P1 | M / 5 SP | S4-02 |
| S5-02 | Criar `SeoSettingsPage` por tenant/cidade | FE/BE | P1 | M / 5 SP | S5-01 |
| S5-03 | Validadores de links/ativos de marca (social/logo/favicon) | FE | P2 | S / 3 SP | S5-01 |
| S5-04 | Fluxo de preview e publicacao controlada | FE/BE | P1 | M / 5 SP | S5-01,S5-02 |
| S5-05 | Smoke de conteudo publico (site settings/social/hero) | QA | P1 | S / 3 SP | S5-04 |

### Criterio de pronto S5

- Marketing opera conteudo critico com preview, sem regressao de SEO/canal.
- QA sprint S5 aprovado (conteudo publico + validacoes).
- Git atualizado somente apos aprovacao QA.

---

## Sprint S6 - Estabilizacao, Qualidade e Performance

### Objetivo

Consolidar confiabilidade para release com foco em nao-regressao.

| ID | Item | Tipo | Criticidade | Estimativa | Dependencias |
|---|---|---|---|---|---|
| S6-01 | Consolidar smoke scripts por trilha (operacao, financeiro, ops, governanca) | QA | P0 | M / 5 SP | S1..S5 |
| S6-02 | Testes de carga para telas e funcoes criticas | QA/DEVOPS | P1 | M / 5 SP | S6-01 |
| S6-03 | Hardening de acessibilidade e i18n de todo admin | FE/QA | P1 | M / 5 SP | S1..S5 |
| S6-04 | Otimizacao de bundles e metricas de performance | FE | P1 | S / 3 SP | S6-03 |
| S6-05 | Checklist de release + rollback drill | QA/DEVOPS | P0 | S / 3 SP | S6-01..S6-04 |

### Criterio de pronto S6

- Release candidate aprovado com smoke completo e rollback testado.
- QA sprint S6 aprovado (suite completa e performance minima).
- Git atualizado somente apos aprovacao QA.

---

## Sprint S7 - Rollout Controlado e Handoff

### Objetivo

Entrar em producao com rollout seguro e operacao treinada.

| ID | Item | Tipo | Criticidade | Estimativa | Dependencias |
|---|---|---|---|---|---|
| S7-01 | Feature flags por modulo (ativacao gradual) | BE/DEVOPS | P0 | M / 5 SP | S6-05 |
| S7-02 | Rollout por cidade com monitoramento de KPI | DEVOPS/PRODUCT | P0 | M / 5 SP | S7-01 |
| S7-03 | Treinamento operacional + playbooks atualizados | PRODUCT/QA | P1 | S / 3 SP | S7-02 |
| S7-04 | Handoff para sustentacao e governance board | PRODUCT | P1 | S / 2 SP | S7-03 |

### Criterio de pronto S7

- Operacao produtiva, monitorada e com ownership definido no pos-go-live.
- QA de rollout aprovado e handoff formal assinado.
- Git atualizado somente apos aprovacao QA.

---

## Dependencias criticas transversais

1. Definicao final de RBAC impacta S1-S5.
2. Wrappers/edge functions novos precisam padrao de auth/idempotencia compartilhado.
3. Estrategia de auditoria unificada precisa ser definida antes do fim de S2.
4. Sem smoke unificado (S6-01), nao avancar para rollout (S7).

## Riscos e mitigacoes

- Risco: escopo visual consumir sprint de dominio.  
  Mitigacao: priorizar entrega funcional com componentes Connect ja existentes.
- Risco: backlog ADS placeholder continuar confundindo operacao.  
  Mitigacao: remover/ocultar rotas placeholder conforme modulo real entrar.
- Risco: regressao no booking flow publico.  
  Mitigacao: smoke publico obrigatorio em toda release admin.

## KPI de acompanhamento do plano

- `% modulos P0 implementados`
- `Lead time medio por issue`
- `Taxa de sucesso dos smoke scripts`
- `MTTA e MTTR de alertas criticos`
- `Incidentes por release`
