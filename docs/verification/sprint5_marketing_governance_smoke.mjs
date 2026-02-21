#!/usr/bin/env node

const project = process.env.RC_SUPABASE_PROJECT || 'ffahkiukektmhkrkordn'
const anonKey = process.env.RC_SUPABASE_ANON_KEY
const adminEmail = process.env.RC_ADMIN_EMAIL
const adminPassword = process.env.RC_ADMIN_PASSWORD

if (!anonKey || !adminEmail || !adminPassword) {
  console.error('Missing required env vars: RC_SUPABASE_ANON_KEY, RC_ADMIN_EMAIL, RC_ADMIN_PASSWORD')
  process.exit(2)
}

const authUrl = `https://${project}.supabase.co/auth/v1/token?grant_type=password`
const fnBase = `https://${project}.supabase.co/functions/v1`
const tenantId = '00000000-0000-0000-0000-000000000000'

async function postJson(url, headers, payload) {
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...headers,
    },
    body: JSON.stringify(payload ?? {}),
  })
  let data
  try {
    data = await response.json()
  } catch {
    data = { raw: await response.text() }
  }
  return { ok: response.ok, status: response.status, data }
}

function pass(label, details = '') {
  console.log(`PASS  ${label}${details ? ` - ${details}` : ''}`)
}

function fail(label, details = '') {
  console.log(`FAIL  ${label}${details ? ` - ${details}` : ''}`)
}

async function main() {
  let failures = 0
  const login = await postJson(authUrl, { apikey: anonKey }, { email: adminEmail, password: adminPassword })
  if (!login.ok || !login.data?.access_token) {
    fail('Admin login', `status=${login.status}`)
    process.exit(1)
  }
  pass('Admin login', `status=${login.status}`)

  const authHeaders = { apikey: anonKey, Authorization: `Bearer ${login.data.access_token}` }

  const listSeo = await postJson(`${fnBase}/admin_list_seo_overrides`, authHeaders, { tenant_id: tenantId })
  if (listSeo.ok && listSeo.data?.success === true) pass('admin_list_seo_overrides', `status=${listSeo.status}`)
  else { fail('admin_list_seo_overrides', `status=${listSeo.status}`); failures += 1 }

  const upsertSeo = await postJson(`${fnBase}/admin_upsert_seo_override`, authHeaders, {
    tenant_id: tenantId,
    city_code: 'URB',
    lang: 'pt',
    meta_title: `Smoke SEO ${Date.now()}`,
    meta_description: 'Smoke validation for SP5 marketing governance',
    canonical_url: 'https://reserveconnect.com.br/urb',
    og_image_url: 'https://reserveconnect.com.br/og-urb.jpg',
    noindex: false,
    is_active: true,
  })
  if (upsertSeo.ok && upsertSeo.data?.success === true) pass('admin_upsert_seo_override', `status=${upsertSeo.status}`)
  else { fail('admin_upsert_seo_override', `status=${upsertSeo.status}`); failures += 1 }

  const getBranding = await postJson(`${fnBase}/admin_get_branding_assets`, authHeaders, { tenant_id: tenantId })
  if (getBranding.ok && getBranding.data?.success === true) pass('admin_get_branding_assets', `status=${getBranding.status}`)
  else { fail('admin_get_branding_assets', `status=${getBranding.status}`); failures += 1 }

  const upsertBranding = await postJson(`${fnBase}/admin_upsert_branding_assets`, authHeaders, {
    tenant_id: tenantId,
    logo_url: 'https://reserveconnect.com.br/logo.svg',
    favicon_url: 'https://reserveconnect.com.br/favicon.ico',
  })
  if (upsertBranding.ok && upsertBranding.data?.success === true) pass('admin_upsert_branding_assets', `status=${upsertBranding.status}`)
  else { fail('admin_upsert_branding_assets', `status=${upsertBranding.status}`); failures += 1 }

  console.log(`\nSummary: ${failures === 0 ? 'ALL PASS' : `${failures} failure(s)`}`)
  if (failures > 0) process.exit(1)
}

main().catch((error) => {
  console.error('SP5 smoke error:', error)
  process.exit(1)
})
