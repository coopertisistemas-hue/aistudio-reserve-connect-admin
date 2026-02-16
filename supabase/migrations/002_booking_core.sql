-- ============================================
-- MIGRATION 002: Booking Core
-- Description: Travelers, booking intents, reservations
-- Version: 1.0
-- Date: 2026-02-16
-- ============================================

-- ============================================
-- 1. TRAVELERS (Guest profiles)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.travelers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_user_id UUID,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(50),
    phone_country_code VARCHAR(5),
    date_of_birth DATE,
    nationality VARCHAR(100),
    document_type VARCHAR(50),
    document_number VARCHAR(100),
    address_line_1 VARCHAR(255),
    city VARCHAR(100),
    state_province VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    preferences JSONB DEFAULT '{}',
    marketing_consent BOOLEAN DEFAULT false,
    is_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.travelers IS 'Guest/traveler profiles for bookings';
COMMENT ON COLUMN reserve.travelers.auth_user_id IS 'Links to auth.users (nullable for guest checkout)';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_travelers_email ON reserve.travelers(email);
CREATE INDEX IF NOT EXISTS idx_travelers_auth ON reserve.travelers(auth_user_id);

-- ============================================
-- 2. BOOKING INTENTS (TTL-based holds)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.booking_intents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id VARCHAR(100) NOT NULL,
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    property_id UUID NOT NULL REFERENCES reserve.properties_map(id),
    unit_id UUID NOT NULL REFERENCES reserve.unit_map(id),
    rate_plan_id UUID REFERENCES reserve.rate_plans(id),
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    nights INTEGER NOT NULL,
    guests_adults INTEGER NOT NULL DEFAULT 1,
    guests_children INTEGER DEFAULT 0,
    guests_infants INTEGER DEFAULT 0,
    traveler_id UUID REFERENCES reserve.travelers(id),
    
    -- Status machine
    status VARCHAR(50) DEFAULT 'intent_created',
    CONSTRAINT valid_intent_status CHECK (status IN (
        'intent_created', 
        'payment_pending', 
        'payment_confirmed', 
        'converted', 
        'expired', 
        'cancelled'
    )),
    
    -- Pricing
    subtotal NUMERIC(12,2),
    taxes NUMERIC(12,2) DEFAULT 0,
    fees NUMERIC(12,2) DEFAULT 0,
    discount_amount NUMERIC(12,2) DEFAULT 0,
    total_amount NUMERIC(12,2),
    currency VARCHAR(3) DEFAULT 'BRL',
    
    -- Payment tracking
    payment_intent_id VARCHAR(100),
    pix_charge_id VARCHAR(100),
    payment_method VARCHAR(20),
    
    -- TTL
    expires_at TIMESTAMPTZ NOT NULL,
    
    -- Conversion tracking
    converted_to_reservation_id UUID,
    converted_at TIMESTAMPTZ,
    
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.booking_intents IS 'Temporary booking holds with TTL (15-30 min)';
COMMENT ON COLUMN reserve.booking_intents.status IS 'State machine: intent_created → payment_pending → payment_confirmed → converted | expired | cancelled';
COMMENT ON COLUMN reserve.booking_intents.expires_at IS 'TTL - auto-expire after this timestamp';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_booking_intents_session ON reserve.booking_intents(session_id);
CREATE INDEX IF NOT EXISTS idx_booking_intents_expires ON reserve.booking_intents(expires_at) WHERE status IN ('intent_created', 'payment_pending');
CREATE INDEX IF NOT EXISTS idx_booking_intents_traveler ON reserve.booking_intents(traveler_id);
CREATE INDEX IF NOT EXISTS idx_booking_intents_property ON reserve.booking_intents(property_id, created_at DESC);

-- ============================================
-- 3. RESERVATIONS (Confirmed bookings)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.reservations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    confirmation_code VARCHAR(50) UNIQUE NOT NULL,
    booking_intent_id UUID REFERENCES reserve.booking_intents(id),
    traveler_id UUID REFERENCES reserve.travelers(id),
    property_id UUID NOT NULL REFERENCES reserve.properties_map(id),
    unit_id UUID NOT NULL REFERENCES reserve.unit_map(id),
    rate_plan_id UUID REFERENCES reserve.rate_plans(id),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    host_booking_id UUID,
    
    -- Dates
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    nights INTEGER NOT NULL,
    
    -- Guests
    guests_adults INTEGER NOT NULL DEFAULT 1,
    guests_children INTEGER DEFAULT 0,
    guests_infants INTEGER DEFAULT 0,
    
    -- Financial
    currency VARCHAR(3) DEFAULT 'BRL',
    subtotal NUMERIC(12,2) NOT NULL,
    taxes NUMERIC(12,2) DEFAULT 0,
    fees NUMERIC(12,2) DEFAULT 0,
    discount_amount NUMERIC(12,2) DEFAULT 0,
    total_amount NUMERIC(12,2) NOT NULL,
    amount_paid NUMERIC(12,2) DEFAULT 0,
    commission_rate NUMERIC(5,4) DEFAULT 0.15,
    commission_amount NUMERIC(12,2),
    
    -- Status (state machine)
    status VARCHAR(50) DEFAULT 'host_commit_pending',
    CONSTRAINT valid_reservation_status CHECK (status IN (
        'host_commit_pending',
        'host_commit_failed',
        'confirmed',
        'checkin_pending',
        'checked_in',
        'checked_out',
        'completed',
        'cancel_pending',
        'cancelled',
        'refund_pending',
        'payout_pending',
        'paid_out'
    )),
    
    payment_status reserve.payment_status DEFAULT 'pending',
    
    -- Guest details (denormalized)
    guest_first_name VARCHAR(100),
    guest_last_name VARCHAR(100),
    guest_email VARCHAR(255),
    guest_phone VARCHAR(50),
    special_requests TEXT,
    
    -- Cancellation
    cancellation_reason TEXT,
    cancelled_by VARCHAR(50),
    
    -- Timestamps
    booked_at TIMESTAMPTZ DEFAULT NOW(),
    confirmed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    checked_in_at TIMESTAMPTZ,
    checked_out_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    
    -- Source tracking
    source reserve.reservation_source DEFAULT 'direct',
    ota_booking_id VARCHAR(100),
    utm_source VARCHAR(100),
    utm_medium VARCHAR(100),
    utm_campaign VARCHAR(200),
    
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.reservations IS 'Confirmed booking records (central entity)';
COMMENT ON COLUMN reserve.reservations.confirmation_code IS 'Unique booking reference (e.g., RES-2026-A1B2C3)';
COMMENT ON COLUMN reserve.reservations.status IS 'Full state machine: host_commit_pending → confirmed → checkin_pending → checked_in → checked_out → completed';
COMMENT ON COLUMN reserve.reservations.host_booking_id IS 'Links to Host Connect booking';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_reservations_code ON reserve.reservations(confirmation_code);
CREATE INDEX IF NOT EXISTS idx_reservations_traveler ON reserve.reservations(traveler_id);
CREATE INDEX IF NOT EXISTS idx_reservations_property ON reserve.reservations(property_id, status);
CREATE INDEX IF NOT EXISTS idx_reservations_dates ON reserve.reservations(check_in, check_out);
CREATE INDEX IF NOT EXISTS idx_reservations_city ON reserve.reservations(city_code, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_reservations_host ON reserve.reservations(host_booking_id);
CREATE INDEX IF NOT EXISTS idx_reservations_intent ON reserve.reservations(booking_intent_id);
CREATE INDEX IF NOT EXISTS idx_reservations_status_payment ON reserve.reservations(status, payment_status);

-- Function to generate confirmation code
CREATE OR REPLACE FUNCTION reserve.generate_confirmation_code()
RETURNS VARCHAR(50) AS $$
DECLARE
    year_part TEXT;
    random_part TEXT;
BEGIN
    year_part := TO_CHAR(NOW(), 'YYYY');
    random_part := UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 6));
    RETURN 'RES-' || year_part || '-' || random_part;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-generate confirmation code
CREATE OR REPLACE FUNCTION reserve.set_confirmation_code()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.confirmation_code IS NULL THEN
        NEW.confirmation_code := reserve.generate_confirmation_code();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_reservations_confirmation_code ON reserve.reservations;
CREATE TRIGGER trg_reservations_confirmation_code
    BEFORE INSERT ON reserve.reservations
    FOR EACH ROW
    EXECUTE FUNCTION reserve.set_confirmation_code();

-- ============================================
-- 4. RLS POLICIES
-- ============================================

ALTER TABLE reserve.travelers ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.booking_intents ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.reservations ENABLE ROW LEVEL SECURITY;

-- Travelers: own data or service role
CREATE POLICY IF NOT EXISTS travelers_own_read ON reserve.travelers 
    FOR SELECT USING (auth_user_id = auth.uid() OR auth.uid() IS NULL);

CREATE POLICY IF NOT EXISTS travelers_service_all ON reserve.travelers 
    FOR ALL TO service_role USING (true);

-- Booking intents: session-based or service
CREATE POLICY IF NOT EXISTS booking_intents_session_read ON reserve.booking_intents
    FOR SELECT USING (
        session_id = COALESCE(current_setting('app.session_id', true), '') 
        OR auth.role() = 'service_role'
    );

CREATE POLICY IF NOT EXISTS booking_intents_service_all ON reserve.booking_intents 
    FOR ALL TO service_role USING (true);

-- Reservations: traveler owns or service
CREATE POLICY IF NOT EXISTS reservations_traveler_read ON reserve.reservations
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM reserve.travelers t 
            WHERE t.id = reservations.traveler_id AND t.auth_user_id = auth.uid()
        ) OR auth.role() = 'service_role'
    );

CREATE POLICY IF NOT EXISTS reservations_service_all ON reserve.reservations 
    FOR ALL TO service_role USING (true);

-- ============================================
-- 5. TRIGGERS
-- ============================================

-- Add updated_at triggers
DO $$
DECLARE
    tbl text;
    tables text[] := ARRAY['travelers', 'booking_intents', 'reservations'];
BEGIN
    FOREACH tbl IN ARRAY tables
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS trg_%I_updated_at ON reserve.%I', tbl, tbl);
        EXECUTE format('CREATE TRIGGER trg_%I_updated_at BEFORE UPDATE ON reserve.%I FOR EACH ROW EXECUTE FUNCTION reserve.update_updated_at_column()', tbl, tbl);
    END LOOP;
END $$;

-- ============================================
-- 6. SEED DATA
-- ============================================

-- Create test traveler
INSERT INTO reserve.travelers (email, first_name, last_name, phone)
VALUES ('test@example.com', 'Test', 'User', '+5511999999999')
ON CONFLICT (email) DO NOTHING;

-- Create test booking intent (expired)
INSERT INTO reserve.booking_intents (
    session_id,
    city_code,
    property_id,
    unit_id,
    check_in,
    check_out,
    nights,
    status,
    expires_at,
    total_amount
)
SELECT 
    'test_session_001',
    'URB',
    p.id,
    u.id,
    CURRENT_DATE + 30,
    CURRENT_DATE + 34,
    4,
    'expired',
    NOW() - INTERVAL '1 hour',
    1400.00
FROM reserve.properties_map p
JOIN reserve.unit_map u ON u.property_id = p.id
WHERE p.slug = 'pousada-teste-urb'
ON CONFLICT DO NOTHING;

-- Create test reservation
INSERT INTO reserve.reservations (
    confirmation_code,
    property_id,
    unit_id,
    city_code,
    check_in,
    check_out,
    nights,
    guests_adults,
    status,
    payment_status,
    subtotal,
    total_amount,
    commission_rate,
    commission_amount,
    guest_first_name,
    guest_last_name,
    guest_email
)
SELECT 
    'RES-2026-TEST01',
    p.id,
    u.id,
    'URB',
    CURRENT_DATE + 60,
    CURRENT_DATE + 64,
    4,
    2,
    'confirmed',
    'paid',
    1400.00,
    1400.00,
    0.15,
    210.00,
    'Test',
    'Guest',
    'test@example.com'
FROM reserve.properties_map p
JOIN reserve.unit_map u ON u.property_id = p.id
WHERE p.slug = 'pousada-teste-urb'
ON CONFLICT (confirmation_code) DO NOTHING;

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 'Migration 002: Booking Core completed successfully' as status;

SELECT 
    'travelers' as table_name, COUNT(*) as count FROM reserve.travelers
UNION ALL
SELECT 'booking_intents', COUNT(*) FROM reserve.booking_intents
UNION ALL
SELECT 'reservations', COUNT(*) FROM reserve.reservations;
