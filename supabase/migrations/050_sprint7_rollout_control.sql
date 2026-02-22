-- ============================================
-- MIGRATION 050: SPRINT 7 ROLLOUT CONTROL
-- Description: Feature flags, city rollout controls and rollback events
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.feature_flags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_key TEXT NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT FALSE,
    rollout_percent INTEGER NOT NULL DEFAULT 0 CHECK (rollout_percent >= 0 AND rollout_percent <= 100),
    note TEXT,
    updated_by TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (module_key)
);

CREATE TABLE IF NOT EXISTS reserve.city_rollout_controls (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code TEXT NOT NULL,
    is_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    phase TEXT NOT NULL DEFAULT 'pilot',
    note TEXT,
    updated_by TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (city_code)
);

CREATE TABLE IF NOT EXISTS reserve.rollout_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type TEXT NOT NULL,
    module_key TEXT,
    city_code TEXT,
    payload JSONB NOT NULL DEFAULT '{}'::JSONB,
    triggered_by TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE reserve.feature_flags ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.city_rollout_controls ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.rollout_events ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS feature_flags_service_all ON reserve.feature_flags;
CREATE POLICY feature_flags_service_all ON reserve.feature_flags FOR ALL TO service_role USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS city_rollout_controls_service_all ON reserve.city_rollout_controls;
CREATE POLICY city_rollout_controls_service_all ON reserve.city_rollout_controls FOR ALL TO service_role USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS rollout_events_service_all ON reserve.rollout_events;
CREATE POLICY rollout_events_service_all ON reserve.rollout_events FOR ALL TO service_role USING (true) WITH CHECK (true);

CREATE OR REPLACE FUNCTION public.admin_list_feature_flags()
RETURNS TABLE (
    id UUID,
    module_key TEXT,
    enabled BOOLEAN,
    rollout_percent INTEGER,
    note TEXT,
    updated_by TEXT,
    updated_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    SELECT
        ff.id,
        ff.module_key::TEXT,
        ff.enabled,
        ff.rollout_percent,
        ff.note::TEXT,
        ff.updated_by::TEXT,
        ff.updated_at
    FROM reserve.feature_flags ff
    ORDER BY ff.module_key ASC;
$$;

CREATE OR REPLACE FUNCTION public.admin_upsert_feature_flag(
    p_module_key TEXT,
    p_enabled BOOLEAN DEFAULT FALSE,
    p_rollout_percent INTEGER DEFAULT 0,
    p_note TEXT DEFAULT NULL,
    p_updated_by TEXT DEFAULT 'admin_api'
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
DECLARE
    v_row reserve.feature_flags%ROWTYPE;
BEGIN
    IF COALESCE(BTRIM(p_module_key), '') = '' THEN
        RAISE EXCEPTION 'module_key is required';
    END IF;

    INSERT INTO reserve.feature_flags (module_key, enabled, rollout_percent, note, updated_by, updated_at)
    VALUES (LOWER(BTRIM(p_module_key)), COALESCE(p_enabled, FALSE), LEAST(GREATEST(COALESCE(p_rollout_percent, 0), 0), 100), p_note, p_updated_by, NOW())
    ON CONFLICT (module_key)
    DO UPDATE SET
        enabled = EXCLUDED.enabled,
        rollout_percent = EXCLUDED.rollout_percent,
        note = EXCLUDED.note,
        updated_by = EXCLUDED.updated_by,
        updated_at = NOW()
    RETURNING * INTO v_row;

    INSERT INTO reserve.rollout_events (event_type, module_key, payload, triggered_by)
    VALUES ('feature_flag_upsert', v_row.module_key, jsonb_build_object('enabled', v_row.enabled, 'rollout_percent', v_row.rollout_percent), p_updated_by);

    RETURN jsonb_build_object(
        'id', v_row.id,
        'module_key', v_row.module_key,
        'enabled', v_row.enabled,
        'rollout_percent', v_row.rollout_percent,
        'updated_at', v_row.updated_at
    );
END;
$$;

CREATE OR REPLACE FUNCTION public.admin_list_city_rollouts()
RETURNS TABLE (
    id UUID,
    city_code TEXT,
    is_enabled BOOLEAN,
    phase TEXT,
    note TEXT,
    updated_by TEXT,
    updated_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    SELECT
        c.id,
        c.city_code::TEXT,
        c.is_enabled,
        c.phase::TEXT,
        c.note::TEXT,
        c.updated_by::TEXT,
        c.updated_at
    FROM reserve.city_rollout_controls c
    ORDER BY c.city_code ASC;
$$;

CREATE OR REPLACE FUNCTION public.admin_upsert_city_rollout(
    p_city_code TEXT,
    p_is_enabled BOOLEAN DEFAULT FALSE,
    p_phase TEXT DEFAULT 'pilot',
    p_note TEXT DEFAULT NULL,
    p_updated_by TEXT DEFAULT 'admin_api'
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
DECLARE
    v_row reserve.city_rollout_controls%ROWTYPE;
BEGIN
    IF COALESCE(BTRIM(p_city_code), '') = '' THEN
        RAISE EXCEPTION 'city_code is required';
    END IF;

    INSERT INTO reserve.city_rollout_controls (city_code, is_enabled, phase, note, updated_by, updated_at)
    VALUES (UPPER(BTRIM(p_city_code)), COALESCE(p_is_enabled, FALSE), LOWER(COALESCE(BTRIM(p_phase), 'pilot')), p_note, p_updated_by, NOW())
    ON CONFLICT (city_code)
    DO UPDATE SET
        is_enabled = EXCLUDED.is_enabled,
        phase = EXCLUDED.phase,
        note = EXCLUDED.note,
        updated_by = EXCLUDED.updated_by,
        updated_at = NOW()
    RETURNING * INTO v_row;

    INSERT INTO reserve.rollout_events (event_type, city_code, payload, triggered_by)
    VALUES ('city_rollout_upsert', v_row.city_code, jsonb_build_object('is_enabled', v_row.is_enabled, 'phase', v_row.phase), p_updated_by);

    RETURN jsonb_build_object(
        'id', v_row.id,
        'city_code', v_row.city_code,
        'is_enabled', v_row.is_enabled,
        'phase', v_row.phase,
        'updated_at', v_row.updated_at
    );
END;
$$;

CREATE OR REPLACE FUNCTION public.admin_rollout_rollback(
    p_scope TEXT DEFAULT 'all',
    p_city_code TEXT DEFAULT NULL,
    p_triggered_by TEXT DEFAULT 'admin_api',
    p_reason TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
BEGIN
    IF LOWER(COALESCE(p_scope, 'all')) IN ('all', 'global') THEN
        UPDATE reserve.feature_flags
        SET enabled = FALSE, rollout_percent = 0, updated_by = p_triggered_by, updated_at = NOW();

        UPDATE reserve.city_rollout_controls
        SET is_enabled = FALSE, phase = 'rollback', updated_by = p_triggered_by, updated_at = NOW();
    ELSIF LOWER(COALESCE(p_scope, '')) = 'city' THEN
        IF COALESCE(BTRIM(p_city_code), '') = '' THEN
            RAISE EXCEPTION 'city_code is required for city scope rollback';
        END IF;

        UPDATE reserve.city_rollout_controls
        SET is_enabled = FALSE, phase = 'rollback', updated_by = p_triggered_by, updated_at = NOW()
        WHERE city_code = UPPER(BTRIM(p_city_code));
    ELSE
        RAISE EXCEPTION 'invalid rollback scope';
    END IF;

    INSERT INTO reserve.rollout_events (event_type, city_code, payload, triggered_by)
    VALUES (
        'rollback',
        CASE WHEN LOWER(COALESCE(p_scope, 'all')) = 'city' THEN UPPER(BTRIM(COALESCE(p_city_code, ''))) ELSE NULL END,
        jsonb_build_object('scope', p_scope, 'reason', COALESCE(p_reason, 'manual rollback')),
        p_triggered_by
    );

    RETURN jsonb_build_object('ok', true, 'scope', p_scope, 'city_code', p_city_code, 'reason', COALESCE(p_reason, 'manual rollback'));
END;
$$;

REVOKE ALL ON FUNCTION public.admin_list_feature_flags() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_upsert_feature_flag(TEXT, BOOLEAN, INTEGER, TEXT, TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_list_city_rollouts() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_upsert_city_rollout(TEXT, BOOLEAN, TEXT, TEXT, TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_rollout_rollback(TEXT, TEXT, TEXT, TEXT) FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.admin_list_feature_flags() TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_upsert_feature_flag(TEXT, BOOLEAN, INTEGER, TEXT, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_list_city_rollouts() TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_upsert_city_rollout(TEXT, BOOLEAN, TEXT, TEXT, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_rollout_rollback(TEXT, TEXT, TEXT, TEXT) TO service_role;
