-- Sprint 2 Verification: cancel_reservation

-- 1) Objects exist
SELECT tablename
FROM pg_tables
WHERE schemaname = 'reserve'
  AND tablename IN ('cancellation_requests');

SELECT proname
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'reserve'
  AND p.proname IN ('release_reservation_inventory');

-- 2) Idempotency constraint
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'reserve'
  AND tablename = 'cancellation_requests'
  AND indexdef ILIKE '%UNIQUE%';

-- 3) State transition test (rollback)
BEGIN;
WITH target AS (
  SELECT id FROM reserve.reservations WHERE status = 'confirmed' LIMIT 1
)
UPDATE reserve.reservations
SET status = 'cancelled'
WHERE id IN (SELECT id FROM target);

SELECT id, status
FROM reserve.reservations
WHERE id IN (SELECT id FROM target);
ROLLBACK;

-- 4) Ledger balance check (recent refunds)
SELECT
  transaction_id,
  reserve.verify_ledger_balance(transaction_id) AS is_balanced
FROM reserve.ledger_entries
WHERE entry_type = 'refund_processed'
ORDER BY created_at DESC
LIMIT 5;
