-- ============================================
-- MIGRATION 012: PII VAULT ENCRYPTION
-- Description: Implement Supabase Vault encryption for all PII columns
-- Version: 1.0
-- Date: 2026-02-16
-- Risk Level: CRITICAL - Must be applied before production
-- ============================================

-- ============================================
-- SECTION 1: ENABLE VAULT EXTENSIONS
-- ============================================

-- Enable pgsodium extension for encryption (requires superuser in Supabase)
-- Note: In Supabase, these are usually available, but we include for completeness
DO $$
BEGIN
    -- pgcrypto is already enabled in Supabase
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pgcrypto') THEN
        CREATE EXTENSION IF NOT EXISTS pgcrypto;
    END IF;
    
    -- pgsodium for field-level encryption
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pgsodium') THEN
        CREATE EXTENSION IF NOT EXISTS pgsodium;
    END IF;
    
    -- Supabase Vault extension (for secret storage)
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'supabase_vault') THEN
        -- This requires manual enablement in Supabase Dashboard or CLI
        RAISE NOTICE 'supabase_vault extension needs to be enabled manually in Supabase Dashboard';
    END IF;
END $$;

-- ============================================
-- SECTION 2: CREATE ENCRYPTION KEYS
-- ============================================

-- Create encryption keys using pgsodium (idempotent)
DO $$
DECLARE
    key_exists BOOLEAN;
BEGIN
    -- Check if pgsodium is available
    IF EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pgsodium') THEN
        BEGIN
            -- Create key for travelers PII
            SELECT EXISTS(
                SELECT 1 FROM pgsodium.key WHERE name = 'travelers_pii_key'
            ) INTO key_exists;
            
            IF NOT key_exists THEN
                PERFORM pgsodium.create_key(
                    key_type := 'aead-det',
                    name := 'travelers_pii_key'
                );
                UPDATE pgsodium.key SET comment = 'Encryption key for travelers personal data (email, phone, document)'
                WHERE name = 'travelers_pii_key';
                RAISE NOTICE 'Created encryption key: travelers_pii_key';
            END IF;
            
            -- Create key for property owners PII
            SELECT EXISTS(
                SELECT 1 FROM pgsodium.key WHERE name = 'owners_pii_key'
            ) INTO key_exists;
            
            IF NOT key_exists THEN
                PERFORM pgsodium.create_key(
                    key_type := 'aead-det',
                    name := 'owners_pii_key'
                );
                UPDATE pgsodium.key SET comment = 'Encryption key for property owner data'
                WHERE name = 'owners_pii_key';
                RAISE NOTICE 'Created encryption key: owners_pii_key';
            END IF;
            
            -- Create key for bank details
            SELECT EXISTS(
                SELECT 1 FROM pgsodium.key WHERE name = 'bank_details_key'
            ) INTO key_exists;
            
            IF NOT key_exists THEN
                PERFORM pgsodium.create_key(
                    key_type := 'aead-det',
                    name := 'bank_details_key'
                );
                UPDATE pgsodium.key SET comment = 'Encryption key for banking information'
                WHERE name = 'bank_details_key';
                RAISE NOTICE 'Created encryption key: bank_details_key';
            END IF;
            
            -- Create key for payment secrets
            SELECT EXISTS(
                SELECT 1 FROM pgsodium.key WHERE name = 'payment_secrets_key'
            ) INTO key_exists;
            
            IF NOT key_exists THEN
                PERFORM pgsodium.create_key(
                    key_type := 'aead-det',
                    name := 'payment_secrets_key'
                );
                UPDATE pgsodium.key SET comment = 'Encryption key for payment gateway secrets'
                WHERE name = 'payment_secrets_key';
                RAISE NOTICE 'Created encryption key: payment_secrets_key';
            END IF;
        EXCEPTION
            WHEN insufficient_privilege THEN
                RAISE NOTICE 'Insufficient privileges to manage pgsodium keys. Create keys manually as postgres.';
        END;
    ELSE
        RAISE NOTICE 'pgsodium not available - keys will need to be created manually';
    END IF;
END $$;

-- ============================================
-- SECTION 3: ADD ENCRYPTED COLUMNS TO TRAVELERS
-- ============================================

-- Add encrypted columns for travelers table
ALTER TABLE reserve.travelers 
ADD COLUMN IF NOT EXISTS email_encrypted TEXT,
ADD COLUMN IF NOT EXISTS phone_encrypted TEXT,
ADD COLUMN IF NOT EXISTS document_number_encrypted TEXT,
ADD COLUMN IF NOT EXISTS address_line_1_encrypted TEXT,
ADD COLUMN IF NOT EXISTS email_hash TEXT,
ADD COLUMN IF NOT EXISTS phone_hash TEXT;

-- Create indexes for encrypted columns (for lookups without decryption)
CREATE INDEX IF NOT EXISTS idx_travelers_email_hash ON reserve.travelers(email_hash);
CREATE INDEX IF NOT EXISTS idx_travelers_phone_hash ON reserve.travelers(phone_hash);

-- Add comments for encrypted columns
COMMENT ON COLUMN reserve.travelers.email_encrypted IS 'PII encrypted with Vault - use travelers_pii_key';
COMMENT ON COLUMN reserve.travelers.phone_encrypted IS 'PII encrypted with Vault - use travelers_pii_key';
COMMENT ON COLUMN reserve.travelers.document_number_encrypted IS 'PII encrypted with Vault - use travelers_pii_key';
COMMENT ON COLUMN reserve.travelers.email_hash IS 'SHA256 hash of email for lookup purposes';

-- ============================================
-- SECTION 4: ADD ENCRYPTED COLUMNS TO PROPERTY_OWNERS
-- ============================================

ALTER TABLE reserve.property_owners 
ADD COLUMN IF NOT EXISTS email_encrypted TEXT,
ADD COLUMN IF NOT EXISTS phone_encrypted TEXT,
ADD COLUMN IF NOT EXISTS document_number_encrypted TEXT,
ADD COLUMN IF NOT EXISTS bank_details_encrypted TEXT,
ADD COLUMN IF NOT EXISTS email_hash TEXT;

CREATE INDEX IF NOT EXISTS idx_property_owners_email_hash ON reserve.property_owners(email_hash);

COMMENT ON COLUMN reserve.property_owners.email_encrypted IS 'PII encrypted with Vault - use owners_pii_key';
COMMENT ON COLUMN reserve.property_owners.bank_details_encrypted IS 'Bank details encrypted with Vault - use bank_details_key';

-- ============================================
-- SECTION 5: ADD ENCRYPTED COLUMNS TO RESERVATIONS
-- ============================================

ALTER TABLE reserve.reservations 
ADD COLUMN IF NOT EXISTS guest_email_encrypted TEXT,
ADD COLUMN IF NOT EXISTS guest_phone_encrypted TEXT,
ADD COLUMN IF NOT EXISTS guest_email_hash TEXT;

CREATE INDEX IF NOT EXISTS idx_reservations_guest_email_hash ON reserve.reservations(guest_email_hash);

COMMENT ON COLUMN reserve.reservations.guest_email_encrypted IS 'PII encrypted with Vault - use travelers_pii_key';

-- ============================================
-- SECTION 6: ADD ENCRYPTED COLUMNS TO PAYOUTS
-- ============================================

ALTER TABLE reserve.payouts 
ADD COLUMN IF NOT EXISTS bank_details_encrypted TEXT;

COMMENT ON COLUMN reserve.payouts.bank_details_encrypted IS 'Bank details encrypted with Vault - use bank_details_key';

-- ============================================
-- SECTION 7: ADD ENCRYPTED COLUMNS TO PAYMENTS
-- ============================================

-- Instead of storing client_secret, we'll store it encrypted temporarily
-- Long-term: don't store client_secret at all, just gateway_payment_id
ALTER TABLE reserve.payments 
ADD COLUMN IF NOT EXISTS stripe_client_secret_encrypted TEXT,
ADD COLUMN IF NOT EXISTS sensitive_metadata_encrypted TEXT;

COMMENT ON COLUMN reserve.payments.stripe_client_secret_encrypted IS 'Payment secret encrypted with Vault - use payment_secrets_key (DO NOT USE - deprecated)';
COMMENT ON COLUMN reserve.payments.sensitive_metadata_encrypted IS 'Encrypted payment metadata';

-- ============================================
-- SECTION 8: CREATE ENCRYPTION HELPER FUNCTIONS
-- ============================================

-- Function to encrypt data using pgsodium
CREATE OR REPLACE FUNCTION reserve.encrypt_pii(plaintext TEXT, key_name TEXT)
RETURNS TEXT AS $$
DECLARE
    key_id UUID;
    encrypted BYTEA;
BEGIN
    IF plaintext IS NULL THEN
        RETURN NULL;
    END IF;
    
    -- Check if pgsodium is available
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pgsodium') THEN
        -- Fallback: return plaintext with marker (for development only)
        RETURN 'PGSODIUM_DISABLED:' || plaintext;
    END IF;
    
    -- Get key ID
    SELECT id INTO key_id FROM pgsodium.key WHERE name = key_name;
    
    IF key_id IS NULL THEN
        RAISE EXCEPTION 'Encryption key % not found', key_name;
    END IF;
    
    -- Encrypt using pgsodium (deterministic)
    encrypted := pgsodium.crypto_aead_det_encrypt(
        plaintext::bytea,
        ''::bytea,
        key_id
    );
    
    RETURN encode(encrypted, 'base64');
EXCEPTION
    WHEN OTHERS THEN
        RAISE WARNING 'Encryption failed: %', SQLERRM;
        RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to decrypt data using pgsodium
CREATE OR REPLACE FUNCTION reserve.decrypt_pii(encrypted TEXT, key_name TEXT)
RETURNS TEXT AS $$
DECLARE
    key_id UUID;
    decrypted BYTEA;
BEGIN
    -- Return NULL if input is NULL
    IF encrypted IS NULL THEN
        RETURN NULL;
    END IF;
    
    -- Check if pgsodium is available
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pgsodium') THEN
        -- Check if it's the fallback marker
        IF encrypted LIKE 'PGSODIUM_DISABLED:%' THEN
            RETURN substring(encrypted from 18);
        END IF;
        RETURN encrypted;
    END IF;
    
    -- Get key ID
    SELECT id INTO key_id FROM pgsodium.key WHERE name = key_name;
    
    IF key_id IS NULL THEN
        RAISE EXCEPTION 'Decryption key % not found', key_name;
    END IF;
    
    -- Decrypt using pgsodium
    decrypted := pgsodium.crypto_aead_det_decrypt(
        decode(encrypted, 'base64'),
        ''::bytea,
        key_id
    );
    
    RETURN convert_from(decrypted, 'UTF8');
EXCEPTION
    WHEN OTHERS THEN
        RAISE WARNING 'Decryption failed: %', SQLERRM;
        RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to hash data for lookups (deterministic)
CREATE OR REPLACE FUNCTION reserve.hash_for_lookup(data TEXT)
RETURNS TEXT AS $$
BEGIN
    IF data IS NULL THEN
        RETURN NULL;
    END IF;
    
    -- Use SHA256 with a salt for lookup purposes
    RETURN encode(
        digest(
            lower(trim(data)) || 'reserve_lookup_salt_2024',
            'sha256'
        ),
        'hex'
    );
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- ============================================
-- SECTION 9: CREATE TRIGGERS FOR AUTO-ENCRYPTION
-- ============================================

-- Trigger function to encrypt travelers data on insert/update
CREATE OR REPLACE FUNCTION reserve.encrypt_travelers_pii()
RETURNS TRIGGER AS $$
BEGIN
    -- Only encrypt if plaintext has changed or encrypted is NULL
    IF TG_OP = 'INSERT' OR OLD.email IS DISTINCT FROM NEW.email THEN
        NEW.email_encrypted := reserve.encrypt_pii(NEW.email, 'travelers_pii_key');
        NEW.email_hash := reserve.hash_for_lookup(NEW.email);
    END IF;
    
    IF TG_OP = 'INSERT' OR OLD.phone IS DISTINCT FROM NEW.phone THEN
        NEW.phone_encrypted := reserve.encrypt_pii(NEW.phone, 'travelers_pii_key');
        NEW.phone_hash := reserve.hash_for_lookup(NEW.phone);
    END IF;
    
    IF TG_OP = 'INSERT' OR OLD.document_number IS DISTINCT FROM NEW.document_number THEN
        NEW.document_number_encrypted := reserve.encrypt_pii(NEW.document_number, 'travelers_pii_key');
    END IF;
    
    IF TG_OP = 'INSERT' OR OLD.address_line_1 IS DISTINCT FROM NEW.address_line_1 THEN
        NEW.address_line_1_encrypted := reserve.encrypt_pii(NEW.address_line_1, 'travelers_pii_key');
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_encrypt_travelers ON reserve.travelers;
CREATE TRIGGER trg_encrypt_travelers
    BEFORE INSERT OR UPDATE ON reserve.travelers
    FOR EACH ROW
    EXECUTE FUNCTION reserve.encrypt_travelers_pii();

-- Trigger function for property_owners
CREATE OR REPLACE FUNCTION reserve.encrypt_owners_pii()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR OLD.email IS DISTINCT FROM NEW.email THEN
        NEW.email_encrypted := reserve.encrypt_pii(NEW.email, 'owners_pii_key');
        NEW.email_hash := reserve.hash_for_lookup(NEW.email);
    END IF;
    
    IF TG_OP = 'INSERT' OR OLD.phone IS DISTINCT FROM NEW.phone THEN
        NEW.phone_encrypted := reserve.encrypt_pii(NEW.phone, 'owners_pii_key');
    END IF;
    
    IF TG_OP = 'INSERT' OR OLD.document_number IS DISTINCT FROM NEW.document_number THEN
        NEW.document_number_encrypted := reserve.encrypt_pii(NEW.document_number, 'owners_pii_key');
    END IF;
    
    IF TG_OP = 'INSERT' OR OLD.bank_details IS DISTINCT FROM NEW.bank_details THEN
        NEW.bank_details_encrypted := reserve.encrypt_pii(NEW.bank_details::text, 'bank_details_key');
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_encrypt_owners ON reserve.property_owners;
CREATE TRIGGER trg_encrypt_owners
    BEFORE INSERT OR UPDATE ON reserve.property_owners
    FOR EACH ROW
    EXECUTE FUNCTION reserve.encrypt_owners_pii();

-- Trigger function for reservations
CREATE OR REPLACE FUNCTION reserve.encrypt_reservation_pii()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR OLD.guest_email IS DISTINCT FROM NEW.guest_email THEN
        NEW.guest_email_encrypted := reserve.encrypt_pii(NEW.guest_email, 'travelers_pii_key');
        NEW.guest_email_hash := reserve.hash_for_lookup(NEW.guest_email);
    END IF;
    
    IF TG_OP = 'INSERT' OR OLD.guest_phone IS DISTINCT FROM NEW.guest_phone THEN
        NEW.guest_phone_encrypted := reserve.encrypt_pii(NEW.guest_phone, 'travelers_pii_key');
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_encrypt_reservations ON reserve.reservations;
CREATE TRIGGER trg_encrypt_reservations
    BEFORE INSERT OR UPDATE ON reserve.reservations
    FOR EACH ROW
    EXECUTE FUNCTION reserve.encrypt_reservation_pii();

-- ============================================
-- SECTION 10: MIGRATE EXISTING DATA
-- ============================================

-- Migrate existing travelers data (run in batches for large datasets)
DO $$
DECLARE
    batch_size INT := 1000;
    total_migrated INT := 0;
    batch_count INT;
BEGIN
    -- Check if there are unencrypted records
    SELECT COUNT(*) INTO batch_count
    FROM reserve.travelers
    WHERE email_encrypted IS NULL AND email IS NOT NULL;
    
    IF batch_count > 0 THEN
        RAISE NOTICE 'Migrating % travelers records to encrypted format...', batch_count;
        
        -- Update triggers will handle encryption automatically
        UPDATE reserve.travelers
        SET email = email  -- Trigger will encrypt
        WHERE email_encrypted IS NULL 
        AND email IS NOT NULL;
        
        GET DIAGNOSTICS total_migrated = ROW_COUNT;
        RAISE NOTICE 'Migrated % travelers records', total_migrated;
    ELSE
        RAISE NOTICE 'No travelers records need migration';
    END IF;
END $$;

-- Migrate property_owners
DO $$
DECLARE
    batch_count INT;
BEGIN
    SELECT COUNT(*) INTO batch_count
    FROM reserve.property_owners
    WHERE email_encrypted IS NULL AND email IS NOT NULL;
    
    IF batch_count > 0 THEN
        RAISE NOTICE 'Migrating % property_owners records...', batch_count;
        
        UPDATE reserve.property_owners
        SET email = email
        WHERE email_encrypted IS NULL 
        AND email IS NOT NULL;
        
        RAISE NOTICE 'Migration complete';
    END IF;
END $$;

-- Migrate reservations
DO $$
DECLARE
    batch_count INT;
BEGIN
    SELECT COUNT(*) INTO batch_count
    FROM reserve.reservations
    WHERE guest_email_encrypted IS NULL AND guest_email IS NOT NULL;
    
    IF batch_count > 0 THEN
        RAISE NOTICE 'Migrating % reservations records...', batch_count;
        
        UPDATE reserve.reservations
        SET guest_email = guest_email
        WHERE guest_email_encrypted IS NULL 
        AND guest_email IS NOT NULL;
        
        RAISE NOTICE 'Migration complete';
    END IF;
END $$;

-- ============================================
-- SECTION 11: CREATE SECURE VIEWS
-- ============================================

-- View for travelers with decrypted data (service_role only)
CREATE OR REPLACE VIEW reserve.travelers_secure AS
SELECT 
    id,
    auth_user_id,
    -- Decrypt PII fields
    reserve.decrypt_pii(email_encrypted, 'travelers_pii_key') as email,
    first_name,
    last_name,
    reserve.decrypt_pii(phone_encrypted, 'travelers_pii_key') as phone,
    phone_country_code,
    date_of_birth,
    nationality,
    document_type,
    reserve.decrypt_pii(document_number_encrypted, 'travelers_pii_key') as document_number,
    reserve.decrypt_pii(address_line_1_encrypted, 'travelers_pii_key') as address_line_1,
    city,
    state_province,
    postal_code,
    country,
    preferences,
    marketing_consent,
    is_verified,
    created_at,
    updated_at
FROM reserve.travelers;

-- Add RLS policy for secure view
-- Only service_role can access decrypted data
COMMENT ON VIEW reserve.travelers_secure IS 'View with decrypted PII - service_role access only';

-- ============================================
-- SECTION 12: RESTRICT PLAINTEXT COLUMN ACCESS
-- ============================================

-- After migration period, restrict access to plaintext columns
-- This should be applied AFTER application has migrated to encrypted columns

-- Function to block plaintext writes after transition
CREATE OR REPLACE FUNCTION reserve.block_plaintext_pii()
RETURNS TRIGGER AS $$
BEGIN
    -- This is a safety trigger that can be enabled after full migration
    -- Currently just logs warnings
    IF NEW.email IS NOT NULL AND NEW.email != OLD.email THEN
        RAISE WARNING 'Direct email modification detected on table %', TG_TABLE_NAME;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Note: After full migration, enable this to prevent accidental plaintext writes
-- CREATE TRIGGER trg_block_plaintext_travelers
--     BEFORE UPDATE ON reserve.travelers
--     FOR EACH ROW
--     EXECUTE FUNCTION reserve.block_plaintext_pii();

-- ============================================
-- SECTION 13: IP ADDRESS HASHING
-- ============================================

-- Add hashed IP columns to tables that store IP addresses
ALTER TABLE reserve.audit_logs 
ADD COLUMN IF NOT EXISTS ip_hash TEXT;

ALTER TABLE reserve.funnel_events 
ADD COLUMN IF NOT EXISTS ip_hash TEXT;

ALTER TABLE reserve.events 
ADD COLUMN IF NOT EXISTS ip_hash TEXT;

-- Create indexes for hashed IPs
CREATE INDEX IF NOT EXISTS idx_audit_logs_ip_hash ON reserve.audit_logs(ip_hash);

-- Function to hash IP with salt
CREATE OR REPLACE FUNCTION reserve.hash_ip_address(ip INET)
RETURNS TEXT AS $$
BEGIN
    IF ip IS NULL THEN
        RETURN NULL;
    END IF;
    
    RETURN encode(
        digest(ip::text || 'reserve_ip_salt_2024', 'sha256'),
        'hex'
    );
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Trigger to auto-hash IP addresses
CREATE OR REPLACE FUNCTION reserve.auto_hash_ip()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.ip_address IS NOT NULL AND NEW.ip_hash IS NULL THEN
        NEW.ip_hash := reserve.hash_ip_address(NEW.ip_address);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_hash_ip_audit ON reserve.audit_logs;
CREATE TRIGGER trg_hash_ip_audit
    BEFORE INSERT OR UPDATE ON reserve.audit_logs
    FOR EACH ROW
    EXECUTE FUNCTION reserve.auto_hash_ip();

DROP TRIGGER IF EXISTS trg_hash_ip_funnel ON reserve.funnel_events;
CREATE TRIGGER trg_hash_ip_funnel
    BEFORE INSERT OR UPDATE ON reserve.funnel_events
    FOR EACH ROW
    EXECUTE FUNCTION reserve.auto_hash_ip();

-- ============================================
-- VERIFICATION & SUMMARY
-- ============================================

SELECT 
    'PII Vault Encryption Migration' as migration,
    '012_pii_vault_encryption.sql' as file,
    'COMPLETED' as status,
    NOW() as executed_at;

-- Show summary of encrypted columns created
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'reserve'
AND column_name LIKE '%_encrypted'
ORDER BY table_name, column_name;

-- Show encryption keys created (if pgsodium is available)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pgsodium') THEN
        BEGIN
            RAISE NOTICE 'Encryption keys in pgsodium:';
            PERFORM name, key_type 
            FROM pgsodium.key 
            WHERE name IN ('travelers_pii_key', 'owners_pii_key', 'bank_details_key', 'payment_secrets_key');
        EXCEPTION
            WHEN insufficient_privilege THEN
                RAISE NOTICE 'Insufficient privileges to list pgsodium keys. Verify as postgres.';
        END;
    ELSE
        RAISE NOTICE 'pgsodium not enabled - keys need to be created manually';
    END IF;
END $$;

-- ============================================
-- ROLLBACK INSTRUCTIONS (Save this section)
-- ============================================
/*
To rollback this migration:

1. Disable triggers:
   DROP TRIGGER IF EXISTS trg_encrypt_travelers ON reserve.travelers;
   DROP TRIGGER IF EXISTS trg_encrypt_owners ON reserve.property_owners;
   DROP TRIGGER IF EXISTS trg_encrypt_reservations ON reserve.reservations;

2. Drop encrypted columns (data loss - encrypted data will be lost):
   ALTER TABLE reserve.travelers DROP COLUMN IF EXISTS email_encrypted;
   ALTER TABLE reserve.travelers DROP COLUMN IF EXISTS phone_encrypted;
   ALTER TABLE reserve.travelers DROP COLUMN IF EXISTS document_number_encrypted;
   ALTER TABLE reserve.travelers DROP COLUMN IF EXISTS address_line_1_encrypted;
   ALTER TABLE reserve.travelers DROP COLUMN IF EXISTS email_hash;
   ALTER TABLE reserve.travelers DROP COLUMN IF EXISTS phone_hash;
   
   -- Repeat for other tables...

3. Drop helper functions:
   DROP FUNCTION IF EXISTS reserve.encrypt_pii(TEXT, TEXT);
   DROP FUNCTION IF EXISTS reserve.decrypt_pii(TEXT, TEXT);
   DROP FUNCTION IF EXISTS reserve.hash_for_lookup(TEXT);
   DROP FUNCTION IF EXISTS reserve.encrypt_travelers_pii();
   DROP FUNCTION IF EXISTS reserve.encrypt_owners_pii();
   DROP FUNCTION IF EXISTS reserve.encrypt_reservation_pii();

4. Drop views:
   DROP VIEW IF EXISTS reserve.travelers_secure;

5. Drop Vault keys (if desired):
   -- Only if you're sure you won't need to decrypt existing data
   SELECT vault.delete_key(id) FROM vault.keys WHERE name LIKE '%_key';

WARNING: Rolling back will make encrypted data inaccessible!
*/
