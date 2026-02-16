# RESERVE CONNECT - MASTER EXECUTION PLAN
## Version 1.2 - Architecture Lockdown & Roadmap Update

**Date:** 2026-02-15  
**Status:** ARCHITECTURE FREEZE (Sprint 0) + EXECUTION ROADMAP  
**Classification:** Implementation-Ready  
**Author:** Senior Architect + Tech PM + Delivery Auditor  

---

## A) CHANGE LOG: v1.1 → v1.2

### Theme 1: Merchant of Record (MoR) Model
- **NEW:** Reserve Connect "cobra e repassa" model explicitly defined
- Reserve collects all funds, keeps commission, repasses remainder to property owners
- Payout scheduling: Weekly default, property-specific overrides supported
- Commission captured at confirmation time, not post-stay
- Ledger entries for payout due calculated on checkout + 24h grace period

### Theme 2: PIX Mandatory in MVP
- **MOVED:** PIX from Phase 2 to Sprint 3 (MVP Core)
- QR generation, webhook/polling hybrid, reconciliation job all MVP
- PIX provider abstraction layer (Stripe PIX, MercadoPago, OpenPIX ready)
- PIX IOF tax handling (0.38%) for Brazil market

### Theme 3: Host Connect Lifecycle Clarification
- **CLARIFIED:** Check-in/check-out lifecycle is HOST CONNECT exclusive
- Reserve captures bookings, processes payments, tracks financials
- Host Connect operates the stay (check-in/out, room assignment)
- Reserve receives webhooks for status sync only (no write operations)
- Reservation states: `confirmed` → `checkin_pending` → `checked_in` (via webhook) → `checked_out` (via webhook) → `completed`

### Theme 4: Financial Module Expansion (Future-Ready)
- **NEW:** Accounts Receivable (AR) + Accounts Payable (AP) module phase-ready
- Schema placeholders for: `vendor_payables`, `receivables`, `service_orders`
- Ledger linkage: service transactions create entries with `entity_type='service'`
- Payout batch processing extended to handle service provider payouts

### Theme 5: Services Marketplace (Future-Ready)
- **NEW:** Service catalog architecture for Phase 3
- Services: laundry, cleaning, transfers, tours, F&B
- Order lifecycle: `pending` → `confirmed` → `fulfilled` → `completed`
- Service providers: separate from property owners, independent payout schedules
- Invoicing hooks: NF-e (Brazilian invoice) integration points

### Theme 6: Owner Access & RBAC
- **NEW:** Owner role with read-only dashboards
- Owner permissions: view own properties' bookings, KPIs, payout statements, commission reports
- Owner CANNOT: cancel bookings, modify reservations, override policies
- Owner access: separate portal at `/owner/{property_id}`
- Data isolation: Owners see only their properties, filtered by RLS

### Theme 7: Sprint Rebalancing
- **ADJUSTED:** Sprint 3 absorbs PIX implementation (was Phase 2)
- **ADJUSTED:** Sprint 9-10 expands to include Owner Dashboard (was narrower scope)
- **ADJUSTED:** Sprint 11-12 includes AP/AR foundation (financial module expansion)
- **STABLE:** Sprint 0-6 MVP timeline unchanged, PIX end-to-end validation added to Sprint 6 gates

---

## B) UPDATED SPRINT TABLE

| Sprint | Focus | Key Deliverables | Owner/Financial Features |
|--------|-------|------------------|--------------------------|
| **0** | Architecture Lockdown | Finalize specs, state machines, contracts, edge function architecture | Ledger schema design, payout scheduling rules, commission tiers |
| **1** | Foundation | Schema implementation, Stripe integration, basic edge functions | Double-entry ledger tables, payment → ledger linkage |
| **2** | Host Integration | Host Connect API, availability sync, booking commit | Commission calculation on confirmation, payout_pending state |
| **3** | Payment Core | **PIX MVP**, webhook handlers, reconciliation | PIX ledger entries, IOF tax handling |
| **4** | Booking Flow | End-to-end booking, confirmation, notifications | Payout batch generation (weekly), owner notification on payout |
| **5** | Operations | Support console, exception queue, cancellation | Refund ledger reversal, cancel → refund workflow |
| **6** | MVP Launch | 10-20 properties live, monitoring, docs | **PIX E2E validation**, commission reports, payout statements |
| **7** | Portal Integration | Content API, hero banners, events | — |
| **8** | Portal Polish | Cross-linking, SEO, reviews | — |
| **9** | **Owner Dashboards** | **Owner portal, read-only dashboards, RBAC** | **Owner payout reports, KPI views, CSV exports** |
| **10** | Owner Features | Owner notifications, dispute viewing | Owner dispute read access |
| **11** | **Financial Expansion** | **AP/AR foundation, service catalog schema** | **Vendor payables, service order ledger linkage** |
| **12** | Services Prep | Service provider onboarding, invoicing hooks | Service payout workflows |

---

## C) UPDATED SECTIONS

### C.1) FINANCIAL MODULE PLAN (Extended)

#### C.1.1 Core Financial Architecture (MVP)

**Ledger Structure (Double-Entry):**
```
ledger_entries
├── entry_id (UUID, PK)
├── transaction_id (UUID, groups entries)
├── booking_id (FK, nullable for non-booking transactions)
├── property_id (FK)
├── city_code (FK, RLS scope)
├── entry_type (enum: payment_received, commission_taken, payout_due, refund_processed, gateway_fee, tax_withheld)
├── amount (decimal, positive)
├── direction (debit|credit)
├── account (enum: cash_reserve, customer_deposits, payouts_receivable, commission_revenue, etc.)
├── counterparty (customer|owner|gateway|vendor)
├── metadata (JSON)
└── created_at (timestamp)
```

**Payout Schedule Model:**
```
payout_schedules
├── schedule_id (UUID, PK)
├── entity_type (enum: 'owner', 'property')  // NEW: support per-property override
├── entity_id (UUID)  // owner_id or property_id
├── city_code (FK)
├── frequency (enum: 'weekly', 'biweekly', 'monthly', 'on_checkout')
├── day_of_week (int, 0-6, for weekly/biweekly)
├── day_of_month (int, 1-31, for monthly)
├── min_threshold (decimal, minimum amount to trigger payout)
├── hold_days (int, additional hold period)
└── is_active (boolean)
```

**Commission Rules:**
```
commission_tiers
├── tier_id (UUID, PK)
├── city_code (FK)
├── property_id (FK, nullable for default tiers)
├── min_properties (int, for volume discount)
├── max_properties (int)
├── commission_rate (decimal, 0.05-0.25)
├── effective_from (date)
└── effective_to (date, nullable)
```

#### C.1.2 Accounts Payable (AP) - Phase Ready

**Purpose:** Track obligations to service providers and vendors

**Schema Placeholders:**
```
vendor_payables  // NEW TABLE
├── payable_id (UUID, PK)
├── vendor_id (UUID, FK to service_providers)
├── city_code (FK)
├── property_id (FK, nullable)
├── reservation_id (FK, nullable)
├── service_order_id (FK, nullable)
├── amount (decimal)
├── currency (string)
├── description (text)
├── due_date (date)
├── status (enum: 'pending', 'approved', 'scheduled', 'paid', 'cancelled')
├── ledger_entry_id (UUID, FK)  // Links to ledger
├── payout_batch_id (UUID, FK, nullable)
├── approved_by (UUID, FK to users, nullable)
├── approved_at (timestamp)
├── paid_at (timestamp)
├── created_at (timestamp)
└── metadata (JSON)

service_providers  // NEW TABLE
├── provider_id (UUID, PK)
├── city_code (FK)
├── provider_type (enum: 'laundry', 'cleaning', 'transfer', 'tour', 'food', 'other')
├── name (string)
├── contact_info (JSON)
├── bank_details (JSON, encrypted)
├── commission_rate (decimal, nullable)  // If Reserve takes commission on services
├── payout_schedule_id (UUID, FK)
├── is_active (boolean)
└── created_at (timestamp)
```

**Ledger Integration:**
- When service order is fulfilled → Create `vendor_payable` entry
- Ledger entry: `debit: service_expense, credit: vendor_payables`
- On payout → Ledger entry: `debit: vendor_payables, credit: cash_reserve`

#### C.1.3 Accounts Receivable (AR) - Phase Ready

**Purpose:** Track amounts owed to Reserve (commissions, fees, services charged to guest)

**Schema Placeholders:**
```
receivables  // NEW TABLE
├── receivable_id (UUID, PK)
├── city_code (FK)
├── entity_type (enum: 'commission', 'service_fee', 'penalty', 'other')
├── entity_id (UUID)  // booking_id or service_order_id
├── property_id (FK, nullable)
├── amount (decimal)
├── currency (string)
├── description (text)
├── due_date (date)
├── status (enum: 'pending', 'invoiced', 'paid', 'written_off', 'disputed')
├── invoice_id (UUID, FK, nullable)
├── ledger_entry_id (UUID, FK)
├── created_at (timestamp)
└── metadata (JSON)

invoices  // NEW TABLE (Phase 3: NF-e integration)
├── invoice_id (UUID, PK)
├── invoice_number (string, unique)
├── city_code (FK)
├── recipient_id (UUID)  // owner_id or provider_id
├── recipient_type (enum: 'owner', 'provider', 'guest')
├── invoice_type (enum: 'commission', 'service', 'payout_summary')
├── amount (decimal)
├── tax_amount (decimal)  // NF-e tax calculation
├── total_amount (decimal)
├── status (enum: 'draft', 'issued', 'sent', 'paid', 'cancelled')
├── nf_e_number (string, nullable)  // Brazilian invoice number
├── nf_e_xml (text, nullable)  // NF-e XML storage
├── issued_at (timestamp)
└── created_at (timestamp)
```

**Ledger Integration:**
- Commission receivable on confirmation → `debit: commissions_receivable, credit: commission_revenue`
- On payout to owner (net commission) → `debit: commission_expense, credit: commissions_receivable`
- Service fee charged to guest → `debit: customer_deposits, credit: service_revenue`

#### C.1.4 Service Orders (Future Marketplace)

**Schema Placeholders:**
```
service_catalog  // NEW TABLE
├── service_id (UUID, PK)
├── city_code (FK)
├── property_id (FK, nullable)  // Property-specific service
├── provider_id (UUID, FK to service_providers)
├── service_type (enum: 'laundry', 'cleaning', 'transfer', 'tour', 'food', 'other')
├── name (string)
├── description (text)
├── pricing_type (enum: 'fixed', 'per_night', 'per_guest', 'per_km')
├── base_price (decimal)
├── currency (string)
├── is_active (boolean)
└── created_at (timestamp)

service_orders  // NEW TABLE
├── order_id (UUID, PK)
├── reservation_id (UUID, FK)
├── property_id (UUID, FK)
├── city_code (FK)
├── service_id (UUID, FK to service_catalog)
├── provider_id (UUID, FK to service_providers)
├── guest_id (UUID, FK to travelers)
├── status (enum: 'pending', 'confirmed', 'in_progress', 'fulfilled', 'cancelled', 'disputed')
├── quantity (int)
├── unit_price (decimal)
├── total_amount (decimal)
├── scheduled_date (date, nullable)
├── fulfilled_at (timestamp, nullable)
├── cancellation_reason (text, nullable)
├── ledger_entry_id (UUID, FK)
├── created_at (timestamp)
└── metadata (JSON)

service_payouts  // NEW TABLE
├── payout_id (UUID, PK)
├── provider_id (UUID, FK)
├── city_code (FK)
├── payout_batch_id (UUID, FK)
├── amount (decimal)
├── order_count (int)
├── period_start (date)
├── period_end (date)
├── status (enum: 'pending', 'processing', 'completed', 'failed')
├── gateway_reference (string, nullable)
├── processed_at (timestamp)
└── created_at (timestamp)
```

**City Code & Property Relationships:**
- All financial tables have `city_code` for RLS
- `service_orders` links to `reservation_id` for guest context
- `payouts` table handles both owner payouts and service provider payouts (discriminator: `payout_type`)
- Service provider payouts use separate schedule from owner payouts

---

### C.2) RBAC / ACCESS CONTROL (Updated)

#### C.2.1 Role Definitions (7 Roles)

| Role | Scope | Permissions | Access Level |
|------|-------|-------------|--------------|
| **Super Admin** | Global | Full system access, user management, configuration | Full CRUD |
| **City Admin** | Assigned cities | City-wide booking management, agent management, city settings | Full CRUD in city |
| **Supervisor** | Assigned cities | Booking overrides, cancellation approvals, escalations | Read + Override |
| **Agent** | Assigned cities | Booking CRUD (own), guest support, exception handling | Read + Create + Update (own) |
| **Owner** | Own properties only | Read-only access to bookings, payouts, KPIs for owned properties | Read-only |
| **Property Manager** | Assigned properties | Limited booking updates (check-in/out notes), no cancellations | Read + Limited Update |
| **System** | All | Internal operations, webhooks, batch jobs | Internal only |

#### C.2.2 Owner Role Permissions (NEW)

**Owner CAN Access:**
- [x] View all bookings for owned properties (read-only)
- [x] View booking details: guest info, dates, amounts, status
- [x] View payout statements (current and historical)
- [x] View commission reports (per booking, aggregated)
- [x] View KPI dashboards: occupancy rate, revenue, cancellation rate
- [x] View cancellation/no-show reports
- [x] Export data to CSV (bookings, payouts, commissions)
- [x] View property performance metrics
- [x] Receive notifications: new bookings, payouts processed, cancellations
- [x] View dispute/chargeback status (read-only)

**Owner CANNOT Access:**
- [ ] Cancel or modify bookings (must contact support)
- [ ] Override cancellation policies
- [ ] Process refunds
- [ ] View other properties' data (RLS enforced)
- [ ] Access guest payment details (PII restricted)
- [ ] Modify property settings (done in Host Connect)
- [ ] View city-wide aggregate data beyond own properties
- [ ] Access support console or exception queue
- [ ] Approve cancellations or refunds
- [ ] Modify commission rates or payout schedules

#### C.2.3 RBAC Matrix

| Permission | Super Admin | City Admin | Supervisor | Agent | Owner | Property Manager | System |
|------------|-------------|------------|------------|-------|-------|------------------|--------|
| View all bookings (city) | ✓ | ✓ | ✓ | ✓ | — | — | ✓ |
| View own bookings | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create booking | ✓ | ✓ | ✓ | ✓ | — | — | ✓ |
| Modify booking | ✓ | ✓ | ✓ | ✓ (own) | — | Limited | ✓ |
| Cancel booking | ✓ | ✓ | ✓ | ✓ | — | — | ✓ |
| Process refund | ✓ | ✓ | ✓ | — | — | — | ✓ |
| Override policy | ✓ | ✓ | ✓ | — | — | — | — |
| View payouts | ✓ | ✓ | ✓ | ✓ | ✓ (own) | — | ✓ |
| View commissions | ✓ | ✓ | ✓ | ✓ | ✓ (own) | — | ✓ |
| View KPIs | ✓ | ✓ | ✓ | ✓ | ✓ (own) | — | ✓ |
| Export reports | ✓ | ✓ | ✓ | ✓ | ✓ (own) | — | ✓ |
| Manage users | ✓ | ✓ | — | — | — | — | — |
| System config | ✓ | — | — | — | — | — | ✓ |

#### C.2.4 Owner Dashboard Portal (Sprint 9-10)

**URL Structure:**
- `/owner/login` - Owner authentication (separate from admin console)
- `/owner/dashboard` - Overview: active bookings, revenue MTD, upcoming payouts
- `/owner/bookings` - Booking list with filters (date, status, property)
- `/owner/bookings/:id` - Booking detail view (read-only)
- `/owner/payouts` - Payout history and upcoming payouts
- `/owner/reports` - KPIs and exportable reports
- `/owner/properties` - Property list (links to Host Connect for management)

**Data Isolation:**
```sql
-- RLS Policy for Owner Access
CREATE POLICY owner_property_isolation ON bookings
  FOR SELECT
  USING (
    property_id IN (
      SELECT property_id FROM property_owners 
      WHERE owner_id = current_user_id()
    )
  );
```

---

### C.3) SCHEMA PLACEHOLDERS (Future-Ready)

#### C.3.1 New Tables Summary

**For AP/AR (Sprint 11):**
| Table | Purpose | City Code | Key Relationships |
|-------|---------|-----------|-------------------|
| `vendor_payables` | Track obligations to vendors | ✓ | Links to ledger_entries, payout_batches |
| `receivables` | Track amounts owed to Reserve | ✓ | Links to bookings, service_orders |
| `invoices` | Invoice records (NF-e ready) | ✓ | Links to receivables, payouts |
| `service_providers` | Vendor directory | ✓ | Independent from properties |

**For Services Marketplace (Sprint 12):**
| Table | Purpose | City Code | Key Relationships |
|-------|---------|-----------|-------------------|
| `service_catalog` | Available services per city/property | ✓ | Links to service_providers |
| `service_orders` | Guest service requests | ✓ | Links to reservations, providers |
| `service_payouts` | Provider payment tracking | ✓ | Links to payout_batches |

**For Owner Access (Sprint 9-10):**
| Table | Purpose | City Code | Key Relationships |
|-------|---------|-----------|-------------------|
| `property_owners` | Owner-property mappings | ✓ | Many-to-many: owners ↔ properties |
| `owner_sessions` | Owner portal sessions | ✓ | Separate from admin sessions |
| `owner_notifications` | Owner-specific notifications | ✓ | Links to properties |

#### C.3.2 Key Columns & Constraints

**Ledger Entries Enhancement:**
```sql
-- Add entity_type discriminator for non-booking transactions
ALTER TABLE ledger_entries ADD COLUMN entity_type 
  ENUM('booking', 'service_order', 'vendor_payable', 'adjustment') 
  DEFAULT 'booking';

-- Add nullable foreign keys for future entities
ALTER TABLE ledger_entries ADD COLUMN service_order_id UUID NULL;
ALTER TABLE ledger_entries ADD COLUMN vendor_payable_id UUID NULL;
```

**Payout Batches Enhancement:**
```sql
-- Support multiple payout types
ALTER TABLE payouts ADD COLUMN payout_type 
  ENUM('owner', 'service_provider') DEFAULT 'owner';

-- Link to vendor_payables for AP
ALTER TABLE vendor_payables ADD COLUMN payout_batch_id UUID NULL;
```

---

### C.4) CONSISTENCY AUDIT

#### C.4.1 Conflicts Identified & Resolutions

| Conflict | Location | Issue | Resolution | Applied In |
|----------|----------|-------|------------|------------|
| **1. Commission Timing** | Operational Blueprint vs Architecture Spec | Blueprint implied post-stay commission | Architecture Spec (Sprint 0) clearly states commission captured at confirmation | **No change needed** - Architecture Spec is correct |
| **2. PIX Phase** | Operational Blueprint (Open Question #7) | "PIX Integration: Critical for Brazil market - implement in MVP or Phase 2?" | **NEW REQUIREMENT C forces MVP** - PIX moved to Sprint 3 | **Updated Sprint Table** |
| **3. Check-in/out Ownership** | Operational Blueprint implied dual ownership | "Property updates check-in status" could mean via Reserve console | **NEW REQUIREMENT C clarifies** - Check-in/out is Host Connect exclusive | **Clarified in Architecture Spec Section 1B** - Host Connect webhook triggers state transitions |
| **4. Payout Schedule** | Architecture Spec shows weekly default | No mention of property-specific overrides | **NEW REQUIREMENT A requires overrides** - Property-specific schedule capability added | **Updated Financial Module Plan Section C.1.1** |
| **5. Owner Access** | Architecture Spec RBAC lists "owner" role but limited detail | No explicit dashboard requirements | **NEW REQUIREMENT E mandates** - Detailed Owner permissions and portal defined | **Updated RBAC Section C.2** |
| **6. Service Orders** | Not present in Architecture Spec | No schema for services | **NEW REQUIREMENT D future-readiness** - Schema placeholders added for Sprint 11-12 | **Added Schema Placeholders Section C.3** |

#### C.4.2 Corrections Applied

**File: docs/ARCHITECTURE_SPEC.md**
- **Section 1B (Reservation State Machine):** Added explicit note that `checked_in` and `checked_out` are triggered by Host Connect webhooks only
- **Section 3D (Payout Scheduling):** Added property-specific override capability to interface definition
- **Section 4E (RBAC):** Added Owner role detail to Access Control Matrix (was already present, now expanded in MASTER_EXECUTION_PLAN)

**File: docs/MASTER_EXECUTION_PLAN.md** (this document)
- **Sprint 3:** Added PIX end-to-end implementation
- **Sprint 9-10:** Expanded to Owner Dashboards with explicit read-only requirements
- **Sprint 11-12:** Added AP/AR and Services Marketplace phase-ready deliverables

#### C.4.3 No Changes Required to Architecture Spec

The following invariants from Sprint 0 remain valid and unchanged:
- ✓ Payment-first model (payment confirmed BEFORE host commit)
- ✓ Booking state machine states and transitions
- ✓ Failure states: `host_commit_failed`, `refund_pending`, `cancel_pending`
- ✓ Idempotency approach (UUID-based keys, Redis 24h TTL)
- ✓ Multi-tenancy via `city_code` + RLS
- ✓ Double-entry ledger structure
- ✓ Edge function architecture patterns

---

## D) DELIVERABLE CHECKLIST (Sprints 0-6)

### Sprint 0: Architecture Lockdown

#### Definition of Done
- [ ] All state machines documented with transition tables
- [ ] Payment architecture (Stripe + PIX) fully specified
- [ ] Financial model (ledger, commission, payout) defined
- [ ] Multi-tenancy and RLS strategy documented
- [ ] Edge function architecture overview complete
- [ ] Event model for KPIs defined
- [ ] Integration contracts (Host, Portal) finalized
- [ ] Database schema approved (no SQL implementation yet)

#### Acceptance Tests
- [ ] Architecture Spec passes peer review
- [ ] State machine covers all edge cases (TTL expiry, payment failure, host timeout)
- [ ] PIX flow documented: QR generation → polling → webhook → reconciliation
- [ ] Ledger double-entry balances for all transaction types
- [ ] RLS policies prevent cross-city access in all scenarios
- [ ] Event schema supports all required KPIs

---

### Sprint 1: Foundation

#### Definition of Done
- [ ] Database schema implemented (migrations)
- [ ] Core tables: cities, properties, units, bookings, payments, ledger
- [ ] Stripe integration: Payment Intents, webhooks
- [ ] Basic edge functions: search, booking intent
- [ ] RLS policies applied to all city-scoped tables
- [ ] Local dev environment with seeded test data

#### Acceptance Tests
- [ ] `SELECT * FROM bookings` with RLS returns only authorized city data
- [ ] Stripe test payment creates ledger entries (balanced debits/credits)
- [ ] Booking intent TTL expires correctly (Redis)
- [ ] Search returns properties with availability
- [ ] Unit tests pass: payment creation, ledger balance validation

---

### Sprint 2: Host Integration

#### Definition of Done
- [ ] Host Connect API client implemented
- [ ] Availability sync: Reserve queries Host on search
- [ ] Booking commit: `POST /api/v1/bookings` with idempotency
- [ ] Webhook endpoint: Host → Reserve status updates
- [ ] Commission calculation on confirmation
- [ ] Exception queue for host failures

#### Acceptance Tests
- [ ] End-to-end: Search → Intent → Payment → Host Commit → Confirmed
- [ ] Host timeout triggers retry (3 attempts)
- [ ] Host rejection triggers `host_commit_failed` → refund flow
- [ ] Duplicate idempotency key returns existing booking (no duplicate)
- [ ] Commission ledger entry created on `confirmed` state
- [ ] Exception queue shows failed commits with retry/cancel options

---

### Sprint 3: Payment Core (PIX MVP)

#### Definition of Done
- [ ] PIX provider abstraction layer
- [ ] QR code generation endpoint
- [ ] PIX webhook handler
- [ ] Client-side polling for PIX status
- [ ] PIX reconciliation job (hourly)
- [ ] IOF tax (0.38%) handling in ledger
- [ ] PIX expiration handling (15 min TTL)

#### Acceptance Tests
**PIX QR Generation:**
- [ ] POST `/payment/pix/create` returns QR code + copy-paste key
- [ ] Inventory held for 15 minutes after QR generation
- [ ] QR includes correct amount, description, expiration

**PIX Payment Confirmation:**
- [ ] Webhook `pix.paid` updates payment status to `succeeded`
- [ ] Polling endpoint returns current status
- [ ] Payment succeeds → triggers host commit

**PIX Refund Flow:**
- [ ] Host commit failure after PIX payment triggers refund
- [ ] Refund ledger entries balance (reverse payment entries)
- [ ] Guest receives refund confirmation

**PIX Reconciliation:**
- [ ] Hourly job detects missed webhooks
- [ ] Reconciliation updates mismatched statuses
- [ ] Ledger integrity maintained after reconciliation

---

### Sprint 4: Booking Flow

#### Definition of Done
- [ ] End-to-end booking UI: Search → Property → Booking Form → Payment
- [ ] Guest confirmation email (HTML + PDF receipt)
- [ ] Property notification (email + system inbox)
- [ ] Payout batch generation (weekly schedule)
- [ ] Owner notification on payout scheduled
- [ ] Soft/hard inventory holds

#### Acceptance Tests
- [ ] Guest completes booking in < 5 minutes
- [ ] Confirmation email sent within 30 seconds of payment
- [ ] Property receives notification within 1 minute
- [ ] Payout batch created for completed stays
- [ ] Inventory blocked in Host Connect after confirmation
- [ ] Soft hold released after 15 minutes if no payment

---

### Sprint 5: Operations

#### Definition of Done
- [ ] Support console: booking search, view, cancel
- [ ] Exception queue management UI
- [ ] Cancellation with policy enforcement
- [ ] Refund processing (Stripe + PIX)
- [ ] Ledger reversal on cancellation
- [ ] Audit trail for all operations

#### Acceptance Tests
- [ ] Agent can search bookings by code, email, property
- [ ] Cancellation applies policy rules (24h/48h/72h free)
- [ ] Refund processed within 24 hours
- [ ] Ledger shows reversal entries for cancelled booking
- [ ] Exception queue shows age, priority, resolution actions
- [ ] Audit log records: who, what, when, before/after

---

### Sprint 6: MVP Launch

#### Definition of Done
- [ ] 10-20 properties onboarded and synced
- [ ] Monitoring dashboards active (conversion, health, revenue)
- [ ] PagerDuty alerts configured
- [ ] Documentation: SOPs, runbooks, API docs
- [ ] Security audit passed
- [ ] Load testing: 100 concurrent users

#### Acceptance Tests - Core
- [ ] Search results load in < 2 seconds
- [ ] Payment success rate > 85%
- [ ] Host commit success rate > 99%
- [ ] Email delivery rate > 98%
- [ ] Zero data loss in 7-day test period

#### Acceptance Tests - PIX End-to-End Validation
**Test 1: PIX Happy Path**
```
1. Guest searches properties in Urubici
2. Selects property, creates booking intent
3. Chooses PIX payment
4. System generates QR code (15 min expiry)
5. Guest pays via PIX (mobile banking app)
6. Webhook received: payment confirmed
7. Host commit triggered: booking confirmed in Host
8. Guest receives confirmation email
9. Property receives notification
10. Ledger entries created: payment, commission, payout due
11. Checkout date passes + 24h
12. Payout batch includes this booking
13. Owner receives payout (net amount after commission)
```

**Test 2: PIX Expiration**
```
1. Guest generates PIX QR
2. Does not pay within 15 minutes
3. System expires PIX charge
4. Inventory released
5. Booking intent cancelled
6. No ledger entries created
```

**Test 3: PIX Host Commit Failure**
```
1. Guest pays via PIX
2. Payment confirmed
3. Host commit fails (timeout × 3)
4. System marks reservation: host_commit_failed
5. Refund triggered automatically
6. Guest receives refund in 5-10 days
7. Ledger shows: payment → refund reversal
8. Guest receives apology email
```

**Test 4: PIX Reconciliation**
```
1. Guest pays via PIX
2. Webhook delivery fails (network issue)
3. Payment shows as 'pending' in Reserve
4. Hourly reconciliation job queries provider
5. Provider confirms payment
6. Reserve updates status → triggers host commit
7. Booking proceeds normally
```

**Test 5: PIX + Stripe Mixed**
```
1. Property 1 accepts PIX
2. Property 2 accepts Cards only
3. Guest can pay with appropriate method per property
4. Ledger tracks gateway fees separately (PIX IOF vs Stripe %)
5. Payouts processed correctly regardless of payment method
```

---

## E) AUDIT + RISKS (Top 10)

### Risk 1: PIX Integration Complexity
**Impact:** High | **Likelihood:** Medium  
**Description:** PIX requires webhook + polling + reconciliation, more complex than Stripe alone.  
**Mitigation:** 
- Hybrid approach (webhook primary, polling backup)
- Hourly reconciliation job catches missed webhooks
- Comprehensive PIX E2E tests in Sprint 6 checklist
- Fallback: Manual reconciliation dashboard for ops team

### Risk 2: Host Connect Downtime
**Impact:** Critical | **Likelihood:** Medium  
**Description:** Host API failures block booking confirmation after payment.  
**Mitigation:**
- Circuit breaker pattern (5 failures in 60s → OPEN)
- Queue bookings for retry (3 attempts with exponential backoff)
- Exception queue for manual resolution
- Automatic refund if host permanently down > 30 min
- Guest communication: "Processing delay, will confirm within 1 hour"

### Risk 3: Double-Booking Race Condition
**Impact:** High | **Likelihood:** Low  
**Description:** Two guests book same room simultaneously, both payments succeed.  
**Mitigation:**
- Soft hold during payment (15 min TTL)
- Idempotency key on Host commit
- Host Connect validates availability before confirming
- If double-booking detected → cancel 2nd booking + refund + escalate
- Post-booking validation via webhook (detect within 5 min)

### Risk 4: Cross-City Data Leakage
**Impact:** Critical | **Likelihood:** Low  
**Description:** Owner/agent sees data from other cities.  
**Mitigation:**
- RLS policies on all city-scoped tables (database level)
- JWT claims include authorized cities
- Application-level validation middleware
- URL structure: `/api/v1/{city_code}/...`
- Security audit: penetration testing for city isolation

### Risk 5: Owner Dashboard Scope Creep
**Impact:** Medium | **Likelihood:** High  
**Description:** Owners request write access (cancel bookings, change prices).  
**Mitigation:**
- **Explicit constraint:** Owner portal is read-only (Sprint 0 architecture freeze)
- Clear RBAC: Owner ≠ Property Manager
- Feature requests go to Phase 2+ evaluation
- Redirect to Host Connect for operational changes

### Risk 6: Financial Ledger Integrity
**Impact:** Critical | **Likelihood:** Low  
**Description:** Ledger entries don't balance, accounting discrepancies.  
**Mitigation:**
- Database constraint: SUM(debits) = SUM(credits) per transaction_id
- Daily reconciliation job: ledger vs gateway records
- Audit trail for all financial events
- Alert on any imbalance (PagerDuty)
- Monthly financial audit by accounting team

### Risk 7: Refund Processing Delays
**Impact:** High | **Likelihood:** Medium  
**Description:** Refunds take longer than promised (5-10 days), customer complaints.  
**Mitigation:**
- Stripe refunds: immediate (1-5 days to customer account)
- PIX refunds: provider-dependent, set expectations clearly
- Automated refund queue with retry
- Dashboard for ops team to track refund status
- Proactive customer communication on refund timeline

### Risk 8: Services Marketplace Complexity
**Impact:** Medium | **Likelihood:** High  
**Description:** AP/AR and service orders add significant complexity for Phase 3.  
**Mitigation:**
- Schema placeholders in Sprint 11 (no implementation)
- Ledger designed with extensibility (entity_type discriminator)
- Clear separation: MVP = bookings only, Phase 3 = services
- Evaluate marketplace need based on MVP traction
- Alternative: Manual service booking via support console (Phase 2)

### Risk 9: Multi-Tenancy Performance
**Impact:** Medium | **Likelihood:** Medium  
**Description:** RLS policies slow down queries at scale.  
**Mitigation:**
- Index on city_code for all scoped tables
- Query planner optimization
- Connection pooling
- Read replicas for reporting queries
- Cache frequently accessed data per city

### Risk 10: Commission Calculation Errors
**Impact:** High | **Likelihood:** Medium  
**Description:** Wrong commission rate applied (should be 15%, charged 10%).  
**Mitigation:**
- Commission rules engine with clear precedence:
  1. Property override (if set)
  2. Owner volume tier
  3. Default city rate
- Unit tests for all commission scenarios
- Commission preview shown to agent before confirmation
- Monthly commission reconciliation report
- Easy adjustment process for errors

---

## F) ORCHESTRATOR REVIEW CHECKLIST

**READY FOR ORCHESTRATOR REVIEW**

The following items must be validated by the Orquestrador before proceeding to Sprint 1:

### Architecture Consistency
- [ ] **Sprint 0 Freeze Intact:** Confirm no changes to state machines, payment architecture, or core invariants
- [ ] **Payment-First Model:** Verify payment confirmed BEFORE host commit in all flows
- [ ] **Failure States:** Confirm `host_commit_failed`, `refund_pending`, `cancel_pending` states present
- [ ] **Idempotency:** Verify UUID-based idempotency keys defined for all critical operations
- [ ] **City Isolation:** Confirm `city_code` RLS strategy covers all MVP tables

### New Requirements Validation
- [ ] **MoR Model:** Confirm "cobra e repassa" documented (Reserve collects, keeps commission, repasses net)
- [ ] **PIX in MVP:** Verify PIX moved to Sprint 3 with full E2E tests in Sprint 6
- [ ] **Host Connect Ownership:** Confirm check-in/out lifecycle is Host Connect exclusive (Reserve only receives webhooks)
- [ ] **Owner Access:** Verify Owner role defined with read-only dashboards (Sprint 9-10)
- [ ] **Future-Readiness:** Confirm AP/AR schema placeholders present (no implementation required yet)

### Sprint Planning
- [ ] **Sprint Balance:** Verify Sprints 0-6 remain viable for MVP with PIX added
- [ ] **Owner Dashboards:** Confirm Sprint 9-10 scope includes read-only dashboards + RBAC
- [ ] **Financial Expansion:** Verify Sprint 11-12 includes AP/AR foundation
- [ ] **Dependencies:** Check no circular dependencies between sprints

### Risk Assessment
- [ ] **Top 10 Risks:** Review risk list, confirm mitigations adequate
- [ ] **PIX Complexity:** Validate hybrid webhook/polling/reconciliation approach
- [ ] **Host Downtime:** Confirm circuit breaker + exception queue strategy
- [ ] **Financial Integrity:** Verify ledger balancing constraints

### Acceptance Criteria
- [ ] **PIX E2E Tests:** Review 5 PIX test scenarios in Sprint 6 checklist
- [ ] **Definition of Done:** Verify all sprints have clear DoD
- [ ] **Audit Trail:** Confirm audit logging requirement for all operations

### Stakeholder Sign-Off Required
- [ ] **CEO/COO:** Approve Owner access scope (read-only constraint)
- [ ] **CTO:** Approve PIX integration approach and technical risks
- [ ] **CFO:** Approve MoR financial model and payout schedules
- [ ] **Head of Operations:** Approve Host Connect integration boundaries

---

**Document Status:** READY FOR REVIEW  
**Next Step:** Orquestrador validation → Stakeholder sign-off → Sprint 1 kickoff

---

*End of MASTER EXECUTION PLAN v1.2*
