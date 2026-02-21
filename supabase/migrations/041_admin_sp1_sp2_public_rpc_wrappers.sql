-- ============================================
-- MIGRATION 041: ADMIN SP1/SP2 PUBLIC RPC WRAPPERS
-- Description: Expose SP1/SP2 admin list operations via public RPC wrappers
-- ============================================

CREATE OR REPLACE FUNCTION public.admin_s1_list_units(
  p_property_id UUID DEFAULT NULL,
  p_city_code TEXT DEFAULT NULL,
  p_active_only BOOLEAN DEFAULT FALSE,
  p_limit INTEGER DEFAULT 300
)
RETURNS TABLE (
  id UUID,
  host_unit_id UUID,
  property_id UUID,
  property_name TEXT,
  property_city TEXT,
  name TEXT,
  slug TEXT,
  unit_type TEXT,
  description TEXT,
  max_occupancy INTEGER,
  base_capacity INTEGER,
  size_sqm INTEGER,
  is_active BOOLEAN,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
  SELECT
    u.id,
    u.host_unit_id,
    u.property_id,
    p.name::TEXT AS property_name,
    CONCAT_WS(', ', NULLIF(p.city, ''), NULLIF(p.state_province, ''))::TEXT AS property_city,
    u.name::TEXT,
    u.slug::TEXT,
    u.unit_type::TEXT,
    u.description::TEXT,
    u.max_occupancy,
    u.base_capacity,
    u.size_sqm,
    u.is_active,
    u.created_at,
    u.updated_at
  FROM reserve.unit_map u
  JOIN reserve.properties_map p ON p.id = u.property_id
  LEFT JOIN reserve.cities c ON c.id = p.city_id
  WHERE (p_property_id IS NULL OR u.property_id = p_property_id)
    AND (p_city_code IS NULL OR UPPER(c.code) = UPPER(p_city_code))
    AND (NOT p_active_only OR u.is_active = TRUE)
  ORDER BY u.updated_at DESC
  LIMIT LEAST(GREATEST(COALESCE(p_limit, 300), 1), 1000);
$$;

CREATE OR REPLACE FUNCTION public.admin_s1_list_rate_plans(
  p_property_id UUID DEFAULT NULL,
  p_active_only BOOLEAN DEFAULT FALSE,
  p_limit INTEGER DEFAULT 300
)
RETURNS TABLE (
  id UUID,
  property_id UUID,
  property_name TEXT,
  property_city TEXT,
  host_rate_plan_id UUID,
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
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
  SELECT
    rp.id,
    rp.property_id,
    p.name::TEXT AS property_name,
    CONCAT_WS(', ', NULLIF(p.city, ''), NULLIF(p.state_province, ''))::TEXT AS property_city,
    rp.host_rate_plan_id,
    rp.name::TEXT,
    rp.code::TEXT,
    rp.is_default,
    COALESCE(rp.channels_enabled, '[]'::JSONB) AS channels_enabled,
    rp.min_stay_nights,
    rp.max_stay_nights,
    rp.advance_booking_days,
    rp.cancellation_policy_code::TEXT,
    rp.is_active,
    rp.created_at,
    rp.updated_at
  FROM reserve.rate_plans rp
  JOIN reserve.properties_map p ON p.id = rp.property_id
  WHERE (p_property_id IS NULL OR rp.property_id = p_property_id)
    AND (NOT p_active_only OR rp.is_active = TRUE)
  ORDER BY rp.updated_at DESC
  LIMIT LEAST(GREATEST(COALESCE(p_limit, 300), 1), 1000);
$$;

CREATE OR REPLACE FUNCTION public.admin_s1_list_availability(
  p_unit_id UUID DEFAULT NULL,
  p_property_id UUID DEFAULT NULL,
  p_city_code TEXT DEFAULT NULL,
  p_start_date DATE DEFAULT CURRENT_DATE,
  p_end_date DATE DEFAULT (CURRENT_DATE + INTERVAL '30 days')::DATE,
  p_limit INTEGER DEFAULT 1000
)
RETURNS TABLE (
  id UUID,
  unit_id UUID,
  unit_name TEXT,
  property_id UUID,
  property_name TEXT,
  property_city TEXT,
  rate_plan_id UUID,
  rate_plan_name TEXT,
  date DATE,
  is_available BOOLEAN,
  is_blocked BOOLEAN,
  block_reason TEXT,
  min_stay_override INTEGER,
  base_price NUMERIC,
  discounted_price NUMERIC,
  currency TEXT,
  allotment INTEGER,
  bookings_count INTEGER,
  temp_holds INTEGER,
  updated_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
  SELECT
    ac.id,
    ac.unit_id,
    u.name::TEXT AS unit_name,
    u.property_id,
    p.name::TEXT AS property_name,
    CONCAT_WS(', ', NULLIF(p.city, ''), NULLIF(p.state_province, ''))::TEXT AS property_city,
    ac.rate_plan_id,
    rp.name::TEXT AS rate_plan_name,
    ac.date,
    ac.is_available,
    ac.is_blocked,
    ac.block_reason::TEXT,
    ac.min_stay_override,
    COALESCE(ac.base_price, 0) AS base_price,
    ac.discounted_price,
    ac.currency::TEXT,
    ac.allotment,
    ac.bookings_count,
    0::INTEGER AS temp_holds,
    ac.updated_at
  FROM reserve.availability_calendar ac
  JOIN reserve.unit_map u ON u.id = ac.unit_id
  JOIN reserve.properties_map p ON p.id = u.property_id
  JOIN reserve.rate_plans rp ON rp.id = ac.rate_plan_id
  LEFT JOIN reserve.cities c ON c.id = p.city_id
  WHERE ac.date BETWEEN COALESCE(p_start_date, CURRENT_DATE) AND COALESCE(p_end_date, (CURRENT_DATE + INTERVAL '30 days')::DATE)
    AND (p_unit_id IS NULL OR ac.unit_id = p_unit_id)
    AND (p_property_id IS NULL OR u.property_id = p_property_id)
    AND (p_city_code IS NULL OR UPPER(c.code) = UPPER(p_city_code))
  ORDER BY ac.date ASC
  LIMIT LEAST(GREATEST(COALESCE(p_limit, 1000), 1), 2000);
$$;

CREATE OR REPLACE FUNCTION public.admin_s1_list_booking_holds(
  p_city_code TEXT DEFAULT NULL,
  p_property_id UUID DEFAULT NULL,
  p_status TEXT DEFAULT NULL,
  p_only_active BOOLEAN DEFAULT TRUE,
  p_limit INTEGER DEFAULT 300
)
RETURNS TABLE (
  id UUID,
  session_id TEXT,
  city_code TEXT,
  property_id UUID,
  property_name TEXT,
  unit_id UUID,
  unit_name TEXT,
  rate_plan_id UUID,
  rate_plan_name TEXT,
  check_in DATE,
  check_out DATE,
  nights INTEGER,
  guests_adults INTEGER,
  guests_children INTEGER,
  guests_infants INTEGER,
  status TEXT,
  subtotal NUMERIC,
  taxes NUMERIC,
  fees NUMERIC,
  total_amount NUMERIC,
  currency TEXT,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
  SELECT
    bi.id,
    bi.session_id::TEXT,
    bi.city_code::TEXT,
    bi.property_id,
    p.name::TEXT AS property_name,
    bi.unit_id,
    u.name::TEXT AS unit_name,
    bi.rate_plan_id,
    rp.name::TEXT AS rate_plan_name,
    bi.check_in,
    bi.check_out,
    bi.nights,
    bi.guests_adults,
    bi.guests_children,
    bi.guests_infants,
    bi.status::TEXT,
    COALESCE(bi.subtotal, 0) AS subtotal,
    COALESCE(bi.taxes, 0) AS taxes,
    COALESCE(bi.fees, 0) AS fees,
    COALESCE(bi.total_amount, 0) AS total_amount,
    bi.currency::TEXT,
    bi.expires_at,
    bi.created_at,
    bi.updated_at
  FROM reserve.booking_intents bi
  JOIN reserve.properties_map p ON p.id = bi.property_id
  JOIN reserve.unit_map u ON u.id = bi.unit_id
  LEFT JOIN reserve.rate_plans rp ON rp.id = bi.rate_plan_id
  WHERE (p_city_code IS NULL OR UPPER(bi.city_code) = UPPER(p_city_code))
    AND (p_property_id IS NULL OR bi.property_id = p_property_id)
    AND (
      (p_status IS NOT NULL AND bi.status = p_status)
      OR (p_status IS NULL AND (NOT p_only_active OR bi.status IN ('intent_created', 'payment_pending')))
    )
  ORDER BY bi.created_at DESC
  LIMIT LEAST(GREATEST(COALESCE(p_limit, 300), 1), 1000);
$$;

CREATE OR REPLACE FUNCTION public.admin_s2_list_commission_tiers(
  p_city_code TEXT DEFAULT NULL,
  p_property_id UUID DEFAULT NULL,
  p_active_only BOOLEAN DEFAULT TRUE,
  p_limit INTEGER DEFAULT 300
)
RETURNS TABLE (
  id UUID,
  city_code TEXT,
  property_id UUID,
  property_name TEXT,
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
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
  SELECT
    ct.id,
    ct.city_code::TEXT,
    ct.property_id,
    p.name::TEXT AS property_name,
    ct.name::TEXT,
    ct.min_properties,
    ct.max_properties,
    COALESCE(ct.commission_rate, 0) AS commission_rate,
    ct.effective_from,
    ct.effective_to,
    ct.is_active,
    ct.created_at,
    ct.updated_at
  FROM reserve.commission_tiers ct
  LEFT JOIN reserve.properties_map p ON p.id = ct.property_id
  WHERE (p_city_code IS NULL OR UPPER(ct.city_code) = UPPER(p_city_code))
    AND (p_property_id IS NULL OR ct.property_id = p_property_id)
    AND (NOT p_active_only OR ct.is_active = TRUE)
  ORDER BY ct.city_code ASC, ct.min_properties ASC
  LIMIT LEAST(GREATEST(COALESCE(p_limit, 300), 1), 1000);
$$;

CREATE OR REPLACE FUNCTION public.admin_s2_list_payout_schedules(
  p_city_code TEXT DEFAULT NULL,
  p_entity_type TEXT DEFAULT NULL,
  p_active_only BOOLEAN DEFAULT TRUE,
  p_limit INTEGER DEFAULT 300
)
RETURNS TABLE (
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
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
  SELECT
    ps.id,
    ps.entity_type::TEXT,
    ps.entity_id,
    ps.city_code::TEXT,
    ps.frequency::TEXT,
    ps.day_of_week,
    ps.day_of_month,
    COALESCE(ps.min_threshold, 0) AS min_threshold,
    ps.hold_days,
    ps.is_active,
    ps.created_at,
    ps.updated_at
  FROM reserve.payout_schedules ps
  WHERE (p_city_code IS NULL OR UPPER(ps.city_code) = UPPER(p_city_code))
    AND (p_entity_type IS NULL OR LOWER(ps.entity_type) = LOWER(p_entity_type))
    AND (NOT p_active_only OR ps.is_active = TRUE)
  ORDER BY ps.city_code ASC, ps.updated_at DESC
  LIMIT LEAST(GREATEST(COALESCE(p_limit, 300), 1), 1000);
$$;

REVOKE ALL ON FUNCTION public.admin_s1_list_units(UUID, TEXT, BOOLEAN, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_s1_list_rate_plans(UUID, BOOLEAN, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_s1_list_availability(UUID, UUID, TEXT, DATE, DATE, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_s1_list_booking_holds(TEXT, UUID, TEXT, BOOLEAN, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_s2_list_commission_tiers(TEXT, UUID, BOOLEAN, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_s2_list_payout_schedules(TEXT, TEXT, BOOLEAN, INTEGER) FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.admin_s1_list_units(UUID, TEXT, BOOLEAN, INTEGER) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_s1_list_rate_plans(UUID, BOOLEAN, INTEGER) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_s1_list_availability(UUID, UUID, TEXT, DATE, DATE, INTEGER) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_s1_list_booking_holds(TEXT, UUID, TEXT, BOOLEAN, INTEGER) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_s2_list_commission_tiers(TEXT, UUID, BOOLEAN, INTEGER) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_s2_list_payout_schedules(TEXT, TEXT, BOOLEAN, INTEGER) TO service_role;
