# RESERVE CONNECT MVP PREPARATION
## Database Schema + Edge Functions Architecture

**Date:** 2026-02-15  
**Version:** MVP-1.0  
**Author:** Principal Architect + Supabase Specialist  
**Status:** Implementation-Ready

---

## 1) EXECUTIVE SUMMARY (10 Bullets)

1. **Current State**: Reserve Connect has foundational schema (cities, properties_map, unit_map, reservations, travelers, availability_calendar) but lacks MVP-critical tables: booking_intents, payments, ledger, payouts, ads, reviews, notification_outbox.

2. **Payment Architecture**: Stripe + PIX mandatory for MVP. PIX requires provider abstraction layer with QR generation, webhook/polling hybrid, and IOF tax (0.38%) handling in ledger.

3. **Merchant of Record Model**: Reserve collects all funds → keeps commission (default 15%) → repasses net amount to owners weekly (or per-property override). Double-entry ledger tracks every transaction.

4. **Host Connect Integration**: Check-in/out lifecycle is HOST EXCLUSIVE. Reserve only receives webhooks. All operational bookings sync bidirectionally.

5. **Multi-Tenancy**: RLS enforced via `city_code` on all city-scoped tables. Owner access (Sprint 9-10) will be read-only via `property_owners` junction table.

6. **Portal Integration**: Content (events, restaurants, attractions) fetched via Reserve Edge Functions proxying to Portal (BFF pattern). No Portal tables duplicated in Reserve.

7. **State Machine**: booking_intent (6 states, TTL-based) → reservation (12+ states including failure states: host_commit_failed, refund_pending, cancel_pending). Payment-first model enforced.

8. **Edge Functions**: 24 functions across 6 domains. All app access via BFF pattern—no direct client queries. Idempotency keys required for all payment/host_commit paths.

9. **Future-Ready**: Schema placeholders created for AP/AR (vendor_payables, receivables) and Services Marketplace (service_catalog, service_orders) but business logic deferred to Phase 3+.

10. **Blockers Before Sprint 1**: (1) Create missing MVP tables, (2) Implement RLS policies, (3) Add missing indexes, (4) Deploy sync infrastructure, (5) Create Edge Function stubs.

---

## 2) DELIVERABLE 1 — RESERVE CONNECT "GAP TO MVP" REPORT

### 2.1 What Reserve Connect Schema Currently Has

**Existing Core Tables:**
```sql
-- Geographic & Mapping
cities                    -- City master data (code, name, timezone)
properties_map            -- Synced from Host (host_property_id FK, slug, cached data)
unit_map                  -- Synced from Host (host_unit_id FK, room types)

-- Availability & Pricing
availability_calendar     -- 365-day cache per unit/rate plan
rate_plans                -- Distribution pricing rules

-- Reservations & Travelers (Basic)
reservations              -- Booking records (status, payment_status, amounts)
travelers                 -- Guest profiles (auth_user_id nullable for guest checkout)

-- Operations & Sync
sync_jobs                 -- Host sync orchestration
sync_logs                 -- Detailed sync logs
audit_logs                -- Change tracking

-- Analytics
funnel_events             -- User behavior tracking
kpi_daily_snapshots       -- Aggregated metrics
events                    -- Internal event bus
search_config             -- Search tuning parameters
```

**Existing Enums:**
- `reservation_status`: pending, confirmed, checked_in, checked_out, cancelled, no_show
- `payment_status`: pending, partial, paid, refunded, failed
- `reservation_source`: direct, booking_com, airbnb, expedia, other_ota

**Existing Indexes:**
- Primary keys on all tables
- Foreign key indexes (city_id, property_id, unit_id)
- Active/published composite indexes
- GiST index on properties_map for geo queries

### 2.2 What Is Missing for MVP

**Critical Missing Tables (Must Have):**

| Table | Purpose | Sprint |
|-------|---------|--------|
| `booking_intents` | TTL-based pre-reservation state machine | 2 |
| `payments` | Payment records (Stripe + PIX) | 3 |
| `payment_attempts` | Failed/retry payment tracking | 3 |
| `pix_charges` | PIX-specific charge data (QR, txid) | 3 |
| `ledger_entries` | Double-entry financial records | 2 |
| `payout_schedules` | Owner payout frequency rules | 4 |
| `payout_batches` | Weekly batch grouping | 4 |
| `payouts` | Individual payout records | 4 |
| `commission_tiers` | Commission rate rules | 2 |
| `notification_outbox` | Email/WhatsApp queue | 4 |
| `notification_templates` | Message templates | 4 |
| `reviews` | Guest reviews + ratings | 5 |
| `review_invitations` | Post-stay review requests | 5 |
| `ads_slots` | ADS placement definitions | 6 |
| `ads_campaigns` | ADS campaigns | 6 |
| `ads_impressions` | ADS view tracking | 6 |
| `ads_clicks` | ADS click tracking | 6 |
| `host_webhook_events` | Host webhook replay log | 2 |
| `city_site_mappings` | Reserve city ↔ Portal site alignment | 1 |
| `cancellation_policies` | Policy rules per property | 2 |
| `refunds` | Refund records and tracking | 5 |

**Schema Placeholders Only (Future Phase 3+):**

| Table | Purpose | When |
|-------|---------|------|
| `vendor_payables` | AP - obligations to service providers | Phase 3 |
| `receivables` | AR - amounts owed to Reserve | Phase 3 |
| `invoices` | NF-e integration | Phase 3 |
| `service_providers` | Marketplace vendor directory | Phase 3 |
| `service_catalog` | Available services | Phase 3 |
| `service_orders` | Guest service requests | Phase 3 |
| `service_payouts` | Provider payment tracking | Phase 3 |
| `property_owners` | Owner-property mappings | Sprint 9 |

### 2.3 Naming/Key Conflicts Across Systems

| Concept | Host | Reserve | Portal | Canonical Strategy |
|---------|------|---------|--------|-------------------|
| **Property** | `properties` | `properties_map` | `places.kind='lodging'` | Host ID = canonical; Reserve slug = URL key |
| **Room Type** | `room_types` | `unit_map` | N/A | Host room_types.id = canonical FK in Reserve |
| **Guest/Traveler** | `guests` | `travelers` | N/A | Reserve traveler syncs → Host guest on booking |
| **Booking** | `bookings` | `reservations` | N/A | Reserve reservation syncs → Host booking |
| **City** | N/A | `cities` | `sites` | Reserve `city.code` ↔ Portal `site.slug` via mapping table |
| **Organization** | `organizations` | N/A | N/A | Host-only concept |

**Conflict Resolutions:**
1. **Property/Place**: Portal places for lodging should reference Reserve properties_map via `external_id` if needed. Reserve is distribution layer, Portal is content layer.
2. **Room Types vs Units**: Public API uses "room types", internal Reserve uses `unit_map` (mirrors Host `room_types`).
3. **Guests vs Travelers**: "Traveler" for booking context (Reserve), "Guest" for operational context (Host).

### 2.4 Recommended Canonical Key Strategy

```typescript
// City Identification
interface CityKey {
  code: string;        // e.g., 'URB', 'SAO', 'RIO' - used in URLs and APIs
  id: uuid;            // Internal UUID - used in FKs
}

// Property Identification
interface PropertyKey {
  slug: string;        // URL-safe: 'pousada-montanha-urubici'
  id: uuid;            // Reserve local UUID
  host_property_id: uuid;  // Host Connect canonical UUID
}

// Reservation Identification
interface ReservationKey {
  confirmation_code: string;  // 'RES-2026-ABC123' - customer-facing
  id: uuid;                   // Internal UUID
  host_booking_id: uuid;      // Host Connect booking ID (after sync)
}

// Cross-System Mapping
interface CitySiteMapping {
  city_id: uuid;       // Reserve cities.id
  site_id: uuid;       // Portal sites.id
  city_code: string;   // 'URB'
  site_slug: string;   // 'urubici'
}
```

### 2.5 Blockers Before Edge Functions Implementation

**BLOCKER 1: Missing Core Tables**
- booking_intents, payments, ledger_entries, payout_batches
- **Impact**: Cannot implement booking flow
- **Resolution**: Run migration scripts (Deliverable 2)

**BLOCKER 2: No RLS Policies on New Tables**
- All new tables need city_code-based RLS
- **Impact**: Security vulnerability, cross-city data leakage
- **Resolution**: Include RLS in migration scripts

**BLOCKER 3: Missing Indexes**
- Payment queries, ledger queries, availability search need indexes
- **Impact**: Performance degradation at scale
- **Resolution**: Add indexes in migration

**BLOCKER 4: Sync Infrastructure Not Deployed**
- Host → Reserve sync jobs not configured
- **Impact**: No real property/availability data
- **Resolution**: Deploy sync Edge Functions, configure scheduler

**BLOCKER 5: City-Site Mapping Undefined**
- No mapping between Reserve cities and Portal sites
- **Impact**: Cannot fetch Portal content (events, restaurants)
- **Resolution**: Populate city_site_mappings table

**BLOCKER 6: Payment Provider Credentials**
- Stripe keys, PIX provider credentials not configured
- **Impact**: Cannot process payments
- **Resolution**: Add to Supabase secrets/env vars

---

## 3) DELIVERABLE 2 — MIGRATION PLAN + SQL

### 3.1 Migration File Organization

```
supabase/migrations/
├── 20260215000001_mvp_core_tables.sql          -- Booking, payment, ledger
├── 20260215000002_mvp_financial_tables.sql     -- Payouts, commissions
├── 20260215000003_mvp_ads_tables.sql           -- ADS MVP
├── 20260215000004_mvp_supporting_tables.sql    -- Reviews, notifications
├── 20260215000005_mvp_sync_integration.sql     -- Host sync, webhooks
├── 20260215000006_mvp_rls_policies.sql         -- Security policies
├── 20260215000007_mvp_indexes.sql              -- Performance indexes
└── 20260215000008_future_placeholders.sql      -- Phase 3+ schemas only
```

### 3.2 MVP Core Tables SQL

```sql
-- ============================================
-- MIGRATION: 20260215000001_mvp_core_tables.sql
-- Booking Intents, Payments, Ledger
-- ============================================

-- 1. BOOKING INTENTS (TTL-based pre-reservation)
CREATE TYPE booking_intent_status AS ENUM (
  'intent_created',
  'payment_pending', 
  'payment_confirmed',
  'converted',
  'expired',
  'cancelled'
);

CREATE TABLE booking_intents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id VARCHAR(100) NOT NULL,
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  property_id UUID NOT NULL REFERENCES properties_map(id),
  unit_id UUID NOT NULL REFERENCES unit_map(id),
  rate_plan_id UUID REFERENCES rate_plans(id),
  
  -- Dates & Guests
  check_in DATE NOT NULL,
  check_out DATE NOT NULL,
  nights INTEGER NOT NULL,
  guests_adults INTEGER NOT NULL DEFAULT 1,
  guests_children INTEGER NOT NULL DEFAULT 0,
  guests_infants INTEGER NOT NULL DEFAULT 0,
  
  -- Pricing (snapshot at creation)
  base_price DECIMAL(12,2) NOT NULL,
  taxes DECIMAL(12,2) NOT NULL DEFAULT 0,
  fees DECIMAL(12,2) NOT NULL DEFAULT 0,
  discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  total_amount DECIMAL(12,2) NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'BRL',
  
  -- State Machine
  status booking_intent_status NOT NULL DEFAULT 'intent_created',
  status_changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  -- TTL Tracking
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at TIMESTAMPTZ NOT NULL, -- 15 min default
  
  -- Soft Hold Reference
  hold_token VARCHAR(100), -- For inventory soft hold
  
  -- Conversion (if successful)
  reservation_id UUID REFERENCES reservations(id),
  converted_at TIMESTAMPTZ,
  
  -- Metadata
  source VARCHAR(50) DEFAULT 'direct',
  utm_source VARCHAR(100),
  utm_medium VARCHAR(100),
  utm_campaign VARCHAR(200),
  user_agent TEXT,
  ip_hash VARCHAR(64),
  metadata JSONB NOT NULL DEFAULT '{}'
);

CREATE INDEX idx_booking_intents_session ON booking_intents(session_id);
CREATE INDEX idx_booking_intents_status ON booking_intents(status, expires_at);
CREATE INDEX idx_booking_intents_property ON booking_intents(property_id, created_at DESC);
CREATE INDEX idx_booking_intents_conversion ON booking_intents(reservation_id) WHERE reservation_id IS NOT NULL;

COMMENT ON TABLE booking_intents IS 'TTL-based pre-reservation state machine. Expires after 15min if not converted.';

-- 2. PAYMENTS (Stripe + PIX unified)
CREATE TYPE payment_method AS ENUM ('stripe_card', 'stripe_pix', 'mercadopago_pix', 'openpix');
CREATE TYPE payment_status AS ENUM ('pending', 'processing', 'succeeded', 'failed', 'cancelled', 'expired', 'refund_pending', 'refunded', 'partially_refunded', 'disputed');

CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  -- Link to reservation or intent
  booking_intent_id UUID REFERENCES booking_intents(id),
  reservation_id UUID REFERENCES reservations(id),
  
  -- Payment Details
  method payment_method NOT NULL,
  status payment_status NOT NULL DEFAULT 'pending',
  amount DECIMAL(12,2) NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'BRL',
  
  -- Gateway References
  gateway_payment_intent_id VARCHAR(255), -- Stripe pi_xxx or PIX txid
  gateway_charge_id VARCHAR(255), -- Stripe ch_xxx
  gateway_refund_id VARCHAR(255), -- Stripe re_xxx
  
  -- Gateway Response (for debugging)
  gateway_response JSONB,
  failure_code VARCHAR(100),
  failure_message TEXT,
  
  -- Idempotency
  idempotency_key VARCHAR(255) UNIQUE,
  
  -- Timing
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  processed_at TIMESTAMPTZ,
  refunded_at TIMESTAMPTZ,
  
  -- Metadata
  metadata JSONB NOT NULL DEFAULT '{}'
);

CREATE INDEX idx_payments_intent ON payments(booking_intent_id);
CREATE INDEX idx_payments_reservation ON payments(reservation_id);
CREATE INDEX idx_payments_gateway ON payments(gateway_payment_intent_id);
CREATE INDEX idx_payments_status ON payments(status, created_at);
CREATE INDEX idx_payments_idempotency ON payments(idempotency_key);

-- 3. PIX CHARGES (PIX-specific data)
CREATE TYPE pix_status AS ENUM ('pending', 'paid', 'expired', 'cancelled');

CREATE TABLE pix_charges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  payment_id UUID NOT NULL REFERENCES payments(id) ON DELETE CASCADE,
  city_code VARCHAR(10) NOT NULL,
  
  -- PIX Specific
  provider VARCHAR(50) NOT NULL, -- 'stripe', 'mercadopago', 'openpix'
  provider_charge_id VARCHAR(255) NOT NULL,
  txid VARCHAR(255), -- PIX transaction ID
  
  -- QR Code Data
  qr_code_base64 TEXT, -- Base64 encoded QR image
  qr_code_text TEXT, -- Copy-paste PIX code
  
  -- Amounts
  original_amount DECIMAL(12,2) NOT NULL,
  iof_amount DECIMAL(12,2) NOT NULL DEFAULT 0, -- 0.38% IOF for Brazil
  net_amount DECIMAL(12,2) NOT NULL,
  
  -- Status
  status pix_status NOT NULL DEFAULT 'pending',
  
  -- Expiration
  expires_at TIMESTAMPTZ NOT NULL,
  paid_at TIMESTAMPTZ,
  
  -- Payer Info (when paid)
  payer_name VARCHAR(255),
  payer_document VARCHAR(100),
  payer_bank_name VARCHAR(100),
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  metadata JSONB NOT NULL DEFAULT '{}'
);

CREATE INDEX idx_pix_charges_payment ON pix_charges(payment_id);
CREATE INDEX idx_pix_charges_provider ON pix_charges(provider, provider_charge_id);
CREATE INDEX idx_pix_charges_status ON pix_charges(status, expires_at);

-- 4. LEDGER ENTRIES (Double-entry bookkeeping)
CREATE TYPE ledger_entry_type AS ENUM (
  'payment_received',
  'gateway_fee',
  'iof_tax',
  'commission_taken',
  'commission_revenue',
  'payout_due',
  'payout_executed',
  'refund_processed',
  'refund_reversal',
  'adjustment'
);

CREATE TYPE ledger_account AS ENUM (
  -- Assets
  'cash_reserve',
  'merchant_account',
  'payouts_receivable',
  'gateway_fees_receivable',
  -- Liabilities
  'customer_deposits',
  'refunds_payable',
  'commissions_payable',
  -- Revenue
  'commission_revenue',
  'gateway_fee_expense',
  'iof_expense'
);

CREATE TYPE ledger_direction AS ENUM ('debit', 'credit');

CREATE TABLE ledger_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  transaction_id UUID NOT NULL, -- Groups related entries
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  -- Entity References (polymorphic)
  entity_type VARCHAR(50) NOT NULL DEFAULT 'booking', -- 'booking', 'service_order', etc.
  booking_id UUID REFERENCES reservations(id),
  property_id UUID REFERENCES properties_map(id),
  payment_id UUID REFERENCES payments(id),
  
  -- Entry Details
  entry_type ledger_entry_type NOT NULL,
  account ledger_account NOT NULL,
  direction ledger_direction NOT NULL,
  amount DECIMAL(12,2) NOT NULL CHECK (amount >= 0),
  currency VARCHAR(3) NOT NULL DEFAULT 'BRL',
  
  -- Counterparty
  counterparty_type VARCHAR(50), -- 'customer', 'owner', 'gateway', 'tax_authority'
  counterparty_id VARCHAR(255),
  
  -- Description
  description TEXT,
  metadata JSONB NOT NULL DEFAULT '{}',
  
  -- Audit
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

-- Constraint: Every transaction_id must sum to zero (debits = credits)
-- Enforced at application level or via trigger

CREATE INDEX idx_ledger_transaction ON ledger_entries(transaction_id);
CREATE INDEX idx_ledger_booking ON ledger_entries(booking_id);
CREATE INDEX idx_ledger_property ON ledger_entries(property_id);
CREATE INDEX idx_ledger_payment ON ledger_entries(payment_id);
CREATE INDEX idx_ledger_entry_type ON ledger_entries(entry_type, created_at);
CREATE INDEX idx_ledger_city_created ON ledger_entries(city_code, created_at DESC);

-- ============================================
-- MIGRATION: 20260215000002_mvp_financial_tables.sql
-- Payouts, Commissions, Refunds
-- ============================================

-- 1. COMMISSION TIERS
CREATE TABLE commission_tiers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  -- Scope (property override takes precedence)
  property_id UUID REFERENCES properties_map(id), -- NULL = default tier
  owner_id UUID, -- For volume-based tiers
  
  -- Volume Discount Rules
  min_properties INTEGER, -- NULL = no min
  max_properties INTEGER, -- NULL = no max
  
  -- Rate
  commission_rate DECIMAL(5,4) NOT NULL CHECK (commission_rate >= 0 AND commission_rate <= 1),
  
  -- Validity
  effective_from DATE NOT NULL DEFAULT CURRENT_DATE,
  effective_to DATE,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(city_code, property_id, effective_from)
);

CREATE INDEX idx_commission_tiers_city ON commission_tiers(city_code, is_active);
CREATE INDEX idx_commission_tiers_property ON commission_tiers(property_id) WHERE property_id IS NOT NULL;

-- Seed default commission tier (15%)
INSERT INTO commission_tiers (city_code, commission_rate, effective_from)
SELECT code, 0.15, CURRENT_DATE FROM cities WHERE is_active = TRUE;

-- 2. PAYOUT SCHEDULES
CREATE TYPE payout_frequency AS ENUM ('weekly', 'biweekly', 'monthly', 'on_checkout');

CREATE TABLE payout_schedules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  -- Entity (owner or property)
  entity_type VARCHAR(50) NOT NULL CHECK (entity_type IN ('owner', 'property')),
  entity_id UUID NOT NULL, -- References owner or property
  
  -- Schedule
  frequency payout_frequency NOT NULL DEFAULT 'weekly',
  day_of_week INTEGER CHECK (day_of_week >= 0 AND day_of_week <= 6), -- 0=Sunday
  day_of_month INTEGER CHECK (day_of_month >= 1 AND day_of_month <= 31),
  
  -- Thresholds
  min_threshold DECIMAL(12,2) DEFAULT 0, -- Minimum amount to trigger payout
  hold_days INTEGER DEFAULT 0, -- Additional hold period after checkout
  
  -- Bank Details (encrypted or reference)
  bank_details_encrypted TEXT, -- Vault-encrypted JSON
  
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(city_code, entity_type, entity_id)
);

-- 3. PAYOUT BATCHES (Weekly aggregation)
CREATE TYPE payout_batch_status AS ENUM ('draft', 'processing', 'completed', 'failed');

CREATE TABLE payout_batches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  batch_number VARCHAR(50) NOT NULL UNIQUE, -- 'PB-2026-001'
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  
  status payout_batch_status NOT NULL DEFAULT 'draft',
  
  -- Totals
  total_payouts INTEGER NOT NULL DEFAULT 0,
  total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  
  -- Processing
  processed_at TIMESTAMPTZ,
  processed_by UUID REFERENCES auth.users(id),
  gateway_batch_id VARCHAR(255), -- Stripe Connect batch ID
  
  -- Errors
  error_message TEXT,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_payout_batches_city ON payout_batches(city_code, status);
CREATE INDEX idx_payout_batches_period ON payout_batches(period_start, period_end);

-- 4. PAYOUTS (Individual payments to owners)
CREATE TYPE payout_status AS ENUM ('pending', 'scheduled', 'processing', 'completed', 'failed', 'cancelled');
CREATE TYPE payout_type AS ENUM ('owner', 'service_provider'); -- Future: service_provider

CREATE TABLE payouts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  -- References
  payout_batch_id UUID REFERENCES payout_batches(id),
  property_id UUID REFERENCES properties_map(id),
  reservation_id UUID REFERENCES reservations(id),
  
  -- Recipient
  recipient_type payout_type NOT NULL DEFAULT 'owner',
  recipient_id UUID NOT NULL, -- owner_id or provider_id
  recipient_name VARCHAR(255) NOT NULL,
  
  -- Amounts
  gross_amount DECIMAL(12,2) NOT NULL, -- Before commission
  commission_amount DECIMAL(12,2) NOT NULL,
  net_amount DECIMAL(12,2) NOT NULL, -- What owner receives
  currency VARCHAR(3) NOT NULL DEFAULT 'BRL',
  
  -- Status
  status payout_status NOT NULL DEFAULT 'pending',
  
  -- Gateway
  gateway_transfer_id VARCHAR(255),
  
  -- Timing
  scheduled_for DATE NOT NULL,
  processed_at TIMESTAMPTZ,
  
  -- Ledger Link
  ledger_entry_id UUID REFERENCES ledger_entries(id),
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  metadata JSONB NOT NULL DEFAULT '{}'
);

CREATE INDEX idx_payouts_batch ON payouts(payout_batch_id);
CREATE INDEX idx_payouts_property ON payouts(property_id);
CREATE INDEX idx_payouts_reservation ON payouts(reservation_id);
CREATE INDEX idx_payouts_recipient ON payouts(recipient_type, recipient_id);
CREATE INDEX idx_payouts_status ON payouts(status, scheduled_for);
CREATE INDEX idx_payouts_ledger ON payouts(ledger_entry_id);

-- 5. REFUNDS
CREATE TYPE refund_reason AS ENUM (
  'customer_request',
  'host_commit_failed',
  'cancellation_policy',
  'no_show',
  'dispute_lost',
  'fraud',
  'admin_override'
);

CREATE TABLE refunds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  -- References
  payment_id UUID NOT NULL REFERENCES payments(id),
  reservation_id UUID REFERENCES reservations(id),
  processed_by UUID REFERENCES auth.users(id),
  
  -- Amounts
  amount DECIMAL(12,2) NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'BRL',
  reason refund_reason NOT NULL,
  reason_details TEXT,
  
  -- Gateway
  gateway_refund_id VARCHAR(255),
  
  -- Status
  status VARCHAR(50) NOT NULL DEFAULT 'pending', -- pending, completed, failed
  
  -- Timing
  requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  processed_at TIMESTAMPTZ,
  
  -- Ledger
  ledger_entry_id UUID REFERENCES ledger_entries(id),
  
  metadata JSONB NOT NULL DEFAULT '{}'
);

CREATE INDEX idx_refunds_payment ON refunds(payment_id);
CREATE INDEX idx_refunds_reservation ON refunds(reservation_id);
CREATE INDEX idx_refunds_status ON refunds(status, requested_at);

-- ============================================
-- MIGRATION: 20260215000003_mvp_ads_tables.sql
-- ADS MVP (Slots + Tracking Only)
-- ============================================

-- 1. ADS SLOTS (Placement definitions)
CREATE TABLE ads_slots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  slot_code VARCHAR(100) NOT NULL, -- 'homepage_hero', 'search_sidebar'
  slot_name VARCHAR(255) NOT NULL,
  description TEXT,
  
  -- Placement Rules
  page_type VARCHAR(100) NOT NULL, -- 'home', 'search', 'property_detail'
  position VARCHAR(100) NOT NULL, -- 'top', 'sidebar', 'inline'
  
  -- Dimensions
  width_pixels INTEGER,
  height_pixels INTEGER,
  
  -- Targeting
  allowed_formats TEXT[], -- ['image', 'carousel']
  max_advertisers INTEGER DEFAULT 1,
  
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_ads_slots_code_city ON ads_slots(city_code, slot_code);

-- Seed default slots
INSERT INTO ads_slots (city_code, slot_code, slot_name, page_type, position) 
SELECT code, 'homepage_hero', 'Homepage Hero Banner', 'home', 'top' FROM cities WHERE is_active = TRUE;

-- 2. ADS CAMPAIGNS
CREATE TYPE campaign_status AS ENUM ('draft', 'active', 'paused', 'completed');
CREATE TYPE campaign_objective AS ENUM ('impressions', 'clicks', 'conversions');

CREATE TABLE ads_campaigns (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  -- Campaign Info
  name VARCHAR(255) NOT NULL,
  advertiser_id UUID NOT NULL, -- property owner or external
  advertiser_type VARCHAR(50) NOT NULL DEFAULT 'property', -- 'property', 'external'
  
  -- Targeting
  slot_id UUID NOT NULL REFERENCES ads_slots(id),
  target_property_ids UUID[], -- NULL = all properties
  
  -- Content
  title VARCHAR(255),
  description TEXT,
  image_url TEXT,
  cta_text VARCHAR(100),
  cta_url TEXT,
  
  -- Schedule
  status campaign_status NOT NULL DEFAULT 'draft',
  starts_at TIMESTAMPTZ,
  ends_at TIMESTAMPTZ,
  
  -- Budget
  objective campaign_objective NOT NULL DEFAULT 'impressions',
  budget DECIMAL(12,2),
  budget_type VARCHAR(50) DEFAULT 'total', -- 'total', 'daily'
  cpc_bid DECIMAL(8,4), -- Cost per click bid
  
  -- Limits
  daily_impression_cap INTEGER,
  total_impression_cap INTEGER,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ads_campaigns_city ON ads_campaigns(city_code, status);
CREATE INDEX idx_ads_campaigns_slot ON ads_campaigns(slot_id, status);
CREATE INDEX idx_ads_campaigns_dates ON ads_campaigns(starts_at, ends_at) WHERE status = 'active';

-- 3. ADS IMPRESSIONS (View tracking)
CREATE TABLE ads_impressions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL,
  
  campaign_id UUID NOT NULL REFERENCES ads_campaigns(id),
  slot_id UUID NOT NULL REFERENCES ads_slots(id),
  
  -- Context
  page_path TEXT,
  property_id UUID REFERENCES properties_map(id),
  
  -- User (anonymous)
  session_id VARCHAR(100),
  visitor_id VARCHAR(100),
  ip_hash VARCHAR(64),
  user_agent TEXT,
  
  -- Cost (if CPC)
  cost DECIMAL(8,4),
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ads_impressions_campaign ON ads_impressions(campaign_id, created_at);
CREATE INDEX idx_ads_impressions_slot ON ads_impressions(slot_id, created_at);
CREATE INDEX idx_ads_impressions_session ON ads_impressions(session_id, created_at);

-- 4. ADS CLICKS (Click tracking)
CREATE TABLE ads_clicks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL,
  
  impression_id UUID REFERENCES ads_impressions(id),
  campaign_id UUID NOT NULL REFERENCES ads_campaigns(id),
  
  -- Context
  page_path TEXT,
  referrer TEXT,
  
  -- User
  session_id VARCHAR(100),
  visitor_id VARCHAR(100),
  ip_hash VARCHAR(64),
  
  -- Cost
  cost DECIMAL(8,4), -- Actual CPC charged
  
  -- Conversion (if any)
  converted BOOLEAN DEFAULT FALSE,
  conversion_value DECIMAL(12,2),
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ads_clicks_campaign ON ads_clicks(campaign_id, created_at);
CREATE INDEX idx_ads_clicks_session ON ads_clicks(session_id, created_at);
CREATE INDEX idx_ads_clicks_converted ON ads_clicks(campaign_id) WHERE converted = TRUE;

-- ============================================
-- MIGRATION: 20260215000004_mvp_supporting_tables.sql
-- Reviews, Notifications, Cancellation Policies
-- ============================================

-- 1. CANCELLATION POLICIES
CREATE TYPE cancellation_policy_type AS ENUM ('flexible', 'moderate', 'strict', 'non_refundable');

CREATE TABLE cancellation_policies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  -- Scope (property override or default)
  property_id UUID REFERENCES properties_map(id), -- NULL = city default
  
  policy_type cancellation_policy_type NOT NULL DEFAULT 'moderate',
  
  -- Rules
  free_cancellation_hours INTEGER, -- Hours before check-in for full refund
  refund_percentage_before INTEGER CHECK (refund_percentage_before BETWEEN 0 AND 100),
  refund_percentage_after INTEGER CHECK (refund_percentage_after BETWEEN 0 AND 100),
  
  -- No-show
  no_show_charge_percentage INTEGER CHECK (no_show_charge_percentage BETWEEN 0 AND 100),
  
  description TEXT,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Seed defaults per city
INSERT INTO cancellation_policies (city_code, policy_type, free_cancellation_hours, refund_percentage_before, refund_percentage_after)
SELECT code, 'moderate', 48, 100, 50 FROM cities WHERE is_active = TRUE;

-- 2. REVIEWS
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  -- References
  reservation_id UUID REFERENCES reservations(id) ON DELETE SET NULL,
  traveler_id UUID REFERENCES travelers(id) ON DELETE SET NULL,
  property_id UUID NOT NULL REFERENCES properties_map(id) ON DELETE CASCADE,
  
  -- Ratings
  overall_rating INTEGER NOT NULL CHECK (overall_rating BETWEEN 1 AND 5),
  cleanliness_rating INTEGER CHECK (cleanliness_rating BETWEEN 1 AND 5),
  service_rating INTEGER CHECK (service_rating BETWEEN 1 AND 5),
  location_rating INTEGER CHECK (location_rating BETWEEN 1 AND 5),
  value_rating INTEGER CHECK (value_rating BETWEEN 1 AND 5),
  
  -- Content
  title VARCHAR(200),
  content TEXT NOT NULL,
  
  -- Moderation
  is_verified BOOLEAN DEFAULT FALSE,
  is_published BOOLEAN DEFAULT FALSE,
  moderation_notes TEXT,
  moderated_by UUID REFERENCES auth.users(id),
  moderated_at TIMESTAMPTZ,
  
  -- Stay Details (denormalized)
  stay_date DATE,
  room_type VARCHAR(100),
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_reviews_property ON reviews(property_id, is_published, created_at DESC);
CREATE INDEX idx_reviews_traveler ON reviews(traveler_id);
CREATE INDEX idx_reviews_rating ON reviews(property_id, overall_rating) WHERE is_published = TRUE;
CREATE INDEX idx_reviews_moderation ON reviews(is_published, is_verified);

-- 3. REVIEW INVITATIONS
CREATE TABLE review_invitations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL,
  
  reservation_id UUID NOT NULL REFERENCES reservations(id),
  traveler_id UUID NOT NULL REFERENCES travelers(id),
  property_id UUID NOT NULL REFERENCES properties_map(id),
  
  -- Status
  sent_at TIMESTAMPTZ,
  opened_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  review_id UUID REFERENCES reviews(id),
  
  -- Reminders
  reminder_sent_at TIMESTAMPTZ,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_review_invitations_reservation ON review_invitations(reservation_id);
CREATE INDEX idx_review_invitations_status ON review_invitations(completed_at) WHERE completed_at IS NULL;

-- 4. NOTIFICATION TEMPLATES
CREATE TYPE notification_channel AS ENUM ('email', 'whatsapp', 'sms', 'push');

CREATE TABLE notification_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  template_code VARCHAR(100) NOT NULL, -- 'booking_confirmation', 'payment_receipt'
  channel notification_channel NOT NULL,
  
  -- Content
  subject_template VARCHAR(255), -- For email
  body_template TEXT NOT NULL,
  
  -- Config
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  locale VARCHAR(10) DEFAULT 'pt-BR',
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(city_code, template_code, channel, locale)
);

-- 5. NOTIFICATION OUTBOX (Queue)
CREATE TYPE notification_status AS ENUM ('pending', 'processing', 'sent', 'failed', 'cancelled');

CREATE TABLE notification_outbox (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL,
  
  -- Recipient
  recipient_type VARCHAR(50) NOT NULL, -- 'traveler', 'property', 'admin'
  recipient_id UUID,
  recipient_email VARCHAR(255),
  recipient_phone VARCHAR(50),
  
  -- Message
  template_id UUID REFERENCES notification_templates(id),
  channel notification_channel NOT NULL,
  subject TEXT,
  body TEXT,
  
  -- Context
  reservation_id UUID REFERENCES reservations(id),
  metadata JSONB DEFAULT '{}',
  
  -- Status
  status notification_status NOT NULL DEFAULT 'pending',
  attempt_count INTEGER DEFAULT 0,
  last_error TEXT,
  
  -- Timing
  scheduled_for TIMESTAMPTZ DEFAULT NOW(),
  sent_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_notification_outbox_status ON notification_outbox(status, scheduled_for);
CREATE INDEX idx_notification_outbox_reservation ON notification_outbox(reservation_id);

-- ============================================
-- MIGRATION: 20260215000005_mvp_sync_integration.sql
-- Host Sync, Webhooks, City-Site Mapping
-- ============================================

-- 1. CITY-SITE MAPPINGS (Reserve ↔ Portal alignment)
CREATE TABLE city_site_mappings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_id UUID NOT NULL REFERENCES cities(id),
  site_id UUID NOT NULL, -- Portal sites.id (no FK to avoid cross-DB issues)
  
  city_code VARCHAR(10) NOT NULL,
  site_slug TEXT NOT NULL,
  
  portal_base_url TEXT, -- e.g., 'https://portal.example.com'
  
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(city_id, site_id)
);

CREATE INDEX idx_city_site_mappings_city ON city_site_mappings(city_code) WHERE is_active = TRUE;
CREATE INDEX idx_city_site_mappings_site ON city_site_mappings(site_slug) WHERE is_active = TRUE;

-- 2. HOST WEBHOOK EVENTS (Replay log)
CREATE TABLE host_webhook_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL,
  
  -- Event Data
  event_type VARCHAR(100) NOT NULL, -- 'booking.created', 'booking.updated'
  host_booking_id VARCHAR(255),
  host_property_id VARCHAR(255),
  
  payload JSONB NOT NULL,
  
  -- Processing
  processed BOOLEAN DEFAULT FALSE,
  processed_at TIMESTAMPTZ,
  error_message TEXT,
  
  -- Signature
  signature VARCHAR(255),
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_host_webhook_events_type ON host_webhook_events(event_type, processed);
CREATE INDEX idx_host_webhook_events_booking ON host_webhook_events(host_booking_id);
CREATE INDEX idx_host_webhook_events_created ON host_webhook_events(created_at DESC);

-- 3. Update existing reservations table to add missing columns
ALTER TABLE reservations 
  ADD COLUMN IF NOT EXISTS host_booking_id VARCHAR(255),
  ADD COLUMN IF NOT EXISTS host_commit_status VARCHAR(50) DEFAULT 'pending',
  ADD COLUMN IF NOT EXISTS host_commit_attempts INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS host_commit_last_error TEXT,
  ADD COLUMN IF NOT EXISTS host_commit_failed_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS cancellation_policy_id UUID REFERENCES cancellation_policies(id),
  ADD COLUMN IF NOT EXISTS commission_rate DECIMAL(5,4),
  ADD COLUMN IF NOT EXISTS commission_amount DECIMAL(12,2),
  ADD COLUMN IF NOT EXISTS payout_eligible_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS payout_batch_id UUID REFERENCES payout_batches(id),
  ADD COLUMN IF NOT EXISTS payout_id UUID REFERENCES payouts(id);

CREATE INDEX idx_reservations_host_booking ON reservations(host_booking_id);
CREATE INDEX idx_reservations_host_commit ON reservations(host_commit_status);
CREATE INDEX idx_reservations_payout ON reservations(payout_eligible_at) WHERE payout_eligible_at IS NOT NULL;

-- ============================================
-- MIGRATION: 20260215000006_mvp_rls_policies.sql
-- Row Level Security Policies
-- ============================================

-- Enable RLS on all new tables
ALTER TABLE booking_intents ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE pix_charges ENABLE ROW LEVEL SECURITY;
ALTER TABLE ledger_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE commission_tiers ENABLE ROW LEVEL SECURITY;
ALTER TABLE payout_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE payout_batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE payouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE refunds ENABLE ROW LEVEL SECURITY;
ALTER TABLE ads_slots ENABLE ROW LEVEL SECURITY;
ALTER TABLE ads_campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE ads_impressions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ads_clicks ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE review_invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_outbox ENABLE ROW LEVEL SECURITY;
ALTER TABLE cancellation_policies ENABLE ROW LEVEL SECURITY;
ALTER TABLE city_site_mappings ENABLE ROW LEVEL SECURITY;
ALTER TABLE host_webhook_events ENABLE ROW LEVEL SECURITY;

-- Helper function to get current city from JWT
CREATE OR REPLACE FUNCTION get_current_city_code()
RETURNS VARCHAR(10)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(
    current_setting('request.jwt.claims.city_code', TRUE),
    current_setting('app.current_city_code', TRUE)
  );
$$;

-- RLS Policies for booking_intents
CREATE POLICY "Public can create booking intents" ON booking_intents
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Public can view own booking intents" ON booking_intents
  FOR SELECT USING (session_id = current_setting('request.headers.x-session-id', TRUE));

CREATE POLICY "Service can manage all booking intents" ON booking_intents
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- RLS Policies for payments
CREATE POLICY "Public can create payments" ON payments
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Public can view own payments" ON payments
  FOR SELECT USING (booking_intent_id IN (
    SELECT id FROM booking_intents 
    WHERE session_id = current_setting('request.headers.x-session-id', TRUE)
  ));

CREATE POLICY "Service can manage all payments" ON payments
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- RLS Policies for ledger_entries (Service only)
CREATE POLICY "Service can manage ledger" ON ledger_entries
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- RLS Policies for reviews (Public read, authenticated write)
CREATE POLICY "Public can view published reviews" ON reviews
  FOR SELECT USING (is_published = TRUE);

CREATE POLICY "Travelers can create reviews" ON reviews
  FOR INSERT TO authenticated WITH CHECK (traveler_id = auth.uid());

CREATE POLICY "Admins can moderate reviews" ON reviews
  FOR ALL TO authenticated USING (
    EXISTS (SELECT 1 FROM user_roles WHERE user_id = auth.uid() AND role IN ('admin', 'city_admin'))
  );

-- Similar patterns for other tables...

-- ============================================
-- MIGRATION: 20260215000007_mvp_indexes.sql
-- Performance Indexes
-- ============================================

-- Additional performance indexes
CREATE INDEX idx_reservations_traveler_status ON reservations(traveler_id, status, check_in);
CREATE INDEX idx_reservations_property_booked ON reservations(property_id, booked_at DESC);
CREATE INDEX idx_availability_calendar_property ON availability_calendar(property_id, date, is_available);
CREATE INDEX idx_travelers_email ON travelers(email);
CREATE INDEX idx_properties_map_active ON properties_map(city_id, is_active, is_published) WHERE deleted_at IS NULL;
CREATE INDEX idx_unit_map_property ON unit_map(property_id, is_active);

-- ============================================
-- MIGRATION: 20260215000008_future_placeholders.sql
-- Phase 3+ Schemas Only (No Business Logic)
-- ============================================

-- 1. PROPERTY OWNERS (Placeholder for Sprint 9 Owner Dashboards)
CREATE TABLE property_owners (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  auth_user_id UUID REFERENCES auth.users(id), -- Nullable until owner registers
  email VARCHAR(255) NOT NULL,
  
  -- Profile
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  phone VARCHAR(50),
  
  -- Bank Details (encrypted)
  bank_details_encrypted TEXT,
  
  -- Default Payout Schedule
  default_payout_schedule_id UUID,
  
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_property_owners_auth ON property_owners(auth_user_id) WHERE auth_user_id IS NOT NULL;
CREATE INDEX idx_property_owners_email ON property_owners(email);

-- Junction table: owners ↔ properties
CREATE TABLE property_owner_mappings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  property_id UUID NOT NULL REFERENCES properties_map(id) ON DELETE CASCADE,
  owner_id UUID NOT NULL REFERENCES property_owners(id) ON DELETE CASCADE,
  ownership_percentage DECIMAL(5,2) DEFAULT 100.00,
  is_primary BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(property_id, owner_id)
);

CREATE INDEX idx_property_owner_mappings_property ON property_owner_mappings(property_id);
CREATE INDEX idx_property_owner_mappings_owner ON property_owner_mappings(owner_id);

-- 2. VENDOR PAYABLES (AP - Phase 3 placeholder)
CREATE TABLE vendor_payables (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  payable_code VARCHAR(100), -- e.g., 'VP-2026-001'
  
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  vendor_id UUID, -- Will reference service_providers in Phase 3
  property_id UUID REFERENCES properties_map(id),
  reservation_id UUID REFERENCES reservations(id),
  
  -- Amount
  amount DECIMAL(12,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'BRL',
  description TEXT,
  
  -- Due Date & Status
  due_date DATE NOT NULL,
  status VARCHAR(50) DEFAULT 'pending', -- pending, approved, scheduled, paid
  
  -- Ledger Link
  ledger_entry_id UUID REFERENCES ledger_entries(id),
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. RECEIVABLES (AR - Phase 3 placeholder)
CREATE TABLE receivables (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  entity_type VARCHAR(50) NOT NULL, -- 'commission', 'service_fee'
  entity_id UUID NOT NULL, -- booking_id or service_order_id
  
  amount DECIMAL(12,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'BRL',
  due_date DATE,
  status VARCHAR(50) DEFAULT 'pending',
  
  ledger_entry_id UUID REFERENCES ledger_entries(id),
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. SERVICE PROVIDERS (Phase 3 placeholder)
CREATE TABLE service_providers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  provider_type VARCHAR(50), -- 'laundry', 'cleaning', 'transfer'
  name VARCHAR(255) NOT NULL,
  contact_info JSONB DEFAULT '{}',
  
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 5. SERVICE CATALOG (Phase 3 placeholder)
CREATE TABLE service_catalog (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  property_id UUID REFERENCES properties_map(id),
  provider_id UUID REFERENCES service_providers(id),
  
  service_type VARCHAR(50) NOT NULL,
  name VARCHAR(255) NOT NULL,
  pricing_type VARCHAR(50), -- 'fixed', 'per_night'
  base_price DECIMAL(12,2),
  
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 6. SERVICE ORDERS (Phase 3 placeholder)
CREATE TABLE service_orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_code VARCHAR(10) NOT NULL REFERENCES cities(code),
  
  reservation_id UUID REFERENCES reservations(id),
  property_id UUID REFERENCES properties_map(id),
  service_id UUID REFERENCES service_catalog(id),
  
  status VARCHAR(50) DEFAULT 'pending',
  total_amount DECIMAL(12,2),
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE vendor_payables IS 'PHASE 3 ONLY - Do not implement business logic yet';
COMMENT ON TABLE receivables IS 'PHASE 3 ONLY - Do not implement business logic yet';
COMMENT ON TABLE service_providers IS 'PHASE 3 ONLY - Do not implement business logic yet';
COMMENT ON TABLE service_catalog IS 'PHASE 3 ONLY - Do not implement business logic yet';
COMMENT ON TABLE service_orders IS 'PHASE 3 ONLY - Do not implement business logic yet';

---

## 3) DELIVERABLE 3 — EDGE FUNCTIONS CONTRACT (BFF)

### 3.1 Function Registry

| Domain | Function Name | Auth | Idempotent | Priority |
|--------|---------------|------|------------|----------|
| **Discovery** | search_availability | Public | Yes (cache) | CRITICAL |
| **Discovery** | get_property_list | Public | Yes (cache) | CRITICAL |
| **Discovery** | get_property_detail | Public | Yes (cache) | CRITICAL |
| **Discovery** | get_unit_availability_calendar | Public | Yes (cache) | CRITICAL |
| **Booking** | create_booking_intent | Public | Yes (session_id) | CRITICAL |
| **Booking** | update_traveler_details | Public | No | HIGH |
| **Booking** | create_payment_intent_stripe | Public | Yes (intent_id) | CRITICAL |
| **Booking** | create_pix_charge | Public | Yes (intent_id) | CRITICAL |
| **Booking** | poll_payment_status | Public | No | HIGH |
| **Booking** | finalize_reservation | System | Yes (intent_id) | CRITICAL |
| **Booking** | host_commit_booking | Internal | Yes (reservation_id) | CRITICAL |
| **Booking** | cancel_reservation | Public/Agent | Yes (reservation_id) | HIGH |
| **Booking** | refund_payment | Agent | Yes (payment_id) | CRITICAL |
| **Portal** | get_city_content | Public | Yes (cache) | MEDIUM |
| **Portal** | get_featured_sections | Public | Yes (cache) | MEDIUM |
| **ADS** | get_ads_for_page | Public | Yes (cache) | MEDIUM |
| **ADS** | track_ad_impression | Public | Yes (event_id) | LOW |
| **ADS** | track_ad_click | Public | Yes (event_id) | LOW |
| **KPI** | emit_event | Public | Yes (event_id) | LOW |
| **KPI** | daily_rollup_job | Internal | N/A (cron) | LOW |
| **Integrations** | host_webhook_receiver | Internal (sig) | Yes (webhook_id) | CRITICAL |
| **Integrations** | portal_webhook_receiver | Internal (sig) | Yes (webhook_id) | LOW |

---

### 3.2 Public Discovery Functions

#### 3.2.1 search_availability

```typescript
// Input
interface SearchAvailabilityRequest {
  city_code: string;           // Required
  check_in: string;           // YYYY-MM-DD
  check_out: string;          // YYYY-MM-DD
  guests: {
    adults: number;
    children?: number;
    infants?: number;
  };
  filters?: {
    property_types?: string[];
    min_price?: number;
    max_price?: number;
    amenities?: string[];
    rating?: number;
  };
  pagination?: {
    page: number;            // Default: 1
    per_page: number;        // Default: 20, Max: 50
  };
  sort?: 'price_asc' | 'price_desc' | 'rating_desc' | 'popular';
}

// Output
interface SearchAvailabilityResponse {
  properties: PropertyCard[];
  pagination: {
    page: number;
    per_page: number;
    total: number;
    total_pages: number;
  };
  filters: FilterOptions;
  metadata: {
    query_time_ms: number;
    cache_hit: boolean;
  };
}

interface PropertyCard {
  id: string;                 // UUID
  slug: string;
  name: string;
  property_type: string;
  location: {
    city: string;
    state: string;
  };
  rating: number;
  review_count: number;
  price_from: number;
  currency: string;
  images: string[];
  amenities: string[];
  available: boolean;
  available_units: number;
}
```

**Auth:** Public, rate-limited (100 req/min/IP)  
**Idempotency:** Yes - cache key = hash of all input params, TTL 60s  
**Caching:** Redis, 60s TTL

---

#### 3.2.2 get_property_list

```typescript
// Input
interface GetPropertyListRequest {
  city_code: string;
  property_type?: string;
  is_featured?: boolean;
  is_published?: boolean;
  pagination: { page: number; per_page: number };
  sort?: string;
}

// Output
interface GetPropertyListResponse {
  properties: PropertyDetail[];
  pagination: PaginationInfo;
}
```

**Auth:** Public, rate-limited  
**Idempotency:** Yes - cache key = hash(params), TTL 5min

---

#### 3.2.3 get_property_detail

```typescript
// Input
interface GetPropertyDetailRequest {
  property_slug: string;
  city_code: string;
}

// Output
interface GetPropertyDetailResponse {
  id: string;
  slug: string;
  name: string;
  property_type: string;
  description: string;
  location: {
    address: string;
    city: string;
    state: string;
    lat: number;
    lng: number;
  };
  rating: number;
  review_count: number;
  images: string[];
  amenities: string[];
  policies: {
    check_in: string;
    check_out: string;
    cancellation: string;
  };
  unit_types: UnitType[];
  similar_properties: string[]; // slugs
}
```

**Auth:** Public, rate-limited  
**Idempotency:** Yes - cache key = property_slug + city_code, TTL 5min

---

#### 3.2.4 get_unit_availability_calendar

```typescript
// Input
interface GetAvailabilityCalendarRequest {
  unit_id: string;
  property_id: string;
  start_date: string;     // YYYY-MM-DD
  end_date: string;       // YYYY-MM-DD
}

// Output
interface GetAvailabilityCalendarResponse {
  unit_id: string;
  dates: CalendarDate[];
}

interface CalendarDate {
  date: string;
  is_available: boolean;
  is_blocked: boolean;
  block_reason?: string;
  base_price: number;
  discounted_price?: number;
  min_stay?: number;
  allotment: number;
  bookings_count: number;
}
```

**Auth:** Public  
**Idempotency:** Yes - cache key = unit_id + dates, TTL 30s

---

### 3.3 Booking Flow Functions

#### 3.3.1 create_booking_intent

```typescript
// Input
interface CreateBookingIntentRequest {
  session_id: string;           // Required for idempotency
  city_code: string;
  property_id: string;
  unit_id: string;
  rate_plan_id?: string;
  check_in: string;
  check_out: string;
  guests: {
    adults: number;
    children?: number;
    infants?: number;
  };
  // Traveler (optional - can be added later)
  traveler?: {
    first_name?: string;
    last_name?: string;
    email?: string;
    phone?: string;
  };
  source?: string;              // utm_source
  utm_medium?: string;
  utm_campaign?: string;
}

// Output
interface CreateBookingIntentResponse {
  booking_intent_id: string;
  session_id: string;
  status: 'intent_created';
  expires_at: string;           // ISO 8601
  total_amount: number;
  currency: string;
  price_breakdown: {
    base_price: number;
    taxes: number;
    fees: number;
    discount: number;
    total: number;
  };
}
```

**Auth:** Public  
**Idempotency:** Yes - key = session_id + property_id + dates, TTL = booking_intent.expires_at  
**TTL:** 15 minutes default  
**Validation:** Check availability before creating; reject if unavailable

---

#### 3.3.2 create_payment_intent_stripe

```typescript
// Input
interface CreatePaymentIntentStripeRequest {
  booking_intent_id: string;
  session_id: string;
  payment_method_id?: string;   // Stripe payment method
  customer_email?: string;
}

// Output
interface CreatePaymentIntentStripeResponse {
  payment_intent_id: string;    // Stripe pi_xxx
  client_secret: string;        // For Stripe Elements
  status: 'requires_payment_method' | 'requires_action' | 'processing';
  next_action?: {
    type: string;
    redirect_url?: string;
  };
}
```

**Auth:** Public  
**Idempotency:** Yes - key = booking_intent_id + 'stripe', stored in Redis 24h  
**Retry:** Exponential backoff on Stripe errors (1s, 2s, 4s)

---

#### 3.3.3 create_pix_charge

```typescript
// Input
interface CreatePixChargeRequest {
  booking_intent_id: string;
  session_id: string;
  provider?: 'stripe' | 'mercadopago' | 'openpix';  // Default: stripe
}

// Output
interface CreatePixChargeResponse {
  payment_id: string;
  pix_charge_id: string;
  provider: string;
  qr_code_base64: string;       // Base64 encoded QR image
  qr_code_text: string;         // Copy-paste PIX key
  expires_at: string;
  amount: number;
  currency: string;
}
```

**Auth:** Public  
**Idempotency:** Yes - key = booking_intent_id + 'pix'  
**Expiration:** 15 minutes from creation  
**Provider Abstraction:** Interface allows swapping providers

---

#### 3.3.4 poll_payment_status

```typescript
// Input
interface PollPaymentStatusRequest {
  booking_intent_id: string;
  session_id: string;
}

// Output
interface PollPaymentStatusResponse {
  booking_intent_id: string;
  status: 'intent_created' | 'payment_pending' | 'payment_confirmed' | 'expired' | 'cancelled';
  payment_status?: 'pending' | 'processing' | 'succeeded' | 'failed';
  payment_method?: 'stripe_card' | 'stripe_pix';
  error_message?: string;
}
```

**Auth:** Public (session-based)  
**Idempotency:** N/A (read-only)  
**Client Polling:** Every 5 seconds

---

#### 3.3.5 finalize_reservation (Webhooks + Internal)

```typescript
// This is called internally after payment confirmation
interface FinalizeReservationRequest {
  booking_intent_id: string;
  payment_id: string;
  payment_status: 'succeeded';
}

// Internal Function - not exposed to public
```

**Auth:** Internal (service role)  
**Idempotency:** Yes - key = booking_intent_id + 'finalize'  
**Process:**
1. Validate payment succeeded
2. Update booking_intent.status = 'payment_confirmed'
3. Create reservation record
4. Update booking_intent.status = 'converted'
5. Trigger host_commit_booking (async)
6. Emit event: reservation_confirmed

---

#### 3.3.6 host_commit_booking (Internal)

```typescript
// Called after payment confirmed
interface HostCommitBookingRequest {
  reservation_id: string;
  retry_count?: number;         // Default: 0
}

// Output
interface HostCommitBookingResponse {
  reservation_id: string;
  host_booking_id?: string;
  status: 'host_commit_pending' | 'confirmed' | 'host_commit_failed';
  error_code?: string;
  error_message?: string;
  will_trigger_refund?: boolean;
}
```

**Auth:** Internal (service key)  
**Idempotency:** Yes - key = reservation_id + 'host_commit'  
**Retry:** 3 attempts with exponential backoff (1s, 2s, 4s)  
**Circuit Breaker:** After 5 failures in 60s, open circuit for 30s  
**Failure Handling:** If all retries fail → trigger refund flow automatically

---

#### 3.3.7 cancel_reservation

```typescript
// Input
interface CancelReservationRequest {
  reservation_id: string;
  session_id?: string;
  reason?: string;
  force?: boolean;              // Supervisor override
}

// Output
interface CancelReservationResponse {
  reservation_id: string;
  status: 'cancel_pending' | 'cancelled' | 'rejected';
  refund_eligible: boolean;
  refund_amount?: number;
  refund_percentage?: number;
  cancellation_policy: string;
}
```

**Auth:** Public (owns reservation) or Agent/Supervisor  
**Idempotency:** Yes - key = reservation_id + 'cancel'  
**Policy Engine:** Check cancellation_policies, calculate refund amount

---

#### 3.3.8 refund_payment

```typescript
// Input
interface RefundPaymentRequest {
  payment_id: string;
  reservation_id?: string;
  amount?: number;              // Full if not specified
  reason: string;
  processed_by?: string;         // user_id if agent-initiated
}

// Output
interface RefundPaymentResponse {
  refund_id: string;
  payment_id: string;
  status: 'pending' | 'completed' | 'failed';
  amount: number;
  gateway_refund_id?: string;
  estimated_days: number;
}
```

**Auth:** Agent/Supervisor or System (automatic)  
**Idempotency:** Yes - key = payment_id + 'refund' + amount  
**Retry:** 3 attempts with exponential backoff (5s, 10s, 20s)

---

### 3.4 Portal Enrichment Functions

#### 3.4.1 get_city_content

```typescript
// Input
interface GetCityContentRequest {
  city_code: string;
  content_types: ('hero_banners' | 'featured_sections')[];
}

// Output
interface GetCityContentResponse {
  city_code: string;
  hero_banners: HeroBanner[];
  featured_sections: FeaturedSection[];
}
```

**Auth:** Public, rate-limited  
**Caching:** 5 minutes, Redis

---

#### 3.4.2 get_featured_sections

```typescript
// Input
interface GetFeaturedSectionsRequest {
  city_code: string;
  section_types: ('restaurants' | 'attractions' | 'events')[];
  limit?: number;
}

// Output
interface GetFeaturedSectionsResponse {
  restaurants: Place[];
  attractions: Place[];
  events: Event[];
}
```

**Auth:** Public  
**Caching:** 5 minutes

---

### 3.5 ADS MVP Functions

#### 3.5.1 get_ads_for_page

```typescript
// Input
interface GetAdsForPageRequest {
  city_code: string;
  slot_code: string;
  page_type: 'home' | 'search' | 'property_detail';
  property_id?: string;          // For targeting
  session_id?: string;
  visitor_id?: string;
}

// Output
interface GetAdsForPageResponse {
  slot_code: string;
  ads: Ad[];
}

interface Ad {
  campaign_id: string;
  title: string;
  description: string;
  image_url: string;
  cta_text: string;
  cta_url: string;
}
```

**Auth:** Public  
**Caching:** 60 seconds per slot + user segment

---

#### 3.5.2 track_ad_impression

```typescript
// Input
interface TrackAdImpressionRequest {
  campaign_id: string;
  slot_id: string;
  session_id: string;
  visitor_id?: string;
  property_id?: string;
  page_path?: string;
  cost?: number;
}

// Output
{ success: true; impression_id: string }
```

**Auth:** Public (fire-and-forget)  
**Idempotency:** Yes - generate unique event_id

---

#### 3.5.3 track_ad_click

```typescript
// Input
interface TrackAdClickRequest {
  campaign_id: string;
  impression_id?: string;
  session_id: string;
  visitor_id?: string;
  page_path?: string;
  cost?: number;
}

// Output
{ success: true; click_id: string; redirect_url: string }
```

**Auth:** Public  
**Idempotency:** Yes - generate unique event_id

---

### 3.6 KPI/Events Functions

#### 3.6.1 emit_event

```typescript
// Input
interface EmitEventRequest {
  event_name: string;
  city_code?: string;
  property_id?: string;
  reservation_id?: string;
  session_id?: string;
  visitor_id?: string;
  user_id?: string;
  user_agent?: string;
  utm_source?: string;
  utm_medium?: string;
  utm_campaign?: string;
  metadata?: Record<string, any>;
}

// Output
{ success: true; event_id: string }
```

**Auth:** Public (server-side only for sensitive events)  
**Idempotency:** Yes - event_id = UUID

---

### 3.7 Integration Functions

#### 3.7.1 host_webhook_receiver

```typescript
// Input (Webhook from Host Connect)
interface HostWebhookRequest {
  event_type: string;
  timestamp: string;
  data: Record<string, any>;
  signature: string;            // HMAC verification
}

// Supported Events:
// - booking.created
// - booking.updated
// - booking.cancelled
// - checkin.completed
// - checkout.completed

// Output
{ received: true; processed: boolean }
```

**Auth:** Internal - signature verification required  
**Idempotency:** Yes - store webhook event_id, skip if already processed  
**Retry:** If signature invalid, return 401; if processing fails, return 200 (to stop retries)

---

### 3.8 Error Semantics (Consistent)

```typescript
// All Edge Functions return this structure
interface EdgeFunctionResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;           // e.g., 'INVALID_BOOKING_INTENT'
    message: string;
    details?: Record<string, any>;
  };
  meta?: {
    request_id: string;
    processing_time_ms: number;
  };
}

// Common Error Codes
const ERROR_CODES = {
  // Authentication
  UNAUTHORIZED: 'UNAUTHORIZED',
  FORBIDDEN: 'FORBIDDEN',
  
  // Validation
  INVALID_REQUEST: 'INVALID_REQUEST',
  MISSING_REQUIRED_FIELD: 'MISSING_REQUIRED_FIELD',
  INVALID_PARAMETER: 'INVALID_PARAMETER',
  
  // Business Logic
  BOOKING_INTENT_EXPIRED: 'BOOKING_INTENT_EXPIRED',
  BOOKING_INTENT_NOT_FOUND: 'BOOKING_INTENT_NOT_FOUND',
  PAYMENT_FAILED: 'PAYMENT_FAILED',
  PAYMENT_ALREADY_PROCESSED: 'PAYMENT_ALREADY_PROCESSED',
  HOST_COMMIT_FAILED: 'HOST_COMMIT_FAILED',
  HOST_UNAVAILABLE: 'HOST_UNAVAILABLE',
  INSUFFICIENT_INVENTORY: 'INSUFFICIENT_INVENTORY',
  CANCELLATION_NOT_ALLOWED: 'CANCELLATION_NOT_ALLOWED',
  REFUND_FAILED: 'REFUND_FAILED',
  
  // System
  INTERNAL_ERROR: 'INTERNAL_ERROR',
  RATE_LIMIT_EXCEEDED: 'RATE_LIMIT_EXCEEDED',
  SERVICE_UNAVAILABLE: 'SERVICE_UNAVAILABLE',
} as const;
```

---

## 4) DELIVERABLE 4 — BOOKING STATE MACHINE NOTES

### 4.1 State Definitions

#### 4.1.1 booking_intent States

| State | Description | TTL | Actor |
|-------|-------------|-----|-------|
| `intent_created` | Customer initiated booking, selected dates/property | 15 min | Customer |
| `payment_pending` | Payment initiated, awaiting gateway | 30 min | System/Customer |
| `payment_confirmed` | Gateway confirmed funds received | 5 min failsafe | System |
| `converted` | Successfully converted to reservation | N/A | System |
| `expired` | TTL reached without completion | N/A | System |
| `cancelled` | Customer or system cancelled before conversion | N/A | Customer/System |

#### 4.1.2 reservation States

| State | Description | Actor |
|-------|-------------|-------|
| `host_commit_pending` | Payment confirmed, awaiting Host Connect confirmation | System |
| `host_commit_failed` | Host system rejected booking | System |
| `confirmed` | Host confirmed, booking active | System |
| `checkin_pending` | Date reached, awaiting check-in | System |
| `checked_in` | Guest checked in via Host Connect | Host Webhook |
| `checked_out` | Guest checked out | Host Webhook |
| `completed` | Stay finished, payout pending | System |
| `cancel_pending` | Cancellation requested | Customer/Agent |
| `cancelled` | Booking cancelled | System |
| `refund_pending` | Refund being processed | System |
| `refunded` | Funds returned to customer | System |
| `payout_pending` | Funds held, awaiting payout schedule | System |
| `paid_out` | Owner received payout | System |

---

### 4.2 Transition Rules

#### 4.2.1 booking_intent Transitions

```
intent_created
    ├── [customer initiates payment] → payment_pending
    ├── [TTL 15min expires] → expired
    └── [customer cancels] → cancelled

payment_pending
    ├── [webhook: payment_intent.succeeded] → payment_confirmed
    ├── [customer cancels] → cancelled
    └── [TTL 30min expires] → expired (release inventory)

payment_confirmed
    ├── [finalize_reservation success] → converted
    ├── [host_commit timeout] → refund_pending
    └── [TTL 5min failsafe] → refund_pending

converted ──────────────────────────► [terminal]
expired ─────────────────────────────► [terminal]
cancelled ───────────────────────────► [terminal]
```

#### 4.2.2 reservation Transitions

```
host_commit_pending
    ├── [Host API success] → confirmed
    └── [Host API failure × 3] → host_commit_failed

host_commit_failed
    └── [system trigger] → refund_pending

confirmed
    ├── [check_in date reached] → checkin_pending
    ├── [customer requests cancel] → cancel_pending
    └── [no-show policy] → cancelled

checkin_pending
    ├── [Host webhook: checkin.completed] → checked_in
    └── [no-show timeout] → cancelled

checked_in
    └── [Host webhook: checkout.completed] → checked_out

checked_out
    └── [system: checkout + 24h] → completed

cancel_pending
    ├── [policy allows] → cancelled
    └── [policy denies] → confirmed (reject cancellation)

cancelled
    └── [payment exists] → refund_pending

refund_pending
    ├── [refund succeeds] → refunded
    └── [refund fails] → refund_failed (manual)

completed
    └── [system: payout eligibility] → payout_pending

payout_pending
    ├── [batch executes] → paid_out
    └── [dispute] → refunded
```

---

### 4.3 TTL Rules

| Entity | State | TTL | Action on Expiry |
|--------|-------|-----|------------------|
| booking_intent | intent_created | 15 min | Auto-cancel, release hold |
| booking_intent | payment_pending | 30 min | Auto-cancel, release hold |
| booking_intent | payment_confirmed | 5 min | Failsafe: if not converted, trigger refund |
| pix_charge | pending | 15 min | Auto-expire, release hold |
| reservation | host_commit_pending | 10 min | After 3 retries: mark failed, trigger refund |

---

### 4.4 Soft Holds (Inventory)

1. **booking_intent created** → Create soft hold in `availability_calendar.temp_holds`
2. **Hold TTL** = booking_intent TTL (15 min)
3. **Payment confirmed** → Convert to hard block (sync to Host)
4. **Intent expired/cancelled** → Release soft hold
5. **Concurrency**: `allotment > bookings_count + temp_holds`

---

### 4.5 Check-In/Out (HOST EXCLUSIVE)

**Critical Rule:** Reserve NEVER updates check-in/check-out directly.

1. Guest arrives at property → Host Connect records check-in
2. Host sends webhook to Reserve: `checkin.completed`
3. Reserve updates: `reservation.status = 'checked_in'`
4. Same pattern for check-out

**Webhooks consumed:**
- `booking.checkin_completed` → `checked_in`
- `booking.checkout_completed` → `checked_out`

---

## 5) DELIVERABLE 5 — FINANCIAL (MoR) LEDGER RULES

### 5.1 Ledger Accounts

#### Assets (Debit = +, Credit = -)
| Account | Purpose |
|---------|---------|
| `cash_reserve` | Holding account for customer funds |
| `merchant_account` | Operating account (Stripe/PIX) |
| `payouts_receivable` | Amounts owed to property owners |
| `gateway_fees_receivable` | Fees to be paid to gateways |

#### Liabilities (Debit = -, Credit = +)
| Account | Purpose |
|---------|---------|
| `customer_deposits` | Funds held for customers |
| `refunds_payable` | Refunds owed to customers |
| `commissions_payable` | Commissions held |

#### Revenue (Credit = +)
| Account | Purpose |
|---------|---------|
| `commission_revenue` | Earned commission |
| `gateway_fee_expense` | Cost of payment processing |
| `iof_expense` | IOF tax expense (Brazil PIX) |

---

### 5.2 Entry Recipes

#### 5.2.1 Card Payment Success ($1000)

```sql
-- Transaction ID: txn_payment_001

-- 1. Customer pays $1000
INSERT INTO ledger_entries (transaction_id, city_code, entry_type, account, direction, amount, counterparty_type, description)
VALUES 
  ('txn_payment_001', 'URB', 'payment_received', 'cash_reserve', 'debit', 1000.00, 'customer', 'Payment for reservation RES-2026-001'),
  ('txn_payment_001', 'URB', 'payment_received', 'customer_deposits', 'credit', 1000.00, 'customer', 'Payment for reservation RES-2026-001');

-- 2. Gateway fee: $29 (2.9% + $0.30)
INSERT INTO ledger_entries (transaction_id, city_code, entry_type, account, direction, amount, counterparty_type, description)
VALUES 
  ('txn_payment_001', 'URB', 'gateway_fee', 'gateway_fee_expense', 'debit', 29.00, 'gateway', 'Stripe fee'),
  ('txn_payment_001', 'URB', 'gateway_fee', 'gateway_fees_receivable', 'credit', 29.00, 'gateway', 'Stripe fee accrual');
```

#### 5.2.2 PIX Payment Success ($1000 + IOF)

```sql
-- PIX: R$1000 + IOF 0.38% = R$3.80
-- Net to Reserve: R$1000 - R$3.80 = R$996.20

-- Transaction ID: txn_pix_001

-- 1. Customer pays R$1000
INSERT INTO ledger_entries (transaction_id, city_code, entry_type, account, direction, amount, counterparty_type, description)
VALUES 
  ('txn_pix_001', 'URB', 'payment_received', 'cash_reserve', 'debit', 1000.00, 'customer', 'PIX payment'),
  ('txn_pix_001', 'URB', 'payment_received', 'customer_deposits', 'credit', 1000.00, 'customer', 'PIX payment');

-- 2. IOF Tax (0.38%)
INSERT INTO ledger_entries (transaction_id, city_code, entry_type, account, direction, amount, counterparty_type, description)
VALUES 
  ('txn_pix_001', 'URB', 'iof_tax', 'iof_expense', 'debit', 3.80, 'tax_authority', 'IOF tax 0.38%'),
  ('txn_pix_001', 'URB', 'iof_tax', 'customer_deposits', 'credit', 3.80, 'tax_authority', 'IOF tax withheld');
```

#### 5.2.3 Commission Capture (on confirmation)

```sql
-- Commission: 15% of $1000 = $150
-- Transaction ID: txn_commission_001

INSERT INTO ledger_entries (transaction_id, city_code, entry_type, account, direction, amount, counterparty_type, booking_id, description)
VALUES 
  ('txn_commission_001', 'URB', 'commission_taken', 'customer_deposits', 'debit', 150.00, 'owner', 'res_001', 'Commission captured'),
  ('txn_commission_001', 'URB', 'commission_taken', 'commissions_payable', 'credit', 150.00, 'owner', 'Commission accrued');

-- Revenue recognition
INSERT INTO ledger_entries (transaction_id, city_code, entry_type, account, direction, amount, counterparty_type, booking_id, description)
VALUES 
  ('txn_commission_001', 'URB', 'commission_revenue', 'commission_revenue', 'credit', 150.00, 'owner', 'Commission earned'),
  ('txn_commission_001', 'URB', 'commission_revenue', 'commissions_payable', 'debit', 150.00, 'owner', 'Commission applied');
```

#### 5.2.4 Payout Due (after checkout + 24h)

```sql
-- Owner share: $1000 - $150 = $850
-- Transaction ID: txn_payout_due_001

INSERT INTO ledger_entries (transaction_id, city_code, entry_type, account, direction, amount, counterparty_type, booking_id, property_id, description)
VALUES 
  ('txn_payout_due_001', 'URB', 'payout_due', 'customer_deposits', 'debit', 850.00, 'owner', 'res_001', 'prop_001', 'Owner share due'),
  ('txn_payout_due_001', 'URB', 'payout_due', 'payouts_receivable', 'credit', 850.00, 'owner', 'Owner payout recorded');
```

#### 5.2.5 Payout Executed (weekly batch)

```sql
-- Batch transfer to owner bank account
-- Transaction ID: txn_payout_exec_001

INSERT INTO ledger_entries (transaction_id, city_code, entry_type, account, direction, amount, counterparty_type, description)
VALUES 
  ('txn_payout_exec_001', 'URB', 'payout_executed', 'payouts_receivable', 'debit', 850.00, 'owner', 'Payout to owner'),
  ('txn_payout_exec_001', 'URB', 'payout_executed', 'cash_reserve', 'credit', 850.00, 'owner', 'Payout executed');
```

#### 5.2.6 Refund Flow (Full Refund)

```sql
-- Original: $1000 payment, $150 commission, $850 owner share due (not yet paid)

-- 1. Refund to customer
INSERT INTO ledger_entries (transaction_id, city_code, entry_type, account, direction, amount, counterparty_type, booking_id, description)
VALUES 
  ('txn_refund_001', 'URB', 'refund_processed', 'refunds_payable', 'debit', 1000.00, 'customer', 'res_001', 'Refund to customer'),
  ('txn_refund_001', 'URB', 'refund_processed', 'cash_reserve', 'credit', 1000.00, 'customer', 'Refund paid');

-- 2. Reverse commission (if before payout)
INSERT INTO ledger_entries (transaction_id, city_code, entry_type, account, direction, amount, counterparty_type, booking_id, description)
VALUES 
  ('txn_refund_001', 'URB', 'refund_reversal', 'commissions_payable', 'debit', 150.00, 'owner', 'res_001', 'Commission reversed'),
  ('txn_refund_001', 'URB', 'refund_reversal', 'commission_revenue', 'credit', -150.00, 'owner', 'Commission reversed');

-- 3. Cancel payout obligation (if not yet paid)
INSERT INTO ledger_entries (transaction_id, city_code, entry_type, account, direction, amount, counterparty_type, booking_id, description)
VALUES 
  ('txn_refund_001', 'URB', 'refund_reversal', 'payouts_receivable', 'debit', 850.00, 'owner', 'res_001', 'Payout cancelled'),
  ('txn_refund_001', 'URB', 'refund_reversal', 'customer_deposits', 'credit', 850.00, 'owner', 'Owner share returned');
```

---

### 5.3 Reporting Queries

#### 5.3.1 Gross Revenue (Bookings)

```sql
SELECT 
  DATE_TRUNC('day', le.created_at) as date,
  SUM(le.amount) as gross_revenue,
  COUNT(DISTINCT le.booking_id) as booking_count
FROM ledger_entries le
WHERE le.entry_type = 'payment_received'
  AND le.direction = 'debit'
  AND le.account = 'cash_reserve'
  AND le.city_code = :city_code
  AND le.created_at >= :start_date
GROUP BY DATE_TRUNC('day', le.created_at)
ORDER BY date DESC;
```

#### 5.3.2 Net Payouts to Owners

```sql
SELECT 
  DATE_TRUNC('day', le.created_at) as date,
  SUM(le.amount) as total_payouts,
  COUNT(DISTINCT le.booking_id) as reservation_count
FROM ledger_entries le
WHERE le.entry_type = 'payout_executed'
  AND le.direction = 'debit'
  AND le.account = 'payouts_receivable'
  AND le.city_code = :city_code
GROUP BY DATE_TRUNC('day', le.created_at);
```

#### 5.3.3 Commission Revenue

```sql
SELECT 
  DATE_TRUNC('day', le.created_at) as date,
  SUM(le.amount) as commission_revenue,
  COUNT(DISTINCT le.booking_id) as bookings
FROM ledger_entries le
WHERE le.entry_type = 'commission_revenue'
  AND le.city_code = :city_code
GROUP BY DATE_TRUNC('day', le.created_at);
```

#### 5.3.4 Refund Rate

```sql
SELECT 
  DATE_TRUNC('day', r.requested_at) as date,
  SUM(r.amount) as refund_total,
  (SUM(r.amount) / NULLIF(SUM(p.amount), 0)) * 100 as refund_rate_percent,
  COUNT(*) as refund_count
FROM refunds r
JOIN payments p ON p.id = r.payment_id
WHERE r.city_code = :city_code
  AND r.status = 'completed'
GROUP BY DATE_TRUNC('day', r.requested_at);
```

---

## 6) DELIVERABLE 6 — KPI / EVENTS MODEL

### 6.1 Events Table Schema

```sql
CREATE TABLE IF NOT EXISTS reserve.funnel_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Event Identification
  event_name VARCHAR(100) NOT NULL,
  event_version VARCHAR(10) DEFAULT '1.0',
  
  -- Tenant Context
  city_code VARCHAR(10),
  
  -- Entity References
  property_id UUID,
  reservation_id UUID,
  unit_id UUID,
  booking_intent_id UUID,
  payment_id UUID,
  
  -- User Context (Anonymous or Authenticated)
  session_id VARCHAR(100),
  visitor_id VARCHAR(100),
  user_id UUID,
  
  -- Attribution
  utm_source VARCHAR(100),
  utm_medium VARCHAR(100),
  utm_campaign VARCHAR(200),
  utm_content VARCHAR(200),
  utm_term VARCHAR(200),
  
  -- Context
  user_agent TEXT,
  ip_hash VARCHAR(64),
  referrer TEXT,
  page_path VARCHAR(500),
  
  -- Event Data
  event_data JSONB DEFAULT '{}',
  
  -- Timing
  event_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_funnel_events_name ON funnel_events(event_name, event_timestamp);
CREATE INDEX idx_funnel_events_city ON funnel_events(city_code, event_timestamp);
CREATE INDEX idx_funnel_events_property ON funnel_events(property_id, event_timestamp);
CREATE INDEX idx_funnel_events_session ON funnel_events(session_id, event_timestamp);
CREATE INDEX idx_funnel_events_utm ON funnel_events(utm_source, utm_medium, utm_campaign);
```

---

### 6.2 Required Events

| Event Name | When Emitted | Key Properties |
|------------|--------------|----------------|
| `search_performed` | User submits search | city_code, check_in, check_out, guests, filters, result_count |
| `property_viewed` | User views property detail | property_id, from_search, view_duration |
| `booking_intent_created` | Intent created | booking_intent_id, property_id, total_amount |
| `payment_started` | User initiates payment | booking_intent_id, payment_method |
| `payment_succeeded` | Gateway confirms | payment_id, amount, processing_time |
| `payment_failed` | Gateway rejects | payment_id, failure_code, retry_count |
| `host_commit_started` | Reserve calls Host | reservation_id, attempt |
| `host_commit_succeeded` | Host confirms | reservation_id, host_booking_id |
| `host_commit_failed` | Host rejects/timeout | reservation_id, error_code, will_refund |
| `reservation_confirmed` | Full flow complete | reservation_id, confirmation_code |
| `reservation_cancelled` | Booking cancelled | reservation_id, reason, refund_amount |
| `refund_initiated` | Refund started | refund_id, amount, reason |
| `refund_succeeded` | Refund complete | refund_id, gateway_refund_id |
| `checkout_completed` | Guest checked out | reservation_id (from Host webhook) |

---

### 6.3 Daily Rollup Queries

```sql
-- Daily Conversion Funnel
CREATE MATERIALIZED VIEW mv_daily_conversion_funnel AS
SELECT 
  DATE(event_timestamp) as date,
  city_code,
  
  -- Funnel counts
  COUNT(*) FILTER (WHERE event_name = 'search_performed') as searches,
  COUNT(DISTINCT session_id) FILTER (WHERE event_name = 'property_viewed') as property_views,
  COUNT(DISTINCT session_id) FILTER (WHERE event_name = 'booking_intent_created') as booking_intents,
  COUNT(*) FILTER (WHERE event_name = 'payment_started') as payment_started,
  COUNT(*) FILTER (WHERE event_name = 'payment_succeeded') as payment_succeeded,
  COUNT(*) FILTER (WHERE event_name = 'host_commit_succeeded') as host_commits_succeeded,
  COUNT(*) FILTER (WHERE event_name = 'reservation_confirmed') as reservations_confirmed,
  
  -- Derived rates
  ROUND(
    COUNT(*) FILTER (WHERE event_name = 'reservation_confirmed') * 100.0 / 
    NULLIF(COUNT(*) FILTER (WHERE event_name = 'search_performed'), 0), 2
  ) as search_to_booking_rate_percent,
  
  ROUND(
    COUNT(*) FILTER (WHERE event_name = 'payment_succeeded') * 100.0 / 
    NULLIF(COUNT(*) FILTER (WHERE event_name = 'payment_started'), 0), 2
  ) as payment_success_rate_percent,
  
  ROUND(
    COUNT(*) FILTER (WHERE event_name = 'host_commit_succeeded') * 100.0 / 
    NULLIF(COUNT(*) FILTER (WHERE event_name = 'payment_succeeded'), 0), 2
  ) as host_commit_success_rate_percent
  
FROM funnel_events
WHERE event_timestamp >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE(event_timestamp), city_code;

-- Refresh daily
CREATE INDEX mv_daily_conversion_funnel_date ON mv_daily_conversion_funnel(date, city_code);
```

---

### 6.4 Example Dashboard Queries

#### 6.4.1 Conversion Funnel (Real-time)

```sql
-- Current funnel for city
SELECT 
  event_name,
  COUNT(DISTINCT session_id) as unique_users,
  COUNT(*) as total_events
FROM funnel_events
WHERE city_code = 'URB'
  AND event_timestamp >= NOW() - INTERVAL '24 hours'
  AND event_name IN (
    'search_performed', 
    'property_viewed', 
    'booking_intent_created', 
    'payment_started',
    'payment_succeeded',
    'reservation_confirmed'
  )
GROUP BY event_name
ORDER BY 
  CASE event_name
    WHEN 'search_performed' THEN 1
    WHEN 'property_viewed' THEN 2
    WHEN 'booking_intent_created' THEN 3
    WHEN 'payment_started' THEN 4
    WHEN 'payment_succeeded' THEN 5
    WHEN 'reservation_confirmed' THEN 6
  END;
```

#### 6.4.2 Host Success Rate by Hour

```sql
SELECT 
  DATE_TRUNC('hour', event_timestamp) as hour,
  COUNT(*) FILTER (WHERE event_name = 'host_commit_succeeded') as success,
  COUNT(*) FILTER (WHERE event_name = 'host_commit_failed') as failed,
  ROUND(
    COUNT(*) FILTER (WHERE event_name = 'host_commit_succeeded') * 100.0 / 
    NULLIF(
      COUNT(*) FILTER (WHERE event_name IN ('host_commit_succeeded', 'host_commit_failed')), 
      0
    ), 2
  ) as success_rate_percent
FROM funnel_events
WHERE city_code = 'URB'
  AND event_timestamp >= NOW() - INTERVAL '7 days'
  AND event_name IN ('host_commit_succeeded', 'host_commit_failed')
GROUP BY DATE_TRUNC('hour', event_timestamp)
ORDER BY hour DESC;
```

#### 6.4.3 Payment Success Rate by Method

```sql
SELECT 
  event_data->>'payment_method' as payment_method,
  COUNT(*) FILTER (WHERE event_name = 'payment_succeeded') as succeeded,
  COUNT(*) FILTER (WHERE event_name = 'payment_failed') as failed,
  ROUND(
    COUNT(*) FILTER (WHERE event_name = 'payment_succeeded') * 100.0 / 
    NULLIF(
      COUNT(*) FILTER (WHERE event_name IN ('payment_succeeded', 'payment_failed')), 
      0
    ), 2
  ) as success_rate_percent
FROM funnel_events
WHERE city_code = 'URB'
  AND event_timestamp >= NOW() - INTERVAL '30 days'
  AND event_name IN ('payment_succeeded', 'payment_failed')
GROUP BY event_data->>'payment_method';
```

#### 6.4.4 Exception Queue Rate

```sql
-- Failed commits / total confirmed
SELECT 
  DATE_TRUNC('day', event_timestamp) as date,
  COUNT(*) FILTER (WHERE event_name = 'host_commit_failed') as failed_commits,
  COUNT(*) FILTER (WHERE event_name = 'reservation_confirmed') as confirmed,
  ROUND(
    COUNT(*) FILTER (WHERE event_name = 'host_commit_failed') * 100.0 / 
    NULLIF(COUNT(*) FILTER (WHERE event_name = 'reservation_confirmed'), 0), 2
  ) as exception_rate_percent
FROM funnel_events
WHERE city_code = 'URB'
  AND event_timestamp >= NOW() - INTERVAL '7 days'
GROUP BY DATE_TRUNC('day', event_timestamp)
HAVING COUNT(*) FILTER (WHERE event_name = 'reservation_confirmed') > 0;
```

---

## 7) DELIVERABLE 7 — CONSISTENCY CHECK + ACTION LIST

### 7.1 What I Changed / Propose to Change

| Item | Status | Action |
|------|--------|--------|
| **Created Migration SQL** | ✅ Complete | 8 migration files covering all MVP tables |
| **Added RLS Policies** | ✅ Included | All tables have city_code-based policies |
| **Added Indexes** | ✅ Included | Critical query paths indexed |
| **Created Future Placeholders** | ✅ Complete | AP/AR, Services, Owners as Phase 3+ |
| **Created Edge Functions Spec** | ✅ Complete | 22 functions across 6 domains |
| **State Machine Documentation** | ✅ Complete | Full transition rules + TTL |
| **Ledger Recipes** | ✅ Complete | All transaction types documented |
| **Events Schema** | ✅ Complete | Funnel + daily rollup defined |

---

### 7.2 Files to Be Created/Edited

#### Database (Supabase)
```
supabase/migrations/
├── 20260215000001_mvp_core_tables.sql          ✅ Created
├── 20260215000002_mvp_financial_tables.sql     ✅ Created
├── 20260215000003_mvp_ads_tables.sql            ✅ Created
├── 20260215000004_mvp_supporting_tables.sql    ✅ Created
├── 20260215000005_mvp_sync_integration.sql     ✅ Created
├── 20260215000006_mvp_rls_policies.sql         ✅ Created
├── 20260215000007_mvp_indexes.sql              ✅ Created
└── 20260215000008_future_placeholders.sql       ✅ Created
```

#### Edge Functions (Supabase)
```
supabase/functions/
├── search_availability/index.ts
├── get_property_list/index.ts
├── get_property_detail/index.ts
├── get_unit_availability_calendar/index.ts
├── create_booking_intent/index.ts
├── create_payment_intent_stripe/index.ts
├── create_pix_charge/index.ts
├── poll_payment_status/index.ts
├── finalize_reservation/index.ts
├── host_commit_booking/index.ts
├── cancel_reservation/index.ts
├── refund_payment/index.ts
├── get_city_content/index.ts
├── get_featured_sections/index.ts
├── get_ads_for_page/index.ts
├── track_ad_impression/index.ts
├── track_ad_click/index.ts
├── emit_event/index.ts
├── host_webhook_receiver/index.ts
└── daily_rollup_job/index.ts
```

---

### 7.3 Sprint 1 Kickoff DoD Checklist

#### Pre-Sprint 1 (Immediate)
- [ ] Run all 8 migration scripts on Reserve Connect database
- [ ] Verify RLS policies active on all new tables
- [ ] Verify indexes created
- [ ] Configure Stripe API keys in Supabase secrets
- [ ] Configure PIX provider credentials
- [ ] Test cross-database connection (Reserve → Portal, Reserve → Host)

#### Sprint 1: Foundation
- [ ] Deploy Edge Function stubs (hello world)
- [ ] Implement `search_availability` with mock data
- [ ] Implement `get_property_list` with mock data
- [ ] Implement `get_property_detail` with mock data
- [ ] Connect site app to Edge Functions (BFF pattern)
- [ ] Remove all hardcoded mock data from site app

#### Sprint 2: Host Integration + Booking Intents
- [ ] Deploy `sync_host_properties` Edge Function
- [ ] Deploy `sync_host_room_types` Edge Function
- [ ] Create Host Connect API client
- [ ] Implement `create_booking_intent`
- [ ] Implement booking_intent TTL expiry job

#### Sprint 3: Payment Core (Stripe + PIX)
- [ ] Implement Stripe payment flow
- [ ] Implement PIX provider abstraction
- [ ] Implement `create_pix_charge`
- [ ] Implement PIX webhook + polling
- [ ] Implement PIX reconciliation job

#### Sprint 4: Booking Flow
- [ ] Implement `finalize_reservation`
- [ ] Implement `host_commit_booking`
- [ ] Implement failure retry + circuit breaker
- [ ] Implement notification outbox + templates

#### Sprint 5: Operations
- [ ] Implement `cancel_reservation` with policy engine
- [ ] Implement `refund_payment`
- [ ] Implement support console basics
- [ ] Implement audit logging

#### Sprint 6: MVP Launch
- [ ] All PIX E2E tests passing
- [ ] All Stripe E2E tests passing
- [ ] Host commit success rate > 99%
- [ ] Payment success rate > 85%
- [ ] 10-20 properties live
- [ ] Monitoring dashboards active

---

### 7.4 Acceptance Gate: PIX End-to-End Validation

Before Sprint 6 completion, these 5 scenarios MUST pass:

1. **PIX Happy Path**: Guest pays via PIX → QR generated → Pays → Webhook → Host commit → Confirmed
2. **PIX Expiration**: Guest generates QR → Doesn't pay in 15min → Intent expires → Hold released
3. **PIX Host Failure**: Guest pays → Host commit fails × 3 → Refund triggered → Guest refunded
4. **PIX Reconciliation**: Guest pays → Webhook missed → Hourly job catches → Flow continues
5. **Mixed Payments**: Some properties PIX, some Stripe → All payout correctly → Ledger balances

---

### 7.5 Architecture Invariants (MUST NOT CHANGE)

| Invariant | Description |
|-----------|-------------|
| **Payment-First** | Payment confirmed BEFORE host commit |
| **Host Exclusive Check-In** | Reserve only receives webhooks for checkin/out |
| **City Isolation** | All queries filtered by city_code via RLS |
| **Idempotency** | All payment/host paths use idempotency keys |
| **Failure States** | host_commit_failed, refund_pending, cancel_pending always present |
| **Double-Entry Ledger** | Every transaction has balanced debits = credits |
| **TTL Enforcement** | booking_intent expires after 15min |

---

**Document Status:** COMPLETE  
**Next Steps:** Run migrations → Deploy Edge Functions → Connect Site App → Sprint 1 Kickoff

---

*End of Reserve Connect MVP Preparation Document*

```

---

*Continue to next section for remaining deliverables...*
