-- ============================================
-- MIGRATION 003: Financial Module (MoR)
-- Description: Payments, ledger, payouts
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
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    
    -- Payment details
    payment_method VARCHAR(20) NOT NULL,
    CONSTRAINT valid_payment_method CHECK (payment_method IN ('stripe_card', 'pix', 'stripe_boleto')),
    gateway VARCHAR(50) NOT NULL,
    CONSTRAINT valid_gateway CHECK (gateway IN ('stripe', 'mercadopago', 'openpix', 'pagar_me')),
    gateway_payment_id VARCHAR(100) NOT NULL,
    gateway_charge_id VARCHAR(100),
    
    -- Amounts
    currency VARCHAR(3) DEFAULT 'BRL',
    amount NUMERIC(12,2) NOT NULL,
    gateway_fee NUMERIC(12,2) DEFAULT 0,
    tax_amount NUMERIC(12,2) DEFAULT 0,
    
    -- Status
    status VARCHAR(50) DEFAULT 'pending',
    CONSTRAINT valid_payment_status CHECK (status IN (
        'pending', 
        'processing',
        'succeeded', 
        'failed', 
        'cancelled', 
        'expired',
        'refund_pending',
        'refunded', 
        'partially_refunded',
        'disputed',
        'dispute_won',
        'dispute_lost'
    )),
    refunded_amount NUMERIC(12,2) DEFAULT 0,
    
    -- PIX-specific
    pix_qr_code TEXT,
    pix_copy_paste_key TEXT,
    pix_expires_at TIMESTAMPTZ,
    
    -- Stripe-specific
    stripe_client_secret VARCHAR(255),
    stripe_payment_method_id VARCHAR(100),
    
    -- Metadata
    idempotency_key VARCHAR(100) UNIQUE,
    metadata JSONB DEFAULT '{}',
    
    -- Timestamps
    succeeded_at TIMESTAMPTZ,
    failed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    refunded_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.payments IS 'Payment transactions (Stripe + PIX)';
COMMENT ON COLUMN reserve.payments.gateway_payment_id IS 'Stripe PaymentIntent ID or PIX txid';
COMMENT ON COLUMN reserve.payments.tax_amount IS 'IOF 0.38% for PIX in Brazil';
COMMENT ON COLUMN reserve.payments.idempotency_key IS 'Prevents duplicate payments (24h TTL)';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_payments_reservation ON reserve.payments(reservation_id);
CREATE INDEX IF NOT EXISTS idx_payments_intent ON reserve.payments(booking_intent_id);
CREATE INDEX IF NOT EXISTS idx_payments_gateway ON reserve.payments(gateway_payment_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON reserve.payments(status, created_at);
CREATE INDEX IF NOT EXISTS idx_payments_city ON reserve.payments(city_code, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_payments_idempotency ON reserve.payments(idempotency_key);

-- ============================================
-- 2. LEDGER ENTRIES (Double-Entry Accounting)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.ledger_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id UUID NOT NULL,
    entry_type VARCHAR(50) NOT NULL,
    CONSTRAINT valid_entry_type CHECK (entry_type IN (
        'payment_received',
        'payment_failed',
        'commission_taken',
        'payout_due',
        'payout_transferred',
        'refund_processed',
        'refund_reversed',
        'gateway_fee',
        'tax_withheld',
        'adjustment',
        'chargeback',
        'chargeback_reversed'
    )),
    
    -- References
    booking_id UUID REFERENCES reserve.reservations(id),
    property_id UUID REFERENCES reserve.properties_map(id),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    payment_id UUID REFERENCES reserve.payments(id),
    payout_id UUID,
    
    -- Double-entry
    account VARCHAR(50) NOT NULL,
    CONSTRAINT valid_account CHECK (account IN (
        'cash_reserve',
        'merchant_account',
        'payouts_receivable',
        'gateway_fees_receivable',
        'customer_deposits',
        'refunds_payable',
        'commissions_payable',
        'commission_revenue',
        'gateway_fee_expense',
        'tax_payable',
        'service_revenue'
    )),
    counterparty VARCHAR(50),
    CONSTRAINT valid_counterparty CHECK (counterparty IN (
        'customer',
        'owner',
        'gateway',
        'tax_authority',
        'vendor'
    )),
    direction VARCHAR(10) NOT NULL CHECK (direction IN ('debit', 'credit')),
    amount NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
    
    -- Context
    description TEXT,
    metadata JSONB DEFAULT '{}',
    
    -- Audit
    created_at TIMESTAMPTZ DEFAULT NOW(),
    created_by UUID
);

COMMENT ON TABLE reserve.ledger_entries IS 'Double-entry accounting ledger (MoR financial tracking)';
COMMENT ON COLUMN reserve.ledger_entries.transaction_id IS 'Groups debits and credits together';
COMMENT ON COLUMN reserve.ledger_entries.direction IS 'debit = + for assets, - for liabilities | credit = opposite';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_ledger_transaction ON reserve.ledger_entries(transaction_id);
CREATE INDEX IF NOT EXISTS idx_ledger_booking ON reserve.ledger_entries(booking_id);
CREATE INDEX IF NOT EXISTS idx_ledger_city ON reserve.ledger_entries(city_code, created_at);
CREATE INDEX IF NOT EXISTS idx_ledger_account ON reserve.ledger_entries(account, created_at);
CREATE INDEX IF NOT EXISTS idx_ledger_entry_type ON reserve.ledger_entries(entry_type, created_at);
CREATE INDEX IF NOT EXISTS idx_ledger_payment ON reserve.ledger_entries(payment_id);

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

COMMENT ON TABLE reserve.commission_tiers IS 'Commission rate rules by city/property/volume';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_commission_tiers_city ON reserve.commission_tiers(city_code, is_active);
CREATE INDEX IF NOT EXISTS idx_commission_tiers_property ON reserve.commission_tiers(property_id);

-- Seed default commissions
INSERT INTO reserve.commission_tiers (city_code, name, commission_rate, min_properties, max_properties)
VALUES 
    ('URB', 'Standard Rate', 0.15, 0, 10),
    ('URB', 'Volume Discount 10+', 0.12, 11, 50),
    ('URB', 'Volume Discount 50+', 0.10, 51, NULL)
ON CONFLICT DO NOTHING;

-- ============================================
-- 4. PAYOUT SCHEDULES
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.payout_schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type VARCHAR(20) NOT NULL,
    CONSTRAINT valid_entity_type CHECK (entity_type IN ('owner', 'property')),
    entity_id UUID NOT NULL,
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    frequency VARCHAR(20) DEFAULT 'weekly',
    CONSTRAINT valid_frequency CHECK (frequency IN ('weekly', 'biweekly', 'monthly', 'on_checkout')),
    day_of_week INTEGER CHECK (day_of_week BETWEEN 0 AND 6),
    day_of_month INTEGER CHECK (day_of_month BETWEEN 1 AND 31),
    min_threshold NUMERIC(12,2) DEFAULT 0,
    hold_days INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(entity_type, entity_id)
);

COMMENT ON TABLE reserve.payout_schedules IS 'Owner/property payout schedule configuration';
COMMENT ON COLUMN reserve.payout_schedules.day_of_week IS '0=Sunday for weekly/biweekly';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_payout_schedules_entity ON reserve.payout_schedules(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_payout_schedules_city ON reserve.payout_schedules(city_code, is_active);

-- Seed default schedule for test property
INSERT INTO reserve.payout_schedules (entity_type, entity_id, city_code, frequency, day_of_week)
SELECT 
    'property',
    id,
    'URB',
    'weekly',
    1  -- Monday
FROM reserve.properties_map WHERE slug = 'pousada-teste-urb'
ON CONFLICT DO NOTHING;

-- ============================================
-- 5. PAYOUT BATCHES
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.payout_batches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_date DATE NOT NULL,
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    status VARCHAR(50) DEFAULT 'pending',
    CONSTRAINT valid_batch_status CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'cancelled')),
    total_amount NUMERIC(12,2) DEFAULT 0,
    total_payouts INTEGER DEFAULT 0,
    total_properties INTEGER DEFAULT 0,
    processed_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    error_message TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.payout_batches IS 'Weekly payout batch processing';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_payout_batches_date ON reserve.payout_batches(batch_date);
CREATE INDEX IF NOT EXISTS idx_payout_batches_city ON reserve.payout_batches(city_code, status);

-- ============================================
-- 6. PAYOUTS (to property owners)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.payouts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_id UUID REFERENCES reserve.payout_batches(id),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    property_id UUID NOT NULL REFERENCES reserve.properties_map(id),
    owner_id UUID,
    
    -- Financial breakdown
    currency VARCHAR(3) DEFAULT 'BRL',
    gross_amount NUMERIC(12,2) NOT NULL,
    commission_amount NUMERIC(12,2) NOT NULL,
    fee_amount NUMERIC(12,2) DEFAULT 0,
    tax_amount NUMERIC(12,2) DEFAULT 0,
    net_amount NUMERIC(12,2) NOT NULL,
    
    -- Status
    status VARCHAR(50) DEFAULT 'pending',
    CONSTRAINT valid_payout_status CHECK (status IN ('pending', 'processing', 'transferred', 'completed', 'failed', 'cancelled')),
    gateway_reference VARCHAR(100),
    gateway_transfer_id VARCHAR(100),
    
    -- References
    reservation_ids JSONB DEFAULT '[]',
    booking_count INTEGER DEFAULT 0,
    
    -- Banking (encrypted in production)
    bank_details JSONB,
    
    -- Timestamps
    processed_at TIMESTAMPTZ,
    transferred_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.payouts IS 'Individual owner payouts';
COMMENT ON COLUMN reserve.payouts.net_amount IS 'Gross - Commission - Fees - Tax (what owner receives)';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_payouts_batch ON reserve.payouts(batch_id);
CREATE INDEX IF NOT EXISTS idx_payouts_property ON reserve.payouts(property_id, status);
CREATE INDEX IF NOT EXISTS idx_payouts_city ON reserve.payouts(city_code, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_payouts_status ON reserve.payouts(status, created_at);

-- ============================================
-- 7. RLS POLICIES
-- ============================================

ALTER TABLE reserve.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.ledger_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.commission_tiers ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.payout_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.payout_batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.payouts ENABLE ROW LEVEL SECURITY;

-- All financial tables: service role only
CREATE POLICY IF NOT EXISTS payments_service_all ON reserve.payments FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS ledger_service_all ON reserve.ledger_entries FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS commission_tiers_public_read ON reserve.commission_tiers FOR SELECT USING (true);
CREATE POLICY IF NOT EXISTS commission_tiers_service_all ON reserve.commission_tiers FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS payout_schedules_service_all ON reserve.payout_schedules FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS payout_batches_service_all ON reserve.payout_batches FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS payouts_service_all ON reserve.payouts FOR ALL TO service_role USING (true);

-- ============================================
-- 8. TRIGGERS
-- ============================================

DO $$
DECLARE
    tbl text;
    tables text[] := ARRAY['payments', 'ledger_entries', 'commission_tiers', 'payout_schedules', 'payout_batches', 'payouts'];
BEGIN
    FOREACH tbl IN ARRAY tables
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS trg_%I_updated_at ON reserve.%I', tbl, tbl);
        EXECUTE format('CREATE TRIGGER trg_%I_updated_at BEFORE UPDATE ON reserve.%I FOR EACH ROW EXECUTE FUNCTION reserve.update_updated_at_column()', tbl, tbl);
    END LOOP;
END $$;

-- ============================================
-- 9. LEDGER BALANCE VERIFICATION FUNCTION
-- ============================================

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

COMMENT ON FUNCTION reserve.verify_ledger_balance IS 'Verifies that debits = credits for a transaction';

-- ============================================
-- 10. SEED DATA
-- ============================================

-- Create test payment
INSERT INTO reserve.payments (
    reservation_id,
    city_code,
    payment_method,
    gateway,
    gateway_payment_id,
    amount,
    gateway_fee,
    status,
    succeeded_at
)
SELECT 
    r.id,
    'URB',
    'stripe_card',
    'stripe',
    'pi_test_001',
    1400.00,
    40.60,
    'succeeded',
    NOW()
FROM reserve.reservations r
WHERE r.confirmation_code = 'RES-2026-TEST01'
ON CONFLICT DO NOTHING;

-- Create ledger entries for test payment
DO $$
DECLARE
    v_payment_id UUID;
    v_booking_id UUID;
    v_property_id UUID;
    v_transaction_id UUID := gen_random_uuid();
BEGIN
    SELECT p.id, p.reservation_id, r.property_id 
    INTO v_payment_id, v_booking_id, v_property_id
    FROM reserve.payments p
    JOIN reserve.reservations r ON r.id = p.reservation_id
    WHERE p.gateway_payment_id = 'pi_test_001';
    
    IF v_payment_id IS NOT NULL THEN
        -- Entry 1: Payment Received (Debit cash, Credit customer deposits)
        INSERT INTO reserve.ledger_entries (transaction_id, entry_type, booking_id, property_id, city_code, payment_id, account, counterparty, direction, amount, description)
        VALUES (v_transaction_id, 'payment_received', v_booking_id, v_property_id, 'URB', v_payment_id, 'cash_reserve', 'customer', 'debit', 1400.00, 'Payment received from customer');
        
        INSERT INTO reserve.ledger_entries (transaction_id, entry_type, booking_id, property_id, city_code, payment_id, account, counterparty, direction, amount, description)
        VALUES (v_transaction_id, 'payment_received', v_booking_id, v_property_id, 'URB', v_payment_id, 'customer_deposits', 'customer', 'credit', 1400.00, 'Customer deposit liability');
        
        -- Entry 2: Gateway Fee
        INSERT INTO reserve.ledger_entries (transaction_id, entry_type, booking_id, property_id, city_code, payment_id, account, counterparty, direction, amount, description)
        VALUES (v_transaction_id, 'gateway_fee', v_booking_id, v_property_id, 'URB', v_payment_id, 'gateway_fee_expense', 'gateway', 'debit', 40.60, 'Stripe processing fee');
        
        INSERT INTO reserve.ledger_entries (transaction_id, entry_type, booking_id, property_id, city_code, payment_id, account, counterparty, direction, amount, description)
        VALUES (v_transaction_id, 'gateway_fee', v_booking_id, v_property_id, 'URB', v_payment_id, 'gateway_fees_receivable', 'gateway', 'credit', 40.60, 'Fee payable to Stripe');
        
        -- Entry 3: Commission
        INSERT INTO reserve.ledger_entries (transaction_id, entry_type, booking_id, property_id, city_code, payment_id, account, counterparty, direction, amount, description)
        VALUES (gen_random_uuid(), 'commission_taken', v_booking_id, v_property_id, 'URB', v_payment_id, 'customer_deposits', 'customer', 'debit', 210.00, 'Commission deducted');
        
        INSERT INTO reserve.ledger_entries (transaction_id, entry_type, booking_id, property_id, city_code, payment_id, account, counterparty, direction, amount, description)
        VALUES (gen_random_uuid(), 'commission_taken', v_booking_id, v_property_id, 'URB', v_payment_id, 'commissions_payable', 'owner', 'credit', 210.00, 'Commission earned');
        
        -- Entry 4: Payout Due
        INSERT INTO reserve.ledger_entries (transaction_id, entry_type, booking_id, property_id, city_code, payment_id, account, counterparty, direction, amount, description)
        VALUES (gen_random_uuid(), 'payout_due', v_booking_id, v_property_id, 'URB', v_payment_id, 'customer_deposits', 'customer', 'debit', 1190.00, 'Owner share (gross - commission)');
        
        INSERT INTO reserve.ledger_entries (transaction_id, entry_type, booking_id, property_id, city_code, payment_id, account, counterparty, direction, amount, description)
        VALUES (gen_random_uuid(), 'payout_due', v_booking_id, v_property_id, 'URB', v_payment_id, 'payouts_receivable', 'owner', 'credit', 1190.00, 'Amount due to property owner');
    END IF;
END $$;

-- Verify ledger balance
SELECT 
    transaction_id,
    reserve.verify_ledger_balance(transaction_id) as is_balanced,
    SUM(amount) FILTER (WHERE direction = 'debit') as debits,
    SUM(amount) FILTER (WHERE direction = 'credit') as credits
FROM reserve.ledger_entries
WHERE created_at > NOW() - INTERVAL '1 minute'
GROUP BY transaction_id;

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 'Migration 003: Financial Module completed successfully' as status;

SELECT 
    'payments' as table_name, COUNT(*) as count FROM reserve.payments
UNION ALL
SELECT 'ledger_entries', COUNT(*) FROM reserve.ledger_entries
UNION ALL
SELECT 'commission_tiers', COUNT(*) FROM reserve.commission_tiers
UNION ALL
SELECT 'payout_schedules', COUNT(*) FROM reserve.payout_schedules
UNION ALL
SELECT 'payout_batches', COUNT(*) FROM reserve.payout_batches
UNION ALL
SELECT 'payouts', COUNT(*) FROM reserve.payouts;
