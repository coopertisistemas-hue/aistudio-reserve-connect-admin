#!/usr/bin/env node

const project = process.env.RC_SUPABASE_PROJECT || 'ffahkiukektmhkrkordn'
const anonKey = process.env.RC_SUPABASE_ANON_KEY
const adminEmail = process.env.RC_ADMIN_EMAIL
const adminPassword = process.env.RC_ADMIN_PASSWORD

const expected = {
  paymentId: '7f9b9014-7307-45a7-8cf1-2b2c7777a241',
  payoutId: '49dbf79f-4d4f-4706-bfcf-aaf8865c9b51',
  transactionId: 'e9228947-6954-4568-90a7-2d8d6c0a1111',
}

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
  const data = await response.json()
  return { ok: response.ok, status: response.status, data }
}

function pass(label, details = '') {
  console.log(`PASS  ${label}${details ? ` - ${details}` : ''}`)
}

function fail(label, details = '') {
  console.log(`FAIL  ${label}${details ? ` - ${details}` : ''}`)
}

async function main() {
  let fails = 0

  const login = await postJson(authUrl, { apikey: anonKey }, { email: adminEmail, password: adminPassword })
  if (!login.ok || !login.data?.access_token) {
    fail('Admin login', `status=${login.status}`)
    process.exit(1)
  }
  pass('Admin login', `status=${login.status}`)

  const authHeaders = { apikey: anonKey, Authorization: `Bearer ${login.data.access_token}` }

  const payments = await postJson(`${fnBase}/admin_list_payments`, authHeaders, {})
  const paymentFound = payments.ok && Array.isArray(payments.data?.data) && payments.data.data.some((p) => p.id === expected.paymentId)
  if (paymentFound) pass('Payment visible in admin_list_payments')
  else {
    fail('Payment visible in admin_list_payments', `status=${payments.status}`)
    fails += 1
  }

  const paymentDetail = await postJson(`${fnBase}/admin_get_payment_detail`, authHeaders, { payment_id: expected.paymentId })
  const paymentDetailOk = paymentDetail.ok && paymentDetail.data?.success === true
  if (paymentDetailOk) pass('Payment detail retrievable')
  else {
    fail('Payment detail retrievable', `status=${paymentDetail.status}`)
    fails += 1
  }

  const ledger = await postJson(`${fnBase}/admin_list_ledger_entries`, authHeaders, {})
  const transactionFound = ledger.ok && Array.isArray(ledger.data?.data) && ledger.data.data.some((e) => e.transaction_id === expected.transactionId)
  if (transactionFound) pass('Ledger transaction visible in list')
  else {
    fail('Ledger transaction visible in list', `status=${ledger.status}`)
    fails += 1
  }

  const txDetail = await postJson(`${fnBase}/admin_get_ledger_transaction`, authHeaders, { transaction_id: expected.transactionId })
  const txBalanced = txDetail.ok && txDetail.data?.success === true && Number(txDetail.data?.data?.totals?.imbalance ?? 1) === 0
  if (txBalanced) pass('Ledger transaction drill-down balanced (imbalance=0)')
  else {
    fail('Ledger transaction drill-down balanced', `status=${txDetail.status}`)
    fails += 1
  }

  const payouts = await postJson(`${fnBase}/admin_list_payouts`, authHeaders, {})
  const payoutFound = payouts.ok && Array.isArray(payouts.data?.data) && payouts.data.data.some((p) => p.id === expected.payoutId)
  if (payoutFound) pass('Payout visible in admin_list_payouts')
  else {
    fail('Payout visible in admin_list_payouts', `status=${payouts.status}`)
    fails += 1
  }

  const payoutDetail = await postJson(`${fnBase}/admin_get_payout_detail`, authHeaders, { payout_id: expected.payoutId })
  const payoutDetailOk = payoutDetail.ok && payoutDetail.data?.success === true
  if (payoutDetailOk) pass('Payout detail retrievable')
  else {
    fail('Payout detail retrievable', `status=${payoutDetail.status}`)
    fails += 1
  }

  const msg = `Summary: ${fails === 0 ? 'ALL PASS' : `${fails} failure(s)`}`
  console.log(`\n${msg}`)
  if (fails > 0) process.exit(1)
}

main().catch((error) => {
  console.error('Visibility smoke error:', error)
  process.exit(1)
})
