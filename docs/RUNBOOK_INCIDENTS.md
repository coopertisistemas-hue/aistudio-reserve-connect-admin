# INCIDENT RESPONSE RUNBOOK
## Reserve Connect - Operational Procedures

**Version:** 2.0  
**Last Updated:** 2026-02-16  
**Owner:** Engineering + Operations Team  
**Classification:** INTERNAL USE ONLY

---

## TABLE OF CONTENTS

1. [Severity Levels](#severity-levels)
2. [Incident Response Process](#incident-response-process)
3. [Specific Runbooks](#specific-runbooks)
   - P1: Webhook Down
   - P1: Payment Succeeded but No Reservation
   - P1: Ledger Imbalance Detected
   - P1: Overbooking Detected
   - P2: PIX Paid but Not Confirmed
   - P2: Payment Stuck in Processing
   - P2: Double Charge
   - P2: High Rate of Failed Payments
   - P3: Slow Query Performance
   - P3: Audit Log Growth
4. [Emergency Contacts](#emergency-contacts)
5. [Post-Incident Review](#post-incident-review)

---

## SEVERITY LEVELS

| Severity | Response Time | Description | Examples |
|----------|---------------|-------------|----------|
| **P1 - Critical** | 15 minutes | Service unusable, financial impact, data loss | Payment system down, overbooking, ledger imbalance |
| **P2 - High** | 1 hour | Major feature impaired, potential financial impact | Webhook delays, stuck payments, double charges |
| **P3 - Medium** | 4 hours | Minor feature impaired, workarounds exist | Slow queries, storage growth, non-critical alerts |
| **P4 - Low** | 24 hours | Cosmetic issues, no user impact | UI glitches, log noise |

---

## INCIDENT RESPONSE PROCESS

### Step 1: Detection
1. Automated alert fires (check `reserve.check_all_alerts()`)
2. Manual report from customer support
3. Monitoring dashboard shows anomaly
4. Ops dashboard summary shows spikes (`reserve.ops_dashboard_summary`)

### Step 2: Triage (5 minutes)
1. Classify severity using table above
2. Identify affected components
3. Check if incident is ongoing or resolved
4. Create incident channel/war room

### Step 3: Response
1. Follow specific runbook for incident type
2. Communicate status every 30 minutes (P1/P2)
3. Escalate if needed

### Step 4: Resolution
1. Verify fix with test transaction
2. Monitor for 1 hour (P1) or 4 hours (P2)
3. Document resolution

### Step 5: Post-Mortem (within 48 hours)
1. Timeline of events
2. Root cause analysis
3. Action items to prevent recurrence

---

## SPECIFIC RUNBOOKS

---

## P1: WEBHOOK DOWN (Stripe/PIX)

### Symptoms
- `reserve.stuck_payments` view showing payments in "processing" > 1 hour
- `reserve.webhook_status` view showing failed webhooks
- Customers reporting "paid but no confirmation"

### Immediate Checks (5 minutes)
```sql
-- Check webhook processing status
SELECT provider, status, COUNT(*)
FROM reserve.processed_webhooks
WHERE received_at > NOW() - INTERVAL '1 hour'
GROUP BY provider, status;

-- Check stuck payments
SELECT COUNT(*) as stuck_count
FROM reserve.stuck_payments;

-- Check recent webhook errors
SELECT * FROM reserve.webhook_failure_analysis
ORDER BY last_seen DESC
LIMIT 10;
```

### Diagnosis

**Scenario A: Edge Function Error**
```bash
# Check Edge Function logs
supabase functions logs webhook_stripe --tail

# Look for:
# - "Webhook secret not configured"
# - "Invalid signature"
# - "Processing failed"
```

**Scenario B: Database Connection Issue**
```sql
-- Check connection pool
SELECT count(*) as active_connections 
FROM pg_stat_activity 
WHERE state = 'active';

-- If > 80, connection pool exhausted
```

**Scenario C: Webhook Endpoint Misconfigured**
```bash
# Verify webhook URL in Stripe Dashboard
curl -X POST https://<project>.supabase.co/functions/v1/webhook_stripe \
  -H "Content-Type: application/json" \
  -d '{"test": true}'
# Should return 400 (invalid signature) not 404
```

### Resolution Steps

**If Edge Function Error:**
1. Redeploy function: `supabase functions deploy webhook_stripe`
2. Check environment variables are set
3. Monitor logs for successful processing

**If Database Issue:**
1. Identify long-running queries:
```sql
SELECT pid, query_start, query 
FROM pg_stat_activity 
WHERE state = 'active' 
AND query_start < NOW() - INTERVAL '5 minutes';
```
2. Kill blocking queries if safe
3. Restart connection pool if necessary

**If Webhook Misconfigured:**
1. Update webhook URL in Stripe Dashboard
2. Verify webhook secret matches environment variable

### Recovery: Process Missed Webhooks
```sql
-- Find payments that succeeded at Stripe but not in our system
-- (Requires Stripe Dashboard or API check)

-- Manual reconciliation for each stuck payment:
SELECT * FROM reserve.finalize_reservation(
  p_payment_id := 'payment-uuid',
  p_webhook_id := NULL
);

-- Or mark as failed if payment actually failed
UPDATE reserve.payments 
SET status = 'failed', 
    metadata = metadata || '{"manual_recovery": "webhook_down"}'::jsonb
WHERE id = 'payment-uuid';
```

### Verification
```sql
-- Verify no more stuck payments
SELECT COUNT(*) FROM reserve.stuck_payments;
-- Expected: 0

-- Test new payment end-to-end
-- Check webhook appears in processed_webhooks with status 'completed'
```

---

## P1: PAYMENT SUCCEEDED BUT NO RESERVATION

### Symptoms
- Payment status = 'succeeded'
- No reservation record for booking_intent_id
- Customer has receipt but no confirmation code

### Immediate Checks
```sql
-- Find affected payments
SELECT 
  p.id as payment_id,
  p.booking_intent_id,
  p.succeeded_at,
  r.id as reservation_id,
  r.confirmation_code
FROM reserve.payments p
LEFT JOIN reserve.reservations r ON p.booking_intent_id = r.booking_intent_id
WHERE p.status = 'succeeded'
AND r.id IS NULL
AND p.succeeded_at > NOW() - INTERVAL '24 hours';
```

### Diagnosis

**Scenario A: Webhook Processing Failed**
- Check `reserve.processed_webhooks` for failed entries
- Look for error messages

**Scenario B: Finalize Function Error**
- Check Edge Function logs for finalize_reservation_after_payment
- Look for timeout or validation errors

**Scenario C: Database Constraint Violation**
```sql
-- Check if reservation was attempted but failed
SELECT * FROM reserve.processed_webhooks
WHERE event_type = 'payment_intent.succeeded'
AND status = 'failed'
ORDER BY received_at DESC
LIMIT 10;
```

### Resolution

**For Each Affected Payment:**
```sql
-- Attempt to finalize reservation
SELECT * FROM reserve.finalize_reservation(
  p_payment_id := 'payment-uuid',
  p_webhook_id := NULL
);

-- Check result
-- If success: reservation created
-- If error: check error_message
```

**If Finalize Fails:**
```sql
-- Manual reservation creation
INSERT INTO reserve.reservations (
  booking_intent_id,
  confirmation_code,
  city_code,
  property_id,
  unit_id,
  -- ... other fields from booking_intent
  status,
  payment_status
)
SELECT 
  bi.id,
  'RES-' || TO_CHAR(NOW(), 'YYYY') || '-' || UPPER(SUBSTRING(MD5(RANDOM()::text), 1, 6)),
  bi.city_code,
  bi.property_id,
  bi.unit_id,
  'host_commit_pending',
  'paid'
FROM reserve.booking_intents bi
WHERE bi.id = 'intent-uuid';
```

### Verification
```sql
-- Verify reservation exists
SELECT * FROM reserve.reservations
WHERE booking_intent_id = 'intent-uuid';

-- Verify booking intent updated
SELECT status FROM reserve.booking_intents
WHERE id = 'intent-uuid';
-- Expected: 'converted'
```

---

## P1: LEDGER IMBALANCE DETECTED

### Symptoms
- `reserve.system_health_check()` shows CRITICAL for ledger balance
- `reserve.find_ledger_imbalances()` returns rows

### Immediate Checks
```sql
-- Find imbalanced transactions
SELECT * FROM reserve.find_ledger_imbalances(NOW()::date - 7);

-- Get details for specific transaction
SELECT *
FROM reserve.ledger_entries
WHERE transaction_id = 'imbalanced-tx-id'
ORDER BY direction;
```

### Root Cause Analysis

**Scenario A: Trigger Disabled**
```sql
-- Check if trigger is enabled
SELECT tgenabled 
FROM pg_trigger 
WHERE tgname = 'trg_ledger_balance';
-- Should be 'O' (origin enabled)
```

**Scenario B: Manual Insert Bypassed Trigger**
- Check if someone inserted directly without proper validation

**Scenario C: Race Condition**
- Two simultaneous ledger entries created
- Check timestamps

### Resolution

**If Trigger Disabled:**
```sql
-- Re-enable trigger
ALTER TABLE reserve.ledger_entries 
ENABLE TRIGGER trg_ledger_balance;
```

**If Missing Entries:**
```sql
-- Calculate missing entry
WITH tx_entries AS (
  SELECT 
    transaction_id,
    SUM(CASE WHEN direction = 'debit' THEN amount ELSE 0 END) as debits,
    SUM(CASE WHEN direction = 'credit' THEN amount ELSE 0 END) as credits
  FROM reserve.ledger_entries
  WHERE transaction_id = 'imbalanced-tx-id'
  GROUP BY transaction_id
)
SELECT 
  transaction_id,
  debits - credits as imbalance_amount,
  CASE WHEN debits > credits THEN 'credit' ELSE 'debit' END as needed_direction
FROM tx_entries
WHERE debits != credits;

-- Insert balancing entry (REQUIRES CFO/ACCOUNTANT APPROVAL)
INSERT INTO reserve.ledger_entries (
  transaction_id,
  entry_type,
  account,
  direction,
  amount,
  description,
  city_code
)
VALUES (
  'imbalanced-tx-id',
  'correction',
  'corrections',
  'credit',  -- or 'debit' as needed
  imbalance_amount,
  'Manual correction for imbalance',
  'city_code'
);
```

**If Duplicate Entries:**
```sql
-- Identify and remove duplicate
WITH duplicates AS (
  SELECT id, 
         ROW_NUMBER() OVER (
           PARTITION BY transaction_id, account, direction 
           ORDER BY created_at
         ) as rn
  FROM reserve.ledger_entries
  WHERE transaction_id = 'imbalanced-tx-id'
)
DELETE FROM reserve.ledger_entries
WHERE id IN (SELECT id FROM duplicates WHERE rn > 1);
```

### Verification
```sql
-- Verify balance restored
SELECT * FROM reserve.find_ledger_imbalances(NOW()::date);
-- Expected: 0 rows

-- Verify ledger balance check shows OK
SELECT * FROM reserve.ledger_balance_check
LIMIT 5;
```

### Prevention
- Never disable ledger_balance trigger
- All ledger entries must go through application code
- Implement 4-eyes approval for manual corrections

---

## P1: OVERBOOKING DETECTED

### Symptoms
- `reserve.overbooking_check` view shows rows
- Customers complaining about double-booked dates
- `allotment < bookings_count + temp_holds`

### Immediate Checks
```sql
-- Find overbooked dates
SELECT * FROM reserve.overbooking_check;

-- Find conflicting reservations
SELECT 
  r1.id as res1_id,
  r2.id as res2_id,
  r1.unit_id,
  r1.check_in,
  r1.check_out,
  r1.status as res1_status,
  r2.status as res2_status
FROM reserve.reservations r1
JOIN reserve.reservations r2 ON r1.unit_id = r2.unit_id
  AND r1.id != r2.id
  AND (r1.check_in, r1.check_out) OVERLAPS (r2.check_in, r2.check_out)
WHERE r1.status IN ('confirmed', 'checked_in', 'host_commit_pending')
AND r2.status IN ('confirmed', 'checked_in', 'host_commit_pending')
AND r1.check_in > CURRENT_DATE;
```

### Resolution

**Step 1: Stop New Bookings**
```sql
-- Temporarily mark unit as unavailable
UPDATE reserve.availability_calendar
SET is_available = false, is_blocked = true
WHERE unit_id = 'overbooked-unit-uuid'
AND date >= CURRENT_DATE;
```

**Step 2: Assess Impact**
- Identify which reservation is legitimate (first booked)
- Contact property owner for alternative arrangements
- Prepare compensation for affected customer

**Step 3: Resolve Conflict**

Option A: Move one reservation to different unit
```sql
-- Find alternative unit
SELECT um.id, um.name
FROM reserve.unit_map um
JOIN reserve.properties_map pm ON um.property_id = pm.id
WHERE pm.city_code = 'affected-city'
AND um.max_occupancy >= required_occupancy
AND NOT EXISTS (
  SELECT 1 FROM reserve.reservations r
  WHERE r.unit_id = um.id
  AND r.status IN ('confirmed', 'checked_in')
  AND (r.check_in, r.check_out) OVERLAPS (affected_check_in, affected_check_out)
);

-- Move reservation
UPDATE reserve.reservations
SET unit_id = 'alternative-unit-uuid',
    metadata = metadata || '{"moved_due_to_overbooking": true}'::jsonb
WHERE id = 'reservation-to-move';
```

Option B: Cancel and refund one reservation
```sql
-- Cancel reservation
UPDATE reserve.reservations
SET status = 'cancelled',
    cancellation_reason = 'Overbooking - property error',
    updated_at = NOW()
WHERE id = 'reservation-to-cancel';

-- Process refund (manual or via refund function)
```

**Step 4: Fix Availability Calendar**
```sql
-- Recalculate bookings_count
UPDATE reserve.availability_calendar ac
SET bookings_count = subquery.actual_bookings,
    is_available = (subquery.actual_bookings + ac.temp_holds) < ac.allotment
FROM (
  SELECT 
    unit_id,
    date,
    COUNT(*) as actual_bookings
  FROM reserve.reservations r
  JOIN generate_series(r.check_in, r.check_out - INTERVAL '1 day', INTERVAL '1 day') AS date
  ON true
  WHERE r.status IN ('confirmed', 'checked_in', 'host_commit_pending')
  GROUP BY unit_id, date
) subquery
WHERE ac.unit_id = subquery.unit_id
AND ac.date = subquery.date;
```

**Step 5: Investigate Root Cause**
```sql
-- Check booking locks
SELECT * FROM reserve.active_booking_locks
WHERE unit_id = 'affected-unit';

-- Check for race conditions
SELECT * FROM reserve.booking_locks
WHERE unit_id = 'affected-unit'
AND lock_date BETWEEN affected_check_in AND affected_check_out
ORDER BY created_at;
```

### Prevention
- Ensure booking_locks table has proper constraints
- Verify acquire_booking_lock function is being used
- Review Edge Function for atomicity

---

## P2: PIX PAID BUT NOT CONFIRMED

### Symptoms
- Customer shows PIX payment receipt
- Payment status = 'pending' or 'processing'
- No webhook received from provider

### Checks
```sql
-- Find PIX payment
SELECT * FROM reserve.payments
WHERE gateway_payment_id = 'pix-id-from-customer'
OR booking_intent_id = 'intent-id';

-- Check webhook status
SELECT * FROM reserve.processed_webhooks
WHERE provider IN ('mercadopago', 'openpix')
AND received_at > NOW() - INTERVAL '24 hours'
ORDER BY received_at DESC;
```

### Resolution

**Manual Verification:**
1. Log into MercadoPago/OpenPIX dashboard
2. Verify payment status
3. If status = 'approved', manually trigger webhook processing

```sql
-- Insert synthetic webhook record
INSERT INTO reserve.processed_webhooks (
  provider, event_id, event_type, status
) VALUES (
  'mercadopago', 
  'manual_' || gen_random_uuid(), 
  'payment.approved',
  'processing'
);

-- Update payment status
UPDATE reserve.payments
SET status = 'succeeded',
    succeeded_at = NOW(),
    metadata = metadata || '{"manual_confirmation": true}'::jsonb
WHERE id = 'pix-payment-id';

-- Finalize reservation
SELECT * FROM reserve.finalize_reservation('payment-id', NULL);
```

### Prevention
- Implement PIX webhook endpoint (separate from Stripe)
- Poll payment status every 5 minutes until confirmed
- Set up alerts for PIX payments pending > 30 minutes

---

## P2: PAYMENT STUCK IN PROCESSING

### Symptoms
- Payment status = 'processing' > 1 hour
- No webhook received
- Customer asking about status

### Checks
```sql
SELECT * FROM reserve.stuck_payments;
```

### Resolution

**Option 1: Query Provider Status**
```typescript
// Add to poll_payment_status function
// Query Stripe for PaymentIntent status
const stripePI = await stripe.paymentIntents.retrieve(payment.gateway_payment_id);

if (stripePI.status === 'succeeded') {
  // Process webhook manually
} else if (stripePI.status === 'canceled') {
  // Mark as failed
}
```

**Option 2: Manual Update**
```sql
-- If Stripe shows succeeded but we don't have it
UPDATE reserve.payments
SET status = 'succeeded',
    succeeded_at = COALESCE(succeeded_at, NOW()),
    metadata = metadata || '{"manual_recovery": "processing_stuck"}'::jsonb
WHERE id = 'stuck-payment-id';

-- Then finalize reservation
SELECT * FROM reserve.finalize_reservation('payment-id', NULL);
```

---

## P2: DOUBLE CHARGE

### Symptoms
- Customer reports being charged twice
- Two payments for same booking_intent_id
- Both payments have status = 'succeeded'

### Checks
```sql
-- Find duplicate charges
SELECT 
  booking_intent_id,
  COUNT(*) as payment_count,
  SUM(amount) as total_charged,
  array_agg(id) as payment_ids
FROM reserve.payments
WHERE status = 'succeeded'
AND created_at > NOW() - INTERVAL '7 days'
GROUP BY booking_intent_id
HAVING COUNT(*) > 1;
```

### Resolution

**Step 1: Verify with Stripe**
- Check if both charges exist in Stripe
- Confirm one is duplicate

**Step 2: Refund Duplicate**
```sql
-- Mark as refunded in our system
UPDATE reserve.payments
SET status = 'refunded',
    refunded_amount = amount,
    refunded_at = NOW(),
    metadata = metadata || '{"refund_reason": "duplicate_charge"}'::jsonb
WHERE id = 'duplicate-payment-id';

-- Process refund in Stripe
const refund = await stripe.refunds.create({
  payment_intent: 'pi_duplicate_id',
  reason: 'duplicate'
});

-- Create ledger entries for refund
```

**Step 3: Contact Customer**
- Explain the error
- Confirm refund timeline (5-10 business days)
- Provide refund transaction ID

---

## P2: HIGH RATE OF FAILED PAYMENTS

### Symptoms
- `reserve.failed_payments_analysis` shows spike
- Success rate < 80%
- Same error code repeating

### Checks
```sql
-- Analyze failures
SELECT * FROM reserve.failed_payments_analysis
ORDER BY count DESC;

-- Check by time
SELECT 
  DATE_TRUNC('hour', created_at) as hour,
  COUNT(*) FILTER (WHERE status = 'succeeded') as succeeded,
  COUNT(*) FILTER (WHERE status = 'failed') as failed,
  ROUND(
    COUNT(*) FILTER (WHERE status = 'succeeded')::numeric / 
    COUNT(*) * 100, 2
  ) as success_rate
FROM reserve.payments
WHERE created_at > NOW() - INTERVAL '24 hours'
GROUP BY DATE_TRUNC('hour', created_at)
ORDER BY hour DESC;
```

### Common Causes & Fixes

**Error: card_declined**
- Cause: Bank rejecting cards
- Action: Nothing - normal behavior

**Error: expired_card**
- Cause: Old card on file
- Action: Prompt customer to update card

**Error: processing_error**
- Cause: Stripe API issues
- Action: Check Stripe status page

**Error: rate_limit (from our side)**
- Cause: Too many requests to Stripe
- Action: Increase rate limiting thresholds

**Error: amount_too_small / amount_too_large**
- Cause: Validation bypassed
- Action: Check Edge Function validation

---

## P3: SLOW QUERY PERFORMANCE

### Checks
```sql
-- Find slow queries
SELECT 
  query,
  calls,
  mean_exec_time,
  total_exec_time
FROM pg_stat_statements
WHERE mean_exec_time > 1000  -- > 1 second
ORDER BY mean_exec_time DESC
LIMIT 10;
```

### Common Fixes

**Missing Index:**
```sql
-- Check if query is using index
EXPLAIN ANALYZE <slow_query>;

-- Add index if needed
CREATE INDEX CONCURRENTLY idx_new_index 
ON reserve.table_name(column_name);
```

**Table Bloat:**
```sql
-- Check table bloat
SELECT schemaname, tablename, 
       pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables
WHERE schemaname = 'reserve'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Vacuum if needed
VACUUM ANALYZE reserve.large_table;
```

**Lock Contention:**
```sql
-- Check for locks
SELECT 
  blocked_locks.pid AS blocked_pid,
  blocking_locks.pid AS blocking_pid,
  blocked_activity.query AS blocked_query
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks ON blocking_locks.locktype = blocked_locks.locktype
JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;
```

---

## P3: AUDIT LOG GROWTH

### Checks
```sql
-- Check current size
SELECT pg_size_pretty(pg_total_relation_size('reserve.audit_logs'));

-- Check row count
SELECT COUNT(*) FROM reserve.audit_logs;

-- Check retention statistics
SELECT * FROM reserve.retention_statistics;
```

### Resolution

**If Size > 5GB:**
```sql
-- Run retention cleanup manually
SELECT * FROM reserve.run_retention_cleanup();

-- Check what was archived
SELECT * FROM reserve.audit_logs_archive LIMIT 5;

-- If still too large, consider partitioning
-- (See DATA_RETENTION_POLICY.md)
```

**If Not Archiving:**
```sql
-- Verify retention policy
SELECT * FROM reserve.retention_policies 
WHERE table_name = 'audit_logs';

-- Should show: retention_days = 365, retention_type = 'archive'
```

---

## EMERGENCY CONTACTS

| Role | Name | Phone | Email | Escalation Time |
|------|------|-------|-------|-----------------|
| On-Call Engineer | [On-Call] | [PagerDuty] | oncall@company.com | 0 min |
| Engineering Lead | [Name] | [Phone] | [Email] | 15 min (P1) |
| CTO | [Name] | [Phone] | [Email] | 30 min (P1) |
| Product Manager | [Name] | [Phone] | [Email] | 1 hour (P1) |
| CFO (for financial issues) | [Name] | [Phone] | [Email] | Immediate (P1 + financial) |

### External Vendors

| Vendor | Support URL | Phone | Escalation |
|--------|-------------|-------|------------|
| Stripe | dashboard.stripe.com | [Phone] | For payment issues |
| Supabase | supabase.com/dashboard | [Phone] | For database issues |
| MercadoPago | mercadopago.com.br | [Phone] | For PIX issues |

---

## POST-INCIDENT REVIEW TEMPLATE

**Incident ID:** INC-YYYY-MM-DD-XXX  
**Date:** YYYY-MM-DD  
**Severity:** P1/P2/P3  
**Duration:** HH:MM  
**Reporter:** Name

### Timeline
- HH:MM - Issue detected
- HH:MM - Incident declared
- HH:MM - Root cause identified
- HH:MM - Fix deployed
- HH:MM - Incident resolved

### Root Cause
[Detailed explanation]

### Impact
- **Customers Affected:** X
- **Financial Impact:** $X
- **Reputational Impact:** [Low/Medium/High]

### What Went Well
1. 
2. 

### What Went Wrong
1. 
2. 

### Action Items
| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| | | | |

### Lessons Learned
[Free form]

---

**END OF RUNBOOK**

*Keep this document updated after every incident.*  
*Review quarterly for accuracy.*
