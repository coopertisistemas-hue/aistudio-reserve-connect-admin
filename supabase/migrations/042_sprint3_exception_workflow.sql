-- ============================================
-- MIGRATION 042: SPRINT 3 EXCEPTION WORKFLOW
-- Description: Adds exception lifecycle state, ownership, SLA and update RPCs
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.ops_alert_lifecycle (
    alert_code TEXT PRIMARY KEY,
    severity TEXT NOT NULL DEFAULT 'INFO',
    status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'ack', 'in_progress', 'resolved', 'snoozed')),
    priority TEXT NOT NULL DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'critical')),
    owner_email TEXT,
    notes TEXT,
    snoozed_until TIMESTAMPTZ,
    first_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resolved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ops_alert_lifecycle_status ON reserve.ops_alert_lifecycle(status, priority, updated_at DESC);
CREATE INDEX IF NOT EXISTS idx_ops_alert_lifecycle_owner ON reserve.ops_alert_lifecycle(owner_email, status);

ALTER TABLE reserve.ops_alert_lifecycle ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS ops_alert_lifecycle_service_all ON reserve.ops_alert_lifecycle;
CREATE POLICY ops_alert_lifecycle_service_all
    ON reserve.ops_alert_lifecycle
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

CREATE OR REPLACE FUNCTION public.admin_ops_alert_queue(
    p_severity TEXT DEFAULT NULL,
    p_status TEXT DEFAULT NULL,
    p_owner_email TEXT DEFAULT NULL,
    p_limit INTEGER DEFAULT 300
)
RETURNS TABLE (
    alert_code TEXT,
    severity TEXT,
    description TEXT,
    evidence_query TEXT,
    status TEXT,
    priority TEXT,
    owner_email TEXT,
    notes TEXT,
    snoozed_until TIMESTAMPTZ,
    first_seen_at TIMESTAMPTZ,
    last_seen_at TIMESTAMPTZ,
    aging_minutes INTEGER,
    sla_minutes INTEGER,
    sla_breached BOOLEAN
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
BEGIN
    INSERT INTO reserve.ops_alert_lifecycle (alert_code, severity, status, priority, last_seen_at, first_seen_at)
    SELECT
        a.alert_code::TEXT,
        a.severity::TEXT,
        'open',
        CASE
            WHEN a.severity = 'CRITICAL' THEN 'critical'
            WHEN a.severity = 'WARNING' THEN 'high'
            ELSE 'medium'
        END,
        NOW(),
        NOW()
    FROM reserve.ops_dashboard_alerts a
    ON CONFLICT (alert_code) DO UPDATE
    SET
        severity = EXCLUDED.severity,
        last_seen_at = NOW(),
        updated_at = CASE
            WHEN reserve.ops_alert_lifecycle.severity <> EXCLUDED.severity THEN NOW()
            ELSE reserve.ops_alert_lifecycle.updated_at
        END;

    RETURN QUERY
    SELECT
        a.alert_code::TEXT,
        a.severity::TEXT,
        a.description::TEXT,
        a.evidence_query::TEXT,
        l.status::TEXT,
        l.priority::TEXT,
        l.owner_email::TEXT,
        l.notes::TEXT,
        l.snoozed_until,
        l.first_seen_at,
        l.last_seen_at,
        FLOOR(EXTRACT(EPOCH FROM (NOW() - l.first_seen_at)) / 60)::INTEGER AS aging_minutes,
        CASE
            WHEN a.severity = 'CRITICAL' THEN 30
            WHEN a.severity = 'WARNING' THEN 120
            ELSE 480
        END AS sla_minutes,
        FLOOR(EXTRACT(EPOCH FROM (NOW() - l.first_seen_at)) / 60)::INTEGER >
            CASE
                WHEN a.severity = 'CRITICAL' THEN 30
                WHEN a.severity = 'WARNING' THEN 120
                ELSE 480
            END AS sla_breached
    FROM reserve.ops_dashboard_alerts a
    JOIN reserve.ops_alert_lifecycle l ON l.alert_code = a.alert_code
    WHERE (p_severity IS NULL OR UPPER(a.severity::TEXT) = UPPER(p_severity))
      AND (p_status IS NULL OR l.status = p_status)
      AND (
          p_owner_email IS NULL
          OR (
              CASE
                  WHEN LOWER(p_owner_email) = '__unassigned__' THEN COALESCE(NULLIF(TRIM(l.owner_email), ''), '') = ''
                  ELSE LOWER(COALESCE(l.owner_email, '')) = LOWER(p_owner_email)
              END
          )
      )
    ORDER BY
        CASE a.severity
            WHEN 'CRITICAL' THEN 1
            WHEN 'WARNING' THEN 2
            ELSE 3
        END,
        l.first_seen_at ASC
    LIMIT LEAST(GREATEST(COALESCE(p_limit, 300), 1), 1000);
END;
$$;

CREATE OR REPLACE FUNCTION public.admin_ops_alert_update(
    p_alert_code TEXT,
    p_status TEXT DEFAULT NULL,
    p_owner_email TEXT DEFAULT NULL,
    p_priority TEXT DEFAULT NULL,
    p_note TEXT DEFAULT NULL,
    p_snoozed_until TIMESTAMPTZ DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
DECLARE
    v_severity TEXT := 'INFO';
    v_existing reserve.ops_alert_lifecycle%ROWTYPE;
    v_status TEXT;
    v_priority TEXT;
    v_owner_email TEXT;
    v_notes TEXT;
    v_snoozed_until TIMESTAMPTZ;
    v_resolved_at TIMESTAMPTZ;
BEGIN
    IF p_alert_code IS NULL OR BTRIM(p_alert_code) = '' THEN
        RAISE EXCEPTION 'alert_code is required';
    END IF;

    IF p_status IS NOT NULL AND p_status NOT IN ('open', 'ack', 'in_progress', 'resolved', 'snoozed') THEN
        RAISE EXCEPTION 'invalid status';
    END IF;

    IF p_priority IS NOT NULL AND p_priority NOT IN ('low', 'medium', 'high', 'critical') THEN
        RAISE EXCEPTION 'invalid priority';
    END IF;

    SELECT a.severity::TEXT
    INTO v_severity
    FROM reserve.ops_dashboard_alerts a
    WHERE a.alert_code = p_alert_code
    LIMIT 1;

    IF v_severity IS NULL THEN
        v_severity := 'INFO';
    END IF;

    INSERT INTO reserve.ops_alert_lifecycle (alert_code, severity)
    VALUES (p_alert_code, v_severity)
    ON CONFLICT (alert_code) DO NOTHING;

    SELECT *
    INTO v_existing
    FROM reserve.ops_alert_lifecycle
    WHERE alert_code = p_alert_code
    FOR UPDATE;

    v_status := COALESCE(p_status, v_existing.status);
    v_priority := COALESCE(p_priority, v_existing.priority);

    IF p_owner_email IS NULL THEN
        v_owner_email := v_existing.owner_email;
    ELSIF BTRIM(p_owner_email) = '' THEN
        v_owner_email := NULL;
    ELSE
        v_owner_email := LOWER(BTRIM(p_owner_email));
    END IF;

    IF p_note IS NULL OR BTRIM(p_note) = '' THEN
        v_notes := v_existing.notes;
    ELSE
        v_notes := CONCAT_WS(E'\n', v_existing.notes, CONCAT(TO_CHAR(NOW(), 'YYYY-MM-DD HH24:MI'), ' - ', BTRIM(p_note)));
    END IF;

    v_snoozed_until := COALESCE(p_snoozed_until, v_existing.snoozed_until);
    v_resolved_at := CASE WHEN v_status = 'resolved' THEN NOW() ELSE NULL END;

    UPDATE reserve.ops_alert_lifecycle
    SET
        severity = v_severity,
        status = v_status,
        priority = v_priority,
        owner_email = v_owner_email,
        notes = v_notes,
        snoozed_until = v_snoozed_until,
        resolved_at = v_resolved_at,
        updated_at = NOW(),
        last_seen_at = NOW()
    WHERE alert_code = p_alert_code;

    RETURN (
        SELECT jsonb_build_object(
            'alert_code', l.alert_code,
            'severity', l.severity,
            'status', l.status,
            'priority', l.priority,
            'owner_email', l.owner_email,
            'snoozed_until', l.snoozed_until,
            'resolved_at', l.resolved_at,
            'updated_at', l.updated_at
        )
        FROM reserve.ops_alert_lifecycle l
        WHERE l.alert_code = p_alert_code
    );
END;
$$;

CREATE OR REPLACE FUNCTION public.admin_ops_alert_bulk_update(
    p_alert_codes TEXT[],
    p_status TEXT DEFAULT NULL,
    p_owner_email TEXT DEFAULT NULL,
    p_priority TEXT DEFAULT NULL,
    p_note TEXT DEFAULT NULL,
    p_snoozed_until TIMESTAMPTZ DEFAULT NULL
)
RETURNS TABLE (
    alert_code TEXT,
    status TEXT,
    owner_email TEXT,
    updated_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    WITH updated AS (
        SELECT public.admin_ops_alert_update(
            code,
            p_status,
            p_owner_email,
            p_priority,
            p_note,
            p_snoozed_until
        ) AS payload
        FROM unnest(COALESCE(p_alert_codes, ARRAY[]::TEXT[])) AS code
    )
    SELECT
        payload->>'alert_code' AS alert_code,
        payload->>'status' AS status,
        payload->>'owner_email' AS owner_email,
        (payload->>'updated_at')::TIMESTAMPTZ AS updated_at
    FROM updated;
$$;

CREATE OR REPLACE FUNCTION public.admin_ops_unowned_critical_alerts()
RETURNS TABLE (
    alert_code TEXT,
    severity TEXT,
    description TEXT,
    aging_minutes INTEGER,
    generated_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    SELECT
        q.alert_code,
        q.severity,
        q.description,
        q.aging_minutes,
        NOW() AS generated_at
    FROM public.admin_ops_alert_queue('CRITICAL', NULL, '__unassigned__', 200) q
    WHERE q.status <> 'resolved';
$$;

REVOKE ALL ON FUNCTION public.admin_ops_alert_queue(TEXT, TEXT, TEXT, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_ops_alert_update(TEXT, TEXT, TEXT, TEXT, TEXT, TIMESTAMPTZ) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_ops_alert_bulk_update(TEXT[], TEXT, TEXT, TEXT, TEXT, TIMESTAMPTZ) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_ops_unowned_critical_alerts() FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.admin_ops_alert_queue(TEXT, TEXT, TEXT, INTEGER) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_ops_alert_update(TEXT, TEXT, TEXT, TEXT, TEXT, TIMESTAMPTZ) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_ops_alert_bulk_update(TEXT[], TEXT, TEXT, TEXT, TEXT, TIMESTAMPTZ) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_ops_unowned_critical_alerts() TO service_role;
