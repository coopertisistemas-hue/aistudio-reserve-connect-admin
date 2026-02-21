# Exec Plan Segmentado por Sprints - Excelencia Connect

Data: 2026-02-20  
Projeto alvo: `aistudio-reserve-connect-admin`

## Objetivo

Definir um plano de execucao por sprints para implementar os ajustes de modulos do Admin, alinhando UX premium Connect com aderencia total ao dominio Reserve Connect (reservas, financeiro, ops e governanca).

## Principios de execucao

1. `Domain-first`: priorizar modulos de negocio de reserva/hospedagem sobre taxonomia ADS generica.
2. `Excellence-by-default`: padrao visual, acessibilidade, i18n e observabilidade em todos os modulos.
3. `Security & audit`: toda acao critica com trilha auditavel, RBAC e idempotencia.
4. `No regressions`: cada sprint fecha com smoke funcional, build e checklist de release.

## Horizonte de sprints

- Janela recomendada: 8 sprints tecnicos (S0 a S7), 1-2 semanas cada.
- Entregas em ondas: Fundacao de Dominio -> Governanca -> Operacao Avancada -> Launch Readiness.

## Fases de execucao

### Fase 1 - Foundation Domain
- S0, S1, S2

### Fase 2 - Reliability and Governance
- S3, S4

### Fase 3 - Experience and Launch Readiness
- S5, S6, S7

## Regra de QA e Git por sprint

- Toda sprint fecha com QA formal (`QA Approved`).
- Sem `QA Approved`, nao atualizar branch principal.
- Apos QA aprovado: commit, push, PR com evidencias, merge.

Artefato padrao de QA:

- `docs/templates/SPRINT_QA_SIGNOFF_TEMPLATE.md`

---

## S0 - Alinhamento de arquitetura de modulos (1 semana)

### Meta

Consolidar arquitetura de informacao do Admin Reserve e remover ambiguidade entre menu ADS e dominio de reservas.

### Entregas

- Congelar taxonomia final do menu admin por categorias Reserve.
- Publicar mapa oficial de modulos (fonte unica de verdade).
- Definir ownership de cada modulo (produto, backend, frontend, qa).

### Artefatos

- `docs/ADMIN_MODULES_COMPATIBILITY_MAP.md`
- `docs/EXEC_PLAN_CONNECT_EXCELLENCE_SPRINTS.md`

### Criterios de aceite

- Taxonomia final aprovada por produto/operacao.
- Backlog priorizado por criticidade de negocio.

---

## S1 - Dominio Core de Operacao (2 semanas)

### Meta

Fechar gaps de operacao de reservas no Admin.

### Escopo

- Modulo `Unidades/Tipologias`
- Modulo `Disponibilidade/Calendario`
- Modulo `Rate Plans`
- Observabilidade de `booking_intents` e `soft holds`

### Back-end

- Criar/ajustar funcoes admin para unidades, calendario e rate plans.
- Expor listagem/edicao segura com wrappers publicos e auth admin.

### Front-end

- Rotas e paginas dedicadas para os 4 modulos.
- Tabelas/filtros/acoes padrao Connect.
- Estado vazio, loading, erro, permissao.

### Criterios de aceite

- Operador consegue ajustar disponibilidade e precificacao sem SQL manual.
- Dashboard mostra visao de intents/holds em tempo real operacional.

---

## S2 - Financeiro de Governanca (2 semanas)

### Meta

Completar financeiro alem de consulta, incluindo configuracoes de repasse/comissao.

### Escopo

- Modulo `Comissoes (tiers)`
- Modulo `Regras de Repasse (payout schedules)`
- Auditoria de alteracoes financeiras

### Back-end

- Endpoints admin para CRUD de tiers/schedules.
- Validacoes de consistencia e vigencia.

### Front-end

- UI de configuracao com simulacao de impacto.
- Historico de alteracoes e difs por usuario.

### Criterios de aceite

- Regra alterada reflete em novos fluxos sem quebrar reconciliacao.
- Toda alteracao financeira fica auditada.

---

## S3 - Ops Workflow Excellence (2 semanas)

### Meta

Transformar Ops de painel passivo em fluxo ativo de tratativa.

### Escopo

- Ack/resolve/snooze de alertas
- Owner assignment e prioridade
- SLA clock e aging de excecoes
- Exception Queue unificada (host, pagamentos, webhooks)

### Back-end

- Estado de ciclo de vida de alertas/excecoes.
- Persistencia de owner/status/notes.

### Front-end

- Boards/listas operacionais com filtros por severidade/owner.
- Acoes em lote para triagem.

### Criterios de aceite

- Operacao fecha incidente fim-a-fim no admin sem planilha externa.
- Metricas de MTTA/MTTR disponiveis.

---

## S4 - Governanca e Seguranca Admin (2 semanas)

### Meta

Fechar camada de governanca (usuarios, roles, auditoria, integracoes).

### Escopo

- Modulo `Usuarios`
- Modulo `Roles e Permissoes`
- Modulo `Auditoria`
- Modulo `Integracoes/Webhooks`

### Back-end

- Expandir `admin_check_role` para matriz de permissoes real por acao.
- Endpoints para consulta de trilha de auditoria e webhooks.

### Front-end

- Tela de matriz de permissoes por perfil.
- Tela de eventos de auditoria com busca por entidade/ator.

### Criterios de aceite

- Acesso sensivel respeita RBAC granular.
- Toda acao administrativa critica e rastreavel.

---

## S5 - Conteudo e Canal Premium (1-2 semanas)

### Meta

Completar camada de conteudo com governanca editorial por cidade/site.

### Escopo

- Hero/Home admin
- SEO por tenant/cidade
- Validacao de links sociais e ativos de marca

### Criterios de aceite

- Time de marketing opera sem deploy.
- Mudancas propagam para funcoes publicas com cache invalido corretamente.

---

## S6 - Estabilizacao e Qualidade de Producao (1 semana)

### Meta

Hardening final de qualidade, testes e performance.

### Escopo

- Smoke scripts por trilha: operacao, financeiro, ops, governanca
- Budget de performance frontend
- Revisao de acessibilidade e i18n
- Testes de regressao de booking flow publico

### Criterios de aceite

- Build verde + smoke completo + sem regressao critica.
- Dashboard de qualidade publicado.

---

## S7 - Rollout controlado e handoff (1 semana)

### Meta

Go-live seguro da nova arquitetura de modulos admin.

### Escopo

- Feature flags por modulo
- Rollout por cidade
- Runbooks atualizados + treinamento de operacao
- Handoff para sustentacao

### Criterios de aceite

- Rollback testado.
- Operacao treinada com playbooks.
- KPIs iniciais de saude e adocao monitorados.

---

## Matriz de priorizacao (valor x risco)

### Prioridade P0 (imediata)

- S1 Operacao Core
- S2 Financeiro de Governanca
- S3 Ops Workflow

### Prioridade P1

- S4 Governanca e Seguranca
- S6 Estabilizacao

### Prioridade P2

- S5 Conteudo Premium
- S7 Rollout

## KPIs de excelencia Connect

### Produto/Operacao

- Tempo medio para ajustar disponibilidade
- Tempo medio para tratar alerta critico (MTTA)
- Tempo medio para resolver excecao (MTTR)
- Taxa de sucesso de cancelamento/refund sem intervencao manual

### Financeiro

- Divergencia de conciliacao (objetivo: 0)
- Tempo de fechamento de payout
- Percentual de transacoes com trilha auditavel completa

### Engenharia

- Build success rate
- Smoke success rate por sprint
- Defeitos criticos por release
- P95 de carregamento no admin

## Definicao de pronto por sprint (DoD)

- Rotas + UI + i18n (PT/EN/ES) completas
- Edge functions com auth admin, idempotencia e CORS
- Logs/auditoria para acoes sensiveis
- Smoke script atualizado e aprovado
- Documentacao de operacao e rollback atualizada

## Sequencia recomendada de implementacao

1. Fechar taxonomia de menu Reserve e remover dependencia funcional de placeholders ADS.
2. Entregar S1 + S2 em paralelo parcial (times diferentes).
3. Entrar em S3 antes de ampliar escopo visual adicional.
4. Consolidar governanca (S4) antes de rollout amplo.
5. Finalizar com S6/S7 para sustentacao em padrao Connect.
