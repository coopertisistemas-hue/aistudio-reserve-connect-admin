-- Sprint 2 Verification: reconciliation_job_placeholder

-- 1) reconciliation_runs table exists
SELECT tablename
FROM pg_tables
WHERE schemaname = 'reserve'
  AND tablename IN ('reconciliation_runs');

-- 2) Index checks
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'reserve'
  AND tablename = 'reconciliation_runs';

-- 3) RPC exists
SELECT proname
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public'
  AND p.proname IN ('reconciliation_summary', 'log_reconciliation_run');

-- 4) Insert test run (rollback)
BEGIN;
INSERT INTO reserve.reconciliation_runs (run_id, status, summary, started_at, completed_at)
VALUES ('test_recon_001', 'completed', '{"sample":true}'::jsonb, NOW(), NOW());

SELECT run_id, status
FROM reserve.reconciliation_runs
WHERE run_id = 'test_recon_001';
ROLLBACK;
