# Sprint 3 Kickoff Checklist (Ops/QA Hardening)

Date: 2026-02-19  
Status: IN PROGRESS

## Goal

Increase operational safety and release readiness with an ops alert center, structured smoke verification, and retention/reconciliation controls.

## Planned Scope

1. Ops Alert Center in admin (summary + alerts + health checks)
2. Structured post-deploy smoke script for critical admin/public paths
3. Retention and reconciliation execution checks (runbook-backed)
4. Lightweight E2E smoke visibility for payments -> ledger -> payouts

## Progress Checklist

### 1) Ops Alert Center
- [x] Add public RPC wrappers for ops snapshot/health/alerts (`037_admin_ops_public_wrappers.sql`)
- [x] Add admin alerts Edge Function (`admin_list_ops_alerts`)
- [x] Upgrade `admin_ops_summary` to wrapper-based RPCs
- [x] Upgrade admin ops UI with KPI, alerts, and health checks
- [x] Deploy + smoke-test endpoints with admin auth

### 2) Structured Smoke Script
- [x] Define script format and command entrypoint
- [x] Cover auth, payments list, ledger list, payouts list, and ops endpoints
- [x] Output pass/fail summary suitable for release signoff

Implemented script:
- `docs/verification/sprint3_admin_ops_smoke.mjs`

Example execution:
- `RC_SUPABASE_ANON_KEY=<key> RC_ADMIN_EMAIL=<email> RC_ADMIN_PASSWORD=<password> node docs/verification/sprint3_admin_ops_smoke.mjs`

### 3) Retention and Reconciliation Checks
- [x] Add admin-safe dry-run checks for retention helpers
- [x] Add runbook execution notes and expected thresholds
- [x] Validate with remote smoke outputs

Implemented:
- `supabase/migrations/038_admin_ops_maintenance_public_wrappers.sql`
- `supabase/migrations/039_fix_admin_ops_retention_preview.sql`
- `supabase/functions/admin_ops_retention_preview/index.ts`
- `supabase/functions/admin_ops_reconciliation_status/index.ts`

### 4) Lightweight E2E Visibility
- [x] Add a single smoke flow doc/script linking payment seed -> ledger -> payout visibility
- [x] Include expected IDs and verification queries

Implemented:
- `docs/verification/sprint3_financial_visibility_smoke.mjs`
- `docs/verification/SPRINT3_FINANCIAL_VISIBILITY.md`

## Current Blocking Items

- None.

## Exit Criteria for Sprint 3

- Ops page shows stable, authenticated summary + alerts + health.
- Smoke script can be executed in one command with clear pass/fail output.
- Retention/reconciliation checks documented and validated in dry-run mode.
- Financial visibility smoke path documented and reproducible.
