#!/usr/bin/env node

import { spawnSync } from 'node:child_process'

const tests = [
  {
    label: 'Typecheck (tsc -b)',
    cmd: 'pnpm',
    args: ['--dir', 'apps/web', 'exec', 'tsc', '-b', '--pretty', 'false'],
  },
  {
    label: 'Build (vite)',
    cmd: 'pnpm',
    args: ['--dir', 'apps/web', 'exec', 'vite', 'build'],
  },
  {
    label: 'SP1 smoke',
    cmd: 'node',
    args: ['docs/verification/sprint1_admin_operations_smoke.mjs'],
  },
  {
    label: 'SP2 smoke',
    cmd: 'node',
    args: ['docs/verification/sprint2_financial_governance_smoke.mjs'],
  },
  {
    label: 'SP3 lifecycle smoke',
    cmd: 'node',
    args: ['docs/verification/sprint3_ops_lifecycle_smoke.mjs'],
  },
  {
    label: 'SP3 ops regression',
    cmd: 'node',
    args: ['docs/verification/sprint3_admin_ops_smoke.mjs'],
  },
  {
    label: 'SP3 financial regression',
    cmd: 'node',
    args: ['docs/verification/sprint3_financial_visibility_smoke.mjs'],
  },
  {
    label: 'SP4 governance smoke',
    cmd: 'node',
    args: ['docs/verification/sprint4_rbac_governance_smoke.mjs'],
  },
  {
    label: 'SP5 marketing smoke',
    cmd: 'node',
    args: ['docs/verification/sprint5_marketing_governance_smoke.mjs'],
  },
]

const requiredEnv = ['RC_SUPABASE_ANON_KEY', 'RC_ADMIN_EMAIL', 'RC_ADMIN_PASSWORD']
const missingEnv = requiredEnv.filter((name) => !process.env[name])
if (missingEnv.length) {
  console.error(`Missing required env vars: ${missingEnv.join(', ')}`)
  process.exit(2)
}

function runTest(test) {
  console.log(`\n=== ${test.label} ===`)
  const result = spawnSync(test.cmd, test.args, {
    shell: true,
    encoding: 'utf-8',
    stdio: 'pipe',
    env: process.env,
  })

  const output = `${result.stdout || ''}${result.stderr || ''}`.trim()
  if (output) {
    console.log(output)
  }

  const ok = result.status === 0
  console.log(`RESULT: ${ok ? 'PASS' : 'FAIL'} (${test.label})`)
  return { ...test, ok, status: result.status ?? 1 }
}

const results = tests.map(runTest)
const failed = results.filter((item) => !item.ok)

console.log('\n=== S6 MATRIX SUMMARY ===')
for (const item of results) {
  console.log(`${item.ok ? 'PASS' : 'FAIL'} - ${item.label}`)
}

if (failed.length) {
  console.log(`\nSummary: ${failed.length} failure(s)`)
  process.exit(1)
}

console.log('\nSummary: ALL PASS')
