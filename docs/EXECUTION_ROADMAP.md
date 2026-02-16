# RESERVE CONNECT - EXECUTION ROADMAP

**Role**: Lead Technical Architect  
**Version**: 1.0  
**Date**: 2026-02-15  
**Status**: Implementation-Ready  
**Sprint Cadence**: 2 weeks per sprint  
**MVP Launch**: Sprint 6 (12 weeks from start)

---

## 1) ARCHITECTURE LAYERS OVERVIEW

### Layer 1: Data Layer (Supabase PostgreSQL)
```
reserve schema:
  - cities, properties_map, unit_map
  - availability_calendar, rate_plans
  - reservations, travelers, booking_holds
  - financial_ledger, payouts, commissions
  - sync_jobs, events, audit_logs
  - kpi_daily_snapshots, funnel_events

public schema:
  - proxy views to reserve schema
  - auth integration tables (delayed until Sprint 8)
```

### Layer 2: API Layer (Supabase Edge Functions)
```
Core Functions:
  - search_availability (cached)
  - create_booking_intent
  - process_payment (Stripe + PIX)
  - confirm_booking
  - sync_host_properties
  - sync_host_availability

Financial Functions:
  - create_ledger_entry
  - process_payout
  - calculate_commission
  - reconcile_payments

Admin Functions:
  - support_console_api
  - exception_queue_manager
  - payout_approver

Content Functions:
  - fetch_portal_content
  - sync_hero_banners
```

### Layer 3: Integration Layer
```
External APIs:
  - Host Connect (REST API, webhooks)
  - Stripe (Payments, Connect)
  - PIX Provider (Mercado Pago or similar)
  - SendGrid (Email)
  - WhatsApp Business API
  - Portal Connect (Content API)

Internal Message Bus:
  - Event-driven architecture
  - Reserve.events table as queue
  - Dead letter queue for failures
```

### Layer 4: Frontend Layer (Delayed)
```
Public Site:
  - Search & booking flow
  - Property listings
  - Guest dashboards (Sprint 8)

Admin Console:
  - Support agent interface
  - Owner dashboards
  - Financial dashboards
  - Exception queue UI
```

### Layer 5: Financial Operations Layer
```
Merchant-of-Record Model:
  - Stripe account (Reserve as merchant)
  - PIX provider (Brazil)
  - Ledger system (double-entry)
  - Commission engine
  - Payout scheduler
  - Tax calculation (ISS, IOF)
```

### Layer 6: Monitoring & Operations
```
Observability:
  - Application performance monitoring
  - Business metrics tracking
  - Financial reconciliation monitoring
  - Host integration health
  - Queue depth monitoring

Alerting:
  - PagerDuty for critical failures
  - Email alerts for warnings
  - Slack notifications for ops team
```

---

## 2) SPRINT PLAN

### SPRINT 0: Foundation & Infrastructure (Weeks 1-2)

**Goals**:
- Establish development environment
- Set up core infrastructure
- Define data contracts with Host Connect
- Configure financial accounts

**Deliverables**:
1. Supabase project provisioned with schemas
2. Stripe account configured (test mode)
3. PIX provider account (test mode)
4. CI/CD pipeline (GitHub Actions)
5. Development environment documentation
6. API contract specifications with Host

**Technical Components**:
```sql
-- Core schema foundation (no RLS yet)
CREATE SCHEMA reserve;

-- Initial tables
- cities (manual seed for Urubici)
- properties_map (empty, ready for sync)
- unit_map (empty, ready for sync)
- availability_calendar (empty)
- reservations (empty)
- booking_holds (empty)
- sync_jobs (empty)
- events (empty)

-- No financial tables yet (Sprint 2)
-- No auth integration yet (Sprint 8)
```

**Edge Functions**:
- `health_check` - System health endpoint
- `sync_host_properties` - Initial sync prototype

**Acceptance Criteria**:
- [ ] Database accessible from dev environment
- [ ] Stripe test keys working
- [ ] PIX test environment connected
- [ ] Can connect to Host Connect API (read-only)
- [ ] CI/CD builds and deploys Edge Functions

**Dependencies**:
- Host Connect API credentials
- Stripe account approval
- PIX provider sandbox access
- Supabase project provisioning

**Risk Flags**:
- 🔴 **HIGH**: Stripe account approval delays (mitigation: start paperwork immediately)
- 🟡 **MEDIUM**: PIX provider integration complexity (mitigation: prepare fallback to Stripe only)
- 🟢 **LOW**: Host Connect API contract changes

---

### SPRINT 1: Property & Inventory Sync Core (Weeks 3-4)

**Goals**:
- Sync properties from Host Connect
- Sync room types/units
- Establish availability sync mechanism
- Build sync monitoring

**Deliverables**:
1. Property sync pipeline operational
2. 5-10 pilot properties synced
3. Unit types mapped correctly
4. Availability sync job running
5. Sync failure detection and alerts

**Technical Components**:

```sql
-- Properties sync table
reserve.properties_map:
  - host_property_id (FK to Host)
  - city_id (Urubici)
  - name, slug, description
  - address, coordinates
  - contact info
  - amenities_cached (JSON)
  - images_cached (JSON array)
  - is_active, is_published
  - host_last_synced_at
  - sync_status

-- Unit types sync
reserve.unit_map:
  - host_unit_id (FK to Host room_types)
  - property_id (FK to properties_map)
  - name, slug
  - max_occupancy, base_capacity
  - bed_configuration (JSON)
  - amenities_cached
  - images_cached

-- Sync tracking
reserve.sync_jobs:
  - job_type: 'property_sync', 'availability_sync'
  - property_id, city_id
  - status, error_message
  - records_processed, records_failed
  - started_at, completed_at
```

**Edge Functions**:
```typescript
// 1. sync_host_properties
// Fetches from Host, maps to Reserve schema
// Handles: new properties, updates, deactivations

// 2. sync_host_room_types
// Syncs room types per property
// Maps Host amenities to Reserve format

// 3. sync_host_availability
// Populates availability_calendar
// 365 days forward

// 4. get_properties
// Public API: list properties with filters
// Caches for 60 seconds

// 5. get_property_detail
// Public API: single property with units
```

**Database Evolution**:
```sql
-- Add indexes for performance
CREATE INDEX idx_properties_city ON properties_map(city_id) WHERE is_active = true;
CREATE INDEX idx_properties_slug ON properties_map(slug) WHERE is_published = true;
CREATE INDEX idx_units_property ON unit_map(property_id) WHERE is_active = true;
```

**Acceptance Criteria**:
- [ ] Properties API returns real data from Host
- [ ] Images load correctly (URLs validated)
- [ ] Availability calendar populated for 30 days
- [ ] Sync jobs visible in monitoring
- [ ] Failed syncs trigger alerts

**Dependencies**:
- Sprint 0 completion
- Host Connect API read access
- Pilot property list from operations team

**Risk Flags**:
- 🔴 **HIGH**: Image URL formats incompatible (mitigation: URL transformation layer)
- 🟡 **MEDIUM**: Host property data incomplete (mitigation: manual enrichment process)
- 🟡 **MEDIUM**: Amenities mapping complexity (mitigation: standardization table)

---

### SPRINT 2: Financial Architecture - Ledger & Commission (Weeks 5-6)

**Goals**:
- Build double-entry ledger system
- Implement commission calculation engine
- Set up payout workflow
- Configure tax handling

**Deliverables**:
1. Financial ledger schema operational
2. Commission rules engine working
3. Payout calculation logic
4. Financial audit trail
5. Integration with Stripe/PIX for collections

**Technical Components**:

```sql
-- Financial Ledger (Double-entry)
reserve.financial_ledger:
  id UUID PRIMARY KEY,
  reservation_id UUID REFERENCES reservations(id),
  transaction_type VARCHAR(50), -- 'payment', 'refund', 'payout', 'commission', 'fee'
  direction VARCHAR(10), -- 'debit', 'credit'
  amount DECIMAL(12,2),
  currency VARCHAR(3) DEFAULT 'BRL',
  
  -- Accounts
  account_type VARCHAR(50), -- 'guest', 'property', 'platform', 'stripe', 'tax'
  account_id UUID,
  
  -- References
  stripe_payment_intent_id VARCHAR(100),
  stripe_transfer_id VARCHAR(100),
  pix_transaction_id VARCHAR(100),
  
  -- Metadata
  description TEXT,
  metadata JSONB DEFAULT '{}',
  
  -- Audit
  created_at TIMESTAMPTZ DEFAULT NOW(),
  created_by UUID, -- system or user
  
  -- Constraints
  CONSTRAINT valid_amount CHECK (amount >= 0),
  CONSTRAINT valid_direction CHECK (direction IN ('debit', 'credit'))
);

-- Create indexes
CREATE INDEX idx_ledger_reservation ON financial_ledger(reservation_id);
CREATE INDEX idx_ledger_type ON financial_ledger(transaction_type);
CREATE INDEX idx_ledger_account ON financial_ledger(account_type, account_id);
CREATE INDEX idx_ledger_created ON financial_ledger(created_at);

-- Commission Rules
reserve.commission_rules:
  id UUID PRIMARY KEY,
  property_id UUID REFERENCES properties_map(id),
  rule_type VARCHAR(50), -- 'percentage', 'fixed', 'tiered'
  rate_percentage DECIMAL(5,2), -- e.g., 12.50 for 12.5%
  fixed_amount DECIMAL(12,2),
  min_commission DECIMAL(12,2),
  max_commission DECIMAL(12,2),
  effective_from DATE,
  effective_to DATE,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Default: 12% for all properties
INSERT INTO commission_rules (rule_type, rate_percentage, effective_from) 
VALUES ('percentage', 12.00, '2026-01-01');

-- Payouts to Properties
reserve.payouts:
  id UUID PRIMARY KEY,
  property_id UUID REFERENCES properties_map(id),
  
  -- Amount
  gross_amount DECIMAL(12,2), -- Total bookings
  commission_amount DECIMAL(12,2), -- Platform fee
  tax_amount DECIMAL(12,2), -- ISS/IOF
  net_amount DECIMAL(12,2), -- To property
  
  -- Status
  status VARCHAR(50) DEFAULT 'pending', -- pending, processing, completed, failed
  
  -- Stripe Connect
  stripe_transfer_id VARCHAR(100),
  stripe_payout_id VARCHAR(100),
  
  -- PIX
  pix_key VARCHAR(100),
  
  -- Period
  period_start DATE,
  period_end DATE,
  
  -- Included bookings
  included_bookings UUID[], -- Array of reservation_ids
  
  -- Timestamps
  requested_at TIMESTAMPTZ DEFAULT NOW(),
  processed_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  
  -- Audit
  approved_by UUID,
  notes TEXT
);

-- Payout Approvals (for large amounts)
CREATE INDEX idx_payouts_property ON payouts(property_id);
CREATE INDEX idx_payouts_status ON payouts(status);
CREATE INDEX idx_payouts_period ON payouts(period_start, period_end);
```

**Edge Functions**:
```typescript
// 1. create_ledger_entry
// Double-entry bookkeeping
// Debits and credits must balance

// 2. calculate_commission
// Applies commission rules
// Returns commission amount

// 3. create_payout
// Calculates net amount for property
// Creates payout record
// Initiates Stripe transfer

// 4. reconcile_payments
// Daily reconciliation job
// Matches Stripe/Pix to ledger
// Alerts on discrepancies

// 5. get_property_financials
// Owner dashboard endpoint
// Revenue, commissions, payouts
```

**Financial Flow Design**:
```
Guest Payment Flow:
1. Guest pays R$ 1,000 (Stripe/PIX)
2. Reserve receives R$ 970 (after Stripe 2.9% + R$ 0.30)
3. Ledger entries:
   - Credit: Guest account R$ 1,000 (liability)
   - Debit: Stripe fees R$ 30 (expense)
   - Credit: Platform cash R$ 970 (asset)
   - Debit: Guest account R$ 1,000 (release liability)
   - Credit: Property payable R$ 850 (liability) [after 15% commission]
   - Credit: Commission revenue R$ 150 (income)
   - Credit: Tax payable R$ 20 (liability) [ISS on commission]

Payout Flow:
4. Weekly payout to property
5. Transfer R$ 850 to property bank (Stripe Connect or PIX)
6. Ledger:
   - Debit: Property payable R$ 850
   - Credit: Cash R$ 850
```

**Acceptance Criteria**:
- [ ] Ledger balances for all test transactions
- [ ] Commission calculated correctly (test 5 scenarios)
- [ ] Payout amount = Gross - Commission - Tax
- [ ] Audit trail shows all entries
- [ ] Reconciliation detects 1c discrepancy

**Dependencies**:
- Sprint 1 property sync complete
- Stripe Connect onboarding guide ready
- Tax rates defined (ISS 2-5%, IOF 0.38%)

**Risk Flags**:
- 🔴 **HIGH**: PIX reconciliation complexity (mitigation: manual reconciliation first)
- 🔴 **HIGH**: Tax calculation accuracy (mitigation: accountant review, use established tax engine)
- 🟡 **MEDIUM**: Stripe Connect onboarding for properties (mitigation: PIX as fallback)

---

### SPRINT 3: Booking Flow & State Machine (Weeks 7-8)

**Goals**:
- Build complete booking state machine
- Implement availability holds
- Create reservation records
- Handle booking modifications

**Deliverables**:
1. Booking intent creation with 15-min TTL
2. Availability soft-hold mechanism
3. Reservation state machine operational
4. Booking confirmation workflow
5. Modification and cancellation logic

**Technical Components**:

```sql
-- Booking Intent (Temporary hold)
reserve.booking_intents:
  id UUID PRIMARY KEY,
  
  -- References
  property_id UUID REFERENCES properties_map(id),
  unit_id UUID REFERENCES unit_map(id),
  
  -- Dates
  check_in DATE NOT NULL,
  check_out DATE NOT NULL,
  nights INTEGER GENERATED ALWAYS AS (check_out - check_in) STORED,
  
  -- Guests
  guests_adults INTEGER DEFAULT 1,
  guests_children INTEGER DEFAULT 0,
  
  -- Pricing
  base_price DECIMAL(12,2),
  taxes DECIMAL(12,2) DEFAULT 0,
  fees DECIMAL(12,2) DEFAULT 0,
  total_amount DECIMAL(12,2),
  
  -- Status
  status VARCHAR(50) DEFAULT 'created', -- created, payment_pending, payment_confirmed, converted, expired, cancelled
  
  -- Payment
  stripe_payment_intent_id VARCHAR(100),
  pix_transaction_id VARCHAR(100),
  
  -- Expiration
  created_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '15 minutes'),
  
  -- Conversion
  reservation_id UUID REFERENCES reservations(id),
  
  -- Guest details (denormalized for conversion)
  guest_email VARCHAR(255),
  guest_first_name VARCHAR(100),
  guest_last_name VARCHAR(100),
  guest_phone VARCHAR(50),
  
  -- Constraints
  CONSTRAINT valid_dates CHECK (check_out > check_in),
  CONSTRAINT valid_guests CHECK (guests_adults >= 1)
);

CREATE INDEX idx_intents_status ON booking_intents(status) WHERE status IN ('created', 'payment_pending');
CREATE INDEX idx_intents_expires ON booking_intents(expires_at) WHERE status NOT IN ('converted', 'cancelled');

-- Reservations (Permanent record)
reserve.reservations:
  id UUID PRIMARY KEY,
  confirmation_code VARCHAR(50) UNIQUE NOT NULL,
  
  -- References
  booking_intent_id UUID REFERENCES booking_intents(id),
  property_id UUID REFERENCES properties_map(id),
  unit_id UUID REFERENCES unit_map(id),
  
  -- Host reference (once synced)
  host_booking_id UUID,
  
  -- Guest
  traveler_id UUID REFERENCES travelers(id),
  guest_first_name VARCHAR(100),
  guest_last_name VARCHAR(100),
  guest_email VARCHAR(255),
  guest_phone VARCHAR(50),
  
  -- Dates
  check_in DATE NOT NULL,
  check_out DATE NOT NULL,
  nights INTEGER,
  
  -- Guests
  guests_adults INTEGER DEFAULT 1,
  guests_children INTEGER DEFAULT 0,
  guests_infants INTEGER DEFAULT 0,
  
  -- Pricing
  currency VARCHAR(3) DEFAULT 'BRL',
  base_price DECIMAL(12,2) NOT NULL,
  taxes DECIMAL(12,2) DEFAULT 0,
  fees DECIMAL(12,2) DEFAULT 0,
  discount_amount DECIMAL(12,2) DEFAULT 0,
  total_amount DECIMAL(12,2) NOT NULL,
  
  -- Commission
  commission_amount DECIMAL(12,2),
  net_to_property DECIMAL(12,2),
  
  -- Status
  status VARCHAR(50) DEFAULT 'confirmed', -- confirmed, checked_in, checked_out, cancelled, no_show
  payment_status VARCHAR(50) DEFAULT 'paid', -- paid, refunded, partial_refund
  
  -- Cancellation
  cancelled_at TIMESTAMPTZ,
  cancellation_reason TEXT,
  cancellation_fee DECIMAL(12,2) DEFAULT 0,
  refund_amount DECIMAL(12,2) DEFAULT 0,
  
  -- Check-in/out
  checked_in_at TIMESTAMPTZ,
  checked_out_at TIMESTAMPTZ,
  
  -- Metadata
  special_requests TEXT,
  source VARCHAR(50) DEFAULT 'direct', -- direct, ota, phone
  
  -- Timestamps
  booked_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_reservations_property ON reservations(property_id);
CREATE INDEX idx_reservations_traveler ON reservations(traveler_id);
CREATE INDEX idx_reservations_status ON reservations(status);
CREATE INDEX idx_reservations_dates ON reservations(check_in, check_out);
CREATE INDEX idx_reservations_code ON reservations(confirmation_code);
CREATE INDEX idx_reservations_booked ON reservations(booked_at DESC);

-- Availability with holds tracking
ALTER TABLE reserve.availability_calendar ADD COLUMN temp_holds INTEGER DEFAULT 0;
ALTER TABLE reserve.availability_calendar ADD COLUMN effective_allotment INTEGER GENERATED ALWAYS AS (allotment - bookings_count - temp_holds) STORED;

CREATE INDEX idx_availability_effective ON availability_calendar(unit_id, date) WHERE is_available = true AND effective_allotment > 0;
```

**Edge Functions**:
```typescript
// 1. create_booking_intent
// Validates availability
// Creates intent record
// Places soft hold (temp_holds++)
// Returns intent ID + Stripe client secret

// 2. check_availability
// Real-time availability check
// Considers: bookings_count + temp_holds
// Returns: available + price calculation

// 3. confirm_booking
// Called by Stripe webhook on payment success
// Creates reservation record
// Calls Host API to create booking
// Releases soft hold
// Triggers notifications

// 4. cancel_booking
// Validates cancellation policy
// Processes refund via Stripe
// Calls Host API to cancel
// Updates reservation status

// 5. modify_booking
// Validates new dates/unit available
// Calculates price difference
// Processes charge/refund
// Updates Host booking

// 6. expire_intents
// Cron job: Every minute
// Finds expired intents
// Releases soft holds
// Updates status to 'expired'
```

**State Machine**:
```
booking_intent.status:
  created → payment_pending (guest enters payment)
  payment_pending → payment_confirmed (Stripe/PIX success)
  payment_pending → cancelled (timeout or guest abort)
  payment_pending → expired (15-min TTL exceeded)
  payment_confirmed → host_commit_pending (creating Host booking)
  host_commit_pending → confirmed (Host success, reservation created)
  host_commit_pending → host_commit_failed (Host error after 3 retries)
  host_commit_failed → refund_pending (auto-refund initiated)
  refund_pending → cancelled (refund completed, intent closed)
  payment_confirmed → cancelled (guest abort before Host commit)
  created → expired (15-min TTL)

reservation.status:
  confirmed → checked_in (day of arrival)
  checked_in → checked_out (departure day)
  confirmed → cancel_pending (cancellation requested, validating policy)
  cancel_pending → cancelled (policy validated, refund processed)
  cancel_pending → confirmed (cancellation rejected, reverted)
  confirmed → no_show (day after check-in, 12pm)
  checked_out → completed (post-review period)

Failure State Handling:
  - host_commit_failed: Enters exception queue, agent reviews, options: retry Host call, force cancel + refund, or manual override
  - refund_pending: System processes refund, updates ledger, notifies guest
  - cancel_pending: Validates cancellation policy, calculates refund amount, prevents race conditions
```

**Acceptance Criteria**:
- [ ] Intent expires correctly after 15 min
- [ ] Soft hold prevents overbooking during payment
- [ ] Reservation created with correct confirmation code
- [ ] Host API called successfully
- [ ] Cancellation policy enforced correctly
- [ ] Modification recalculates price accurately

**Dependencies**:
- Sprint 2 financial ledger
- Stripe webhook endpoints configured
- Host Connect booking API access

**Risk Flags**:
- 🔴 **HIGH**: Race condition on availability (mitigation: database row locking)
- 🔴 **HIGH**: State machine complexity (mitigation: explicit state transitions only)
- 🟡 **MEDIUM**: Host API timeout during booking (mitigation: exception queue, manual retry)

---

### SPRINT 4: Payment Processing (Stripe + PIX) (Weeks 9-10)

**Goals**:
- Implement Stripe payment flow
- Implement PIX payment flow (Brazil)
- Handle payment failures and retries
- Build payment reconciliation

**Deliverables**:
1. Stripe card payment working end-to-end
2. PIX QR code generation
3. Payment webhook handlers
4. Failed payment recovery
5. Payment dashboard for support

**Technical Components**:

```sql
-- Payment attempts tracking
reserve.payment_attempts:
  id UUID PRIMARY KEY,
  booking_intent_id UUID REFERENCES booking_intents(id),
  
  -- Method
  payment_method VARCHAR(50), -- 'credit_card', 'debit_card', 'pix'
  
  -- Provider
  provider VARCHAR(50), -- 'stripe', 'mercado_pago'
  provider_payment_intent_id VARCHAR(100),
  provider_charge_id VARCHAR(100),
  pix_transaction_id VARCHAR(100),
  
  -- Amount
  amount DECIMAL(12,2),
  currency VARCHAR(3) DEFAULT 'BRL',
  
  -- Status
  status VARCHAR(50), -- 'pending', 'succeeded', 'failed', 'refunded'
  
  -- Error tracking
  error_code VARCHAR(100),
  error_message TEXT,
  
  -- 3D Secure
  requires_action BOOLEAN DEFAULT false,
  action_type VARCHAR(50), -- 'use_stripe_sdk'
  client_secret VARCHAR(255),
  
  -- Metadata
  card_last4 VARCHAR(4),
  card_brand VARCHAR(50),
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  succeeded_at TIMESTAMPTZ,
  failed_at TIMESTAMPTZ,
  
  -- Retry tracking
  retry_count INTEGER DEFAULT 0,
  next_retry_at TIMESTAMPTZ
);

CREATE INDEX idx_payment_intents ON payment_attempts(booking_intent_id);
CREATE INDEX idx_payment_status ON payment_attempts(status);
CREATE INDEX idx_payment_provider ON payment_attempts(provider, provider_payment_intent_id);

-- PIX-specific tracking
reserve.pix_transactions:
  id UUID PRIMARY KEY,
  payment_attempt_id UUID REFERENCES payment_attempts(id),
  
  -- PIX Data
  pix_key VARCHAR(100),
  qr_code TEXT,
  qr_code_base64 TEXT, -- For image rendering
  copy_paste_code TEXT, -- Copia e Cola
  
  -- Status
  status VARCHAR(50), -- 'pending', 'paid', 'expired', 'cancelled'
  
  -- Expiration
  expires_at TIMESTAMPTZ,
  
  -- Payment confirmation
  paid_at TIMESTAMPTZ,
  payer_name VARCHAR(200),
  payer_document VARCHAR(50),
  
  -- Provider response
  provider_response JSONB,
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Edge Functions**:
```typescript
// 1. create_stripe_payment_intent
// Creates PaymentIntent
// Returns client_secret
// Handles 3D Secure setup

// 2. handle_stripe_webhook
// Listens to Stripe events:
// - payment_intent.succeeded
// - payment_intent.payment_failed
// - charge.refunded
// Updates booking_intent status
// Triggers confirmation flow

// 3. create_pix_payment
// Generates PIX QR code
// Stores QR code image
// Returns: QR code + copy-paste code
// Sets 30-min expiration

// 4. handle_pix_webhook
// Receives PIX payment notification
// Matches to pending PIX transaction
// Triggers confirmation flow

// 5. retry_failed_payment
// Allows guest to retry
// Extends intent TTL
// Creates new payment attempt

// 6. get_payment_status
// Public API for polling
// Returns current payment state
// For PIX: checks if paid
```

**Payment Flow**:
```
Card Payment:
1. Guest selects card payment
2. create_stripe_payment_intent → returns client_secret
3. Frontend loads Stripe Elements
4. Guest enters card details
5. Stripe confirms (3D Secure if needed)
6. Webhook: payment_intent.succeeded
7. confirm_booking called
8. Reservation created

PIX Payment:
1. Guest selects PIX
2. create_pix_payment → returns QR code
3. Frontend displays QR code + copy-paste
4. Guest pays via banking app
5. Webhook: PIX provider notification
6. confirm_booking called
7. Reservation created

Failed Payment:
1. payment_intent.payment_failed received
2. Update booking_intent: retry_count++
3. If retry_count < 3: extend TTL 5 min
4. Email guest: "Payment failed, please retry"
5. If retry_count >= 3: cancel intent, release hold
```

**Acceptance Criteria**:
- [ ] Card payment succeeds with test card
- [ ] PIX QR code generates and scans
- [ ] 3D Secure challenge handled
- [ ] Failed payment allows retry
- [ ] Webhook handles all events correctly
- [ ] Reconciliation matches Stripe dashboard

**Dependencies**:
- Sprint 3 booking state machine
- Stripe webhook endpoint configured
- PIX provider integration (webhook URL)

**Risk Flags**:
- 🔴 **HIGH**: PIX webhook reliability (mitigation: polling fallback)
- 🔴 **HIGH**: 3D Secure complexity (mitigation: Stripe handles most)
- 🟡 **MEDIUM**: Card decline reasons (mitigation: clear error messages)

---

### SPRINT 5: Notifications & Communications (Weeks 11-12)

**Goals**:
- Build notification system
- Implement email templates
- Set up WhatsApp Business API
- Create notification preferences

**Deliverables**:
1. Email notifications (SendGrid)
2. WhatsApp notifications
3. SMS fallback
4. Notification templates (i18n ready)
5. Guest communication log

**Technical Components**:

```sql
-- Notification log
reserve.notifications:
  id UUID PRIMARY KEY,
  reservation_id UUID REFERENCES reservations(id),
  
  -- Recipient
  recipient_type VARCHAR(50), -- 'guest', 'property', 'admin'
  recipient_id UUID,
  recipient_email VARCHAR(255),
  recipient_phone VARCHAR(50),
  
  -- Content
  notification_type VARCHAR(50), -- 'confirmation', 'reminder', 'cancellation', etc.
  subject VARCHAR(255),
  body_html TEXT,
  body_text TEXT,
  
  -- Channel
  channel VARCHAR(50), -- 'email', 'whatsapp', 'sms'
  
  -- Provider
  provider VARCHAR(50), -- 'sendgrid', 'whatsapp_api', 'twilio'
  provider_message_id VARCHAR(100),
  
  -- Status
  status VARCHAR(50) DEFAULT 'pending', -- pending, sent, delivered, opened, failed
  
  -- Tracking
  sent_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  opened_at TIMESTAMPTZ,
  failed_at TIMESTAMPTZ,
  error_message TEXT,
  
  -- Retry
  retry_count INTEGER DEFAULT 0,
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_notifications_reservation ON notifications(reservation_id);
CREATE INDEX idx_notifications_status ON notifications(status);

-- Notification templates
reserve.notification_templates:
  id UUID PRIMARY KEY,
  template_key VARCHAR(100) UNIQUE NOT NULL,
  name VARCHAR(200),
  description TEXT,
  
  -- Channels
  email_enabled BOOLEAN DEFAULT true,
  whatsapp_enabled BOOLEAN DEFAULT false,
  sms_enabled BOOLEAN DEFAULT false,
  
  -- Email template
  email_subject TEXT,
  email_body_html TEXT,
  email_body_text TEXT,
  
  -- WhatsApp template
  whatsapp_template_name VARCHAR(100), -- Approved template name
  whatsapp_body TEXT,
  
  -- SMS template
  sms_body TEXT,
  
  -- Variables (JSON schema)
  variables JSONB,
  
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Seed templates
INSERT INTO notification_templates (template_key, name, email_subject, email_body_html) VALUES
('booking_confirmation', 'Booking Confirmation', 'Your Reservation Confirmation - {{confirmation_code}}', '<html>...</html>'),
('booking_reminder_24h', '24h Reminder', 'Check-in Tomorrow - {{property_name}}', '<html>...</html>'),
('booking_cancellation', 'Cancellation Confirmation', 'Your Reservation has been Cancelled', '<html>...</html>');
```

**Edge Functions**:
```typescript
// 1. send_notification
// Generic notification dispatcher
// Queues notification in reserve.notifications
// Calls appropriate provider

// 2. send_email (via SendGrid)
// HTML + text versions
// Template substitution
// Attachment support (receipts)

// 3. send_whatsapp
// Uses WhatsApp Business API
// Template messages (pre-approved)
// Session messages (reply within 24h)

// 4. send_sms (via Twilio)
// Fallback for critical messages
// Character limit handling

// 5. process_notification_queue
// Cron job: Every 5 minutes
// Processes pending notifications
// Retries failed (max 3)

// 6. handle_sendgrid_webhook
// Delivery status updates
// Open/click tracking
// Bounce handling
```

**Notification Triggers**:
```
Guest Notifications:
- Booking confirmation (immediate) - Email + WhatsApp
- 24h reminder (T-24h) - Email + WhatsApp
- 2h reminder (T-2h) - WhatsApp only
- Check-out reminder (morning of checkout) - WhatsApp
- Review request (2 days post-checkout) - Email
- Cancellation confirmation (immediate) - Email + WhatsApp
- Refund confirmation (when processed) - Email

Property Notifications:
- New booking (immediate) - Email + System Inbox
- Cancellation (immediate) - Email + System Inbox
- Check-in reminder (morning of) - WhatsApp
- No-show alert (next day 12pm) - Email
```

**Acceptance Criteria**:
- [ ] Confirmation email sent within 30 seconds
- [ ] WhatsApp message delivered
- [ ] Templates support variable substitution
- [ ] Failed notifications retry automatically
- [ ] Email opens tracked
- [ ] Unsubscribe links functional

**Dependencies**:
- SendGrid account configured
- WhatsApp Business API approved
- Twilio account (SMS fallback)
- Templates designed and approved

**Risk Flags**:
- 🔴 **HIGH**: WhatsApp template approval delays (mitigation: email primary, WhatsApp secondary)
- 🟡 **MEDIUM**: Email deliverability (SPF/DKIM setup)
- 🟢 **LOW**: SMS cost (use sparingly)

---

### SPRINT 6: Support Console & MVP Launch (Weeks 13-14)

**Goals**:
- Build support agent console
- Implement exception queue UI
- Create basic dashboards
- Launch MVP

**Deliverables**:
1. Support agent web console
2. Exception queue management
3. City-wide availability watchboard
4. Basic financial dashboard
5. MVP launch to public

**Technical Components**:

```sql
-- Exception queue
reserve.exceptions:
  id UUID PRIMARY KEY,
  exception_type VARCHAR(100), -- 'host_booking_failed', 'payment_webhook_missing', 'inventory_mismatch'
  severity VARCHAR(20), -- 'critical', 'high', 'medium', 'low'
  
  -- Related records
  reservation_id UUID REFERENCES reservations(id),
  booking_intent_id UUID REFERENCES booking_intents(id),
  
  -- Details
  title VARCHAR(255),
  description TEXT,
  error_message TEXT,
  error_code VARCHAR(100),
  
  -- Context
  context JSONB, -- Additional data for debugging
  
  -- Status
  status VARCHAR(50) DEFAULT 'open', -- open, in_progress, resolved, dismissed
  
  -- Assignment
  assigned_to UUID,
  
  -- Resolution
  resolution_notes TEXT,
  resolution_action VARCHAR(100),
  resolved_at TIMESTAMPTZ,
  resolved_by UUID,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_exceptions_status ON exceptions(status) WHERE status = 'open';
CREATE INDEX idx_exceptions_assigned ON exceptions(assigned_to, status);
CREATE INDEX idx_exceptions_severity ON exceptions(severity, created_at);

-- Support agent activity log
reserve.support_activity:
  id UUID PRIMARY KEY,
  agent_id UUID NOT NULL,
  activity_type VARCHAR(50), -- 'viewed_booking', 'cancelled_booking', 'resolved_exception', etc.
  target_type VARCHAR(50), -- 'reservation', 'exception', 'payout'
  target_id UUID,
  details JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Edge Functions (Admin API)**:
```typescript
// 1. get_exception_queue
// List exceptions with filters
// Pagination support

// 2. assign_exception
// Assign to agent
// Update status to 'in_progress'

// 3. resolve_exception
// Mark as resolved
- Add resolution notes
- Trigger any follow-up actions

// 4. force_cancel_booking
// Supervisor override
- Bypass policy checks
- Full audit trail

// 5. get_city_dashboard
// Aggregate metrics
// Today's bookings, revenue, check-ins

// 6. get_availability_watchboard
- Grid view of all properties
- Color-coded availability
- Real-time updates

// 7. get_financial_summary
- Revenue today/week/month
- Pending payouts
- Commission earned
```

**Console Features**:
```
Support Agent Console:
- Dashboard: Today's stats, exceptions count
- Bookings: Search, view, modify, cancel
- Exceptions: Queue, assignment, resolution
- Properties: List, view details
- Travelers: Search, view history

Owner Dashboard (Property Manager):
- My Bookings: List, filter by date/status
- Calendar: View occupancy
- Financials: Revenue, commissions, payouts
- Notifications: Settings

Supervisor Console:
- All agent features
- Exception assignment/management
- Payout approval
- City-wide reports
- User management
```

**MVP Launch Checklist**:
- [ ] 10-20 properties onboarded
- [ ] Payment processing tested (10+ test bookings)
- [ ] Support team trained
- [ ] Exception handling procedures documented
- [ ] Monitoring dashboards active
- [ ] PagerDuty alerts configured
- [ ] Terms of service published
- [ ] Privacy policy published
- [ ] Support phone/email active
- [ ] Backup/recovery tested

**Acceptance Criteria**:
- [ ] Support agent can cancel booking end-to-end
- [ ] Exception queue visible and manageable
- [ ] Availability watchboard shows real-time data
- [ ] Financial dashboard displays correct totals
- [ ] First real booking succeeds

**Dependencies**:
- All previous sprints complete
- Properties onboarded
- Support team hired and trained
- Launch marketing ready

**Risk Flags**:
- 🔴 **HIGH**: Launch day traffic surge (mitigation: load testing, gradual rollout)
- 🔴 **HIGH**: First booking failure (mitigation: extensive testing, on-call team)
- 🟡 **MEDIUM**: Support team inexperience (mitigation: shadowing, playbooks)

---

### SPRINT 7: Portal Content Integration (Weeks 15-16)

**Goals**:
- Integrate Portal Connect content
- Hero banners
- Events enrichment
- Restaurant cross-linking

**Deliverables**:
1. Portal content fetch API
2. Hero banners on homepage
3. Events listed on property pages
4. Restaurant recommendations

**Technical Components**:

```sql
-- Portal content cache (optional denormalization)
reserve.portal_content_cache:
  id UUID PRIMARY KEY,
  content_type VARCHAR(50), -- 'hero_banner', 'event', 'place'
  portal_id UUID, -- ID in Portal system
  
  -- Content
  title VARCHAR(500),
  description TEXT,
  image_url TEXT,
  cta_url TEXT,
  
  -- Metadata
  site_id UUID, -- Portal site
  city_id UUID, -- Reserve city
  
  -- Validity
  starts_at TIMESTAMPTZ,
  ends_at TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT true,
  
  -- Sync
  last_synced_at TIMESTAMPTZ,
  portal_data_hash VARCHAR(64),
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- City-site mapping (if not done)
reserve.city_site_mappings:
  city_id UUID REFERENCES cities(id),
  site_id UUID, -- Portal site ID
  is_active BOOLEAN DEFAULT true,
  PRIMARY KEY (city_id, site_id)
);
```

**Edge Functions**:
```typescript
// 1. sync_portal_content
// Fetches from Portal API
- Hero banners
- Events
- Places (restaurants, attractions)
- Stores in cache

// 2. get_hero_banners
- Returns active banners for city
- Fallback to default if none

// 3. get_nearby_events
- Events near property
- Date range filter

// 4. get_nearby_restaurants
- Restaurants near property
- Category filter
```

**Acceptance Criteria**:
- [ ] Hero banners display on homepage
- [ ] Events show on property detail
- [ ] Restaurants cross-linked
- [ ] Content updates sync automatically

**Dependencies**:
- Portal Connect API access
- City-site mapping defined
- Content available in Portal

**Risk Flags**:
- 🟢 **LOW**: Content availability (can launch without)
- 🟢 **LOW**: API rate limits (caching mitigates)

---

### SPRINT 8: Authentication & Guest Dashboard (Weeks 17-18)

**Goals**:
- Implement user authentication (delayed per requirements)
- Create guest dashboard
- Booking history
- Profile management

**Deliverables**:
1. Supabase Auth integration
2. Guest registration/login
3. Guest dashboard
4. Booking management (self-service)

**Technical Components**:

```sql
-- Auth is handled by Supabase auth schema
-- Link to travelers

-- Update travelers table
ALTER TABLE reserve.travelers 
ADD COLUMN auth_user_id UUID REFERENCES auth.users(id),
ADD COLUMN password_set_at TIMESTAMPTZ;

-- Guest dashboard preferences
reserve.traveler_preferences:
  traveler_id UUID PRIMARY KEY REFERENCES travelers(id),
  marketing_emails BOOLEAN DEFAULT false,
  whatsapp_notifications BOOLEAN DEFAULT false,
  sms_notifications BOOLEAN DEFAULT false,
  preferred_language VARCHAR(10) DEFAULT 'pt',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Edge Functions**:
```typescript
// 1. register_guest
// Creates auth user
// Links to traveler record
// Sends welcome email

// 2. get_guest_bookings
// Returns bookings for logged-in user
// Pagination support

// 3. update_guest_profile
// Name, phone, preferences

// 4. change_password
// Supabase Auth wrapper

// 5. request_password_reset
// Sends reset email
```

**Acceptance Criteria**:
- [ ] Guest can register
- [ ] Guest can login
- [ ] Dashboard shows booking history
- [ ] Can modify profile

**Dependencies**:
- Supabase Auth configured
- Email templates for auth
- Privacy policy updated for accounts

**Risk Flags**:
- 🟡 **MEDIUM**: Guest checkout vs account (keep guest checkout option)
- 🟢 **LOW**: Auth complexity (Supabase handles)

---

### SPRINT 9-10: Owner Dashboards & Property Tools (Weeks 19-22)

**Goals**:
- Build property owner dashboards
- Financial reporting
- Booking management for owners
- Payout visibility

**Deliverables**:
1. Owner dashboard web app
2. Financial reports (revenue, commissions)
3. Booking calendar view
4. Payout history

**Technical Components**:

```sql
-- Owner dashboard permissions
-- Use RLS policies

-- Property access control
CREATE POLICY owner_property_access ON properties_map
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM host_connect_public.properties hp
      WHERE hp.id = properties_map.host_property_id
      AND hp.user_id = auth.uid()
    )
  );

-- Or use property_owners junction table
reserve.property_owners:
  property_id UUID REFERENCES properties_map(id),
  user_id UUID REFERENCES auth.users(id),
  role VARCHAR(50) DEFAULT 'owner', -- owner, manager
  created_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (property_id, user_id)
);
```

**Edge Functions**:
```typescript
// 1. get_owner_properties
// Properties user owns/manages

// 2. get_owner_bookings
// Bookings for owned properties
// Filter by date range

// 3. get_owner_financials
// Revenue, commissions, payouts
// Monthly breakdown

// 4. get_owner_calendar
- Occupancy view
- Block dates

// 5. update_owner_profile
- Contact info
- Payout preferences
```

**Dashboard Features**:
```
Owner Dashboard:
- Overview: Today's check-ins, revenue, occupancy
- Bookings: List with filters, details
- Calendar: Monthly view, block dates
- Financials: Revenue report, payouts
- Settings: Contact info, notifications
```

**Acceptance Criteria**:
- [ ] Owner sees only their properties
- [ ] Revenue calculations accurate
- [ ] Calendar shows bookings correctly

**Dependencies**:
- Sprint 8 auth complete
- Property ownership data
- Host Connect user mapping

**Risk Flags**:
- 🟡 **MEDIUM**: Owner vs Host Connect access (clear separation)

---

### SPRINT 11-12: ADS Module (Weeks 23-26)

**Goals**:
- Implement advertising system
- Property promotions
- Featured listings
- Campaign tracking

**Technical Components**:

```sql
-- Ads schema (leverage existing from Portal if possible)
reserve.property_promotions:
  id UUID PRIMARY KEY,
  property_id UUID REFERENCES properties_map(id),
  
  -- Campaign
  campaign_name VARCHAR(200),
  promotion_type VARCHAR(50), -- 'featured', 'sponsored', 'banner'
  
  -- Duration
  starts_at TIMESTAMPTZ,
  ends_at TIMESTAMPTZ,
  
  -- Placement
  placement VARCHAR(50), -- 'search_top', 'homepage', 'category'
  
  -- Pricing
  cost_model VARCHAR(50), -- 'cpc', 'cpm', 'flat'
  cost_amount DECIMAL(12,2),
  
  -- Performance
  impressions INTEGER DEFAULT 0,
  clicks INTEGER DEFAULT 0,
  bookings_attributed INTEGER DEFAULT 0,
  revenue_attributed DECIMAL(12,2) DEFAULT 0,
  
  -- Status
  is_active BOOLEAN DEFAULT true,
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Ad impressions tracking
reserve.ad_impressions:
  id UUID PRIMARY KEY,
  promotion_id UUID REFERENCES property_promotions(id),
  session_id VARCHAR(100),
  user_id UUID,
  property_id UUID,
  impression_type VARCHAR(50), -- 'view', 'click'
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Edge Functions**:
```typescript
// 1. get_featured_properties
- Returns promoted properties
- Randomized within tier

// 2. track_ad_impression
- Logs view/click
- Updates counters

// 3. get_ad_campaigns
- Admin: list campaigns
- Performance metrics

// 4. create_ad_campaign
- Admin only
- Schedule promotions
```

**Acceptance Criteria**:
- [ ] Featured properties display correctly
- [ ] Impressions/clicks tracked
- [ ] Campaign ROI calculable

**Dependencies**:
- Owner dashboard complete
- Payment for ads ( Stripe)

**Risk Flags**:
- 🟢 **LOW**: Optional feature

---

## 3) DATABASE EVOLUTION PLAN

### Phase 0: Foundation (Sprint 0)
```sql
-- Schema creation
CREATE SCHEMA reserve;

-- Core reference tables
- cities (seed data)

-- Empty tables ready for sync
- properties_map
- unit_map
- availability_calendar
- reservations
- booking_intents
- sync_jobs
- events
- audit_logs

-- Indexes on primary keys
```

### Phase 1: Sync & Properties (Sprint 1)
```sql
-- Add sync tracking columns
ALTER TABLE properties_map ADD COLUMN sync_status VARCHAR(50);
ALTER TABLE properties_map ADD COLUMN host_last_synced_at TIMESTAMPTZ;

-- Add indexes for search
CREATE INDEX idx_properties_city ON properties_map(city_id);
CREATE INDEX idx_properties_slug ON properties_map(slug);
CREATE INDEX idx_units_property ON unit_map(property_id);

-- Sync jobs table enhanced
-- Add error tracking
```

### Phase 2: Financial (Sprint 2)
```sql
-- New tables
- financial_ledger
- commission_rules
- payouts

-- Ledger indexes
CREATE INDEX idx_ledger_reservation ON financial_ledger(reservation_id);
CREATE INDEX idx_ledger_type ON financial_ledger(transaction_type);

-- Add financial columns to reservations
ALTER TABLE reservations ADD COLUMN commission_amount DECIMAL(12,2);
ALTER TABLE reservations ADD COLUMN net_to_property DECIMAL(12,2);
```

### Phase 3: Booking Flow (Sprint 3)
```sql
-- Booking intent table
- booking_intents

-- Reservation enhancements
ALTER TABLE reservations ADD COLUMN booking_intent_id UUID;
ALTER TABLE reservations ADD COLUMN host_booking_id UUID;
ALTER TABLE reservations ADD COLUMN confirmation_code VARCHAR(50);

-- Availability holds
ALTER TABLE availability_calendar ADD COLUMN temp_holds INTEGER DEFAULT 0;
```

### Phase 4: Payments (Sprint 4)
```sql
-- Payment tracking
- payment_attempts
- pix_transactions

-- Add to booking_intents
ALTER TABLE booking_intents ADD COLUMN stripe_payment_intent_id VARCHAR(100);
ALTER TABLE booking_intents ADD COLUMN pix_transaction_id VARCHAR(100);
```

### Phase 5: Notifications (Sprint 5)
```sql
-- Notification system
- notifications
- notification_templates

-- Add to reservations
ALTER TABLE reservations ADD COLUMN guest_email VARCHAR(255);
```

### Phase 6: Support & Operations (Sprint 6)
```sql
-- Exception handling
- exceptions
- support_activity

-- Add to reservations
ALTER TABLE reservations ADD COLUMN checked_in_at TIMESTAMPTZ;
ALTER TABLE reservations ADD COLUMN checked_out_at TIMESTAMPTZ;
ALTER TABLE reservations ADD COLUMN cancelled_at TIMESTAMPTZ;
```

### Phase 7: Portal (Sprint 7)
```sql
-- Content cache
- portal_content_cache
- city_site_mappings
```

### Phase 8: Auth (Sprint 8)
```sql
-- Auth integration
ALTER TABLE travelers ADD COLUMN auth_user_id UUID;
- traveler_preferences

-- Property ownership
- property_owners
```

### Phase 9-12: Advanced Features
```sql
-- Owner dashboard views
- owner_bookings_view
- owner_financials_view

-- ADS module
- property_promotions
- ad_impressions

-- Advanced reporting tables
- kpi_daily_snapshots (enhanced)
- funnel_events (enhanced)
```

---

## 4) EDGE FUNCTIONS PLAN

### Sprint 0-1: Infrastructure & Sync
```typescript
// health_check.ts - System health endpoint
// sync_host_properties.ts - Property sync from Host
// sync_host_room_types.ts - Room type sync
// sync_host_availability.ts - Availability sync
// get_properties.ts - Public property search
// get_property_detail.ts - Public property detail
```

### Sprint 2: Financial
```typescript
// create_ledger_entry.ts - Double-entry bookkeeping
// calculate_commission.ts - Commission calculation
// create_payout.ts - Payout processing
// reconcile_payments.ts - Daily reconciliation
// get_property_financials.ts - Owner financial data
```

### Sprint 3: Booking
```typescript
// create_booking_intent.ts - Intent creation
// check_availability.ts - Real-time availability
// confirm_booking.ts - Post-payment confirmation
// cancel_booking.ts - Cancellation flow
// modify_booking.ts - Modification flow
// expire_intents.ts - Cron: Expire old intents
```

### Sprint 4: Payments
```typescript
// create_stripe_payment_intent.ts - Stripe integration
// handle_stripe_webhook.ts - Stripe webhooks
// create_pix_payment.ts - PIX QR generation
// handle_pix_webhook.ts - PIX webhooks
// retry_failed_payment.ts - Payment retry
// get_payment_status.ts - Payment status polling
```

### Sprint 5: Notifications
```typescript
// send_notification.ts - Generic dispatcher
// send_email.ts - SendGrid integration
// send_whatsapp.ts - WhatsApp API
// send_sms.ts - Twilio SMS
// process_notification_queue.ts - Cron: Process queue
// handle_sendgrid_webhook.ts - SendGrid tracking
```

### Sprint 6: Admin & Support
```typescript
// get_exception_queue.ts - Exception listing
// assign_exception.ts - Assignment
// resolve_exception.ts - Resolution
// force_cancel_booking.ts - Supervisor override
// get_city_dashboard.ts - City metrics
// get_availability_watchboard.ts - Real-time board
// get_financial_summary.ts - Financial dashboard
```

### Sprint 7: Portal
```typescript
// sync_portal_content.ts - Content sync
// get_hero_banners.ts - Homepage content
// get_nearby_events.ts - Events for property
// get_nearby_restaurants.ts - Restaurants for property
```

### Sprint 8: Auth
```typescript
// register_guest.ts - User registration
// get_guest_bookings.ts - Booking history
// update_guest_profile.ts - Profile updates
// change_password.ts - Password management
// request_password_reset.ts - Password reset
```

### Sprint 9-10: Owner Dashboard
```typescript
// get_owner_properties.ts - Owner's properties
// get_owner_bookings.ts - Owner's bookings
// get_owner_financials.ts - Financial reports
// get_owner_calendar.ts - Occupancy calendar
// update_owner_profile.ts - Owner settings
```

### Sprint 11-12: ADS
```typescript
// get_featured_properties.ts - Promoted listings
// track_ad_impression.ts - Ad tracking
// get_ad_campaigns.ts - Campaign management
// create_ad_campaign.ts - Create promotion
```

---

## 5) FINANCIAL MODULE PLAN

### Ledger Architecture (Double-Entry)

**Accounts**:
```
Assets:
- Cash (Stripe balance)
- Cash (PIX)
- Receivables (pending payouts)

Liabilities:
- Guest prepayments (unearned revenue)
- Property payables (owed to properties)
- Tax payables (ISS, IOF)

Equity:
- Retained earnings

Revenue:
- Commission income
- Ad revenue
- Cancellation fees

Expenses:
- Stripe fees
- PIX fees
- Refunds
```

**Transaction Types**:
```
1. Guest Payment Received
   Debit: Cash +$1,000
   Credit: Guest Prepayment +$1,000

2. Stripe Fee Deduction
   Debit: Stripe Fees -$30
   Credit: Cash -$30

3. Commission Recognition
   Debit: Guest Prepayment -$1,000
   Credit: Property Payable +$850
   Credit: Commission Income +$150

4. Tax Accrual
   Debit: Commission Income -$20
   Credit: Tax Payable +$20

5. Payout to Property
   Debit: Property Payable -$850
   Credit: Cash -$850

6. Guest Refund
   Debit: Guest Prepayment -$1,000
   Credit: Cash -$1,000
   Credit: Refunds +$1,000 (expense)
```

### Commission Engine

**Rules**:
- Default: 15% of base price
- Tiered: 10% for high-volume properties (>50 bookings/month)
- Negotiated: Custom rate per property contract
- Minimum: R$ 50 per booking

**Calculation**:
```typescript
function calculateCommission(booking): Commission {
  const rule = getCommissionRule(booking.property_id);
  let commission = 0;
  
  if (rule.type === 'percentage') {
    commission = booking.base_price * (rule.rate / 100);
  } else if (rule.type === 'fixed') {
    commission = rule.fixed_amount;
  } else if (rule.type === 'tiered') {
    const monthlyVolume = getMonthlyBookingCount(booking.property_id);
    commission = booking.base_price * (getTierRate(monthlyVolume) / 100);
  }
  
  // Apply min/max
  commission = Math.max(commission, rule.min_commission || 0);
  commission = Math.min(commission, rule.max_commission || Infinity);
  
  return commission;
}
```

### Payout Workflow

**Frequency Options**:
- Weekly (every Monday)
- Bi-weekly
- Monthly
- Per-booking (immediate, for high-trust properties)

**Process**:
1. **Calculate**: Sum all confirmed bookings in period
2. **Deduct**: Commissions, fees, refunds
3. **Approve**: Supervisor approval for amounts > R$ 10,000
4. **Transfer**: Stripe Connect or PIX
5. **Reconcile**: Match to ledger
6. **Notify**: Email receipt to property

**Safety Controls**:
- Payout approval required for large amounts
- Balance checks before transfer
- Failed payout queue with retry
- Manual override capability

### Tax Handling

**Brazilian Taxes**:
- **ISS** (Service Tax): 2-5% depending on municipality
- **IOF** (Financial Operations Tax): 0.38% on PIX transfers
- **PIS/COFINS**: On commission revenue (if applicable)

**Implementation**:
```sql
-- Tax rules by city
reserve.tax_rules:
  city_id UUID,
  tax_type VARCHAR(50),
  rate DECIMAL(5,2),
  applies_to VARCHAR(50) -- 'commission', 'payout', 'booking'
```

---

## 6) MONITORING & OBSERVABILITY PLAN

### Application Performance Monitoring (APM)

**Tool**: Sentry or Datadog
**Metrics**:
- API response times (p50, p95, p99)
- Error rates by endpoint
- Database query performance
- Edge Function execution time

**Alerts**:
- Error rate > 1% for 5 minutes
- API response time > 2s for 10 minutes
- Database connection pool exhaustion

### Business Metrics Tracking

**Tool**: Custom dashboard + Metabase
**Metrics**:
- Conversion funnel (search → booking)
- Payment success rate
- Host API success rate
- Booking confirmation time
- Exception queue depth

**Dashboards**:
1. **Executive Dashboard**: Revenue, bookings, conversion rate
2. **Operations Dashboard**: Exceptions, support tickets, sync status
3. **Engineering Dashboard**: API health, errors, performance

### Financial Monitoring

**Daily Reconciliation**:
- Stripe balance vs ledger
- PIX transactions vs ledger
- Payouts vs ledger
- Alert on any 1c discrepancy

**Weekly Reports**:
- Revenue by property
- Commission earned
- Payouts processed
- Outstanding payables

### Log Aggregation

**Structured Logging**:
```json
{
  "timestamp": "2026-03-01T10:30:00Z",
  "level": "info",
  "service": "reserve-connect",
  "function": "confirm_booking",
  "request_id": "req-123",
  "user_id": "user-456",
  "reservation_id": "res-789",
  "duration_ms": 250,
  "status": "success"
}
```

**Log Retention**: 30 days hot, 1 year cold storage

### Alerting Configuration

**PagerDuty (Critical)**:
- Host API completely down
- Payment processing failure rate > 20%
- Database unreachable
- Booking confirmation time > 2 minutes
- Exception queue > 10 items for > 30 minutes

**Slack (Warning)**:
- API error rate > 5%
- Individual property sync failure
- Email delivery failures
- PIX provider errors

**Email (Daily Digest)**:
- Booking summary
- Revenue report
- System health status

---

## 7) HUMAN OPERATIONS ENABLEMENT

### Support Agent Training Program

**Week 1: System Overview**
- Three-system architecture
- Booking lifecycle
- Financial flow

**Week 2: Console Training**
- Searching bookings
- Processing cancellations
- Managing exceptions
- Financial adjustments

**Week 3: Scenarios**
- Payment failed after confirmation
- Guest wants to modify dates
- Property overbooked
- No-show processing

**Week 4: Shadowing**
- Shadow experienced agent
- Handle supervised transactions
- Q&A with engineering team

### Standard Operating Procedures (SOPs)

**SOP-001: Booking Cancellation**
1. Authenticate guest (email + confirmation code)
2. Review cancellation policy
3. Calculate refund amount
4. Process cancellation in system
5. Process refund via Stripe
6. Cancel in Host Connect
7. Send confirmation email
8. Log in support_activity

**SOP-002: Exception Resolution**
1. Review exception details
2. Check Host Connect status
3. If transient error: Retry
4. If permanent failure: Cancel & refund
5. If requires override: Supervisor approval
6. Document resolution
7. Close exception ticket

**SOP-003: No-Show Processing**
1. Verify guest hasn't checked in
2. Confirm with property via phone
3. Mark as no-show in system
4. Apply no-show fee (if policy)
5. Release inventory
6. Update financials

### Support Console UI/UX

**Dashboard Layout**:
```
┌─────────────────────────────────────────────┐
│ Header: Logo, City Selector, User Menu     │
├─────────────────────────────────────────────┤
│ Sidebar                                     │
│ - Dashboard                                 │
│ - Bookings (Search)                         │
│ - Exceptions (Queue)                        │
│ - Properties                                │
│ - Travelers                                 │
│ - Reports                                   │
│ - Settings                                  │
├─────────────────────────────────────────────┤
│ Main Content Area                           │
│ - Dynamic based on route                    │
└─────────────────────────────────────────────┘
```

**Booking Detail View**:
- Guest info (name, contact)
- Booking details (dates, unit, price)
- Payment status
- Host Connect status
- Action buttons (Cancel, Modify, Refund)
- Communication history
- Audit log

### Escalation Matrix

**Level 1: Agent**
- Standard cancellations
- Booking modifications
- Guest inquiries
- Exception resolution (routine)

**Level 2: Supervisor**
- Policy overrides
- Large refunds (> R$ 5,000)
- Host disputes
- Complex exceptions
- System failures

**Level 3: Engineering**
- Data corruption
- API failures
- Security incidents
- Financial discrepancies

---

## 8) ADS MODULE PLAN

### Overview
Reserve Connect ADS module allows properties to purchase promoted placement.

### Ad Types

**1. Featured Listings**
- Appear at top of search results
- "Featured" badge
- Pricing: CPC or flat monthly fee

**2. Homepage Hero**
- Banner on homepage
- Rotating carousel
- Pricing: CPM or flat weekly fee

**3. Category Sponsorship**
- Sponsored section in category pages
- "Recommended by [Property]"
- Pricing: Flat monthly

### Campaign Management

**Self-Service** (Future):
- Property owner creates campaign
- Sets budget and duration
- Uploads creative
- Tracks performance

**Managed Service** (MVP):
- Sales team creates campaigns
- Properties billed separately
- Manual performance reports

### Tracking & Attribution

**Metrics**:
- Impressions
- Clicks
- Click-through rate (CTR)
- Bookings attributed
- Revenue attributed
- Return on ad spend (ROAS)

**Attribution Window**: 7 days (click), 1 day (view)

### Revenue Model

**Pricing**:
- Featured Listing: R$ 5-15 per click
- Homepage Hero: R$ 500-2,000 per week
- Category Sponsorship: R$ 300-1,000 per month

**Revenue Share**: 100% to Reserve Connect (no split)

---

## 9) KPI & DASHBOARD PLAN

### Executive KPIs

**Financial**:
- Gross Booking Volume (GBV): Target R$ 100k/month by month 6
- Net Revenue (Commissions): Target R$ 15k/month
- Average Booking Value: Target R$ 800
- Payout Accuracy: 100%

**Operational**:
- Booking Confirmation Time: < 30 seconds
- Exception Resolution Time: < 30 minutes
- Support Tickets per Booking: < 0.1
- System Uptime: 99.9%

**Growth**:
- Monthly Bookings: 50 → 200 → 500
- Properties Onboarded: 10 → 50 → 200
- Conversion Rate: 3% → 5% → 7%
- Repeat Guest Rate: Target 30%

### Dashboard Specifications

**1. City Operations Dashboard**
```
Real-Time Section:
- Today's Bookings: Count + Revenue
- Check-ins Today: List with status
- Exception Queue: Count + Oldest Item
- System Health: All green/yellow/red

Charts:
- Hourly Booking Volume (today vs yesterday)
- Revenue by Property (top 10)
- Availability Heatmap (all properties)

Tables:
- Recent Bookings (last 10)
- Pending Exceptions
- Today's Check-ins
```

**2. Financial Dashboard**
```
Summary Cards:
- Revenue This Month: R$ XX,XXX
- Commissions Earned: R$ X,XXX
- Payouts This Month: R$ XX,XXX
- Outstanding Payables: R$ X,XXX

Charts:
- Daily Revenue (30 days)
- Revenue by Property
- Commission Rate Trend
- Payout Schedule

Reports:
- Monthly P&L
- Property Revenue Report
- Tax Liability Report
```

**3. Conversion Funnel Dashboard**
```
Funnel Visualization:
- Search: 10,000
- Property View: 4,000 (40%)
- Booking Intent: 600 (15%)
- Payment Attempt: 420 (70%)
- Payment Success: 357 (85%)
- Booking Confirmed: 353 (99%)
- Overall: 3.53%

Drop-off Analysis:
- Search → View: 60% drop (improve search relevance)
- View → Intent: 85% drop (pricing issue?)
- Intent → Payment: 30% drop (checkout friction)
- Payment → Success: 15% drop (payment failures)

A/B Test Results:
- Control vs Variant conversion rates
```

### Reporting Schedule

**Daily (8am)**:
- Booking summary (previous day)
- Revenue report
- Exception summary

**Weekly (Monday 9am)**:
- Weekly business review
- Property performance ranking
- Support ticket analysis

**Monthly (1st of month)**:
- Financial statements
- Payout reports
- Tax calculations
- Business metrics deck

---

## 10) WHEN TO REMIX ADS CONNECT PROJECT

### Remix Triggers

**Phase 1: MVP Launch (Sprint 6)**
- **Do NOT remix yet**
- Focus on core booking flow
- ADS module is Sprint 11-12

**Phase 2: Post-MVP (Sprint 9-10)**
- **Evaluate**: Owner dashboards done?
- **If YES**: Begin ADS module planning
- **If NO**: Delay ADS to Sprint 13-14

**Phase 3: Growth Phase (Month 4)**
- **Remix Condition**: > 50 properties AND > 200 monthly bookings
- **Reason**: Need ad inventory to sell
- **Scope**: Port ADS Connect features to Reserve Connect

### Remix Strategy

**Option A: Full Integration**
- Merge ADS Connect codebase into Reserve Connect
- Unified database schema
- Single admin console

**Option B: Service Integration**
- Keep ADS Connect as separate service
- API integration between systems
- Shared property database

**Recommendation**: Option A (Full Integration)
**Rationale**:
- Simpler operations
- Single source of truth
- Unified user experience
- Lower maintenance cost

### Remix Checklist

- [ ] ADS Connect features catalogued
- [ ] Database schema alignment planned
- [ ] Migration scripts prepared
- [ ] Code review completed
- [ ] Test coverage > 80%
- [ ] Performance benchmarks met
- [ ] Documentation updated

---

## 11) ACCEPTANCE GATES BETWEEN PHASES

### Gate 0: Foundation Complete (End of Sprint 0)
**Criteria**:
- [ ] Database schemas created
- [ ] CI/CD pipeline operational
- [ ] Stripe test account working
- [ ] PIX test environment connected
- [ ] Host Connect API accessible
- [ ] Monitoring stack configured

**Sign-off**: CTO + DevOps Lead

---

### Gate 1: Property Sync Operational (End of Sprint 1)
**Criteria**:
- [ ] 5+ properties synced from Host
- [ ] Images loading correctly
- [ ] Availability calendar populated
- [ ] Sync monitoring active
- [ ] Failed syncs alert properly
- [ ] Property API response time < 500ms

**Sign-off**: Engineering Lead + QA Lead

---

### Gate 2: Financial System Ready (End of Sprint 2)
**Criteria**:
- [ ] Ledger entries balance (test transactions)
- [ ] Commission calculated correctly (5 test scenarios)
- [ ] Payout amounts accurate
- [ ] Reconciliation detects discrepancies
- [ ] Tax calculations reviewed by accountant
- [ ] Stripe Connect onboarding process documented

**Sign-off**: CFO + Engineering Lead + External Accountant

---

### Gate 3: Booking Flow Complete (End of Sprint 3)
**Criteria**:
- [ ] Intent → Reservation flow working
- [ ] 15-minute TTL expires correctly
- [ ] Soft holds prevent overbooking
- [ ] Confirmation codes generated
- [ ] State machine transitions verified
- [ ] Cancellation policy enforced

**Sign-off**: Product Lead + QA Lead

---

### Gate 4: Payment Processing Ready (End of Sprint 4)
**Criteria**:
- [ ] Stripe card payments succeed
- [ ] PIX QR codes generate and scan
- [ ] 3D Secure handled correctly
- [ ] Failed payments allow retry
- [ ] Webhooks processed correctly
- [ ] Reconciliation matches providers

**Sign-off**: Engineering Lead + QA Lead + Payment Provider

---

### Gate 5: Communications Working (End of Sprint 5)
**Criteria**:
- [ ] Confirmation emails sent < 30s
- [ ] Email templates render correctly
- [ ] WhatsApp templates approved (if applicable)
- [ ] Failed notifications retry
- [ ] Unsubscribe links functional
- [ ] SPF/DKIM configured

**Sign-off**: Marketing Lead + QA Lead

---

### Gate 6: MVP LAUNCH READY (End of Sprint 6)
**Criteria**:
- [ ] 10-20 properties onboarded
- [ ] 10+ end-to-end test bookings
- [ ] Support team trained
- [ ] Exception queue manageable
- [ ] Monitoring dashboards active
- [ ] PagerDuty alerts configured
- [ ] Terms of service published
- [ ] Privacy policy published
- [ ] Support channels active
- [ ] Load test passed (100 concurrent users)
- [ ] Security audit passed
- [ ] Backup/recovery tested

**Sign-off**: CEO + CTO + COO + QA Lead

**Launch Authorization**: Executive Team

---

### Gate 7: Content Integration (End of Sprint 7)
**Criteria**:
- [ ] Portal content displays
- [ ] Hero banners rotate
- [ ] Events show on property pages
- [ ] Content syncs automatically

**Sign-off**: Product Lead + QA Lead

---

### Gate 8: Authentication & Dashboards (End of Sprint 10)
**Criteria**:
- [ ] Guest registration/login works
- [ ] Guest dashboard functional
- [ ] Owner dashboards accessible
- [ ] Financial reports accurate
- [ ] RBAC enforced correctly

**Sign-off**: Product Lead + QA Lead + Security Review

---

### Gate 9: Scale Ready (End of Sprint 12)
**Criteria**:
- [ ] 50+ properties onboarded
- [ ] Multi-city support tested
- [ ] ADS module functional
- [ ] Performance benchmarks met
- [ ] Documentation complete

**Sign-off**: CTO + Engineering Lead

---

## 12) RISK MITIGATION STRATEGY

### High-Risk Items

#### Risk 1: Payment Provider Integration Failure
**Impact**: Cannot process payments, blocking bookings
**Mitigation**:
- Stripe as primary (reliable)
- PIX as secondary (have fallback)
- Manual payment option for phone bookings
- Extensive testing in sandbox

**Contingency**: Launch with Stripe only, add PIX in Sprint 7

---

#### Risk 2: Host Connect API Downtime
**Impact**: Cannot confirm bookings, guest experience degraded
**Mitigation**:
- Circuit breaker pattern
- Booking queue for retry
- Graceful degradation messaging
- Manual booking process documented

**Contingency**: Exception queue process + manual Host entry by support

---

#### Risk 3: Double Booking (Race Condition)
**Impact**: Two guests book same room, property chaos
**Mitigation**:
- Database row locking on availability check
- Soft holds during payment
- Idempotent Host API calls
- Availability re-verification before confirmation
- Exception detection and auto-resolution

**Contingency**: Manual overbooking resolution process

---

#### Risk 4: Financial Calculation Errors
**Impact**: Incorrect payouts, tax issues, legal liability
**Mitigation**:
- Double-entry ledger (must balance)
- Daily reconciliation with providers
- External accountant review
- Audit trail for all transactions
- Payout approval for large amounts

**Contingency**: Financial freeze + manual review + corrections

---

#### Risk 5: Data Corruption
**Impact**: Lost bookings, incorrect financials
**Mitigation**:
- Daily automated backups
- Point-in-time recovery (PITR)
- Transaction logs
- Data validation on writes
- Regular restore testing

**Contingency**: Restore from backup + manual reconciliation

---

#### Risk 6: Security Breach
**Impact**: Guest data stolen, PCI violations
**Mitigation**:
- Stripe handles card data (PCI scope reduced)
- RLS policies on all tables
- Encryption at rest
- Regular security audits
- Penetration testing before launch

**Contingency**: Incident response plan + breach notification process

---

#### Risk 7: Launch Day Traffic Surge
**Impact**: System crash, lost bookings
**Mitigation**:
- Load testing (100+ concurrent users)
- Auto-scaling (if using serverless)
- Circuit breakers
- Rate limiting
- Gradual rollout (invite-only first)

**Contingency**: Scale up infrastructure + queuing

---

#### Risk 8: Support Team Overwhelmed
**Impact**: Poor customer experience, churn
**Mitigation**:
- Extensive training before launch
- Clear escalation procedures
- Automated responses for common issues
- Exception queue limits with alerts
- Gradual property onboarding (not all at once)

**Contingency**: Temporary additional staff + extended hours

---

### Risk Register

| Risk | Probability | Impact | Mitigation Status | Owner |
|------|------------|--------|-------------------|-------|
| Payment integration failure | Low | Critical | In Progress | Engineering |
| Host Connect downtime | Medium | High | Planned | Engineering |
| Double booking | Low | Critical | Implemented | Engineering |
| Financial errors | Low | Critical | In Progress | Engineering + Finance |
| Data corruption | Very Low | Critical | Implemented | DevOps |
| Security breach | Low | Critical | In Progress | Security Lead |
| Traffic surge | Medium | High | Planned | Engineering |
| Support overwhelmed | Medium | Medium | Planned | Operations |

---

## APPENDIX: GLOSSARY

**Merchant of Record**: Entity that processes payments, assumes liability, and handles tax compliance
**Soft Hold**: Temporary inventory reservation (15 min) during payment
**Hard Block**: Permanent inventory block after booking confirmed
**Idempotency**: Operation that produces same result if called multiple times
**Circuit Breaker**: Pattern that prevents cascading failures
**Payout**: Transfer of funds to property owner
**Commission**: Fee charged by platform (percentage of booking)
**Reconciliation**: Process of matching financial records
**Exception Queue**: List of failed operations requiring manual intervention

---

**Document Owner**: Lead Technical Architect  
**Review Cycle**: Weekly during sprints  
**Next Review**: Sprint 0 Kickoff  
**Distribution**: Engineering Team, Product Team, Executive Team

---

*This execution plan represents a complete, implementation-ready roadmap from zero to MVP launch and beyond. All phases are designed with 2-week sprint cadence, clear acceptance criteria, and comprehensive risk mitigation.*
