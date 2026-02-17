-- ============================================
-- MIGRATION 013: AUDIT LOG REDACTION & RETENTION
-- Description: Implement PII redaction in audit logs and data retention policies
-- Version: 1.0
-- Date: 2026-02-16
-- Risk Level: HIGH - Affects audit trail compliance
-- ============================================

-- ============================================
-- SECTION 1: ENHANCED PII REDACTION FUNCTION
-- ============================================

-- Enhanced redaction function with more PII fields
CREATE OR REPLACE FUNCTION reserve.redact_pii_from_json(data JSONB)
RETURNS JSONB AS $$
DECLARE
    redacted JSONB := data;
    sensitive_keys TEXT[] := ARRAY[
        'email', 'phone', 'document_number', 'document_type',
        'address_line_1', 'address_line_2', 'postal_code',
        'bank_details', 'stripe_client_secret', 'stripe_payment_method_id',
        'gateway_payment_id', 'pix_copy_paste_key', 'credit_card_number',
        'cvv', 'password', 'token', 'api_key', 'secret',
        'first_name', 'last_name', 'guest_first_name', 'guest_last_name',
        'guest_email', 'guest_phone', 'ota_guest_email'
    ];
    key TEXT;
BEGIN
    IF data IS NULL THEN
        RETURN NULL;
    END IF;
    
    -- Redact common PII fields
    FOREACH key IN ARRAY sensitive_keys LOOP
        IF data ? key THEN
            CASE 
                WHEN key LIKE '%email%' THEN
                    redacted := jsonb_set(redacted, ARRAY[key], to_jsonb('***@***.com'::text));
                WHEN key LIKE '%phone%' THEN
                    redacted := jsonb_set(redacted, ARRAY[key], to_jsonb('***-***-****'::text));
                WHEN key LIKE '%document%' THEN
                    redacted := jsonb_set(redacted, ARRAY[key], to_jsonb('***.***.***-**'::text));
                WHEN key LIKE '%name%' THEN
                    redacted := jsonb_set(redacted, ARRAY[key], to_jsonb('***'::text));
                WHEN key IN ('stripe_client_secret', 'api_key', 'secret', 'token', 'cvv') THEN
                    redacted := jsonb_set(redacted, ARRAY[key], to_jsonb('[REDACTED]'::text));
                WHEN key = 'bank_details' THEN
                    redacted := jsonb_set(redacted, ARRAY[key], to_jsonb('[ENCRYPTED]'::text));
                WHEN key LIKE '%address%' OR key LIKE '%postal%' THEN
                    redacted := jsonb_set(redacted, ARRAY[key], to_jsonb('[ADDRESS REDACTED]'::text));
                ELSE
                    redacted := jsonb_set(redacted, ARRAY[key], to_jsonb('[REDACTED]'::text));
            END CASE;
        END IF;
    END LOOP;
    
    -- Handle nested objects (one level deep)
    FOR key IN SELECT jsonb_object_keys(data) LOOP
        IF jsonb_typeof(data->key) = 'object' THEN
            redacted := jsonb_set(
                redacted, 
                ARRAY[key], 
                reserve.redact_pii_from_json(data->key)
            );
        END IF;
    END LOOP;
    
    RETURN redacted;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION reserve.redact_pii_from_json IS 'Redacts PII from JSONB data for audit logs. Handles nested objects one level deep.';

-- ============================================
-- SECTION 2: UPDATE AUDIT TRIGGERS WITH REDACTION
-- ============================================

-- Drop existing audit triggers to recreate with redaction
DROP TRIGGER IF EXISTS audit_trigger ON reserve.travelers;
DROP TRIGGER IF EXISTS audit_trigger ON reserve.property_owners;
DROP TRIGGER IF EXISTS audit_trigger ON reserve.reservations;
DROP TRIGGER IF EXISTS audit_trigger ON reserve.payments;
DROP TRIGGER IF EXISTS audit_trigger ON reserve.payouts;
DROP TRIGGER IF EXISTS audit_trigger ON reserve.booking_intents;

-- Create enhanced audit trigger function with automatic PII redaction
CREATE OR REPLACE FUNCTION reserve.audit_trigger_func()
RETURNS TRIGGER AS $$
DECLARE
    old_data JSONB;
    new_data JSONB;
    changed_fields JSONB;
    audit_row reserve.audit_logs;
    excluded_cols TEXT[] := ARRAY['created_at', 'updated_at'];
BEGIN
    -- Build old_data with PII redaction
    IF TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        old_data := to_jsonb(OLD);
        -- Remove excluded columns
        old_data := old_data - excluded_cols;
        -- Redact PII
        old_data := reserve.redact_pii_from_json(old_data);
    ELSE
        old_data := NULL;
    END IF;
    
    -- Build new_data with PII redaction
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        new_data := to_jsonb(NEW);
        -- Remove excluded columns
        new_data := new_data - excluded_cols;
        -- Redact PII
        new_data := reserve.redact_pii_from_json(new_data);
    ELSE
        new_data := NULL;
    END IF;
    
    -- Calculate changed fields (only for UPDATE)
    IF TG_OP = 'UPDATE' THEN
        changed_fields := jsonb_object_agg(
            key, 
            jsonb_build_object('old', old_data->key, 'new', new_data->key)
        )
        FROM jsonb_object_keys(new_data) AS key
        WHERE old_data->key IS DISTINCT FROM new_data->key;
    ELSE
        changed_fields := NULL;
    END IF;
    
    -- Insert audit row using current audit_logs schema
    INSERT INTO reserve.audit_logs (
        id,
        actor_type,
        actor_id,
        actor_email,
        action,
        resource_type,
        resource_id,
        before_data,
        after_data,
        changed_fields,
        ip_address,
        user_agent,
        request_id,
        session_id,
        metadata,
        created_at
    ) VALUES (
        gen_random_uuid(),
        COALESCE(current_setting('app.current_actor_type', true), 'system'),
        COALESCE(current_setting('app.current_actor_id', true), 'unknown'),
        COALESCE(current_setting('app.current_actor_email', true), NULL),
        TG_OP,
        TG_TABLE_NAME,
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.id 
            ELSE NEW.id 
        END,
        old_data,
        new_data,
        changed_fields,
        NULL,
        NULL,
        COALESCE(current_setting('app.current_request_id', true), NULL),
        COALESCE(current_setting('app.current_session_id', true), NULL),
        jsonb_strip_nulls(
            jsonb_build_object(
                'city_code', COALESCE((to_jsonb(NEW)->>'city_code'), (to_jsonb(OLD)->>'city_code')),
                'reservation_id', COALESCE((to_jsonb(NEW)->>'reservation_id'), (to_jsonb(OLD)->>'reservation_id')),
                'table_name', TG_TABLE_NAME
            )
        ),
        NOW()
    );
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate audit triggers on sensitive tables
CREATE TRIGGER audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON reserve.travelers
    FOR EACH ROW EXECUTE FUNCTION reserve.audit_trigger_func();

CREATE TRIGGER audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON reserve.property_owners
    FOR EACH ROW EXECUTE FUNCTION reserve.audit_trigger_func();

CREATE TRIGGER audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON reserve.reservations
    FOR EACH ROW EXECUTE FUNCTION reserve.audit_trigger_func();

CREATE TRIGGER audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON reserve.payments
    FOR EACH ROW EXECUTE FUNCTION reserve.audit_trigger_func();

CREATE TRIGGER audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON reserve.payouts
    FOR EACH ROW EXECUTE FUNCTION reserve.audit_trigger_func();

CREATE TRIGGER audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON reserve.booking_intents
    FOR EACH ROW EXECUTE FUNCTION reserve.audit_trigger_func();

-- ============================================
-- SECTION 3: DATA RETENTION TABLES & POLICIES
-- ============================================

-- Create retention configuration table
CREATE TABLE IF NOT EXISTS reserve.retention_policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_name VARCHAR(100) NOT NULL UNIQUE,
    retention_days INT NOT NULL,
    retention_type VARCHAR(20) NOT NULL CHECK (retention_type IN ('delete', 'archive', 'anonymize')),
    archive_table VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    last_run_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.retention_policies IS 'Configuration for automated data retention policies';

-- Insert default retention policies
INSERT INTO reserve.retention_policies (table_name, retention_days, retention_type, is_active)
VALUES 
    ('audit_logs', 365, 'archive', true),              -- 1 year, then archive
    ('events', 90, 'delete', true),                     -- 90 days
    ('funnel_events', 90, 'delete', true),              -- 90 days
    ('booking_intents', 30, 'anonymize', true),         -- 30 days, then anonymize
    ('notification_outbox', 30, 'delete', true),        -- 30 days
    ('temp_holds_log', 7, 'delete', true)               -- 7 days
ON CONFLICT (table_name) DO UPDATE SET
    retention_days = EXCLUDED.retention_days,
    retention_type = EXCLUDED.retention_type;

-- Create archive table for audit_logs
CREATE TABLE IF NOT EXISTS reserve.audit_logs_archive (
    LIKE reserve.audit_logs INCLUDING ALL,
    archived_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add index on archive table for efficient queries
CREATE INDEX IF NOT EXISTS idx_audit_archive_table_date 
ON reserve.audit_logs_archive(resource_type, created_at);

-- ============================================
-- SECTION 4: RETENTION CLEANUP FUNCTIONS
-- ============================================

-- Function to clean up old events
CREATE OR REPLACE FUNCTION reserve.cleanup_old_events()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INT := 0;
    retention_record RECORD;
BEGIN
    FOR retention_record IN 
        SELECT * FROM reserve.retention_policies WHERE is_active = true
    LOOP
        CASE retention_record.table_name
            WHEN 'events' THEN
                DELETE FROM reserve.events 
                WHERE created_at < NOW() - INTERVAL '1 day' * retention_record.retention_days;
                GET DIAGNOSTICS deleted_count = ROW_COUNT;
                
            WHEN 'funnel_events' THEN
                DELETE FROM reserve.funnel_events 
                WHERE created_at < NOW() - INTERVAL '1 day' * retention_record.retention_days;
                GET DIAGNOSTICS deleted_count = ROW_COUNT;
                
            WHEN 'audit_logs' THEN
                -- Archive old audit logs instead of deleting
                IF retention_record.retention_type = 'archive' THEN
                    INSERT INTO reserve.audit_logs_archive
                    SELECT *, NOW() FROM reserve.audit_logs
                    WHERE created_at < NOW() - INTERVAL '1 day' * retention_record.retention_days;
                    
                    DELETE FROM reserve.audit_logs 
                    WHERE created_at < NOW() - INTERVAL '1 day' * retention_record.retention_days;
                    GET DIAGNOSTICS deleted_count = ROW_COUNT;
                END IF;
                
            WHEN 'booking_intents' THEN
                -- Anonymize instead of delete for accounting integrity
                IF retention_record.retention_type = 'anonymize' THEN
                    UPDATE reserve.booking_intents
                    SET 
                        guest_email = '[REDACTED]',
                        guest_phone = '[REDACTED]',
                        session_id = '[REDACTED]',
                        metadata = metadata || '{"anonymized": true}'::jsonb
                    WHERE created_at < NOW() - INTERVAL '1 day' * retention_record.retention_days
                    AND (metadata->>'anonymized')::boolean IS DISTINCT FROM true;
                    GET DIAGNOSTICS deleted_count = ROW_COUNT;
                END IF;
                
            WHEN 'notification_outbox' THEN
                DELETE FROM reserve.notification_outbox 
                WHERE created_at < NOW() - INTERVAL '1 day' * retention_record.retention_days
                AND status IN ('sent', 'failed', 'bounced');
                GET DIAGNOSTICS deleted_count = ROW_COUNT;
        END CASE;
        
        -- Update last_run timestamp
        UPDATE reserve.retention_policies
        SET last_run_at = NOW()
        WHERE id = retention_record.id;
        
        RAISE NOTICE 'Cleaned up % rows from %', deleted_count, retention_record.table_name;
    END LOOP;
    
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION reserve.cleanup_old_events() IS 'Automated cleanup of old data based on retention policies';

-- Function to run cleanup (can be called by cron job)
CREATE OR REPLACE FUNCTION reserve.run_retention_cleanup()
RETURNS TABLE (
    table_name VARCHAR,
    rows_affected INTEGER,
    action_taken VARCHAR,
    executed_at TIMESTAMPTZ
) AS $$
DECLARE
    policy RECORD;
    affected_rows INT;
BEGIN
    FOR policy IN SELECT * FROM reserve.retention_policies WHERE is_active = true
    LOOP
        affected_rows := 0;
        
        CASE policy.table_name
            WHEN 'events' THEN
                DELETE FROM reserve.events 
                WHERE created_at < NOW() - INTERVAL '1 day' * policy.retention_days;
                GET DIAGNOSTICS affected_rows = ROW_COUNT;
                RETURN QUERY SELECT policy.table_name::VARCHAR, affected_rows, 'deleted'::VARCHAR, NOW();
                
            WHEN 'funnel_events' THEN
                DELETE FROM reserve.funnel_events 
                WHERE created_at < NOW() - INTERVAL '1 day' * policy.retention_days;
                GET DIAGNOSTICS affected_rows = ROW_COUNT;
                RETURN QUERY SELECT policy.table_name::VARCHAR, affected_rows, 'deleted'::VARCHAR, NOW();
                
            WHEN 'audit_logs' THEN
                IF policy.retention_type = 'archive' THEN
                    -- Move to archive first
                    INSERT INTO reserve.audit_logs_archive
                    SELECT *, NOW() FROM reserve.audit_logs
                    WHERE created_at < NOW() - INTERVAL '1 day' * policy.retention_days
                    AND NOT EXISTS (
                        SELECT 1 FROM reserve.audit_logs_archive a 
                        WHERE a.id = audit_logs.id
                    );
                    
                    DELETE FROM reserve.audit_logs 
                    WHERE created_at < NOW() - INTERVAL '1 day' * policy.retention_days;
                    GET DIAGNOSTICS affected_rows = ROW_COUNT;
                    RETURN QUERY SELECT policy.table_name::VARCHAR, affected_rows, 'archived'::VARCHAR, NOW();
                END IF;
                
            WHEN 'booking_intents' THEN
                UPDATE reserve.booking_intents
                SET 
                    guest_email = '[REDACTED]',
                    guest_phone = '[REDACTED]',
                    session_id = '[REDACTED]',
                    metadata = metadata || '{"anonymized": true}'::jsonb,
                    updated_at = NOW()
                WHERE created_at < NOW() - INTERVAL '1 day' * policy.retention_days
                AND (metadata->>'anonymized')::boolean IS DISTINCT FROM true;
                GET DIAGNOSTICS affected_rows = ROW_COUNT;
                RETURN QUERY SELECT policy.table_name::VARCHAR, affected_rows, 'anonymized'::VARCHAR, NOW();
        END CASE;
        
        UPDATE reserve.retention_policies
        SET last_run_at = NOW()
        WHERE id = policy.id;
    END LOOP;
    
    RETURN;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- SECTION 5: GDPR RIGHT TO ERASURE SUPPORT
-- ============================================

-- Create table to track erasure requests
CREATE TABLE IF NOT EXISTS reserve.data_erasure_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type VARCHAR(50) NOT NULL,  -- 'traveler', 'property_owner', etc.
    entity_id UUID NOT NULL,
    email_hash TEXT,  -- Hashed email for verification
    request_reason VARCHAR(255),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'rejected')),
    requested_at TIMESTAMPTZ DEFAULT NOW(),
    processed_at TIMESTAMPTZ,
    processed_by VARCHAR(255),
    retention_justification TEXT,  -- Legal basis for retention
    error_message TEXT
);

CREATE INDEX IF NOT EXISTS idx_erasure_entity ON reserve.data_erasure_requests(entity_type, entity_id);

-- Function to anonymize traveler data (GDPR Article 17)
CREATE OR REPLACE FUNCTION reserve.anonymize_traveler(traveler_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    anon_id UUID := '00000000-0000-0000-0000-000000000000'::uuid;
    success BOOLEAN := false;
BEGIN
    -- Anonymize traveler record
    UPDATE reserve.travelers
    SET 
        email = '[REDACTED-' || substring(id::text, 1, 8) || ']',
        email_encrypted = NULL,
        first_name = '[REDACTED]',
        last_name = '[REDACTED]',
        phone = '[REDACTED]',
        phone_encrypted = NULL,
        document_number = '[REDACTED]',
        document_number_encrypted = NULL,
        address_line_1 = '[REDACTED]',
        address_line_1_encrypted = NULL,
        city = '[REDACTED]',
        state_province = '[REDACTED]',
        postal_code = '00000',
        is_active = false,
        updated_at = NOW(),
        preferences = '{}'::jsonb
    WHERE id = traveler_id;
    
    -- Anonymize associated reservations (keep financial records)
    UPDATE reserve.reservations
    SET 
        guest_email = '[REDACTED]',
        guest_email_encrypted = NULL,
        guest_first_name = '[REDACTED]',
        guest_last_name = '[REDACTED]',
        guest_phone = '[REDACTED]',
        guest_phone_encrypted = NULL,
        special_requests = '[REDACTED]'
    WHERE traveler_id = traveler_id;
    
    -- Update erasure request status
    UPDATE reserve.data_erasure_requests
    SET status = 'completed', processed_at = NOW()
    WHERE entity_type = 'traveler' AND entity_id = traveler_id AND status = 'processing';
    
    success := true;
    RETURN success;
    
EXCEPTION
    WHEN OTHERS THEN
        UPDATE reserve.data_erasure_requests
        SET status = 'failed', error_message = SQLERRM
        WHERE entity_type = 'traveler' AND entity_id = traveler_id;
        RETURN false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION reserve.anonymize_traveler IS 'Anonymizes all PII for a traveler while preserving accounting records';

-- ============================================
-- SECTION 6: AUDIT LOG QUERY OPTIMIZATION
-- ============================================

-- Add indexes for common audit log queries
CREATE INDEX IF NOT EXISTS idx_audit_logs_resource_date 
ON reserve.audit_logs(resource_type, resource_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at 
ON reserve.audit_logs(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_audit_logs_by_actor 
ON reserve.audit_logs(actor_type, actor_id, created_at DESC);

-- Partitioning preparation (for future implementation)
COMMENT ON TABLE reserve.audit_logs IS 
'Audit logs with PII redaction. Consider partitioning by month when >10M rows. See DATA_RETENTION_POLICY.md';

-- ============================================
-- SECTION 7: RETENTION STATISTICS VIEW
-- ============================================

CREATE OR REPLACE VIEW reserve.retention_statistics AS
SELECT 
    'audit_logs' as table_name,
    COUNT(*) as total_rows,
    COUNT(*) FILTER (WHERE created_at < NOW() - INTERVAL '90 days') as older_than_90_days,
    pg_size_pretty(pg_total_relation_size('reserve.audit_logs')) as total_size
FROM reserve.audit_logs

UNION ALL

SELECT 
    'events' as table_name,
    COUNT(*) as total_rows,
    COUNT(*) FILTER (WHERE created_at < NOW() - INTERVAL '90 days') as older_than_90_days,
    pg_size_pretty(pg_total_relation_size('reserve.events')) as total_size
FROM reserve.events

UNION ALL

SELECT 
    'funnel_events' as table_name,
    COUNT(*) as total_rows,
    COUNT(*) FILTER (WHERE created_at < NOW() - INTERVAL '90 days') as older_than_90_days,
    pg_size_pretty(pg_total_relation_size('reserve.funnel_events')) as total_size
FROM reserve.funnel_events;

COMMENT ON VIEW reserve.retention_statistics IS 'Current storage statistics for retention-managed tables';

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 
    'Audit Log Redaction & Retention Migration' as migration,
    '013_audit_log_redaction_retention.sql' as file,
    'COMPLETED' as status,
    NOW() as executed_at;

-- Show redaction function
SELECT 
    'Redaction function updated' as check_item,
    proname as function_name,
    prosrc IS NOT NULL as has_implementation
FROM pg_proc
WHERE proname = 'redact_pii_from_json';

-- Show audit triggers
SELECT 
    'Audit triggers active' as check_item,
    tgname as trigger_name,
    tgrelid::regclass as table_name
FROM pg_trigger
WHERE tgname = 'audit_trigger'
AND tgrelid::regclass::text LIKE 'reserve.%';

-- Show retention policies
SELECT 
    'Retention policies configured' as check_item,
    table_name,
    retention_days,
    retention_type
FROM reserve.retention_policies
WHERE is_active = true;

-- ============================================
-- ROLLBACK INSTRUCTIONS
-- ============================================
/*
To rollback this migration:

1. Drop triggers:
   DROP TRIGGER IF EXISTS audit_trigger ON reserve.travelers;
   DROP TRIGGER IF EXISTS audit_trigger ON reserve.property_owners;
   DROP TRIGGER IF EXISTS audit_trigger ON reserve.reservations;
   DROP TRIGGER IF EXISTS audit_trigger ON reserve.payments;
   DROP TRIGGER IF EXISTS audit_trigger ON reserve.payouts;
   DROP TRIGGER IF EXISTS audit_trigger ON reserve.booking_intents;

2. Restore old audit function (if you have a backup):
   -- Restore from backup or recreate without redaction

3. Drop retention tables:
   DROP TABLE IF EXISTS reserve.retention_policies CASCADE;
   DROP TABLE IF EXISTS reserve.data_erasure_requests CASCADE;
   DROP TABLE IF EXISTS reserve.audit_logs_archive CASCADE;

4. Drop functions:
   DROP FUNCTION IF EXISTS reserve.cleanup_old_events();
   DROP FUNCTION IF EXISTS reserve.run_retention_cleanup();
   DROP FUNCTION IF EXISTS reserve.anonymize_traveler(UUID);
   DROP FUNCTION IF EXISTS reserve.audit_trigger_func();

5. Drop view:
   DROP VIEW IF EXISTS reserve.retention_statistics;

WARNING: This will remove redaction from future audit logs!
Existing redacted data cannot be restored.
*/
