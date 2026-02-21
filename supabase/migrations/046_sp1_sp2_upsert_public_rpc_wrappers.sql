-- ============================================
-- MIGRATION 046: SP1/SP2 UPSERT PUBLIC RPC WRAPPERS
-- Description: Public RPC wrappers for SP1/SP2 admin upsert flows
-- ============================================

CREATE OR REPLACE FUNCTION public.admin_s1_upsert_rate_plan(
    p_id UUID DEFAULT NULL,
    p_property_id UUID DEFAULT NULL,
    p_host_rate_plan_id UUID DEFAULT NULL,
    p_name TEXT DEFAULT NULL,
    p_code TEXT DEFAULT NULL,
    p_is_default BOOLEAN DEFAULT FALSE,
    p_channels_enabled JSONB DEFAULT '[]'::JSONB,
    p_min_stay_nights INTEGER DEFAULT 1,
    p_max_stay_nights INTEGER DEFAULT NULL,
    p_advance_booking_days INTEGER DEFAULT NULL,
    p_cancellation_policy_code TEXT DEFAULT NULL,
    p_is_active BOOLEAN DEFAULT TRUE
)
RETURNS TABLE (
    mode TEXT,
    id UUID,
    property_id UUID,
    name TEXT,
    code TEXT,
    is_default BOOLEAN,
    channels_enabled JSONB,
    min_stay_nights INTEGER,
    max_stay_nights INTEGER,
    advance_booking_days INTEGER,
    cancellation_policy_code TEXT,
    is_active BOOLEAN,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
BEGIN
    IF p_property_id IS NULL THEN
        RAISE EXCEPTION 'property_id is required';
    END IF;
    IF COALESCE(BTRIM(p_name), '') = '' THEN
        RAISE EXCEPTION 'name is required';
    END IF;
    IF p_min_stay_nights IS NULL OR p_min_stay_nights < 1 THEN
        RAISE EXCEPTION 'min_stay_nights must be >= 1';
    END IF;

    IF p_id IS NULL THEN
        RETURN QUERY
        INSERT INTO reserve.rate_plans (
            property_id,
            host_rate_plan_id,
            name,
            code,
            is_default,
            channels_enabled,
            min_stay_nights,
            max_stay_nights,
            advance_booking_days,
            cancellation_policy_code,
            is_active
        ) VALUES (
            p_property_id,
            p_host_rate_plan_id,
            p_name,
            p_code,
            COALESCE(p_is_default, FALSE),
            CASE WHEN p_channels_enabled IS NULL OR jsonb_typeof(p_channels_enabled) <> 'array' OR jsonb_array_length(p_channels_enabled) = 0
                 THEN '[]'::JSONB
                 ELSE p_channels_enabled
            END,
            p_min_stay_nights,
            p_max_stay_nights,
            p_advance_booking_days,
            p_cancellation_policy_code,
            COALESCE(p_is_active, TRUE)
        )
        RETURNING
            'created'::TEXT,
            reserve.rate_plans.id,
            reserve.rate_plans.property_id,
            reserve.rate_plans.name::TEXT,
            reserve.rate_plans.code::TEXT,
            reserve.rate_plans.is_default,
            reserve.rate_plans.channels_enabled,
            reserve.rate_plans.min_stay_nights,
            reserve.rate_plans.max_stay_nights,
            reserve.rate_plans.advance_booking_days,
            reserve.rate_plans.cancellation_policy_code::TEXT,
            reserve.rate_plans.is_active,
            reserve.rate_plans.created_at,
            reserve.rate_plans.updated_at;
    ELSE
        RETURN QUERY
        UPDATE reserve.rate_plans rp
        SET
            property_id = p_property_id,
            host_rate_plan_id = p_host_rate_plan_id,
            name = p_name,
            code = p_code,
            is_default = COALESCE(p_is_default, FALSE),
            channels_enabled = CASE WHEN p_channels_enabled IS NULL OR jsonb_typeof(p_channels_enabled) <> 'array' OR jsonb_array_length(p_channels_enabled) = 0
                 THEN '[]'::JSONB
                 ELSE p_channels_enabled
            END,
            min_stay_nights = p_min_stay_nights,
            max_stay_nights = p_max_stay_nights,
            advance_booking_days = p_advance_booking_days,
            cancellation_policy_code = p_cancellation_policy_code,
            is_active = COALESCE(p_is_active, TRUE),
            updated_at = NOW()
        WHERE rp.id = p_id
        RETURNING
            'updated'::TEXT,
            rp.id,
            rp.property_id,
            rp.name::TEXT,
            rp.code::TEXT,
            rp.is_default,
            rp.channels_enabled,
            rp.min_stay_nights,
            rp.max_stay_nights,
            rp.advance_booking_days,
            rp.cancellation_policy_code::TEXT,
            rp.is_active,
            rp.created_at,
            rp.updated_at;
    END IF;
END;
$$;

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
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
BEGIN
    IF p_rows IS NULL OR jsonb_typeof(p_rows) <> 'array' OR jsonb_array_length(p_rows) = 0 THEN
        RAISE EXCEPTION 'rows payload is required';
    END IF;

    RETURN QUERY
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
    FROM jsonb_array_elements(p_rows) AS row
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
END;
$$;

CREATE OR REPLACE FUNCTION public.admin_s2_upsert_commission_tier(
    p_id UUID DEFAULT NULL,
    p_city_code TEXT DEFAULT NULL,
    p_property_id UUID DEFAULT NULL,
    p_name TEXT DEFAULT NULL,
    p_min_properties INTEGER DEFAULT 0,
    p_max_properties INTEGER DEFAULT NULL,
    p_commission_rate NUMERIC DEFAULT NULL,
    p_effective_from DATE DEFAULT CURRENT_DATE,
    p_effective_to DATE DEFAULT NULL,
    p_is_active BOOLEAN DEFAULT TRUE
)
RETURNS TABLE (
    mode TEXT,
    id UUID,
    city_code TEXT,
    property_id UUID,
    name TEXT,
    min_properties INTEGER,
    max_properties INTEGER,
    commission_rate NUMERIC,
    effective_from DATE,
    effective_to DATE,
    is_active BOOLEAN,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
BEGIN
    IF COALESCE(BTRIM(p_city_code), '') = '' THEN
        RAISE EXCEPTION 'city_code is required';
    END IF;
    IF COALESCE(BTRIM(p_name), '') = '' THEN
        RAISE EXCEPTION 'name is required';
    END IF;
    IF p_commission_rate IS NULL OR p_commission_rate < 0 OR p_commission_rate > 1 THEN
        RAISE EXCEPTION 'commission_rate must be between 0 and 1';
    END IF;

    IF p_id IS NULL THEN
        RETURN QUERY
        INSERT INTO reserve.commission_tiers (
            city_code,
            property_id,
            name,
            min_properties,
            max_properties,
            commission_rate,
            effective_from,
            effective_to,
            is_active
        ) VALUES (
            UPPER(BTRIM(p_city_code)),
            p_property_id,
            p_name,
            COALESCE(p_min_properties, 0),
            p_max_properties,
            p_commission_rate,
            COALESCE(p_effective_from, CURRENT_DATE),
            p_effective_to,
            COALESCE(p_is_active, TRUE)
        )
        RETURNING
            'created'::TEXT,
            reserve.commission_tiers.id,
            reserve.commission_tiers.city_code::TEXT,
            reserve.commission_tiers.property_id,
            reserve.commission_tiers.name::TEXT,
            reserve.commission_tiers.min_properties,
            reserve.commission_tiers.max_properties,
            reserve.commission_tiers.commission_rate,
            reserve.commission_tiers.effective_from,
            reserve.commission_tiers.effective_to,
            reserve.commission_tiers.is_active,
            reserve.commission_tiers.created_at,
            reserve.commission_tiers.updated_at;
    ELSE
        RETURN QUERY
        UPDATE reserve.commission_tiers ct
        SET
            city_code = UPPER(BTRIM(p_city_code)),
            property_id = p_property_id,
            name = p_name,
            min_properties = COALESCE(p_min_properties, 0),
            max_properties = p_max_properties,
            commission_rate = p_commission_rate,
            effective_from = COALESCE(p_effective_from, CURRENT_DATE),
            effective_to = p_effective_to,
            is_active = COALESCE(p_is_active, TRUE),
            updated_at = NOW()
        WHERE ct.id = p_id
        RETURNING
            'updated'::TEXT,
            ct.id,
            ct.city_code::TEXT,
            ct.property_id,
            ct.name::TEXT,
            ct.min_properties,
            ct.max_properties,
            ct.commission_rate,
            ct.effective_from,
            ct.effective_to,
            ct.is_active,
            ct.created_at,
            ct.updated_at;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.admin_s2_upsert_payout_schedule(
    p_id UUID DEFAULT NULL,
    p_entity_type TEXT DEFAULT NULL,
    p_entity_id UUID DEFAULT NULL,
    p_city_code TEXT DEFAULT NULL,
    p_frequency TEXT DEFAULT 'weekly',
    p_day_of_week INTEGER DEFAULT NULL,
    p_day_of_month INTEGER DEFAULT NULL,
    p_min_threshold NUMERIC DEFAULT 0,
    p_hold_days INTEGER DEFAULT 0,
    p_is_active BOOLEAN DEFAULT TRUE
)
RETURNS TABLE (
    mode TEXT,
    id UUID,
    entity_type TEXT,
    entity_id UUID,
    city_code TEXT,
    frequency TEXT,
    day_of_week INTEGER,
    day_of_month INTEGER,
    min_threshold NUMERIC,
    hold_days INTEGER,
    is_active BOOLEAN,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
BEGIN
    IF COALESCE(BTRIM(p_entity_type), '') NOT IN ('owner', 'property') THEN
        RAISE EXCEPTION 'entity_type must be owner or property';
    END IF;
    IF p_entity_id IS NULL THEN
        RAISE EXCEPTION 'entity_id is required';
    END IF;
    IF COALESCE(BTRIM(p_city_code), '') = '' THEN
        RAISE EXCEPTION 'city_code is required';
    END IF;

    IF p_id IS NULL THEN
        RETURN QUERY
        INSERT INTO reserve.payout_schedules (
            entity_type,
            entity_id,
            city_code,
            frequency,
            day_of_week,
            day_of_month,
            min_threshold,
            hold_days,
            is_active
        ) VALUES (
            LOWER(BTRIM(p_entity_type)),
            p_entity_id,
            UPPER(BTRIM(p_city_code)),
            LOWER(COALESCE(BTRIM(p_frequency), 'weekly')),
            p_day_of_week,
            p_day_of_month,
            COALESCE(p_min_threshold, 0),
            COALESCE(p_hold_days, 0),
            COALESCE(p_is_active, TRUE)
        )
        RETURNING
            'created'::TEXT,
            reserve.payout_schedules.id,
            reserve.payout_schedules.entity_type::TEXT,
            reserve.payout_schedules.entity_id,
            reserve.payout_schedules.city_code::TEXT,
            reserve.payout_schedules.frequency::TEXT,
            reserve.payout_schedules.day_of_week,
            reserve.payout_schedules.day_of_month,
            reserve.payout_schedules.min_threshold,
            reserve.payout_schedules.hold_days,
            reserve.payout_schedules.is_active,
            reserve.payout_schedules.created_at,
            reserve.payout_schedules.updated_at;
    ELSE
        RETURN QUERY
        UPDATE reserve.payout_schedules ps
        SET
            entity_type = LOWER(BTRIM(p_entity_type)),
            entity_id = p_entity_id,
            city_code = UPPER(BTRIM(p_city_code)),
            frequency = LOWER(COALESCE(BTRIM(p_frequency), 'weekly')),
            day_of_week = p_day_of_week,
            day_of_month = p_day_of_month,
            min_threshold = COALESCE(p_min_threshold, 0),
            hold_days = COALESCE(p_hold_days, 0),
            is_active = COALESCE(p_is_active, TRUE),
            updated_at = NOW()
        WHERE ps.id = p_id
        RETURNING
            'updated'::TEXT,
            ps.id,
            ps.entity_type::TEXT,
            ps.entity_id,
            ps.city_code::TEXT,
            ps.frequency::TEXT,
            ps.day_of_week,
            ps.day_of_month,
            ps.min_threshold,
            ps.hold_days,
            ps.is_active,
            ps.created_at,
            ps.updated_at;
    END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_s1_upsert_rate_plan(UUID, UUID, UUID, TEXT, TEXT, BOOLEAN, JSONB, INTEGER, INTEGER, INTEGER, TEXT, BOOLEAN) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_s1_upsert_availability_rows(JSONB) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_s2_upsert_commission_tier(UUID, TEXT, UUID, TEXT, INTEGER, INTEGER, NUMERIC, DATE, DATE, BOOLEAN) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_s2_upsert_payout_schedule(UUID, TEXT, UUID, TEXT, TEXT, INTEGER, INTEGER, NUMERIC, INTEGER, BOOLEAN) FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.admin_s1_upsert_rate_plan(UUID, UUID, UUID, TEXT, TEXT, BOOLEAN, JSONB, INTEGER, INTEGER, INTEGER, TEXT, BOOLEAN) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_s1_upsert_availability_rows(JSONB) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_s2_upsert_commission_tier(UUID, TEXT, UUID, TEXT, INTEGER, INTEGER, NUMERIC, DATE, DATE, BOOLEAN) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_s2_upsert_payout_schedule(UUID, TEXT, UUID, TEXT, TEXT, INTEGER, INTEGER, NUMERIC, INTEGER, BOOLEAN) TO service_role;
