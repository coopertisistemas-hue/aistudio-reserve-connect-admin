-- ============================================
-- MIGRATION 004: Operations & Audit
-- Description: Audit logs, notifications, sync tracking
-- Version: 1.0
-- Date: 2026-02-16
-- ============================================

-- ============================================
-- 1. AUDIT LOGS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_name VARCHAR(100) NOT NULL,
    record_id UUID NOT NULL,
    action VARCHAR(20) NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    old_data JSONB,
    new_data JSONB,
    changed_fields JSONB,
    actor_type VARCHAR(50) DEFAULT 'system',
    actor_id VARCHAR(255),
    city_code VARCHAR(10),
    reservation_id UUID,
    session_id VARCHAR(100),
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.audit_logs IS 'Complete audit trail for all booking changes';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_audit_table_record ON reserve.audit_logs(table_name, record_id);
CREATE INDEX IF NOT EXISTS idx_audit_created ON reserve.audit_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_reservation ON reserve.audit_logs(reservation_id);
CREATE INDEX IF NOT EXISTS idx_audit_city ON reserve.audit_logs(city_code, created_at);
CREATE INDEX IF NOT EXISTS idx_audit_actor ON reserve.audit_logs(actor_type, actor_id);

-- ============================================
-- 2. NOTIFICATION OUTBOX
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.notification_outbox (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(10) NOT NULL REFERENCES reserve.cities(code),
    
    -- Recipient
    recipient_type VARCHAR(20) NOT NULL CHECK (recipient_type IN ('traveler', 'property', 'owner', 'agent', 'system')),
    recipient_id UUID NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    
    -- Content
    channel VARCHAR(20) NOT NULL CHECK (channel IN ('email', 'whatsapp', 'sms', 'push')),
    template_id VARCHAR(100),
    subject VARCHAR(255),
    body TEXT,
    body_html TEXT,
    
    -- Status
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'queued', 'sent', 'failed', 'delivered', 'opened')),
    priority INTEGER DEFAULT 5,
    
    -- Scheduling
    scheduled_at TIMESTAMPTZ DEFAULT NOW(),
    sent_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,
    opened_at TIMESTAMPTZ,
    
    -- References
    reservation_id UUID REFERENCES reserve.reservations(id),
    metadata JSONB DEFAULT '{}',
    
    -- Error tracking
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.notification_outbox IS 'Email/WhatsApp/SMS notification queue';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_notifications_status ON reserve.notification_outbox(status, scheduled_at) WHERE status = 'pending';
CREATE INDEX IF NOT EXISTS idx_notifications_reservation ON reserve.notification_outbox(reservation_id);
CREATE INDEX IF NOT EXISTS idx_notifications_recipient ON reserve.notification_outbox(recipient_type, recipient_id);
CREATE INDEX IF NOT EXISTS idx_notifications_channel ON reserve.notification_outbox(channel, status);

-- ============================================
-- 3. HOST SYNC JOBS
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.host_sync_jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_name VARCHAR(100) NOT NULL,
    job_type VARCHAR(50) NOT NULL,
    CONSTRAINT valid_job_type CHECK (job_type IN (
        'property_sync',
        'unit_sync',
        'availability_sync',
        'booking_sync',
        'full_sync'
    )),
    direction reserve.sync_direction NOT NULL,
    
    -- Scope
    property_id UUID REFERENCES reserve.properties_map(id),
    city_code VARCHAR(10) REFERENCES reserve.cities(code),
    date_from DATE,
    date_to DATE,
    
    -- Status
    status reserve.sync_status DEFAULT 'pending',
    priority INTEGER DEFAULT 5,
    
    -- Tracking
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    records_processed INTEGER DEFAULT 0,
    records_failed INTEGER DEFAULT 0,
    
    -- Performance
    duration_ms INTEGER,
    
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.host_sync_jobs IS 'Host Connect synchronization job tracking';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_sync_jobs_status ON reserve.host_sync_jobs(status, priority, created_at);
CREATE INDEX IF NOT EXISTS idx_sync_jobs_property ON reserve.host_sync_jobs(property_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sync_jobs_city ON reserve.host_sync_jobs(city_code, status);

-- ============================================
-- 4. HOST WEBHOOK EVENTS (for replay)
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.host_webhook_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id VARCHAR(100) UNIQUE NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    
    -- Payload
    payload JSONB NOT NULL,
    headers JSONB,
    
    -- Processing
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'ignored')),
    processed_at TIMESTAMPTZ,
    error_message TEXT,
    
    -- Idempotency
    idempotency_key VARCHAR(100),
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE reserve.host_webhook_events IS 'Host Connect webhook events for replay and audit';

-- Indexes
CREATE INDEX IF NOT EXISTS idx_webhook_events ON reserve.host_webhook_events(event_id, status);
CREATE INDEX IF NOT EXISTS idx_webhook_events_type ON reserve.host_webhook_events(event_type, created_at);
CREATE INDEX IF NOT EXISTS idx_webhook_events_status ON reserve.host_webhook_events(status, created_at) WHERE status = 'pending';

-- ============================================
-- 5. RLS POLICIES
-- ============================================

ALTER TABLE reserve.audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.notification_outbox ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.host_sync_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.host_webhook_events ENABLE ROW LEVEL SECURITY;

-- All operational tables: service role only
CREATE POLICY IF NOT EXISTS audit_service_all ON reserve.audit_logs FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS notifications_service_all ON reserve.notification_outbox FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS sync_jobs_service_all ON reserve.host_sync_jobs FOR ALL TO service_role USING (true);
CREATE POLICY IF NOT EXISTS webhook_events_service_all ON reserve.host_webhook_events FOR ALL TO service_role USING (true);

-- ============================================
-- 6. TRIGGERS
-- ============================================

DO $$
DECLARE
    tbl text;
    tables text[] := ARRAY['notification_outbox', 'host_sync_jobs'];
BEGIN
    FOREACH tbl IN ARRAY tables
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS trg_%I_updated_at ON reserve.%I', tbl, tbl);
        EXECUTE format('CREATE TRIGGER trg_%I_updated_at BEFORE UPDATE ON reserve.%I FOR EACH ROW EXECUTE FUNCTION reserve.update_updated_at_column()', tbl, tbl);
    END LOOP;
END $$;

-- ============================================
-- 7. AUDIT TRIGGER FUNCTION
-- ============================================

CREATE OR REPLACE FUNCTION reserve.audit_trigger()
RETURNS TRIGGER AS $$
DECLARE
    old_data JSONB;
    new_data JSONB;
    changed_fields JSONB := '{}'::JSONB;
    key TEXT;
BEGIN
    IF TG_OP = 'DELETE' THEN
        old_data := to_jsonb(OLD);
        INSERT INTO reserve.audit_logs (table_name, record_id, action, old_data, actor_type, city_code)
        VALUES (TG_TABLE_NAME, OLD.id, 'DELETE', old_data, 'system', NULL);
        RETURN OLD;
    ELSIF TG_OP = 'INSERT' THEN
        new_data := to_jsonb(NEW);
        INSERT INTO reserve.audit_logs (table_name, record_id, action, new_data, actor_type, city_code)
        VALUES (TG_TABLE_NAME, NEW.id, 'INSERT', new_data, 'system', NULL);
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        old_data := to_jsonb(OLD);
        new_data := to_jsonb(NEW);
        
        -- Calculate changed fields
        FOR key IN SELECT jsonb_object_keys(new_data)
        LOOP
            IF old_data->key IS DISTINCT FROM new_data->key THEN
                changed_fields := changed_fields || jsonb_build_object(key, jsonb_build_object('old', old_data->key, 'new', new_data->key));
            END IF;
        END LOOP;
        
        INSERT INTO reserve.audit_logs (table_name, record_id, action, old_data, new_data, changed_fields, actor_type, city_code, reservation_id)
        VALUES (
            TG_TABLE_NAME, 
            NEW.id, 
            'UPDATE', 
            old_data, 
            new_data, 
            changed_fields,
            'system',
            NEW.city_code,
            CASE WHEN TG_TABLE_NAME = 'reservations' THEN NEW.id ELSE NULL END
        );
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Apply audit trigger to critical tables
DO $$
BEGIN
    -- Reservations
    DROP TRIGGER IF EXISTS trg_reservations_audit ON reserve.reservations;
    CREATE TRIGGER trg_reservations_audit
        AFTER INSERT OR UPDATE OR DELETE ON reserve.reservations
        FOR EACH ROW EXECUTE FUNCTION reserve.audit_trigger();
    
    -- Booking intents
    DROP TRIGGER IF EXISTS trg_booking_intents_audit ON reserve.booking_intents;
    CREATE TRIGGER trg_booking_intents_audit
        AFTER INSERT OR UPDATE OR DELETE ON reserve.booking_intents
        FOR EACH ROW EXECUTE FUNCTION reserve.audit_trigger();
    
    -- Payments
    DROP TRIGGER IF EXISTS trg_payments_audit ON reserve.payments;
    CREATE TRIGGER trg_payments_audit
        AFTER INSERT OR UPDATE OR DELETE ON reserve.payments
        FOR EACH ROW EXECUTE FUNCTION reserve.audit_trigger();
    
    -- Payouts
    DROP TRIGGER IF EXISTS trg_payouts_audit ON reserve.payouts;
    CREATE TRIGGER trg_payouts_audit
        AFTER INSERT OR UPDATE OR DELETE ON reserve.payouts
        FOR EACH ROW EXECUTE FUNCTION reserve.audit_trigger();
        
    RAISE NOTICE 'Audit triggers applied successfully';
END $$;

-- ============================================
-- 8. SEED DATA
-- ============================================

-- Create test sync job
INSERT INTO reserve.host_sync_jobs (job_name, job_type, direction, city_code, status, records_processed)
VALUES (
    'Initial Property Sync',
    'property_sync',
    'pull_from_host',
    'URB',
    'completed',
    1
);

-- Create test notification
INSERT INTO reserve.notification_outbox (
    city_code,
    recipient_type,
    recipient_id,
    email,
    channel,
    template_id,
    subject,
    status
)
SELECT 
    'URB',
    'traveler',
    t.id,
    t.email,
    'email',
    'booking_confirmation',
    'Your reservation is confirmed!',
    'sent'
FROM reserve.travelers t
WHERE t.email = 'test@example.com'
ON CONFLICT DO NOTHING;

-- ============================================
-- 9. CLEANUP FUNCTION (for expired intents)
-- ============================================

CREATE OR REPLACE FUNCTION reserve.cleanup_expired_intents()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    -- Release soft holds
    UPDATE reserve.availability_calendar ac
    SET temp_holds = GREATEST(0, temp_holds - 1)
    FROM reserve.booking_intents bi
    WHERE bi.status IN ('intent_created', 'payment_pending')
      AND bi.expires_at < NOW()
      AND ac.unit_id = bi.unit_id;
    
    -- Mark expired
    UPDATE reserve.booking_intents
    SET status = 'expired',
        updated_at = NOW()
    WHERE status IN ('intent_created', 'payment_pending')
      AND expires_at < NOW();
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION reserve.cleanup_expired_intents IS 'Cleans up expired booking intents and releases soft holds';

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 'Migration 004: Operations & Audit completed successfully' as status;

SELECT 
    'audit_logs' as table_name, COUNT(*) as count FROM reserve.audit_logs
UNION ALL
SELECT 'notification_outbox', COUNT(*) FROM reserve.notification_outbox
UNION ALL
SELECT 'host_sync_jobs', COUNT(*) FROM reserve.host_sync_jobs
UNION ALL
SELECT 'host_webhook_events', COUNT(*) FROM reserve.host_webhook_events;

-- Show sample audit log
SELECT table_name, action, record_id, created_at 
FROM reserve.audit_logs 
ORDER BY created_at DESC 
LIMIT 5;
