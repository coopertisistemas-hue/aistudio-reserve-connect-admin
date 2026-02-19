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

async function httpJson(url, { method = 'POST', headers = {}, body } = {}) {
  const response = await fetch(url, {
    method,
    headers: {
      'Content-Type': 'application/json',
      ...headers,
    },
    body: body ? JSON.stringify(body) : undefined,
  })

  let data = null
  try {
    data = await response.json()
  } catch {
    data = { raw: await response.text() }
  }

  return { ok: response.ok, status: response.status, data }
}

function check(condition, label, details = '') {
  if (condition) {
    console.log(`PASS  ${label}${details ? ` - ${details}` : ''}`)
    return true
  }

  console.log(`FAIL  ${label}${details ? ` - ${details}` : ''}`)
  return false
}

async function main() {
  const results = []

  const login = await httpJson(authUrl, {
    method: 'POST',
    headers: { apikey: anonKey },
    body: { email: adminEmail, password: adminPassword },
  })

  results.push(check(login.ok && login.data?.access_token, 'Admin login', `status=${login.status}`))
  if (!login.ok || !login.data?.access_token) {
    process.exit(1)
  }

  const token = login.data.access_token
  const authHeaders = {
    apikey: anonKey,
    Authorization: `Bearer ${token}`,
  }

  const endpoints = [
    ['admin_list_payments', {}],
    ['admin_get_payment_detail', { payment_id: '7f9b9014-7307-45a7-8cf1-2b2c7777a241' }],
    ['admin_list_ledger_entries', {}],
    ['admin_list_payouts', {}],
    ['admin_get_payout_detail', { payout_id: '49dbf79f-4d4f-4706-bfcf-aaf8865c9b51' }],
    ['admin_ops_summary', {}],
    ['admin_list_ops_alerts', {}],
    ['admin_ops_retention_preview', {}],
    ['admin_ops_reconciliation_status', {}],
  ]

  for (const [fn, payload] of endpoints) {
    const res = await httpJson(`${fnBase}/${fn}`, {
      method: 'POST',
      headers: authHeaders,
      body: payload,
    })

    const ok = res.ok && res.data?.success === true
    results.push(check(ok, fn, `status=${res.status}`))
  }

  const passCount = results.filter(Boolean).length
  const failCount = results.length - passCount
  console.log(`\nSummary: ${passCount} passed, ${failCount} failed`)

  if (failCount > 0) {
    process.exit(1)
  }
}

main().catch((error) => {
  console.error('Smoke script error:', error)
  process.exit(1)
})
