-- ============================================
-- MIGRATION 019: OPS + QA HARDENING
-- Description: Health checks, ops dashboards, retention helpers
-- Version: 1.0
-- Date: 2026-02-16
-- Risk Level: LOW - Monitoring and maintenance helpers
-- ============================================

-- ============================================
-- SECTION 1: EXPANDED SYSTEM HEALTH CHECK
-- ============================================

CREATE OR REPLACE FUNCTION reserve.system_health_check()
RETURNS TABLE (
    check_name VARCHAR(100),
    status VARCHAR(20),
    details TEXT,
    severity VARCHAR(20),
    checked_at TIMESTAMPTZ
) AS $$
DECLARE
    v_count INT;
    v_size BIGINT;
    v_last TIMESTAMPTZ;
    v_failed_runs INT;
    v_advisory_locks INT;
    v_blocked_locks INT;
BEGIN
    checked_at := NOW();

    -- Ledger imbalance
    SELECT COUNT(*) INTO v_count FROM reserve.find_ledger_imbalances();
    check_name := 'Ledger Balance';
    status := CASE WHEN v_count = 0 THEN 'OK' ELSE 'CRITICAL' END;
    details := CASE WHEN v_count = 0 THEN 'All transactions balanced'
                    ELSE format('%s imbalanced transactions found', v_count) END;
    severity := CASE WHEN v_count = 0 THEN 'INFO' ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;

    -- Stuck payments
    SELECT COUNT(*) INTO v_count FROM reserve.stuck_payments;
    check_name := 'Stuck Payments';
    status := CASE WHEN v_count = 0 THEN 'OK'
                   WHEN v_count < 5 THEN 'WARNING'
                   ELSE 'CRITICAL' END;
    details := format('%s payments stuck for >1 hour', v_count);
    severity := CASE WHEN v_count = 0 THEN 'INFO'
                     WHEN v_count < 5 THEN 'WARNING'
                     ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;

    -- Expired intents
    SELECT COUNT(*) INTO v_count FROM reserve.expired_intents_not_cleaned;
    check_name := 'Expired Intents';
    status := CASE WHEN v_count = 0 THEN 'OK'
                   WHEN v_count < 10 THEN 'WARNING'
                   ELSE 'CRITICAL' END;
    details := format('%s expired intents not cleaned up', v_count);
    severity := CASE WHEN v_count = 0 THEN 'INFO'
                     WHEN v_count < 10 THEN 'WARNING'
                     ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;

    -- Overbooking
    SELECT COUNT(*) INTO v_count FROM reserve.overbooking_check;
    check_name := 'Overbooking';
    status := CASE WHEN v_count = 0 THEN 'OK' ELSE 'CRITICAL' END;
    details := CASE WHEN v_count = 0 THEN 'No overbookings detected'
                    ELSE format('%s overbooked dates found', v_count) END;
    severity := CASE WHEN v_count = 0 THEN 'INFO' ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;

    -- Failed payment webhooks
    SELECT COUNT(*) INTO v_count
    FROM reserve.processed_webhooks pw
    WHERE pw.status = 'failed'
      AND received_at > NOW() - INTERVAL '24 hours';
    check_name := 'Failed Payment Webhooks';
    status := CASE WHEN v_count = 0 THEN 'OK'
                   WHEN v_count < 10 THEN 'WARNING'
                   ELSE 'CRITICAL' END;
    details := format('%s failed payment webhooks in last 24h', v_count);
    severity := CASE WHEN v_count = 0 THEN 'INFO'
                     WHEN v_count < 10 THEN 'WARNING'
                     ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;

    -- Failed host webhooks
    SELECT COUNT(*) INTO v_count
    FROM reserve.host_webhook_events he
    WHERE he.status = 'failed'
      AND created_at > NOW() - INTERVAL '24 hours';
    check_name := 'Failed Host Webhooks';
    status := CASE WHEN v_count = 0 THEN 'OK'
                   WHEN v_count < 10 THEN 'WARNING'
                   ELSE 'CRITICAL' END;
    details := format('%s failed host webhooks in last 24h', v_count);
    severity := CASE WHEN v_count = 0 THEN 'INFO'
                     WHEN v_count < 10 THEN 'WARNING'
                     ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;

    -- Pending cancellations
    SELECT COUNT(*) INTO v_count
    FROM reserve.cancellation_requests cr
    WHERE cr.status = 'processing'
      AND created_at < NOW() - INTERVAL '15 minutes';
    check_name := 'Pending Cancellations';
    status := CASE WHEN v_count = 0 THEN 'OK'
                   WHEN v_count < 5 THEN 'WARNING'
                   ELSE 'CRITICAL' END;
    details := format('%s cancellation requests pending', v_count);
    severity := CASE WHEN v_count = 0 THEN 'INFO'
                     WHEN v_count < 5 THEN 'WARNING'
                     ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;

    -- Reconciliation runs
    SELECT MAX(completed_at) INTO v_last FROM reserve.reconciliation_runs;
    SELECT COUNT(*) INTO v_failed_runs
    FROM reserve.reconciliation_runs
    WHERE status = 'failed'
      AND created_at > NOW() - INTERVAL '7 days';
    check_name := 'Reconciliation Runs';
    status := CASE WHEN v_last IS NULL THEN 'WARNING'
                   WHEN v_failed_runs > 0 THEN 'WARNING'
                   ELSE 'OK' END;
    details := CASE WHEN v_last IS NULL THEN 'No reconciliation runs recorded'
                    ELSE format('Last run at %s (failed last 7d: %s)', v_last, v_failed_runs) END;
    severity := CASE WHEN v_last IS NULL THEN 'WARNING'
                     WHEN v_failed_runs > 0 THEN 'WARNING'
                     ELSE 'INFO' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;

    -- Audit log size and freshness
    SELECT pg_total_relation_size('reserve.audit_logs') INTO v_size;
    SELECT MAX(created_at) INTO v_last FROM reserve.audit_logs;
    check_name := 'Audit Log Size';
    status := CASE WHEN v_size < 1073741824 THEN 'OK'
                   WHEN v_size < 5368709120 THEN 'WARNING'
                   ELSE 'CRITICAL' END;
    details := format('Audit logs: %s, last entry: %s', pg_size_pretty(v_size), COALESCE(v_last::text, 'none'));
    severity := CASE WHEN v_size < 1073741824 THEN 'INFO'
                     WHEN v_size < 5368709120 THEN 'WARNING'
                     ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;

    -- Advisory locks
    SELECT COUNT(*) INTO v_advisory_locks FROM pg_locks WHERE locktype = 'advisory' AND granted = true;
    SELECT COUNT(*) INTO v_blocked_locks FROM pg_locks WHERE granted = false;
    check_name := 'Database Locks';
    status := CASE WHEN v_blocked_locks = 0 THEN 'OK' ELSE 'WARNING' END;
    details := format('Advisory locks: %s, blocked locks: %s', v_advisory_locks, v_blocked_locks);
    severity := CASE WHEN v_blocked_locks = 0 THEN 'INFO' ELSE 'WARNING' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.system_health_check IS 'Comprehensive system health check - run on schedule';

-- ============================================
-- SECTION 2: OPS DASHBOARD VIEWS
-- ============================================

CREATE OR REPLACE VIEW reserve.ops_dashboard_summary AS
SELECT
    NOW() as generated_at,
    (SELECT COUNT(*) FROM reserve.find_ledger_imbalances()) AS ledger_imbalances,
    (SELECT COUNT(*) FROM reserve.stuck_payments) AS stuck_payments,
    (SELECT COUNT(*) FROM reserve.expired_intents_not_cleaned) AS expired_intents,
    (SELECT COUNT(*) FROM reserve.overbooking_check) AS overbookings,
    (SELECT COUNT(*) FROM reserve.processed_webhooks WHERE status = 'failed' AND received_at > NOW() - INTERVAL '24 hours') AS failed_payment_webhooks,
    (SELECT COUNT(*) FROM reserve.host_webhook_events WHERE status = 'failed' AND created_at > NOW() - INTERVAL '24 hours') AS failed_host_webhooks,
    (SELECT COUNT(*) FROM reserve.cancellation_requests WHERE status = 'processing') AS pending_cancellations,
    (SELECT MAX(completed_at) FROM reserve.reconciliation_runs) AS last_reconciliation_run,
    (SELECT MAX(created_at) FROM reserve.audit_logs) AS last_audit_log,
    (SELECT pg_total_relation_size('reserve.audit_logs')) AS audit_log_size_bytes,
    (SELECT COUNT(*) FROM pg_locks WHERE locktype = 'advisory' AND granted = true) AS advisory_locks,
    (SELECT COUNT(*) FROM pg_locks WHERE granted = false) AS blocked_locks;

COMMENT ON VIEW reserve.ops_dashboard_summary IS 'Single-row ops dashboard summary for operators';

CREATE OR REPLACE VIEW reserve.ops_dashboard_alerts AS
SELECT * FROM (
    SELECT
        'ledger_imbalance'::VARCHAR(50) AS alert_code,
        'CRITICAL'::VARCHAR(20) AS severity,
        'Ledger imbalance detected'::TEXT AS description,
        'SELECT * FROM reserve.find_ledger_imbalances();'::TEXT AS evidence_query
    WHERE (SELECT COUNT(*) FROM reserve.find_ledger_imbalances()) > 0

    UNION ALL
    SELECT
        'stuck_payments'::VARCHAR(50),
        'WARNING'::VARCHAR(20),
        'Payments stuck in pending/processing'::TEXT,
        'SELECT * FROM reserve.stuck_payments;'::TEXT
    WHERE (SELECT COUNT(*) FROM reserve.stuck_payments) > 0

    UNION ALL
    SELECT
        'overbooking'::VARCHAR(50),
        'CRITICAL'::VARCHAR(20),
        'Overbooking detected in availability calendar'::TEXT,
        'SELECT * FROM reserve.overbooking_check;'::TEXT
    WHERE (SELECT COUNT(*) FROM reserve.overbooking_check) > 0

    UNION ALL
    SELECT
        'failed_host_webhooks'::VARCHAR(50),
        'WARNING'::VARCHAR(20),
        'Failed Host webhooks in last 24h'::TEXT,
        'SELECT * FROM reserve.host_webhook_events WHERE status = ''failed'';'::TEXT
    WHERE (SELECT COUNT(*) FROM reserve.host_webhook_events WHERE status = 'failed' AND created_at > NOW() - INTERVAL '24 hours') > 0

    UNION ALL
    SELECT
        'pending_cancellations'::VARCHAR(50),
        'WARNING'::VARCHAR(20),
        'Cancellation requests pending > 15 minutes'::TEXT,
        'SELECT * FROM reserve.cancellation_requests WHERE status = ''processing'';'::TEXT
    WHERE (SELECT COUNT(*) FROM reserve.cancellation_requests WHERE status = 'processing' AND created_at < NOW() - INTERVAL '15 minutes') > 0
) alerts;

COMMENT ON VIEW reserve.ops_dashboard_alerts IS 'Alert list for ops dashboard derived from health checks';

-- ============================================
-- SECTION 3: RETENTION HELPERS
-- ============================================

CREATE OR REPLACE FUNCTION reserve.purge_old_audit_logs(
    p_days INTEGER,
    p_dry_run BOOLEAN DEFAULT true
)
RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    IF COALESCE(current_setting('request.jwt.claim.role', true), '') <> 'service_role' THEN
        RAISE EXCEPTION 'permission denied';
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM reserve.audit_logs
    WHERE created_at < NOW() - INTERVAL '1 day' * p_days;

    IF p_dry_run THEN
        RETURN v_count;
    END IF;

    IF to_regclass('reserve.audit_logs_archive') IS NOT NULL THEN
        INSERT INTO reserve.audit_logs_archive
        SELECT *, NOW() FROM reserve.audit_logs
        WHERE created_at < NOW() - INTERVAL '1 day' * p_days
        ON CONFLICT DO NOTHING;
    END IF;

    DELETE FROM reserve.audit_logs
    WHERE created_at < NOW() - INTERVAL '1 day' * p_days;

    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN v_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION reserve.purge_old_audit_logs IS 'Purge audit logs older than N days (dry-run default)';

CREATE OR REPLACE FUNCTION reserve.purge_old_webhook_dedup(
    p_days INTEGER,
    p_dry_run BOOLEAN DEFAULT true
)
RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    IF COALESCE(current_setting('request.jwt.claim.role', true), '') <> 'service_role' THEN
        RAISE EXCEPTION 'permission denied';
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM reserve.processed_webhooks
    WHERE received_at < NOW() - INTERVAL '1 day' * p_days;

    IF p_dry_run THEN
        RETURN v_count;
    END IF;

    DELETE FROM reserve.processed_webhooks
    WHERE received_at < NOW() - INTERVAL '1 day' * p_days;

    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN v_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION reserve.purge_old_webhook_dedup IS 'Purge processed webhooks older than N days (dry-run default)';

CREATE OR REPLACE FUNCTION reserve.purge_old_reconciliation_runs(
    p_days INTEGER,
    p_dry_run BOOLEAN DEFAULT true
)
RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    IF COALESCE(current_setting('request.jwt.claim.role', true), '') <> 'service_role' THEN
        RAISE EXCEPTION 'permission denied';
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM reserve.reconciliation_runs
    WHERE created_at < NOW() - INTERVAL '1 day' * p_days;

    IF p_dry_run THEN
        RETURN v_count;
    END IF;

    DELETE FROM reserve.reconciliation_runs
    WHERE created_at < NOW() - INTERVAL '1 day' * p_days;

    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN v_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION reserve.purge_old_reconciliation_runs IS 'Purge reconciliation runs older than N days (dry-run default)';

REVOKE ALL ON FUNCTION reserve.purge_old_audit_logs(INTEGER, BOOLEAN) FROM PUBLIC;
REVOKE ALL ON FUNCTION reserve.purge_old_webhook_dedup(INTEGER, BOOLEAN) FROM PUBLIC;
REVOKE ALL ON FUNCTION reserve.purge_old_reconciliation_runs(INTEGER, BOOLEAN) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION reserve.purge_old_audit_logs(INTEGER, BOOLEAN) TO service_role;
GRANT EXECUTE ON FUNCTION reserve.purge_old_webhook_dedup(INTEGER, BOOLEAN) TO service_role;
GRANT EXECUTE ON FUNCTION reserve.purge_old_reconciliation_runs(INTEGER, BOOLEAN) TO service_role;

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 'Sprint 3 ops/qa hardening applied' AS status, NOW() AS executed_at;

-- ============================================
-- ROLLBACK INSTRUCTIONS
-- ============================================
/*
To rollback this migration:

1. Drop views:
   DROP VIEW IF EXISTS reserve.ops_dashboard_summary;
   DROP VIEW IF EXISTS reserve.ops_dashboard_alerts;

2. Drop functions:
   DROP FUNCTION IF EXISTS reserve.purge_old_audit_logs(INTEGER, BOOLEAN);
   DROP FUNCTION IF EXISTS reserve.purge_old_webhook_dedup(INTEGER, BOOLEAN);
   DROP FUNCTION IF EXISTS reserve.purge_old_reconciliation_runs(INTEGER, BOOLEAN);

3. Revert reserve.system_health_check() from migration 016 if needed.
*/
