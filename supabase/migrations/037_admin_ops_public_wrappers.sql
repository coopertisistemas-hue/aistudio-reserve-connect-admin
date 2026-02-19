-- ============================================
-- MIGRATION 037: ADMIN OPS PUBLIC WRAPPERS
-- Description: Expose ops snapshot, health checks, and alerts via public RPC
-- ============================================

CREATE OR REPLACE FUNCTION public.admin_ops_snapshot()
RETURNS JSONB
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    SELECT jsonb_build_object(
        'generated_at', s.generated_at,
        'ledger_imbalances', s.ledger_imbalances,
        'stuck_payments', s.stuck_payments,
        'failed_payment_webhooks', s.failed_payment_webhooks,
        'failed_host_webhooks', s.failed_host_webhooks,
        'failed_webhooks', COALESCE(s.failed_payment_webhooks, 0) + COALESCE(s.failed_host_webhooks, 0),
        'pending_cancellations', s.pending_cancellations,
        'overbookings', s.overbookings,
        'expired_intents', s.expired_intents,
        'last_reconciliation_run', s.last_reconciliation_run,
        'blocked_locks', s.blocked_locks
    )
    FROM reserve.ops_dashboard_summary s;
$$;

CREATE OR REPLACE FUNCTION public.admin_ops_health_checks()
RETURNS TABLE (
    check_name TEXT,
    status TEXT,
    details TEXT,
    severity TEXT,
    checked_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    SELECT
        h.check_name::TEXT,
        h.status::TEXT,
        h.details::TEXT,
        h.severity::TEXT,
        h.checked_at
    FROM reserve.system_health_check() h;
$$;

CREATE OR REPLACE FUNCTION public.admin_ops_alerts()
RETURNS TABLE (
    alert_code TEXT,
    severity TEXT,
    description TEXT,
    evidence_query TEXT
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    SELECT
        a.alert_code::TEXT,
        a.severity::TEXT,
        a.description::TEXT,
        a.evidence_query::TEXT
    FROM reserve.ops_dashboard_alerts a
    ORDER BY
        CASE a.severity
            WHEN 'CRITICAL' THEN 1
            WHEN 'WARNING' THEN 2
            ELSE 3
        END,
        a.alert_code;
$$;

REVOKE ALL ON FUNCTION public.admin_ops_snapshot() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_ops_health_checks() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_ops_alerts() FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.admin_ops_snapshot() TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_ops_health_checks() TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_ops_alerts() TO service_role;
