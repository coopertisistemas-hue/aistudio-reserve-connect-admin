-- ============================================
-- MIGRATION 005: Analytics & Marketing
-- Description: Events, reviews, ADS MVP
-- Version: 1.0
-- Date: 2026-02-16
-- ============================================

-- ============================================
-- 1. EVENTS (KPI tracking)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_name VARCHAR(100) NOT NULL,
    event_version VARCHAR(10) DEFAULT '1.0',
    
    -- Multi-tenancy
    city_code VARCHAR(10) REFERENCES reserve.cities(code),
    
    -- Entity references
    property_id UUID REFERENCES reserve.properties_map(id),
    unit_id UUID REFERENCES reserve.unit_map(id),
    reservation_id UUID REFERENCES reserve.reservations(id),
    traveler_id UUID REFERENCES reserve.travelers(id),
    payment_id UUID REFERENCES reserve.payments(id),
    
    -- Session tracking
    session_id VARCHAR(100),
    correlation_id UUID,
    
    -- Payload
    entity_type VARCHAR(50),
    entity_id UUID,
    metadata JSONB DEFAULT '{}',
    
    -- Attribution
    utm_source VARCHAR(100),
    utm_medium VARCHAR(100),
    utm_campaign VARCHAR(200),
    
    -- Context
    user_agent TEXT,
    ip_hash VARCHAR(64),
    referrer TEXT,
    device_type VARCHAR(20),
    app_version VARCHAR(20),
    
    -- Severity
    severity reserve.event_severity DEFAULT 'info',
    
    -- Timestamp
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.events IS 'KPI and funnel event tracking';
COMMENT ON COLUMN reserve.events.event_name IS 'e.g., search_performed, property_viewed, payment_succeeded';
COMMENT ON COLUMN reserve.events.correlation_id IS 'Request trace ID for distributed tracing';
COMMENT ON COLUMN reserve.events.ip_hash IS 'Hashed IP for privacy compliance';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_events_name ON reserve.events(event_name, created_at);
CREATE INDEX IF NOT EXISTS idx_events_city ON reserve.events(city_code, event_name);
CREATE INDEX IF NOT EXISTS idx_events_session ON reserve.events(session_id, created_at);
CREATE INDEX IF NOT EXISTS idx_events_reservation ON reserve.events(reservation_id);
CREATE INDEX IF NOT EXISTS idx_events_property ON reserve.events(property_id, created_at);
CREATE INDEX IF NOT EXISTS idx_events_created ON reserve.events(created_at DESC);

-- ============================================
-- 2. REVIEWS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES reserve.reservations(id) ON DELETE CASCADE,
    traveler_id UUID REFERENCES reserve.travelers(id) ON DELETE SET NULL,
    property_id UUID NOT NULL REFERENCES reserve.properties_map(id) ON DELETE CASCADE,
    
    -- Ratings (1-5 scale)
    overall_rating INTEGER NOT NULL CHECK (overall_rating BETWEEN 1 AND 5),
    cleanliness_rating INTEGER CHECK (cleanliness_rating BETWEEN 1 AND 5),
    service_rating INTEGER CHECK (service_rating BETWEEN 1 AND 5),
    location_rating INTEGER CHECK (location_rating BETWEEN 1 AND 5),
    value_rating INTEGER CHECK (value_rating BETWEEN 1 AND 5),
    
    -- Content
    title VARCHAR(200),
    content TEXT NOT NULL,
    
    -- Moderation
    is_verified BOOLEAN DEFAULT false,
    is_published BOOLEAN DEFAULT false,
    moderation_notes TEXT,
    moderated_by UUID REFERENCES auth.users(id),
    moderated_at TIMESTAMPTZ,
    
    -- Stay details (denormalized)
    stay_date DATE,
    room_type VARCHAR(100),
    
    -- Engagement
    helpful_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.reviews IS 'Guest reviews and ratings';
COMMENT ON COLUMN reserve.reviews.is_verified IS 'Verified stay (guest actually stayed)';
COMMENT ON COLUMN reserve.reviews.is_published IS 'Approved by moderation';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_reviews_property ON reserve.reviews(property_id, is_published, created_at);
CREATE INDEX IF NOT EXISTS idx_reviews_traveler ON reserve.reviews(traveler_id);
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reserve.reviews(property_id, overall_rating) WHERE is_published = true;
CREATE INDEX IF NOT EXISTS idx_reviews_created ON reserve.reviews(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_reviews_reservation ON reserve.reviews(reservation_id);

-- ============================================
-- 3. REVIEW INVITATIONS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.review_invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES reserve.reservations(id) ON DELETE CASCADE,
    traveler_id UUID NOT NULL REFERENCES reserve.travelers(id),
    property_id UUID NOT NULL REFERENCES reserve.properties_map(id),
    
    -- Status
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'sent', 'opened', 'completed', 'expired')),
    
    -- Timing
    sent_at TIMESTAMPTZ,
    opened_at TIMESTAMPTZ,
    submitted_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    
    -- Token for public submission
    token VARCHAR(255) UNIQUE NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.review_invitations IS 'Review request tracking';
COMMENT ON COLUMN reserve.review_invitations.token IS 'Secure token for guest to submit review without login';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_review_invitations_reservation ON reserve.review_invitations(reservation_id);
CREATE INDEX IF NOT EXISTS idx_review_invitations_status ON reserve.review_invitations(status, expires_at);
CREATE INDEX IF NOT EXISTS idx_review_invitations_token ON reserve.review_invitations(token);

-- ============================================
-- 4. ADS SLOTS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.ads_slots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    slot_name VARCHAR(100) NOT NULL,
    slot_type VARCHAR(50) NOT NULL CHECK (slot_type IN ('banner', 'listing', 'native', 'sidebar')),
    
    -- Configuration
    position INTEGER DEFAULT 0,
    dimensions JSONB,
    max_ads INTEGER DEFAULT 1,
    is_active BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(city_code, slot_name)
);

COMMENT ON TABLE reserve.ads_slots IS 'Ad inventory slots per city';
COMMENT ON COLUMN reserve.ads_slots.slot_name IS 'e.g., home_hero, search_sidebar, property_detail';

-- Seed default slots
INSERT INTO reserve.ads_slots (city_code, slot_name, slot_type, position, max_ads)
VALUES 
    ('URB', 'home_hero', 'banner', 1, 3),
    ('URB', 'search_results_top', 'listing', 1, 2),
    ('URB', 'search_sidebar', 'sidebar', 1, 4),
    ('URB', 'property_detail_sidebar', 'sidebar', 1, 2)
ON CONFLICT (city_code, slot_name) DO NOTHING;

-- ============================================
-- 5. ADS CAMPAIGNS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.ads_campaigns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    advertiser_id UUID NOT NULL,
    slot_id UUID NOT NULL REFERENCES reserve.ads_slots(id),
    
    -- Content
    name VARCHAR(200) NOT NULL,
    headline VARCHAR(255),
    description TEXT,
    image_url TEXT,
    destination_url TEXT,
    
    -- Targeting
    target_property_types JSONB,
    target_dates JSONB,
    
    -- Budget
    budget_type VARCHAR(20) CHECK (budget_type IN ('daily', 'total')),
    budget_amount NUMERIC(12,2),
    cpc_bid NUMERIC(8,2),
    
    -- Status
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'paused', 'ended')),
    
    -- Schedule
    starts_at TIMESTAMPTZ,
    ends_at TIMESTAMPTZ,
    
    -- Metrics
    impression_count INTEGER DEFAULT 0,
    click_count INTEGER DEFAULT 0,
    conversion_count INTEGER DEFAULT 0,
    spend_amount NUMERIC(12,2) DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.ads_campaigns IS 'Advertising campaigns';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_ads_campaigns_city ON reserve.ads_campaigns(city_code, status) WHERE status = 'active';
CREATE INDEX IF NOT EXISTS idx_ads_campaigns_slot ON reserve.ads_campaigns(slot_id, status);
CREATE INDEX IF NOT EXISTS idx_ads_campaigns_advertiser ON reserve.ads_campaigns(advertiser_id);

-- ============================================
-- 6. ADS IMPRESSIONS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.ads_impressions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL REFERENCES reserve.ads_campaigns(id),
    city_code VARCHAR(10) NOT NULL,
    
    -- Context
    session_id VARCHAR(100),
    traveler_id UUID REFERENCES reserve.travelers(id),
    property_id UUID REFERENCES reserve.properties_map(id),
    
    -- Placement
    slot_name VARCHAR(100),
    page_path TEXT,
    
    -- Timestamp
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.ads_impressions IS 'Ad impression tracking';

-- Indexes (partition-friendly)
CREATE INDEX IF NOT EXISTS idx_ads_impressions_campaign ON reserve.ads_impressions(campaign_id, created_at);
CREATE INDEX IF NOT EXISTS idx_ads_impressions_session ON reserve.ads_impressions(session_id, created_at);
CREATE INDEX IF NOT EXISTS idx_ads_impressions_created ON reserve.ads_impressions(created_at);

-- ============================================
-- 7. ADS CLICKS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.ads_clicks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID NOT NULL REFERENCES reserve.ads_campaigns(id),
    impression_id UUID REFERENCES reserve.ads_impressions(id),
    city_code VARCHAR(10) NOT NULL,
    
    -- Context
    session_id VARCHAR(100),
    traveler_id UUID REFERENCES reserve.travelers(id),
    
    -- Cost
    cost_amount NUMERIC(8,2),
    
    -- Conversion tracking
    converted BOOLEAN DEFAULT false,
    conversion_value NUMERIC(12,2),
    conversion_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.ads_clicks IS 'Ad click tracking with cost';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_ads_clicks_campaign ON reserve.ads_clicks(campaign_id, created_at);
CREATE INDEX IF NOT EXISTS idx_ads_clicks_session ON reserve.ads_clicks(session_id, created_at);
CREATE INDEX IF NOT EXISTS idx_ads_clicks_created ON reserve.ads_clicks(created_at);

-- ============================================
-- 8. DAILY KPI SNAPSHOTS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.kpi_daily_snapshots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    snapshot_date DATE NOT NULL,
    
    -- Search metrics
    searches_count INTEGER DEFAULT 0,
    search_result_avg DECIMAL(5,2),
    
    -- Conversion funnel
    page_views INTEGER DEFAULT 0,
    property_views INTEGER DEFAULT 0,
    intents_created INTEGER DEFAULT 0,
    payments_started INTEGER DEFAULT 0,
    payments_succeeded INTEGER DEFAULT 0,
    reservations_confirmed INTEGER DEFAULT 0,
    
    -- Financial
    gross_revenue DECIMAL(12,2) DEFAULT 0,
    commission_earned DECIMAL(12,2) DEFAULT 0,
    refunds_processed DECIMAL(12,2) DEFAULT 0,
    
    -- Performance
    avg_payment_time_ms INTEGER,
    host_success_rate DECIMAL(5,2),
    payment_success_rate DECIMAL(5,2),
    
    -- Marketing
    ad_impressions INTEGER DEFAULT 0,
    ad_clicks INTEGER DEFAULT 0,
    ad_spend DECIMAL(12,2) DEFAULT 0,
    
    -- Calculated metrics
    search_to_view_rate DECIMAL(5,2),
    view_to_intent_rate DECIMAL(5,2),
    intent_to_payment_rate DECIMAL(5,2),
    payment_to_confirmation_rate DECIMAL(5,2),
    overall_conversion_rate DECIMAL(5,2),
    
    UNIQUE(city_code, snapshot_date)
);

COMMENT ON TABLE reserve.kpi_daily_snapshots IS 'Daily aggregated KPIs for dashboards';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_kpi_snapshots_date ON reserve.kpi_daily_snapshots(snapshot_date);
CREATE INDEX IF NOT EXISTS idx_kpi_snapshots_city ON reserve.kpi_daily_snapshots(city_code, snapshot_date);

-- ============================================
-- 9. RLS POLICIES
-- ============================================

ALTER TABLE reserve.events ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.review_invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.ads_slots ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.ads_campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.ads_impressions ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.ads_clicks ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.kpi_daily_snapshots ENABLE ROW LEVEL SECURITY;

-- Reviews: public can see published
CREATE POLICY IF NOT EXISTS reviews_public_read ON reserve.reviews
    FOR SELECT USING (is_published = true);

CREATE POLICY IF NOT EXISTS reviews_service_all ON reserve.reviews FOR ALL TO service_role USING (true);

-- Review invitations: service only
CREATE POLICY IF NOT EXISTS review_invitations_service_all ON reserve.review_invitations FOR ALL TO service_role USING (true);

-- Events: service only (write), public can emit
CREATE POLICY IF NOT EXISTS events_public_insert ON reserve.events FOR INSERT WITH CHECK (true);
CREATE POLICY IF NOT EXISTS events_service_all ON reserve.events FOR ALL TO service_role USING (true);

-- ADS slots: public read active
CREATE POLICY IF NOT EXISTS ads_slots_public_read ON reserve.ads_slots
    FOR SELECT USING (is_active = true);

-- ADS campaigns: public read active
CREATE POLICY IF NOT EXISTS ads_campaigns_public_read ON reserve.ads_campaigns
    FOR SELECT USING (
        status = 'active' 
        AND starts_at <= NOW() 
        AND (ends_at IS NULL OR ends_at >= NOW())
    );

-- ADS impressions/clicks: service only
CREATE POLICY IF NOT EXISTS ads_impressions_service_all ON reserve.ads_impressions FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS ads_clicks_service_all ON reserve.ads_clicks FOR ALL TO service_role USING (true);

-- KPI snapshots: service only
CREATE POLICY IF NOT EXISTS kpi_service_all ON reserve.kpi_daily_snapshots FOR ALL TO service_role USING (true);

-- ============================================
-- 10. TRIGGERS
-- ============================================

DO $$
DECLARE
    tbl text;
    tables text[] := ARRAY['reviews', 'review_invitations', 'ads_slots', 'ads_campaigns'];
BEGIN
    FOREACH tbl IN ARRAY tables
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS trg_%I_updated_at ON reserve.%I', tbl, tbl);
        EXECUTE format('CREATE TRIGGER trg_%I_updated_at BEFORE UPDATE ON reserve.%I FOR EACH ROW EXECUTE FUNCTION reserve.update_updated_at_column()', tbl, tbl);
    END LOOP;
END $$;

-- ============================================
-- 11. SEED DATA
-- ============================================

-- Create test review
INSERT INTO reserve.reviews (
    reservation_id,
    traveler_id,
    property_id,
    overall_rating,
    cleanliness_rating,
    service_rating,
    title,
    content,
    is_verified,
    is_published
)
SELECT 
    r.id,
    r.traveler_id,
    r.property_id,
    5,
    5,
    5,
    'Excelente experiência!',
    'Adoramos nossa estadia. O atendimento foi impecável e a pousada é linda.',
    true,
    true
FROM reserve.reservations r
WHERE r.confirmation_code = 'RES-2026-TEST01'
ON CONFLICT DO NOTHING;

-- Update property rating cache
UPDATE reserve.properties_map
SET rating_cached = 5.0,
    review_count_cached = 1
WHERE slug = 'pousada-teste-urb';

-- Create test events
INSERT INTO reserve.events (event_name, city_code, session_id, metadata, device_type)
VALUES 
    ('search_performed', 'URB', 'test_session', '{"result_count": 10}'::jsonb, 'desktop'),
    ('property_viewed', 'URB', 'test_session', '{"property_id": "test"}'::jsonb, 'desktop'),
    ('booking_intent_created', 'URB', 'test_session', '{"total_amount": 1400}'::jsonb, 'desktop');

-- Create KPI snapshot for today
INSERT INTO reserve.kpi_daily_snapshots (
    city_code,
    snapshot_date,
    searches_count,
    page_views,
    intents_created,
    reservations_confirmed,
    gross_revenue,
    commission_earned
)
VALUES (
    'URB',
    CURRENT_DATE,
    100,
    500,
    20,
    5,
    7000.00,
    1050.00
)
ON CONFLICT (city_code, snapshot_date) DO UPDATE SET
    searches_count = EXCLUDED.searches_count,
    page_views = EXCLUDED.page_views,
    intents_created = EXCLUDED.intents_created,
    reservations_confirmed = EXCLUDED.reservations_confirmed,
    gross_revenue = EXCLUDED.gross_revenue,
    commission_earned = EXCLUDED.commission_earned;

-- ============================================
-- 12. ANALYTICS FUNCTIONS
-- ============================================

-- Function to calculate conversion funnel
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
        SELECT 
            'search' as stage,
            COUNT(*) FILTER (WHERE event_name = 'search_performed') as cnt
        FROM reserve.events
        WHERE city_code = p_city_code
          AND created_at::date BETWEEN p_start_date AND p_end_date
        
        UNION ALL
        
        SELECT 
            'property_view',
            COUNT(*) FILTER (WHERE event_name = 'property_viewed')
        FROM reserve.events
        WHERE city_code = p_city_code
          AND created_at::date BETWEEN p_start_date AND p_end_date
        
        UNION ALL
        
        SELECT 
            'intent',
            COUNT(*) FILTER (WHERE event_name = 'booking_intent_created')
        FROM reserve.events
        WHERE city_code = p_city_code
          AND created_at::date BETWEEN p_start_date AND p_end_date
        
        UNION ALL
        
        SELECT 
            'payment',
            COUNT(*) FILTER (WHERE event_name = 'payment_succeeded')
        FROM reserve.events
        WHERE city_code = p_city_code
          AND created_at::date BETWEEN p_start_date AND p_end_date
        
        UNION ALL
        
        SELECT 
            'booking',
            COUNT(*) FILTER (WHERE event_name = 'reservation_confirmed')
        FROM reserve.events
        WHERE city_code = p_city_code
          AND created_at::date BETWEEN p_start_date AND p_end_date
    )
    SELECT 
        f.stage,
        f.cnt,
        CASE 
            WHEN LAG(f.cnt) OVER (ORDER BY CASE f.stage 
                WHEN 'search' THEN 1 
                WHEN 'property_view' THEN 2 
                WHEN 'intent' THEN 3 
                WHEN 'payment' THEN 4 
                WHEN 'booking' THEN 5 
            END) > 0 
            THEN ROUND((f.cnt::decimal / LAG(f.cnt) OVER (ORDER BY CASE f.stage 
                WHEN 'search' THEN 1 
                WHEN 'property_view' THEN 2 
                WHEN 'intent' THEN 3 
                WHEN 'payment' THEN 4 
                WHEN 'booking' THEN 5 
            END)) * 100, 2)
            ELSE NULL
        END as conversion_rate
    FROM funnel f
    ORDER BY CASE f.stage 
        WHEN 'search' THEN 1 
        WHEN 'property_view' THEN 2 
        WHEN 'intent' THEN 3 
        WHEN 'payment' THEN 4 
        WHEN 'booking' THEN 5 
    END;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.get_conversion_funnel IS 'Calculates conversion funnel metrics';

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 'Migration 005: Analytics & Marketing completed successfully' as status;

SELECT 
    'events' as table_name, COUNT(*) as count FROM reserve.events
UNION ALL
SELECT 'reviews', COUNT(*) FROM reserve.reviews
UNION ALL
SELECT 'review_invitations', COUNT(*) FROM reserve.review_invitations
UNION ALL
SELECT 'ads_slots', COUNT(*) FROM reserve.ads_slots
UNION ALL
SELECT 'ads_campaigns', COUNT(*) FROM reserve.ads_campaigns
UNION ALL
SELECT 'kpi_daily_snapshots', COUNT(*) FROM reserve.kpi_daily_snapshots;

-- Test conversion funnel
SELECT * FROM reserve.get_conversion_funnel('URB', CURRENT_DATE - 7, CURRENT_DATE);
