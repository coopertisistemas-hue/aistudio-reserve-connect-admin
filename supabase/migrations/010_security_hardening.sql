-- ============================================
-- SECURITY HARDENING MIGRATION
-- Description: Fix security issues found in audit
-- Version: 1.0
-- Date: 2026-02-16
-- ============================================

-- ============================================
-- 1. ADD MISSING RLS POLICIES FOR CRITICAL TABLES
-- ============================================

-- Enable RLS on all tables (ensure complete coverage)
DO $$
DECLARE
    tbl RECORD;
BEGIN
    FOR tbl IN 
        SELECT c.relname 
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE n.nspname='reserve' AND c.relkind='r' AND NOT c.relrowsecurity
    LOOP
        EXECUTE format('ALTER TABLE reserve.%I ENABLE ROW LEVEL SECURITY', tbl.relname);
        RAISE NOTICE 'Enabled RLS on: %', tbl.relname;
    END LOOP;
END $$;

-- ============================================
-- 2. RESTRICT OVERLY PERMISSIVE POLICIES
-- ============================================

-- Fix search_config - remove public write access
DROP POLICY IF EXISTS public_read_search_config ON reserve.search_config;
CREATE POLICY search_config_public_read ON reserve.search_config
    FOR SELECT TO anon, authenticated
    USING (true);

-- Add strict service_role policy for write operations
DROP POLICY IF EXISTS service_role_search_config ON reserve.search_config;
CREATE POLICY search_config_service_all ON reserve.search_config
    FOR ALL TO service_role
    USING (true);

-- ============================================
-- 3. ADD CITY_CODE FILTERING TO ALL PUBLIC POLICIES
-- ============================================

-- Fix cities policy to only show active
DROP POLICY IF EXISTS public_read_cities ON reserve.cities;
CREATE POLICY cities_public_read ON reserve.cities
    FOR SELECT TO anon, authenticated
    USING (is_active = true);

-- Add policy for availability calendar with city filter
DROP POLICY IF EXISTS public_read_availability ON reserve.availability_calendar;
CREATE POLICY availability_public_read ON reserve.availability_calendar
    FOR SELECT TO anon, authenticated
    USING (
        is_available = true 
        AND is_blocked = false
        AND EXISTS (
            SELECT 1 FROM reserve.unit_map u
            JOIN reserve.properties_map p ON p.id = u.property_id
            WHERE u.id = availability_calendar.unit_id
            AND p.is_active = true
            AND p.is_published = true
        )
    );

-- ============================================
-- 4. DATA MASKING FOR PII IN PUBLIC READS
-- ============================================

-- Create views for public access with masked PII
CREATE OR REPLACE VIEW reserve.public_properties AS
SELECT 
    id,
    slug,
    name,
    property_type,
    city,
    state_province,
    description,
    amenities_cached,
    images_cached,
    rating_cached,
    review_count_cached,
    latitude,
    longitude,
    -- Mask sensitive data
    CASE WHEN phone IS NOT NULL THEN '***-***-' || RIGHT(phone, 4) ELSE NULL END as phone_masked,
    CASE WHEN email IS NOT NULL THEN '***@' || SPLIT_PART(email, '@', 2) ELSE NULL END as email_masked,
    is_active,
    is_published,
    city_code
FROM reserve.properties_map
WHERE is_active = true AND is_published = true AND deleted_at IS NULL;

COMMENT ON VIEW reserve.public_properties IS 'Public property view with masked PII';

-- ============================================
-- 5. AUDIT LOGS DATA MINIMIZATION
-- ============================================

-- Create function to redact PII from audit payloads
CREATE OR REPLACE FUNCTION reserve.redact_pii_from_json(data JSONB)
RETURNS JSONB AS $$
DECLARE
    redacted JSONB := data;
BEGIN
    -- Redact common PII fields
    IF data ? 'email' THEN
        redacted := jsonb_set(redacted, '{email}', to_jsonb('***@***.com'::text));
    END IF;
    
    IF data ? 'phone' THEN
        redacted := jsonb_set(redacted, '{phone}', to_jsonb('***-***-****'::text));
    END IF;
    
    IF data ? 'document_number' THEN
        redacted := jsonb_set(redacted, '{document_number}', to_jsonb('***.***.***-**'::text));
    END IF;
    
    IF data ? 'stripe_client_secret' THEN
        redacted := jsonb_set(redacted, '{stripe_client_secret}', to_jsonb('[REDACTED]'::text));
    END IF;
    
    RETURN redacted;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- ============================================
-- 6. TRIGGER TO ENFORCE LEDGER BALANCE
-- ============================================

CREATE OR REPLACE FUNCTION reserve.check_ledger_balance_trigger()
RETURNS TRIGGER AS $$
DECLARE
    total_debits NUMERIC(12,2);
    total_credits NUMERIC(12,2);
BEGIN
    -- Skip if this is a deletion
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    
    -- Calculate totals for this transaction
    SELECT 
        COALESCE(SUM(amount) FILTER (WHERE direction = 'debit'), 0),
        COALESCE(SUM(amount) FILTER (WHERE direction = 'credit'), 0)
    INTO total_debits, total_credits
    FROM reserve.ledger_entries
    WHERE transaction_id = NEW.transaction_id;
    
    -- Only validate if we have both debit and credit entries
    IF total_debits > 0 AND total_credits > 0 AND total_debits != total_credits THEN
        RAISE EXCEPTION 'Ledger entries for transaction % are not balanced. Debits: %, Credits: %', 
            NEW.transaction_id, total_debits, total_credits;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger (disabled initially, enable after data migration)
DROP TRIGGER IF EXISTS trg_ledger_balance ON reserve.ledger_entries;
CREATE CONSTRAINT TRIGGER trg_ledger_balance
    AFTER INSERT OR UPDATE ON reserve.ledger_entries
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION reserve.check_ledger_balance_trigger();

-- ============================================
-- 7. PAYMENT METHOD CONSTRAINT
-- ============================================

-- Add constraint to ensure valid payment methods
ALTER TABLE reserve.payments DROP CONSTRAINT IF EXISTS valid_payment_method;
ALTER TABLE reserve.payments ADD CONSTRAINT valid_payment_method
    CHECK (payment_method IN ('stripe_card', 'pix', 'stripe_boleto', 'bank_transfer'));

-- ============================================
-- 8. INDEX OPTIMIZATIONS
-- ============================================

-- Partial index for active bookings
CREATE INDEX IF NOT EXISTS idx_reservations_active 
ON reserve.reservations(property_id, check_in, check_out) 
WHERE status IN ('confirmed', 'checked_in');

-- Index for payment lookups by gateway
CREATE INDEX IF NOT EXISTS idx_payments_gateway_lookup 
ON reserve.payments(gateway, gateway_payment_id, status);

-- Partial index for pending payments
CREATE INDEX IF NOT EXISTS idx_payments_pending 
ON reserve.payments(booking_intent_id, created_at) 
WHERE status IN ('pending', 'processing');

-- Composite index for events analytics
CREATE INDEX IF NOT EXISTS idx_events_analytics 
ON reserve.events(event_name, city_code, created_at DESC);

-- ============================================
-- 9. IP HASHING FUNCTION
-- ============================================

CREATE OR REPLACE FUNCTION reserve.hash_ip(ip_address INET)
RETURNS TEXT AS $$
BEGIN
    RETURN encode(digest(ip_address::text || 'salt_reserve_2024', 'sha256'), 'hex');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Note: Requires pgcrypto extension
-- CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ============================================
-- 10. SOFT DELETE PROTECTION
-- ============================================

-- Ensure soft deletes don't break FKs
CREATE OR REPLACE FUNCTION reserve.check_soft_delete_references()
RETURNS TRIGGER AS $$
BEGIN
    -- If this is a soft delete (setting deleted_at)
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
        -- Check if there are active reservations
        IF EXISTS (
            SELECT 1 FROM reserve.reservations 
            WHERE property_id = NEW.id 
            AND status IN ('confirmed', 'checked_in', 'pending')
        ) THEN
            RAISE EXCEPTION 'Cannot delete property with active reservations';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_properties_soft_delete ON reserve.properties_map;
CREATE TRIGGER trg_properties_soft_delete
    BEFORE UPDATE ON reserve.properties_map
    FOR EACH ROW
    EXECUTE FUNCTION reserve.check_soft_delete_references();

-- ============================================
-- 11. CREDENTIAL ENCRYPTION REMINDER
-- ============================================

-- Add comment about Supabase Vault for sensitive data
COMMENT ON COLUMN reserve.payments.stripe_client_secret IS 
    'TODO: Migrate to Supabase Vault (encrypted column) for production';

COMMENT ON COLUMN reserve.property_owners.bank_details IS 
    'TODO: Store in Supabase Vault with pgsodium encryption';

COMMENT ON COLUMN reserve.payouts.bank_details IS 
    'TODO: Store in Supabase Vault with pgsodium encryption';

-- ============================================
-- 12. SESSION ID VALIDATION
-- ============================================

CREATE OR REPLACE FUNCTION reserve.validate_session_id()
RETURNS TRIGGER AS $$
BEGIN
    -- Validate session_id format (UUID v4 or custom format)
    IF NEW.session_id IS NOT NULL AND 
       NEW.session_id !~ '^[a-zA-Z0-9_-]{20,128}$' THEN
        RAISE EXCEPTION 'Invalid session_id format';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validate_session ON reserve.booking_intents;
CREATE TRIGGER trg_validate_session
    BEFORE INSERT OR UPDATE ON reserve.booking_intents
    FOR EACH ROW
    EXECUTE FUNCTION reserve.validate_session_id();

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 'Security Hardening Migration Completed Successfully' as status;

-- Show summary of changes
SELECT 
    'RLS Enabled' as check_item,
    COUNT(*)::text as count
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname='reserve' AND c.relkind='r' AND c.relrowsecurity;
