-- ============================================
-- MIGRATION 034: ADMIN LEDGER TRANSACTION WRAPPER
-- Description: Expose secure transaction drill-down via public RPC
-- ============================================

CREATE OR REPLACE FUNCTION public.admin_get_ledger_transaction_entries(
    p_transaction_id UUID
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
        'transaction_id', p_transaction_id,
        'entries', COALESCE(
            jsonb_agg(
                jsonb_build_object(
                    'id', le.id,
                    'entry_type', le.entry_type,
                    'booking_id', le.booking_id,
                    'payment_id', le.payment_id,
                    'confirmation_code', r.confirmation_code,
                    'city_code', le.city_code,
                    'account', le.account,
                    'counterparty', le.counterparty,
                    'direction', le.direction,
                    'amount', le.amount,
                    'description', le.description,
                    'created_at', le.created_at
                )
                ORDER BY le.created_at DESC
            ),
            '[]'::JSONB
        ),
        'totals', jsonb_build_object(
            'debits', COALESCE(SUM(CASE WHEN le.direction = 'debit' THEN le.amount ELSE 0 END), 0),
            'credits', COALESCE(SUM(CASE WHEN le.direction = 'credit' THEN le.amount ELSE 0 END), 0),
            'imbalance', COALESCE(SUM(CASE WHEN le.direction = 'debit' THEN le.amount ELSE 0 END), 0) - COALESCE(SUM(CASE WHEN le.direction = 'credit' THEN le.amount ELSE 0 END), 0)
        )
    )
    INTO v_result
    FROM reserve.ledger_entries le
    LEFT JOIN reserve.reservations r ON r.id = le.booking_id
    WHERE le.transaction_id = p_transaction_id;

    IF (v_result -> 'entries') = '[]'::JSONB THEN
        RAISE EXCEPTION 'Transaction not found';
    END IF;

    RETURN v_result;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_get_ledger_transaction_entries(UUID) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.admin_get_ledger_transaction_entries(UUID) TO service_role;
