-- ============================================
-- MIGRATION 048: FIX S1 AVAILABILITY UPSERT WRAPPER CONFLICT
-- Description: Replaces availability upsert wrapper as SQL function to avoid plpgsql ambiguity
-- ============================================

CREATE OR REPLACE FUNCTION public.admin_s1_upsert_availability_rows(
    p_rows JSONB
)
RETURNS TABLE (
    id UUID,
    unit_id UUID,
    rate_plan_id UUID,
    date DATE,
    is_available BOOLEAN,
    is_blocked BOOLEAN,
    block_reason TEXT,
    min_stay_override INTEGER,
    base_price NUMERIC,
    discounted_price NUMERIC,
    currency TEXT,
    allotment INTEGER,
    updated_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    INSERT INTO reserve.availability_calendar (
        unit_id,
        rate_plan_id,
        date,
        is_available,
        is_blocked,
        block_reason,
        min_stay_override,
        base_price,
        discounted_price,
        currency,
        allotment
    )
    SELECT
        (row->>'unit_id')::UUID,
        (row->>'rate_plan_id')::UUID,
        (row->>'date')::DATE,
        COALESCE((row->>'is_available')::BOOLEAN, TRUE),
        COALESCE((row->>'is_blocked')::BOOLEAN, FALSE),
        NULLIF(row->>'block_reason', ''),
        NULLIF(row->>'min_stay_override', '')::INTEGER,
        COALESCE((row->>'base_price')::NUMERIC, 0),
        NULLIF(row->>'discounted_price', '')::NUMERIC,
        COALESCE(NULLIF(row->>'currency', ''), 'BRL'),
        COALESCE(NULLIF(row->>'allotment', '')::INTEGER, 1)
    FROM jsonb_array_elements(COALESCE(p_rows, '[]'::JSONB)) AS row
    ON CONFLICT (unit_id, rate_plan_id, date)
    DO UPDATE SET
        is_available = EXCLUDED.is_available,
        is_blocked = EXCLUDED.is_blocked,
        block_reason = EXCLUDED.block_reason,
        min_stay_override = EXCLUDED.min_stay_override,
        base_price = EXCLUDED.base_price,
        discounted_price = EXCLUDED.discounted_price,
        currency = EXCLUDED.currency,
        allotment = EXCLUDED.allotment,
        updated_at = NOW()
    RETURNING
        reserve.availability_calendar.id,
        reserve.availability_calendar.unit_id,
        reserve.availability_calendar.rate_plan_id,
        reserve.availability_calendar.date,
        reserve.availability_calendar.is_available,
        reserve.availability_calendar.is_blocked,
        reserve.availability_calendar.block_reason::TEXT,
        reserve.availability_calendar.min_stay_override,
        reserve.availability_calendar.base_price,
        reserve.availability_calendar.discounted_price,
        reserve.availability_calendar.currency::TEXT,
        reserve.availability_calendar.allotment,
        reserve.availability_calendar.updated_at;
$$;
