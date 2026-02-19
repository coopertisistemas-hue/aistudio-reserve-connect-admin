-- ============================================
-- MIGRATION 038: ADMIN OPS MAINTENANCE WRAPPERS
-- Description: Expose retention dry-run and reconciliation status via public RPC
-- ============================================

CREATE OR REPLACE FUNCTION public.admin_ops_retention_preview(
    p_audit_days INTEGER DEFAULT 180,
    p_webhook_days INTEGER DEFAULT 60,
    p_recon_days INTEGER DEFAULT 90
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
DECLARE
    v_audit_candidates INTEGER;
    v_webhook_candidates INTEGER;
    v_recon_candidates INTEGER;
BEGIN
    v_audit_candidates := reserve.purge_old_audit_logs(p_audit_days, true);
    v_webhook_candidates := reserve.purge_old_webhook_dedup(p_webhook_days, true);
    v_recon_candidates := reserve.purge_old_reconciliation_runs(p_recon_days, true);

    RETURN jsonb_build_object(
        'audit_days', p_audit_days,
        'webhook_days', p_webhook_days,
        'reconciliation_days', p_recon_days,
        'audit_log_candidates', v_audit_candidates,
        'webhook_candidates', v_webhook_candidates,
        'reconciliation_candidates', v_recon_candidates,
        'dry_run', true,
        'generated_at', NOW()
    );
END;
$$;

CREATE OR REPLACE FUNCTION public.admin_ops_reconciliation_status()
RETURNS JSONB
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    WITH last_run AS (
        SELECT
            run_id,
            status,
            started_at,
            completed_at,
            summary
        FROM reserve.reconciliation_runs
        ORDER BY created_at DESC
        LIMIT 1
    )
    SELECT jsonb_build_object(
        'last_run', (
            SELECT row_to_json(last_run.*)::jsonb FROM last_run
        ),
        'failed_last_7_days', (
            SELECT COUNT(*)
            FROM reserve.reconciliation_runs
            WHERE status = 'failed'
              AND created_at > NOW() - INTERVAL '7 days'
        ),
        'pending_cancellations', (
            SELECT COUNT(*)
            FROM reserve.cancellation_requests
            WHERE status = 'processing'
        ),
        'failed_host_webhooks_last_24h', (
            SELECT COUNT(*)
            FROM reserve.host_webhook_events
            WHERE status = 'failed'
              AND created_at > NOW() - INTERVAL '24 hours'
        ),
        'failed_payment_webhooks_last_24h', (
            SELECT COUNT(*)
            FROM reserve.processed_webhooks
            WHERE status = 'failed'
              AND received_at > NOW() - INTERVAL '24 hours'
        ),
        'generated_at', NOW()
    );
$$;

REVOKE ALL ON FUNCTION public.admin_ops_retention_preview(INTEGER, INTEGER, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_ops_reconciliation_status() FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.admin_ops_retention_preview(INTEGER, INTEGER, INTEGER) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_ops_reconciliation_status() TO service_role;
