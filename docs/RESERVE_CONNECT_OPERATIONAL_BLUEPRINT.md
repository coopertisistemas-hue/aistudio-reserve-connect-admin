# RESERVE CONNECT - CENTRAL RESERVATIONS OPERATIONAL BLUEPRINT

**Version**: 1.0  
**Date**: 2026-02-15  
**Author**: CEO/COO Architecture  
**Status**: Implementation-Ready Design Document

---

## A) EXECUTIVE SUMMARY

1. **Reserve Connect** is the Central Reservations distribution layer, orchestrating bookings across a city-wide network of lodging properties while Host Connect remains the operational master.

2. **Three-System Architecture**: Host Connect (operations master) ↔ Reserve Connect (distribution orchestrator) ↔ Portal Connect (content enrichment), with Reserve as the transaction coordinator.

3. **Human-in-the-Loop Design**: Central Reservations team monitors city-wide availability, handles exceptions, and provides white-glove support for complex bookings or failures.

4. **Canonical Data Strategy**: Host owns properties/inventory/bookings; Reserve owns reservations/payments/sync orchestration; Portal owns content/events. No data duplication without explicit sync contracts.

5. **Real-Time Availability**: City-wide availability watchboard queries Reserve's cached view of Host inventory, updated via webhooks with 30-second SLA for critical booking operations.

6. **Booking State Machine**: 11 distinct states with explicit failure recovery paths:
   - Intent → Payment Pending → Payment Confirmed → Host Commit Pending → Confirmed → Checked-In → Completed
   - Failure states: Host Commit Failed, Refund Pending, Cancel Pending
   - All failures route to exception queue for agent resolution

7. **Payment-First Model**: Guest payment confirms before inventory commit, eliminating double-booking risk. Failed payments auto-release holds within 15 minutes.

8. **Idempotent Operations**: All Host Connect calls use idempotency keys; duplicate booking attempts return existing reservation instead of creating conflicts.

9. **Failure Resilience**: Circuit breakers isolate Host downtime; bookings queue for retry; support agents can manual-override with full audit trails.

10. **Multi-Tenant Isolation**: Strict `city_code` boundaries; properties can only see their own bookings; Central Reservations sees city-wide aggregate.

11. **Notification Orchestration**: Guest receives email confirmation + WhatsApp (opt-in); property receives system inbox notification + email + WhatsApp Business API.

12. **Inventory Blocking Strategy**: Soft holds (15-min) during payment → Hard blocks (confirmation) synced to Host → Auto-release on cancellation/no-show.

13. **Cancellation Policy Engine**: Flexible rules (24h/48h/72h free cancellation) enforced automatically with automatic refund triggers.

14. **Support Agent Console**: Web-based interface for CRUD operations on bookings, manual inventory adjustments, exception queue management, and guest communication.

15. **Monitoring-First**: Every operation emits events; real-time dashboards track conversion funnel, Host integration health, payment success rates, and SLA compliance.

16. **Audit Everything**: Complete audit trail (who, what, when, before/after) for all booking modifications, manual overrides, and system actions.

17. **MVP Scope**: Single city (Urubici), 10-20 properties, Stripe + PIX payments, email notifications, basic support console, 30-day availability window.

18. **Revenue Model**: Commission per booking (10-15%) collected at payment time; net payout to properties weekly or per-booking based on preference.

19. **Portal Integration**: Content (events, restaurants, attractions) enriches property listings but does not duplicate lodging inventory; cross-link by city_code.

20. **Scale Architecture**: Phase 2 adds multi-city, Phase 3 adds OTA distribution (Booking.com/Airbnb), Phase 4 adds mobile apps and AI chatbot support.

---

## B) END-TO-END PROCESS MAP

### Process 1: Availability Search (Guest Journey)

1. **Guest enters search criteria** on `/city` or `/hospedagens`
   - Inputs: `city_code`, `check_in`, `check_out`, `guests` (adults+children)
   - System validates dates (check_out > check_in, max 30 nights)

2. **System queries Reserve availability index**
   - Joins: `properties_map` + `unit_map` + `availability_calendar`
   - Filters: `city_id`, date range, `is_available=true`, `allotment > bookings_count`
   - Returns: Available properties with lowest price per unit

3. **Guest views results on `/hospedagens`**
   - Cards show: image, name, rating, price from, amenities tags
   - Filters applied: property type, price range, amenities
   - Pagination: 20 results per page

4. **Guest selects property**, navigates to `/hospedagem/:slug`
   - System fetches: Property details, unit types, availability calendar
   - Shows: Gallery, description, amenities, reviews, location map

5. **Guest selects unit type and dates**
   - System validates: Unit available for all dates in range
   - Calculates: Nightly rates sum + taxes + fees = Total
   - Displays: Cancellation policy, house rules

### Process 2: Booking Intent & Hold

6. **Guest clicks "Book Now"**
   - System creates: `booking_intent` record (15-min TTL)
   - Fields: `property_id`, `unit_id`, `dates`, `guest_details`, `price_breakdown`
   - Status: `intent_created`

7. **System places soft inventory hold**
   - Increments: `availability_calendar.temp_holds` counter
   - TTL: 15 minutes (configurable)
   - Prevents overbooking during payment flow

8. **Guest enters traveler details**
   - Fields: First name, last name, email, phone, document (optional for now)
   - Validation: Email format, phone format
   - Creates/updates: `travelers` record

9. **System displays payment form** (Stripe Elements)
   - Shows: Total amount, deposit amount (if applicable), cancellation policy
   - Calculates: Payment schedule (full now, or deposit + balance later)

### Process 3: Payment Processing

10. **Guest submits payment**
    - System creates: Stripe Payment Intent
    - Updates: `booking_intent.payment_intent_id`, status: `payment_pending`

11. **Stripe processes payment**
    - Success: Webhook received → Proceed to step 12
    - Failure: Error displayed → Guest can retry (hold extended 5 min) or cancel
    - 3D Secure: Challenge flow handled by Stripe

12. **Payment confirmed**
    - Updates: `booking_intent.status` = `payment_confirmed`
    - Creates: `reservations` record (permanent)
    - Generates: `confirmation_code` (format: RES-YYYY-XXXXXX)

### Process 4: Inventory Commitment

13. **System commits inventory to Host Connect**
    - API Call: `POST /api/v1/bookings` (Host Connect)
    - Payload: Property ID, room type, dates, guest details, external ref
    - Idempotency Key: `reservation.id` (prevents duplicates)

14. **Host responds with booking confirmation**
    - Success: Host returns `booking_id` (Host's internal ID)
    - Updates: `reservations.host_booking_id`, status: `confirmed`
    - Syncs: Availability calendar blocked for dates

15. **Host failure handling** (alternate path)
    - If Host API timeout/error: Queue for retry (max 3 attempts)
    - If Host rejects (no availability): Enter exception queue
    - If Host permanently down: Manual intervention required

### Process 5: Notifications & Confirmation

16. **Guest confirmation triggered**
    - Email: HTML confirmation with booking details, cancellation policy, property contact
    - WhatsApp (if opted in): Summary message with confirmation code
    - SMS (optional): Confirmation code only

17. **Property notification triggered**
    - System Inbox: Booking appears in Host Connect dashboard
    - Email: To property's reservation email
    - WhatsApp Business: To property's WhatsApp (if configured)

18. **Invoice/receipt generation**
    - Creates: `invoices` record
    - Sends: PDF receipt to guest email
    - Stores: Stripe receipt URL

19. **Soft hold released**
    - Decrements: `availability_calendar.temp_holds`
    - Hard block remains via Host booking

### Process 6: Post-Booking Operations

20. **Booking reminder** (T-24 hours before check-in)
    - Email: Check-in instructions, property contact, what to bring

21. **Check-in day**
    - Guest arrives, Host checks them in
    - Host updates: Booking status in Host Connect → `checked_in`
    - Sync to Reserve: Status updated via webhook

22. **Check-out day**
    - Host checks out guest
    - Status: `checked_out`
    - System: Available for review request (3 days later)

23. **Review request**
    - Email to guest: "How was your stay?"
    - Creates: `review_invitations` record
    - Reviews collected feed into `properties_map.rating_cached`

### Process 7: Modifications & Cancellations

24. **Guest-initiated modification**
    - Dates: Check availability → If available, update booking
    - Guests: Validate capacity → Update if within limits
    - Unit type: Check availability → Update with price adjustment
    - Payment: Charge difference or refund via Stripe

25. **Guest-initiated cancellation**
    - Check: Cancellation policy rules
    - Within free period: Full refund, booking cancelled
    - After free period: Partial refund per policy
    - Updates: `reservations.status` = `cancelled`

26. **Inventory release on cancellation**
    - API Call: `DELETE /api/v1/bookings/:id` (Host)
    - Or: Update status to `cancelled` in Host
    - Sync: Availability calendar unblocked

27. **Refund processing**
    - Stripe refund initiated
    - Updates: `reservations.payment_status` = `refunded`
    - Notification: Refund confirmation email

### Process 8: No-Shows & Exceptions

28. **No-show detection** (Day after check-in, 12:00 PM)
    - If status != `checked_in`: Mark as `no_show`
    - Policy: Charge no-show fee (if applicable)
    - Inventory: Released after no-show window

29. **Exception queue monitoring**
    - Scenarios: Payment confirmed but Host failed, Double booking detected, Manual approval required
    - Support agent: Reviews queue, takes action
    - Actions: Retry Host call, Cancel & refund, Override & force booking

30. **Audit trail complete**
    - Every action logged to `audit_logs`
    - Who: User ID or support agent ID
    - What: Action type, before/after state
    - When: Timestamp with timezone

---

## C) DATA OWNERSHIP MATRIX

| Entity | System of Record | Sync Direction | Notes |
|--------|-----------------|----------------|-------|
| **Properties** | Host Connect | Host → Reserve | Reserve caches for distribution; `is_published` flag controls visibility |
| **Room Types** | Host Connect | Host → Reserve | Reserve `unit_map` mirrors Host `room_types` |
| **Physical Rooms** | Host Connect | None | Operational detail, not needed in Reserve |
| **Availability** | Host Connect | Host ↔ Reserve | Bidirectional: Host updates push to Reserve; OTA bookings in Reserve push to Host |
| **Pricing Rules** | Host Connect | Host → Reserve | Reserve can override for distribution-specific pricing |
| **Bookings (Operational)** | Host Connect | Bidirectional | Host = operational state; Reserve = transaction record |
| **Reservations (Distribution)** | Reserve Connect | N/A | Reservation entity is Reserve's core domain |
| **Guests (CRM)** | Host Connect | Reserve → Host | Travelers become Guests on first booking per property |
| **Travelers (Distribution)** | Reserve Connect | N/A | Reserve's traveler profiles with booking history |
| **Payments** | Reserve Connect | N/A | Stripe integration owned by Reserve |
| **Cities** | Reserve Connect | None | Reserve defines city codes; Portal maps to sites |
| **Site Content** | Portal Connect | None | Events, restaurants, attractions - Portal exclusive |
| **Reviews** | Reserve Connect | None | Review aggregation and display owned by Reserve |
| **Support Tickets** | Reserve Connect | None | Central Reservations operations |
| **Audit Logs** | Each System | None | Each system logs its own domain |
| **KPIs/Analytics** | Reserve Connect | Aggregated | Funnel events, conversion metrics |

### Cross-System Key Mapping

| Reserve Connect | Host Connect | Portal Connect | Canonical Key |
|----------------|--------------|----------------|---------------|
| `properties_map.host_property_id` | `properties.id` | `places.external_id` | Host `id` |
| `properties_map.slug` | - | `places.slug` | Reserve `slug` |
| `unit_map.host_unit_id` | `room_types.id` | - | Host `id` |
| `cities.code` | - | `sites.slug` | Reserve `code` (e.g., 'URB') |
| `reservations.id` | `bookings.external_id` | - | Reserve `id` |

---

## D) OPERATIONAL ROLES & HUMAN WORKFLOWS

### Role Definitions

#### 1. Central Reservations Agent (Agent)
- **Volume**: 2-3 agents per city during business hours
- **Access**: Support console (web app), read access to all city bookings
- **Permissions**: 
  - View all bookings and guest details
  - Cancel bookings with refund
  - Modify booking details (dates, guests)
  - Process manual payments/refunds
  - Communicate with guests and properties
  - Manage exception queue
- **SLA**: Respond to support tickets within 2 hours during business hours

#### 2. Central Reservations Supervisor (Supervisor)
- **Volume**: 1 per city
- **Access**: Full support console + dashboards + reports
- **Permissions**:
  - All Agent permissions
  - Override any booking (bypass policies)
  - Access financial reports
  - Manage agent accounts
  - Configure city-wide settings
  - Handle escalations
- **SLA**: Respond to escalations within 30 minutes

#### 3. Property Manager (Property)
- **Access**: Host Connect (separate system)
- **In Reserve**: Read-only access to their own bookings, update check-in/check-out status
- **Permissions**:
  - View bookings for their properties
  - Update booking status (check-in, check-out)
  - Add internal notes
  - Cannot cancel/modify without contacting support
- **Integration**: Primarily via Host Connect, Reserve provides booking notifications

#### 4. System Administrator (Admin)
- **Volume**: 1-2 global
- **Access**: All systems, database, infrastructure
- **Permissions**: Full system access, user management, configuration

### Workflow 1: Exception Queue Management

**Scenario**: Payment confirmed but Host API failed (booking not created in Host)

1. **System detects failure** after 3 retry attempts
2. **Alert**: PagerDuty notification to on-call + ticket created in exception queue
3. **Agent views exception** in support console:
   - Reservation details
   - Error message from Host
   - Retry button
   - Force cancel button
   - Manual override button

4. **Agent decision tree**:
   - **Option A**: Retry Host API (if transient error)
   - **Option B**: Cancel reservation + refund guest (if Host permanently rejecting)
   - **Option C**: Manual override (create booking manually in Host, link IDs)

5. **Resolution logged** in audit trail with agent ID

**SOP Document**: SOP-001-Host-Booking-Failure-Resolution

### Workflow 2: Guest Cancellation Request

**Scenario**: Guest calls support to cancel booking

1. **Agent authenticates guest**: Email + confirmation code + verification question
2. **Agent retrieves booking**: Views cancellation policy and refund eligibility
3. **Policy check**:
   - Within free period: Full refund
   - After free period: Partial refund
   - Non-refundable: No refund (supervisor override required)

4. **Agent initiates cancellation** in support console
5. **System actions**:
   - Cancel in Host Connect
   - Process Stripe refund
   - Send cancellation confirmation email
   - Release inventory

6. **Guest receives**: Confirmation of cancellation and refund timeline

**SOP Document**: SOP-002-Guest-Cancellation-Processing

### Workflow 3: No-Show Processing

**Scenario**: Guest doesn't arrive, booking status remains `confirmed`

1. **System detects**: Current date > check_in date, status != `checked_in`
2. **Grace period**: 12 hours after standard check-in time
3. **Auto-action**: System marks as `no_show`
4. **Property notification**: Email to property confirming no-show
5. **Payment action**: No-show fee charged (if policy applies)
6. **Agent review**: Weekly no-show report for pattern analysis

**SOP Document**: SOP-003-No-Show-Processing

### Workflow 4: Overbooking Resolution

**Scenario**: Host confirms booking but was actually full (double booking)

1. **Property contacts support** via phone/email
2. **Supervisor assesses**:
   - Alternative room type available?
   - Alternative property available?
   - Upgrade possible?

3. **Guest communication**:
   - Apologize + explain
   - Offer alternatives
   - Provide compensation (discount, upgrade, refund)

4. **System updates**:
   - Move booking to alternative unit/property
   - Price adjustment (refund difference)
   - Update guest on new confirmation

5. **Post-incident**: Review with property to prevent recurrence

**SOP Document**: SOP-004-Overbooking-Resolution

### RACI Matrix for Key Operations

| Operation | Agent | Supervisor | Property | System | Notes |
|-----------|-------|------------|----------|--------|-------|
| View booking | R | R | R (own) | - | All can view |
| Cancel booking | R | A | - | C | Agent can cancel; Supervisor approves exceptions |
| Modify booking | R | A | - | C | Date/guest changes |
| Process refund | R | A | - | C | Refund to guest |
| Check-in guest | - | - | R | - | Property updates status |
| Handle exceptions | R | A | - | C | Exception queue |
| Override policy | - | R | - | - | Supervisor only |
| Configure city | - | R | - | - | City settings |
| Block inventory | - | R | A | C | Manual holds |
| Resolve overbooking | C | R | C | C | Supervisor leads |
| Generate reports | R | R | - | C | Reporting access |

*R = Responsible, A = Accountable, C = Consulted, I = Informed*

---

## E) REQUIRED FEATURES LIST

### Domain 1: Guest-Facing Features

#### Search & Discovery
- [ ] **F-001**: City-wide availability search by dates and guests
- [ ] **F-002**: Property listing with filters (type, price, amenities, rating)
- [ ] **F-003**: Property detail page with gallery, amenities, map, reviews
- [ ] **F-004**: Unit type selection with pricing breakdown
- [ ] **F-005**: Availability calendar view (dates and pricing)
- [ ] **F-006**: Event and content enrichment (nearby restaurants, attractions)

#### Booking Flow
- [ ] **F-007**: Booking intent creation with 15-min hold
- [ ] **F-008**: Guest details collection (name, email, phone, document)
- [ ] **F-009**: Stripe payment integration (cards, PIX for Brazil)
- [ ] **F-010**: Payment retry on failure
- [ ] **F-011**: Booking confirmation page with confirmation code
- [ ] **F-012**: Confirmation email (HTML + PDF receipt)
- [ ] **F-013**: WhatsApp notifications (opt-in)
- [ ] **F-014**: Booking modification (dates, guests) - self-service
- [ ] **F-015**: Cancellation request with policy enforcement

#### Post-Booking
- [ ] **F-016**: Booking management dashboard (for logged-in users)
- [ ] **F-017**: Check-in reminder emails (24h, 2h before)
- [ ] **F-018**: Review submission (post-stay)
- [ ] **F-019**: Rebooking discounts (loyalty program Phase 2)

### Domain 2: Property/Host Integration

#### Inventory Management
- [ ] **F-020**: Real-time availability sync from Host
- [ ] **F-021**: Soft hold mechanism (15-min TTL)
- [ ] **F-022**: Hard block on confirmed booking
- [ ] **F-023**: Automatic release on cancellation
- [ ] **F-024**: Blocked dates display (maintenance, owner use)

#### Booking Operations
- [ ] **F-025**: New booking notification (system, email, WhatsApp)
- [ ] **F-026**: Booking detail view in Host Connect
- [ ] **F-027**: Check-in/check-out status updates
- [ ] **F-028**: Guest communication (via Host Connect)
- [ ] **F-029**: No-show marking

#### Configuration
- [ ] **F-030**: Cancellation policy configuration (24h/48h/72h)
- [ ] **F-031**: Deposit rules (full, partial, none)
- [ ] **F-032**: Pricing rules (seasonal, length-of-stay discounts)
- [ ] **F-033**: Property contact information

### Domain 3: Central Reservations Operations

#### Support Console
- [ ] **F-034**: Booking search and view (all city bookings)
- [ ] **F-035**: Booking modification interface
- [ ] **F-036**: Cancellation with refund processing
- [ ] **F-037**: Manual payment processing (for phone bookings)
- [ ] **F-038**: Guest communication log
- [ ] **F-039**: Exception queue management
- [ ] **F-040**: Override capabilities (Supervisor)

#### City-Wide Monitoring
- [ ] **F-041**: Availability watchboard (real-time occupancy)
- [ ] **F-042**: Booking volume dashboard (today, this week, this month)
- [ ] **F-043**: Revenue dashboard (gross, commissions, payouts)
- [ ] **F-044**: Exception queue length and age
- [ ] **F-045**: Host integration health status

#### Reporting
- [ ] **F-046**: Booking report (by date, property, status)
- [ ] **F-047**: Financial report (payments, refunds, commissions)
- [ ] **F-048**: Conversion funnel report
- [ ] **F-049**: Support ticket report
- [ ] **F-050**: No-show and cancellation analysis

### Domain 4: Portal Content Integration

#### Content Enrichment
- [ ] **F-051**: Hero banners (Portal → Reserve site)
- [ ] **F-052**: Events calendar integration
- [ ] **F-053**: Restaurant directory integration
- [ ] **F-054**: Attractions guide integration
- [ ] **F-055**: Cross-linking (property near event, etc.)

#### SEO & Marketing
- [ ] **F-056**: Dynamic sitemap generation
- [ ] **F-057**: Structured data (Schema.org) for properties
- [ ] **F-058**: Meta tag management per page
- [ ] **F-059**: UTM tracking for booking attribution

### Domain 5: System & Infrastructure

#### Sync & Integration
- [ ] **F-060**: Host Connect availability sync (webhook or poll)
- [ ] **F-061**: Host Connect booking creation API
- [ ] **F-062**: Host Connect cancellation API
- [ ] **F-063**: Portal content fetch API
- [ ] **F-064**: Idempotency key management
- [ ] **F-065**: Retry logic with exponential backoff
- [ ] **F-066**: Dead letter queue for failed operations

#### Notifications
- [ ] **F-067**: Email service (SendGrid/AWS SES)
- [ ] **F-068**: WhatsApp Business API integration
- [ ] **F-069**: SMS notifications (Twilio)
- [ ] **F-070**: Notification templates (i18n ready)

#### Monitoring
- [ ] **F-071**: Application performance monitoring (APM)
- [ ] **F-072**: Error tracking (Sentry)
- [ ] **F-073**: Booking funnel event tracking
- [ ] **F-074**: Host API health checks
- [ ] **F-075**: Payment success rate monitoring
- [ ] **F-076**: Alerting (PagerDuty/Opsgenie)

#### Security & Compliance
- [ ] **F-077**: Row-level security (RLS) enforcement
- [ ] **F-078**: Audit logging (all booking changes)
- [ ] **F-079**: GDPR data export/deletion
- [ ] **F-080**: PCI DSS compliance (Stripe handles card data)

---

## F) API/INTEGRATION CONTRACT OUTLINE

### Host Connect Integration (Primary)

#### 1. Availability API
```
Endpoint: GET /api/v1/availability
Auth: API Key + JWT
Rate Limit: 100/min per property

Request:
{
  "property_id": "uuid",
  "room_type_id": "uuid", // optional
  "start_date": "2026-03-01",
  "end_date": "2026-03-05"
}

Response:
{
  "property_id": "uuid",
  "availability": [
    {
      "room_type_id": "uuid",
      "date": "2026-03-01",
      "available": true,
      "allotment": 5,
      "base_price": 350.00,
      "currency": "BRL"
    }
  ]
}

Sync Strategy:
- Real-time: Reserve queries Host on search (cached 60s)
- Webhook: Host pushes updates to Reserve on booking changes
- Fallback: Poll every 5 minutes for critical properties
```

#### 2. Create Booking API
```
Endpoint: POST /api/v1/bookings
Auth: API Key + JWT
Idempotency Key: Required (UUID)
Timeout: 10 seconds
Retries: 3 with exponential backoff

Request:
{
  "property_id": "uuid",
  "room_type_id": "uuid",
  "check_in": "2026-03-01",
  "check_out": "2026-03-05",
  "guests": {
    "adults": 2,
    "children": 0
  },
  "guest_details": {
    "first_name": "João",
    "last_name": "Silva",
    "email": "joao@example.com",
    "phone": "+5511999999999"
  },
  "external_reference": "RES-2026-ABC123",
  "total_amount": 1400.00,
  "special_requests": "Late check-in"
}

Response (Success - 201):
{
  "booking_id": "host-uuid",
  "external_reference": "RES-2026-ABC123",
  "status": "confirmed",
  "confirmation_code": "HT-12345",
  "created_at": "2026-02-15T10:30:00Z"
}

Response (Failure - 4xx/5xx):
{
  "error": "room_type_unavailable",
  "message": "Room type is not available for selected dates",
  "details": { "conflicting_dates": ["2026-03-02"] }
}

Idempotency:
- Same idempotency key within 24h returns same booking (no duplicate)
- Different key, same parameters = new booking (potential duplicate - prevented by availability check)
```

#### 3. Cancel Booking API
```
Endpoint: DELETE /api/v1/bookings/:booking_id
Auth: API Key + JWT

Request:
{
  "reason": "guest_requested",
  "refund_amount": 1400.00
}

Response (Success - 200):
{
  "booking_id": "host-uuid",
  "status": "cancelled",
  "cancelled_at": "2026-02-15T11:00:00Z"
}
```

#### 4. Update Booking API
```
Endpoint: PATCH /api/v1/bookings/:booking_id
Auth: API Key + JWT

Supported Updates:
- check_in/check_out dates (if availability allows)
- number of guests (if within capacity)
- guest details (name, contact)
- status (check_in, check_out) - by property

Request:
{
  "check_in": "2026-03-02",
  "guests": { "adults": 3 }
}

Response: Updated booking object
```

#### 5. Webhook Events (Host → Reserve)
```
Endpoint: POST https://reserve-connect.com/webhooks/host
Auth: Webhook signature verification

Events:
- booking.created - New booking created in Host (OTA or direct)
- booking.updated - Booking modified in Host
- booking.cancelled - Booking cancelled in Host
- availability.changed - Inventory blocked/released
- property.updated - Property details changed

Payload:
{
  "event": "booking.created",
  "timestamp": "2026-02-15T10:30:00Z",
  "property_id": "uuid",
  "booking": { ...booking_details }
}

Retry Policy:
- Reserve responds with 200 OK within 5 seconds
- If fails, Host retries 3 times over 15 minutes
- After 3 failures, queue for manual review
```

### Portal Connect Integration (Content Provider)

#### 1. Content Fetch API
```
Endpoint: GET /api/v1/content
Auth: API Key (read-only)

Endpoints:
- /sites/:slug - Site configuration
- /events?site_id=:id - Events list
- /places?site_id=:id&kind=:kind - Places (restaurants, attractions)
- /hero_banners?site_id=:id - Hero content
- /media/:id - Media assets

Response: JSON with i18n content

Cache Strategy:
- Cache in Reserve for 5 minutes (content changes infrequently)
- Stale-while-revalidate pattern
- Cache invalidation on webhook from Portal

Rate Limit: 1000/day per city
```

#### 2. City Mapping
```
Reserve city_code → Portal site_slug mapping
Example: 'URB' → 'urubici'

Stored in: `city_site_mappings` table
```

### Reserve Connect Public API (Guest-Facing)

#### 1. Search API
```
GET /api/v1/search?city_code=URB&check_in=2026-03-01&check_out=2026-03-05&guests=2

Response:
{
  "city": { ... },
  "properties": [
    {
      "id": "uuid",
      "slug": "pousada-montanha",
      "name": "Pousada Montanha",
      "rating": 4.8,
      "review_count": 127,
      "price_from": 350.00,
      "currency": "BRL",
      "image": "https://...",
      "available": true
    }
  ],
  "total": 45,
  "filters": { ... }
}
```

#### 2. Booking API (Authenticated)
```
POST /api/v1/bookings

Request:
{
  "property_slug": "pousada-montanha",
  "unit_slug": "suite-luxo",
  "check_in": "2026-03-01",
  "check_out": "2026-03-05",
  "guests": { "adults": 2 },
  "guest_details": { ... },
  "payment_intent_id": "pi_xxx"
}

Response:
{
  "reservation_id": "uuid",
  "confirmation_code": "RES-2026-ABC123",
  "status": "confirmed",
  "total_amount": 1400.00,
  "receipt_url": "https://..."
}
```

---

## G) FAILURE MODES & MITIGATIONS

| Scenario | Detection | Mitigation | Owner | Priority |
|----------|-----------|------------|-------|----------|
| **Payment Succeeded but Host API Timeout** | Host API timeout after 10s, 3 retries failed | Queue for retry; Alert agent; Manual override available after 30 min | Agent + System | CRITICAL |
| **Payment Succeeded but Host Rejects (No Availability)** | Host returns 409 Conflict | Cancel reservation + refund guest + notify property of overbooking | Agent | CRITICAL |
| **Double Booking (Race Condition)** | Host confirms 2 bookings for same room/date | Detect within 5 min via webhook; Cancel 2nd booking + refund + escalate to supervisor | System + Supervisor | CRITICAL |
| **Host Downtime (Complete)** | Health check fails for >2 min | Queue all new bookings; Display "booking temporarily unavailable"; SMS agents | System + Admin | HIGH |
| **Partial Host Downtime (Some Properties)** | Individual property API failures | Mark property as "temporarily unavailable"; Route to alternative properties | System | MEDIUM |
| **Stripe Payment Failure** | Stripe returns error | Show error to guest; Extend hold 5 min; Allow retry; After 3 failures, cancel hold | System | HIGH |
| **3D Secure Challenge Abandoned** | Payment intent status: requires_action for >10 min | Auto-cancel hold after 15 min total; Email guest to retry | System | MEDIUM |
| **Email Delivery Failure** | SendGrid webhook shows bounced/dropped | Retry once; Log to support queue; Agent manually contacts guest if critical | System + Agent | MEDIUM |
| **WhatsApp Message Failure** | WhatsApp API error | Retry once; Fall back to SMS or email; Log only (non-critical) | System | LOW |
| **Inventory Sync Lag** | Reserve shows available, Host shows blocked | Real-time check before payment; After-payment validation via webhook | System | HIGH |
| **Guest Requests Cancellation Outside Policy** | Guest contacts support | Agent reviews; Supervisor can override policy with reason logged | Agent + Supervisor | MEDIUM |
| **Property Requests Cancellation** | Property calls/emails support | Agent validates reason; Process cancellation per policy; Compensate guest if needed | Agent | MEDIUM |
| **No-Show False Positive** | Guest arrives late, already marked no-show | Agent verifies with property; Reverse no-show status if within 24h | Agent | LOW |
| **Booking Modification Conflict** | New dates unavailable | Offer alternative dates/units; Cancel + refund if no alternative | Agent | MEDIUM |
| **Refund Processing Failure** | Stripe refund fails | Queue for retry; Alert finance team; Manual refund via bank transfer if needed | System + Finance | HIGH |
| **Data Corruption (Booking State Mismatch)** | Audit detects Host status != Reserve status | System reconciliation job runs hourly; Alert on mismatch; Agent manually syncs | System + Agent | HIGH |
| **Fraudulent Booking** | Stripe fraud detection flags | Hold booking; Review by agent; Cancel if confirmed fraud | System + Agent | MEDIUM |
| **Guest Changes Email After Booking** | Guest contacts support | Update traveler record; Resend confirmation to new email; Log audit | Agent | LOW |

### Failure Recovery Procedures

#### Procedure 1: Payment Confirmed, Host Failed
1. **T+0 min**: Payment webhook received, Host API call initiated
2. **T+10s**: Timeout, retry #1
3. **T+30s**: Timeout, retry #2
4. **T+70s**: Timeout, retry #3
5. **T+80s**: All retries failed → Exception queue + PagerDuty alert
6. **T+5 min**: Agent reviews exception queue
7. **Agent Options**:
   - Click "Retry" → System attempts Host API again
   - Click "Force Cancel" → Cancel reservation, refund guest, apologize
   - Click "Manual Override" → Agent creates booking manually in Host, pastes Host booking ID, system links records

#### Procedure 2: Host Downtime
1. **Detection**: Health check fails at T+0
2. **T+30s**: Circuit breaker opens
3. **T+1 min**: 
   - Search API: Mark all properties as "availability check unavailable - call to book"
   - Booking API: Return 503 "Booking temporarily unavailable"
   - Alert: SMS to on-call agent
4. **T+5 min**: 
   - Email to all properties: "Reservation system experiencing issues"
   - Guest messaging: "We're experiencing technical difficulties. Please call [phone] to book."
5. **Recovery**: When Host returns, circuit breaker closes, normal operation resumes, queued bookings processed

---

## H) MONITORING & SLA MODEL

### Key Metrics (KPIs)

#### Conversion Funnel
| Stage | Target | Alert Threshold |
|-------|--------|----------------|
| Search → Property View | 40% | <30% |
| Property View → Booking Intent | 15% | <10% |
| Booking Intent → Payment Attempt | 70% | <60% |
| Payment Attempt → Success | 85% | <75% |
| Payment Success → Host Confirm | 99% | <95% |
| **Overall Search → Confirmed** | **5%** | **<3%** |

#### Operational Health
| Metric | Target | SLA | Alert |
|--------|--------|-----|-------|
| Host API Availability | 99.9% | 99.5% | <99% |
| Host API Response Time (p95) | <500ms | <2s | >3s |
| Payment Success Rate | 95% | 90% | <85% |
| Booking Confirmation Time | <30s | <60s | >120s |
| Email Delivery Rate | 99% | 98% | <95% |
| Exception Queue Age | <10 min | <30 min | >1 hour |
| Support Ticket Response | <2 hours | <4 hours | >6 hours |

#### Business Metrics
| Metric | Target | Review Frequency |
|--------|--------|------------------|
| Total Bookings (Daily) | 50+ | Daily |
| Revenue per Booking | R$ 800+ | Weekly |
| Cancellation Rate | <10% | Weekly |
| No-Show Rate | <5% | Monthly |
| Commission Revenue | R$ 10k/month | Monthly |
| Support Tickets per Booking | <0.1 | Monthly |

### Dashboards

#### 1. City Operations Dashboard (Real-time)
- **Availability Watchboard**: Grid view of all properties, color-coded by occupancy (green=available, yellow=limited, red=full)
- **Today's Check-ins**: List of guests arriving today with status (not arrived, checked in)
- **Exception Queue**: Count and age of items requiring action
- **Revenue Today**: Gross bookings, commissions earned
- **Booking Volume**: Hourly chart of bookings created

#### 2. Technical Health Dashboard (Real-time)
- **API Health**: Host API latency and error rate
- **Payment Success**: Stripe success rate by payment method
- **Sync Status**: Last successful sync timestamp per property
- **Error Rate**: Application errors per minute
- **Queue Depth**: Exception queue and retry queue sizes

#### 3. Business Intelligence Dashboard (Daily/Weekly)
- **Conversion Funnel**: Visual funnel with drop-off rates
- **Top Properties**: By booking volume, revenue, rating
- **Guest Demographics**: Geographic distribution, booking lead time
- **Revenue Trends**: Daily revenue, average booking value
- **Support Metrics**: Tickets by category, resolution time

### Alerting Configuration

#### PagerDuty Alerts (Immediate)
- Host API completely down (>2 min)
- Payment processing failure rate >20%
- Exception queue >10 items and growing
- Database connection failures
- Booking confirmation time >2 minutes

#### Email Alerts (Within 15 min)
- Host API error rate >5%
- Individual property sync failure
- Email delivery failures
- Stripe webhook failures

#### Daily Digest Email
- Booking summary (yesterday's stats)
- Revenue report
- Support ticket summary
- System health report

### SLA Definitions

#### Guest-Facing SLAs
1. **Search Results**: <2 seconds
2. **Booking Confirmation**: <30 seconds (payment success to confirmation email)
3. **Support Response**: <2 hours during business hours (8am-8pm)
4. **Refund Processing**: <24 hours for approved cancellations

#### Internal SLAs
1. **Exception Resolution**: <30 minutes from alert
2. **Host Sync Latency**: <5 minutes for availability updates
3. **Report Generation**: <10 seconds for standard reports
4. **Backup Restoration**: <1 hour for point-in-time recovery

---

## I) MVP DEFINITION

### MVP Scope (Version 1.0)

**Geographic**: Single city (Urubici - URB)
**Properties**: 10-20 pilot properties
**Timeframe**: 8-10 weeks

### MVP Feature Set

#### MUST HAVE (Ship Blockers)
1. ✅ Property listing page with real data from Host
2. ✅ Property detail page with unit types and availability
3. ✅ Booking intent creation with 15-min hold
4. ✅ Stripe + PIX payment processing
5. ✅ Booking confirmation and inventory blocking
6. ✅ Guest confirmation email
7. ✅ Property notification (email + system inbox)
8. ✅ Basic support console (view bookings, cancel, refund)
9. ✅ Availability watchboard for agents
10. ✅ Exception queue management
11. ✅ Host Connect integration (availability + booking creation)
12. ✅ 30-day availability window

#### SHOULD HAVE (MVP+2 weeks)
13. WhatsApp notifications (opt-in)
14. Booking modification (dates, guests)
15. Guest self-service dashboard
16. Cancellation policy enforcement
17. Review collection (post-stay)
18. Hero banners from Portal
19. Basic events integration

#### NICE TO HAVE (Post-MVP)
20. Restaurant/attractions integration
21. Advanced reporting
22. Advanced reporting
23. Mobile app
24. Multi-language support
25. Loyalty program

### MVP Acceptance Criteria

#### Functional
- [ ] Guest can search for Urubici properties by date
- [ ] Guest can view property details, amenities, photos
- [ ] Guest can select dates and see real availability
- [ ] Guest can complete booking with Stripe or PIX payment
- [ ] Guest receives confirmation email within 30 seconds
- [ ] Property receives notification within 1 minute
- [ ] Support agent can view all bookings
- [ ] Support agent can cancel booking and process refund
- [ ] System handles Host downtime gracefully
- [ ] No double bookings occur

#### Performance
- [ ] Search results load in <2 seconds
- [ ] Property detail page loads in <1 second
- [ ] Payment processing completes in <10 seconds
- [ ] Support console loads in <2 seconds
- [ ] 99% uptime during business hours

#### Quality
- [ ] Payment success rate >85%
- [ ] Host booking creation success rate >99%
- [ ] Email delivery rate >98%
- [ ] Zero data loss
- [ ] Complete audit trail for all booking changes

### MVP Go-Live Checklist

- [ ] 10+ properties onboarded and synced
- [ ] Stripe account configured and tested
- [ ] Support team trained on console
- [ ] Exception handling procedures documented
- [ ] Monitoring dashboards configured
- [ ] PagerDuty alerts active
- [ ] Backup and recovery tested
- [ ] Security audit passed
- [ ] Terms of service and privacy policy published
- [ ] Support phone number and email active

---

## J) ROADMAP

### Phase 0: Foundation (Weeks 1-2)
**Goal**: Infrastructure and core schema ready

**Deliverables**:
- [ ] Reserve Connect schema finalization (reviews table added)
- [ ] Host Connect sync infrastructure deployed
- [ ] Stripe account setup and integration
- [ ] Email service (SendGrid) configured
- [ ] Monitoring stack (Sentry, PagerDuty) setup
- [ ] Support console basic framework
- [ ] City-site mapping (Urubici)

**Milestones**:
- End of Week 2: System can sync 1 property from Host

### Phase 1: MVP Core (Weeks 3-6)
**Goal**: End-to-end booking flow working

**Deliverables**:
- [ ] Property search and listing (real data)
- [ ] Property detail with availability calendar
- [ ] Booking intent and payment flow
- [ ] Booking confirmation and notifications
- [ ] Basic support console (view, cancel, refund)
- [ ] Exception queue and handling
- [ ] 10 properties onboarded

**Milestones**:
- Week 4: First test booking end-to-end
- Week 6: 10 properties live, accepting bookings

### Phase 2: MVP Polish (Weeks 7-8)
**Goal**: Production-ready, agent training

**Deliverables**:
- [ ] WhatsApp notifications
- [ ] Booking modifications
- [ ] Cancellation policies
- [ ] Agent training and documentation
- [ ] Load testing (100 concurrent users)
- [ ] Security hardening
- [ ] 20 properties onboarded

**Milestones**:
- Week 8: MVP launch to public

### Phase 3: Growth (Months 3-4)
**Goal**: Scale to 50+ properties, add content

**Deliverables**:
- [ ] Portal Connect integration (events, restaurants)
- [ ] Review system
- [ ] Guest dashboard
- [ ] Advanced reporting
- [ ] Marketing automation
- [ ] 50 properties onboarded
- [ ] Additional city (Phase 3b)

**Milestones**:
- Month 3: 50 properties, full feature set
- Month 4: Second city launched

### Phase 4: Scale (Months 5-6)
**Goal**: Multi-city, OTA distribution

**Deliverables**:
- [ ] Multi-city support
- [ ] OTA integration (Booking.com, Airbnb)
- [ ] Mobile app (iOS/Android)
- [ ] AI chatbot support
- [ ] Revenue management tools
- [ ] 200+ properties across 5 cities

**Milestones**:
- Month 6: Profitable operation

### Phase 5: Optimization (Months 7-12)
**Goal**: Market leader in regional reservations

**Deliverables**:
- [ ] Dynamic pricing
- [ ] Machine learning recommendations
- [ ] Business intelligence platform
- [ ] White-label solutions
- [ ] API for third-party developers
- [ ] 1000+ properties, 10+ cities

---

## K) OPEN QUESTIONS

1. **Portal Integration Depth**: Should Portal places (restaurants, attractions) link bidirectionally to Reserve properties, or remain as content enrichment only?

2. **Commission Structure**: Is commission collected at booking time (Reserve holds funds) or post-stay (property remits commission)?

3. **Check-in/out Updates**: Should property managers update check-in status via Reserve support console, or only via Host Connect?

4. **Phone Bookings**: What percentage of bookings are expected via phone vs online? This impacts support agent workload planning.

5. **Property Onboarding**: Manual process or self-service? What documentation/training do properties need?

6. **Cancellation Policy Standardization**: City-wide standard policies or per-property custom policies?

7. **PIX Integration**: Critical for Brazil market - implement in MVP or Phase 2?

---

**Document Version**: 1.0  
**Next Review**: Post-MVP launch (Week 10)  
**Owner**: CEO/COO Reserve Connect  
**Distribution**: Executive Team, Engineering Leads, Operations Team

---

*This blueprint represents the complete operational architecture for Reserve Connect as a Central Reservations platform. Implementation should follow the MVP definition strictly for initial launch, then iterate through roadmap phases.*
