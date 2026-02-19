-- Migration: Create Site Settings, Social Links, and Branding Assets tables
-- Created: 2026-02-17

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Site Settings table
CREATE TABLE IF NOT EXISTS public.site_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL,
    site_name TEXT NOT NULL DEFAULT 'Reserve Connect',
    primary_cta_label TEXT,
    primary_cta_link TEXT,
    contact_email TEXT,
    contact_phone TEXT,
    whatsapp TEXT,
    meta_title TEXT,
    meta_description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT site_settings_tenant_id_key UNIQUE (tenant_id)
);

-- Social Links table
CREATE TABLE IF NOT EXISTS public.social_links (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL,
    platform TEXT NOT NULL CHECK (platform IN ('instagram', 'facebook', 'tiktok', 'youtube', 'linkedin')),
    url TEXT NOT NULL,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT social_links_tenant_platform_key UNIQUE (tenant_id, platform)
);

-- Branding Assets table
CREATE TABLE IF NOT EXISTS public.branding_assets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL,
    logo_url TEXT,
    favicon_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT branding_assets_tenant_id_key UNIQUE (tenant_id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_site_settings_tenant_id ON public.site_settings(tenant_id);
CREATE INDEX IF NOT EXISTS idx_social_links_tenant_id ON public.social_links(tenant_id);
CREATE INDEX IF NOT EXISTS idx_social_links_platform ON public.social_links(platform);
CREATE INDEX IF NOT EXISTS idx_branding_assets_tenant_id ON public.branding_assets(tenant_id);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
DROP TRIGGER IF EXISTS update_site_settings_updated_at ON public.site_settings;
CREATE TRIGGER update_site_settings_updated_at
    BEFORE UPDATE ON public.site_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_social_links_updated_at ON public.social_links;
CREATE TRIGGER update_social_links_updated_at
    BEFORE UPDATE ON public.social_links
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_branding_assets_updated_at ON public.branding_assets;
CREATE TRIGGER update_branding_assets_updated_at
    BEFORE UPDATE ON public.branding_assets
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security
ALTER TABLE public.site_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.social_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.branding_assets ENABLE ROW LEVEL SECURITY;

-- Create policies for authenticated users (Edge Functions use service role)
CREATE POLICY "Allow read for authenticated users" 
    ON public.site_settings FOR SELECT 
    TO authenticated 
    USING (true);

CREATE POLICY "Allow read for authenticated users" 
    ON public.social_links FOR SELECT 
    TO authenticated 
    USING (true);

CREATE POLICY "Allow read for authenticated users" 
    ON public.branding_assets FOR SELECT 
    TO authenticated 
    USING (true);

-- Insert default data for Urubici tenant
INSERT INTO public.site_settings (tenant_id, site_name, contact_email)
VALUES (
    '00000000-0000-0000-0000-000000000000',
    'Reserve Connect - Urubici',
    'contato@reserveconnect.com'
)
ON CONFLICT (tenant_id) DO NOTHING;

INSERT INTO public.branding_assets (tenant_id)
VALUES ('00000000-0000-0000-0000-000000000000')
ON CONFLICT (tenant_id) DO NOTHING;

-- Create audit log table for admin actions
CREATE TABLE IF NOT EXISTS public.admin_audit_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    action TEXT NOT NULL,
    table_name TEXT,
    record_id UUID,
    old_data JSONB,
    new_data JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_admin_audit_log_user_id ON public.admin_audit_log(user_id);
CREATE INDEX IF NOT EXISTS idx_admin_audit_log_created_at ON public.admin_audit_log(created_at);
CREATE INDEX IF NOT EXISTS idx_admin_audit_log_action ON public.admin_audit_log(action);

-- Enable RLS on audit log
ALTER TABLE public.admin_audit_log ENABLE ROW LEVEL SECURITY;

-- Only admins can view audit logs
CREATE POLICY "Allow read for authenticated users" 
    ON public.admin_audit_log FOR SELECT 
    TO authenticated 
    USING (true);

-- Grant permissions to authenticated users
GRANT SELECT ON public.site_settings TO authenticated;
GRANT SELECT ON public.social_links TO authenticated;
GRANT SELECT ON public.branding_assets TO authenticated;
GRANT SELECT ON public.admin_audit_log TO authenticated;

-- Grant all to service role (for Edge Functions)
GRANT ALL ON public.site_settings TO service_role;
GRANT ALL ON public.social_links TO service_role;
GRANT ALL ON public.branding_assets TO service_role;
GRANT ALL ON public.admin_audit_log TO service_role;
