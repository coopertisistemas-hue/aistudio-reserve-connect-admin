# POST-MIGRATION VERIFICATION CHECKLIST

## Pre-Deployment Checklist

- [ ] Backup database (if production data exists)
- [ ] Review migrations in staging environment
- [ ] Notify team of maintenance window
- [ ] Have rollback plan ready

---

## Migration 010 - Security Hardening

### Step 1: Deploy Migration
```bash
psql "postgresql://postgres:Syb%40s3%232025%23@db.ffahkiukektmhkrkordn.supabase.co:5432/postgres?sslmode=require" \
  -f supabase/migrations/010_security_hardening.sql
```

### Step 2: Verify RLS Coverage
```sql
-- All tables should have RLS enabled
SELECT c.relname, c.relrowsecurity
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname='reserve' AND c.relkind='r' AND NOT c.relrowsecurity;

-- Expected: 0 rows returned
```

**Status:** ⬜ Verified

### Step 3: Verify Ledger Balance Trigger
```sql
-- Check trigger exists
SELECT tgname, tgenabled 
FROM pg_trigger 
WHERE tgname = 'trg_ledger_balance';

-- Expected: 1 row with trigger details
```

**Status:** ⬜ Verified

### Step 4: Test Ledger Balance Enforcement
```sql
-- Try to create unbalanced ledger entry (should fail)
DO $$
DECLARE
    txn_id UUID := gen_random_uuid();
BEGIN
    INSERT INTO reserve.ledger_entries (transaction_id, entry_type, account, direction, amount, city_code)
    VALUES (txn_id, 'test', 'cash_reserve', 'debit', 100, 'URB');
    
    -- Missing credit entry
    COMMIT; -- This should fail
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Good! Ledger balance check is working: %', SQLERRM;
END $$;
```

**Status:** ⬜ Tested

### Step 5: Verify Payment Method Constraint
```sql
-- Check constraint exists
SELECT constraint_name 
FROM information_schema.check_constraints 
WHERE constraint_name = 'valid_payment_method';

-- Test constraint
INSERT INTO reserve.payments (booking_intent_id, city_code, payment_method, gateway, gateway_payment_id, amount)
VALUES (gen_random_uuid(), 'URB', 'invalid_method', 'test', 'test', 100);
-- Expected: ERROR - violates check constraint
```

**Status:** ⬜ Tested

### Step 6: Verify Public Views
```sql
-- Check view exists
SELECT * FROM reserve.public_properties LIMIT 1;

-- Verify PII is masked
SELECT phone_masked, email_masked 
FROM reserve.public_properties 
WHERE phone IS NOT NULL OR email IS NOT NULL 
LIMIT 1;

-- Expected: masked values like "***-***-9999" and "***@domain.com"
```

**Status:** ⬜ Verified

---

## Migration 011 - Performance Indexes

### Step 1: Deploy Migration
```bash
psql "postgresql://postgres:Syb%40s3%232025%23@db.ffahkiukektmhkrkordn.supabase.co:5432/postgres?sslmode=require" \
  -f supabase/migrations/011_performance_indexes.sql
```

### Step 2: Verify Indexes Created
```sql
-- Count partial indexes (should have WHERE clause)
SELECT COUNT(*) 
FROM pg_indexes 
WHERE schemaname = 'reserve' 
AND indexdef LIKE '%WHERE%';

-- Expected: >= 5 new partial indexes
```

**Status:** ⬜ Verified

### Step 3: Verify Specific Indexes
```sql
-- Check key indexes exist
SELECT indexname, indexdef 
FROM pg_indexes 
WHERE schemaname = 'reserve' 
AND indexname IN (
    'idx_availability_available',
    'idx_reservations_active',
    'idx_payments_pending_cleanup',
    'idx_events_analytics'
);

-- Expected: 4 rows
```

**Status:** ⬜ Verified

### Step 4: Test Query Performance
```sql
-- Explain search availability query (should use index)
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT ac.unit_id, ac.date, ac.base_price
FROM reserve.availability_calendar ac
WHERE ac.unit_id = '00000000-0000-0000-0000-000000000001'
  AND ac.date BETWEEN '2026-03-01' AND '2026-03-05'
  AND ac.is_available = true 
  AND ac.is_blocked = false;

-- Look for: "Index Scan" or "Index Only Scan"
```

**Status:** ⬜ Tested

### Step 5: Update Statistics
```sql
-- Verify statistics updated
SELECT last_analyze, last_autoanalyze
FROM pg_stat_user_tables
WHERE schemaname = 'reserve' AND relname = 'availability_calendar';

-- Expected: recent timestamp
```

**Status:** ⬜ Verified

---

## Edge Functions Verification

### Test 1: Search Availability
```bash
curl -X POST https://ffahkiukektmhkrkordn.supabase.co/functions/v1/search_availability \
  -H "Content-Type: application/json" \
  -d '{
    "city_code": "URB",
    "check_in": "2026-03-01",
    "check_out": "2026-03-05",
    "guests_adults": 2
  }'
```

**Expected:** 200 OK with properties list  
**Status:** ⬜ Tested

### Test 2: Create Booking Intent
```bash
curl -X POST https://ffahkiukektmhkrkordn.supabase.co/functions/v1/create_booking_intent \
  -H "Content-Type: application/json" \
  -H "X-Session-ID: test_session_001" \
  -d '{
    "session_id": "test_session_001",
    "city_code": "URB",
    "property_slug": "pousada-teste-urb",
    "unit_id": "b60a1184-29c4-477f-8e5f-06435d7bf7aa",
    "check_in": "2026-03-01",
    "check_out": "2026-03-05",
    "guests_adults": 2
  }'
```

**Expected:** 200 OK with intent_id and pricing  
**Status:** ⬜ Tested

### Test 3: Get Property Detail
```bash
curl -X POST https://ffahkiukektmhkrkordn.supabase.co/functions/v1/get_property_detail \
  -H "Content-Type: application/json" \
  -d '{
    "slug": "pousada-teste-urb",
    "check_in": "2026-03-01",
    "check_out": "2026-03-05"
  }'
```

**Expected:** 200 OK with property details  
**Status:** ⬜ Tested

### Test 4: Poll Payment Status
```bash
curl -X POST https://ffahkiukektmhkrkordn.supabase.co/functions/v1/poll_payment_status \
  -H "Content-Type: application/json" \
  -d '{
    "intent_id": "paste_intent_id_here"
  }'
```

**Expected:** 200 OK with status  
**Status:** ⬜ Tested

---

## Security Verification

### Test 5: RLS Protection
```sql
-- Try to access data as anon user (should be limited)
-- In Supabase Dashboard SQL Editor with anon key:
SET ROLE anon;

-- Should fail or return limited data
SELECT * FROM reserve.travelers;
-- Expected: 0 rows (no access)

SELECT * FROM reserve.properties_map;
-- Expected: Only published properties

RESET ROLE;
```

**Status:** ⬜ Tested

### Test 6: Cross-City Isolation
```sql
-- Verify city_code filtering works
SELECT city_code, COUNT(*) 
FROM reserve.properties_map 
WHERE is_active = true AND is_published = true
GROUP BY city_code;

-- Should only show cities you're authorized to see
```

**Status:** ⬜ Verified

---

## Data Integrity Verification

### Test 7: Foreign Keys
```sql
-- Verify no orphaned records
SELECT 'booking_intents' as table_name, COUNT(*) as orphans
FROM reserve.booking_intents bi
LEFT JOIN reserve.properties_map p ON p.id = bi.property_id
WHERE p.id IS NULL;

-- Expected: 0 orphans
```

**Status:** ⬜ Verified

### Test 8: Ledger Balance
```sql
-- Verify all transactions are balanced
SELECT transaction_id, 
       SUM(CASE WHEN direction = 'debit' THEN amount ELSE 0 END) as debits,
       SUM(CASE WHEN direction = 'credit' THEN amount ELSE 0 END) as credits
FROM reserve.ledger_entries
GROUP BY transaction_id
HAVING SUM(CASE WHEN direction = 'debit' THEN amount ELSE 0 END) != 
       SUM(CASE WHEN direction = 'credit' THEN amount ELSE 0 END);

-- Expected: 0 rows (all balanced)
```

**Status:** ⬜ Verified

---

## Performance Verification

### Test 9: Query Timing
```sql
-- Before and after timing
EXPLAIN (ANALYZE, TIMING)
SELECT p.*, MIN(ac.base_price) as min_price
FROM reserve.properties_map p
JOIN reserve.unit_map u ON u.property_id = p.id
JOIN reserve.availability_calendar ac ON ac.unit_id = u.id
WHERE p.city_code = 'URB'
  AND p.is_active = true
  AND p.is_published = true
  AND ac.date = '2026-03-01'
  AND ac.is_available = true
GROUP BY p.id;

-- Should complete in < 100ms with indexes
```

**Status:** ⬜ Tested

### Test 10: Index Usage
```sql
-- Check if new indexes are being used
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read
FROM pg_stat_user_indexes
WHERE schemaname = 'reserve'
AND indexname LIKE 'idx_%'
ORDER BY idx_scan DESC
LIMIT 10;

-- Should show scans on new indexes
```

**Status:** ⬜ Verified

---

## Rollback Plan

If issues occur:

### Rollback Migration 011 (Performance)
```sql
-- Drop new indexes
DROP INDEX IF EXISTS reserve.idx_availability_search_composite;
DROP INDEX IF EXISTS reserve.idx_availability_available;
DROP INDEX IF EXISTS reserve.idx_properties_search_covering;
DROP INDEX IF EXISTS reserve.idx_reservations_active;
DROP INDEX IF EXISTS idx_payments_gateway_lookup;
-- ... etc
```

### Rollback Migration 010 (Security)
```sql
-- Disable ledger trigger
DROP TRIGGER IF EXISTS trg_ledger_balance ON reserve.ledger_entries;

-- Drop constraints
ALTER TABLE reserve.payments DROP CONSTRAINT IF EXISTS valid_payment_method;

-- Drop views
DROP VIEW IF EXISTS reserve.public_properties;

-- Revert policies (if needed)
-- ...
```

---

## Final Sign-Off

**Deployed By:** _________________  
**Date:** _________________  
**Time:** _________________

### Checklist Summary
- [ ] Migration 010 deployed successfully
- [ ] Migration 011 deployed successfully
- [ ] All RLS policies working
- [ ] Ledger balance trigger active
- [ ] New indexes created
- [ ] Query performance improved
- [ ] Edge Functions responding
- [ ] No errors in logs
- [ ] Data integrity maintained
- [ ] Rollback tested (optional)

**Overall Status:** ⬜ **PASS** / ⬜ **FAIL**

**Notes:**
```
[Space for notes]
```

---

## Monitoring Post-Deployment

### Watch for 24-48 hours:
- [ ] Error rates in Edge Functions
- [ ] Database query performance
- [ ] Ledger balance violations (should be 0)
- [ ] Index usage statistics
- [ ] RLS policy violations
- [ ] Storage growth (audit_logs, events)

### Alerts to Configure:
- [ ] Ledger imbalance detected
- [ ] Failed payment webhooks
- [ ] Slow queries (> 1 second)
- [ ] RLS bypass attempts
- [ ] Storage > 80% capacity

---

**End of Checklist**

**Version:** 1.0  
**Last Updated:** 2026-02-16
