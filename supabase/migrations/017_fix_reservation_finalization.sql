-- ============================================
-- MIGRATION 017: RESERVATION FINALIZATION FIXES
-- Description: Fix reservation creation status/city_code and align lock handling
-- Version: 1.0
-- Date: 2026-02-16
-- Risk Level: HIGH - Booking correctness
-- ============================================

-- ============================================
-- SECTION 1: RESERVATION CREATION SAFETY FIXES
-- ============================================

CREATE OR REPLACE FUNCTION reserve.create_reservation_safe(
    p_booking_intent_id UUID,
    p_city_code VARCHAR(10),
    p_property_id UUID,
    p_unit_id UUID,
    p_rate_plan_id UUID,
    p_traveler_id UUID,
    p_check_in DATE,
    p_check_out DATE,
    p_guests_adults INT,
    p_guests_children INT,
    p_guests_infants INT,
    p_guest_first_name VARCHAR(100),
    p_guest_last_name VARCHAR(100),
    p_guest_email VARCHAR(255),
    p_guest_phone VARCHAR(50),
    p_total_amount NUMERIC,
    p_currency VARCHAR(3) DEFAULT 'BRL'
)
RETURNS TABLE (
    reservation_id UUID,
    confirmation_code VARCHAR(20),
    success BOOLEAN,
    error_message TEXT
) AS $$
DECLARE
    v_reservation_id UUID;
    v_confirmation_code VARCHAR(20);
    v_conflict RECORD;
    v_lock_acquired BOOLEAN;
    v_conflict_date DATE;
    v_conflict_type VARCHAR(20);
    v_lock_ids UUID[];
    v_intent RECORD;
    v_city_code VARCHAR(10);
    v_currency VARCHAR(3);
    v_subtotal NUMERIC(12,2);
    v_taxes NUMERIC(12,2);
    v_fees NUMERIC(12,2);
    v_discount NUMERIC(12,2);
    v_total NUMERIC(12,2);
BEGIN
    SELECT * INTO v_intent
    FROM reserve.booking_intents
    WHERE id = p_booking_intent_id;

    IF FOUND THEN
        v_city_code := COALESCE(p_city_code, v_intent.city_code);
        v_currency := COALESCE(v_intent.currency, p_currency, 'BRL');
        v_subtotal := v_intent.subtotal;
        v_taxes := v_intent.taxes;
        v_fees := v_intent.fees;
        v_discount := v_intent.discount_amount;
        v_total := COALESCE(v_intent.total_amount, p_total_amount);
    ELSE
        v_city_code := p_city_code;
        v_currency := COALESCE(p_currency, 'BRL');
        v_subtotal := NULL;
        v_taxes := NULL;
        v_fees := NULL;
        v_discount := NULL;
        v_total := p_total_amount;
    END IF;

    -- Check for existing confirmed reservation via booking_intents mapping
    SELECT converted_to_reservation_id INTO v_reservation_id
    FROM reserve.booking_intents
    WHERE id = p_booking_intent_id;

    IF v_reservation_id IS NOT NULL THEN
        SELECT confirmation_code INTO v_confirmation_code
        FROM reserve.reservations WHERE id = v_reservation_id;

        RETURN QUERY SELECT
            v_reservation_id,
            v_confirmation_code,
            true,
            'Reservation already exists'::TEXT;
        RETURN;
    END IF;

    -- Check for conflicting confirmed bookings
    SELECT r.id, r.confirmation_code INTO v_conflict
    FROM reserve.reservations r
    WHERE r.unit_id = p_unit_id
    AND r.status IN (
        'host_commit_pending',
        'confirmed',
        'checkin_pending',
        'checked_in',
        'checked_out',
        'completed'
    )
    AND (
        (p_check_in, p_check_out) OVERLAPS (r.check_in, r.check_out)
    )
    LIMIT 1;

    IF FOUND THEN
        RETURN QUERY SELECT
            NULL::UUID,
            NULL::VARCHAR,
            false,
            format('Date conflict with existing reservation %s', v_conflict.confirmation_code)::TEXT;
        RETURN;
    END IF;

    -- Acquire hard locks
    SELECT * INTO v_lock_acquired, v_conflict_date, v_conflict_type, v_lock_ids
    FROM reserve.acquire_booking_lock(
        p_unit_id,
        p_check_in,
        p_check_out,
        'reservation_' || p_booking_intent_id::text,
        'confirmed',
        p_booking_intent_id,
        v_city_code,
        1440  -- 24 hours
    );

    IF NOT v_lock_acquired THEN
        RETURN QUERY SELECT
            NULL::UUID,
            NULL::VARCHAR,
            false,
            format('Unable to acquire locks - conflict on %s (%s)', v_conflict_date, v_conflict_type)::TEXT;
        RETURN;
    END IF;

    -- Generate confirmation code
    v_confirmation_code := 'RES-' || TO_CHAR(NOW(), 'YYYY') || '-' ||
                          UPPER(SUBSTRING(MD5(RANDOM()::text), 1, 6));

    -- Create reservation
    INSERT INTO reserve.reservations (
        confirmation_code,
        booking_intent_id,
        city_code,
        property_id,
        unit_id,
        rate_plan_id,
        traveler_id,
        check_in,
        check_out,
        nights,
        guests_adults,
        guests_children,
        guests_infants,
        guest_first_name,
        guest_last_name,
        guest_email,
        guest_phone,
        status,
        payment_status,
        currency,
        subtotal,
        taxes,
        fees,
        discount_amount,
        total_amount,
        amount_paid,
        source,
        metadata,
        booked_at,
        created_at,
        updated_at
    ) VALUES (
        v_confirmation_code,
        p_booking_intent_id,
        v_city_code,
        p_property_id,
        p_unit_id,
        p_rate_plan_id,
        p_traveler_id,
        p_check_in,
        p_check_out,
        (p_check_out - p_check_in),
        p_guests_adults,
        p_guests_children,
        p_guests_infants,
        p_guest_first_name,
        p_guest_last_name,
        p_guest_email,
        p_guest_phone,
        'host_commit_pending',
        'paid',
        v_currency,
        v_subtotal,
        v_taxes,
        v_fees,
        v_discount,
        v_total,
        v_total,
        'reserve_connect',
        jsonb_build_object('booking_intent_id', p_booking_intent_id, 'city_code', v_city_code),
        NOW(),
        NOW(),
        NOW()
    )
    RETURNING id INTO v_reservation_id;

    -- Update booking locks with reservation_id
    UPDATE reserve.booking_locks
    SET reservation_id = v_reservation_id
    WHERE booking_intent_id = p_booking_intent_id;

    -- Update availability calendar (confirm booking, release soft holds)
    UPDATE reserve.availability_calendar
    SET
        bookings_count = bookings_count + 1,
        temp_holds = GREATEST(temp_holds - 1, 0),
        is_available = CASE
            WHEN (bookings_count + 1 + GREATEST(temp_holds - 1, 0)) >= allotment THEN false
            ELSE true
        END,
        updated_at = NOW()
    WHERE unit_id = p_unit_id
    AND date >= p_check_in
    AND date < p_check_out;

    -- Update booking intent mapping
    UPDATE reserve.booking_intents
    SET status = 'converted',
        converted_to_reservation_id = v_reservation_id,
        converted_at = NOW(),
        updated_at = NOW()
    WHERE id = p_booking_intent_id;

    RETURN QUERY SELECT v_reservation_id, v_confirmation_code, true, NULL::TEXT;

EXCEPTION
    WHEN unique_violation THEN
        -- Another transaction created the reservation
        SELECT r.id, r.confirmation_code INTO v_reservation_id, v_confirmation_code
        FROM reserve.booking_intents bi
        JOIN reserve.reservations r ON r.id = bi.converted_to_reservation_id
        WHERE bi.id = p_booking_intent_id;

        RETURN QUERY SELECT
            v_reservation_id,
            v_confirmation_code,
            true,
            'Reservation created by concurrent transaction'::TEXT;
    WHEN OTHERS THEN
        RETURN QUERY SELECT NULL::UUID, NULL::VARCHAR, false, SQLERRM::TEXT;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.create_reservation_safe IS 'Creates reservation with booking locks and correct state initialization';

-- ============================================
-- SECTION 2: FINALIZE RESERVATION FUNCTION
-- ============================================

CREATE OR REPLACE FUNCTION reserve.finalize_reservation(
    p_payment_id UUID,
    p_webhook_id UUID DEFAULT NULL
)
RETURNS TABLE (
    reservation_id UUID,
    success BOOLEAN,
    error_message TEXT
) AS $$
DECLARE
    v_payment RECORD;
    v_intent RECORD;
    v_existing_reservation UUID;
    v_result RECORD;
BEGIN
    SELECT * INTO v_payment
    FROM reserve.payments
    WHERE id = p_payment_id;

    IF v_payment IS NULL THEN
        RETURN QUERY SELECT NULL::UUID, false, 'Payment not found'::TEXT;
        RETURN;
    END IF;

    IF v_payment.status != 'succeeded' THEN
        RETURN QUERY SELECT NULL::UUID, false,
            format('Payment status is %s (expected succeeded)', v_payment.status)::TEXT;
        RETURN;
    END IF;

    SELECT * INTO v_intent
    FROM reserve.booking_intents
    WHERE id = v_payment.booking_intent_id;

    IF v_intent IS NULL THEN
        RETURN QUERY SELECT NULL::UUID, false, 'Booking intent not found'::TEXT;
        RETURN;
    END IF;

    SELECT converted_to_reservation_id INTO v_existing_reservation
    FROM reserve.booking_intents
    WHERE id = v_payment.booking_intent_id;

    IF v_existing_reservation IS NOT NULL THEN
        UPDATE reserve.payments
        SET reservation_id = v_existing_reservation,
            updated_at = NOW()
        WHERE id = v_payment.id
        AND reservation_id IS NULL;

        IF p_webhook_id IS NOT NULL THEN
            UPDATE reserve.processed_webhooks
            SET reservation_id = v_existing_reservation,
                status = 'completed',
                processed_at = NOW()
            WHERE id = p_webhook_id;
        END IF;

        RETURN QUERY SELECT v_existing_reservation, true, 'Reservation already exists'::TEXT;
        RETURN;
    END IF;

    IF v_intent.status != 'payment_confirmed' THEN
        RETURN QUERY SELECT NULL::UUID, false,
            format('Invalid intent status: %s (expected payment_confirmed)', v_intent.status)::TEXT;
        RETURN;
    END IF;

    SELECT * INTO v_result
    FROM reserve.create_reservation_safe(
        v_intent.id,
        v_intent.city_code,
        v_intent.property_id,
        v_intent.unit_id,
        v_intent.rate_plan_id,
        v_intent.traveler_id,
        v_intent.check_in,
        v_intent.check_out,
        v_intent.guests_adults,
        v_intent.guests_children,
        v_intent.guests_infants,
        v_intent.guest_first_name,
        v_intent.guest_last_name,
        v_intent.guest_email,
        v_intent.guest_phone,
        v_intent.total_amount,
        v_intent.currency
    );

    IF v_result.success IS NOT TRUE THEN
        RETURN QUERY SELECT NULL::UUID, false, v_result.error_message::TEXT;
        RETURN;
    END IF;

    UPDATE reserve.payments
    SET reservation_id = v_result.reservation_id,
        updated_at = NOW()
    WHERE id = v_payment.id;

    IF p_webhook_id IS NOT NULL THEN
        UPDATE reserve.processed_webhooks
        SET reservation_id = v_result.reservation_id,
            status = 'completed',
            processed_at = NOW()
        WHERE id = p_webhook_id;
    END IF;

    RETURN QUERY SELECT v_result.reservation_id, true, NULL::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RETURN QUERY SELECT NULL::UUID, false, SQLERRM::TEXT;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.finalize_reservation IS 'Finalizes booking intent into reservation with correct status and city scope';

-- ============================================
-- VERIFICATION
-- ============================================

SELECT
    'Reservation Finalization Fixes' as migration,
    '017_fix_reservation_finalization.sql' as file,
    NOW() as executed_at;

SELECT
    proname as function_name,
    pg_get_function_result(p.oid) as result_type
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'reserve'
AND proname IN ('create_reservation_safe', 'finalize_reservation');

-- ============================================
-- ROLLBACK INSTRUCTIONS
-- ============================================
/*
To rollback this migration:

1. Revert function definitions to the previous version from migration 014/015.
2. Verify booking flows in staging before production rollback.

WARNING: Rolling back these functions reintroduces invalid reservation status handling.
*/
