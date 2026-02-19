-- ============================================
-- MIGRATION 036: ADMIN PAYOUT DETAIL WRAPPER
-- Description: Expose secure payout detail via public RPC
-- ============================================

CREATE OR REPLACE FUNCTION public.admin_get_payout_detail(
    p_payout_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
DECLARE
    v_result JSONB;
BEGIN
    SELECT jsonb_build_object(
        'payout', jsonb_build_object(
            'id', po.id,
            'batch_id', po.batch_id,
            'city_code', po.city_code,
            'property_id', po.property_id,
            'property_name', pm.name,
            'currency', po.currency,
            'gross_amount', COALESCE(po.gross_amount, 0),
            'commission_amount', COALESCE(po.commission_amount, 0),
            'fee_amount', COALESCE(po.fee_amount, 0),
            'tax_amount', COALESCE(po.tax_amount, 0),
            'net_amount', COALESCE(po.net_amount, 0),
            'status', po.status,
            'gateway_reference', po.gateway_reference,
            'gateway_transfer_id', po.gateway_transfer_id,
            'booking_count', COALESCE(po.booking_count, 0),
            'reservation_ids', po.reservation_ids,
            'created_at', po.created_at,
            'processed_at', po.processed_at,
            'transferred_at', po.transferred_at
        ),
        'ledger_entries', COALESCE((
            SELECT jsonb_agg(jsonb_build_object(
                'id', le.id,
                'transaction_id', le.transaction_id,
                'entry_type', le.entry_type,
                'account', le.account,
                'direction', le.direction,
                'amount', le.amount,
                'description', le.description,
                'created_at', le.created_at
            ) ORDER BY le.created_at DESC)
            FROM reserve.ledger_entries le
            WHERE le.payout_id = po.id
        ), '[]'::JSONB)
    ) INTO v_result
    FROM reserve.payouts po
    LEFT JOIN reserve.properties_map pm ON pm.id = po.property_id
    WHERE po.id = p_payout_id;

    IF v_result IS NULL THEN
        RAISE EXCEPTION 'Payout not found';
    END IF;

    RETURN v_result;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_get_payout_detail(UUID) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.admin_get_payout_detail(UUID) TO service_role;
