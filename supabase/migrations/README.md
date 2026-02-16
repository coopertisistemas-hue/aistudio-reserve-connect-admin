# RESERVE CONNECT - DATABASE MIGRATION GUIDE

## Overview

This directory contains all SQL migrations to set up the Reserve Connect database schema from scratch. The schema implements a complete booking platform with:

- Multi-tenancy by city
- Property and unit management
- Booking intent workflow with TTL
- Payment processing (Stripe + PIX)
- Double-entry accounting ledger
- Owner payouts
- Reviews and ratings
- Analytics and events
- Advertising system
- Future-ready tables (owner portal, services marketplace)

## Migration Files

| File | Description | Tables Created |
|------|-------------|----------------|
| `001_foundation_schema.sql` | Cities, properties, units, availability | 6 tables + 7 enums |
| `002_booking_core.sql` | Travelers, booking intents, reservations | 3 tables |
| `003_financial_module.sql` | Payments, ledger, payouts | 6 tables |
| `004_operations_audit.sql` | Audit logs, notifications, sync | 4 tables |
| `005_analytics_marketing.sql` | Events, reviews, ads | 7 tables |
| `006_future_placeholders.sql` | Owner portal, AP/AR, services | 9 tables |
| `007_qa_verification.sql` | Comprehensive QA tests | - |

**Total: 35+ tables, 7 enums, 50+ indexes, 40+ RLS policies**

## Quick Start

### Option 1: Apply via Supabase Dashboard (Recommended for production)

1. Go to Supabase Dashboard → SQL Editor
2. Create a new query
3. Copy and paste the content of each migration file in order (001 → 007)
4. Run each migration separately
5. Check the output for any errors

### Option 2: Apply via psql CLI

```bash
# Set environment variables
export SUPABASE_URL="your-project-url"
export SUPABASE_SERVICE_KEY="your-service-role-key"

# Connect and run migrations
psql "${SUPABASE_URL}/postgres" \
  --username postgres \
  --file 001_foundation_schema.sql

psql "${SUPABASE_URL}/postgres" \
  --username postgres \
  --file 002_booking_core.sql

# ... repeat for all migrations

# Run QA verification
psql "${SUPABASE_URL}/postgres" \
  --username postgres \
  --file 007_qa_verification.sql
```

### Option 3: Apply via Supabase CLI

```bash
# Install Supabase CLI if not already installed
npm install -g supabase

# Link to your project
supabase link --project-ref your-project-ref

# Apply migrations
supabase db push
```

## Migration Order

**MUST BE APPLIED IN SEQUENCE:**

1. ✅ `001_foundation_schema.sql` - Creates cities, properties, units
2. ✅ `002_booking_core.sql` - Creates travelers, intents, reservations
3. ✅ `003_financial_module.sql` - Creates payments, ledger, payouts
4. ✅ `004_operations_audit.sql` - Creates audit logs, notifications
5. ✅ `005_analytics_marketing.sql` - Creates events, reviews, ads
6. ✅ `006_future_placeholders.sql` - Creates owner portal, services
7. ✅ `007_qa_verification.sql` - Runs comprehensive QA tests

## Key Features

### 1. Multi-Tenancy
- All tables include `city_code` for isolation
- RLS policies enforce city-level access control
- Portal site slug mapping via `city_site_mappings`

### 2. State Machines
- **Booking Intent**: intent_created → payment_pending → payment_confirmed → converted | expired | cancelled
- **Reservation**: host_commit_pending → confirmed → checkin_pending → checked_in → checked_out → completed
- **Payment**: pending → processing → succeeded | failed | refunded

### 3. Financial System
- Double-entry ledger (debits = credits)
- Commission calculation (default 15%)
- Weekly payout batches
- IOF 0.38% handling for PIX
- Stripe fee tracking

### 4. Soft Holds
- TTL-based inventory holds during booking flow
- Automatic release on expiry
- Prevents double-booking

### 5. Audit Trail
- All mutations logged to `audit_logs`
- Before/after state tracking
- Actor identification

### 6. Notifications
- Email/WhatsApp/SMS queue
- Template-based system
- Retry logic with exponential backoff

## Seed Data

Each migration includes test data:

- **City**: Urubici (URB)
- **Property**: Pousada Teste Urubici
- **Unit**: Quarto Standard
- **Traveler**: test@example.com
- **Reservation**: RES-2026-TEST01
- **Payment**: Stripe test payment
- **Ledger**: Balanced entries
- **Review**: 5-star test review
- **Events**: Test funnel events
- **KPI**: Sample daily snapshot

## QA Verification

Run `007_qa_verification.sql` to verify:

✅ All 35+ tables exist
✅ All indexes created
✅ All RLS policies applied
✅ Foreign keys valid
✅ Seed data present
✅ Functions working
✅ Triggers active
✅ Ledger balanced

## Post-Deployment Checklist

After running all migrations:

- [ ] No errors in migration output
- [ ] All tables visible in Supabase Table Editor
- [ ] RLS policies visible in Auth → Policies
- [ ] Seed data queryable
- [ ] QA verification passes all tests
- [ ] Edge Functions can connect to tables
- [ ] Test booking flow end-to-end

## Troubleshooting

### Migration fails with "relation already exists"

Migrations are idempotent (use `IF NOT EXISTS`), but if you need to reset:

```sql
-- WARNING: This deletes all data!
DROP SCHEMA reserve CASCADE;
CREATE SCHEMA reserve;
-- Re-run migrations
```

### RLS policies not working

Verify policies were created:

```sql
SELECT * FROM pg_policies WHERE schemaname = 'reserve';
```

### Missing indexes

Check indexes:

```sql
SELECT * FROM pg_indexes WHERE schemaname = 'reserve';
```

### Seed data missing

Re-run specific migration or insert manually:

```sql
-- Example: Insert test city
INSERT INTO reserve.cities (code, name, state_province)
VALUES ('URB', 'Urubici', 'SC')
ON CONFLICT (code) DO NOTHING;
```

## Security Notes

1. **Never use anon key for migrations** - Always use service_role key
2. **RLS is enabled** on all tables - policies are restrictive by default
3. **Audit logging** tracks all changes
4. **Bank details** should use Supabase Vault in production
5. **PII fields** are hashed or encrypted where noted

## Next Steps

After schema deployment:

1. Configure Supabase Auth
2. Set up Stripe webhook endpoint
3. Configure PIX provider credentials
4. Deploy Edge Functions
5. Configure Host Connect sync
6. Set up Portal Connect proxy
7. Test end-to-end booking flow
8. Configure monitoring and alerts

## Support

For issues or questions:
- Check QA verification output
- Review Supabase logs
- Verify migration order
- Test individual table queries
- Check RLS policy application

## Schema Version

**Version**: 1.0.0
**Date**: 2026-02-16
**Compatible with**: Supabase Postgres 15+
**Status**: Production-ready MVP

## Changelog

### v1.0.0 (2026-02-16)
- Initial schema creation
- 35+ tables for complete booking platform
- Stripe + PIX payment support
- Double-entry accounting
- Multi-tenancy by city
- State machines for bookings
- Future-ready Phase 3+ tables
