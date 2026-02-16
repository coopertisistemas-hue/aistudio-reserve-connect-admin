# Backend Exec Plan Sprint Reports

## Sprint 1: Booking Finalization + Host Commit

**What changed**
- Fixed reservation finalization SQL to use valid status/state and city scope
- Added finalize + host commit edge functions for end-to-end booking completion
- Wired Stripe webhook to trigger finalization flow
- Added verification SQL for booking finalization

**Files changed**
- `supabase/migrations/017_fix_reservation_finalization.sql`
- `supabase/functions/finalize_reservation_after_payment/index.ts`
- `supabase/functions/host_commit_booking/index.ts`
- `supabase/functions/webhook_stripe/index.ts`
- `supabase/functions/.env.example`
- `supabase/functions/README.md`
- `docs/EDGE_FUNCTIONS_REPORT.md`
- `docs/verification/sprint1_booking_finalization.sql`

**SQL/functions added or updated**
- `reserve.create_reservation_safe` (status + city_code + soft hold release)
- `reserve.finalize_reservation` (uses updated reservation creation)

**Verification steps executed**
- Not executed in this environment (requires Supabase connection)
- Verification script: `docs/verification/sprint1_booking_finalization.sql`

**Risk notes + rollback notes**
- Host Connect API must be configured (`HOST_CONNECT_API_URL`, `HOST_CONNECT_API_KEY`) before auto-commit
- Rollback: revert functions from `017_fix_reservation_finalization.sql` if needed

## Sprint 2: Cancellation + Host Webhooks + Reconciliation Placeholder

**What changed**
- Added cancellation requests table + reconciliation runs table
- Implemented cancel_reservation, host_webhook_receiver, reconciliation_job_placeholder functions
- Added inventory release helper for cancellations
- Added verification scripts for Sprint 2 operations

**Files changed**
- `supabase/migrations/018_sprint2_cancellation_webhook_reconciliation.sql`
- `supabase/functions/cancel_reservation/index.ts`
- `supabase/functions/host_webhook_receiver/index.ts`
- `supabase/functions/reconciliation_job_placeholder/index.ts`
- `supabase/functions/README.md`
- `docs/EDGE_FUNCTIONS_REPORT.md`
- `docs/verification/sprint2_cancel_reservation.sql`
- `docs/verification/sprint2_host_webhook_receiver.sql`
- `docs/verification/sprint2_reconciliation_placeholder.sql`

**SQL/functions added or updated**
- `reserve.release_reservation_inventory`
- `reserve.cancellation_requests`
- `reserve.reconciliation_runs`

**Verification steps executed**
- Not executed in this environment (requires Supabase connection)
- Verification scripts: `docs/verification/sprint2_cancel_reservation.sql`, `docs/verification/sprint2_host_webhook_receiver.sql`, `docs/verification/sprint2_reconciliation_placeholder.sql`

**Risk notes + rollback notes**
- PIX refunds are flagged pending; manual ops action required to complete refund
- Rollback: drop `018_sprint2_cancellation_webhook_reconciliation.sql` objects if needed

## Sprint 3: Ops/QA Hardening

**What changed**
- Expanded system health checks and ops dashboard views
- Added retention helper functions with dry-run defaults
- Added Sprint 3 verification scripts
- Extended post-deploy verification checklist

**Files changed**
- `supabase/migrations/019_sprint3_ops_qa_hardening.sql`
- `docs/verification/sprint3_ops_health_checks.sql`
- `docs/verification/sprint3_retention_checks.sql`
- `docs/verification/sprint3_smoke_tests.sql`
- `docs/POST_DEPLOY_VERIFICATION.md`
- `docs/RUNBOOK_INCIDENTS.md`
- `docs/OPS_DASHBOARD_GUIDE.md`

**SQL/functions added or updated**
- `reserve.system_health_check` (expanded)
- `reserve.ops_dashboard_summary`
- `reserve.ops_dashboard_alerts`
- `reserve.purge_old_audit_logs`
- `reserve.purge_old_webhook_dedup`
- `reserve.purge_old_reconciliation_runs`

**Verification steps executed**
- Not executed in this environment (requires Supabase connection)
- Verification scripts: `docs/verification/sprint3_ops_health_checks.sql`, `docs/verification/sprint3_retention_checks.sql`, `docs/verification/sprint3_smoke_tests.sql`

**Risk notes + rollback notes**
- Retention helpers default to dry-run; destructive runs require explicit dry_run=false
- Rollback: drop ops views/functions from `019_sprint3_ops_qa_hardening.sql` and reapply migration 016 version of system_health_check
