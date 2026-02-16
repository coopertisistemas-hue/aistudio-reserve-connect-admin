-- ============================================
-- MIGRATION: Create Missing Tables
-- Description: Creates only tables that don't exist yet
-- Version: 1.0
-- Date: 2026-02-16
-- ============================================

-- ============================================
-- 1. PAYMENTS (Stripe + PIX)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID REFERENCES reserve.reservations(id) ON DELETE SET NULL,
    booking_intent_id UUID REFERENCES reserve.booking_intents(id),
    city_code VARCHAR(10) REFERENCES reserve.cities(code),
    
    payment_method VARCHAR(20) NOT NULL,
    gateway VARCHAR(50) NOT NULL,
    gateway_payment_id VARCHAR(100) NOT NULL,
    gateway_charge_id VARCHAR(100),
    
    currency VARCHAR(3) DEFAULT 'BRL',
    amount NUMERIC(12,2) NOT NULL,
    gateway_fee NUMERIC(12,2) DEFAULT 0,
    tax_amount NUMERIC(12,2) DEFAULT 0,
    
    status VARCHAR(50) DEFAULT 'pending',
    refunded_amount NUMERIC(12,2) DEFAULT 0,
    
    pix_qr_code TEXT,
    pix_copy_paste_key TEXT,
    pix_expires_at TIMESTAMPTZ,
    
    stripe_client_secret VARCHAR(255),
    stripe_payment_method_id VARCHAR(100),
    
    idempotency_key VARCHAR(100) UNIQUE,
    metadata JSONB DEFAULT '{}',
    
    succeeded_at TIMESTAMPTZ,
    failed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    refunded_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_payments_reservation ON reserve.payments(reservation_id);
CREATE INDEX IF NOT EXISTS idx_payments_intent ON reserve.payments(booking_intent_id);
CREATE INDEX IF NOT EXISTS idx_payments_gateway ON reserve.payments(gateway_payment_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON reserve.payments(status, created_at);
CREATE INDEX IF NOT EXISTS idx_payments_city ON reserve.payments(city_code, created_at DESC);

ALTER TABLE reserve.payments ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 2. LEDGER ENTRIES
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.ledger_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id UUID NOT NULL,
    entry_type VARCHAR(50) NOT NULL,
    
    booking_id UUID REFERENCES reserve.reservations(id),
    property_id UUID REFERENCES reserve.properties_map(id),
    city_code VARCHAR(10) REFERENCES reserve.cities(code),
    payment_id UUID REFERENCES reserve.payments(id),
    payout_id UUID,
    
    account VARCHAR(50) NOT NULL,
    counterparty VARCHAR(50),
    direction VARCHAR(10) NOT NULL CHECK (direction IN ('debit', 'credit')),
    amount NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
    
    description TEXT,
    metadata JSONB DEFAULT '{}',
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    created_by UUID
);

CREATE INDEX IF NOT EXISTS idx_ledger_transaction ON reserve.ledger_entries(transaction_id);
CREATE INDEX IF NOT EXISTS idx_ledger_booking ON reserve.ledger_entries(booking_id);
CREATE INDEX IF NOT EXISTS idx_ledger_city ON reserve.ledger_entries(city_code, created_at);
CREATE INDEX IF NOT EXISTS idx_ledger_account ON reserve.ledger_entries(account, created_at);

ALTER TABLE reserve.ledger_entries ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 3. COMMISSION TIERS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.commission_tiers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    property_id UUID REFERENCES reserve.properties_map(id),
    name VARCHAR(100) NOT NULL,
    min_properties INTEGER DEFAULT 0,
    max_properties INTEGER,
    commission_rate NUMERIC(5,4) NOT NULL CHECK (commission_rate BETWEEN 0 AND 1),
    effective_from DATE DEFAULT CURRENT_DATE,
    effective_to DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_commission_tiers_city ON reserve.commission_tiers(city_code, is_active);

-- Seed default commissions
INSERT INTO reserve.commission_tiers (city_code, name, commission_rate, min_properties, max_properties)
VALUES 
    ('URB', 'Standard Rate', 0.15, 0, 10),
    ('URB', 'Volume Discount 10+', 0.12, 11, 50),
    ('URB', 'Volume Discount 50+', 0.10, 51, NULL)
ON CONFLICT DO NOTHING;

ALTER TABLE reserve.commission_tiers ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 4. PAYOUT SCHEDULES
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.payout_schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type VARCHAR(20) NOT NULL CHECK (entity_type IN ('owner', 'property')),
    entity_id UUID NOT NULL,
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    frequency VARCHAR(20) DEFAULT 'weekly' CHECK (frequency IN ('weekly', 'biweekly', 'monthly', 'on_checkout')),
    day_of_week INTEGER CHECK (day_of_week BETWEEN 0 AND 6),
    day_of_month INTEGER CHECK (day_of_month BETWEEN 1 AND 31),
    min_threshold NUMERIC(12,2) DEFAULT 0,
    hold_days INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(entity_type, entity_id)
);

CREATE INDEX IF NOT EXISTS idx_payout_schedules_entity ON reserve.payout_schedules(entity_type, entity_id);

ALTER TABLE reserve.payout_schedules ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 5. PAYOUT BATCHES
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.payout_batches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_date DATE NOT NULL,
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    status VARCHAR(50) DEFAULT 'pending',
    total_amount NUMERIC(12,2) DEFAULT 0,
    total_payouts INTEGER DEFAULT 0,
    total_properties INTEGER DEFAULT 0,
    processed_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    error_message TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_payout_batches_date ON reserve.payout_batches(batch_date);
CREATE INDEX IF NOT EXISTS idx_payout_batches_city ON reserve.payout_batches(city_code, status);

ALTER TABLE reserve.payout_batches ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 6. PAYOUTS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.payouts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_id UUID REFERENCES reserve.payout_batches(id),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    property_id UUID NOT NULL REFERENCES reserve.properties_map(id),
    owner_id UUID,
    
    currency VARCHAR(3) DEFAULT 'BRL',
    gross_amount NUMERIC(12,2) NOT NULL,
    commission_amount NUMERIC(12,2) NOT NULL,
    fee_amount NUMERIC(12,2) DEFAULT 0,
    tax_amount NUMERIC(12,2) DEFAULT 0,
    net_amount NUMERIC(12,2) NOT NULL,
    
    status VARCHAR(50) DEFAULT 'pending',
    gateway_reference VARCHAR(100),
    gateway_transfer_id VARCHAR(100),
    
    reservation_ids JSONB DEFAULT '[]',
    booking_count INTEGER DEFAULT 0,
    bank_details JSONB,
    
    processed_at TIMESTAMPTZ,
    transferred_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_payouts_batch ON reserve.payouts(batch_id);
CREATE INDEX IF NOT EXISTS idx_payouts_property ON reserve.payouts(property_id, status);

ALTER TABLE reserve.payouts ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 7. NOTIFICATION OUTBOX
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.notification_outbox (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    recipient_type VARCHAR(20) NOT NULL,
    recipient_id UUID NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    channel VARCHAR(20) NOT NULL,
    template_id VARCHAR(100),
    subject VARCHAR(255),
    body TEXT,
    body_html TEXT,
    status VARCHAR(20) DEFAULT 'pending',
    priority INTEGER DEFAULT 5,
    scheduled_at TIMESTAMPTZ DEFAULT NOW(),
    sent_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,
    opened_at TIMESTAMPTZ,
    reservation_id UUID REFERENCES reserve.reservations(id),
    metadata JSONB DEFAULT '{}',
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_notifications_status ON reserve.notification_outbox(status, scheduled_at);
CREATE INDEX IF NOT EXISTS idx_notifications_reservation ON reserve.notification_outbox(reservation_id);

ALTER TABLE reserve.notification_outbox ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 8. HOST WEBHOOK EVENTS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.host_webhook_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id VARCHAR(100) UNIQUE NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    payload JSONB NOT NULL,
    headers JSONB,
    status VARCHAR(20) DEFAULT 'pending',
    processed_at TIMESTAMPTZ,
    error_message TEXT,
    idempotency_key VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_webhook_events ON reserve.host_webhook_events(event_id, status);
CREATE INDEX IF NOT EXISTS idx_webhook_events_status ON reserve.host_webhook_events(status, created_at);

ALTER TABLE reserve.host_webhook_events ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 9. REVIEWS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES reserve.reservations(id) ON DELETE CASCADE,
    traveler_id UUID REFERENCES reserve.travelers(id) ON DELETE SET NULL,
    property_id UUID NOT NULL REFERENCES reserve.properties_map(id) ON DELETE CASCADE,
    overall_rating INTEGER NOT NULL CHECK (overall_rating BETWEEN 1 AND 5),
    cleanliness_rating INTEGER CHECK (cleanliness_rating BETWEEN 1 AND 5),
    service_rating INTEGER CHECK (service_rating BETWEEN 1 AND 5),
    location_rating INTEGER CHECK (location_rating BETWEEN 1 AND 5),
    value_rating INTEGER CHECK (value_rating BETWEEN 1 AND 5),
    title VARCHAR(200),
    content TEXT NOT NULL,
    is_verified BOOLEAN DEFAULT false,
    is_published BOOLEAN DEFAULT false,
    moderation_notes TEXT,
    moderated_by UUID REFERENCES auth.users(id),
    moderated_at TIMESTAMPTZ,
    stay_date DATE,
    room_type VARCHAR(100),
    helpful_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_reviews_property ON reserve.reviews(property_id, is_published, created_at);
CREATE INDEX IF NOT EXISTS idx_reviews_traveler ON reserve.reviews(traveler_id);

ALTER TABLE reserve.reviews ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 10. REVIEW INVITATIONS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.review_invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES reserve.reservations(id) ON DELETE CASCADE,
    traveler_id UUID NOT NULL REFERENCES reserve.travelers(id),
    property_id UUID NOT NULL REFERENCES reserve.properties_map(id),
    status VARCHAR(20) DEFAULT 'pending',
    sent_at TIMESTAMPTZ,
    opened_at TIMESTAMPTZ,
    submitted_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    token VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_review_invitations_reservation ON reserve.review_invitations(reservation_id);
CREATE INDEX IF NOT EXISTS idx_review_invitations_token ON reserve.review_invitations(token);

ALTER TABLE reserve.review_invitations ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 11. ADS SLOTS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.ads_slots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    slot_name VARCHAR(100) NOT NULL,
    slot_type VARCHAR(50) NOT NULL,
    position INTEGER DEFAULT 0,
    dimensions JSONB,
    max_ads INTEGER DEFAULT 1,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(city_code, slot_name)
);

INSERT INTO reserve.ads_slots (city_code, slot_name, slot_type, position, max_ads)
VALUES 
    ('URB', 'home_hero', 'banner', 1, 3),
    ('URB', 'search_results_top', 'listing', 1, 2),
    ('URB', 'search_sidebar', 'sidebar', 1, 4)
ON CONFLICT (city_code, slot_name) DO NOTHING;

ALTER TABLE reserve.ads_slots ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 12. ADS CAMPAIGNS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.ads_campaigns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    advertiser_id UUID NOT NULL,
    slot_id UUID NOT NULL REFERENCES reserve.ads_slots(id),
    name VARCHAR(200) NOT NULL,
    headline VARCHAR(255),
    description TEXT,
    image_url TEXT,
    destination_url TEXT,
    target_property_types JSONB,
    target_dates JSONB,
    budget_type VARCHAR(20),
    budget_amount NUMERIC(12,2),
    cpc_bid NUMERIC(8,2),
    status VARCHAR(20) DEFAULT 'draft',
    starts_at TIMESTAMPTZ,
    ends_at TIMESTAMPTZ,
    impression_count INTEGER DEFAULT 0,
    click_count INTEGER DEFAULT 0,
    conversion_count INTEGER DEFAULT 0,
    spend_amount NUMERIC(12,2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ads_campaigns_city ON reserve.ads_campaigns(city_code, status);

ALTER TABLE reserve.ads_campaigns ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 13. ADS IMPRESSIONS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.ads_impressions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL REFERENCES reserve.ads_campaigns(id),
    city_code VARCHAR(10) NOT NULL,
    session_id VARCHAR(100),
    traveler_id UUID REFERENCES reserve.travelers(id),
    property_id UUID REFERENCES reserve.properties_map(id),
    slot_name VARCHAR(100),
    page_path TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ads_impressions_campaign ON reserve.ads_impressions(campaign_id, created_at);

ALTER TABLE reserve.ads_impressions ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 14. ADS CLICKS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.ads_clicks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL REFERENCES reserve.ads_campaigns(id),
    impression_id UUID REFERENCES reserve.ads_impressions(id),
    city_code VARCHAR(10) NOT NULL,
    session_id VARCHAR(100),
    traveler_id UUID REFERENCES reserve.travelers(id),
    cost_amount NUMERIC(8,2),
    converted BOOLEAN DEFAULT false,
    conversion_value NUMERIC(12,2),
    conversion_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ads_clicks_campaign ON reserve.ads_clicks(campaign_id, created_at);

ALTER TABLE reserve.ads_clicks ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 15. PROPERTY OWNERS (Future)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.property_owners (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(50),
    document_type VARCHAR(50),
    document_number VARCHAR(100),
    bank_details JSONB,
    default_payout_schedule_id UUID,
    notification_preferences JSONB DEFAULT '{}',
    auth_user_id UUID REFERENCES auth.users(id),
    is_active BOOLEAN DEFAULT true,
    email_verified_at TIMESTAMPTZ,
    last_login_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE reserve.property_owners ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 16. OWNER PROPERTIES
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.owner_properties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES reserve.property_owners(id) ON DELETE CASCADE,
    property_id UUID NOT NULL REFERENCES reserve.properties_map(id) ON DELETE CASCADE,
    ownership_percentage NUMERIC(5,2) DEFAULT 100,
    is_primary_owner BOOLEAN DEFAULT false,
    can_view_bookings BOOLEAN DEFAULT true,
    can_view_financials BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(owner_id, property_id)
);

ALTER TABLE reserve.owner_properties ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 17. SERVICE PROVIDERS (Future)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.service_providers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    provider_type VARCHAR(50) NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    contact_name VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(50),
    whatsapp VARCHAR(50),
    address_line_1 VARCHAR(255),
    city VARCHAR(100),
    state_province VARCHAR(100),
    postal_code VARCHAR(20),
    bank_details JSONB,
    commission_rate NUMERIC(5,4),
    payout_schedule_id UUID,
    document_type VARCHAR(50),
    document_number VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE reserve.service_providers ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 18. SERVICE CATALOG
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.service_catalog (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    property_id UUID REFERENCES reserve.properties_map(id),
    provider_id UUID REFERENCES reserve.service_providers(id),
    service_type VARCHAR(50) NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    pricing_type VARCHAR(20) NOT NULL,
    base_price NUMERIC(12,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'BRL',
    min_quantity INTEGER DEFAULT 1,
    max_quantity INTEGER,
    available_days INTEGER[] DEFAULT ARRAY[0,1,2,3,4,5,6],
    available_from TIME,
    available_until TIME,
    advance_booking_hours INTEGER DEFAULT 24,
    cancellation_policy TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE reserve.service_catalog ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 19. SERVICE ORDERS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.service_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES reserve.reservations(id),
    property_id UUID NOT NULL REFERENCES reserve.properties_map(id),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    service_id UUID REFERENCES reserve.service_catalog(id),
    provider_id UUID REFERENCES reserve.service_providers(id),
    traveler_id UUID REFERENCES reserve.travelers(id),
    status VARCHAR(20) DEFAULT 'pending',
    quantity INTEGER DEFAULT 1,
    unit_price NUMERIC(12,2) NOT NULL,
    total_amount NUMERIC(12,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'BRL',
    scheduled_date DATE,
    scheduled_time TIME,
    fulfilled_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    cancellation_reason TEXT,
    cancelled_by VARCHAR(50),
    ledger_entry_id UUID,
    vendor_payable_id UUID,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE reserve.service_orders ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 20. SERVICE PAYOUTS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.service_payouts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_id UUID NOT NULL REFERENCES reserve.service_providers(id),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    payout_batch_id UUID REFERENCES reserve.payout_batches(id),
    currency VARCHAR(3) DEFAULT 'BRL',
    amount NUMERIC(12,2) NOT NULL,
    order_count INTEGER DEFAULT 0,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    gateway_reference VARCHAR(100),
    order_ids JSONB DEFAULT '[]',
    processed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE reserve.service_payouts ENABLE ROW LEVEL SECURITY;

-- ============================================
-- FUNCTIONS
-- ============================================

-- Function to update updated_at
CREATE OR REPLACE FUNCTION reserve.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

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

-- Function to verify ledger balance
CREATE OR REPLACE FUNCTION reserve.verify_ledger_balance(p_transaction_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    total_debits NUMERIC(12,2);
    total_credits NUMERIC(12,2);
BEGIN
    SELECT 
        COALESCE(SUM(amount) FILTER (WHERE direction = 'debit'), 0),
        COALESCE(SUM(amount) FILTER (WHERE direction = 'credit'), 0)
    INTO total_debits, total_credits
    FROM reserve.ledger_entries
    WHERE transaction_id = p_transaction_id;
    
    RETURN total_debits = total_credits;
END;
$$ LANGUAGE plpgsql;

-- Function to cleanup expired intents
CREATE OR REPLACE FUNCTION reserve.cleanup_expired_intents()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    UPDATE reserve.availability_calendar ac
    SET temp_holds = GREATEST(0, temp_holds - 1)
    FROM reserve.booking_intents bi
    WHERE bi.status IN ('intent_created', 'payment_pending')
      AND bi.expires_at < NOW()
      AND ac.unit_id = bi.unit_id;
    
    UPDATE reserve.booking_intents
    SET status = 'expired',
        updated_at = NOW()
    WHERE status IN ('intent_created', 'payment_pending')
      AND expires_at < NOW();
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to get conversion funnel
CREATE OR REPLACE FUNCTION reserve.get_conversion_funnel(
    p_city_code VARCHAR,
    p_start_date DATE,
    p_end_date DATE
)
RETURNS TABLE (
    stage VARCHAR(50),
    count BIGINT,
    conversion_rate DECIMAL(5,2)
) AS $$
BEGIN
    RETURN QUERY
    WITH funnel AS (
        SELECT 'search' as stage, COUNT(*) FILTER (WHERE event_name = 'search_performed') as cnt
        FROM reserve.events
        WHERE city_code = p_city_code AND created_at::date BETWEEN p_start_date AND p_end_date
        UNION ALL
        SELECT 'property_view', COUNT(*) FILTER (WHERE event_name = 'property_viewed')
        FROM reserve.events WHERE city_code = p_city_code AND created_at::date BETWEEN p_start_date AND p_end_date
        UNION ALL
        SELECT 'intent', COUNT(*) FILTER (WHERE event_name = 'booking_intent_created')
        FROM reserve.events WHERE city_code = p_city_code AND created_at::date BETWEEN p_start_date AND p_end_date
        UNION ALL
        SELECT 'payment', COUNT(*) FILTER (WHERE event_name = 'payment_succeeded')
        FROM reserve.events WHERE city_code = p_city_code AND created_at::date BETWEEN p_start_date AND p_end_date
        UNION ALL
        SELECT 'booking', COUNT(*) FILTER (WHERE event_name = 'reservation_confirmed')
        FROM reserve.events WHERE city_code = p_city_code AND created_at::date BETWEEN p_start_date AND p_end_date
    )
    SELECT f.stage, f.cnt, NULL::decimal FROM funnel f
    ORDER BY CASE f.stage WHEN 'search' THEN 1 WHEN 'property_view' THEN 2 WHEN 'intent' THEN 3 WHEN 'payment' THEN 4 WHEN 'booking' THEN 5 END;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 'Missing tables migration completed successfully' as status;

SELECT 
    'Total tables in reserve schema' as metric,
    COUNT(*)::text as value
FROM information_schema.tables 
WHERE table_schema = 'reserve';
