-- Sprint 3 Verification: Retention helpers

-- 1) Functions exist
SELECT proname
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'reserve'
  AND p.proname IN (
    'purge_old_audit_logs',
    'purge_old_webhook_dedup',
    'purge_old_reconciliation_runs'
  );

-- 2) Dry-run checks (service role required)
BEGIN;
SELECT set_config('request.jwt.claim.role', 'service_role', true);
SELECT reserve.purge_old_audit_logs(180, true) AS audit_logs_candidates;
SELECT reserve.purge_old_webhook_dedup(60, true) AS webhook_candidates;
SELECT reserve.purge_old_reconciliation_runs(90, true) AS reconciliation_candidates;
COMMIT;
