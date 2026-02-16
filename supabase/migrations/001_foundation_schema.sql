-- ============================================
-- MIGRATION 001: Foundation Schema
-- Description: Cities, mappings, properties, units, availability
-- Version: 1.0
-- Date: 2026-02-16
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 1. ENUMS (if not exists)
-- ============================================

DO $$ BEGIN
    CREATE TYPE reserve.payment_status AS ENUM ('pending', 'partial', 'paid', 'refunded', 'failed');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE reserve.reservation_status AS ENUM ('pending', 'confirmed', 'checked_in', 'checked_out', 'cancelled', 'no_show');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE reserve.reservation_source AS ENUM ('direct', 'booking_com', 'airbnb', 'expedia', 'other_ota');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE reserve.sync_direction AS ENUM ('push_to_host', 'pull_from_host', 'bidirectional');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE reserve.sync_status AS ENUM ('pending', 'in_progress', 'completed', 'failed', 'retrying');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE reserve.event_severity AS ENUM ('info', 'warning', 'error', 'critical');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE reserve.funnel_stage AS ENUM ('page_view', 'search', 'view_item', 'lead', 'checkout', 'purchase', 'abandon');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- ============================================
-- 2. CITIES TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.cities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    state_province VARCHAR(100),
    country VARCHAR(100) DEFAULT 'Brazil',
    timezone VARCHAR(50) DEFAULT 'America/Sao_Paulo',
    currency VARCHAR(3) DEFAULT 'BRL',
    is_active BOOLEAN DEFAULT true,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.cities IS 'Master city data for multi-tenancy';
COMMENT ON COLUMN reserve.cities.code IS 'Unique city code (e.g., URB, SAO, RIO)';

-- Seed pilot city (Urubici)
INSERT INTO reserve.cities (code, name, state_province)
VALUES ('URB', 'Urubici', 'SC')
ON CONFLICT (code) DO NOTHING;

-- ============================================
-- 3. CITY-SITE MAPPINGS (Reserve ↔ Portal)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.city_site_mappings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_id UUID NOT NULL REFERENCES reserve.cities(id) ON DELETE CASCADE,
    portal_site_id UUID,
    city_code VARCHAR(10) NOT NULL,
    site_slug TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(city_id, portal_site_id),
    UNIQUE(city_code, site_slug)
);

COMMENT ON TABLE reserve.city_site_mappings IS 'Maps Reserve city codes to Portal site slugs';

-- Seed mapping for Urubici
INSERT INTO reserve.city_site_mappings (city_id, city_code, site_slug)
SELECT id, 'URB', 'urubici' FROM reserve.cities WHERE code = 'URB'
ON CONFLICT (city_code, site_slug) DO NOTHING;

-- ============================================
-- 4. PROPERTIES MAP (synced from Host)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.properties_map (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host_property_id UUID NOT NULL,
    city_id UUID NOT NULL REFERENCES reserve.cities(id),
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) UNIQUE NOT NULL,
    description TEXT,
    property_type VARCHAR(50),
    address_line_1 VARCHAR(255),
    city VARCHAR(100),
    state_province VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100) DEFAULT 'Brazil',
    latitude NUMERIC(10,8),
    longitude NUMERIC(11,8),
    phone VARCHAR(50),
    email VARCHAR(255),
    website VARCHAR(500),
    amenities_cached JSONB DEFAULT '[]',
    images_cached JSONB DEFAULT '[]',
    rating_cached NUMERIC(2,1),
    review_count_cached INTEGER DEFAULT 0,
    host_last_synced_at TIMESTAMPTZ,
    host_data_hash VARCHAR(64),
    is_active BOOLEAN DEFAULT true,
    is_published BOOLEAN DEFAULT false,
    deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.properties_map IS 'Synced property cache from Host Connect';
COMMENT ON COLUMN reserve.properties_map.host_property_id IS 'Canonical FK to Host properties.id';
COMMENT ON COLUMN reserve.properties_map.slug IS 'Canonical URL identifier';
COMMENT ON COLUMN reserve.properties_map.is_published IS 'Manual approval gate for public visibility';

-- Indexes for properties_map
CREATE INDEX IF NOT EXISTS idx_properties_map_city ON reserve.properties_map(city_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_properties_map_slug ON reserve.properties_map(slug) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_properties_map_host ON reserve.properties_map(host_property_id);
CREATE INDEX IF NOT EXISTS idx_properties_map_active ON reserve.properties_map(is_active, is_published) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_properties_map_geo ON reserve.properties_map USING gist (point(longitude, latitude)) WHERE deleted_at IS NULL;

-- ============================================
-- 5. UNIT MAP (synced room types from Host)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.unit_map (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host_unit_id UUID NOT NULL,
    property_id UUID NOT NULL REFERENCES reserve.properties_map(id) ON DELETE CASCADE,
    host_property_id UUID,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) NOT NULL,
    unit_type VARCHAR(50),
    description TEXT,
    max_occupancy INTEGER NOT NULL DEFAULT 2,
    base_capacity INTEGER NOT NULL DEFAULT 2,
    size_sqm INTEGER,
    bed_configuration JSONB DEFAULT '[]',
    amenities_cached JSONB DEFAULT '[]',
    images_cached JSONB DEFAULT '[]',
    is_active BOOLEAN DEFAULT true,
    host_last_synced_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(property_id, slug)
);

COMMENT ON TABLE reserve.unit_map IS 'Synced room types from Host Connect';
COMMENT ON COLUMN reserve.unit_map.host_unit_id IS 'Canonical FK to Host room_types.id';

-- Indexes for unit_map
CREATE INDEX IF NOT EXISTS idx_unit_map_property ON reserve.unit_map(property_id);
CREATE INDEX IF NOT EXISTS idx_unit_map_host ON reserve.unit_map(host_unit_id);

-- ============================================
-- 6. RATE PLANS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.rate_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL REFERENCES reserve.properties_map(id) ON DELETE CASCADE,
    host_rate_plan_id UUID,
    name VARCHAR(200) NOT NULL,
    code VARCHAR(50),
    is_default BOOLEAN DEFAULT false,
    channels_enabled JSONB DEFAULT '["direct"]',
    min_stay_nights INTEGER DEFAULT 1,
    max_stay_nights INTEGER,
    advance_booking_days INTEGER,
    cancellation_policy_code VARCHAR(50),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.rate_plans IS 'Pricing rules and rate plans per property';

-- Indexes for rate_plans
CREATE INDEX IF NOT EXISTS idx_rate_plans_property ON reserve.rate_plans(property_id) WHERE is_active = true;

-- ============================================
-- 7. AVAILABILITY CALENDAR (365-day cache)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.availability_calendar (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    unit_id UUID NOT NULL REFERENCES reserve.unit_map(id) ON DELETE CASCADE,
    rate_plan_id UUID NOT NULL REFERENCES reserve.rate_plans(id),
    date DATE NOT NULL,
    is_available BOOLEAN DEFAULT true,
    is_blocked BOOLEAN DEFAULT false,
    block_reason VARCHAR(100),
    min_stay_override INTEGER,
    base_price NUMERIC(12,2) NOT NULL,
    discounted_price NUMERIC(12,2),
    currency VARCHAR(3) DEFAULT 'BRL',
    allotment INTEGER DEFAULT 1,
    bookings_count INTEGER DEFAULT 0,
    temp_holds INTEGER DEFAULT 0,
    host_last_synced_at TIMESTAMPTZ,
    source_system VARCHAR(50) DEFAULT 'reserve',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(unit_id, rate_plan_id, date)
);

COMMENT ON TABLE reserve.availability_calendar IS 'Daily availability and pricing cache (365 days ahead)';
COMMENT ON COLUMN reserve.availability_calendar.temp_holds IS 'Soft holds during booking intent (TTL-based)';

-- Indexes for availability_calendar
CREATE INDEX IF NOT EXISTS idx_availability_unit_date ON reserve.availability_calendar(unit_id, date);
CREATE INDEX IF NOT EXISTS idx_availability_search ON reserve.availability_calendar(date, is_available, is_blocked) WHERE is_available = true AND is_blocked = false;
CREATE INDEX IF NOT EXISTS idx_availability_property ON reserve.availability_calendar(unit_id, date, is_available, is_blocked);

-- ============================================
-- 8. RLS POLICIES
-- ============================================

-- Enable RLS
ALTER TABLE reserve.cities ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.properties_map ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.unit_map ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.rate_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.availability_calendar ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.city_site_mappings ENABLE ROW LEVEL SECURITY;

-- Cities: readable by all
CREATE POLICY IF NOT EXISTS cities_public_read ON reserve.cities
    FOR SELECT USING (true);

CREATE POLICY IF NOT EXISTS cities_service_all ON reserve.cities
    FOR ALL TO service_role USING (true);

-- Properties: public can read published, active properties
CREATE POLICY IF NOT EXISTS properties_public_read ON reserve.properties_map
    FOR SELECT USING (is_active = true AND is_published = true AND deleted_at IS NULL);

CREATE POLICY IF NOT EXISTS properties_service_all ON reserve.properties_map
    FOR ALL TO service_role USING (true);

-- Units: public can read units of published properties
CREATE POLICY IF NOT EXISTS units_public_read ON reserve.unit_map
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM reserve.properties_map p 
            WHERE p.id = unit_map.property_id 
            AND p.is_active = true AND p.is_published = true AND p.deleted_at IS NULL
        )
    );

CREATE POLICY IF NOT EXISTS units_service_all ON reserve.unit_map
    FOR ALL TO service_role USING (true);

-- Rate plans: public can read active plans of published properties
CREATE POLICY IF NOT EXISTS rate_plans_public_read ON reserve.rate_plans
    FOR SELECT USING (
        is_active = true AND
        EXISTS (
            SELECT 1 FROM reserve.properties_map p 
            WHERE p.id = rate_plans.property_id 
            AND p.is_active = true AND p.is_published = true AND p.deleted_at IS NULL
        )
    );

CREATE POLICY IF NOT EXISTS rate_plans_service_all ON reserve.rate_plans
    FOR ALL TO service_role USING (true);

-- Availability: public can read available slots
CREATE POLICY IF NOT EXISTS availability_public_read ON reserve.availability_calendar
    FOR SELECT USING (is_available = true AND is_blocked = false);

CREATE POLICY IF NOT EXISTS availability_service_all ON reserve.availability_calendar
    FOR ALL TO service_role USING (true);

-- City site mappings: service only
CREATE POLICY IF NOT EXISTS city_mappings_service_all ON reserve.city_site_mappings
    FOR ALL TO service_role USING (true);

-- ============================================
-- 9. TRIGGERS FOR UPDATED_AT
-- ============================================

CREATE OR REPLACE FUNCTION reserve.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at trigger to all tables
DO $$
DECLARE
    tbl text;
    tables text[] := ARRAY[
        'cities',
        'properties_map',
        'unit_map',
        'rate_plans',
        'availability_calendar',
        'city_site_mappings'
    ];
BEGIN
    FOREACH tbl IN ARRAY tables
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS trg_%I_updated_at ON reserve.%I', tbl, tbl);
        EXECUTE format('CREATE TRIGGER trg_%I_updated_at BEFORE UPDATE ON reserve.%I FOR EACH ROW EXECUTE FUNCTION reserve.update_updated_at_column()', tbl, tbl);
    END LOOP;
END $$;

-- ============================================
-- 10. SEED DATA FOR TESTING
-- ============================================

-- Create test property (will be overwritten by Host sync)
INSERT INTO reserve.properties_map (
    host_property_id,
    city_id,
    name,
    slug,
    description,
    property_type,
    city,
    state_province,
    is_active,
    is_published
)
SELECT 
    '00000000-0000-0000-0000-000000000001'::uuid,
    id,
    'Pousada Teste Urubici',
    'pousada-teste-urb',
    'Propriedade de teste para desenvolvimento',
    'pousada',
    'Urubici',
    'SC',
    true,
    true
FROM reserve.cities WHERE code = 'URB'
ON CONFLICT (slug) DO NOTHING;

-- Create test unit
INSERT INTO reserve.unit_map (
    host_unit_id,
    property_id,
    host_property_id,
    name,
    slug,
    unit_type,
    max_occupancy,
    base_capacity
)
SELECT 
    '00000000-0000-0000-0000-000000000001'::uuid,
    id,
    '00000000-0000-0000-0000-000000000001'::uuid,
    'Quarto Standard',
    'quarto-standard',
    'standard',
    2,
    2
FROM reserve.properties_map WHERE slug = 'pousada-teste-urb'
ON CONFLICT (property_id, slug) DO NOTHING;

-- Create default rate plan
INSERT INTO reserve.rate_plans (
    property_id,
    name,
    code,
    is_default,
    is_active
)
SELECT 
    id,
    'Tarifa Padrão',
    'STANDARD',
    true,
    true
FROM reserve.properties_map WHERE slug = 'pousada-teste-urb'
ON CONFLICT DO NOTHING;

-- Populate availability for next 30 days (test data)
INSERT INTO reserve.availability_calendar (
    unit_id,
    rate_plan_id,
    date,
    is_available,
    base_price,
    currency
)
SELECT 
    u.id,
    rp.id,
    d.date,
    true,
    350.00,
    'BRL'
FROM reserve.unit_map u
CROSS JOIN reserve.rate_plans rp
CROSS JOIN generate_series(
    CURRENT_DATE, 
    CURRENT_DATE + INTERVAL '30 days', 
    INTERVAL '1 day'
) AS d(date)
WHERE u.slug = 'quarto-standard'
  AND rp.code = 'STANDARD'
ON CONFLICT (unit_id, rate_plan_id, date) DO NOTHING;

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 'Migration 001: Foundation Schema completed successfully' as status;

-- Verify counts
SELECT 
    'cities' as table_name, COUNT(*) as count FROM reserve.cities
UNION ALL
SELECT 'properties_map', COUNT(*) FROM reserve.properties_map
UNION ALL
SELECT 'unit_map', COUNT(*) FROM reserve.unit_map
UNION ALL
SELECT 'rate_plans', COUNT(*) FROM reserve.rate_plans
UNION ALL
SELECT 'availability_calendar', COUNT(*) FROM reserve.availability_calendar
UNION ALL
SELECT 'city_site_mappings', COUNT(*) FROM reserve.city_site_mappings;
