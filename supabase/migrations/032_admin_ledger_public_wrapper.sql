-- ============================================
-- MIGRATION 032: ADMIN LEDGER PUBLIC WRAPPER
-- Description: Expose secure ledger listing via public RPC
-- ============================================

CREATE OR REPLACE FUNCTION public.admin_list_ledger_entries(
    p_city_code TEXT DEFAULT NULL,
    p_account TEXT DEFAULT NULL,
    p_entry_type TEXT DEFAULT NULL,
    p_search TEXT DEFAULT NULL,
    p_limit INTEGER DEFAULT 400
)
RETURNS TABLE (
    id UUID,
    transaction_id UUID,
    entry_type TEXT,
    booking_id UUID,
    payment_id UUID,
    confirmation_code TEXT,
    city_code TEXT,
    account TEXT,
    counterparty TEXT,
    direction TEXT,
    amount NUMERIC,
    description TEXT,
    created_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    SELECT
        le.id,
        le.transaction_id,
        le.entry_type,
        le.booking_id,
        le.payment_id,
        r.confirmation_code,
        le.city_code::TEXT AS city_code,
        le.account,
        le.counterparty,
        le.direction,
        le.amount,
        le.description,
        le.created_at
    FROM reserve.ledger_entries le
    LEFT JOIN reserve.reservations r ON r.id = le.booking_id
    WHERE (p_city_code IS NULL OR le.city_code::TEXT = p_city_code)
      AND (p_account IS NULL OR le.account = p_account)
      AND (p_entry_type IS NULL OR le.entry_type = p_entry_type)
      AND (
        p_search IS NULL
        OR CONCAT_WS(' ',
            le.id::TEXT,
            le.transaction_id::TEXT,
            le.entry_type,
            le.booking_id::TEXT,
            le.payment_id::TEXT,
            le.account,
            le.counterparty,
            le.direction,
            le.city_code::TEXT,
            le.description,
            r.confirmation_code
        ) ILIKE ('%' || p_search || '%')
      )
    ORDER BY le.created_at DESC
    LIMIT LEAST(GREATEST(COALESCE(p_limit, 400), 1), 1000);
$$;

REVOKE ALL ON FUNCTION public.admin_list_ledger_entries(TEXT, TEXT, TEXT, TEXT, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.admin_list_ledger_entries(TEXT, TEXT, TEXT, TEXT, INTEGER) TO service_role;
