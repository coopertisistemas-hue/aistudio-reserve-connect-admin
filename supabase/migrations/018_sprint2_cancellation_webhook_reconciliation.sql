-- ============================================
-- MIGRATION 018: CANCELLATION + HOST WEBHOOK + RECONCILIATION
-- Description: Adds cancellation requests, webhook tracking updates, reconciliation runs
-- Version: 1.0
-- Date: 2026-02-16
-- Risk Level: HIGH - Booking and ops integrity
-- ============================================

-- ============================================
-- SECTION 1: CANCELLATION REQUESTS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.cancellation_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES reserve.reservations(id) ON DELETE CASCADE,
    request_id VARCHAR(100),
    idempotency_key VARCHAR(150) NOT NULL,
    status VARCHAR(20) DEFAULT 'processing' CHECK (status IN ('processing', 'completed', 'failed')),
    refund_status VARCHAR(20) DEFAULT 'pending' CHECK (refund_status IN ('pending', 'processing', 'completed', 'failed', 'not_required')),
    refund_amount NUMERIC(12,2) DEFAULT 0,
    refund_provider VARCHAR(50),
    payment_id UUID REFERENCES reserve.payments(id),
    error_message TEXT,
    response_payload JSONB DEFAULT '{}',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(idempotency_key)
);

CREATE INDEX IF NOT EXISTS idx_cancellation_requests_reservation
ON reserve.cancellation_requests(reservation_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_cancellation_requests_status
ON reserve.cancellation_requests(status, created_at);

ALTER TABLE reserve.cancellation_requests ENABLE ROW LEVEL SECURITY;
CREATE POLICY IF NOT EXISTS cancellation_requests_service_all
ON reserve.cancellation_requests FOR ALL TO service_role USING (true);

-- ============================================
-- SECTION 2: HOST WEBHOOK EVENTS EXTENSIONS
-- ============================================

ALTER TABLE reserve.host_webhook_events
    ADD COLUMN IF NOT EXISTS attempt_count INTEGER DEFAULT 0,
    ADD COLUMN IF NOT EXISTS last_attempt_at TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS idx_host_webhook_events_status_created
ON reserve.host_webhook_events(status, created_at DESC);

-- ============================================
-- SECTION 3: RECONCILIATION RUNS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.reconciliation_runs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    run_id VARCHAR(100) UNIQUE NOT NULL,
    status VARCHAR(20) DEFAULT 'running' CHECK (status IN ('running', 'completed', 'failed')),
    summary JSONB DEFAULT '{}',
    started_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_reconciliation_runs_created_at
ON reserve.reconciliation_runs(created_at DESC);

ALTER TABLE reserve.reconciliation_runs ENABLE ROW LEVEL SECURITY;
CREATE POLICY IF NOT EXISTS reconciliation_runs_service_all
ON reserve.reconciliation_runs FOR ALL TO service_role USING (true);

-- ============================================
-- SECTION 4: INVENTORY RELEASE HELPER
-- ============================================

CREATE OR REPLACE FUNCTION reserve.release_reservation_inventory(
    p_reservation_id UUID
)
RETURNS TABLE (
    availability_rows INTEGER,
    locks_released INTEGER
) AS $$
DECLARE
    v_reservation RECORD;
    v_rows INTEGER := 0;
    v_locks INTEGER := 0;
BEGIN
    SELECT id, unit_id, rate_plan_id, check_in, check_out
    INTO v_reservation
    FROM reserve.reservations
    WHERE id = p_reservation_id;

    IF NOT FOUND THEN
        RETURN QUERY SELECT 0, 0;
        RETURN;
    END IF;

    UPDATE reserve.availability_calendar
    SET
        bookings_count = GREATEST(bookings_count - 1, 0),
        is_available = CASE
            WHEN is_blocked THEN false
            WHEN GREATEST(bookings_count - 1, 0) < allotment THEN true
            ELSE false
        END,
        updated_at = NOW()
    WHERE unit_id = v_reservation.unit_id
      AND date >= v_reservation.check_in
      AND date < v_reservation.check_out
      AND (v_reservation.rate_plan_id IS NULL OR rate_plan_id = v_reservation.rate_plan_id);

    GET DIAGNOSTICS v_rows = ROW_COUNT;

    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'reserve'
          AND table_name = 'booking_locks'
    ) THEN
        DELETE FROM reserve.booking_locks
        WHERE reservation_id = p_reservation_id;

        GET DIAGNOSTICS v_locks = ROW_COUNT;
    END IF;

    RETURN QUERY SELECT v_rows, v_locks;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.release_reservation_inventory IS 'Releases availability and booking locks for a cancelled reservation';

-- ============================================
-- VERIFICATION
-- ============================================

SELECT
    'Sprint 2 Migration Applied' AS status,
    NOW() AS executed_at;
