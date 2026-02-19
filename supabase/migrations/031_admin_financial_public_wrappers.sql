-- ============================================
-- MIGRATION 031: ADMIN FINANCIAL PUBLIC WRAPPERS
-- Description: Expose secure payment admin operations via public RPC
-- ============================================

CREATE OR REPLACE FUNCTION public.admin_list_payments(
    p_city_code TEXT DEFAULT NULL,
    p_status TEXT DEFAULT NULL,
    p_search TEXT DEFAULT NULL,
    p_limit INTEGER DEFAULT 300
)
RETURNS TABLE (
    id UUID,
    reservation_id UUID,
    confirmation_code TEXT,
    guest_name TEXT,
    property_name TEXT,
    city_code TEXT,
    payment_method TEXT,
    gateway TEXT,
    gateway_payment_id TEXT,
    currency TEXT,
    amount NUMERIC,
    gateway_fee NUMERIC,
    tax_amount NUMERIC,
    refunded_amount NUMERIC,
    net_amount NUMERIC,
    status TEXT,
    created_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    SELECT
        p.id,
        p.reservation_id,
        r.confirmation_code,
        NULLIF(CONCAT_WS(' ', r.guest_first_name, r.guest_last_name), '') AS guest_name,
        pm.name AS property_name,
        p.city_code::TEXT AS city_code,
        p.payment_method,
        p.gateway,
        p.gateway_payment_id,
        p.currency,
        COALESCE(p.amount, 0) AS amount,
        COALESCE(p.gateway_fee, 0) AS gateway_fee,
        COALESCE(p.tax_amount, 0) AS tax_amount,
        COALESCE(p.refunded_amount, 0) AS refunded_amount,
        COALESCE(p.amount, 0) - COALESCE(p.gateway_fee, 0) - COALESCE(p.tax_amount, 0) - COALESCE(p.refunded_amount, 0) AS net_amount,
        p.status,
        p.created_at
    FROM reserve.payments p
    LEFT JOIN reserve.reservations r ON r.id = p.reservation_id
    LEFT JOIN reserve.properties_map pm ON pm.id = r.property_id
    WHERE (p_city_code IS NULL OR p.city_code::TEXT = p_city_code)
      AND (p_status IS NULL OR p.status = p_status)
      AND (
        p_search IS NULL
        OR CONCAT_WS(' ',
            p.id::TEXT,
            p.gateway_payment_id,
            p.reservation_id::TEXT,
            r.confirmation_code,
            r.guest_first_name,
            r.guest_last_name,
            pm.name,
            p.city_code::TEXT,
            p.status
        ) ILIKE ('%' || p_search || '%')
      )
    ORDER BY p.created_at DESC
    LIMIT LEAST(GREATEST(COALESCE(p_limit, 300), 1), 500);
$$;

CREATE OR REPLACE FUNCTION public.admin_get_payment_detail(
    p_payment_id UUID
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
        'payment', jsonb_build_object(
            'id', p.id,
            'reservation_id', p.reservation_id,
            'city_code', p.city_code,
            'payment_method', p.payment_method,
            'gateway', p.gateway,
            'gateway_payment_id', p.gateway_payment_id,
            'currency', p.currency,
            'amount', COALESCE(p.amount, 0),
            'gateway_fee', COALESCE(p.gateway_fee, 0),
            'tax_amount', COALESCE(p.tax_amount, 0),
            'refunded_amount', COALESCE(p.refunded_amount, 0),
            'net_amount', COALESCE(p.amount, 0) - COALESCE(p.gateway_fee, 0) - COALESCE(p.tax_amount, 0) - COALESCE(p.refunded_amount, 0),
            'status', p.status,
            'created_at', p.created_at,
            'succeeded_at', p.succeeded_at,
            'failed_at', p.failed_at,
            'refunded_at', p.refunded_at,
            'metadata', p.metadata
        ),
        'reservation', CASE
            WHEN r.id IS NULL THEN NULL
            ELSE jsonb_build_object(
                'id', r.id,
                'confirmation_code', r.confirmation_code,
                'status', r.status,
                'guest_name', NULLIF(CONCAT_WS(' ', r.guest_first_name, r.guest_last_name), ''),
                'property_name', pm.name
            )
        END,
        'ledger_entries', COALESCE((
            SELECT jsonb_agg(jsonb_build_object(
                'id', le.id,
                'entry_type', le.entry_type,
                'account', le.account,
                'direction', le.direction,
                'amount', le.amount,
                'description', le.description,
                'created_at', le.created_at
            ) ORDER BY le.created_at DESC)
            FROM reserve.ledger_entries le
            WHERE le.payment_id = p.id
        ), '[]'::JSONB)
    ) INTO v_result
    FROM reserve.payments p
    LEFT JOIN reserve.reservations r ON r.id = p.reservation_id
    LEFT JOIN reserve.properties_map pm ON pm.id = r.property_id
    WHERE p.id = p_payment_id;

    IF v_result IS NULL THEN
        RAISE EXCEPTION 'Payment not found';
    END IF;

    RETURN v_result;
END;
$$;

CREATE OR REPLACE FUNCTION public.admin_apply_payment_refund(
    p_payment_id UUID,
    p_amount NUMERIC,
    p_reason TEXT DEFAULT NULL,
    p_admin_email TEXT DEFAULT NULL
)
RETURNS TABLE (
    payment_id UUID,
    status TEXT,
    refunded_amount NUMERIC,
    currency TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
DECLARE
    v_payment reserve.payments%ROWTYPE;
    v_now TIMESTAMPTZ := NOW();
    v_refundable NUMERIC;
    v_next_refunded NUMERIC;
    v_next_status TEXT;
    v_tx UUID := gen_random_uuid();
BEGIN
    IF p_amount IS NULL OR p_amount <= 0 THEN
        RAISE EXCEPTION 'Invalid refund amount';
    END IF;

    SELECT *
    INTO v_payment
    FROM reserve.payments
    WHERE id = p_payment_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Payment not found';
    END IF;

    IF v_payment.status IN ('failed', 'cancelled') THEN
        RAISE EXCEPTION 'Payment status does not allow refunds: %', v_payment.status;
    END IF;

    v_refundable := GREATEST(COALESCE(v_payment.amount, 0) - COALESCE(v_payment.refunded_amount, 0), 0);

    IF p_amount > v_refundable THEN
        RAISE EXCEPTION 'Refund amount exceeds refundable balance';
    END IF;

    v_next_refunded := COALESCE(v_payment.refunded_amount, 0) + p_amount;
    v_next_status := CASE
        WHEN v_next_refunded >= COALESCE(v_payment.amount, 0) THEN 'refunded'
        ELSE 'partially_refunded'
    END;

    UPDATE reserve.payments
    SET
        refunded_amount = v_next_refunded,
        status = v_next_status,
        refunded_at = v_now,
        updated_at = v_now,
        metadata = COALESCE(v_payment.metadata, '{}'::JSONB) || jsonb_build_object(
            'admin_refund', jsonb_build_object(
                'amount', p_amount,
                'reason', p_reason,
                'admin_email', p_admin_email,
                'at', v_now
            )
        )
    WHERE id = p_payment_id;

    IF v_payment.reservation_id IS NOT NULL THEN
        UPDATE reserve.reservations
        SET
            payment_status = v_next_status,
            updated_at = v_now
        WHERE id = v_payment.reservation_id;
    END IF;

    INSERT INTO reserve.ledger_entries (
        transaction_id,
        entry_type,
        booking_id,
        city_code,
        payment_id,
        account,
        counterparty,
        direction,
        amount,
        description,
        created_at
    ) VALUES
        (
            v_tx,
            'refund_processed',
            v_payment.reservation_id,
            COALESCE(v_payment.city_code, 'URB'),
            v_payment.id,
            'refunds_payable',
            'customer',
            'debit',
            p_amount,
            COALESCE(p_reason, 'Admin refund'),
            v_now
        ),
        (
            v_tx,
            'refund_processed',
            v_payment.reservation_id,
            COALESCE(v_payment.city_code, 'URB'),
            v_payment.id,
            'cash_reserve',
            'customer',
            'credit',
            p_amount,
            COALESCE(p_reason, 'Admin refund'),
            v_now
        );

    RETURN QUERY
    SELECT
        v_payment.id,
        v_next_status,
        v_next_refunded,
        v_payment.currency;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_list_payments(TEXT, TEXT, TEXT, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_get_payment_detail(UUID) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_apply_payment_refund(UUID, NUMERIC, TEXT, TEXT) FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.admin_list_payments(TEXT, TEXT, TEXT, INTEGER) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_get_payment_detail(UUID) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_apply_payment_refund(UUID, NUMERIC, TEXT, TEXT) TO service_role;
