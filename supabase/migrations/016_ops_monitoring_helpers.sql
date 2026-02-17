-- ============================================
-- MIGRATION 016: OPERATIONAL MONITORING HELPERS
-- Description: Views and functions for monitoring system health and detecting issues
-- Version: 1.0
-- Date: 2026-02-16
-- Risk Level: MEDIUM - Monitoring only, no data changes
-- ============================================

-- ============================================
-- SECTION 1: LEDGER MONITORING
-- ============================================

-- View to check ledger balance integrity
CREATE OR REPLACE VIEW reserve.ledger_balance_check AS
WITH daily_balance AS (
    SELECT 
        city_code,
        DATE(created_at) as date,
        COUNT(*) as entry_count,
        SUM(CASE WHEN direction = 'debit' THEN amount ELSE 0 END) as total_debits,
        SUM(CASE WHEN direction = 'credit' THEN amount ELSE 0 END) as total_credits,
        SUM(CASE WHEN direction = 'debit' THEN amount ELSE -amount END) as net_balance
    FROM reserve.ledger_entries
    WHERE created_at > NOW() - INTERVAL '7 days'
    GROUP BY city_code, DATE(created_at)
)
SELECT 
    city_code,
    date,
    entry_count,
    total_debits,
    total_credits,
    net_balance,
    CASE 
        WHEN ABS(net_balance) < 0.01 THEN 'BALANCED'
        ELSE 'IMBALANCE DETECTED'
    END as balance_status
FROM daily_balance
ORDER BY date DESC, city_code;

COMMENT ON VIEW reserve.ledger_balance_check IS 'Daily ledger balance verification - should always show BALANCED';

-- Function to detect ledger imbalances
CREATE OR REPLACE FUNCTION reserve.find_ledger_imbalances(
    p_start_date DATE DEFAULT (NOW() - INTERVAL '7 days')::date
)
RETURNS TABLE (
    transaction_id VARCHAR(100),
    city_code VARCHAR(10),
    entry_count BIGINT,
    total_debits NUMERIC,
    total_credits NUMERIC,
    difference NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        le.transaction_id::VARCHAR,
        le.city_code,
        COUNT(*) as entry_count,
        SUM(CASE WHEN le.direction = 'debit' THEN le.amount ELSE 0 END) as total_debits,
        SUM(CASE WHEN le.direction = 'credit' THEN le.amount ELSE 0 END) as total_credits,
        ABS(
            SUM(CASE WHEN le.direction = 'debit' THEN le.amount ELSE 0 END) - 
            SUM(CASE WHEN le.direction = 'credit' THEN le.amount ELSE 0 END)
        ) as difference
    FROM reserve.ledger_entries le
    WHERE le.created_at >= p_start_date
    GROUP BY le.transaction_id, le.city_code
    HAVING ABS(
        SUM(CASE WHEN le.direction = 'debit' THEN le.amount ELSE 0 END) - 
        SUM(CASE WHEN le.direction = 'credit' THEN le.amount ELSE 0 END)
    ) > 0.01
    ORDER BY MAX(le.created_at) DESC;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.find_ledger_imbalances IS 'Finds transactions where debits != credits (should return 0 rows)';

-- ============================================
-- SECTION 2: PAYMENT MONITORING
-- ============================================

-- View for stuck payments
CREATE OR REPLACE VIEW reserve.stuck_payments AS
SELECT 
    p.id as payment_id,
    p.booking_intent_id,
    p.gateway,
    p.gateway_payment_id,
    p.status,
    p.amount,
    p.currency,
    p.created_at,
    EXTRACT(EPOCH FROM (NOW() - p.created_at)) / 3600 as hours_pending,
    bi.session_id,
    bi.city_code,
    pw.event_type as last_webhook_event,
    pw.received_at as last_webhook_at
FROM reserve.payments p
LEFT JOIN reserve.booking_intents bi ON p.booking_intent_id = bi.id
LEFT JOIN LATERAL (
    SELECT event_type, received_at
    FROM reserve.processed_webhooks
    WHERE payment_id = p.id
    ORDER BY received_at DESC
    LIMIT 1
) pw ON true
WHERE p.status IN ('pending', 'processing')
AND p.created_at < NOW() - INTERVAL '1 hour'
ORDER BY p.created_at ASC;

COMMENT ON VIEW reserve.stuck_payments IS 'Payments stuck in pending/processing state for more than 1 hour';

-- View for payment success metrics
CREATE OR REPLACE VIEW reserve.payment_metrics_24h AS
SELECT 
    gateway,
    payment_method,
    COUNT(*) as total_attempts,
    COUNT(*) FILTER (WHERE status = 'succeeded') as succeeded,
    COUNT(*) FILTER (WHERE status = 'failed') as failed,
    COUNT(*) FILTER (WHERE status = 'pending') as still_pending,
    ROUND(
        COUNT(*) FILTER (WHERE status = 'succeeded')::numeric / 
        NULLIF(COUNT(*), 0) * 100, 
        2
    ) as success_rate_pct,
    SUM(amount) FILTER (WHERE status = 'succeeded') as total_volume,
    AVG(EXTRACT(EPOCH FROM (succeeded_at - created_at))) FILTER (WHERE status = 'succeeded') as avg_completion_seconds
FROM reserve.payments
WHERE created_at > NOW() - INTERVAL '24 hours'
GROUP BY gateway, payment_method;

-- View for failed payments analysis
CREATE OR REPLACE VIEW reserve.failed_payments_analysis AS
SELECT 
    gateway,
    payment_method,
    status,
    metadata->>'failure_code' as error_code,
    metadata->>'failure_message' as error_message,
    COUNT(*) as count,
    MIN(created_at) as first_occurrence,
    MAX(created_at) as last_occurrence
FROM reserve.payments
WHERE status IN ('failed', 'expired')
AND created_at > NOW() - INTERVAL '7 days'
GROUP BY gateway, payment_method, status, metadata->>'failure_code', metadata->>'failure_message'
ORDER BY count DESC;

-- ============================================
-- SECTION 3: BOOKING INTENT MONITORING
-- ============================================

-- View for expired but not cleaned up intents
CREATE OR REPLACE VIEW reserve.expired_intents_not_cleaned AS
SELECT 
    bi.id as intent_id,
    bi.status,
    bi.expires_at,
    EXTRACT(EPOCH FROM (NOW() - bi.expires_at)) / 3600 as hours_expired,
    bi.session_id,
    bi.city_code,
    bi.total_amount,
    EXISTS (
        SELECT 1 FROM reserve.payments p 
        WHERE p.booking_intent_id = bi.id 
        AND p.status IN ('succeeded', 'processing')
    ) as has_successful_payment
FROM reserve.booking_intents bi
WHERE bi.expires_at < NOW()
AND bi.status IN ('intent_created', 'payment_pending')
ORDER BY bi.expires_at ASC;

-- View for intent conversion funnel
CREATE OR REPLACE VIEW reserve.intent_conversion_funnel AS
WITH intent_stats AS (
    SELECT 
        DATE(created_at) as date,
        COUNT(*) as created,
        COUNT(*) FILTER (WHERE status IN ('payment_pending', 'payment_confirmed', 'converted')) as reached_payment,
        COUNT(*) FILTER (WHERE status IN ('payment_confirmed', 'converted')) as confirmed_payment,
        COUNT(*) FILTER (WHERE status = 'converted') as converted,
        COUNT(*) FILTER (WHERE status = 'expired') as expired,
        COUNT(*) FILTER (WHERE status = 'cancelled') as cancelled
    FROM reserve.booking_intents
    WHERE created_at > NOW() - INTERVAL '7 days'
    GROUP BY DATE(created_at)
)
SELECT 
    date,
    created,
    reached_payment,
    confirmed_payment,
    converted,
    expired,
    cancelled,
    ROUND(reached_payment::numeric / NULLIF(created, 0) * 100, 2) as payment_started_pct,
    ROUND(confirmed_payment::numeric / NULLIF(created, 0) * 100, 2) as payment_confirmed_pct,
    ROUND(converted::numeric / NULLIF(created, 0) * 100, 2) as conversion_pct
FROM intent_stats
ORDER BY date DESC;

-- ============================================
-- SECTION 4: RESERVATION MONITORING
-- ============================================

-- View for reservations needing attention
CREATE OR REPLACE VIEW reserve.reservations_needing_attention AS
SELECT 
    r.id,
    r.confirmation_code,
    r.status,
    r.payment_status,
    r.check_in,
    r.check_out,
    r.guest_first_name,
    r.guest_last_name,
    r.guest_email,
    r.total_amount,
    r.currency,
    r.created_at,
    CASE 
        WHEN r.status = 'pending' AND r.created_at < NOW() - INTERVAL '24 hours' 
            THEN 'PENDING_OVERDUE'
        WHEN r.status = 'confirmed' AND r.check_in < NOW() AND r.payment_status != 'paid'
            THEN 'CHECKIN_WITHOUT_PAYMENT'
        WHEN r.status = 'confirmed' AND r.check_in < NOW() - INTERVAL '1 day'
            THEN 'NO_SHOW_POSSIBLE'
        ELSE 'OK'
    END as attention_reason
FROM reserve.reservations r
WHERE (
    (r.status = 'pending' AND r.created_at < NOW() - INTERVAL '24 hours')
    OR (r.status = 'confirmed' AND r.check_in < NOW() AND r.payment_status != 'paid')
    OR (r.status = 'confirmed' AND r.check_in < NOW() - INTERVAL '1 day')
)
ORDER BY r.check_in ASC;

-- View for overbooking detection
CREATE OR REPLACE VIEW reserve.overbooking_check AS
SELECT 
    ac.unit_id,
    um.name as unit_name,
    pm.name as property_name,
    ac.date,
    ac.allotment,
    ac.bookings_count,
    ac.bookings_count as total_occupancy,
    ac.is_available,
    CASE 
        WHEN ac.bookings_count > ac.allotment THEN 'OVERBOOKED'
        WHEN ac.bookings_count = ac.allotment THEN 'FULL'
        ELSE 'AVAILABLE'
    END as status
FROM reserve.availability_calendar ac
JOIN reserve.unit_map um ON ac.unit_id = um.id
JOIN reserve.properties_map pm ON um.property_id = pm.id
WHERE ac.date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days'
AND ac.bookings_count > ac.allotment
ORDER BY ac.date ASC, pm.name, um.name;

-- ============================================
-- SECTION 5: WEBHOOK MONITORING
-- ============================================

-- View for webhook failure analysis
CREATE OR REPLACE VIEW reserve.webhook_failure_analysis AS
SELECT 
    provider,
    event_type,
    status,
    COUNT(*) as count,
    MIN(received_at) as first_seen,
    MAX(received_at) as last_seen,
    AVG(retry_count) as avg_retries,
    string_agg(DISTINCT error_message, '; ') as errors
FROM reserve.processed_webhooks
WHERE received_at > NOW() - INTERVAL '24 hours'
AND (status IN ('failed') OR retry_count > 0)
GROUP BY provider, event_type, status
ORDER BY count DESC;

-- View for webhook lag (time between receive and process)
CREATE OR REPLACE VIEW reserve.webhook_processing_lag AS
SELECT 
    provider,
    AVG(EXTRACT(EPOCH FROM (processed_at - received_at))) as avg_lag_seconds,
    MAX(EXTRACT(EPOCH FROM (processed_at - received_at))) as max_lag_seconds,
    COUNT(*) as total_processed
FROM reserve.processed_webhooks
WHERE processed_at IS NOT NULL
AND received_at > NOW() - INTERVAL '24 hours'
GROUP BY provider;

-- ============================================
-- SECTION 6: SYSTEM HEALTH CHECK
-- ============================================

-- Comprehensive system health check function
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
    v_result RECORD;
BEGIN
    checked_at := NOW();
    
    -- Check 1: Ledger imbalance
    SELECT COUNT(*) INTO v_count FROM reserve.find_ledger_imbalances();
    check_name := 'Ledger Balance';
    status := CASE WHEN v_count = 0 THEN 'OK' ELSE 'CRITICAL' END;
    details := CASE 
        WHEN v_count = 0 THEN 'All transactions balanced'
        ELSE format('%s imbalanced transactions found', v_count)
    END;
    severity := CASE WHEN v_count = 0 THEN 'INFO' ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;
    
    -- Check 2: Stuck payments
    SELECT COUNT(*) INTO v_count FROM reserve.stuck_payments;
    check_name := 'Stuck Payments';
    status := CASE 
        WHEN v_count = 0 THEN 'OK'
        WHEN v_count < 5 THEN 'WARNING'
        ELSE 'CRITICAL'
    END;
    details := format('%s payments stuck for >1 hour', v_count);
    severity := CASE 
        WHEN v_count = 0 THEN 'INFO'
        WHEN v_count < 5 THEN 'WARNING'
        ELSE 'CRITICAL'
    END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;
    
    -- Check 3: Expired intents not cleaned
    SELECT COUNT(*) INTO v_count FROM reserve.expired_intents_not_cleaned;
    check_name := 'Expired Intents';
    status := CASE 
        WHEN v_count = 0 THEN 'OK'
        WHEN v_count < 10 THEN 'WARNING'
        ELSE 'CRITICAL'
    END;
    details := format('%s expired intents not cleaned up', v_count);
    severity := CASE 
        WHEN v_count = 0 THEN 'INFO'
        WHEN v_count < 10 THEN 'WARNING'
        ELSE 'CRITICAL'
    END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;
    
    -- Check 4: Overbooking
    SELECT COUNT(*) INTO v_count FROM reserve.overbooking_check;
    check_name := 'Overbooking';
    status := CASE WHEN v_count = 0 THEN 'OK' ELSE 'CRITICAL' END;
    details := CASE 
        WHEN v_count = 0 THEN 'No overbookings detected'
        ELSE format('%s overbooked dates found', v_count)
    END;
    severity := CASE WHEN v_count = 0 THEN 'INFO' ELSE 'CRITICAL' END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;
    
    -- Check 5: Failed webhooks
    SELECT COUNT(*) INTO v_count 
    FROM reserve.processed_webhooks pw
    WHERE pw.status = 'failed' 
    AND pw.received_at > NOW() - INTERVAL '24 hours';
    check_name := 'Failed Webhooks';
    status := CASE 
        WHEN v_count = 0 THEN 'OK'
        WHEN v_count < 10 THEN 'WARNING'
        ELSE 'CRITICAL'
    END;
    details := format('%s failed webhooks in last 24h', v_count);
    severity := CASE 
        WHEN v_count = 0 THEN 'INFO'
        WHEN v_count < 10 THEN 'WARNING'
        ELSE 'CRITICAL'
    END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;
    
    -- Check 6: Active locks
    SELECT COUNT(*) INTO v_count FROM reserve.booking_locks WHERE expires_at > NOW();
    check_name := 'Active Locks';
    status := 'OK';
    details := format('%s active booking locks', v_count);
    severity := 'INFO';
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;
    
    -- Check 7: Audit log size
    SELECT pg_total_relation_size('reserve.audit_logs') INTO v_count;
    check_name := 'Audit Log Size';
    status := CASE 
        WHEN v_count < 1073741824 THEN 'OK'  -- < 1GB
        WHEN v_count < 5368709120 THEN 'WARNING'  -- < 5GB
        ELSE 'CRITICAL'  -- > 5GB
    END;
    details := format('Audit logs: %s', pg_size_pretty(v_count::bigint));
    severity := CASE 
        WHEN v_count < 1073741824 THEN 'INFO'
        WHEN v_count < 5368709120 THEN 'WARNING'
        ELSE 'CRITICAL'
    END;
    RETURN QUERY SELECT check_name, status, details, severity, checked_at;
    
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.system_health_check IS 'Comprehensive system health check - run daily';

-- ============================================
-- SECTION 7: DAILY METRICS SUMMARY
-- ============================================

-- Function to generate daily metrics report
CREATE OR REPLACE FUNCTION reserve.generate_daily_metrics(
    p_date DATE DEFAULT CURRENT_DATE - 1
)
RETURNS TABLE (
    metric_name VARCHAR(100),
    metric_value NUMERIC,
    details TEXT
) AS $$
BEGIN
    -- Booking metrics
    RETURN QUERY
    SELECT 
        'intents_created'::VARCHAR(100),
        COUNT(*)::NUMERIC,
        format('Booking intents created on %s', p_date)::TEXT
    FROM reserve.booking_intents
    WHERE DATE(created_at) = p_date;
    
    RETURN QUERY
    SELECT 
        'intents_converted'::VARCHAR(100),
        COUNT(*)::NUMERIC,
        format('Booking intents converted on %s', p_date)::TEXT
    FROM reserve.booking_intents
    WHERE DATE(converted_at) = p_date;
    
    -- Payment metrics
    RETURN QUERY
    SELECT 
        'payments_succeeded'::VARCHAR(100),
        COUNT(*)::NUMERIC,
        format('Total: R$ %s', COALESCE(SUM(amount), 0))::TEXT
    FROM reserve.payments
    WHERE DATE(succeeded_at) = p_date
    AND status = 'succeeded';
    
    RETURN QUERY
    SELECT 
        'payments_failed'::VARCHAR(100),
        COUNT(*)::NUMERIC,
        format('Failed payments on %s', p_date)::TEXT
    FROM reserve.payments
    WHERE DATE(created_at) = p_date
    AND status = 'failed';
    
    -- Reservation metrics
    RETURN QUERY
    SELECT 
        'new_reservations'::VARCHAR(100),
        COUNT(*)::NUMERIC,
        format('New reservations on %s', p_date)::TEXT
    FROM reserve.reservations
    WHERE DATE(created_at) = p_date;
    
    -- Revenue
    RETURN QUERY
    SELECT 
        'daily_revenue'::VARCHAR(100),
        COALESCE(SUM(amount), 0)::NUMERIC,
        format('BRL revenue on %s', p_date)::TEXT
    FROM reserve.payments
    WHERE DATE(succeeded_at) = p_date
    AND status = 'succeeded';
    
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.generate_daily_metrics IS 'Generate daily business metrics for reporting';

-- ============================================
-- SECTION 8: ALERTING THRESHOLDS
-- ============================================

-- Table to store alert configurations
CREATE TABLE IF NOT EXISTS reserve.alert_configurations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alert_name VARCHAR(100) NOT NULL UNIQUE,
    metric_view VARCHAR(100) NOT NULL,
    threshold_operator VARCHAR(10) NOT NULL CHECK (threshold_operator IN ('>', '<', '>=', '<=', '=', '!=')),
    threshold_value NUMERIC NOT NULL,
    severity VARCHAR(20) NOT NULL CHECK (severity IN ('INFO', 'WARNING', 'CRITICAL')),
    is_active BOOLEAN DEFAULT true,
    last_triggered_at TIMESTAMPTZ,
    notification_channels TEXT[],
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert default alerts
INSERT INTO reserve.alert_configurations (alert_name, metric_view, threshold_operator, threshold_value, severity)
VALUES 
    ('stuck_payments', 'stuck_payments', '>', 0, 'WARNING'),
    ('overbooking_detected', 'overbooking_check', '>', 0, 'CRITICAL'),
    ('ledger_imbalance', 'ledger_balance_check', '>', 0, 'CRITICAL'),
    ('failed_webhooks', 'webhook_failure_analysis', '>', 5, 'WARNING'),
    ('expired_intents', 'expired_intents_not_cleaned', '>', 10, 'WARNING')
ON CONFLICT (alert_name) DO NOTHING;

-- Function to check all alerts
CREATE OR REPLACE FUNCTION reserve.check_all_alerts()
RETURNS TABLE (
    alert_name VARCHAR(100),
    triggered BOOLEAN,
    current_value NUMERIC,
    threshold NUMERIC,
    severity VARCHAR(20),
    details TEXT
) AS $$
DECLARE
    v_alert RECORD;
    v_count INT;
BEGIN
    FOR v_alert IN SELECT * FROM reserve.alert_configurations WHERE is_active = true
    LOOP
        -- Execute count query dynamically
        EXECUTE format('SELECT COUNT(*) FROM reserve.%I', v_alert.metric_view) INTO v_count;
        
        alert_name := v_alert.alert_name;
        current_value := v_count;
        threshold := v_alert.threshold_value;
        severity := v_alert.severity;
        
        -- Check threshold
        triggered := CASE v_alert.threshold_operator
            WHEN '>' THEN v_count > v_alert.threshold_value
            WHEN '<' THEN v_count < v_alert.threshold_value
            WHEN '>=' THEN v_count >= v_alert.threshold_value
            WHEN '<=' THEN v_count <= v_alert.threshold_value
            WHEN '=' THEN v_count = v_alert.threshold_value
            WHEN '!=' THEN v_count != v_alert.threshold_value
            ELSE false
        END;
        
        details := format('View: %s, Operator: %s, Threshold: %s', 
            v_alert.metric_view, v_alert.threshold_operator, v_alert.threshold_value);
        
        -- Update last_triggered if triggered
        IF triggered THEN
            UPDATE reserve.alert_configurations
            SET last_triggered_at = NOW()
            WHERE id = v_alert.id;
        END IF;
        
        RETURN NEXT;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.check_all_alerts IS 'Check all configured alerts against current system state';

-- ============================================
-- SECTION 9: MAINTENANCE TASKS
-- ============================================

-- Table to track maintenance task execution
CREATE TABLE IF NOT EXISTS reserve.maintenance_task_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_name VARCHAR(100) NOT NULL,
    started_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'running' CHECK (status IN ('running', 'completed', 'failed')),
    records_processed INT,
    error_message TEXT,
    execution_time_ms INT
);

-- Function to run daily maintenance
CREATE OR REPLACE FUNCTION reserve.run_daily_maintenance()
RETURNS TABLE (
    task_name VARCHAR(100),
    status VARCHAR(20),
    records_processed INT,
    execution_time_ms INT,
    error_message TEXT
) AS $$
DECLARE
    v_task_id UUID;
    v_start_time TIMESTAMPTZ;
    v_count INT;
BEGIN
    v_start_time := clock_timestamp();
    
    -- Task 1: Cleanup expired locks
    INSERT INTO reserve.maintenance_task_log (task_name) 
    VALUES ('cleanup_expired_locks') 
    RETURNING id INTO v_task_id;
    
    BEGIN
        SELECT reserve.cleanup_expired_locks() INTO v_count;
        
        UPDATE reserve.maintenance_task_log
        SET status = 'completed',
            completed_at = NOW(),
            records_processed = v_count,
            execution_time_ms = EXTRACT(MILLISECONDS FROM (clock_timestamp() - v_start_time))::INT
        WHERE id = v_task_id;
        
        RETURN QUERY SELECT 
            'cleanup_expired_locks'::VARCHAR(100),
            'completed'::VARCHAR(20),
            v_count,
            EXTRACT(MILLISECONDS FROM (clock_timestamp() - v_start_time))::INT,
            NULL::TEXT;
    EXCEPTION WHEN OTHERS THEN
        UPDATE reserve.maintenance_task_log
        SET status = 'failed',
            completed_at = NOW(),
            error_message = SQLERRM,
            execution_time_ms = EXTRACT(MILLISECONDS FROM (clock_timestamp() - v_start_time))::INT
        WHERE id = v_task_id;
        
        RETURN QUERY SELECT 
            'cleanup_expired_locks'::VARCHAR(100),
            'failed'::VARCHAR(20),
            0,
            EXTRACT(MILLISECONDS FROM (clock_timestamp() - v_start_time))::INT,
            SQLERRM::TEXT;
    END;
    
    -- Task 2: Run data retention cleanup
    v_start_time := clock_timestamp();
    INSERT INTO reserve.maintenance_task_log (task_name) 
    VALUES ('retention_cleanup') 
    RETURNING id INTO v_task_id;
    
    BEGIN
        PERFORM reserve.run_retention_cleanup();
        
        UPDATE reserve.maintenance_task_log
        SET status = 'completed',
            completed_at = NOW(),
            execution_time_ms = EXTRACT(MILLISECONDS FROM (clock_timestamp() - v_start_time))::INT
        WHERE id = v_task_id;
        
        RETURN QUERY SELECT 
            'retention_cleanup'::VARCHAR(100),
            'completed'::VARCHAR(20),
            0,
            EXTRACT(MILLISECONDS FROM (clock_timestamp() - v_start_time))::INT,
            NULL::TEXT;
    EXCEPTION WHEN OTHERS THEN
        UPDATE reserve.maintenance_task_log
        SET status = 'failed',
            completed_at = NOW(),
            error_message = SQLERRM,
            execution_time_ms = EXTRACT(MILLISECONDS FROM (clock_timestamp() - v_start_time))::INT
        WHERE id = v_task_id;
        
        RETURN QUERY SELECT 
            'retention_cleanup'::VARCHAR(100),
            'failed'::VARCHAR(20),
            0,
            EXTRACT(MILLISECONDS FROM (clock_timestamp() - v_start_time))::INT,
            SQLERRM::TEXT;
    END;
    
    -- Task 3: System health check
    v_start_time := clock_timestamp();
    INSERT INTO reserve.maintenance_task_log (task_name) 
    VALUES ('system_health_check') 
    RETURNING id INTO v_task_id;
    
    BEGIN
        PERFORM reserve.system_health_check();
        
        UPDATE reserve.maintenance_task_log
        SET status = 'completed',
            completed_at = NOW(),
            execution_time_ms = EXTRACT(MILLISECONDS FROM (clock_timestamp() - v_start_time))::INT
        WHERE id = v_task_id;
        
        RETURN QUERY SELECT 
            'system_health_check'::VARCHAR(100),
            'completed'::VARCHAR(20),
            0,
            EXTRACT(MILLISECONDS FROM (clock_timestamp() - v_start_time))::INT,
            NULL::TEXT;
    EXCEPTION WHEN OTHERS THEN
        UPDATE reserve.maintenance_task_log
        SET status = 'failed',
            completed_at = NOW(),
            error_message = SQLERRM,
            execution_time_ms = EXTRACT(MILLISECONDS FROM (clock_timestamp() - v_start_time))::INT
        WHERE id = v_task_id;
        
        RETURN QUERY SELECT 
            'system_health_check'::VARCHAR(100),
            'failed'::VARCHAR(20),
            0,
            EXTRACT(MILLISECONDS FROM (clock_timestamp() - v_start_time))::INT,
            SQLERRM::TEXT;
    END;
    
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.run_daily_maintenance IS 'Run all daily maintenance tasks - schedule via cron';

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 
    'Operational Monitoring Helpers Migration' as migration,
    '016_ops_monitoring_helpers.sql' as file,
    'COMPLETED' as status,
    NOW() as executed_at;

-- Show all views created
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'reserve'
AND table_type = 'VIEW'
AND table_name IN (
    'ledger_balance_check',
    'stuck_payments',
    'payment_metrics_24h',
    'expired_intents_not_cleaned',
    'intent_conversion_funnel',
    'reservations_needing_attention',
    'overbooking_check',
    'webhook_failure_analysis',
    'webhook_processing_lag'
)
ORDER BY table_name;

-- Show all monitoring functions
SELECT routine_name, routine_type
FROM information_schema.routines
WHERE routine_schema = 'reserve'
AND routine_name IN (
    'find_ledger_imbalances',
    'system_health_check',
    'generate_daily_metrics',
    'check_all_alerts',
    'run_daily_maintenance'
)
ORDER BY routine_name;

-- Run quick health check
SELECT * FROM reserve.system_health_check() LIMIT 5;

-- ============================================
-- ROLLBACK INSTRUCTIONS
-- ============================================
/*
To rollback this migration:

1. Drop views:
   DROP VIEW IF EXISTS reserve.ledger_balance_check CASCADE;
   DROP VIEW IF EXISTS reserve.stuck_payments CASCADE;
   DROP VIEW IF EXISTS reserve.payment_metrics_24h CASCADE;
   DROP VIEW IF EXISTS reserve.failed_payments_analysis CASCADE;
   DROP VIEW IF EXISTS reserve.expired_intents_not_cleaned CASCADE;
   DROP VIEW IF EXISTS reserve.intent_conversion_funnel CASCADE;
   DROP VIEW IF EXISTS reserve.reservations_needing_attention CASCADE;
   DROP VIEW IF EXISTS reserve.overbooking_check CASCADE;
   DROP VIEW IF EXISTS reserve.webhook_failure_analysis CASCADE;
   DROP VIEW IF EXISTS reserve.webhook_processing_lag CASCADE;

2. Drop functions:
   DROP FUNCTION IF EXISTS reserve.find_ledger_imbalances(DATE);
   DROP FUNCTION IF EXISTS reserve.system_health_check();
   DROP FUNCTION IF EXISTS reserve.generate_daily_metrics(DATE);
   DROP FUNCTION IF EXISTS reserve.check_all_alerts();
   DROP FUNCTION IF EXISTS reserve.run_daily_maintenance();

3. Drop tables:
   DROP TABLE IF EXISTS reserve.alert_configurations CASCADE;
   DROP TABLE IF EXISTS reserve.maintenance_task_log CASCADE;

WARNING: Rolling back removes all monitoring capabilities!
*/
