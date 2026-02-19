-- ============================================
-- MIGRATION 033: ADMIN PAYOUTS PUBLIC WRAPPER
-- Description: Expose secure payout listing via public RPC
-- ============================================

CREATE OR REPLACE FUNCTION public.admin_list_payouts(
    p_city_code TEXT DEFAULT NULL,
    p_status TEXT DEFAULT NULL,
    p_search TEXT DEFAULT NULL,
    p_limit INTEGER DEFAULT 300
)
RETURNS TABLE (
    id UUID,
    batch_id UUID,
    city_code TEXT,
    property_id UUID,
    property_name TEXT,
    currency TEXT,
    gross_amount NUMERIC,
    commission_amount NUMERIC,
    fee_amount NUMERIC,
    tax_amount NUMERIC,
    net_amount NUMERIC,
    status TEXT,
    booking_count INTEGER,
    gateway_reference TEXT,
    gateway_transfer_id TEXT,
    created_at TIMESTAMPTZ,
    processed_at TIMESTAMPTZ,
    transferred_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    SELECT
        po.id,
        po.batch_id,
        po.city_code::TEXT AS city_code,
        po.property_id,
        pm.name AS property_name,
        po.currency,
        COALESCE(po.gross_amount, 0) AS gross_amount,
        COALESCE(po.commission_amount, 0) AS commission_amount,
        COALESCE(po.fee_amount, 0) AS fee_amount,
        COALESCE(po.tax_amount, 0) AS tax_amount,
        COALESCE(po.net_amount, 0) AS net_amount,
        po.status,
        COALESCE(po.booking_count, 0) AS booking_count,
        po.gateway_reference,
        po.gateway_transfer_id,
        po.created_at,
        po.processed_at,
        po.transferred_at
    FROM reserve.payouts po
    LEFT JOIN reserve.properties_map pm ON pm.id = po.property_id
    WHERE (p_city_code IS NULL OR po.city_code::TEXT = p_city_code)
      AND (p_status IS NULL OR po.status = p_status)
      AND (
        p_search IS NULL
        OR CONCAT_WS(' ',
            po.id::TEXT,
            po.batch_id::TEXT,
            po.property_id::TEXT,
            pm.name,
            po.city_code::TEXT,
            po.status,
            po.gateway_reference,
            po.gateway_transfer_id
        ) ILIKE ('%' || p_search || '%')
      )
    ORDER BY po.created_at DESC
    LIMIT LEAST(GREATEST(COALESCE(p_limit, 300), 1), 500);
$$;

REVOKE ALL ON FUNCTION public.admin_list_payouts(TEXT, TEXT, TEXT, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.admin_list_payouts(TEXT, TEXT, TEXT, INTEGER) TO service_role;
