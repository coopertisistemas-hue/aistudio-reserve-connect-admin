# RESERVE CONNECT - SPRINT 0 ARCHITECTURE LOCKDOWN
## Comprehensive System Specification

**Version:** 1.0.0  
**Status:** ARCHITECTURE FREEZE  
**Date:** 2026-02-15  
**Classification:** Implementation-Ready

---

## Table of Contents
1. [Booking State Machine Final Spec](#1-booking-state-machine-final-spec)
2. [Payment Architecture Spec](#2-payment-architecture-spec)
3. [Merchant-of-Record Financial Model](#3-merchant-of-record-financial-model)
4. [Multi-Tenancy & RLS Strategy](#4-multi-tenancy--rls-strategy)
5. [Edge Function Architecture Overview](#5-edge-function-architecture-overview)
6. [Event Model](#6-event-model)

---

# 1. BOOKING STATE MACHINE FINAL SPEC

## 1A. BOOKING_INTENT State Machine

### Allowed States
| State | Description | Persistence |
|-------|-------------|-------------|
| `intent_created` | Initial state, customer has selected dates/property | In-memory + Redis cache |
| `payment_pending` | Payment method selected, awaiting gateway response | Persistent |
| `payment_confirmed` | Gateway confirmed funds received | Persistent |
| `converted` | Successfully converted to reservation | Persistent |
| `expired` | TTL reached without completion | Persistent (audit) |
| `cancelled` | Customer or system cancelled before conversion | Persistent (audit) |

### State Transitions

```
intent_created
    ├── payment_pending (customer initiates payment)
    ├── expired (TTL: 15 min reached)
    └── cancelled (customer action)

payment_pending
    ├── payment_confirmed (webhook: payment_intent.succeeded)
    ├── cancelled (customer action)
    └── expired (TTL: 30 min reached)

payment_confirmed
    ├── converted (host_commit success)
    ├── refund_pending (host_commit failure)
    └── expired (TTL: 5 min - failsafe)

converted
    └── [terminal state]

expired
    └── [terminal state]

cancelled
    └── [terminal state]
```

### Timeout Rules (TTL Behavior)

| State | TTL | Action on Expiry | Retry Allowed |
|-------|-----|------------------|---------------|
| intent_created | 15 minutes | Auto-cancel | Yes (new intent) |
| payment_pending | 30 minutes | Auto-cancel + release inventory | No |
| payment_confirmed | 5 minutes | Trigger refund if not converted | System only |
| converted | N/A | N/A | N/A |

### TTL Implementation Strategy
- **Redis TTL** for active intents
- **Scheduled job** (pg_cron) for edge cases
- **Idempotent expiry handlers** to prevent double-processing

### Automatic Transitions
1. **TTL expiry** → `expired` state (system-triggered)
2. **Payment webhook** → `payment_confirmed` (async)
3. **Host timeout** → `refund_pending` (system-triggered)

### Edge Cases

| Scenario | Handling |
|----------|----------|
| Payment succeeds after TTL | Reject webhook, trigger refund automatically |
| Duplicate payment intent | Idempotency key prevents double-charge |
| Customer refreshes page | Resume from current state using session_token |
| Network failure mid-payment | Polling endpoint checks status, resume or timeout |
| Host system down during commit | Queue retry (3 attempts, exponential backoff) |

---

## 1B. RESERVATION State Machine

### Allowed States
| State | Description | Actor |
|-------|-------------|-------|
| `host_commit_pending` | Payment confirmed, awaiting Host Connect confirmation | System |
| `host_commit_failed` | Host system rejected booking | System |
| `confirmed` | Host confirmed, booking active | System |
| `checkin_pending` | Date reached, awaiting check-in | System |
| `checked_in` | Guest checked in via Host Connect | Host Connect |
| `checked_out` | Guest checked out | Host Connect |
| `completed` | Stay finished, payout pending | System |
| `cancel_pending` | Cancellation requested | Customer/Agent |
| `cancelled` | Booking cancelled | System |
| `refund_pending` | Refund being processed | System |
| `refunded` | Funds returned to customer | System |
| `payout_pending` | Funds held, awaiting payout schedule | System |
| `paid_out` | Owner received payout | System |

### Full Lifecycle Transitions

```
host_commit_pending
    ├── host_commit_failed (Host Connect rejects)
    └── confirmed (Host Connect accepts)

host_commit_failed
    └── refund_pending (automatic trigger)

confirmed
    ├── checkin_pending (date reached - cron)
    ├── cancel_pending (customer/agent request)
    └── cancelled (no-show policy trigger)

checkin_pending
    ├── checked_in (Host Connect webhook)
    └── cancelled (no-show)

checked_in
    └── checked_out (Host Connect webhook)

checked_out
    ├── completed (system)
    └── cancel_pending (edge case: dispute)

completed
    ├── payout_pending (system)
    └── refunded (post-completion dispute)

cancel_pending
    ├── cancelled (approved)
    └── confirmed (rejected - back to active)

cancelled
    ├── refund_pending (if payment made)
    └── [terminal state]

refund_pending
    ├── refunded (gateway confirms)
    └── refund_failed (manual intervention needed)

payout_pending
    ├── paid_out (scheduled payout executed)
    └── refunded (dispute/chargeback)
```

### Relationship with Payment State

| Reservation State | Required Payment State | Invariant |
|-------------------|------------------------|-----------|
| host_commit_pending | payment_confirmed | Payment must precede commit |
| confirmed | payment_confirmed | Immutable |
| refund_pending | refund_initiated | Refund amount ≤ payment |
| cancelled | any terminal | Cancellation independent of payment |

### Trigger Matrix

| Transition | Trigger | Actor | SLA |
|------------|---------|-------|-----|
| host_commit_pending → confirmed | Host Connect API success | System | < 5s |
| host_commit_pending → host_commit_failed | Host Connect API failure | System | < 5s |
| confirmed → checkin_pending | Cron: checkin_date reached | System | Daily 00:00 |
| checkin_pending → checked_in | Host Connect webhook | Host | Real-time |
| any → cancel_pending | POST /cancel | Customer/Agent | < 1s |
| cancel_pending → cancelled | Policy check passes | System | < 5s |
| completed → payout_pending | checkout_date + 24h | System | Daily |

### System vs Agent Triggered

**SYSTEM-ONLY:**
- host_commit_pending → confirmed
- host_commit_pending → host_commit_failed
- confirmed → checkin_pending
- checkin_pending → checked_in
- checked_out → completed
- completed → payout_pending

**AGENT-TRIGGERED:**
- cancel_pending (initiated by customer/agent)
- checked_in (Host Connect webhook acts as agent)
- checked_out (Host Connect webhook acts as agent)

**BOTH:**
- cancel_pending → cancelled (system evaluates policy)
- cancel_pending → confirmed (manual override by supervisor)

### Transition Table Matrix

| From/To | host_commit_pending | host_commit_failed | confirmed | cancel_pending | cancelled | refund_pending | payout_pending | paid_out |
|---------|---------------------|--------------------|-----------|----------------|-----------|----------------|----------------|----------|
| **intent_converted** | ✓ | - | - | - | - | - | - | - |
| **host_commit_pending** | - | ✓ | ✓ | - | - | - | - | - |
| **host_commit_failed** | - | - | - | - | - | ✓ | - | - |
| **confirmed** | - | - | - | ✓ | ✓* | - | - | - |
| **checkin_pending** | - | - | - | ✓ | ✓ | - | - | - |
| **checked_in** | - | - | - | - | - | - | - | - |
| **checked_out** | - | - | - | - | - | - | - | - |
| **completed** | - | - | - | - | - | ✓ | ✓ | - |
| **cancel_pending** | - | - | ✓** | - | ✓ | - | - | - |
| **cancelled** | - | - | - | - | - | ✓*** | - | - |

*No-show cancellation  
**Rejection of cancellation request  
***If payment was made

---

# 2. PAYMENT ARCHITECTURE SPEC

## 2A. STRIPE (Card) Flow

### Payment Intent Lifecycle

```
[Create Intent]
    ↓
payment_intent.created (reserve)
    ↓
[Customer enters card]
    ↓
payment_intent.requires_action (3DS if needed)
    ↓
[Authentication complete]
    ↓
payment_intent.succeeded OR payment_intent.payment_failed
    ↓
[Webhook processing]
    ↓
[Update booking_intent state]
```

### Webhook Events Used

| Event | Action | Idempotency |
|-------|--------|-------------|
| `payment_intent.created` | Log only | Key: pi_id |
| `payment_intent.requires_action` | Update UI state | Key: pi_id |
| `payment_intent.succeeded` | Confirm payment, trigger host commit | Key: pi_id + timestamp |
| `payment_intent.payment_failed` | Release inventory, notify customer | Key: pi_id |
| `charge.refunded` | Update ledger, mark refunded | Key: charge_id |
| `charge.dispute.created` | Alert admin, freeze payout | Key: dispute_id |
| `charge.dispute.closed` | Update ledger, release/adjust | Key: dispute_id |
| `payout.paid` | Reconcile ledger | Key: payout_id |

### Failure Handling

| Failure Type | Retry Strategy | Customer Experience |
|--------------|----------------|---------------------|
| Card declined | 1 retry allowed, different card | Inline error message |
| 3DS failed | 2 retries, then cancel | Modal with retry button |
| Network timeout | Idempotent retry (max 3) | Loading spinner, auto-retry |
| Webhook timeout | Queue for retry (exponential) | Silent, system handles |
| Duplicate idempotency key | Return existing response | Seamless |

### Idempotency Approach

**Strategy:** UUID-based idempotency keys

```
Key Format: {booking_intent_id}:{action}:{timestamp}
Example: bi_12345:create:1708000000

Storage: Redis (24h TTL)
Collision: Return cached response
Scope: Per-action (create, confirm, refund)
```

**Implementation Rules:**
1. Generate key on client before API call
2. Include in Stripe `Idempotency-Key` header
3. Store mapping: key → result for 24h
4. On collision, return stored result

---

## 2B. PIX Flow

### Provider Model (Generic Abstraction)

```
┌─────────────────────────────────────┐
│     Payment Gateway Interface       │
├─────────────────────────────────────┤
│ + createPixCharge(intent)           │
│ + checkPixStatus(charge_id)         │
│ + cancelPixCharge(charge_id)        │
│ + handleWebhook(payload)            │
└─────────────────────────────────────┘
                  ↑
    ┌─────────────┼─────────────┐
    ↓             ↓             ↓
┌────────┐   ┌────────┐   ┌────────┐
│Stripe PIX│   │MercadoPago│   │OpenPIX │
└────────┘   └────────┘   └────────┘
```

### QR Generation Flow

```
1. Customer selects PIX
   ↓
2. POST /payment/pix/create
   ↓
3. Reserve inventory (TTL: 15 min)
   ↓
4. Call provider: createPixCharge()
   - amount
   - description
   - expires_at (15 min)
   - idempotency_key
   ↓
5. Receive: pix_id, qr_code_base64, copy_paste_key
   ↓
6. Store: pix_charges table
   ↓
7. Return to customer: QR + copy-paste
   ↓
8. Start polling (5s intervals)
```

### Expiration Handling

| Stage | TTL | Action |
|-------|-----|--------|
| QR generation | 15 min | Auto-cancel if not paid |
| Pending payment | 15 min | Release inventory |
| After payment | 5 min | Must convert to reservation |

**Expiry Scenarios:**
1. **Customer doesn't pay:** Cron job cleans expired PIX charges
2. **Pays after expiry:** Provider rejects, customer must restart
3. **Pays at exact expiry:** Race condition handled by idempotency

### Webhook vs Polling Strategy

**Hybrid Approach:**

```
┌─────────────────────────────────────┐
│         Client Browser              │
│  ┌─────────────────────────────┐   │
│  │  Poll every 5 seconds       │   │
│  │  GET /payment/status        │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
                  ↑
                  │ Check DB
                  ↓
┌─────────────────────────────────────┐
│         Reserve Connect             │
│  ┌─────────────────────────────┐   │
│  │  Webhook endpoint           │   │
│  │  POST /webhooks/pix         │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
                  ↑
                  │ Provider webhook
                  ↓
┌─────────────────────────────────────┐
│          PIX Provider               │
└─────────────────────────────────────┘
```

**Priority:**
1. Webhook updates status immediately
2. Polling catches missed webhooks
3. Cron job reconciles discrepancies (hourly)

### Reconciliation Approach

**Daily Reconciliation Job:**
```
For each pix_charge in last 24h:
  If status == 'pending':
    Query provider API for current status
    If provider says 'paid' but we don't:
      → Trigger payment_confirmed flow
    If provider says 'expired' and we show 'pending':
      → Update to expired, release inventory
```

---

## 2C. Payment Status Enum

```typescript
enum PaymentStatus {
  // Initial states
  PENDING = 'pending',           // Awaiting customer action
  PROCESSING = 'processing',     // Gateway handling
  
  // Success states
  SUCCEEDED = 'succeeded',       // Funds captured
  
  // Failure states
  FAILED = 'failed',             // Card declined, etc.
  CANCELLED = 'cancelled',       // Customer cancelled
  EXPIRED = 'expired',           // TTL reached
  
  // Refund states
  REFUND_PENDING = 'refund_pending',
  REFUNDED = 'refunded',
  PARTIALLY_REFUNDED = 'partially_refunded',
  
  // Dispute states
  DISPUTED = 'disputed',
  DISPUTE_WON = 'dispute_won',
  DISPUTE_LOST = 'dispute_lost'
}
```

---

## 2D. Gateway State Mapping

### Stripe Mapping

| Stripe State | Internal State | Action |
|--------------|----------------|--------|
| `requires_payment_method` | PENDING | Awaiting card input |
| `requires_confirmation` | PROCESSING | Processing payment |
| `requires_action` | PROCESSING | 3DS in progress |
| `processing` | PROCESSING | Async processing |
| `succeeded` | SUCCEEDED | Trigger host commit |
| `canceled` | CANCELLED | Release inventory |
| `payment_failed` | FAILED | Notify customer |

### PIX Mapping (Generic)

| Provider State | Internal State | Action |
|----------------|----------------|--------|
| `pending` | PENDING | Show QR code |
| `paid` | SUCCEEDED | Trigger host commit |
| `expired` | EXPIRED | Release inventory |
| `cancelled` | CANCELLED | Cleanup |

---

## 2E. Failure Scenarios

### Scenario: Payment Succeeded but Host Commit Failed

```
Flow:
1. Payment webhook received → SUCCEEDED
2. Trigger host_commit to Host Connect
3. Host Connect returns 5xx or timeout
4. Retry 3 times with exponential backoff
5. All retries failed

Resolution:
┌────────────────────────────────────────────┐
│ 1. Mark reservation: host_commit_failed    │
│ 2. Create ledger entry: refund_pending     │
│ 3. Initiate refund via gateway             │
│ 4. Notify customer: full refund in 5-10d   │
│ 5. Release inventory                       │
│ 6. Alert ops team for host system review   │
└────────────────────────────────────────────┘
```

### Refund Triggers and States

| Trigger | Refund Amount | State Flow |
|---------|---------------|------------|
| Host commit failed | 100% | payment → refund_pending → refunded |
| Customer cancellation | Policy-based % | cancel_pending → cancelled → refund_pending |
| No-show | 0% (full charge) | checkin_pending → cancelled |
| Dispute | 100% + fee | disputed → dispute_lost → refunded |
| Admin override | Variable | manual → refund_pending |

---

# 3. MERCHANT-OF-RECORD FINANCIAL MODEL

## 3A. Ledger Structure (Double-Entry)

### Core Principle
Every financial event generates **balanced entries**: Debits = Credits

```
Ledger Entry Structure:
┌─────────────────────────────────────────┐
│ entry_id (UUID, PK)                     │
│ transaction_id (UUID, groups entries)    │
│ booking_id (FK)                         │
│ property_id (FK)                        │
│ city_code (FK)                          │
│ entry_type (enum)                       │
│ amount (decimal, positive)              │
│ direction (debit|credit)                │
│ account (enum)                          │
│ counterparty (customer|owner|gateway)   │
│ metadata (JSON)                         │
│ created_at (timestamp)                  │
└─────────────────────────────────────────┘

Constraint: For every transaction_id, SUM(debits) = SUM(credits)
```

### Account Structure

**Asset Accounts (Debit = +, Credit = -):**
- `cash_reserve` - Holding account for customer funds
- `merchant_account` - Operating account (Stripe/PIX)
- `payouts_receivable` - Amounts owed to property owners
- `gateway_fees_receivable` - Fees to be paid to gateways

**Liability Accounts (Debit = -, Credit = +):**
- `customer_deposits` - Funds held for customers
- `refunds_payable` - Refunds owed to customers
- `commissions_payable` - Commissions held

**Revenue Accounts (Credit = +):**
- `commission_revenue` - Earned commission
- `gateway_fee_expense` - Cost of payment processing

---

## 3B. Entry Taxonomy

### Payment Received
```
Transaction: Customer pays $1000

Debit:  cash_reserve           $1000
Credit: customer_deposits      $1000

Metadata: {gateway: 'stripe', fee: $29}
```

### Commission Taken (on confirmation)
```
Transaction: 15% commission on $1000

Debit:  customer_deposits      $150
Credit: commissions_payable     $150

Metadata: {rate: 0.15, base_amount: 1000}
```

### Payout Due (on checkout)
```
Transaction: Owner share = $1000 - $150 = $850

Debit:  customer_deposits      $850
Credit: payouts_receivable      $850

Metadata: {owner_id: 'prop_123', scheduled_payout: '2026-02-22'}
```

### Gateway Fee
```
Transaction: Stripe fee 2.9% + $0.30 on $1000

Debit:  gateway_fee_expense     $29
Credit: gateway_fees_receivable  $29

Metadata: {gateway: 'stripe', rate: 0.029, fixed: 0.30}
```

### Refund Processed
```
Transaction: Full refund of $1000

Debit:  refunds_payable        $1000
Credit: cash_reserve           $1000

Metadata: {reason: 'host_commit_failed', gateway_refund_id: 're_xxx'}
```

### Tax Withheld (Brazil/PIX)
```
Transaction: IOF tax 0.38% on $1000

Debit:  customer_deposits      $3.80
Credit: tax_payable             $3.80

Metadata: {tax_type: 'IOF', rate: 0.0038, jurisdiction: 'BR'}
```

---

## 3C. Commission Calculation Rules

### Base Commission Structure

```
┌─────────────────────────────────────────────┐
│           COMMISSION TIERS                  │
├─────────────────────────────────────────────┤
│ Tier 1: Standard Rate                        │
│   - Default: 15%                             │
│   - Applies to: All properties unless overridden│
│                                              │
│ Tier 2: Volume Discount                      │
│   - 12% if owner has >10 active properties   │
│   - 10% if owner has >50 active properties   │
│                                              │
│ Tier 3: Property Override                    │
│   - Range: 5% - 25%                          │
│   - Set per property in admin panel          │
│   - Takes precedence over tier rules         │
└─────────────────────────────────────────────┘
```

### Calculation Formula
```
base_amount = nightly_rate × nights + cleaning_fee + taxes

commission_rate = 
  IF property.commission_override EXISTS:
    property.commission_override
  ELSE IF owner.property_count > 50:
    0.10
  ELSE IF owner.property_count > 10:
    0.12
  ELSE:
    0.15

commission_amount = base_amount × commission_rate
owner_share = base_amount - commission_amount
```

### When Commission is Applied
- **Captured:** When reservation moves to `confirmed` state
- **Reversed:** If reservation is cancelled before check-in
- **Partial refund:** Pro-rated based on cancellation policy

---

## 3D. Payout Scheduling Model

### Default Schedule: Weekly

```
Payout Cycle:
┌─────────────────────────────────────────────┐
│ Check-out Date + 24 hours grace period      │
│              ↓                              │
│   Mark reservation as "payout_eligible"     │
│              ↓                              │
│   Weekly batch (Every Monday 00:00 UTC)     │
│              ↓                              │
│   Sum all eligible payouts per owner        │
│              ↓                              │
│   Generate payout batch                     │
│              ↓                              │
│   Transfer via Stripe Connect / PIX         │
│              ↓                              │
│   Update ledger: payouts_receivable → paid  │
└─────────────────────────────────────────────┘
```

### Property-Specific Override Capability

```typescript
interface PayoutSchedule {
  property_id: string;
  frequency: 'weekly' | 'biweekly' | 'monthly' | 'on_checkout';
  day_of_week?: number;  // 0-6, if weekly/biweekly
  day_of_month?: number; // 1-31, if monthly
  min_threshold?: number; // Minimum amount to trigger payout
  hold_days?: number;     // Additional hold period
}
```

**Override Precedence:**
1. Property-specific schedule (if set)
2. Owner default schedule (if set)
3. System default (weekly)

### Payout States

```
payout_pending
    ↓
processing (batch created)
    ↓
transferred (gateway confirms)
    ↓
completed (funds in owner account)
    ↓
[terminal]
```

---

## 3E. Refund Reconciliation Logic

### Full Refund Scenario

```
Original Payment: $1000
Commission: $150 (15%)
Owner Share: $850 (not yet paid)

Customer cancels, full refund:

1. Refund $1000 to customer
2. Reverse commission entry (-$150)
3. Cancel owner payout obligation (-$850)
4. Gateway fee: Not refunded (Stripe policy)

Ledger Entries:
┌─────────────────────────────────────────────┐
│ Debit:  refunds_payable        $1000       │
│ Credit: cash_reserve           $1000       │
│                                              │
│ Debit:  commissions_payable     $150        │
│ Credit: commission_revenue     -$150        │
│                                              │
│ Debit:  payouts_receivable      $850        │
│ Credit: customer_deposits       $850        │
└─────────────────────────────────────────────┘
```

### Partial Refund Scenario

```
Cancellation Policy: 50% refund if cancelled <7 days

Booking Amount: $1000
Refund Due: $500
Commission: Still $150 (non-refundable)
Owner Share: $350 ($500 - $150)

Ledger Entries:
┌─────────────────────────────────────────────┐
│ Debit:  refunds_payable         $500        │
│ Credit: cash_reserve            $500        │
│                                              │
│ Debit:  customer_deposits       $500        │
│ Credit: payouts_receivable      $350        │
│ Credit: commission_revenue      $150        │
└─────────────────────────────────────────────┘
```

### Reconciliation Checks

**Daily Job:**
1. Compare gateway refund records vs ledger
2. Flag mismatches for manual review
3. Auto-correct if difference < $1.00 (rounding)
4. Alert if gateway refund > ledger expectation

---

# 4. MULTI-TENANCY & RLS STRATEGY

## 4A. Tenancy Model Overview

```
┌─────────────────────────────────────────────┐
│           Reserve Connect                    │
│                                              │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐        │
│  │  City A │ │  City B │ │  City C │        │
│  │ (SFO)   │ │ (NYC)   │ │ (RIO)   │        │
│  └────┬────┘ └────┬────┘ └────┬────┘        │
│       │           │           │              │
│  ┌────┴────┐ ┌────┴────┐ ┌────┴────┐        │
│  │Property1│ │Property3│ │Property5│        │
│  │Property2│ │Property4│ │Property6│        │
│  └─────────┘ └─────────┘ └─────────┘        │
└─────────────────────────────────────────────┘
```

## 4B. Where city_code is Mandatory

| Table/Context | city_code Required | Reason |
|---------------|-------------------|---------|
| `properties` | YES | Primary tenancy boundary |
| `bookings` | YES | Belongs to property in city |
| `booking_intents` | YES | Derived from property search |
| `payments` | YES | Linked to booking |
| `ledger_entries` | YES | Financial audit by city |
| `payouts` | YES | Owner operations per city |
| `agents` | YES | Staff scope limitation |
| `kpi_metrics` | YES | Reporting segmentation |
| `ads` | YES | Campaign targeting |
| `search_logs` | YES | Analytics isolation |

## 4C. Where property_id Scoping is Sufficient

| Table/Context | city_code | Rationale |
|---------------|-----------|-----------|
| `property_rooms` | Implicit via property | Data always accessed via parent |
| `property_amenities` | Implicit via property | Join through properties table |
| `booking_guests` | Implicit via booking | Child table of booking |
| `payment_attempts` | Implicit via payment | Child table of payment |
| `ledger_metadata` | Implicit via ledger entry | Extension table |

**Rule:** If table is a child with FK to a parent that has city_code, city_code is implicit.

## 4D. Global Tables (No Tenancy)

| Table | Scope | Access Pattern |
|-------|-------|----------------|
| `cities` | Global | Read-only, cached |
| `users` | Global | Authentication only |
| `roles` | Global | System reference |
| `permissions` | Global | System reference |
| `commission_tiers` | Global | System configuration |
| `payout_schedules` | Global | Template definitions |
| `gateway_providers` | Global | Configuration |
| `system_settings` | Global | App configuration |

## 4E. RLS Enforcement Strategy

### Conceptual Model

```sql
-- Pseudocode for RLS policies

-- 1. City-scoped tables
CREATE POLICY city_isolation ON bookings
  FOR ALL
  USING (city_code IN (
    SELECT city_code FROM user_city_access WHERE user_id = current_user_id()
  ));

-- 2. Property-scoped tables (implicit)
CREATE POLICY property_city_isolation ON property_rooms
  FOR ALL
  USING (property_id IN (
    SELECT id FROM properties WHERE city_code IN (...)
  ));

-- 3. Global tables (no policy or allow all)
CREATE POLICY global_read ON cities
  FOR SELECT
  USING (true);
```

### Access Control Matrix

| Role | City Scope | Property Scope | Permissions |
|------|-----------|----------------|-------------|
| `super_admin` | All | All | Full CRUD |
| `city_admin` | Assigned | All in city | Full CRUD |
| `agent` | Assigned | All in city | Read, Create, Update (own) |
| `supervisor` | Assigned | All in city | Read, Update, Cancel |
| `owner` | Assigned | Own properties | Read only |
| `system` | All | All | Internal operations only |

### Cross-City Leakage Prevention

**Primary Mechanisms:**

1. **RLS Policies (Database Level)**
   - Every query filtered by city_code
   - Even super_admin uses policies (audit trail)
   - No `bypass_rls` for application roles

2. **Application-Level Validation**
   ```typescript
   // Middleware pattern
   function validateCityAccess(user, city_code) {
     if (!user.cities.includes(city_code)) {
       throw new ForbiddenError('City access denied');
     }
   }
   ```

3. **API Route Segregation**
   ```
   /api/v1/{city_code}/bookings      // Scoped endpoint
   /api/v1/{city_code}/properties    // Scoped endpoint
   ```

4. **JWT Claims**
   ```json
   {
     "sub": "user_123",
     "role": "agent",
     "cities": ["SFO", "NYC"],
     "properties": ["prop_1", "prop_2"],
     "iat": 1234567890
   }
   ```

5. **Query Builder Enforcement**
   ```typescript
   // Automatic city_code injection
   db.table('bookings')
     .where('city_code', ctx.user.cities)  // Always added
     .where('status', 'confirmed')
   ```

**Leakage Scenarios & Mitigations:**

| Attack Vector | Prevention |
|---------------|------------|
| URL parameter tampering | Validate city_code against JWT claims |
| Direct database access | RLS blocks unauthorized reads |
| SQL injection | Parameterized queries + RLS |
| Exporting data | City filter mandatory on export endpoints |
| API key sharing | Keys scoped to specific cities |
| Admin override abuse | Audit log + approval workflow |

---

# 5. EDGE FUNCTION ARCHITECTURE OVERVIEW

## 5A. Domain Grouping

### Public Search
| Function | Auth Model | Idempotency | Retry | Failure Handling |
|----------|-----------|-------------|-------|------------------|
| `search-properties` | Public (rate limited) | Cache key: params_hash | 1 retry | Return cached results |
| `search-availability` | Public (rate limited) | Cache key: property+dates | 1 retry | Return unavailable |
| `get-property-details` | Public | Cache key: property_id | 1 retry | Return 404 |

### Booking Intent
| Function | Auth Model | Idempotency | Retry | Failure Handling |
|----------|-----------|-------------|-------|------------------|
| `create-intent` | Customer JWT | Key: session_id | 0 | Return error, no reservation |
| `validate-intent` | Customer JWT | N/A (read-only) | 1 | Return validation error |
| `cancel-intent` | Customer JWT | Key: intent_id | 0 | Queue for cleanup |

### Payment
| Function | Auth Model | Idempotency | Retry | Failure Handling |
|----------|-----------|-------------|-------|------------------|
| `create-payment` | Customer JWT | Key: intent_id | 0 | Return error state |
| `process-webhook` | Gateway signature | Webhook event_id | 3 (exponential) | Queue for retry |
| `check-payment-status` | Customer JWT | N/A | 0 | Return unknown |
| `create-pix-charge` | Customer JWT | Key: intent_id | 0 | Return error |
| `confirm-pix-payment` | System | Provider idempotency | 3 | Queue for reconciliation |

### Host Commit
| Function | Auth Model | Idempotency | Retry | Failure Handling |
|----------|-----------|-------------|-------|------------------|
| `commit-to-host` | System (service key) | Booking_id | 3 (backoff) | Trigger refund flow |
| `check-host-status` | System | N/A | 2 | Log for manual review |
| `cancel-host-booking` | System + Agent JWT | Booking_id | 3 | Alert operations |

### Cancellation/Refund
| Function | Auth Model | Idempotency | Retry | Failure Handling |
|----------|-----------|-------------|-------|------------------|
| `request-cancellation` | Customer/Agent JWT | Booking_id | 0 | Return error |
| `process-refund` | System | Payment_id | 3 | Alert finance team |
| `approve-cancellation` | Supervisor JWT | Booking_id | 0 | Return error |

### Notification
| Function | Auth Model | Idempotency | Retry | Failure Handling |
|----------|-----------|-------------|-------|------------------|
| `send-email` | System | Message_id | 3 (exponential) | Queue dead letter |
| `send-sms` | System | Message_id | 3 (exponential) | Queue dead letter |
| `send-push` | System | Message_id | 2 | Log failure |

### Ads Delivery
| Function | Auth Model | Idempotency | Retry | Failure Handling |
|----------|-----------|-------------|-------|------------------|
| `get-sponsored-listings` | Public (geo-based) | Cache: city+segment | 1 | Return organic only |
| `track-ad-impression` | Public | Event_id | 0 | Fire and forget |
| `track-ad-click` | Public | Event_id | 0 | Fire and forget |

### KPI Tracking
| Function | Auth Model | Idempotency | Retry | Failure Handling |
|----------|-----------|-------------|-------|------------------|
| `track-search-event` | Public | Event_id | 0 | Drop (best effort) |
| `track-booking-funnel` | System | Event_id | 0 | Drop (best effort) |
| `aggregate-metrics` | System (cron) | Date range | 0 | Retry next run |
| `export-kpi-report` | Admin JWT | Request_id | 1 | Return error |

## 5B. Retry & Backoff Strategy

### Exponential Backoff Formula
```
delay = min(base_delay × 2^attempt, max_delay)

Where:
  base_delay = 1000ms
  max_delay = 30000ms
  max_attempts = 3-5 (context dependent)

Jitter: delay × (0.5 + random(0, 1))
```

### Retry Matrix

| Function Category | Max Attempts | Base Delay | Jitter | Dead Letter |
|------------------|--------------|------------|--------|-------------|
| Webhook handlers | 5 | 2s | Yes | After 5 failures |
| Host API calls | 3 | 1s | Yes | Alert ops |
| Refund processing | 3 | 5s | No | Alert finance |
| Notifications | 3 | 2s | Yes | After 3 failures |
| Read operations | 1 | 0s | No | Return error |
| Write operations | 0 | 0s | No | Return error |

## 5C. Failure Handling Strategy

### Immediate Failure (No Retry)
- Validation errors
- Authentication failures
- Authorization failures
- Invalid parameters
- Duplicate idempotency key

**Action:** Return error to caller immediately

### Retry with Backoff
- Transient network errors
- Gateway timeouts
- Host API temporary failures
- Database connection issues

**Action:** Retry with exponential backoff, then dead letter

### Compensating Transaction
- Payment succeeded but booking failed
- Host commit failed after payment
- Cancellation failed mid-process

**Action:** Trigger compensating action (refund, release, notify)

### Manual Intervention
- Refund failed after max retries
- Host system down > 1 hour
- Data inconsistency detected
- Fraud alert triggered

**Action:** Alert operations team, pause related workflows

### Circuit Breaker Pattern
```
┌─────────────────────────────────────────────┐
│  Circuit State: CLOSED (normal)             │
│  → On 5 failures in 60s: OPEN              │
│                                              │
│  Circuit State: OPEN (failing)              │
│  → Reject requests for 30s                  │
│  → After 30s: HALF-OPEN                     │
│                                              │
│  Circuit State: HALF-OPEN (testing)         │
│  → Allow 1 request                          │
│  → If success: CLOSED                       │
│  → If failure: OPEN (extend timeout)        │
└─────────────────────────────────────────────┘
```

---

# 6. EVENT MODEL (FOR KPIs + MONITORING)

## 6A. Event Schema Standard

```typescript
interface ReserveEvent {
  event_id: string;           // UUID v4
  event_type: EventType;      // Enum
  timestamp: string;          // ISO 8601 UTC
  city_code: string;          // Multi-tenancy
  user_id?: string;           // If authenticated
  session_id: string;         // Anonymous tracking
  correlation_id: string;     // Request trace ID
  
  payload: {
    entity_id: string;        // Primary subject
    entity_type: string;      // booking, property, etc.
    metadata: Record<string, any>;
  };
  
  context: {
    user_agent?: string;
    ip_hash?: string;         // Hashed for privacy
    referrer?: string;
    device_type?: string;
    app_version?: string;
  };
}
```

## 6B. Event Types Specification

### Search Events

**search_performed**
```json
{
  "event_type": "search_performed",
  "payload": {
    "entity_type": "search_query",
    "metadata": {
      "city_code": "SFO",
      "check_in": "2026-03-01",
      "check_out": "2026-03-05",
      "guests": 2,
      "filters": ["pool", "wifi"],
      "result_count": 45,
      "response_time_ms": 120
    }
  }
}
```

**property_viewed**
```json
{
  "event_type": "property_viewed",
  "payload": {
    "entity_id": "prop_12345",
    "entity_type": "property",
    "metadata": {
      "from_search": true,
      "search_id": "srch_abc123",
      "view_duration_ms": 8500,
      "images_viewed": 8,
      "amenities_expanded": true
    }
  }
}
```

### Booking Funnel Events

**booking_intent_created**
```json
{
  "event_type": "booking_intent_created",
  "payload": {
    "entity_id": "bi_67890",
    "entity_type": "booking_intent",
    "metadata": {
      "property_id": "prop_12345",
      "check_in": "2026-03-01",
      "check_out": "2026-03-05",
      "total_amount": 1250.00,
      "nightly_rate": 250.00,
      "source": "search_results"
    }
  }
}
```

**payment_attempted**
```json
{
  "event_type": "payment_attempted",
  "payload": {
    "entity_id": "pay_abc123",
    "entity_type": "payment",
    "metadata": {
      "booking_intent_id": "bi_67890",
      "payment_method": "card",
      "gateway": "stripe",
      "amount": 1250.00,
      "currency": "USD"
    }
  }
}
```

**payment_succeeded**
```json
{
  "event_type": "payment_succeeded",
  "payload": {
    "entity_id": "pay_abc123",
    "entity_type": "payment",
    "metadata": {
      "booking_intent_id": "bi_67890",
      "payment_method": "card",
      "gateway": "stripe",
      "amount": 1250.00,
      "processing_time_ms": 2300,
      "gateway_fee": 36.25
    }
  }
}
```

**payment_failed**
```json
{
  "event_type": "payment_failed",
  "payload": {
    "entity_id": "pay_def456",
    "entity_type": "payment",
    "metadata": {
      "booking_intent_id": "bi_67891",
      "payment_method": "card",
      "gateway": "stripe",
      "amount": 1250.00,
      "failure_code": "card_declined",
      "failure_message": "Your card was declined.",
      "retry_count": 0
    }
  }
}
```

### Host Integration Events

**host_commit_started**
```json
{
  "event_type": "host_commit_started",
  "payload": {
    "entity_id": "res_ghi789",
    "entity_type": "reservation",
    "metadata": {
      "booking_intent_id": "bi_67890",
      "property_id": "prop_12345",
      "host_system": "host_connect",
      "payment_id": "pay_abc123",
      "attempt": 1
    }
  }
}
```

**host_commit_succeeded**
```json
{
  "event_type": "host_commit_succeeded",
  "payload": {
    "entity_id": "res_ghi789",
    "entity_type": "reservation",
    "metadata": {
      "host_booking_id": "hc_555666",
      "response_time_ms": 1200,
      "host_property_id": "external_123"
    }
  }
}
```

**host_commit_failed**
```json
{
  "event_type": "host_commit_failed",
  "payload": {
    "entity_id": "res_jkl012",
    "entity_type": "reservation",
    "metadata": {
      "error_code": "HOST_TIMEOUT",
      "error_message": "Host system did not respond within 5s",
      "attempt": 3,
      "will_refund": true
    }
  }
}
```

### Reservation Lifecycle Events

**reservation_confirmed**
```json
{
  "event_type": "reservation_confirmed",
  "payload": {
    "entity_id": "res_ghi789",
    "entity_type": "reservation",
    "metadata": {
      "property_id": "prop_12345",
      "customer_id": "cust_98765",
      "check_in": "2026-03-01",
      "check_out": "2026-03-05",
      "total_amount": 1250.00,
      "commission_amount": 187.50
    }
  }
}
```

**reservation_cancelled**
```json
{
  "event_type": "reservation_cancelled",
  "payload": {
    "entity_id": "res_ghi789",
    "entity_type": "reservation",
    "metadata": {
      "cancelled_by": "customer",
      "cancelled_at": "2026-02-20T10:30:00Z",
      "check_in": "2026-03-01",
      "hours_before_checkin": 216,
      "refund_amount": 875.00,
      "refund_percentage": 0.70,
      "cancellation_reason": "change_of_plans"
    }
  }
}
```

**reservation_checked_in**
```json
{
  "event_type": "reservation_checked_in",
  "payload": {
    "entity_id": "res_ghi789",
    "entity_type": "reservation",
    "metadata": {
      "checked_in_at": "2026-03-01T15:30:00Z",
      "scheduled_check_in": "2026-03-01T16:00:00Z",
      "early_checkin": true,
      "host_recorded": true
    }
  }
}
```

### Financial Events

**ledger_entry_created**
```json
{
  "event_type": "ledger_entry_created",
  "payload": {
    "entity_id": "le_mno345",
    "entity_type": "ledger_entry",
    "metadata": {
      "transaction_id": "txn_pqr678",
      "booking_id": "res_ghi789",
      "entry_type": "commission_taken",
      "amount": 187.50,
      "direction": "credit",
      "account": "commission_revenue"
    }
  }
}
```

**payout_initiated**
```json
{
  "event_type": "payout_initiated",
  "payload": {
    "entity_id": "po_stu901",
    "entity_type": "payout",
    "metadata": {
      "owner_id": "owner_789",
      "amount": 1062.50,
      "reservation_count": 5,
      "scheduled_for": "2026-02-22",
      "method": "stripe_transfer"
    }
  }
}
```

**refund_processed**
```json
{
  "event_type": "refund_processed",
  "payload": {
    "entity_id": "ref_vwx234",
    "entity_type": "refund",
    "metadata": {
      "original_payment_id": "pay_abc123",
      "amount": 875.00,
      "reason": "customer_cancellation",
      "gateway_refund_id": "re_yza567",
      "processing_time_hours": 0.5
    }
  }
}
```

### Ad Events

**ad_impression**
```json
{
  "event_type": "ad_impression",
  "payload": {
    "entity_id": "ad_bcd890",
    "entity_type": "advertisement",
    "metadata": {
      "campaign_id": "camp_efg123",
      "property_id": "prop_99999",
      "placement": "search_results_top",
      "cpc_bid": 0.50,
      "user_segment": "luxury_traveler"
    }
  }
}
```

**ad_clicked**
```json
{
  "event_type": "ad_clicked",
  "payload": {
    "entity_id": "ad_bcd890",
    "entity_type": "advertisement",
    "metadata": {
      "campaign_id": "camp_efg123",
      "property_id": "prop_99999",
      "placement": "search_results_top",
      "click_cost": 0.50,
      "time_to_click_ms": 3200
    }
  }
}
```

**ad_conversion**
```json
{
  "event_type": "ad_conversion",
  "payload": {
    "entity_id": "ad_bcd890",
    "entity_type": "advertisement",
    "metadata": {
      "campaign_id": "camp_efg123",
      "booking_id": "res_ghi789",
      "conversion_value": 1250.00,
      "time_to_conversion_hours": 2.5,
      "attribution_model": "last_click"
    }
  }
}
```

### System Events

**system_alert**
```json
{
  "event_type": "system_alert",
  "payload": {
    "entity_id": "alert_hij456",
    "entity_type": "alert",
    "metadata": {
      "severity": "critical",
      "category": "HOST_CONNECT_DOWN",
      "message": "Host Connect API not responding for > 5 minutes",
      "affected_cities": ["SFO", "NYC"],
      "auto_escalated": true
    }
  }
}
```

**webhook_received**
```json
{
  "event_type": "webhook_received",
  "payload": {
    "entity_id": "wh_klm789",
    "entity_type": "webhook",
    "metadata": {
      "gateway": "stripe",
      "event_type": "payment_intent.succeeded",
      "processing_time_ms": 150,
      "signature_valid": true,
      "idempotency_hit": false
    }
  }
}
```

## 6C. Event Routing

### Real-Time Streaming
```
┌─────────────────────────────────────────────┐
│         Event Publishers                     │
│  (Edge Functions, Database Triggers)         │
└─────────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────────┐
│         Event Bus (Redis Pub/Sub)            │
└─────────────────────────────────────────────┘
                  ↓
    ┌─────────────┼─────────────┐
    ↓             ↓             ↓
┌────────┐   ┌────────┐   ┌────────┐
│KPI DB  │   │Alerts  │   │Audit   │
│(Timescale│   │(Opsgenie)│   │Log     │
└────────┘   └────────┘   └────────┘
```

### Batch Processing
- **Hourly:** Aggregation for dashboards
- **Daily:** Financial reconciliation reports
- **Weekly:** Owner statements
- **Monthly:** Business intelligence exports

## 6D. KPIs Derived from Events

### Business Metrics
- **Conversion Rate:** `booking_intent_created` → `payment_succeeded`
- **Search-to-Book:** `search_performed` → `reservation_confirmed`
- **Cancellation Rate:** `reservation_confirmed` → `reservation_cancelled`
- **Average Booking Value:** Sum of `total_amount` / Count of `reservation_confirmed`
- **Host Commit Success Rate:** `host_commit_started` → `host_commit_succeeded`

### Operational Metrics
- **Payment Failure Rate:** Count of `payment_failed` / Count of `payment_attempted`
- **Average Payment Time:** Avg `processing_time_ms` from `payment_succeeded`
- **Host API Latency:** Avg `response_time_ms` from `host_commit_succeeded`
- **Refund Processing Time:** Avg `processing_time_hours` from `refund_processed`

### Financial Metrics
- **Gross Booking Value:** Sum of `total_amount` from `reservation_confirmed`
- **Net Revenue:** Sum of `commission_amount` from `reservation_confirmed`
- **Refund Rate:** Sum of `refund_amount` / Sum of `total_amount`
- **Gateway Cost:** Sum of `gateway_fee` from `payment_succeeded`

---

# APPENDIX A: INTEGRATION CONTRACTS

## A.1 Host Connect API Contract

### Commit Booking
```
POST /api/v1/bookings
Headers:
  Authorization: Bearer {host_connect_token}
  X-City-Code: {city_code}

Body:
{
  "property_id": "string",
  "check_in": "YYYY-MM-DD",
  "check_out": "YYYY-MM-DD",
  "guests": {
    "adults": number,
    "children": number
  },
  "guest_info": {
    "name": "string",
    "email": "string",
    "phone": "string"
  },
  "total_amount": number,
  "currency": "USD",
  "external_reference": "string"  // Our booking_id
}

Response 201:
{
  "host_booking_id": "string",
  "status": "confirmed",
  "confirmation_code": "string"
}

Response 4xx/5xx:
{
  "error": "string",
  "error_code": "string",
  "retryable": boolean
}
```

### Cancel Booking
```
DELETE /api/v1/bookings/{host_booking_id}
Headers:
  Authorization: Bearer {host_connect_token}

Response 200:
{
  "status": "cancelled",
  "refund_eligible": boolean
}
```

### Webhook Events (from Host Connect)
```
POST /webhooks/host-connect
Headers:
  X-Signature: {hmac_signature}

Body:
{
  "event_type": "checkin_completed|checkout_completed|booking_modified",
  "host_booking_id": "string",
  "timestamp": "ISO8601",
  "data": { ... }
}
```

## A.2 Portal Connect API Contract

### Get Property Editorial Content
```
GET /api/v1/properties/{property_id}/content
Headers:
  Authorization: Bearer {portal_connect_token}

Response 200:
{
  "property_id": "string",
  "name": "string",
  "description": "string",
  "images": [...],
  "amenities": [...],
  "policies": { ... }
}
```

## A.3 Stripe Webhook Contract

See Section 2A for event types.

Signature verification:
```
stripe.webhooks.constructEvent(
  payload,
  signature,
  webhook_secret
)
```

---

# APPENDIX B: GLOSSARY

| Term | Definition |
|------|------------|
| **Booking Intent** | Temporary reservation state before payment confirmation |
| **Host Commit** | Synchronization of booking to Host Connect system |
| **PIX** | Brazilian instant payment system (QR code based) |
| **MoR** | Merchant of Record - entity legally responsible for transactions |
| **TTL** | Time To Live - expiration timeout for temporary states |
| **RLS** | Row Level Security - database access control mechanism |
| **Edge Function** | Serverless function at CDN edge (Deno/Supabase) |
| **Idempotency** | Property ensuring repeated operations have same effect |

---

**END OF ARCHITECTURE SPECIFICATION**

*This document represents the architecture freeze for Sprint 0. All implementation in Sprint 1+ must conform to these specifications.*
