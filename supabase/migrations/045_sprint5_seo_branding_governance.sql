-- ============================================
-- MIGRATION 045: SPRINT 5 SEO/BRANDING GOVERNANCE
-- Description: Adds city/language SEO overrides and public/admin wrappers
-- ============================================

CREATE TABLE IF NOT EXISTS public.seo_overrides (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    city_code TEXT NOT NULL,
    lang TEXT NOT NULL DEFAULT 'pt',
    meta_title TEXT,
    meta_description TEXT,
    canonical_url TEXT,
    og_image_url TEXT,
    noindex BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (tenant_id, city_code, lang)
);

CREATE INDEX IF NOT EXISTS idx_seo_overrides_tenant_city_lang ON public.seo_overrides(tenant_id, city_code, lang);
CREATE INDEX IF NOT EXISTS idx_seo_overrides_active ON public.seo_overrides(is_active, updated_at DESC);

ALTER TABLE public.seo_overrides ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS seo_overrides_auth_read ON public.seo_overrides;
CREATE POLICY seo_overrides_auth_read
    ON public.seo_overrides
    FOR SELECT
    TO authenticated
    USING (true);

DROP POLICY IF EXISTS seo_overrides_service_all ON public.seo_overrides;
CREATE POLICY seo_overrides_service_all
    ON public.seo_overrides
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

GRANT SELECT ON public.seo_overrides TO authenticated;
GRANT ALL ON public.seo_overrides TO service_role;

CREATE OR REPLACE FUNCTION public.admin_list_seo_overrides(
    p_tenant_id UUID DEFAULT '00000000-0000-0000-0000-000000000000',
    p_city_code TEXT DEFAULT NULL,
    p_lang TEXT DEFAULT NULL,
    p_active_only BOOLEAN DEFAULT FALSE
)
RETURNS TABLE (
    id UUID,
    tenant_id UUID,
    city_code TEXT,
    lang TEXT,
    meta_title TEXT,
    meta_description TEXT,
    canonical_url TEXT,
    og_image_url TEXT,
    noindex BOOLEAN,
    is_active BOOLEAN,
    updated_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT
        s.id,
        s.tenant_id,
        s.city_code,
        s.lang,
        s.meta_title,
        s.meta_description,
        s.canonical_url,
        s.og_image_url,
        s.noindex,
        s.is_active,
        s.updated_at
    FROM public.seo_overrides s
    WHERE s.tenant_id = COALESCE(p_tenant_id, '00000000-0000-0000-0000-000000000000')
      AND (p_city_code IS NULL OR UPPER(s.city_code) = UPPER(p_city_code))
      AND (p_lang IS NULL OR LOWER(s.lang) = LOWER(p_lang))
      AND (NOT p_active_only OR s.is_active = TRUE)
    ORDER BY s.updated_at DESC;
$$;

CREATE OR REPLACE FUNCTION public.admin_upsert_seo_override(
    p_tenant_id UUID,
    p_city_code TEXT,
    p_lang TEXT,
    p_meta_title TEXT DEFAULT NULL,
    p_meta_description TEXT DEFAULT NULL,
    p_canonical_url TEXT DEFAULT NULL,
    p_og_image_url TEXT DEFAULT NULL,
    p_noindex BOOLEAN DEFAULT FALSE,
    p_is_active BOOLEAN DEFAULT TRUE
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_row public.seo_overrides%ROWTYPE;
BEGIN
    IF COALESCE(TRIM(p_city_code), '') = '' THEN
        RAISE EXCEPTION 'city_code is required';
    END IF;

    IF COALESCE(TRIM(p_lang), '') = '' THEN
        RAISE EXCEPTION 'lang is required';
    END IF;

    INSERT INTO public.seo_overrides (
        tenant_id,
        city_code,
        lang,
        meta_title,
        meta_description,
        canonical_url,
        og_image_url,
        noindex,
        is_active,
        updated_at
    ) VALUES (
        COALESCE(p_tenant_id, '00000000-0000-0000-0000-000000000000'),
        UPPER(TRIM(p_city_code)),
        LOWER(TRIM(p_lang)),
        p_meta_title,
        p_meta_description,
        p_canonical_url,
        p_og_image_url,
        COALESCE(p_noindex, FALSE),
        COALESCE(p_is_active, TRUE),
        NOW()
    )
    ON CONFLICT (tenant_id, city_code, lang)
    DO UPDATE SET
        meta_title = EXCLUDED.meta_title,
        meta_description = EXCLUDED.meta_description,
        canonical_url = EXCLUDED.canonical_url,
        og_image_url = EXCLUDED.og_image_url,
        noindex = EXCLUDED.noindex,
        is_active = EXCLUDED.is_active,
        updated_at = NOW()
    RETURNING * INTO v_row;

    RETURN jsonb_build_object(
        'id', v_row.id,
        'tenant_id', v_row.tenant_id,
        'city_code', v_row.city_code,
        'lang', v_row.lang,
        'is_active', v_row.is_active,
        'updated_at', v_row.updated_at
    );
END;
$$;

CREATE OR REPLACE FUNCTION public.get_public_site_seo(
    p_tenant_id UUID DEFAULT '00000000-0000-0000-0000-000000000000',
    p_city_code TEXT DEFAULT NULL,
    p_lang TEXT DEFAULT 'pt'
)
RETURNS JSONB
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
    WITH base AS (
        SELECT
            ss.meta_title,
            ss.meta_description
        FROM public.site_settings ss
        WHERE ss.tenant_id = COALESCE(p_tenant_id, '00000000-0000-0000-0000-000000000000')
        LIMIT 1
    ), override AS (
        SELECT
            so.meta_title,
            so.meta_description,
            so.canonical_url,
            so.og_image_url,
            so.noindex
        FROM public.seo_overrides so
        WHERE so.tenant_id = COALESCE(p_tenant_id, '00000000-0000-0000-0000-000000000000')
          AND so.is_active = TRUE
          AND (p_city_code IS NULL OR UPPER(so.city_code) = UPPER(p_city_code))
          AND LOWER(so.lang) = LOWER(COALESCE(p_lang, 'pt'))
        ORDER BY so.updated_at DESC
        LIMIT 1
    )
    SELECT jsonb_build_object(
        'meta_title', COALESCE((SELECT override.meta_title FROM override), (SELECT base.meta_title FROM base), ''),
        'meta_description', COALESCE((SELECT override.meta_description FROM override), (SELECT base.meta_description FROM base), ''),
        'canonical_url', COALESCE((SELECT override.canonical_url FROM override), ''),
        'og_image_url', COALESCE((SELECT override.og_image_url FROM override), ''),
        'noindex', COALESCE((SELECT override.noindex FROM override), FALSE)
    );
$$;

REVOKE ALL ON FUNCTION public.admin_list_seo_overrides(UUID, TEXT, TEXT, BOOLEAN) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_upsert_seo_override(UUID, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, BOOLEAN, BOOLEAN) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_public_site_seo(UUID, TEXT, TEXT) FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.admin_list_seo_overrides(UUID, TEXT, TEXT, BOOLEAN) TO service_role;
GRANT EXECUTE ON FUNCTION public.admin_upsert_seo_override(UUID, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, BOOLEAN, BOOLEAN) TO service_role;
GRANT EXECUTE ON FUNCTION public.get_public_site_seo(UUID, TEXT, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION public.get_public_site_seo(UUID, TEXT, TEXT) TO anon;
