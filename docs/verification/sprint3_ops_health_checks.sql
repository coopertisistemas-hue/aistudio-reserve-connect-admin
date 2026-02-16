-- Sprint 3 Verification: Ops health checks

-- 1) Function and views exist
SELECT proname
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'reserve'
  AND p.proname = 'system_health_check';

SELECT table_name
FROM information_schema.views
WHERE table_schema = 'reserve'
  AND table_name IN ('ops_dashboard_summary', 'ops_dashboard_alerts');

-- 2) Health check returns rows
SELECT check_name, status, severity
FROM reserve.system_health_check();

-- 3) Ops dashboard summary is single row
SELECT COUNT(*) AS summary_rows
FROM reserve.ops_dashboard_summary;

-- 4) Alerts view has required columns
SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'reserve'
  AND table_name = 'ops_dashboard_alerts'
ORDER BY ordinal_position;
