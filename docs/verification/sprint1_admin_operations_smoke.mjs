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

function logPass(label, details = '') {
  console.log(`PASS  ${label}${details ? ` - ${details}` : ''}`)
}

function logFail(label, details = '') {
  console.log(`FAIL  ${label}${details ? ` - ${details}` : ''}`)
}

function isSuccessResponse(res) {
  return res.ok && res.data?.success === true && Array.isArray(res.data?.data)
}

async function main() {
  let fails = 0

  const login = await postJson(authUrl, { apikey: anonKey }, { email: adminEmail, password: adminPassword })
  if (!login.ok || !login.data?.access_token) {
    logFail('Admin login', `status=${login.status}`)
    process.exit(1)
  }
  logPass('Admin login', `status=${login.status}`)

  const authHeaders = { apikey: anonKey, Authorization: `Bearer ${login.data.access_token}` }

  const checks = [
    ['admin_list_units', {}],
    ['admin_list_rate_plans', {}],
    ['admin_list_availability', {
      start_date: new Date().toISOString().slice(0, 10),
      end_date: new Date(Date.now() + 1000 * 60 * 60 * 24 * 7).toISOString().slice(0, 10),
    }],
    ['admin_list_booking_holds', { only_active: true }],
  ]

  for (const [fn, payload] of checks) {
    const res = await postJson(`${fnBase}/${fn}`, authHeaders, payload)
    if (isSuccessResponse(res)) {
      const count = res.data.data.length
      logPass(fn, `status=${res.status}, items=${count}`)
    } else {
      logFail(fn, `status=${res.status}`)
      fails += 1
    }
  }

  const summary = fails === 0 ? 'ALL PASS' : `${fails} failure(s)`
  console.log(`\nSummary: ${summary}`)
  if (fails > 0) process.exit(1)
}

main().catch((error) => {
  console.error('Sprint 1 smoke error:', error)
  process.exit(1)
})
