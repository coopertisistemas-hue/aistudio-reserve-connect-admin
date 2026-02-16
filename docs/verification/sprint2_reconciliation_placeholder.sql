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

-- 3) Insert test run (rollback)
BEGIN;
INSERT INTO reserve.reconciliation_runs (run_id, status, summary, started_at, completed_at)
VALUES ('test_recon_001', 'completed', '{"sample":true}'::jsonb, NOW(), NOW());

SELECT run_id, status
FROM reserve.reconciliation_runs
WHERE run_id = 'test_recon_001';
ROLLBACK;
