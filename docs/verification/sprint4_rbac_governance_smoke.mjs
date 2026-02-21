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

  const checks = [
    ['admin_list_users', {}],
    ['admin_list_roles_permissions', {}],
    ['admin_list_audit_events', { limit: 50 }],
    ['admin_list_integrations_status', { limit: 20 }],
  ]

  for (const [fn, payload] of checks) {
    const res = await postJson(`${fnBase}/${fn}`, authHeaders, payload)
    const ok = res.ok && res.data?.success === true
    if (ok) pass(`${fn}`, `status=${res.status}`)
    else {
      fail(`${fn}`, `status=${res.status}`)
      failures += 1
    }
  }

  const unauth = await postJson(`${fnBase}/admin_list_users`, { apikey: anonKey }, {})
  if (!unauth.ok && unauth.status === 401) {
    pass('Negative access check', `status=${unauth.status}`)
  } else {
    fail('Negative access check', `status=${unauth.status}`)
    failures += 1
  }

  console.log(`\nSummary: ${failures === 0 ? 'ALL PASS' : `${failures} failure(s)`}`)
  if (failures > 0) process.exit(1)
}

main().catch((error) => {
  console.error('RBAC governance smoke error:', error)
  process.exit(1)
})
