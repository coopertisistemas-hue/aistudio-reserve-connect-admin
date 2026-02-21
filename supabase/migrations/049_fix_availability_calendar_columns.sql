-- ============================================
-- MIGRATION 049: FIX AVAILABILITY CALENDAR COLUMNS
-- Description: Restores expected columns required by booking/ops triggers
-- ============================================

ALTER TABLE reserve.availability_calendar
    ADD COLUMN IF NOT EXISTS temp_holds INTEGER DEFAULT 0;

ALTER TABLE reserve.availability_calendar
    ADD COLUMN IF NOT EXISTS bookings_count INTEGER DEFAULT 0;

UPDATE reserve.availability_calendar
SET
    temp_holds = COALESCE(temp_holds, 0),
    bookings_count = COALESCE(bookings_count, 0)
WHERE temp_holds IS NULL OR bookings_count IS NULL;
