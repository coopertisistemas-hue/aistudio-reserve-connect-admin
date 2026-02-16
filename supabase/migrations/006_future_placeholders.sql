-- ============================================
-- MIGRATION 006: Future Placeholders (Phase 3+)
-- Description: Owner dashboard, AP/AR, Services
-- Version: 1.0
-- Date: 2026-02-16
-- Note: Tables created but minimal business logic
-- ============================================

-- ============================================
-- 1. PROPERTY OWNERS (for future owner portal)
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
    
    -- Banking (to be encrypted via Vault in production)
    bank_details JSONB,
    
    -- Settings
    default_payout_schedule_id UUID,
    notification_preferences JSONB DEFAULT '{}',
    
    -- Auth
    auth_user_id UUID REFERENCES auth.users(id),
    
    -- Access control
    is_active BOOLEAN DEFAULT true,
    email_verified_at TIMESTAMPTZ,
    last_login_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.property_owners IS 'Property owners for future owner portal (Phase 3)';
COMMENT ON COLUMN reserve.property_owners.bank_details IS 'Encrypted bank account info (use Vault in production)';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_property_owners_email ON reserve.property_owners(email);
CREATE INDEX IF NOT EXISTS idx_property_owners_auth ON reserve.property_owners(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_property_owners_city ON reserve.property_owners(city_code, is_active);

-- ============================================
-- 2. OWNER-PROPERTY MAPPINGS (many-to-many)
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
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(owner_id, property_id)
);

COMMENT ON TABLE reserve.owner_properties IS 'Links owners to properties (many-to-many)';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_owner_properties_owner ON reserve.owner_properties(owner_id);
CREATE INDEX IF NOT EXISTS idx_owner_properties_property ON reserve.owner_properties(property_id);

-- ============================================
-- 3. VENDOR PAYABLES (AP - Accounts Payable)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.vendor_payables (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vendor_id UUID NOT NULL, -- Reference to future service_providers
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    property_id UUID REFERENCES reserve.properties_map(id),
    reservation_id UUID REFERENCES reserve.reservations(id),
    service_order_id UUID,
    
    -- Financial
    amount NUMERIC(12,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'BRL',
    description TEXT,
    due_date DATE,
    
    -- Status
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'scheduled', 'paid', 'cancelled', 'disputed')),
    ledger_entry_id UUID REFERENCES reserve.ledger_entries(id),
    payout_batch_id UUID REFERENCES reserve.payout_batches(id),
    
    -- Approval
    approved_by UUID REFERENCES auth.users(id),
    approved_at TIMESTAMPTZ,
    paid_at TIMESTAMPTZ,
    
    -- Documents
    invoice_number VARCHAR(100),
    invoice_url TEXT,
    nf_e_number VARCHAR(100), -- Brazilian invoice
    
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.vendor_payables IS 'Accounts Payable - obligations to vendors (Phase 3)';
COMMENT ON COLUMN reserve.vendor_payables.nf_e_number IS 'Brazilian electronic invoice number (NF-e)';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_vendor_payables_vendor ON reserve.vendor_payables(vendor_id);
CREATE INDEX IF NOT EXISTS idx_vendor_payables_status ON reserve.vendor_payables(status, due_date);
CREATE INDEX IF NOT EXISTS idx_vendor_payables_city ON reserve.vendor_payables(city_code, status);

-- ============================================
-- 4. RECEIVABLES (AR - Accounts Receivable)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.receivables (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    entity_type VARCHAR(50) NOT NULL CHECK (entity_type IN ('commission', 'service_fee', 'penalty', 'interest', 'other')),
    entity_id UUID NOT NULL,
    
    property_id UUID REFERENCES reserve.properties_map(id),
    amount NUMERIC(12,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'BRL',
    description TEXT,
    due_date DATE,
    
    -- Status
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'invoiced', 'paid', 'overdue', 'written_off', 'disputed')),
    invoice_id UUID,
    ledger_entry_id UUID REFERENCES reserve.ledger_entries(id),
    
    -- Payment tracking
    paid_amount NUMERIC(12,2) DEFAULT 0,
    paid_at TIMESTAMPTZ,
    
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.receivables IS 'Accounts Receivable - amounts owed to Reserve (Phase 3)';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_receivables_entity ON reserve.receivables(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_receivables_status ON reserve.receivables(status, due_date);
CREATE INDEX IF NOT EXISTS idx_receivables_city ON reserve.receivables(city_code, status);

-- ============================================
-- 5. INVOICES (NF-e integration)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_number VARCHAR(100) UNIQUE NOT NULL,
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    recipient_id UUID NOT NULL,
    recipient_type VARCHAR(20) NOT NULL CHECK (recipient_type IN ('owner', 'provider', 'guest')),
    
    -- Invoice details
    invoice_type VARCHAR(20) NOT NULL CHECK (invoice_type IN ('commission', 'service', 'payout_summary', 'fee')),
    amount NUMERIC(12,2) NOT NULL,
    tax_amount NUMERIC(12,2) DEFAULT 0,
    total_amount NUMERIC(12,2) NOT NULL,
    
    -- Status
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'issued', 'sent', 'paid', 'cancelled', 'overdue')),
    
    -- NF-e (Brazil)
    nf_e_number VARCHAR(100),
    nf_e_xml TEXT,
    nf_e_pdf_url TEXT,
    
    -- Dates
    issued_at TIMESTAMPTZ,
    sent_at TIMESTAMPTZ,
    paid_at TIMESTAMPTZ,
    due_date DATE,
    
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.invoices IS 'Invoice records with NF-e support (Phase 3)';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_invoices_number ON reserve.invoices(invoice_number);
CREATE INDEX IF NOT EXISTS idx_invoices_recipient ON reserve.invoices(recipient_type, recipient_id);
CREATE INDEX IF NOT EXISTS idx_invoices_status ON reserve.invoices(status, due_date);

-- ============================================
-- 6. SERVICE PROVIDERS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.service_providers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    
    -- Provider info
    provider_type VARCHAR(50) NOT NULL CHECK (provider_type IN ('laundry', 'cleaning', 'transfer', 'tour', 'food', 'maintenance', 'other')),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    contact_name VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(50),
    whatsapp VARCHAR(50),
    
    -- Address
    address_line_1 VARCHAR(255),
    city VARCHAR(100),
    state_province VARCHAR(100),
    postal_code VARCHAR(20),
    
    -- Banking (encrypted)
    bank_details JSONB,
    
    -- Commission
    commission_rate NUMERIC(5,4),
    payout_schedule_id UUID,
    
    -- Documents
    document_type VARCHAR(50),
    document_number VARCHAR(100),
    
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.service_providers IS 'Service providers for marketplace (Phase 3)';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_service_providers_city ON reserve.service_providers(city_code, provider_type);
CREATE INDEX IF NOT EXISTS idx_service_providers_type ON reserve.service_providers(provider_type, is_active);

-- ============================================
-- 7. SERVICE CATALOG
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.service_catalog (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    property_id UUID REFERENCES reserve.properties_map(id),
    provider_id UUID REFERENCES reserve.service_providers(id),
    
    -- Service details
    service_type VARCHAR(50) NOT NULL CHECK (service_type IN ('laundry', 'cleaning', 'transfer', 'tour', 'food', 'maintenance', 'other')),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Pricing
    pricing_type VARCHAR(20) NOT NULL CHECK (pricing_type IN ('fixed', 'per_night', 'per_guest', 'per_km', 'per_hour')),
    base_price NUMERIC(12,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'BRL',
    min_quantity INTEGER DEFAULT 1,
    max_quantity INTEGER,
    
    -- Availability
    available_days INTEGER[] DEFAULT ARRAY[0,1,2,3,4,5,6], -- 0=Sunday
    available_from TIME,
    available_until TIME,
    
    -- Booking
    advance_booking_hours INTEGER DEFAULT 24,
    cancellation_policy TEXT,
    
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.service_catalog IS 'Available services per property/city (Phase 3)';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_service_catalog_property ON reserve.service_catalog(property_id, is_active);
CREATE INDEX IF NOT EXISTS idx_service_catalog_provider ON reserve.service_catalog(provider_id);
CREATE INDEX IF NOT EXISTS idx_service_catalog_type ON reserve.service_catalog(service_type, city_code);

-- ============================================
-- 8. SERVICE ORDERS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.service_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES reserve.reservations(id),
    property_id UUID NOT NULL REFERENCES reserve.properties_map(id),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    service_id UUID REFERENCES reserve.service_catalog(id),
    provider_id UUID REFERENCES reserve.service_providers(id),
    traveler_id UUID REFERENCES reserve.travelers(id),
    
    -- Status
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'in_progress', 'fulfilled', 'cancelled', 'disputed', 'refunded')),
    
    -- Financial
    quantity INTEGER DEFAULT 1,
    unit_price NUMERIC(12,2) NOT NULL,
    total_amount NUMERIC(12,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'BRL',
    
    -- Scheduling
    scheduled_date DATE,
    scheduled_time TIME,
    fulfilled_at TIMESTAMPTZ,
    
    -- Cancellation
    cancelled_at TIMESTAMPTZ,
    cancellation_reason TEXT,
    cancelled_by VARCHAR(50),
    
    -- References
    ledger_entry_id UUID REFERENCES reserve.ledger_entries(id),
    vendor_payable_id UUID,
    
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.service_orders IS 'Guest service requests (Phase 3)';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_service_orders_reservation ON reserve.service_orders(reservation_id);
CREATE INDEX IF NOT EXISTS idx_service_orders_status ON reserve.service_orders(status, scheduled_date);
CREATE INDEX IF NOT EXISTS idx_service_orders_provider ON reserve.service_orders(provider_id, status);

-- ============================================
-- 9. SERVICE PAYOUTS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.service_payouts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_id UUID NOT NULL REFERENCES reserve.service_providers(id),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    payout_batch_id UUID REFERENCES reserve.payout_batches(id),
    
    -- Financial
    currency VARCHAR(3) DEFAULT 'BRL',
    amount NUMERIC(12,2) NOT NULL,
    order_count INTEGER DEFAULT 0,
    
    -- Period
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    
    -- Status
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
    gateway_reference VARCHAR(100),
    
    -- References
    order_ids JSONB DEFAULT '[]',
    
    processed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.service_payouts IS 'Service provider payouts (Phase 3)';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_service_payouts_provider ON reserve.service_payouts(provider_id, status);
CREATE INDEX IF NOT EXISTS idx_service_payouts_batch ON reserve.service_payouts(payout_batch_id);

-- ============================================
-- 10. RLS POLICIES
-- ============================================

ALTER TABLE reserve.property_owners ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.owner_properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.vendor_payables ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.receivables ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.service_providers ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.service_catalog ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.service_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.service_payouts ENABLE ROW LEVEL SECURITY;

-- Service role has full access to all future tables
CREATE POLICY IF NOT EXISTS property_owners_service_all ON reserve.property_owners FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS owner_properties_service_all ON reserve.owner_properties FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS vendor_payables_service_all ON reserve.vendor_payables FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS receivables_service_all ON reserve.receivables FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS invoices_service_all ON reserve.invoices FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS service_providers_service_all ON reserve.service_providers FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS service_catalog_service_all ON reserve.service_catalog FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS service_orders_service_all ON reserve.service_orders FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS service_payouts_service_all ON reserve.service_payouts FOR ALL TO service_role USING (true);

-- ============================================
-- 11. TRIGGERS
-- ============================================

DO $$
DECLARE
    tbl text;
    tables text[] := ARRAY[
        'property_owners',
        'owner_properties',
        'vendor_payables',
        'receivables',
        'invoices',
        'service_providers',
        'service_catalog',
        'service_orders',
        'service_payouts'
    ];
BEGIN
    FOREACH tbl IN ARRAY tables
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS trg_%I_updated_at ON reserve.%I', tbl, tbl);
        EXECUTE format('CREATE TRIGGER trg_%I_updated_at BEFORE UPDATE ON reserve.%I FOR EACH ROW EXECUTE FUNCTION reserve.update_updated_at_column()', tbl, tbl);
    END LOOP;
END $$;

-- ============================================
-- 12. SEED DATA
-- ============================================

-- Create test owner
INSERT INTO reserve.property_owners (
    city_code,
    email,
    first_name,
    last_name,
    phone
)
VALUES (
    'URB',
    'owner@example.com',
    'João',
    'Proprietário',
    '+5511988888888'
)
ON CONFLICT (email) DO NOTHING;

-- Link owner to test property
INSERT INTO reserve.owner_properties (owner_id, property_id, is_primary_owner)
SELECT 
    po.id,
    p.id,
    true
FROM reserve.property_owners po
CROSS JOIN reserve.properties_map p
WHERE po.email = 'owner@example.com'
  AND p.slug = 'pousada-teste-urb'
ON CONFLICT DO NOTHING;

-- Create test service provider
INSERT INTO reserve.service_providers (
    city_code,
    provider_type,
    name,
    email,
    phone
)
VALUES (
    'URB',
    'transfer',
    'Urubici Transfer',
    'transfer@example.com',
    '+5511977777777'
)
ON CONFLICT DO NOTHING;

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 'Migration 006: Future Placeholders completed successfully' as status;

SELECT 
    'property_owners' as table_name, COUNT(*) as count FROM reserve.property_owners
UNION ALL
SELECT 'owner_properties', COUNT(*) FROM reserve.owner_properties
UNION ALL
SELECT 'vendor_payables', COUNT(*) FROM reserve.vendor_payables
UNION ALL
SELECT 'receivables', COUNT(*) FROM reserve.receivables
UNION ALL
SELECT 'invoices', COUNT(*) FROM reserve.invoices
UNION ALL
SELECT 'service_providers', COUNT(*) FROM reserve.service_providers
UNION ALL
SELECT 'service_catalog', COUNT(*) FROM reserve.service_catalog
UNION ALL
SELECT 'service_orders', COUNT(*) FROM reserve.service_orders
UNION ALL
SELECT 'service_payouts', COUNT(*) FROM reserve.service_payouts;

-- ============================================
-- FINAL VERIFICATION - ALL TABLES
-- ============================================

SELECT 
    'TOTAL TABLES CREATED' as metric,
    COUNT(*)::text as value
FROM information_schema.tables 
WHERE table_schema = 'reserve';

SELECT 
    'TABLES WITH DATA' as metric,
    COUNT(DISTINCT tablename)::text as value
FROM pg_tables t
JOIN pg_stat_user_tables s ON s.relname = t.tablename
WHERE t.schemaname = 'reserve'
  AND s.n_live_tup > 0;
