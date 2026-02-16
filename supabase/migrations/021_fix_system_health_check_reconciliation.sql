-- ============================================
-- MIGRATION 021: FIX SYSTEM HEALTH CHECK (RECONCILIATION)
-- Description: Qualify reconciliation_runs status reference
-- Version: 1.0
-- Date: 2026-02-16
-- Risk Level: LOW - Monitoring helper
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

    SELECT COUNT(*) INTO v_count FROM reserve.find_ledger_imbalances();
    check_name := 'Ledger Balance';
    status := CASE WHEN v_count = 0 THEN 'OK' ELSE 'CRITICAL' END;
    details := CASE WHEN v_count = 0 THEN 'All transactions balanced'
                    ELSE format('%s imbalanced transactions found', v_count) END;
    severity := CASE WHEN v_count = 0 THEN 'INFO' ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;

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

    SELECT COUNT(*) INTO v_count FROM reserve.overbooking_check;
    check_name := 'Overbooking';
    status := CASE WHEN v_count = 0 THEN 'OK' ELSE 'CRITICAL' END;
    details := CASE WHEN v_count = 0 THEN 'No overbookings detected'
                    ELSE format('%s overbooked dates found', v_count) END;
    severity := CASE WHEN v_count = 0 THEN 'INFO' ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;

    SELECT COUNT(*) INTO v_count
    FROM reserve.processed_webhooks pw
    WHERE pw.status = 'failed'
      AND pw.received_at > NOW() - INTERVAL '24 hours';
    check_name := 'Failed Payment Webhooks';
    status := CASE WHEN v_count = 0 THEN 'OK'
                   WHEN v_count < 10 THEN 'WARNING'
                   ELSE 'CRITICAL' END;
    details := format('%s failed payment webhooks in last 24h', v_count);
    severity := CASE WHEN v_count = 0 THEN 'INFO'
                     WHEN v_count < 10 THEN 'WARNING'
                     ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;

    SELECT COUNT(*) INTO v_count
    FROM reserve.host_webhook_events he
    WHERE he.status = 'failed'
      AND he.created_at > NOW() - INTERVAL '24 hours';
    check_name := 'Failed Host Webhooks';
    status := CASE WHEN v_count = 0 THEN 'OK'
                   WHEN v_count < 10 THEN 'WARNING'
                   ELSE 'CRITICAL' END;
    details := format('%s failed host webhooks in last 24h', v_count);
    severity := CASE WHEN v_count = 0 THEN 'INFO'
                     WHEN v_count < 10 THEN 'WARNING'
                     ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;

    SELECT COUNT(*) INTO v_count
    FROM reserve.cancellation_requests cr
    WHERE cr.status = 'processing'
      AND cr.created_at < NOW() - INTERVAL '15 minutes';
    check_name := 'Pending Cancellations';
    status := CASE WHEN v_count = 0 THEN 'OK'
                   WHEN v_count < 5 THEN 'WARNING'
                   ELSE 'CRITICAL' END;
    details := format('%s cancellation requests pending', v_count);
    severity := CASE WHEN v_count = 0 THEN 'INFO'
                     WHEN v_count < 5 THEN 'WARNING'
                     ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;

    SELECT MAX(completed_at) INTO v_last FROM reserve.reconciliation_runs;
    SELECT COUNT(*) INTO v_failed_runs
    FROM reserve.reconciliation_runs rr
    WHERE rr.status = 'failed'
      AND rr.created_at > NOW() - INTERVAL '7 days';
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

SELECT 'Sprint 3 reconciliation health fix applied' AS status, NOW() AS executed_at;
