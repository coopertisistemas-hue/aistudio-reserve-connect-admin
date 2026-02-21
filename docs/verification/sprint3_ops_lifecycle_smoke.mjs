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

  const queue = await postJson(`${fnBase}/admin_list_exception_queue`, authHeaders, {})
  if (!queue.ok || queue.data?.success !== true || !Array.isArray(queue.data?.data)) {
    fail('Load exception queue', `status=${queue.status}`)
    process.exit(1)
  }
  pass('Load exception queue', `items=${queue.data.data.length}`)

  const hasQueueAlert = queue.data.data.length > 0
  const alertCode = hasQueueAlert
    ? queue.data.data[0].alert_code
    : `SMOKE_SYNTHETIC_${Date.now()}`

  if (!hasQueueAlert) {
    pass('Synthetic lifecycle mode', `alert=${alertCode}`)
  }

  const updates = [
    ['ack', { alert_code: alertCode, status: 'ack', note: 'smoke ack' }],
    ['in_progress', { alert_code: alertCode, status: 'in_progress', note: 'smoke in progress' }],
    ['resolved', { alert_code: alertCode, status: 'resolved', note: 'smoke resolved' }],
  ]

  for (const [targetStatus, payload] of updates) {
    const res = await postJson(`${fnBase}/admin_update_exception_alert`, authHeaders, payload)
    const ok = res.ok && res.data?.success === true && res.data?.data?.status === targetStatus
    if (ok) pass(`Update status ${targetStatus}`, `code=${alertCode}`)
    else {
      fail(`Update status ${targetStatus}`, `status=${res.status}`)
      failures += 1
    }
  }

  const bulkRes = await postJson(`${fnBase}/admin_bulk_update_exception_alerts`, authHeaders, {
    alert_codes: [alertCode],
    status: 'open',
    note: 'smoke reopen',
  })
  if (bulkRes.ok && bulkRes.data?.success === true && Array.isArray(bulkRes.data?.data)) {
    pass('Bulk reopen', `updated=${bulkRes.data.data.length}`)
  } else {
    fail('Bulk reopen', `status=${bulkRes.status}`)
    failures += 1
  }

  console.log(`\nSummary: ${failures === 0 ? 'ALL PASS' : `${failures} failure(s)`}`)
  if (failures > 0) process.exit(1)
}

main().catch((error) => {
  console.error('Ops lifecycle smoke error:', error)
  process.exit(1)
})
