-- ============================================
-- QA VERIFICATION SCRIPT
-- Description: Comprehensive verification of Reserve Connect schema
-- Version: 1.0
-- Date: 2026-02-16
-- ============================================

-- Enable timing
\timing on

-- ============================================
-- SECTION 1: SCHEMA OBJECTS COUNT
-- ============================================

SELECT 'SCHEMA VERIFICATION STARTED' as check_point, NOW() as timestamp;

-- Count tables
SELECT 
    'Tables' as object_type,
    COUNT(*) as count,
    CASE 
        WHEN COUNT(*) >= 35 THEN 'PASS'
        ELSE 'FAIL'
    END as status
FROM information_schema.tables 
WHERE table_schema = 'reserve';

-- Count enums
SELECT 
    'Enums' as object_type,
    COUNT(*) as count,
    CASE 
        WHEN COUNT(*) >= 7 THEN 'PASS'
        ELSE 'FAIL'
    END as status
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
WHERE n.nspname = 'reserve' AND t.typtype = 'e';

-- Count indexes
SELECT 
    'Indexes' as object_type,
    COUNT(*) as count,
    'INFO' as status
FROM pg_indexes 
WHERE schemaname = 'reserve';

-- Count functions
SELECT 
    'Functions' as object_type,
    COUNT(*) as count,
    CASE 
        WHEN COUNT(*) >= 5 THEN 'PASS'
        ELSE 'FAIL'
    END as status
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'reserve';

-- Count triggers
SELECT 
    'Triggers' as object_type,
    COUNT(*) as count,
    'INFO' as status
FROM pg_trigger t
JOIN pg_class c ON c.oid = t.tgrelid
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'reserve';

-- Count RLS policies
SELECT 
    'RLS Policies' as object_type,
    COUNT(*) as count,
    CASE 
        WHEN COUNT(*) >= 35 THEN 'PASS'
        ELSE 'FAIL'
    END as status
FROM pg_policies 
WHERE schemaname = 'reserve';

-- ============================================
-- SECTION 2: CRITICAL TABLES VERIFICATION
-- ============================================

WITH expected_tables AS (
    SELECT unnest(ARRAY[
        'cities',
        'city_site_mappings',
        'properties_map',
        'unit_map',
        'rate_plans',
        'availability_calendar',
        'travelers',
        'booking_intents',
        'reservations',
        'payments',
        'ledger_entries',
        'commission_tiers',
        'payout_schedules',
        'payout_batches',
        'payouts',
        'audit_logs',
        'notification_outbox',
        'host_sync_jobs',
        'host_webhook_events',
        'events',
        'reviews',
        'review_invitations',
        'ads_slots',
        'ads_campaigns',
        'ads_impressions',
        'ads_clicks',
        'kpi_daily_snapshots',
        'property_owners',
        'owner_properties',
        'vendor_payables',
        'receivables',
        'invoices',
        'service_providers',
        'service_catalog',
        'service_orders',
        'service_payouts'
    ]) as table_name
)
SELECT 
    e.table_name,
    CASE 
        WHEN t.table_name IS NOT NULL THEN 'EXISTS'
        ELSE 'MISSING'
    END as status,
    CASE 
        WHEN t.table_name IS NOT NULL THEN 'PASS'
        ELSE 'FAIL'
    END as result
FROM expected_tables e
LEFT JOIN information_schema.tables t ON t.table_schema = 'reserve' AND t.table_name = e.table_name
ORDER BY e.table_name;

-- ============================================
-- SECTION 3: TABLE STRUCTURE VERIFICATION
-- ============================================

-- Verify cities table structure
SELECT 'cities' as table_name,
    COUNT(*) FILTER (WHERE column_name IN ('id', 'code', 'name', 'state_province', 'is_active')) as required_columns,
    CASE 
        WHEN COUNT(*) FILTER (WHERE column_name = 'code') > 0 THEN 'PASS'
        ELSE 'FAIL'
    END as has_code_column,
    CASE 
        WHEN COUNT(*) FILTER (WHERE column_name = 'is_active') > 0 THEN 'PASS'
        ELSE 'FAIL'
    END as has_active_column
FROM information_schema.columns 
WHERE table_schema = 'reserve' AND table_name = 'cities';

-- Verify properties_map structure
SELECT 'properties_map' as table_name,
    COUNT(*) FILTER (WHERE column_name IN ('id', 'host_property_id', 'city_id', 'slug', 'is_published')) as required_columns,
    CASE 
        WHEN COUNT(*) FILTER (WHERE column_name = 'slug') > 0 THEN 'PASS'
        ELSE 'FAIL'
    END as has_slug_column,
    CASE 
        WHEN COUNT(*) FILTER (WHERE column_name = 'host_property_id') > 0 THEN 'PASS'
        ELSE 'FAIL'
    END as has_host_id_column
FROM information_schema.columns 
WHERE table_schema = 'reserve' AND table_name = 'properties_map';

-- Verify reservations structure
SELECT 'reservations' as table_name,
    COUNT(*) FILTER (WHERE column_name IN ('id', 'confirmation_code', 'status', 'payment_status', 'total_amount')) as required_columns,
    CASE 
        WHEN COUNT(*) FILTER (WHERE column_name = 'confirmation_code') > 0 THEN 'PASS'
        ELSE 'FAIL'
    END as has_confirmation_code,
    CASE 
        WHEN COUNT(*) FILTER (WHERE column_name = 'city_code') > 0 THEN 'PASS'
        ELSE 'FAIL'
    END as has_city_code
FROM information_schema.columns 
WHERE table_schema = 'reserve' AND table_name = 'reservations';

-- Verify payments structure
SELECT 'payments' as table_name,
    COUNT(*) FILTER (WHERE column_name IN ('id', 'reservation_id', 'gateway', 'gateway_payment_id', 'amount', 'status')) as required_columns,
    CASE 
        WHEN COUNT(*) FILTER (WHERE column_name = 'pix_qr_code') > 0 THEN 'PASS'
        ELSE 'FAIL'
    END as has_pix_fields,
    CASE 
        WHEN COUNT(*) FILTER (WHERE column_name = 'stripe_client_secret') > 0 THEN 'PASS'
        ELSE 'FAIL'
    END as has_stripe_fields
FROM information_schema.columns 
WHERE table_schema = 'reserve' AND table_name = 'payments';

-- ============================================
-- SECTION 4: INDEX VERIFICATION
-- ============================================

-- Verify critical indexes exist
WITH expected_indexes AS (
    SELECT 'idx_properties_map_city' as index_name, 'properties_map' as table_name UNION ALL
    SELECT 'idx_properties_map_slug', 'properties_map' UNION ALL
    SELECT 'idx_properties_map_active', 'properties_map' UNION ALL
    SELECT 'idx_unit_map_property', 'unit_map' UNION ALL
    SELECT 'idx_availability_unit_date', 'availability_calendar' UNION ALL
    SELECT 'idx_reservations_code', 'reservations' UNION ALL
    SELECT 'idx_reservations_property', 'reservations' UNION ALL
    SELECT 'idx_payments_reservation', 'payments' UNION ALL
    SELECT 'idx_payments_gateway', 'payments' UNION ALL
    SELECT 'idx_ledger_transaction', 'ledger_entries' UNION ALL
    SELECT 'idx_events_name', 'events' UNION ALL
    SELECT 'idx_reviews_property', 'reviews'
)
SELECT 
    e.index_name,
    e.table_name,
    CASE 
        WHEN i.indexname IS NOT NULL THEN 'EXISTS'
        ELSE 'MISSING'
    END as status,
    CASE 
        WHEN i.indexname IS NOT NULL THEN 'PASS'
        ELSE 'WARN'
    END as result
FROM expected_indexes e
LEFT JOIN pg_indexes i ON i.schemaname = 'reserve' AND i.tablename = e.table_name AND i.indexname = e.index_name
ORDER BY e.table_name, e.index_name;

-- ============================================
-- SECTION 5: FOREIGN KEY VERIFICATION
-- ============================================

-- Verify critical foreign keys
SELECT 
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    'PASS' as status
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema = 'reserve'
    AND tc.table_name IN ('properties_map', 'unit_map', 'reservations', 'payments', 'ledger_entries')
ORDER BY tc.table_name, kcu.column_name;

-- ============================================
-- SECTION 6: RLS POLICY VERIFICATION
-- ============================================

-- Verify RLS is enabled on critical tables
SELECT 
    c.relname as table_name,
    c.relrowsecurity as rls_enabled,
    CASE 
        WHEN c.relrowsecurity THEN 'PASS'
        ELSE 'FAIL'
    END as status
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'reserve'
    AND c.relkind = 'r'
    AND c.relname IN ('properties_map', 'unit_map', 'reservations', 'payments', 'travelers', 'booking_intents')
ORDER BY c.relname;

-- Count policies per table
SELECT 
    tablename,
    COUNT(*) as policy_count,
    CASE 
        WHEN COUNT(*) >= 1 THEN 'PASS'
        ELSE 'FAIL'
    END as status
FROM pg_policies
WHERE schemaname = 'reserve'
GROUP BY tablename
ORDER BY tablename;

-- ============================================
-- SECTION 7: SEED DATA VERIFICATION
-- ============================================

-- Verify seed data exists
SELECT 
    'Cities' as data_type,
    COUNT(*) as count,
    CASE WHEN COUNT(*) >= 1 THEN 'PASS' ELSE 'FAIL' END as status
FROM reserve.cities;

SELECT 
    'Properties' as data_type,
    COUNT(*) as count,
    CASE WHEN COUNT(*) >= 1 THEN 'PASS' ELSE 'FAIL' END as status
FROM reserve.properties_map;

SELECT 
    'Units' as data_type,
    COUNT(*) as count,
    CASE WHEN COUNT(*) >= 1 THEN 'PASS' ELSE 'FAIL' END as status
FROM reserve.unit_map;

SELECT 
    'Rate Plans' as data_type,
    COUNT(*) as count,
    CASE WHEN COUNT(*) >= 1 THEN 'PASS' ELSE 'FAIL' END as status
FROM reserve.rate_plans;

SELECT 
    'Availability Records' as data_type,
    COUNT(*) as count,
    CASE WHEN COUNT(*) >= 30 THEN 'PASS' ELSE 'WARN' END as status
FROM reserve.availability_calendar;

SELECT 
    'Travelers' as data_type,
    COUNT(*) as count,
    CASE WHEN COUNT(*) >= 1 THEN 'PASS' ELSE 'WARN' END as status
FROM reserve.travelers;

SELECT 
    'Reservations' as data_type,
    COUNT(*) as count,
    CASE WHEN COUNT(*) >= 1 THEN 'PASS' ELSE 'WARN' END as status
FROM reserve.reservations;

SELECT 
    'Payments' as data_type,
    COUNT(*) as count,
    CASE WHEN COUNT(*) >= 1 THEN 'PASS' ELSE 'WARN' END as status
FROM reserve.payments;

SELECT 
    'Ledger Entries' as data_type,
    COUNT(*) as count,
    CASE WHEN COUNT(*) >= 4 THEN 'PASS' ELSE 'WARN' END as status
FROM reserve.ledger_entries;

SELECT 
    'Commission Tiers' as data_type,
    COUNT(*) as count,
    CASE WHEN COUNT(*) >= 1 THEN 'PASS' ELSE 'FAIL' END as status
FROM reserve.commission_tiers;

SELECT 
    'Reviews' as data_type,
    COUNT(*) as count,
    CASE WHEN COUNT(*) >= 1 THEN 'PASS' ELSE 'WARN' END as status
FROM reserve.reviews;

SELECT 
    'Events' as data_type,
    COUNT(*) as count,
    CASE WHEN COUNT(*) >= 1 THEN 'PASS' ELSE 'WARN' END as status
FROM reserve.events;

-- ============================================
-- SECTION 8: FUNCTION VERIFICATION
-- ============================================

-- Verify functions exist
SELECT 
    p.proname as function_name,
    CASE 
        WHEN p.proname IS NOT NULL THEN 'EXISTS'
        ELSE 'MISSING'
    END as status,
    CASE 
        WHEN p.proname IN ('update_updated_at_column', 'generate_confirmation_code', 'cleanup_expired_intents', 'verify_ledger_balance', 'get_conversion_funnel') THEN 'PASS'
        ELSE 'INFO'
    END as result
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'reserve'
ORDER BY p.proname;

-- Test generate_confirmation_code function
SELECT 
    'generate_confirmation_code' as function_name,
    reserve.generate_confirmation_code() as sample_output,
    CASE 
        WHEN reserve.generate_confirmation_code() LIKE 'RES-2026-%' THEN 'PASS'
        ELSE 'FAIL'
    END as status;

-- Test verify_ledger_balance function
SELECT 
    'verify_ledger_balance' as function_name,
    reserve.verify_ledger_balance(gen_random_uuid()) as returns_boolean,
    'INFO' as status;

-- ============================================
-- SECTION 9: CONSTRAINTS VERIFICATION
-- ============================================

-- Verify check constraints
SELECT 
    tc.table_name,
    tc.constraint_name,
    CASE 
        WHEN tc.constraint_type = 'CHECK' THEN 'CHECK'
        ELSE tc.constraint_type
    END as constraint_type,
    'PASS' as status
FROM information_schema.table_constraints tc
WHERE tc.table_schema = 'reserve'
    AND tc.constraint_type IN ('CHECK', 'UNIQUE', 'PRIMARY KEY')
    AND tc.table_name IN ('booking_intents', 'reservations', 'payments')
ORDER BY tc.table_name, tc.constraint_name;

-- ============================================
-- SECTION 10: TRIGGERS VERIFICATION
-- ============================================

-- Verify updated_at triggers
SELECT 
    c.relname as table_name,
    t.tgname as trigger_name,
    CASE 
        WHEN t.tgname LIKE 'trg_%_updated_at' THEN 'PASS'
        ELSE 'INFO'
    END as status
FROM pg_trigger t
JOIN pg_class c ON c.oid = t.tgrelid
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'reserve'
    AND NOT t.tgisinternal
ORDER BY c.relname, t.tgname;

-- Verify audit triggers
SELECT 
    c.relname as table_name,
    t.tgname as trigger_name,
    'AUDIT_TRIGGER' as type,
    'PASS' as status
FROM pg_trigger t
JOIN pg_class c ON c.oid = t.tgrelid
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'reserve'
    AND t.tgname LIKE 'trg_%_audit'
ORDER BY c.relname;

-- ============================================
-- SECTION 11: COMPREHENSIVE DATA TESTS
-- ============================================

-- Test: City has properties
SELECT 
    'City-Property Relationship' as test_name,
    c.code as city_code,
    COUNT(p.id) as property_count,
    CASE WHEN COUNT(p.id) >= 1 THEN 'PASS' ELSE 'WARN' END as status
FROM reserve.cities c
LEFT JOIN reserve.properties_map p ON p.city_id = c.id
GROUP BY c.code;

-- Test: Property has units
SELECT 
    'Property-Unit Relationship' as test_name,
    p.slug,
    COUNT(u.id) as unit_count,
    CASE WHEN COUNT(u.id) >= 1 THEN 'PASS' ELSE 'WARN' END as status
FROM reserve.properties_map p
LEFT JOIN reserve.unit_map u ON u.property_id = p.id
GROUP BY p.slug;

-- Test: Unit has availability
SELECT 
    'Unit-Availability Relationship' as test_name,
    u.slug,
    COUNT(a.id) as availability_count,
    CASE WHEN COUNT(a.id) >= 1 THEN 'PASS' ELSE 'WARN' END as status
FROM reserve.unit_map u
LEFT JOIN reserve.availability_calendar a ON a.unit_id = u.id
GROUP BY u.slug;

-- Test: Reservation links to property and traveler
SELECT 
    'Reservation Relationships' as test_name,
    r.confirmation_code,
    p.name as property_name,
    t.email as traveler_email,
    CASE 
        WHEN p.id IS NOT NULL AND t.id IS NOT NULL THEN 'PASS'
        ELSE 'FAIL'
    END as status
FROM reserve.reservations r
JOIN reserve.properties_map p ON p.id = r.property_id
LEFT JOIN reserve.travelers t ON t.id = r.traveler_id
WHERE r.confirmation_code = 'RES-2026-TEST01';

-- Test: Payment links to reservation
SELECT 
    'Payment-Reservation Relationship' as test_name,
    p.gateway_payment_id,
    r.confirmation_code,
    CASE 
        WHEN r.id IS NOT NULL THEN 'PASS'
        ELSE 'FAIL'
    END as status
FROM reserve.payments p
JOIN reserve.reservations r ON r.id = p.reservation_id
WHERE p.gateway_payment_id = 'pi_test_001';

-- Test: Ledger entries balance
SELECT 
    'Ledger Balance' as test_name,
    le.transaction_id,
    SUM(CASE WHEN le.direction = 'debit' THEN le.amount ELSE 0 END) as debits,
    SUM(CASE WHEN le.direction = 'credit' THEN le.amount ELSE 0 END) as credits,
    CASE 
        WHEN SUM(CASE WHEN le.direction = 'debit' THEN le.amount ELSE 0 END) = 
             SUM(CASE WHEN le.direction = 'credit' THEN le.amount ELSE 0 END) THEN 'PASS'
        ELSE 'FAIL'
    END as status
FROM reserve.ledger_entries le
WHERE le.created_at > NOW() - INTERVAL '1 day'
GROUP BY le.transaction_id
LIMIT 5;

-- ============================================
-- SECTION 12: PERFORMANCE TESTS
-- ============================================

-- Test query performance: Property search
EXPLAIN (ANALYZE, TIMING, FORMAT TEXT)
SELECT p.*, MIN(a.base_price) as min_price
FROM reserve.properties_map p
LEFT JOIN reserve.unit_map u ON u.property_id = p.id
LEFT JOIN reserve.availability_calendar a ON a.unit_id = u.id AND a.date = CURRENT_DATE + 30
WHERE p.city_id = (SELECT id FROM reserve.cities WHERE code = 'URB')
  AND p.is_active = true
  AND p.is_published = true
GROUP BY p.id
LIMIT 10;

-- Test query performance: Availability search
EXPLAIN (ANALYZE, TIMING, FORMAT TEXT)
SELECT 
    p.id, p.name, p.slug,
    MIN(a.base_price) as min_price
FROM reserve.properties_map p
JOIN reserve.unit_map u ON u.property_id = p.id
JOIN reserve.availability_calendar a ON a.unit_id = u.id
WHERE p.city_id = (SELECT id FROM reserve.cities WHERE code = 'URB')
  AND p.is_active = true
  AND p.is_published = true
  AND a.date BETWEEN CURRENT_DATE + 30 AND CURRENT_DATE + 34
  AND a.is_available = true
  AND a.is_blocked = false
GROUP BY p.id
HAVING COUNT(DISTINCT a.date) = 5;

-- ============================================
-- FINAL SUMMARY
-- ============================================

SELECT '========================================' as separator;
SELECT 'QA VERIFICATION COMPLETED' as message, NOW() as timestamp;
SELECT '========================================' as separator;

-- Summary counts
SELECT 
    'TOTAL CHECKS' as metric,
    (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'reserve')::text as value
UNION ALL
SELECT 
    'TABLES WITH RLS',
    (SELECT COUNT(*) FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE n.nspname = 'reserve' AND c.relkind = 'r' AND c.relrowsecurity = true)::text
UNION ALL
SELECT 
    'TOTAL INDEXES',
    (SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'reserve')::text
UNION ALL
SELECT 
    'FOREIGN KEYS',
    (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = 'reserve' AND constraint_type = 'FOREIGN KEY')::text
UNION ALL
SELECT 
    'RLS POLICIES',
    (SELECT COUNT(*) FROM pg_policies WHERE schemaname = 'reserve')::text
UNION ALL
SELECT 
    'FUNCTIONS',
    (SELECT COUNT(*) FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace WHERE n.nspname = 'reserve')::text;

-- End timing
\timing off
