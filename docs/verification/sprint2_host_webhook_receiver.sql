-- Sprint 2 Verification: host_webhook_receiver

-- 1) host_webhook_events columns
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'reserve'
  AND table_name = 'host_webhook_events'
  AND column_name IN ('event_id', 'status', 'attempt_count', 'last_attempt_at');

-- 2) Deduplication constraint
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'reserve'
  AND tablename = 'host_webhook_events'
  AND indexdef ILIKE '%UNIQUE%';

-- 3) Deduplication test (rollback)
BEGIN;
INSERT INTO reserve.host_webhook_events (event_id, event_type, payload, status)
VALUES ('test_evt_001', 'booking.confirmed', '{}'::jsonb, 'pending')
ON CONFLICT DO NOTHING;

INSERT INTO reserve.host_webhook_events (event_id, event_type, payload, status)
VALUES ('test_evt_001', 'booking.confirmed', '{}'::jsonb, 'pending')
ON CONFLICT DO NOTHING;

SELECT event_id, COUNT(*)
FROM reserve.host_webhook_events
WHERE event_id = 'test_evt_001'
GROUP BY event_id;
ROLLBACK;

-- 4) State transition test (rollback)
BEGIN;
WITH target AS (
  SELECT id FROM reserve.reservations WHERE status = 'confirmed' LIMIT 1
)
UPDATE reserve.reservations
SET status = 'checked_in'
WHERE id IN (SELECT id FROM target);

SELECT id, status
FROM reserve.reservations
WHERE id IN (SELECT id FROM target);
ROLLBACK;
