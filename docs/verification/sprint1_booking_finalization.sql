-- Sprint 1 Verification: Reservation Finalization + Host Commit

-- 1) Functions are updated
SELECT
  n.nspname as schema,
  p.proname as function_name,
  pg_get_function_result(p.oid) as result_type
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'reserve'
AND p.proname IN ('create_reservation_safe', 'finalize_reservation');

-- 2) Ensure no legacy "pending" reservation status rows exist
SELECT COUNT(*) AS pending_reservations
FROM reserve.reservations
WHERE status = 'pending';

-- 3) Validate payments linked to reservations after finalization
SELECT COUNT(*) AS payments_without_reservation
FROM reserve.payments
WHERE status = 'succeeded'
AND reservation_id IS NULL;

-- 4) Ledger entries for commission and payout due
SELECT
  entry_type,
  COUNT(*) AS entry_count
FROM reserve.ledger_entries
WHERE entry_type IN ('commission_taken', 'payout_due')
GROUP BY entry_type
ORDER BY entry_type;

-- 5) Host commit events
SELECT event_name, COUNT(*)
FROM reserve.events
WHERE event_name IN ('host_commit_succeeded', 'host_commit_failed')
GROUP BY event_name;
