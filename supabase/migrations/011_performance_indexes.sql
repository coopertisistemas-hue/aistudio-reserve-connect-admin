-- ============================================
-- PERFORMANCE OPTIMIZATION MIGRATION
-- Description: Add missing indexes for common queries
-- Version: 1.0
-- Date: 2026-02-16
-- ============================================

-- ============================================
-- 1. SEARCH AVAILABILITY OPTIMIZATIONS
-- ============================================

-- Composite index for date range queries (most common)
CREATE INDEX IF NOT EXISTS idx_availability_search_composite 
ON reserve.availability_calendar(unit_id, rate_plan_id, date, is_available, is_blocked)
WHERE is_available = true AND is_blocked = false;

-- Partial index for available inventory
CREATE INDEX IF NOT EXISTS idx_availability_available 
ON reserve.availability_calendar(unit_id, date, base_price, discounted_price)
WHERE is_available = true AND is_blocked = false;

-- ============================================
-- 2. PROPERTY LISTING OPTIMIZATIONS
-- ============================================

-- Covering index for property search
CREATE INDEX IF NOT EXISTS idx_properties_search_covering 
ON reserve.properties_map(city_code, is_active, is_published, deleted_at, slug, name, rating_cached)
WHERE is_active = true AND is_published = true AND deleted_at IS NULL;

-- Index for property type filtering
CREATE INDEX IF NOT EXISTS idx_properties_by_type 
ON reserve.properties_map(property_type, city_code, is_active, is_published)
WHERE is_active = true AND is_published = true;

-- ============================================
-- 3. RESERVATION OPTIMIZATIONS
-- ============================================

-- Check-in date queries (operations dashboard)
CREATE INDEX IF NOT EXISTS idx_reservations_checkin_date 
ON reserve.reservations(check_in, status, property_id)
WHERE status IN ('confirmed', 'checked_in');

-- Guest lookup by email/phone
CREATE INDEX IF NOT EXISTS idx_reservations_guest_contact 
ON reserve.reservations(guest_email, guest_phone, created_at DESC)
WHERE guest_email IS NOT NULL OR guest_phone IS NOT NULL;

-- Active reservations by property
CREATE INDEX IF NOT EXISTS idx_reservations_property_active 
ON reserve.reservations(property_id, check_in, check_out, status)
WHERE status IN ('confirmed', 'checked_in', 'pending');

-- ============================================
-- 4. PAYMENT OPTIMIZATIONS
-- ============================================

-- Gateway payment lookup (webhook processing)
CREATE INDEX IF NOT EXISTS idx_payments_gateway_lookup 
ON reserve.payments(gateway, gateway_payment_id, status);

-- Pending payments for cleanup job
CREATE INDEX IF NOT EXISTS idx_payments_pending_cleanup 
ON reserve.payments(status, created_at)
WHERE status IN ('pending', 'processing');

-- Reservation payment lookup
CREATE INDEX IF NOT EXISTS idx_payments_reservation_lookup 
ON reserve.payments(reservation_id, status, created_at DESC);

-- PIX expiration check
CREATE INDEX IF NOT EXISTS idx_payments_pix_expiry 
ON reserve.payments(pix_expires_at, status)
WHERE payment_method = 'pix' AND status = 'pending';

-- ============================================
-- 5. LEDGER OPTIMIZATIONS
-- ============================================

-- Transaction balance check
CREATE INDEX IF NOT EXISTS idx_ledger_transaction_balance 
ON reserve.ledger_entries(transaction_id, direction, amount);

-- Account reconciliation
CREATE INDEX IF NOT EXISTS idx_ledger_account_date 
ON reserve.ledger_entries(account, created_at, city_code);

-- Booking lookup for financial reports
CREATE INDEX IF NOT EXISTS idx_ledger_booking_lookup 
ON reserve.ledger_entries(booking_id, entry_type, created_at);

-- ============================================
-- 6. EVENTS/ANALYTICS OPTIMIZATIONS
-- ============================================

-- Funnel analysis
CREATE INDEX IF NOT EXISTS idx_events_funnel 
ON reserve.events(event_name, city_code, session_id, created_at);

-- Property analytics
CREATE INDEX IF NOT EXISTS idx_events_property 
ON reserve.events(property_id, event_name, created_at DESC);

-- Correlation ID tracking (distributed tracing)
CREATE INDEX IF NOT EXISTS idx_events_correlation 
ON reserve.events(correlation_id, created_at);

-- Unprocessed events for worker
CREATE INDEX IF NOT EXISTS idx_events_unprocessed 
ON reserve.events(processed_at, created_at)
WHERE processed_at IS NULL;

-- ============================================
-- 7. UNIT/ROOM TYPE OPTIMIZATIONS
-- ============================================

-- Property units lookup
CREATE INDEX IF NOT EXISTS idx_units_property_lookup 
ON reserve.unit_map(property_id, is_active, max_occupancy)
WHERE is_active = true;

-- ============================================
-- 8. RATE PLANS OPTIMIZATIONS
-- ============================================

-- Default rate plan lookup
CREATE INDEX IF NOT EXISTS idx_rate_plans_default 
ON reserve.rate_plans(property_id, is_default, is_active)
WHERE is_default = true AND is_active = true;

-- ============================================
-- 9. TRAVELER OPTIMIZATIONS
-- ============================================

-- Email lookup for returning guests
CREATE INDEX IF NOT EXISTS idx_travelers_email_lookup 
ON reserve.travelers(email, created_at DESC);

-- Auth user lookup
CREATE INDEX IF NOT EXISTS idx_travelers_auth_lookup 
ON reserve.travelers(auth_user_id, is_verified)
WHERE auth_user_id IS NOT NULL;

-- ============================================
-- 10. SYNC JOBS OPTIMIZATIONS
-- ============================================

-- Pending jobs for worker
CREATE INDEX IF NOT EXISTS idx_sync_jobs_pending 
ON reserve.sync_jobs(status, priority, created_at)
WHERE status IN ('pending', 'retrying');

-- Jobs by property for monitoring
CREATE INDEX IF NOT EXISTS idx_sync_jobs_property 
ON reserve.sync_jobs(property_id, created_at DESC);

-- ============================================
-- 11. AUDIT LOGS OPTIMIZATIONS
-- ============================================

-- Recent audit entries
CREATE INDEX IF NOT EXISTS idx_audit_recent 
ON reserve.audit_logs(created_at DESC, table_name)
WHERE created_at > NOW() - INTERVAL '30 days';

-- By reservation for audit trail
CREATE INDEX IF NOT EXISTS idx_audit_reservation 
ON reserve.audit_logs(reservation_id, created_at DESC);

-- ============================================
-- 12. REVIEW OPTIMIZATIONS
-- ============================================

-- Published reviews by property
CREATE INDEX IF NOT EXISTS idx_reviews_published_property 
ON reserve.reviews(property_id, is_published, created_at DESC)
WHERE is_published = true;

-- Pending moderation
CREATE INDEX IF NOT EXISTS idx_reviews_pending_moderation 
ON reserve.reviews(is_published, created_at)
WHERE is_published = false;

-- ============================================
-- 13. CLEANUP REDUNDANT INDEXES
-- ============================================

-- Remove exact duplicate indexes
-- Example: if both idx_reservations_dates and idx_reservations_checkin exist
-- and cover similar columns

-- Check for redundant indexes
SELECT 
    'Redundant index candidates' as check_type,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'reserve'
    AND indexname LIKE 'idx_%'
ORDER BY tablename, indexname;

-- ============================================
-- 14. INDEX MAINTENANCE
-- ============================================

-- Update statistics after creating indexes
ANALYZE reserve.availability_calendar;
ANALYZE reserve.properties_map;
ANALYZE reserve.reservations;
ANALYZE reserve.payments;
ANALYZE reserve.ledger_entries;
ANALYZE reserve.events;

-- ============================================
-- VERIFICATION
-- ============================================

SELECT 
    'Performance Migration Summary' as report,
    COUNT(*)::text as total_indexes
FROM pg_indexes 
WHERE schemaname = 'reserve';

-- Show index sizes
SELECT 
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexname::regclass)) as index_size
FROM pg_indexes
WHERE schemaname = 'reserve'
    AND indexname LIKE 'idx_%'
ORDER BY pg_relation_size(indexname::regclass) DESC
LIMIT 20;

SELECT 'Performance Optimization Migration Completed Successfully' as status;
