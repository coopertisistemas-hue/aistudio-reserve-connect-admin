# Sprint 3 Financial Visibility Smoke

This verification ensures seeded financial data is visible across all admin financial surfaces.

## Preconditions

- Migrations `031` to `036` applied.
- Seed migration `035_seed_financial_smoke_case.sql` applied.
- Admin endpoints deployed.

## Expected Seed IDs

- Payment: `7f9b9014-7307-45a7-8cf1-2b2c7777a241`
- Payout: `49dbf79f-4d4f-4706-bfcf-aaf8865c9b51`
- Ledger transaction: `e9228947-6954-4568-90a7-2d8d6c0a1111`

## Command

```bash
RC_SUPABASE_ANON_KEY=<anon_key> \
RC_ADMIN_EMAIL=<admin_email> \
RC_ADMIN_PASSWORD=<admin_password> \
node docs/verification/sprint3_financial_visibility_smoke.mjs
```

## Pass Criteria

- Payment is listed and detail endpoint returns success.
- Ledger list contains expected transaction.
- Ledger drill-down returns `imbalance = 0`.
- Payout is listed and payout detail endpoint returns success.

## Notes

- This is a lightweight visibility smoke for release readiness, not a full transactional E2E.
- Use this together with `docs/verification/sprint3_admin_ops_smoke.mjs`.
