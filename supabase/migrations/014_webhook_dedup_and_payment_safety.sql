-- ============================================
-- MIGRATION 014: WEBHOOK DEDUPLICATION & PAYMENT SAFETY
-- Description: Implement webhook deduplication and payment state machine safety
-- Version: 1.0
-- Date: 2026-02-16
-- Risk Level: CRITICAL - Financial correctness
-- ============================================

-- ============================================
-- SECTION 1: PROCESSED WEBHOOKS TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.processed_webhooks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider VARCHAR(50) NOT NULL,  -- 'stripe', 'mercadopago', 'openpix', 'asaas'
    event_id VARCHAR(255) NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    received_at TIMESTAMPTZ DEFAULT NOW(),
    processed_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'duplicate')),
    payment_id UUID REFERENCES reserve.payments(id) ON DELETE SET NULL,
    reservation_id UUID REFERENCES reserve.reservations(id) ON DELETE SET NULL,
    payload_hash TEXT,  -- Hash of payload for integrity checking
    error_message TEXT,
    retry_count INT DEFAULT 0,
    processed_by VARCHAR(255),
    UNIQUE(provider, event_id)  -- Prevent duplicate processing
);

-- Indexes for efficient lookups
CREATE INDEX IF NOT EXISTS idx_processed_webhooks_provider_event 
ON reserve.processed_webhooks(provider, event_id);

CREATE INDEX IF NOT EXISTS idx_processed_webhooks_payment 
ON reserve.processed_webhooks(payment_id) WHERE payment_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_processed_webhooks_status 
ON reserve.processed_webhooks(status, received_at) WHERE status IN ('pending', 'failed');

CREATE INDEX IF NOT EXISTS idx_processed_webhooks_received_at 
ON reserve.processed_webhooks(received_at DESC);

COMMENT ON TABLE reserve.processed_webhooks IS 'Tracks all processed webhooks for deduplication and audit trail';

-- ============================================
-- SECTION 2: WEBHOOK DEDUPLICATION FUNCTION
-- ============================================

CREATE OR REPLACE FUNCTION reserve.check_webhook_duplicate(
    p_provider VARCHAR(50),
    p_event_id VARCHAR(255)
)
RETURNS TABLE (
    is_duplicate BOOLEAN,
    existing_status VARCHAR(20),
    processed_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        true as is_duplicate,
        pw.status as existing_status,
        pw.processed_at
    FROM reserve.processed_webhooks pw
    WHERE pw.provider = p_provider
    AND pw.event_id = p_event_id
    AND pw.status IN ('completed', 'processing')
    LIMIT 1;
    
    -- If no rows returned, it's not a duplicate
    IF NOT FOUND THEN
        RETURN QUERY SELECT false, NULL::VARCHAR, NULL::TIMESTAMPTZ;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to record webhook processing start
CREATE OR REPLACE FUNCTION reserve.start_webhook_processing(
    p_provider VARCHAR(50),
    p_event_id VARCHAR(255),
    p_event_type VARCHAR(100),
    p_payload_hash TEXT
)
RETURNS UUID AS $$
DECLARE
    webhook_id UUID;
BEGIN
    INSERT INTO reserve.processed_webhooks (
        provider, event_id, event_type, payload_hash, status, received_at
    ) VALUES (
        p_provider, p_event_id, p_event_type, p_payload_hash, 'processing', NOW()
    )
    ON CONFLICT (provider, event_id) DO UPDATE SET
        retry_count = reserve.processed_webhooks.retry_count + 1,
        received_at = NOW(),
        status = 'processing'
    WHERE reserve.processed_webhooks.status IN ('failed', 'pending')
    RETURNING id INTO webhook_id;
    
    RETURN webhook_id;
EXCEPTION
    WHEN unique_violation THEN
        -- Already processed successfully
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Function to complete webhook processing
CREATE OR REPLACE FUNCTION reserve.complete_webhook_processing(
    p_webhook_id UUID,
    p_status VARCHAR(20),
    p_payment_id UUID DEFAULT NULL,
    p_reservation_id UUID DEFAULT NULL,
    p_error_message TEXT DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    UPDATE reserve.processed_webhooks
    SET 
        status = p_status,
        processed_at = NOW(),
        payment_id = COALESCE(p_payment_id, payment_id),
        reservation_id = COALESCE(p_reservation_id, reservation_id),
        error_message = p_error_message
    WHERE id = p_webhook_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- SECTION 3: PAYMENT STATE MACHINE CONSTRAINTS
-- ============================================

-- Add state machine validation to payments table
CREATE OR REPLACE FUNCTION reserve.validate_payment_state_transition()
RETURNS TRIGGER AS $$
DECLARE
    allowed_transitions JSONB;
    current_status VARCHAR(20);
BEGIN
    -- Define valid state transitions
    allowed_transitions := '{
        "pending": ["processing", "succeeded", "failed", "expired", "cancelled"],
        "processing": ["succeeded", "failed", "expired"],
        "succeeded": ["refunded", "partially_refunded", "disputed"],
        "failed": ["pending"],
        "expired": ["pending"],
        "refunded": [],
        "partially_refunded": ["refunded"],
        "disputed": ["succeeded", "refunded"],
        "cancelled": []
    }'::jsonb;
    
    -- Get current status
    IF TG_OP = 'UPDATE' THEN
        current_status := OLD.status;
        
        -- Allow same status (idempotent update)
        IF current_status = NEW.status THEN
            RETURN NEW;
        END IF;
        
        -- Check if transition is allowed
        IF NOT (allowed_transitions->current_status ? NEW.status) THEN
            RAISE EXCEPTION 'Invalid payment status transition: % -> %', 
                current_status, NEW.status
                USING HINT = 'Allowed transitions: ' || allowed_transitions->current_status;
        END IF;
        
        -- Additional validations
        IF NEW.status = 'succeeded' AND OLD.succeeded_at IS NULL THEN
            NEW.succeeded_at := NOW();
        END IF;
        
        IF NEW.status IN ('refunded', 'partially_refunded') AND OLD.refunded_at IS NULL THEN
            NEW.refunded_at := NOW();
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_payment_state_validation ON reserve.payments;
CREATE TRIGGER trg_payment_state_validation
    BEFORE UPDATE ON reserve.payments
    FOR EACH ROW
    EXECUTE FUNCTION reserve.validate_payment_state_transition();

COMMENT ON FUNCTION reserve.validate_payment_state_transition IS 'Enforces valid payment state transitions to prevent invalid status changes';

-- ============================================
-- SECTION 4: BOOKING INTENT STATE MACHINE
-- ============================================

CREATE OR REPLACE FUNCTION reserve.validate_intent_state_transition()
RETURNS TRIGGER AS $$
DECLARE
    allowed_transitions JSONB;
BEGIN
    -- Define valid intent state transitions
    allowed_transitions := '{
        "intent_created": ["payment_pending", "expired", "cancelled"],
        "payment_pending": ["payment_confirmed", "payment_failed", "expired", "cancelled"],
        "payment_confirmed": ["converted", "cancelled"],
        "payment_failed": ["payment_pending", "expired", "cancelled"],
        "converted": ["cancelled"],
        "expired": [],
        "cancelled": []
    }'::jsonb;
    
    IF TG_OP = 'UPDATE' THEN
        -- Allow same status
        IF OLD.status = NEW.status THEN
            RETURN NEW;
        END IF;
        
        -- Check transition validity
        IF NOT (allowed_transitions->OLD.status ? NEW.status) THEN
            RAISE EXCEPTION 'Invalid intent state transition: % -> %',
                OLD.status, NEW.status
                USING HINT = 'Allowed transitions: ' || allowed_transitions->OLD.status;
        END IF;
        
        -- Set timestamps
        IF NEW.status = 'payment_confirmed' AND OLD.payment_confirmed_at IS NULL THEN
            NEW.payment_confirmed_at := NOW();
        END IF;
        
        IF NEW.status = 'converted' AND OLD.converted_at IS NULL THEN
            NEW.converted_at := NOW();
        END IF;
        
        IF NEW.status = 'expired' AND OLD.expired_at IS NULL THEN
            NEW.expired_at := NOW();
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_intent_state_validation ON reserve.booking_intents;
CREATE TRIGGER trg_intent_state_validation
    BEFORE UPDATE ON reserve.booking_intents
    FOR EACH ROW
    EXECUTE FUNCTION reserve.validate_intent_state_transition();

-- ============================================
-- SECTION 5: IDEMPOTENCY ENFORCEMENT
-- ============================================

-- Ensure unique reservation linkage per booking intent
CREATE UNIQUE INDEX IF NOT EXISTS idx_booking_intents_unique_reservation 
ON reserve.booking_intents(converted_to_reservation_id) 
WHERE converted_to_reservation_id IS NOT NULL;

-- Ensure unique payment per intent + gateway + status combination
CREATE UNIQUE INDEX IF NOT EXISTS idx_payments_unique_intent_gateway 
ON reserve.payments(booking_intent_id, gateway, payment_method) 
WHERE status IN ('pending', 'processing');

-- Function to safely create or update payment (idempotent)
CREATE OR REPLACE FUNCTION reserve.upsert_payment(
    p_intent_id UUID,
    p_city_code VARCHAR(10),
    p_payment_method VARCHAR(50),
    p_gateway VARCHAR(50),
    p_gateway_payment_id VARCHAR(255),
    p_amount NUMERIC,
    p_currency VARCHAR(3),
    p_idempotency_key VARCHAR(100),
    p_metadata JSONB DEFAULT '{}'::jsonb
)
RETURNS TABLE (
    payment_id UUID,
    is_new BOOLEAN,
    existing_status VARCHAR(20)
) AS $$
DECLARE
    v_payment_id UUID;
    v_is_new BOOLEAN := false;
    v_existing_status VARCHAR(20);
BEGIN
    -- Try to find existing payment
    SELECT id, status INTO v_payment_id, v_existing_status
    FROM reserve.payments
    WHERE booking_intent_id = p_intent_id
    AND gateway = p_gateway
    AND payment_method = p_payment_method
    AND status IN ('pending', 'processing');
    
    IF v_payment_id IS NOT NULL THEN
        -- Return existing payment
        RETURN QUERY SELECT v_payment_id, false, v_existing_status;
        RETURN;
    END IF;
    
    -- Check idempotency key
    SELECT id, status INTO v_payment_id, v_existing_status
    FROM reserve.payments
    WHERE idempotency_key = p_idempotency_key;
    
    IF v_payment_id IS NOT NULL THEN
        RETURN QUERY SELECT v_payment_id, false, v_existing_status;
        RETURN;
    END IF;
    
    -- Create new payment
    INSERT INTO reserve.payments (
        booking_intent_id,
        city_code,
        payment_method,
        gateway,
        gateway_payment_id,
        amount,
        currency,
        status,
        idempotency_key,
        metadata
    ) VALUES (
        p_intent_id,
        p_city_code,
        p_payment_method,
        p_gateway,
        p_gateway_payment_id,
        p_amount,
        p_currency,
        'pending',
        p_idempotency_key,
        p_metadata
    )
    RETURNING id INTO v_payment_id;
    
    RETURN QUERY SELECT v_payment_id, true, 'pending'::VARCHAR;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.upsert_payment IS 'Idempotent payment creation - returns existing payment if duplicate detected';

-- ============================================
-- SECTION 6: FINALIZE RESERVATION SAFETY
-- ============================================

-- Function to safely finalize reservation after payment (prevents double-booking)
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
    v_reservation_id UUID;
    v_webhook_provider VARCHAR(50);
    v_existing_reservation UUID;
BEGIN
    -- Get payment details
    SELECT * INTO v_payment
    FROM reserve.payments
    WHERE id = p_payment_id;
    
    IF v_payment IS NULL THEN
        RETURN QUERY SELECT NULL::UUID, false, 'Payment not found'::TEXT;
        RETURN;
    END IF;
    
    -- Check if reservation already exists
    SELECT converted_to_reservation_id INTO v_existing_reservation
    FROM reserve.booking_intents
    WHERE id = v_payment.booking_intent_id;
    
    IF v_existing_reservation IS NOT NULL THEN
        -- Already finalized
        IF p_webhook_id IS NOT NULL THEN
            UPDATE reserve.processed_webhooks
            SET reservation_id = v_existing_reservation,
                status = 'completed'
            WHERE id = p_webhook_id;
        END IF;
        
        RETURN QUERY SELECT v_existing_reservation, true, 'Reservation already exists'::TEXT;
        RETURN;
    END IF;
    
    -- Get intent details
    SELECT * INTO v_intent
    FROM reserve.booking_intents
    WHERE id = v_payment.booking_intent_id;
    
    IF v_intent IS NULL THEN
        RETURN QUERY SELECT NULL::UUID, false, 'Booking intent not found'::TEXT;
        RETURN;
    END IF;
    
    -- Check intent status
    IF v_intent.status != 'payment_confirmed' THEN
        RETURN QUERY SELECT NULL::UUID, false, 
            format('Invalid intent status: %s (expected payment_confirmed)', v_intent.status)::TEXT;
        RETURN;
    END IF;
    
    -- Create reservation
    INSERT INTO reserve.reservations (
        confirmation_code,
        traveler_id,
        property_id,
        unit_id,
        rate_plan_id,
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
        booked_at
    ) VALUES (
        'RES-' || TO_CHAR(NOW(), 'YYYY') || '-' || UPPER(SUBSTRING(MD5(RANDOM()::text), 1, 6)),
        v_intent.traveler_id,
        v_intent.property_id,
        v_intent.unit_id,
        v_intent.rate_plan_id,
        v_intent.check_in,
        v_intent.check_out,
        v_intent.nights,
        v_intent.guests_adults,
        v_intent.guests_children,
        v_intent.guests_infants,
        v_intent.guest_first_name,
        v_intent.guest_last_name,
        v_intent.guest_email,
        v_intent.guest_phone,
        'pending',
        'paid',
        v_payment.currency,
        v_intent.subtotal,
        v_intent.taxes,
        v_intent.fees,
        v_intent.discount_amount,
        v_payment.amount,
        v_payment.amount,
        v_payment.gateway,
        jsonb_build_object('booking_intent_id', v_intent.id, 'payment_id', v_payment.id),
        NOW()
    )
    RETURNING id INTO v_reservation_id;
    
    -- Update intent status
    UPDATE reserve.booking_intents
    SET status = 'converted',
        converted_at = NOW(),
        converted_to_reservation_id = v_reservation_id,
        updated_at = NOW()
    WHERE id = v_intent.id;
    
    -- Update webhook record
    IF p_webhook_id IS NOT NULL THEN
        UPDATE reserve.processed_webhooks
        SET reservation_id = v_reservation_id,
            status = 'completed',
            processed_at = NOW()
        WHERE id = p_webhook_id;
    END IF;
    
    RETURN QUERY SELECT v_reservation_id, true, NULL::TEXT;
    
EXCEPTION
    WHEN unique_violation THEN
        -- Another transaction created the reservation
        SELECT converted_to_reservation_id INTO v_reservation_id
        FROM reserve.booking_intents
        WHERE id = v_payment.booking_intent_id;
        
        RETURN QUERY SELECT v_reservation_id, true, 'Reservation created by concurrent transaction'::TEXT;
    WHEN OTHERS THEN
        RETURN QUERY SELECT NULL::UUID, false, SQLERRM::TEXT;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.finalize_reservation IS 'Safely creates reservation from confirmed payment with duplicate protection';

-- ============================================
-- SECTION 7: WEBHOOK MONITORING
-- ============================================

-- View for webhook monitoring
CREATE OR REPLACE VIEW reserve.webhook_status AS
SELECT 
    provider,
    event_type,
    status,
    COUNT(*) as count,
    MIN(received_at) as oldest_pending,
    MAX(received_at) as most_recent
FROM reserve.processed_webhooks
WHERE received_at > NOW() - INTERVAL '24 hours'
GROUP BY provider, event_type, status
ORDER BY provider, event_type, status;

-- Function to get stuck webhooks (failed or pending too long)
CREATE OR REPLACE FUNCTION reserve.get_stuck_webhooks(
    p_max_age_minutes INT DEFAULT 30
)
RETURNS TABLE (
    webhook_id UUID,
    provider VARCHAR,
    event_id VARCHAR,
    event_type VARCHAR,
    status VARCHAR,
    received_at TIMESTAMPTZ,
    age_minutes NUMERIC,
    retry_count INT,
    error_message TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pw.id,
        pw.provider,
        pw.event_id,
        pw.event_type,
        pw.status,
        pw.received_at,
        EXTRACT(EPOCH FROM (NOW() - pw.received_at)) / 60 as age_minutes,
        pw.retry_count,
        pw.error_message
    FROM reserve.processed_webhooks pw
    WHERE pw.status IN ('failed', 'pending')
    AND pw.received_at < NOW() - INTERVAL '1 minute' * p_max_age_minutes
    ORDER BY pw.received_at ASC;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- SECTION 8: PAYMENT RECONCILIATION SUPPORT
-- ============================================

-- Table for reconciliation tracking
CREATE TABLE IF NOT EXISTS reserve.payment_reconciliation_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_id UUID NOT NULL REFERENCES reserve.payments(id) ON DELETE CASCADE,
    provider VARCHAR(50) NOT NULL,
    provider_payment_id VARCHAR(255),
    local_status VARCHAR(20),
    provider_status VARCHAR(20),
    mismatch BOOLEAN DEFAULT false,
    reconciled_at TIMESTAMPTZ DEFAULT NOW(),
    action_taken VARCHAR(100),
    details JSONB
);

CREATE INDEX IF NOT EXISTS idx_reconciliation_payment 
ON reserve.payment_reconciliation_log(payment_id);

CREATE INDEX IF NOT EXISTS idx_reconciliation_mismatch 
ON reserve.payment_reconciliation_log(mismatch, reconciled_at) 
WHERE mismatch = true;

-- Function to log reconciliation check
CREATE OR REPLACE FUNCTION reserve.log_reconciliation_check(
    p_payment_id UUID,
    p_provider VARCHAR(50),
    p_provider_payment_id VARCHAR(255),
    p_local_status VARCHAR(20),
    p_provider_status VARCHAR(20),
    p_action_taken VARCHAR(100) DEFAULT NULL,
    p_details JSONB DEFAULT '{}'::jsonb
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO reserve.payment_reconciliation_log (
        payment_id,
        provider,
        provider_payment_id,
        local_status,
        provider_status,
        mismatch,
        action_taken,
        details
    ) VALUES (
        p_payment_id,
        p_provider,
        p_provider_payment_id,
        p_local_status,
        p_provider_status,
        p_local_status != p_provider_status,
        p_action_taken,
        p_details
    );
END;
$$ LANGUAGE plpgsql;

-- View for mismatched payments requiring attention
CREATE OR REPLACE VIEW reserve.payments_needing_reconciliation AS
SELECT 
    p.id as payment_id,
    p.booking_intent_id,
    p.gateway,
    p.gateway_payment_id,
    p.status as local_status,
    p.amount,
    p.currency,
    p.created_at,
    p.succeeded_at,
    prl.provider_status as last_seen_provider_status,
    prl.reconciled_at as last_reconciliation_check
FROM reserve.payments p
LEFT JOIN LATERAL (
    SELECT provider_status, reconciled_at
    FROM reserve.payment_reconciliation_log
    WHERE payment_id = p.id
    ORDER BY reconciled_at DESC
    LIMIT 1
) prl ON true
WHERE p.status IN ('pending', 'processing')
AND p.created_at < NOW() - INTERVAL '1 hour'
ORDER BY p.created_at ASC;

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 
    'Webhook Deduplication & Payment Safety Migration' as migration,
    '014_webhook_dedup_and_payment_safety.sql' as file,
    'COMPLETED' as status,
    NOW() as executed_at;

-- Show processed_webhooks table structure
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'processed_webhooks'
AND table_schema = 'reserve'
ORDER BY ordinal_position;

-- Show triggers created
SELECT 
    tgname as trigger_name,
    tgrelid::regclass as table_name,
    CASE WHEN tgenabled = 'O' THEN 'ENABLED' ELSE 'DISABLED' END as status
FROM pg_trigger
WHERE tgname IN ('trg_payment_state_validation', 'trg_intent_state_validation');

-- Show unique constraints for idempotency
SELECT 
    indexname,
    tablename,
    indexdef
FROM pg_indexes
WHERE schemaname = 'reserve'
AND indexname IN ('idx_booking_intents_unique_reservation', 'idx_payments_unique_intent_gateway');

-- ============================================
-- ROLLBACK INSTRUCTIONS
-- ============================================
/*
To rollback this migration:

1. Drop tables:
   DROP TABLE IF EXISTS reserve.processed_webhooks CASCADE;
   DROP TABLE IF EXISTS reserve.payment_reconciliation_log CASCADE;

2. Drop triggers:
   DROP TRIGGER IF EXISTS trg_payment_state_validation ON reserve.payments;
   DROP TRIGGER IF EXISTS trg_intg_intent_state_validation ON reserve.booking_intents;

3. Drop functions:
   DROP FUNCTION IF EXISTS reserve.check_webhook_duplicate(VARCHAR, VARCHAR);
   DROP FUNCTION IF EXISTS reserve.start_webhook_processing(VARCHAR, VARCHAR, VARCHAR, TEXT);
   DROP FUNCTION IF EXISTS reserve.complete_webhook_processing(UUID, VARCHAR, UUID, UUID, TEXT);
   DROP FUNCTION IF EXISTS reserve.validate_payment_state_transition();
   DROP FUNCTION IF EXISTS reserve.validate_intent_state_transition();
   DROP FUNCTION IF EXISTS reserve.upsert_payment(UUID, VARCHAR, VARCHAR, VARCHAR, VARCHAR, NUMERIC, VARCHAR, VARCHAR, JSONB);
   DROP FUNCTION IF EXISTS reserve.finalize_reservation(UUID, UUID);
   DROP FUNCTION IF EXISTS reserve.get_stuck_webhooks(INT);
   DROP FUNCTION IF EXISTS reserve.log_reconciliation_check(UUID, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, JSONB);

4. Drop indexes:
   DROP INDEX IF EXISTS reserve.idx_reservations_unique_intent;
   DROP INDEX IF EXISTS reserve.idx_payments_unique_intent_gateway;

5. Drop views:
   DROP VIEW IF EXISTS reserve.webhook_status;
   DROP VIEW IF EXISTS reserve.payments_needing_reconciliation;

WARNING: This removes all webhook deduplication and state machine protections!
Existing processed_webhooks data will be lost.
*/
