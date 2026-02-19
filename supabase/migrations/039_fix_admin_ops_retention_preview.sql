-- ============================================
-- MIGRATION 039: FIX ADMIN OPS RETENTION PREVIEW
-- Description: Remove dependency on service_role-only purge helpers
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
    SELECT COUNT(*)
    INTO v_audit_candidates
    FROM reserve.audit_logs
    WHERE created_at < NOW() - INTERVAL '1 day' * p_audit_days;

    SELECT COUNT(*)
    INTO v_webhook_candidates
    FROM reserve.processed_webhooks
    WHERE received_at < NOW() - INTERVAL '1 day' * p_webhook_days;

    SELECT COUNT(*)
    INTO v_recon_candidates
    FROM reserve.reconciliation_runs
    WHERE created_at < NOW() - INTERVAL '1 day' * p_recon_days;

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
