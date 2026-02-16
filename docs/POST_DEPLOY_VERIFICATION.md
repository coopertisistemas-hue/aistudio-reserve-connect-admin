# POST-DEPLOYMENT VERIFICATION
## Reserve Connect Security Hardening - Verification Checklist

**Version:** 2.0  
**Date:** 2026-02-16  
**Classification:** INTERNAL USE ONLY  
**Owner:** Engineering Team  

---

## OVERVIEW

This document provides comprehensive verification procedures to ensure the security hardening migrations (012-016) and Edge Function updates have been successfully deployed and are functioning correctly.

**Estimated Verification Time:** 2-3 hours  
**Prerequisites:** All migrations applied to production database

---

## PHASE 1: DATABASE MIGRATION VERIFICATION (30 min)

### 1.1 Verify Migrations Applied

```sql
-- Check all migrations are present
SELECT 
  filename,
  CASE 
    WHEN applied_at IS NOT NULL THEN '✅ APPLIED'
    ELSE '❌ MISSING'
  END as status
FROM supabase_migrations.migrations
WHERE filename IN (
  '012_pii_vault_encryption.sql',
  '013_audit_log_redaction_retention.sql',
  '014_webhook_dedup_and_payment_safety.sql',
  '015_concurrency_and_booking_integrity.sql',
  '016_ops_monitoring_helpers.sql'
)
ORDER BY filename;

-- Expected: All 5 migrations show '✅ APPLIED'
```

**Pass Criteria:**
- [ ] All 5 migrations show as applied
- [ ] No errors in migration logs

### 1.2 Verify Encryption Infrastructure

```sql
-- Check encrypted columns exist
SELECT 
  table_name,
  string_agg(column_name, ', ') as encrypted_columns
FROM information_schema.columns
WHERE table_schema = 'reserve'
AND column_name LIKE '%_encrypted'
GROUP BY table_name
ORDER BY table_name;

-- Expected: travelers, property_owners, reservations, payouts, payments have encrypted columns

-- Check encryption triggers
SELECT 
  tgrelid::regclass as table_name,
  tgname as trigger_name,
  CASE WHEN tgenabled = 'O' THEN '✅ ENABLED' ELSE '❌ DISABLED' END as status
FROM pg_trigger
WHERE tgname LIKE 'trg_encrypt_%'
ORDER BY tgrelid::regclass::text;

-- Expected: All encryption triggers enabled
```

**Pass Criteria:**
- [ ] Minimum 10 encrypted columns across tables
- [ ] All encryption triggers enabled

### 1.3 Verify Vault Keys

```sql
-- Check encryption keys exist (requires Vault access)
SELECT 
  name,
  key_type,
  CASE WHEN id IS NOT NULL THEN '✅ EXISTS' ELSE '❌ MISSING' END as status
FROM vault.keys
WHERE name IN (
  'travelers_pii_key',
  'owners_pii_key', 
  'bank_details_key',
  'payment_secrets_key'
);

-- Expected: All 4 keys show '✅ EXISTS'
```

**Pass Criteria:**
- [ ] All 4 encryption keys present
- [ ] Keys have correct type (aead-det)

### 1.4 Verify Audit Log Redaction

```sql
-- Check redaction function
SELECT 
  proname,
  prosrc IS NOT NULL as has_implementation
FROM pg_proc
WHERE pronename = 'redact_pii_from_json';

-- Expected: has_implementation = true

-- Test redaction
SELECT reserve.redact_pii_from_json('{
  "email": "test@example.com",
  "phone": "+5511999999999",
  "document_number": "12345678900",
  "name": "John Doe"
}'::jsonb) as redacted;

-- Expected: All values redacted/masked
```

**Pass Criteria:**
- [ ] Redaction function exists
- [ ] Test shows proper redaction

### 1.5 Verify Retention Policies

```sql
-- Check retention policies configured
SELECT 
  table_name,
  retention_days,
  retention_type,
  is_active
FROM reserve.retention_policies
WHERE is_active = true
ORDER BY table_name;

-- Expected: audit_logs (365 days), events (90 days), etc.
```

**Pass Criteria:**
- [ ] All 6 retention policies active
- [ ] Reasonable retention periods set

---

## PHASE 2: WEBHOOK AND PAYMENT SAFETY (30 min)

### 2.1 Verify Webhook Infrastructure

```sql
-- Check processed_webhooks table
SELECT 
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'processed_webhooks'
AND table_schema = 'reserve'
ORDER BY ordinal_position;

-- Expected: provider, event_id, event_type, status, payment_id, etc.

-- Check unique constraint
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'reserve'
AND tablename = 'processed_webhooks'
AND indexdef LIKE '%UNIQUE%';

-- Expected: Unique constraint on (provider, event_id)
```

**Pass Criteria:**
- [ ] processed_webhooks table exists with correct schema
- [ ] Unique constraint preventing duplicates

### 2.2 Verify State Machine Triggers

```sql
-- Check payment state validation trigger
SELECT 
  tgrelid::regclass as table_name,
  tgname,
  tgenabled
FROM pg_trigger
WHERE tgname = 'trg_payment_state_validation';

-- Check intent state validation trigger
SELECT 
  tgrelid::regclass as table_name,
  tgname,
  tgenabled
FROM pg_trigger
WHERE tgname = 'trg_intent_state_validation';

-- Expected: Both triggers present and enabled
```

**Pass Criteria:**
- [ ] Payment state trigger enabled
- [ ] Intent state trigger enabled

### 2.3 Test State Transitions

```sql
-- Create test payment
INSERT INTO reserve.payments (
  booking_intent_id,
  city_code,
  payment_method,
  gateway,
  gateway_payment_id,
  amount,
  currency,
  status,
  idempotency_key
) VALUES (
  '00000000-0000-0000-0000-000000000000'::uuid,
  'test',
  'stripe_card',
  'stripe',
  'pi_test_' || extract(epoch from now()),
  100.00,
  'BRL',
  'pending',
  'test_' || extract(epoch from now())
)
RETURNING id;

-- Test valid transition: pending -> processing
UPDATE reserve.payments 
SET status = 'processing' 
WHERE id = 'test-payment-id';
-- Expected: Success

-- Test invalid transition: pending -> refunded (should fail)
UPDATE reserve.payments 
SET status = 'refunded' 
WHERE id = 'test-payment-id';
-- Expected: ERROR: Invalid payment status transition

-- Cleanup
DELETE FROM reserve.payments WHERE id = 'test-payment-id';
```

**Pass Criteria:**
- [ ] Valid transitions succeed
- [ ] Invalid transitions rejected with error

### 2.4 Verify Idempotency Constraints

```sql
-- Check unique indexes
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'reserve'
AND indexname IN ('idx_reservations_unique_intent', 'idx_payments_unique_intent_gateway');

-- Expected: Both indexes present
```

**Pass Criteria:**
- [ ] Reservation uniqueness constraint exists
- [ ] Payment uniqueness constraint exists

---

## PHASE 3: CONCURRENCY AND LOCKING (45 min)

### 3.1 Verify Booking Locks Table

```sql
-- Check booking_locks schema
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'booking_locks'
AND table_schema = 'reserve'
ORDER BY ordinal_position;

-- Check indexes
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'reserve'
AND tablename = 'booking_locks';

-- Expected: 5 indexes including unique constraint
```

**Pass Criteria:**
- [ ] booking_locks table exists with correct schema
- [ ] All indexes present

### 3.2 Test Lock Acquisition

```sql
-- Test acquiring soft lock
SELECT * FROM reserve.acquire_booking_lock(
  'test-unit-uuid'::uuid,
  '2026-03-01'::date,
  '2026-03-05'::date,
  'test-session-001',
  'soft_hold',
  'test-intent-uuid'::uuid,
  'test-city',
  15
);

-- Expected: success = true, lock_ids populated

-- Test conflicting lock (different session)
SELECT * FROM reserve.acquire_booking_lock(
  'test-unit-uuid'::uuid,
  '2026-03-01'::date,
  '2026-03-05'::date,
  'test-session-002', -- Different session
  'hard_hold',
  'test-intent-uuid-2'::uuid,
  'test-city',
  15
);

-- Expected: success = false, conflict_date = '2026-03-01'

-- Cleanup
DELETE FROM reserve.booking_locks WHERE session_id LIKE 'test-session-%';
```

**Pass Criteria:**
- [ ] Lock acquisition succeeds when available
- [ ] Lock acquisition fails when conflicting

### 3.3 Test Reservation Creation Safety

```sql
-- Test create_reservation_safe function
SELECT * FROM reserve.create_reservation_safe(
  'test-intent-uuid'::uuid,
  'test-city',
  'test-property-uuid'::uuid,
  'test-unit-uuid'::uuid,
  NULL,
  NULL,
  '2026-04-01'::date,
  '2026-04-05'::date,
  2,
  0,
  0,
  'Test',
  'Guest',
  'test@example.com',
  '+5511999999999',
  500.00,
  'BRL'
);

-- Expected: success = true, reservation_id and confirmation_code returned

-- Try to create duplicate (should return existing)
SELECT * FROM reserve.create_reservation_safe(
  'test-intent-uuid'::uuid, -- Same intent
  -- ... same parameters
);

-- Expected: success = true, same reservation_id, 'Reservation already exists' message

-- Cleanup
DELETE FROM reserve.reservations WHERE booking_intent_id = 'test-intent-uuid'::uuid;
DELETE FROM reserve.booking_locks WHERE booking_intent_id = 'test-intent-uuid'::uuid;
```

**Pass Criteria:**
- [ ] Safe reservation creation works
- [ ] Duplicate protection prevents double-booking

### 3.4 Verify Active Locks View

```sql
-- Check active locks view exists and returns data
SELECT COUNT(*) as active_lock_count
FROM reserve.active_booking_locks;

-- Check double booking risks view
SELECT COUNT(*) as risk_count
FROM reserve.double_booking_risks;

-- Expected: Views exist and queryable
```

**Pass Criteria:**
- [ ] active_booking_locks view accessible
- [ ] double_booking_risks view accessible

---

## PHASE 4: MONITORING AND OBSERVABILITY (30 min)

### 4.1 Verify Monitoring Views

```sql
-- Check all monitoring views exist
SELECT table_name
FROM information_schema.views
WHERE table_schema = 'reserve'
AND table_name IN (
  'stuck_payments',
  'overbooking_check',
  'ledger_balance_check',
  'webhook_failure_analysis',
  'intent_conversion_funnel',
  'retention_statistics',
  'webhook_status',
  'active_booking_locks'
)
ORDER BY table_name;

-- Expected: All 9 views present
```

**Pass Criteria:**
- [ ] All monitoring views created
- [ ] Views return data (even if empty)

### 4.2 Test System Health Check

```sql
-- Run health check
SELECT * FROM reserve.system_health_check();

-- Expected: 7 checks returned
-- All should show status IN ('OK', 'WARNING', 'CRITICAL')
```

**Pass Criteria:**
- [ ] Health check function works
- [ ] No errors during execution

### 4.3 Verify Alert Configuration

```sql
-- Check alert configurations
SELECT 
  alert_name,
  threshold_operator,
  threshold_value,
  severity,
  is_active
FROM reserve.alert_configurations
WHERE is_active = true
ORDER BY alert_name;

-- Expected: 5 alerts configured and active
```

**Pass Criteria:**
- [ ] All 5 alerts configured
- [ ] Reasonable thresholds set

### 4.4 Test Alert Checking

```sql
-- Run alert check
SELECT * FROM reserve.check_all_alerts();

-- Expected: All alerts checked, triggered column shows true/false
```

**Pass Criteria:**
- [ ] Alert check function works
- [ ] Returns results for all alerts

---

## PHASE 5: EDGE FUNCTION VERIFICATION (45 min)

### 5.1 Deploy Updated Functions

```bash
# Deploy all updated functions
supabase functions deploy webhook_stripe
supabase functions deploy create_payment_intent_stripe
supabase functions deploy create_pix_charge

# Verify deployment
supabase functions list
```

**Pass Criteria:**
- [ ] All 3 functions deployed successfully
- [ ] No deployment errors

### 5.2 Test Webhook Stripe Function

```bash
# Test with invalid signature (should return 400)
curl -X POST https://<project>.supabase.co/functions/v1/webhook_stripe \
  -H "Content-Type: application/json" \
  -d '{"test": true}'

# Expected: {"error": "Missing stripe-signature header"} with status 400

# Verify environment variables set
supabase secrets list | grep STRIPE

# Expected: STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET present
```

**Pass Criteria:**
- [ ] Function responds correctly
- [ ] Environment variables configured

### 5.3 Test Rate Limiting

```bash
# Make 25 rapid requests to test rate limiting
for i in {1..25}; do
  curl -X POST https://<project>.supabase.co/functions/v1/create_payment_intent_stripe \
    -H "Authorization: Bearer <token>" \
    -H "Content-Type: application/json" \
    -d '{"intent_id": "test"}' &
done

# Check response headers
# Expected: After 20 requests, receive 429 with Retry-After header
```

**Pass Criteria:**
- [ ] Rate limiting activates after threshold
- [ ] Returns 429 status with Retry-After header

### 5.4 Test Payment State Validation

```bash
# Create test intent
curl -X POST https://<project>.supabase.co/functions/v1/create_booking_intent \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "session_id": "test-session",
    "city_code": "test",
    "property_slug": "test-property",
    "unit_id": "test-unit",
    "check_in": "2026-06-01",
    "check_out": "2026-06-05"
  }'

# Try to create payment intent for invalid state
# (Manually update intent to invalid state in DB first)
curl -X POST https://<project>.supabase.co/functions/v1/create_payment_intent_stripe \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"intent_id": "test-intent"}'

# Expected: Error with code RESERVE_003 and invalid state message
```

**Pass Criteria:**
- [ ] Invalid state transitions rejected
- [ ] Appropriate error messages returned

---

## PHASE 6: INTEGRATION TESTING (30 min)

### 6.1 End-to-End Payment Flow

**Test Steps:**
1. Create booking intent
2. Create Stripe payment intent
3. Simulate Stripe webhook (payment succeeded)
4. Verify reservation created
5. Verify ledger entries

```bash
# Step 1: Create intent
 INTENT_RESPONSE=$(curl -s -X POST \
   https://<project>.supabase.co/functions/v1/create_booking_intent \
   -H "Authorization: Bearer <token>" \
   -H "Content-Type: application/json" \
   -d '{
     "session_id": "e2e-test-session",
     "city_code": "saopaulo",
     "property_slug": "test-hotel",
     "unit_id": "test-unit-uuid",
     "check_in": "2026-07-01",
     "check_out": "2026-07-03"
   }')

 INTENT_ID=$(echo $INTENT_RESPONSE | jq -r '.data.intent_id')

# Step 2: Create payment intent
 PAYMENT_RESPONSE=$(curl -s -X POST \
   https://<project>.supabase.co/functions/v1/create_payment_intent_stripe \
   -H "Authorization: Bearer <token>" \
   -H "Content-Type: application/json" \
    -d "{\"intent_id\": \"$INTENT_ID\"}")

---

## PHASE 7: OPS/QA HARDENING (Sprint 3)

### 7.1 Verify Ops Views and Health Checks

```sql
SELECT * FROM reserve.system_health_check();

SELECT * FROM reserve.ops_dashboard_summary;

SELECT * FROM reserve.ops_dashboard_alerts;
```

**Pass Criteria:**
- [ ] system_health_check returns rows with non-null status
- [ ] ops_dashboard_summary returns single row
- [ ] ops_dashboard_alerts returns 0+ rows without errors

### 7.2 Verify Retention Helpers (Dry Run)

```sql
SELECT reserve.purge_old_audit_logs(180, true) AS audit_log_candidates;
SELECT reserve.purge_old_webhook_dedup(60, true) AS webhook_candidates;
SELECT reserve.purge_old_reconciliation_runs(90, true) AS recon_candidates;
```

**Pass Criteria:**
- [ ] All functions execute with service_role and return counts

### 7.3 Verify Sprint 3 Migration Applied

```sql
SELECT filename, applied_at
FROM supabase_migrations.migrations
WHERE filename = '019_sprint3_ops_qa_hardening.sql';
```

**Pass Criteria:**
- [ ] Migration 019 is applied

# Step 3: Verify in database
SELECT status FROM reserve.booking_intents WHERE id = '$INTENT_ID';
-- Expected: 'payment_pending'

SELECT status FROM reserve.payments WHERE booking_intent_id = '$INTENT_ID';
-- Expected: 'pending'

# Step 4: Check audit log redaction
SELECT old_data, new_data
FROM reserve.audit_logs
WHERE table_name = 'payments'
ORDER BY created_at DESC
LIMIT 1;

# Expected: PII fields redacted/masked
```

**Pass Criteria:**
- [ ] Intent created successfully
- [ ] Payment intent created
- [ ] Audit logs show redacted data

### 6.2 Verify Encryption in Database

```sql
-- Check that PII is encrypted
SELECT 
  email,  -- plaintext (legacy)
  LEFT(email_encrypted, 20) as encrypted_preview,
  email_hash IS NOT NULL as has_hash
FROM reserve.travelers
WHERE email IS NOT NULL
LIMIT 5;

-- Expected: email_encrypted contains encrypted data, email_hash populated
```

**Pass Criteria:**
- [ ] Encrypted columns populated
- [ ] Hash columns populated for lookups

### 6.3 Verify IP Hashing

```sql
-- Check IP addresses are being hashed
SELECT 
  ip_address,
  ip_hash IS NOT NULL as has_hash
FROM reserve.audit_logs
WHERE ip_address IS NOT NULL
LIMIT 5;

-- Expected: ip_hash populated for recent entries
```

**Pass Criteria:**
- [ ] IP hashing trigger working
- [ ] Hash column populated

---

## PHASE 7: PERFORMANCE VERIFICATION (15 min)

### 7.1 Query Performance Check

```sql
-- Check slow queries
SELECT query, mean_exec_time
FROM pg_stat_statements
WHERE mean_exec_time > 500  -- > 500ms
ORDER BY mean_exec_time DESC
LIMIT 10;

-- Expected: No new slow queries introduced
```

### 7.2 Index Usage Check

```sql
-- Check new indexes are being used
SELECT schemaname, tablename, indexname, idx_scan
FROM pg_stat_user_indexes
WHERE schemaname = 'reserve'
AND indexname IN (
  'idx_booking_locks_unit_date',
  'idx_processed_webhooks_provider_event',
  'idx_reservations_unique_intent'
)
ORDER BY idx_scan DESC;

-- Expected: Indexes show usage (idx_scan > 0 after activity)
```

**Pass Criteria:**
- [ ] No significant performance degradation
- [ ] New indexes being utilized

---

## FINAL CHECKLIST

### Database Migrations
- [ ] All 5 migrations applied
- [ ] Encrypted columns created
- [ ] Encryption triggers active
- [ ] Vault keys present
- [ ] Audit redaction working
- [ ] Retention policies configured
- [ ] State machine triggers active
- [ ] Webhook infrastructure ready
- [ ] Booking locks table created
- [ ] Monitoring views accessible
- [ ] Health check function working
- [ ] Alert configurations set

### Edge Functions
- [ ] webhook_stripe deployed with signature verification
- [ ] create_payment_intent_stripe deployed with rate limiting
- [ ] create_pix_charge deployed with rate limiting
- [ ] Rate limiting working
- [ ] State validation working

### Integration
- [ ] End-to-end payment flow tested
- [ ] Encryption verified in database
- [ ] IP hashing verified
- [ ] Audit log redaction verified
- [ ] No performance degradation

### Documentation
- [ ] HARDENING_REPORT.md reviewed
- [ ] RUNBOOK_INCIDENTS.md accessible
- [ ] DATA_RETENTION_POLICY.md distributed
- [ ] SECURITY_KEYS_AND_SECRETS.md secured
- [ ] Team trained on new procedures

---

## POST-VERIFICATION ACTIONS

### Immediate (Within 24 hours)
- [ ] Monitor error rates
- [ ] Watch for failed payments
- [ ] Check webhook processing
- [ ] Verify no stuck payments

### Weekly (First month)
- [ ] Review system_health_check() daily
- [ ] Monitor retention cleanup logs
- [ ] Check for any overbooking incidents
- [ ] Verify encryption is working

### Monthly (Ongoing)
- [ ] Review security metrics
- [ ] Check key rotation schedule
- [ ] Update documentation if needed
- [ ] Conduct security training

---

## TROUBLESHOOTING

### Issue: Migration Failed

**Symptoms:** Migration shows error in logs  
**Solution:**
1. Check migration error message
2. Fix underlying issue
3. Re-run migration manually
4. Verify with Phase 1 checks

### Issue: Encryption Not Working

**Symptoms:** Encrypted columns NULL  
**Solution:**
1. Check Vault keys exist: `SELECT * FROM vault.keys`
2. Check trigger is enabled
3. Test manual encryption: `SELECT reserve.encrypt_pii('test', 'travelers_pii_key')`
4. Contact Supabase support if Vault issues

### Issue: Rate Limiting Not Working

**Symptoms:** No 429 responses  
**Solution:**
1. Verify Edge Function deployed: `supabase functions list`
2. Check environment variables set
3. Test with rapid curl requests
4. Check rate limit store in function logs

### Issue: Webhook Deduplication Not Working

**Symptoms:** Duplicate webhook processing  
**Solution:**
1. Check processed_webhooks table exists
2. Verify unique constraint on (provider, event_id)
3. Check webhook function logs
4. Test with duplicate event ID

---

## SIGN-OFF

**Verification Completed By:**

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Lead Engineer | | | |
| Security Engineer | | | |
| QA Engineer | | | |
| DevOps Engineer | | | |

**Approval:**

| Role | Name | Signature | Date |
|------|------|-----------|------|
| CTO | | | |
| CISO | | | |

---

**END OF POST-DEPLOYMENT VERIFICATION**

*Document ID:* RC-POST-DEPLOY-2026-02-16  
*Classification:* INTERNAL USE ONLY  
*Next Review:* After each deployment
