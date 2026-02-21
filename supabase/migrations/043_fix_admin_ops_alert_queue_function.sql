-- ============================================
-- MIGRATION 043: FIX OPS ALERT QUEUE FUNCTION
-- Description: Fixes ambiguous column reference in admin_ops_alert_queue
-- ============================================

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
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    WITH sync AS (
        INSERT INTO reserve.ops_alert_lifecycle AS l (
            alert_code,
            severity,
            status,
            priority,
            last_seen_at,
            first_seen_at
        )
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
                WHEN l.severity <> EXCLUDED.severity THEN NOW()
                ELSE l.updated_at
            END
        RETURNING 1
    )
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
$$;
