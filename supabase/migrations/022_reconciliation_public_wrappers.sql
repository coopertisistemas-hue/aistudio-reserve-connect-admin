-- ============================================
-- MIGRATION 022: RECONCILIATION PUBLIC WRAPPERS
-- Description: Expose reconciliation helpers via public schema RPC
-- Version: 1.0
-- Date: 2026-02-16
-- Risk Level: LOW - Ops helper
-- ============================================

CREATE OR REPLACE FUNCTION public.reconciliation_summary()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
DECLARE
    v_one_hour_ago TIMESTAMPTZ := NOW() - INTERVAL '1 hour';
    v_fifteen_min_ago TIMESTAMPTZ := NOW() - INTERVAL '15 minutes';
    v_ten_min_ago TIMESTAMPTZ := NOW() - INTERVAL '10 minutes';
    v_summary JSONB;
BEGIN
    v_summary := jsonb_build_object(
        'stuck_payments', (
            SELECT COUNT(*) FROM reserve.payments
            WHERE status IN ('pending', 'processing')
              AND created_at < v_one_hour_ago
        ),
        'missing_finalization', (
            SELECT COUNT(*) FROM reserve.booking_intents
            WHERE status = 'payment_confirmed'
              AND converted_to_reservation_id IS NULL
              AND created_at < v_ten_min_ago
        ),
        'pending_webhooks', (
            SELECT COUNT(*) FROM reserve.host_webhook_events
            WHERE status IN ('pending', 'failed')
              AND created_at < v_fifteen_min_ago
        ),
        'pending_cancellations', (
            SELECT COUNT(*) FROM reserve.cancellation_requests
            WHERE status = 'processing'
              AND created_at < v_fifteen_min_ago
        ),
        'generated_at', NOW()
    );

    RETURN v_summary;
END;
$$;

COMMENT ON FUNCTION public.reconciliation_summary IS 'Returns reconciliation summary for edge function';

CREATE OR REPLACE FUNCTION public.log_reconciliation_run(
    p_run_id TEXT,
    p_status TEXT,
    p_summary JSONB,
    p_started_at TIMESTAMPTZ,
    p_completed_at TIMESTAMPTZ
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
BEGIN
    INSERT INTO reserve.reconciliation_runs (
        run_id,
        status,
        summary,
        started_at,
        completed_at
    ) VALUES (
        p_run_id,
        p_status,
        p_summary,
        p_started_at,
        p_completed_at
    );
END;
$$;

COMMENT ON FUNCTION public.log_reconciliation_run IS 'Logs reconciliation run summary to reserve schema';

REVOKE ALL ON FUNCTION public.reconciliation_summary() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.log_reconciliation_run(TEXT, TEXT, JSONB, TIMESTAMPTZ, TIMESTAMPTZ) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.reconciliation_summary() TO service_role;
GRANT EXECUTE ON FUNCTION public.log_reconciliation_run(TEXT, TEXT, JSONB, TIMESTAMPTZ, TIMESTAMPTZ) TO service_role;

SELECT 'Reconciliation public wrappers applied' AS status, NOW() AS executed_at;
