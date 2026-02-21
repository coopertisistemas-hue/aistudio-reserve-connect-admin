-- ============================================
-- MIGRATION 044: SPRINT 4 RBAC GOVERNANCE
-- Description: Action-level RBAC, admin users, audit feed, and integrations health wrappers
-- ============================================

CREATE TABLE IF NOT EXISTS reserve.admin_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    description TEXT,
    is_system BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS reserve.admin_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_key TEXT NOT NULL,
    action_key TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(module_key, action_key)
);

CREATE TABLE IF NOT EXISTS reserve.admin_role_permissions (
    role_id UUID NOT NULL REFERENCES reserve.admin_roles(id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES reserve.admin_permissions(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE IF NOT EXISTS reserve.admin_user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_user_id UUID,
    user_email TEXT NOT NULL,
    role_id UUID NOT NULL REFERENCES reserve.admin_roles(id) ON DELETE CASCADE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    assigned_by TEXT,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_email, role_id)
);

CREATE INDEX IF NOT EXISTS idx_admin_user_roles_email ON reserve.admin_user_roles(user_email, is_active);
CREATE INDEX IF NOT EXISTS idx_admin_user_roles_role ON reserve.admin_user_roles(role_id, is_active);

ALTER TABLE reserve.admin_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.admin_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.admin_role_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE reserve.admin_user_roles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS admin_roles_service_all ON reserve.admin_roles;
CREATE POLICY admin_roles_service_all ON reserve.admin_roles FOR ALL TO service_role USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS admin_permissions_service_all ON reserve.admin_permissions;
CREATE POLICY admin_permissions_service_all ON reserve.admin_permissions FOR ALL TO service_role USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS admin_role_permissions_service_all ON reserve.admin_role_permissions;
CREATE POLICY admin_role_permissions_service_all ON reserve.admin_role_permissions FOR ALL TO service_role USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS admin_user_roles_service_all ON reserve.admin_user_roles;
CREATE POLICY admin_user_roles_service_all ON reserve.admin_user_roles FOR ALL TO service_role USING (true) WITH CHECK (true);

INSERT INTO reserve.admin_roles (slug, name, description)
VALUES
    ('admin', 'Admin', 'Full administrative access'),
    ('ops_manager', 'Ops Manager', 'Operational and incident management access'),
    ('finance_manager', 'Finance Manager', 'Financial and payout governance access'),
    ('content_manager', 'Content Manager', 'Marketing and content operations access'),
    ('auditor', 'Auditor', 'Read-only governance and audit access')
ON CONFLICT (slug) DO UPDATE
SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    updated_at = NOW();

INSERT INTO reserve.admin_permissions (module_key, action_key, description)
VALUES
    ('users', 'read', 'Read admin users'),
    ('users', 'write', 'Write admin users'),
    ('permissions', 'read', 'Read role permissions matrix'),
    ('permissions', 'write', 'Write role permissions matrix'),
    ('audit', 'read', 'Read audit feed'),
    ('integrations', 'read', 'Read integrations health'),
    ('ops', 'read', 'Read operations and incidents'),
    ('ops', 'write', 'Write operations and incidents'),
    ('financial', 'read', 'Read financial module'),
    ('financial', 'write', 'Write financial governance'),
    ('inventory', 'read', 'Read inventory and rates'),
    ('inventory', 'write', 'Write inventory and rates'),
    ('reservations', 'read', 'Read reservations'),
    ('reservations', 'write', 'Write reservations'),
    ('marketing', 'read', 'Read marketing modules'),
    ('marketing', 'write', 'Write marketing modules')
ON CONFLICT (module_key, action_key) DO UPDATE
SET description = EXCLUDED.description;

INSERT INTO reserve.admin_role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM reserve.admin_roles r
JOIN reserve.admin_permissions p ON 1 = 1
WHERE r.slug = 'admin'
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO reserve.admin_user_roles (auth_user_id, user_email, role_id, is_active, assigned_by)
SELECT
    u.id,
    LOWER(u.email),
    r.id,
    TRUE,
    'migration_044'
FROM auth.users u
JOIN reserve.admin_roles r ON r.slug = 'admin'
WHERE COALESCE(u.raw_app_meta_data->>'role', '') = 'admin'
  AND u.email IS NOT NULL
ON CONFLICT (user_email, role_id) DO UPDATE
SET
    is_active = TRUE,
    updated_at = NOW();

CREATE OR REPLACE FUNCTION public.admin_check_role(
    p_user_email TEXT,
    p_module TEXT,
    p_action TEXT DEFAULT 'read'
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
DECLARE
    v_email TEXT;
    v_has_role_permission BOOLEAN := FALSE;
    v_is_legacy_admin BOOLEAN := FALSE;
    v_roles TEXT[] := ARRAY[]::TEXT[];
BEGIN
    v_email := LOWER(COALESCE(TRIM(p_user_email), ''));
    IF v_email = '' THEN
        RETURN jsonb_build_object('allowed', false, 'reason', 'missing_email', 'roles', v_roles);
    END IF;

    SELECT COALESCE(array_agg(DISTINCT r.slug), ARRAY[]::TEXT[])
    INTO v_roles
    FROM reserve.admin_user_roles ur
    JOIN reserve.admin_roles r ON r.id = ur.role_id
    WHERE LOWER(ur.user_email) = v_email
      AND ur.is_active = TRUE
      AND r.is_active = TRUE;

    SELECT EXISTS (
        SELECT 1
        FROM reserve.admin_user_roles ur
        JOIN reserve.admin_roles r ON r.id = ur.role_id
        JOIN reserve.admin_role_permissions rp ON rp.role_id = r.id
        JOIN reserve.admin_permissions p ON p.id = rp.permission_id
        WHERE LOWER(ur.user_email) = v_email
          AND ur.is_active = TRUE
          AND r.is_active = TRUE
          AND LOWER(p.module_key) = LOWER(COALESCE(p_module, ''))
          AND (
              LOWER(p.action_key) = LOWER(COALESCE(p_action, 'read'))
              OR LOWER(p.action_key) = '*'
          )
    ) INTO v_has_role_permission;

    SELECT EXISTS (
        SELECT 1
        FROM auth.users u
        WHERE LOWER(COALESCE(u.email, '')) = v_email
          AND COALESCE(u.raw_app_meta_data->>'role', '') = 'admin'
    ) INTO v_is_legacy_admin;

    RETURN jsonb_build_object(
        'allowed', (v_has_role_permission OR v_is_legacy_admin),
        'source', CASE WHEN v_has_role_permission THEN 'rbac' WHEN v_is_legacy_admin THEN 'legacy_admin_claim' ELSE 'none' END,
        'roles', v_roles,
        'module', p_module,
        'action', p_action
    );
END;
$$;

CREATE OR REPLACE FUNCTION public.admin_list_user_role_assignments()
RETURNS TABLE (
    user_email TEXT,
    role_slug TEXT,
    role_name TEXT,
    is_active BOOLEAN,
    assigned_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    SELECT
        ur.user_email::TEXT,
        r.slug::TEXT,
        r.name::TEXT,
        ur.is_active,
        ur.assigned_at,
        ur.updated_at
    FROM reserve.admin_user_roles ur
    JOIN reserve.admin_roles r ON r.id = ur.role_id
    ORDER BY ur.updated_at DESC;
$$;

CREATE OR REPLACE FUNCTION public.admin_assign_user_role(
    p_user_email TEXT,
    p_role_slug TEXT,
    p_is_active BOOLEAN DEFAULT TRUE,
    p_assigned_by TEXT DEFAULT 'admin_api'
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
DECLARE
    v_email TEXT;
    v_role_id UUID;
BEGIN
    v_email := LOWER(COALESCE(TRIM(p_user_email), ''));
    IF v_email = '' THEN
        RAISE EXCEPTION 'user_email is required';
    END IF;

    SELECT id INTO v_role_id
    FROM reserve.admin_roles
    WHERE slug = p_role_slug
    LIMIT 1;

    IF v_role_id IS NULL THEN
        RAISE EXCEPTION 'invalid role_slug';
    END IF;

    INSERT INTO reserve.admin_user_roles (user_email, role_id, is_active, assigned_by, assigned_at, updated_at)
    VALUES (v_email, v_role_id, COALESCE(p_is_active, TRUE), p_assigned_by, NOW(), NOW())
    ON CONFLICT (user_email, role_id) DO UPDATE
    SET
        is_active = EXCLUDED.is_active,
        assigned_by = EXCLUDED.assigned_by,
        assigned_at = NOW(),
        updated_at = NOW();

    RETURN jsonb_build_object('user_email', v_email, 'role_slug', p_role_slug, 'is_active', COALESCE(p_is_active, TRUE));
END;
$$;

CREATE OR REPLACE FUNCTION public.admin_list_roles_permissions()
RETURNS JSONB
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    SELECT jsonb_build_object(
        'roles', COALESCE((
            SELECT jsonb_agg(jsonb_build_object(
                'slug', r.slug,
                'name', r.name,
                'description', r.description,
                'is_active', r.is_active
            ) ORDER BY r.slug)
            FROM reserve.admin_roles r
        ), '[]'::jsonb),
        'permissions', COALESCE((
            SELECT jsonb_agg(jsonb_build_object(
                'module_key', p.module_key,
                'action_key', p.action_key,
                'description', p.description
            ) ORDER BY p.module_key, p.action_key)
            FROM reserve.admin_permissions p
        ), '[]'::jsonb),
        'matrix', COALESCE((
            SELECT jsonb_agg(jsonb_build_object(
                'role_slug', r.slug,
                'module_key', p.module_key,
                'action_key', p.action_key
            ) ORDER BY r.slug, p.module_key, p.action_key)
            FROM reserve.admin_role_permissions rp
            JOIN reserve.admin_roles r ON r.id = rp.role_id
            JOIN reserve.admin_permissions p ON p.id = rp.permission_id
        ), '[]'::jsonb)
    );
$$;

CREATE OR REPLACE FUNCTION public.admin_set_role_permissions(
    p_role_slug TEXT,
    p_permissions TEXT[]
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
DECLARE
    v_role_id UUID;
BEGIN
    SELECT id INTO v_role_id
    FROM reserve.admin_roles
    WHERE slug = p_role_slug
    LIMIT 1;

    IF v_role_id IS NULL THEN
        RAISE EXCEPTION 'invalid role_slug';
    END IF;

    DELETE FROM reserve.admin_role_permissions
    WHERE role_id = v_role_id;

    INSERT INTO reserve.admin_role_permissions (role_id, permission_id)
    SELECT v_role_id, p.id
    FROM reserve.admin_permissions p
    JOIN unnest(COALESCE(p_permissions, ARRAY[]::TEXT[])) input(value)
      ON input.value = CONCAT(p.module_key, ':', p.action_key)
    ON CONFLICT (role_id, permission_id) DO NOTHING;

    RETURN jsonb_build_object('role_slug', p_role_slug, 'permissions_count', (
        SELECT COUNT(*) FROM reserve.admin_role_permissions WHERE role_id = v_role_id
    ));
END;
$$;

CREATE OR REPLACE FUNCTION public.admin_list_audit_events(
    p_actor TEXT DEFAULT NULL,
    p_table_name TEXT DEFAULT NULL,
    p_limit INTEGER DEFAULT 200
)
RETURNS TABLE (
    id UUID,
    table_name TEXT,
    action TEXT,
    actor_type TEXT,
    actor_id TEXT,
    city_code TEXT,
    created_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    SELECT
        a.id,
        a.resource_type::TEXT,
        a.action::TEXT,
        a.actor_type::TEXT,
        a.actor_id::TEXT,
        (a.metadata->>'city_code')::TEXT,
        a.created_at
    FROM reserve.audit_logs a
    WHERE (p_actor IS NULL OR LOWER(COALESCE(a.actor_id, '')) LIKE CONCAT('%', LOWER(p_actor), '%'))
      AND (p_table_name IS NULL OR LOWER(a.resource_type) = LOWER(p_table_name))
    ORDER BY a.created_at DESC
    LIMIT LEAST(GREATEST(COALESCE(p_limit, 200), 1), 1000);
$$;

CREATE OR REPLACE FUNCTION public.admin_list_integrations_status(
    p_limit INTEGER DEFAULT 60
)
RETURNS JSONB
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, reserve
AS $$
    SELECT jsonb_build_object(
        'host_webhooks_failed_24h', (
            SELECT COUNT(*)
            FROM reserve.host_webhook_events h
            WHERE h.status = 'failed'
              AND h.created_at > NOW() - INTERVAL '24 hours'
        ),
        'payment_webhooks_failed_24h', (
            SELECT COUNT(*)
            FROM reserve.processed_webhooks w
            WHERE w.status = 'failed'
              AND w.received_at > NOW() - INTERVAL '24 hours'
        ),
        'latest_host_webhooks', COALESCE((
            SELECT jsonb_agg(jsonb_build_object(
                'id', h.id,
                'status', h.status,
                'created_at', h.created_at,
                'provider', h.provider,
                'event_type', COALESCE(h.event_type, 'unknown')
            ) ORDER BY h.created_at DESC)
            FROM (
                SELECT id, status, created_at, 'host_connect'::TEXT AS provider, event_type
                FROM reserve.host_webhook_events
                ORDER BY created_at DESC
                LIMIT LEAST(GREATEST(COALESCE(p_limit, 60), 1), 200)
            ) h
        ), '[]'::jsonb),
        'latest_payment_webhooks', COALESCE((
            SELECT jsonb_agg(jsonb_build_object(
                'id', w.id,
                'status', w.status,
                'received_at', w.received_at,
                'provider', w.provider,
                'event_type', w.event_type
            ) ORDER BY w.received_at DESC)
            FROM (
                SELECT id, status, received_at, provider, event_type
                FROM reserve.processed_webhooks
                ORDER BY received_at DESC
                LIMIT LEAST(GREATEST(COALESCE(p_limit, 60), 1), 200)
            ) w
        ), '[]'::jsonb)
    );
$$;

REVOKE ALL ON FUNCTION public.admin_check_role(TEXT, TEXT, TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_list_user_role_assignments() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_assign_user_role(TEXT, TEXT, BOOLEAN, TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_list_roles_permissions() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_set_role_permissions(TEXT, TEXT[]) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_list_audit_events(TEXT, TEXT, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_list_integrations_status(INTEGER) FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.admin_check_role(TEXT, TEXT, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_list_user_role_assignments() TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_assign_user_role(TEXT, TEXT, BOOLEAN, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_list_roles_permissions() TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_set_role_permissions(TEXT, TEXT[]) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_list_audit_events(TEXT, TEXT, INTEGER) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_list_integrations_status(INTEGER) TO service_role;
