-- Sprint 3 Verification: Ops smoke tests

-- 1) Key triggers exist
SELECT tgname, tgrelid::regclass AS table_name
FROM pg_trigger
WHERE tgname IN (
  'trg_payment_state_validation',
  'trg_intent_state_validation',
  'trg_reservations_confirmation_code',
  'audit_trigger'
);

-- 2) RLS policies exist for key tables
SELECT tablename, COUNT(*) AS policy_count
FROM pg_policies
WHERE schemaname = 'reserve'
  AND tablename IN ('reservations', 'payments', 'booking_intents', 'audit_logs')
GROUP BY tablename
ORDER BY tablename;

-- 3) Ops dashboard alerts query
SELECT alert_code, severity
FROM reserve.ops_dashboard_alerts;

-- 4) Check system health output fields
SELECT
  COUNT(*) FILTER (WHERE check_name IS NULL) AS missing_check_name,
  COUNT(*) FILTER (WHERE status IS NULL) AS missing_status,
  COUNT(*) FILTER (WHERE severity IS NULL) AS missing_severity
FROM reserve.system_health_check();
