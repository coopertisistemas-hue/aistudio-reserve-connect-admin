-- ============================================
-- MIGRATION 015: CONCURRENCY & BOOKING INTEGRITY
-- Description: Implement database-level locking and constraints to prevent double-booking
-- Version: 1.0
-- Date: 2026-02-16
-- Risk Level: CRITICAL - Prevents overbooking
-- ============================================

-- ============================================
-- SECTION 1: BOOKING LOCKS TABLE
-- ============================================

-- Table to track active booking locks
CREATE TABLE IF NOT EXISTS reserve.booking_locks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    unit_id UUID NOT NULL REFERENCES reserve.unit_map(id) ON DELETE CASCADE,
    lock_date DATE NOT NULL,
    lock_type VARCHAR(20) NOT NULL CHECK (lock_type IN ('soft_hold', 'hard_hold', 'confirmed')),
    session_id VARCHAR(100) NOT NULL,
    booking_intent_id UUID REFERENCES reserve.booking_intents(id) ON DELETE CASCADE,
    reservation_id UUID REFERENCES reserve.reservations(id) ON DELETE CASCADE,
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    city_code VARCHAR(10),
    UNIQUE(unit_id, lock_date, lock_type)  -- Prevent duplicate locks
);

-- Indexes for efficient lock lookups
CREATE INDEX IF NOT EXISTS idx_booking_locks_unit_date 
ON reserve.booking_locks(unit_id, lock_date);

CREATE INDEX IF NOT EXISTS idx_booking_locks_session 
ON reserve.booking_locks(session_id);

CREATE INDEX IF NOT EXISTS idx_booking_locks_expires 
ON reserve.booking_locks(expires_at);

CREATE INDEX IF NOT EXISTS idx_booking_locks_intent 
ON reserve.booking_locks(booking_intent_id) WHERE booking_intent_id IS NOT NULL;

COMMENT ON TABLE reserve.booking_locks IS 'Tracks all active booking locks to prevent double-booking at database level';

-- ============================================
-- SECTION 2: LOCK MANAGEMENT FUNCTIONS
-- ============================================

-- Function to acquire booking locks
CREATE OR REPLACE FUNCTION reserve.acquire_booking_lock(
    p_unit_id UUID,
    p_check_in DATE,
    p_check_out DATE,
    p_session_id VARCHAR(100),
    p_lock_type VARCHAR(20) DEFAULT 'soft_hold',
    p_booking_intent_id UUID DEFAULT NULL,
    p_city_code VARCHAR(10) DEFAULT NULL,
    p_ttl_minutes INT DEFAULT 15
)
RETURNS TABLE (
    success BOOLEAN,
    conflict_date DATE,
    conflict_type VARCHAR(20),
    lock_ids UUID[]
) AS $$
DECLARE
    v_date DATE;
    v_lock_id UUID;
    v_lock_ids UUID[] := ARRAY[]::UUID[];
    v_expires_at TIMESTAMPTZ;
    v_conflict RECORD;
BEGIN
    v_expires_at := NOW() + INTERVAL '1 minute' * p_ttl_minutes;
    
    -- First, check for existing conflicting locks
    FOR v_date IN 
        SELECT generate_series(p_check_in, p_check_out - INTERVAL '1 day', INTERVAL '1 day')::date
    LOOP
        -- Check for hard locks (confirmed bookings)
        SELECT * INTO v_conflict
        FROM reserve.booking_locks
        WHERE unit_id = p_unit_id
        AND lock_date = v_date
        AND lock_type = 'confirmed'
        AND (expires_at > NOW() OR expires_at IS NULL);
        
        IF FOUND THEN
            RETURN QUERY SELECT false, v_date, 'confirmed'::VARCHAR, NULL::UUID[];
            RETURN;
        END IF;
        
        -- Check for other hard holds from different sessions
        IF p_lock_type IN ('hard_hold', 'confirmed') THEN
            SELECT * INTO v_conflict
            FROM reserve.booking_locks
            WHERE unit_id = p_unit_id
            AND lock_date = v_date
            AND lock_type = 'hard_hold'
            AND session_id != p_session_id
            AND expires_at > NOW();
            
            IF FOUND THEN
                RETURN QUERY SELECT false, v_date, 'hard_hold'::VARCHAR, NULL::UUID[];
                RETURN;
            END IF;
        END IF;
    END LOOP;
    
    -- Clean up expired locks before acquiring new ones
    DELETE FROM reserve.booking_locks
    WHERE unit_id = p_unit_id
    AND lock_date BETWEEN p_check_in AND p_check_out - INTERVAL '1 day'
    AND expires_at < NOW();
    
    -- Acquire locks for each date
    FOR v_date IN 
        SELECT generate_series(p_check_in, p_check_out - INTERVAL '1 day', INTERVAL '1 day')::date
    LOOP
        INSERT INTO reserve.booking_locks (
            unit_id,
            lock_date,
            lock_type,
            session_id,
            booking_intent_id,
            city_code,
            expires_at
        ) VALUES (
            p_unit_id,
            v_date,
            p_lock_type,
            p_session_id,
            p_booking_intent_id,
            p_city_code,
            v_expires_at
        )
        ON CONFLICT (unit_id, lock_date, lock_type) DO UPDATE SET
            session_id = EXCLUDED.session_id,
            booking_intent_id = EXCLUDED.booking_intent_id,
            expires_at = EXCLUDED.expires_at,
            created_at = NOW()
        WHERE reserve.booking_locks.expires_at < NOW()
        RETURNING id INTO v_lock_id;
        
        IF v_lock_id IS NOT NULL THEN
            v_lock_ids := array_append(v_lock_ids, v_lock_id);
        END IF;
    END LOOP;
    
    IF array_length(v_lock_ids, 1) > 0 THEN
        RETURN QUERY SELECT true, NULL::DATE, NULL::VARCHAR, v_lock_ids;
    ELSE
        RETURN QUERY SELECT false, p_check_in, 'unknown'::VARCHAR, NULL::UUID[];
    END IF;
    
EXCEPTION
    WHEN unique_violation THEN
        -- Another transaction acquired the lock
        RETURN QUERY SELECT false, p_check_in, 'concurrent_lock'::VARCHAR, NULL::UUID[];
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.acquire_booking_lock IS 'Atomically acquires booking locks for a date range. Returns success=false if conflicts detected.';

-- Function to release booking locks
CREATE OR REPLACE FUNCTION reserve.release_booking_lock(
    p_session_id VARCHAR(100),
    p_booking_intent_id UUID DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
    v_deleted_count INT;
BEGIN
    IF p_booking_intent_id IS NOT NULL THEN
        DELETE FROM reserve.booking_locks
        WHERE booking_intent_id = p_booking_intent_id;
    ELSE
        DELETE FROM reserve.booking_locks
        WHERE session_id = p_session_id;
    END IF;
    
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    RETURN v_deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to extend lock TTL
CREATE OR REPLACE FUNCTION reserve.extend_booking_lock(
    p_booking_intent_id UUID,
    p_additional_minutes INT DEFAULT 15
)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE reserve.booking_locks
    SET expires_at = expires_at + INTERVAL '1 minute' * p_additional_minutes
    WHERE booking_intent_id = p_booking_intent_id
    AND expires_at > NOW();
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- SECTION 3: CLEANUP EXPIRED LOCKS
-- ============================================

-- Function to clean up expired locks
CREATE OR REPLACE FUNCTION reserve.cleanup_expired_locks()
RETURNS INTEGER AS $$
DECLARE
    v_deleted_count INT;
BEGIN
    DELETE FROM reserve.booking_locks
    WHERE expires_at < NOW();
    
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    
    IF v_deleted_count > 0 THEN
        RAISE NOTICE 'Cleaned up % expired booking locks', v_deleted_count;
    END IF;
    
    RETURN v_deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Create a scheduled job for lock cleanup (if pg_cron available)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_cron') THEN
        -- Schedule cleanup every 5 minutes
        PERFORM cron.schedule(
            'cleanup-expired-locks',
            '*/5 * * * *',
            'SELECT reserve.cleanup_expired_locks()'
        );
        RAISE NOTICE 'Scheduled lock cleanup job';
    ELSE
        RAISE NOTICE 'pg_cron not available - schedule cleanup via external cron';
    END IF;
END $$;

-- ============================================
-- SECTION 4: DOUBLE-BOOKING PREVENTION CONSTRAINTS
-- ============================================

-- Ensure availability calendar consistency
CREATE OR REPLACE FUNCTION reserve.check_availability_consistency()
RETURNS TRIGGER AS $$
DECLARE
    v_total_locks INT;
    v_confirmed_bookings INT;
BEGIN
    -- Count active locks for this date
    SELECT COUNT(*) INTO v_total_locks
    FROM reserve.booking_locks
    WHERE unit_id = NEW.unit_id
    AND lock_date = NEW.date
    AND lock_type IN ('hard_hold', 'confirmed')
    AND expires_at > NOW();
    
    -- Count confirmed bookings
    SELECT COUNT(*) INTO v_confirmed_bookings
    FROM reserve.reservations r
    WHERE r.unit_id = NEW.unit_id
    AND NEW.date BETWEEN r.check_in AND r.check_out - INTERVAL '1 day'
    AND r.status IN ('confirmed', 'checked_in');
    
    -- Verify that bookings_count matches reality
    IF NEW.bookings_count != v_confirmed_bookings THEN
        RAISE WARNING 'Bookings count mismatch for unit % on %: stored=%, actual=%',
            NEW.unit_id, NEW.date, NEW.bookings_count, v_confirmed_bookings;
        -- Auto-correct
        NEW.bookings_count := v_confirmed_bookings;
    END IF;
    
    -- Ensure we don't exceed allotment
    IF (NEW.bookings_count + NEW.temp_holds) > NEW.allotment AND NEW.is_available THEN
        RAISE WARNING 'Overbooking detected for unit % on %: bookings=%, holds=%, allotment=%',
            NEW.unit_id, NEW.date, NEW.bookings_count, NEW.temp_holds, NEW.allotment;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_availability_consistency ON reserve.availability_calendar;
CREATE TRIGGER trg_availability_consistency
    BEFORE INSERT OR UPDATE ON reserve.availability_calendar
    FOR EACH ROW
    EXECUTE FUNCTION reserve.check_availability_consistency();

-- ============================================
-- SECTION 5: RESERVATION CREATION SAFETY
-- ============================================

-- Enhanced reservation creation with conflict check
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
BEGIN
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
    AND r.status IN ('confirmed', 'checked_in', 'pending')
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
        p_city_code,
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
        created_at
    ) VALUES (
        v_confirmation_code,
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
        'pending',
        'paid',
        p_currency,
        NULL,
        NULL,
        NULL,
        NULL,
        p_total_amount,
        p_total_amount,
        'reserve_connect',
        jsonb_build_object('booking_intent_id', p_booking_intent_id, 'city_code', p_city_code),
        NOW(),
        NOW()
    )
    RETURNING id INTO v_reservation_id;
    
    -- Update booking locks with reservation_id
    UPDATE reserve.booking_locks
    SET reservation_id = v_reservation_id
    WHERE booking_intent_id = p_booking_intent_id;
    
    -- Update availability calendar
    UPDATE reserve.availability_calendar
    SET 
        bookings_count = bookings_count + 1,
        is_available = CASE 
            WHEN (bookings_count + 1 + temp_holds) >= allotment THEN false 
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

COMMENT ON FUNCTION reserve.create_reservation_safe IS 'Creates reservation with database-level locking to prevent double-booking';

-- ============================================
-- SECTION 6: CONCURRENCY MONITORING
-- ============================================

-- View for active locks
CREATE OR REPLACE VIEW reserve.active_booking_locks AS
SELECT 
    bl.id,
    bl.unit_id,
    um.name as unit_name,
    bl.lock_date,
    bl.lock_type,
    bl.session_id,
    bl.booking_intent_id,
    bi.status as intent_status,
    bl.reservation_id,
    bl.expires_at,
    EXTRACT(EPOCH FROM (bl.expires_at - NOW())) / 60 as minutes_until_expiry,
    bl.city_code,
    bl.created_at
FROM reserve.booking_locks bl
LEFT JOIN reserve.unit_map um ON bl.unit_id = um.id
LEFT JOIN reserve.booking_intents bi ON bl.booking_intent_id = bi.id
WHERE bl.expires_at > NOW()
ORDER BY bl.expires_at ASC;

-- View for potential double-booking risks
CREATE OR REPLACE VIEW reserve.double_booking_risks AS
SELECT 
    unit_id,
    lock_date,
    COUNT(*) as total_locks,
    COUNT(*) FILTER (WHERE lock_type = 'confirmed') as confirmed_count,
    COUNT(*) FILTER (WHERE lock_type = 'hard_hold') as hard_holds,
    COUNT(*) FILTER (WHERE lock_type = 'soft_hold') as soft_holds,
    COUNT(DISTINCT session_id) as unique_sessions,
    string_agg(DISTINCT session_id, ', ') as sessions,
    MIN(expires_at) as earliest_expiry
FROM reserve.booking_locks
WHERE expires_at > NOW()
GROUP BY unit_id, lock_date
HAVING COUNT(*) > 1 OR COUNT(DISTINCT session_id) > 1
ORDER BY lock_date ASC;

-- Function to check unit availability with locks
CREATE OR REPLACE FUNCTION reserve.check_unit_availability_with_locks(
    p_unit_id UUID,
    p_check_in DATE,
    p_check_out DATE,
    p_exclude_session_id VARCHAR(100) DEFAULT NULL
)
RETURNS TABLE (
    date DATE,
    is_available BOOLEAN,
    active_locks INT,
    hard_locks INT,
    confirmed_bookings INT,
    blocking_sessions TEXT[]
) AS $$
BEGIN
    RETURN QUERY
    WITH date_range AS (
        SELECT generate_series(p_check_in, p_check_out - INTERVAL '1 day', INTERVAL '1 day')::date as d
    ),
    locks_per_date AS (
        SELECT 
            dr.d,
            COUNT(*) FILTER (WHERE bl.expires_at > NOW()) as total_locks,
            COUNT(*) FILTER (WHERE bl.lock_type = 'hard_hold' AND bl.expires_at > NOW()) as hard_locks,
            COUNT(*) FILTER (WHERE bl.lock_type = 'confirmed' AND bl.expires_at > NOW()) as confirmed_count,
            array_agg(DISTINCT bl.session_id) FILTER (WHERE bl.session_id != COALESCE(p_exclude_session_id, '') AND bl.expires_at > NOW()) as blocking_sessions
        FROM date_range dr
        LEFT JOIN reserve.booking_locks bl ON dr.d = bl.lock_date AND bl.unit_id = p_unit_id
        GROUP BY dr.d
    )
    SELECT 
        lpd.d as date,
        (lpd.confirmed_count = 0 AND lpd.hard_locks = 0) as is_available,
        COALESCE(lpd.total_locks, 0) as active_locks,
        COALESCE(lpd.hard_locks, 0) as hard_locks,
        COALESCE(lpd.confirmed_count, 0) as confirmed_bookings,
        COALESCE(lpd.blocking_sessions, ARRAY[]::TEXT[]) as blocking_sessions
    FROM locks_per_date lpd
    ORDER BY lpd.d;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.check_unit_availability_with_locks IS 'Checks availability considering active locks';

-- ============================================
-- SECTION 7: TEMP HOLDS INTEGRATION
-- ============================================

-- Update temp_holds to use booking_locks
CREATE OR REPLACE FUNCTION reserve.update_temp_holds_from_locks()
RETURNS INTEGER AS $$
DECLARE
    v_updated_count INT := 0;
    v_unit_id UUID;
    v_date DATE;
    v_lock_count INT;
BEGIN
    FOR v_unit_id, v_date, v_lock_count IN
        SELECT 
            unit_id,
            lock_date,
            COUNT(*) FILTER (WHERE lock_type IN ('soft_hold', 'hard_hold') AND expires_at > NOW())
        FROM reserve.booking_locks
        WHERE expires_at > NOW() - INTERVAL '1 hour'
        GROUP BY unit_id, lock_date
    LOOP
        UPDATE reserve.availability_calendar
        SET temp_holds = v_lock_count,
            updated_at = NOW()
        WHERE unit_id = v_unit_id
        AND date = v_date;
        
        v_updated_count := v_updated_count + 1;
    END LOOP;
    
    RETURN v_updated_count;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 
    'Concurrency & Booking Integrity Migration' as migration,
    '015_concurrency_and_booking_integrity.sql' as file,
    'COMPLETED' as status,
    NOW() as executed_at;

-- Show booking_locks table structure
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'booking_locks'
AND table_schema = 'reserve'
ORDER BY ordinal_position;

-- Show indexes
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'reserve'
AND tablename = 'booking_locks';

-- Show functions created
SELECT 
    routine_name,
    routine_type
FROM information_schema.routines
WHERE routine_schema = 'reserve'
AND routine_name IN (
    'acquire_booking_lock',
    'release_booking_lock',
    'extend_booking_lock',
    'cleanup_expired_locks',
    'check_unit_availability_with_locks',
    'create_reservation_safe'
)
ORDER BY routine_name;

-- ============================================
-- ROLLBACK INSTRUCTIONS
-- ============================================
/*
To rollback this migration:

1. Drop views:
   DROP VIEW IF EXISTS reserve.active_booking_locks;
   DROP VIEW IF EXISTS reserve.double_booking_risks;

2. Drop functions:
   DROP FUNCTION IF EXISTS reserve.acquire_booking_lock(UUID, DATE, DATE, VARCHAR, VARCHAR, UUID, VARCHAR, INT);
   DROP FUNCTION IF EXISTS reserve.release_booking_lock(VARCHAR, UUID);
   DROP FUNCTION IF EXISTS reserve.extend_booking_lock(UUID, INT);
   DROP FUNCTION IF EXISTS reserve.cleanup_expired_locks();
   DROP FUNCTION IF EXISTS reserve.check_availability_consistency();
   DROP FUNCTION IF EXISTS reserve.create_reservation_safe(UUID, VARCHAR, UUID, UUID, UUID, UUID, DATE, DATE, INT, INT, INT, VARCHAR, VARCHAR, VARCHAR, VARCHAR, NUMERIC, VARCHAR);
   DROP FUNCTION IF EXISTS reserve.check_unit_availability_with_locks(UUID, DATE, DATE, VARCHAR);
   DROP FUNCTION IF EXISTS reserve.update_temp_holds_from_locks();

3. Drop triggers:
   DROP TRIGGER IF EXISTS trg_availability_consistency ON reserve.availability_calendar;

4. Drop table (WARNING: all lock data will be lost):
   DROP TABLE IF EXISTS reserve.booking_locks CASCADE;

5. Drop cron job if exists:
   SELECT cron.unschedule('cleanup-expired-locks');

WARNING: Rolling back removes all double-booking protection!
Active locks will be lost and overbooking becomes possible.
*/
