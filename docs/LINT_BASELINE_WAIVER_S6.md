# Lint Baseline Waiver - S6

Date: 2026-02-21  
Scope: S6 stabilization gate

## Context

S6 stabilization matrix (build + smoke S1-S5) passed fully, but `pnpm --dir apps/web lint` still fails due to pre-existing workspace baseline debt.

Current lint result snapshot:

- 60 errors
- 6 warnings

Main categories:

- `@typescript-eslint/no-explicit-any`
- `@typescript-eslint/no-unused-vars`
- `react-refresh/only-export-components`
- `react-hooks/exhaustive-deps`

## Decision

For S6 release readiness, lint baseline is accepted as technical debt outside sprint scope.

- Gate decision: approved with waiver for lint baseline.
- Requirement maintained: no critical regression in runtime flow/build/smoke.

## Follow-up Plan

1. Create dedicated lint-hardening track in SP7 rollout phase.
2. Enforce "new/edited files lint clean" policy from next sprint onward.
3. Burn down top categories (`no-explicit-any`, `only-export-components`) first.
