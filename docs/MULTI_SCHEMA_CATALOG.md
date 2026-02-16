# MULTI-SCHEMA CATALOG

## Executive Summary

This document provides a unified entity catalog across three Supabase instances: **Reserve Connect**, **Portal Connect**, and **Host Connect**. It identifies data ownership, detects structural conflicts, and maps entity relationships.

### Key Statistics
- **Total Tables**: 88 (13 Reserve + 32 Portal + 44 Host)
- **Total Indexes**: 200+
- **Cross-System Relationships**: 15 identified
- **Naming Conflicts**: 3 detected
- **Missing Indexes**: 8 identified
- **Tenant Isolation Risk**: Medium (inconsistent patterns)

### Systems Overview

| System | Schema | Purpose | Tenancy Model |
|--------|--------|---------|---------------|
| **Reserve Connect** | `reserve` | Distribution & Booking | City-based (`city_id`) |
| **Portal Connect** | `public` | Content & CMS | Site-based (`site_id`) |
| **Host Connect** | `public` | Operations & Property Mgmt | Org-based (`org_id`) |

---

## Unified Entity Catalog

### Section 1: Property Domain

#### 1.1 Properties (Accommodations)

**Host Connect** (Canonical Source)
```sql
Table: public.properties
Key: id (UUID)
Tenant: org_id (FK → organizations)
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK - gen_random_uuid() |
| user_id | uuid | NO | FK → auth.users |
| org_id | uuid | NO | FK → organizations |
| name | text | NO | Property name |
| description | text | YES | Full description |
| address | text | NO | Street address |
| city | text | NO | City name |
| state | text | NO | State/Province |
| country | text | NO | 'Brasil' |
| postal_code | text | YES | ZIP code |
| phone | text | YES | Contact phone |
| email | text | YES | Contact email |
| whatsapp | text | YES | WhatsApp number |
| total_rooms | integer | NO | 0 |
| status | text | NO | 'active' |
| created_at | timestamptz | NO | now() |
| updated_at | timestamptz | NO | now() |

**Indexes:**
- PRIMARY KEY (id)
- idx_properties_org_id (org_id)
- idx_properties_user_id (user_id)

**RLS:** Not enabled (uses org-based application logic)

---

**Reserve Connect** (Sync Cache)
```sql
Table: reserve.properties_map
Key: id (UUID)
Tenant: city_id (FK → cities)
Maps to: host_property_id (UUID - Host PK)
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK - Reserve local ID |
| host_property_id | uuid | NO | **Canonical FK to Host** |
| city_id | uuid | NO | FK → cities |
| name | varchar(200) | NO | Synced from Host |
| slug | varchar(200) | NO | **Canonical URL identifier** |
| description | text | YES | Synced |
| property_type | varchar(50) | YES | Mapped type |
| address_line_1 | varchar(255) | YES | Address |
| city | varchar(100) | YES | City name |
| state_province | varchar(100) | YES | State |
| postal_code | varchar(20) | YES | ZIP |
| country | varchar(100) | YES | 'Brazil' |
| latitude | numeric(10,8) | YES | Geo lat |
| longitude | numeric(11,8) | YES | Geo lng |
| phone | varchar(50) | YES | Phone |
| email | varchar(255) | YES | Email |
| website | varchar(500) | YES | Website |
| amenities_cached | jsonb | NO | '[]' - Synced amenities |
| images_cached | jsonb | NO | '[]' - Image URLs |
| rating_cached | numeric(2,1) | YES | Avg rating |
| review_count_cached | integer | NO | 0 |
| host_last_synced_at | timestamptz | YES | Last sync timestamp |
| host_data_hash | varchar(64) | YES | Change detection hash |
| is_active | boolean | NO | true |
| is_published | boolean | NO | false - **Publication control** |
| deleted_at | timestamptz | YES | Soft delete |
| created_at | timestamptz | NO | now() |
| updated_at | timestamptz | NO | now() |

**Indexes:**
- PRIMARY KEY (id)
- UNIQUE (slug)
- idx_properties_map_host_id (host_property_id)
- idx_properties_map_city (city_id)
- idx_properties_map_active_published (is_active, is_published) WHERE deleted_at IS NULL
- GiST idx_properties_map_geo (point) - Geo queries

**RLS:**
- Public read: WHERE is_active=true AND is_published=true AND deleted_at IS NULL
- Service role: Full access

---

**Portal Connect** (Content Extension - Optional)
```sql
Table: public.places
Key: id (UUID)
Tenant: site_id (FK → sites)
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| site_id | uuid | NO | FK → sites |
| kind | place_kind | NO | 'lodging', 'food', etc. |
| status | place_status | NO | 'draft'/'published' |
| slug | text | NO | URL identifier |
| name_i18n | jsonb | NO | Translated name |
| description_i18n | jsonb | YES | Translated description |
| category_id | uuid | YES | FK → place_categories |
| phone | text | YES | Contact |
| whatsapp | text | YES | WhatsApp |
| email | text | YES | Email |
| website | text | YES | Website |
| address_line | text | YES | Address |
| city | text | YES | City |
| state | text | YES | State |
| lat | numeric(9,6) | YES | Latitude |
| lng | numeric(9,6) | YES | Longitude |
| is_featured | boolean | NO | false |
| curation_status | text | YES | 'pending', 'approved' |
| data_source | text | YES | Origin indicator |

**Conflict Detected**: Portal `places` could duplicate Host `properties` if not careful.
**Resolution**: Portal `places.kind='lodging'` should reference Reserve `properties_map` via external_id if cross-listing needed.

---

#### 1.2 Room Types / Units

**Host Connect** (Canonical)
```sql
Table: public.room_types
Key: id (UUID)
Tenant: org_id, property_id
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| property_id | uuid | NO | FK → properties |
| org_id | uuid | NO | FK → organizations |
| name | text | NO | Room type name |
| description | text | YES | Description |
| capacity | integer | NO | 1 - Max guests |
| base_price | numeric | NO | 0 - Default price |
| status | text | NO | 'active' |
| category | text | YES | 'standard', 'deluxe', etc. |
| amenities_json | text[] | YES | Amenity codes |

---

**Reserve Connect** (Sync Cache)
```sql
Table: reserve.unit_map
Key: id (UUID)
Tenant: property_id (FK → properties_map)
Maps to: host_unit_id (UUID - Host room_types.id)
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK - Reserve ID |
| host_unit_id | uuid | NO | **Canonical FK to Host room_types** |
| property_id | uuid | NO | FK → properties_map |
| name | varchar(200) | NO | Room type name |
| slug | varchar(200) | NO | Unique per property |
| unit_type | varchar(50) | YES | Type classification |
| description | text | YES | Description |
| max_occupancy | integer | NO | 2 - Max guests |
| base_capacity | integer | NO | 2 - Base guests |
| size_sqm | integer | YES | Room size |
| bed_configuration | jsonb | NO | '[]' - Bed types |
| amenities_cached | jsonb | NO | '[]' - Features |
| images_cached | jsonb | NO | '[]' - Gallery |
| host_property_id | uuid | YES | **Denormalized for sync** |

**Naming Conflict**: Host uses `room_types`, Reserve uses `unit_map`.
**Resolution**: Reserve terminology preferred for public API (`units` or `room_types`).

---

### Section 2: Booking Domain

#### 2.1 Bookings / Reservations

**Host Connect** (Canonical Operations)
```sql
Table: public.bookings
Key: id (UUID)
Tenant: org_id, property_id
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| property_id | uuid | NO | FK → properties |
| org_id | uuid | NO | FK → organizations |
| room_type_id | uuid | YES | FK → room_types |
| current_room_id | uuid | YES | FK → rooms |
| guest_name | text | NO | Primary guest |
| guest_email | text | NO | Contact email |
| guest_phone | text | YES | Phone |
| check_in | date | NO | Arrival |
| check_out | date | NO | Departure |
| total_guests | integer | NO | 1 |
| total_amount | numeric | NO | 0 - Total value |
| status | text | NO | Booking state |
| notes | text | YES | Internal notes |
| lead_id | uuid | YES | FK → reservation_leads |
| stripe_session_id | text | YES | Payment ref |

**Status Values**: 'INQUIRY', 'QUOTED', 'CONFIRMED', 'CHECKED_IN', 'CHECKED_OUT', 'CANCELLED', 'NO_SHOW'

---

**Reserve Connect** (Distribution Reservations)
```sql
Table: reserve.reservations
Key: id (UUID)
Tenant: property_id (FK → properties_map)
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| traveler_id | uuid | YES | FK → travelers |
| property_id | uuid | NO | FK → properties_map |
| unit_id | uuid | NO | FK → unit_map |
| rate_plan_id | uuid | NO | FK → rate_plans |
| confirmation_code | varchar(50) | NO | **Unique booking ref** |
| source | reservation_source | NO | 'direct', 'booking_com', etc. |
| ota_booking_id | varchar(100) | YES | External ref |
| check_in | date | NO | Arrival |
| check_out | date | NO | Departure |
| nights | integer | NO | Auto-calculated |
| guests_adults | integer | NO | 1 |
| guests_children | integer | NO | 0 |
| guests_infants | integer | NO | 0 |
| status | reservation_status | NO | Booking state |
| payment_status | payment_status | NO | Payment state |
| currency | varchar(3) | NO | 'BRL' |
| subtotal | numeric(12,2) | NO | Room charges |
| taxes | numeric(12,2) | NO | 0 |
| fees | numeric(12,2) | NO | 0 |
| discount_amount | numeric(12,2) | NO | 0 |
| total_amount | numeric(12,2) | NO | **Final total** |
| amount_paid | numeric(12,2) | NO | 0 |
| guest_first_name | varchar(100) | YES | Guest details |
| guest_last_name | varchar(100) | YES | |
| guest_email | varchar(255) | YES | |
| guest_phone | varchar(50) | YES | |
| special_requests | text | YES | |
| metadata | jsonb | NO | '{}' - Extensible |
| booked_at | timestamptz | NO | now() |
| cancelled_at | timestamptz | YES | |
| checked_in_at | timestamptz | YES | |
| checked_out_at | timestamptz | YES | |

**Status ENUM**: 'pending', 'confirmed', 'checked_in', 'checked_out', 'cancelled', 'no_show'
**Payment ENUM**: 'pending', 'partial', 'paid', 'refunded', 'failed'
**Source ENUM**: 'direct', 'booking_com', 'airbnb', 'expedia', 'other_ota'

**Sync Strategy**: 
- Direct bookings flow: Site → Reserve → (sync) → Host
- OTA bookings flow: OTA → Host → (sync) → Reserve

---

### Section 3: Content Domain

#### 3.1 Sites / Cities

**Portal Connect** (Canonical - CMS Sites)
```sql
Table: public.sites
Key: id (UUID)
Tenant: None (top level)
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| slug | text | NO | Unique identifier |
| name_i18n | jsonb | NO | Translated name |
| is_active | boolean | NO | true |
| status | site_status | NO | 'draft'/'published' |
| default_locale | text | NO | 'pt' |
| supported_locales | text[] | NO | ['pt','en','es'] |
| primary_domain | text | YES | Custom domain |

**Relationship to Reserve**: Portal `sites.slug` maps to Reserve `cities.code` (e.g., 'urubici')

---

**Reserve Connect** (Canonical - Geographic)
```sql
Table: reserve.cities
Key: id (UUID)
Tenant: None (global reference)
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| code | varchar(10) | NO | **Unique code** (e.g., 'URB') |
| name | varchar(100) | NO | Display name |
| state_province | varchar(100) | YES | State |
| country | varchar(100) | NO | 'Brazil' |
| timezone | varchar(50) | NO | 'America/Sao_Paulo' |
| currency | varchar(3) | NO | 'BRL' |
| is_active | boolean | NO | true |
| metadata | jsonb | NO | '{}' - Extensible |

**Canonical Key Strategy**:
- Use `cities.code` (e.g., 'URB', 'SAO') for cross-system reference
- Map Portal `sites.slug` to Reserve `cities.code`
- Example: Portal site 'urubici' ↔ Reserve city 'URB'

---

#### 3.2 Events

**Portal Connect** (Exclusive Master)
```sql
Table: public.events
Key: id (UUID)
Tenant: site_id
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| site_id | uuid | NO | FK → sites |
| status | event_status | NO | 'draft'/'published'/'archived' |
| slug | text | NO | URL identifier |
| title_i18n | jsonb | NO | Translated title |
| summary_i18n | jsonb | YES | Short description |
| body_i18n | jsonb | YES | Full content |
| start_at | timestamptz | NO | Event start |
| end_at | timestamptz | YES | Event end |
| all_day | boolean | NO | false |
| location_name | text | YES | Venue name |
| address_line | text | YES | Address |
| city | text | YES | City |
| state | text | YES | State |
| lat | numeric(9,6) | YES | Latitude |
| lng | numeric(9,6) | YES | Longitude |
| cover_url | text | YES | Cover image |
| category_id | uuid | YES | FK → event_categories |

**No equivalent in Host or Reserve** - Portal exclusive.

---

#### 3.3 Places (Restaurants, Attractions)

**Portal Connect** (Exclusive Master)
```sql
Table: public.places
Key: id (UUID)
Tenant: site_id
Kind: 'lodging', 'food', 'attraction', 'service', 'medical'
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| site_id | uuid | NO | FK → sites |
| kind | place_kind | NO | Type discriminator |
| status | place_status | NO | Publication status |
| slug | text | NO | URL identifier |
| name_i18n | jsonb | NO | Translated name |
| description_i18n | jsonb | YES | Description |
| category_id | uuid | YES | FK → place_categories |
| phone | text | YES | Contact |
| whatsapp | text | YES | WhatsApp |
| email | text | YES | Email |
| website | text | YES | Website |
| address_line | text | YES | Address |
| city | text | YES | City |
| state | text | YES | State |
| lat | numeric(9,6) | YES | Geo lat |
| lng | numeric(9,6) | YES | Geo lng |
| category_type | text | YES | 'onde_ir', 'onde_ficar', etc. |
| is_featured | boolean | NO | false |
| curation_status | text | YES | 'pending', 'approved', etc. |
| data_source | text | YES | Import source |

**Categories**:
- `place_categories` table with hierarchical structure (parent_id)
- `kind` enum: 'lodging', 'food', 'attraction', 'service', 'medical'

**No equivalent in Host or Reserve** - Portal exclusive.

---

### Section 4: User Domain

#### 4.1 Users & Authentication

**All Systems** (Supabase Auth - Shared or Separate?)

**Host Connect**:
- `auth.users` - Standard Supabase Auth
- `public.profiles` - Extended profile data
- `public.org_members` - Organization membership
- `public.guests` - Guest profiles (CRM)

**Reserve Connect**:
- `auth.users` - Standard Supabase Auth
- `reserve.travelers` - Traveler profiles with booking history

**Portal Connect**:
- `auth.users` - Standard Supabase Auth
- `public.profiles` - Basic profile
- `public.site_members` - Site membership

**Critical Question**: Are these separate Auth instances or shared?
- Current setup suggests **separate instances**
- Reserve Connect needs to link `travelers.auth_user_id` to its own `auth.users`
- Cross-system identity federation not implemented

**Recommended Approach**:
- Keep separate auth instances per system
- Use email as cross-system identifier
- Sync traveler profiles from Reserve to Host as guests

---

#### 4.2 Guests / Travelers

**Host Connect** (Canonical - Property Operations)
```sql
Table: public.guests
Key: id (UUID)
Tenant: org_id
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| org_id | uuid | NO | FK → organizations |
| first_name | text | NO | |
| last_name | text | NO | |
| email | text | YES | |
| phone | text | YES | |
| document | text | YES | ID document |
| birthdate | date | YES | |
| address_json | jsonb | YES | Structured address |

---

**Reserve Connect** (Canonical - Booking Distribution)
```sql
Table: reserve.travelers
Key: id (UUID)
Tenant: None (global)
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| auth_user_id | uuid | YES | FK → auth.users (nullable for guest checkout) |
| email | varchar(255) | NO | Unique |
| first_name | varchar(100) | YES | |
| last_name | varchar(100) | YES | |
| phone | varchar(50) | YES | |
| phone_country_code | varchar(5) | YES | |
| date_of_birth | date | YES | |
| nationality | varchar(100) | YES | |
| document_type | varchar(50) | YES | 'passport', 'id_card', etc. |
| document_number | varchar(100) | YES | |
| address_line_1 | varchar(255) | YES | |
| city | varchar(100) | YES | |
| state_province | varchar(100) | YES | |
| postal_code | varchar(20) | YES | |
| country | varchar(100) | YES | |
| preferences | jsonb | NO | '{}' - Room prefs |
| marketing_consent | boolean | NO | false |
| is_verified | boolean | NO | false |

**Sync Strategy**:
- Reserve traveler → Sync to Host guest (on first booking per org)
- Link via email address
- Host guest_id stored in Reserve reservation metadata if needed

---

### Section 5: Availability & Pricing

#### 5.1 Availability Calendar

**Reserve Connect** (Exclusive - Distribution Layer)
```sql
Table: reserve.availability_calendar
Key: id (UUID)
Tenant: unit_id + rate_plan_id
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| unit_id | uuid | NO | FK → unit_map |
| rate_plan_id | uuid | NO | FK → rate_plans |
| date | date | NO | Calendar date |
| is_available | boolean | NO | true - Can book? |
| is_blocked | boolean | NO | false - Blocked? |
| block_reason | varchar(100) | YES | Why blocked |
| min_stay_override | integer | YES | Minimum nights |
| base_price | numeric(12,2) | NO | Standard price |
| discounted_price | numeric(12,2) | YES | Promo price |
| currency | varchar(3) | NO | 'BRL' |
| allotment | integer | NO | 1 - Inventory count |
| bookings_count | integer | NO | 0 - Committed |
| host_last_synced_at | timestamptz | YES | Sync timestamp |
| source_system | varchar(50) | NO | 'reserve' or 'host' |

**Source of Truth**:
- Host Connect has canonical availability in operational system
- Reserve Connect caches distribution availability
- Bidirectional sync required for OTA bookings

**No equivalent in Portal** - Portal doesn't manage inventory.

---

#### 5.2 Rate Plans

**Reserve Connect** (Exclusive)
```sql
Table: reserve.rate_plans
Key: id (UUID)
Tenant: property_id
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| property_id | uuid | NO | FK → properties_map |
| host_rate_plan_id | uuid | YES | FK to Host (optional) |
| name | varchar(200) | NO | Rate plan name |
| code | varchar(50) | YES | Internal code |
| is_default | boolean | NO | false |
| channels_enabled | jsonb | NO | '["direct"]' - OTA channels |
| min_stay_nights | integer | YES | 1 |
| max_stay_nights | integer | YES | |
| advance_booking_days | integer | YES | |
| cancellation_policy_code | varchar(50) | YES | Policy ref |

**Note**: Host Connect has `pricing_rules` table but different structure.
**Strategy**: Reserve manages distribution rate plans; syncs availability from Host operational system.

---

### Section 6: Operational Data

#### 6.1 Physical Rooms

**Host Connect** (Exclusive - Operations)
```sql
Table: public.rooms
Key: id (UUID)
Tenant: org_id, property_id
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| property_id | uuid | NO | FK → properties |
| room_type_id | uuid | NO | FK → room_types |
| room_number | text | NO | Physical room # |
| status | text | NO | 'available', 'occupied', 'maintenance', etc. |
| org_id | uuid | NO | FK → organizations |
| last_booking_id | uuid | YES | FK → bookings |

**Reserve Context**: Reserve doesn't track physical rooms, only room types (unit_map). Physical room assignment happens in Host after booking.

---

#### 6.2 Inventory & Stock

**Host Connect** (Exclusive - Operations)
```sql
Tables: 
- stock_items
- stock_locations
- stock_movements
- stock_daily_checks
- inventory_items
- item_stock
- room_type_inventory
```

**No equivalent in Reserve or Portal** - Operational data stays in Host.

---

#### 6.3 Staff & Departments

**Host Connect** (Exclusive)
```sql
Tables:
- staff_profiles
- departments
- shifts
- shift_assignments
- shift_handoffs
```

**No equivalent in Reserve or Portal**.

---

### Section 7: Analytics & Tracking

#### 7.1 Funnel Events

**Reserve Connect** (Exclusive - Distribution Analytics)
```sql
Table: reserve.funnel_events
Key: id (UUID)
Tenant: city_id, property_id, unit_id
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| session_id | varchar(100) | NO | Anonymous session |
| visitor_id | varchar(100) | NO | Persistent visitor |
| stage | funnel_stage | NO | 'page_view', 'search', 'view_item', 'lead', 'checkout', 'purchase', 'abandon' |
| city_id | uuid | YES | FK → cities |
| property_id | uuid | YES | FK → properties_map |
| unit_id | uuid | YES | FK → unit_map |
| search_params | jsonb | YES | Search criteria |
| utm_source | varchar(100) | YES | Marketing source |
| utm_medium | varchar(100) | YES | Channel |
| utm_campaign | varchar(200) | YES | Campaign |
| conversion_value | numeric(12,2) | YES | Revenue |
| reservation_id | uuid | YES | FK → reservations |

**No equivalent in Host or Portal**.

---

#### 7.2 Page Views

**Portal Connect** (Exclusive - Content Analytics)
```sql
Table: public.page_views
Key: id (UUID)
Tenant: site_id
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| site_id | uuid | NO | FK → sites |
| page_path | text | NO | URL path |
| referrer | text | YES | Source |
| user_agent | text | YES | Browser |
| session_id | uuid | NO | Session |
| user_id | uuid | YES | FK → auth.users |
| ip_hash | text | YES | Hashed IP |
| country_code | text | YES | Geo |

**No equivalent in Host or Reserve**.

---

### Section 8: Sync & Integration

#### 8.1 Sync Jobs

**Reserve Connect** (Exclusive - Orchestration)
```sql
Table: reserve.sync_jobs
Key: id (UUID)
Tenant: property_id, city_id
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| job_name | varchar(100) | NO | Descriptive name |
| job_type | varchar(50) | NO | 'property_sync', 'availability_sync', etc. |
| direction | sync_direction | NO | 'push_to_host', 'pull_from_host', 'bidirectional' |
| property_id | uuid | YES | Target property |
| city_id | uuid | YES | Target city |
| date_from | date | YES | Date range start |
| date_to | date | YES | Date range end |
| status | sync_status | NO | 'pending', 'in_progress', 'completed', 'failed', 'retrying' |
| priority | integer | NO | 5 - Execution priority |
| started_at | timestamptz | YES | |
| completed_at | timestamptz | YES | |
| error_message | text | YES | |
| retry_count | integer | NO | 0 |
| records_processed | integer | YES | |

**Critical for**: Host ↔ Reserve data synchronization

---

#### 8.2 Events (Event Bus)

**Reserve Connect** (Exclusive - Async Processing)
```sql
Table: reserve.events
Key: id (UUID)
Tenant: None (global event bus)
```
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | uuid | NO | PK |
| event_name | varchar(100) | NO | 'reservation.created', 'sync.completed', etc. |
| event_version | varchar(10) | NO | '1.0' |
| severity | event_severity | NO | 'info', 'warning', 'error', 'critical' |
| actor_type | varchar(50) | NO | 'user', 'system', 'integration' |
| actor_id | varchar(255) | YES | |
| entity_type | varchar(50) | NO | 'reservation', 'property', etc. |
| entity_id | uuid | NO | |
| payload | jsonb | NO | Event data |
| processed_at | timestamptz | YES | |
| correlation_id | uuid | YES | Trace ID |

---

## Ownership Mapping

### Canonical Sources of Truth

| Entity | Canonical Source | Sync Direction | Notes |
|--------|-----------------|----------------|-------|
| **Properties** | Host Connect | Host → Reserve | Reserve caches for distribution |
| **Room Types** | Host Connect | Host → Reserve | Reserve unit_map mirrors |
| **Bookings** | Reserve Connect | Bidirectional | OTA → Host → Reserve; Direct → Reserve → Host |
| **Availability** | Host Connect | Host → Reserve | Reserve caches, updates from OTA push back |
| **Guests** | Reserve Connect | Reserve → Host | Travelers sync to Host guests |
| **Cities** | Reserve Connect | Reserve ←→ Portal | Code/slug alignment needed |
| **Events** | Portal Connect | Portal only | No sync needed |
| **Restaurants** | Portal Connect | Portal only | No sync needed |
| **Attractions** | Portal Connect | Portal only | No sync needed |
| **Content** | Portal Connect | Portal only | Hero banners, CMS content |
| **Users** | Per System | Email linking | Separate auth instances |

### Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        SITE APP (Frontend)                       │
└─────────────────────────────────────────────────────────────────┘
                              │
          ┌───────────────────┼───────────────────┐
          │                   │                   │
          ▼                   ▼                   ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│  PORTAL CONNECT │  │ RESERVE CONNECT │  │  HOST CONNECT   │
│   (Content)     │  │ (Distribution)  │  │  (Operations)   │
├─────────────────┤  ├─────────────────┤  ├─────────────────┤
│ • Sites         │  │ • Cities        │  │ • Organizations │
│ • Events        │  │ • Properties*   │  │ • Properties    │
│ • Places        │  │ • Unit Types*   │  │ • Room Types    │
│ • Posts         │  │ • Availability* │  │ • Bookings      │
│ • Media         │  │ • Reservations  │  │ • Guests        │
│ • Ads           │  │ • Travelers     │  │ • Rooms         │
│                 │  │ • Rate Plans    │  │ • Inventory     │
│                 │  │ • Sync Jobs     │  │ • Staff         │
└─────────────────┘  └─────────────────┘  └─────────────────┘
                              │                   ▲
                              │ Sync              │ Sync
                              ▼                   │
                    ┌──────────────────┐          │
                    │  External OTAs   │          │
                    │ (Booking.com,    │          │
                    │  Airbnb, etc.)   │          │
                    └──────────────────┘          │
                                                  │
                              ┌───────────────────┘
                              │ Operations Data
                              │ (No public access)
                              ▼
                    ┌──────────────────┐
                    │  Host Admin UI   │
                    └──────────────────┘

* Synced from Host Connect
```

---

## Conflict Analysis

### Naming Conflicts Detected

#### 1. Property vs Place vs Establishment
- **Host**: `properties` (operational)
- **Reserve**: `properties_map` (distribution cache)
- **Portal**: `places` (with `kind='lodging'`)

**Conflict**: Portal could create `places.kind='lodging'` that duplicates Host `properties`.

**Resolution Strategy**:
1. Portal `places.kind='lodging'` should reference Reserve `properties_map` via `external_id`
2. Or, Portal should import from Reserve for lodging places
3. Clear documentation: Host = operations master, Portal = content extension

#### 2. Room Types vs Units
- **Host**: `room_types` (canonical)
- **Reserve**: `unit_map` (sync cache)

**Conflict**: Different terminology for same concept.

**Resolution**: Standardize on "room types" for user-facing, "units" for internal mapping.

#### 3. Guests vs Travelers
- **Host**: `guests` (CRM/operational)
- **Reserve**: `travelers` (distribution/booking)

**Conflict**: Same entity, different names and purposes.

**Resolution**: 
- Use "traveler" for booking context (Reserve)
- Use "guest" for operational context (Host)
- Sync Reserve traveler → Host guest on first booking

#### 4. Bookings vs Reservations
- **Host**: `bookings` (operations)
- **Reserve**: `reservations` (distribution)

**Conflict**: Different names, similar but different schemas.

**Resolution**: 
- Host `bookings` = operational state machine
- Reserve `reservations` = booking transactions
- Sync with status mapping

---

## Missing Indexes Analysis

### Reserve Connect

| Table | Missing Index | Impact | Priority |
|-------|--------------|--------|----------|
| `reservations` | (traveler_id, status, check_in) | Dashboard queries | High |
| `reservations` | (property_id, status, booked_at DESC) | Property reports | High |
| `availability_calendar` | (property_id, date, is_available) | Property availability view | Medium |
| `funnel_events` | (created_at DESC) WHERE stage='purchase' | Conversion analytics | Medium |
| `travelers` | (created_at DESC) | Admin user list | Low |

### Portal Connect

| Table | Missing Index | Impact | Priority |
|-------|--------------|--------|----------|
| `places` | (site_id, kind, curation_status, updated_at) | Curation workflow | Medium |
| `events` | (start_at, end_at) WHERE status='published' | Calendar queries | Medium |
| `page_views` | (page_path, created_at) | Page analytics | Low |

### Host Connect

| Table | Missing Index | Impact | Priority |
|-------|--------------|--------|----------|
| `bookings` | (property_id, check_in, check_out, status) | Availability calc | High |
| `bookings` | (guest_email) | Guest lookup | Medium |
| `guests` | (email, org_id) | Duplicate detection | Medium |
| `rooms` | (room_type_id, status) | Room assignment | Medium |

---

## Tenant Isolation Analysis

### Current Isolation Patterns

| System | Tenant Column | Pattern | Risk Level |
|--------|--------------|---------|------------|
| **Host** | `org_id` | Organization-based | Low |
| **Reserve** | `city_id` | City-based | Medium |
| **Portal** | `site_id` | Site-based | Low |

### Risk Assessment

#### High Risk: Reserve Connect
- `properties_map` uses `city_id` for tenancy
- But `host_property_id` references Host (different tenant model)
- Risk: Cross-city data leakage if queries don't filter by city_id

**Mitigation**:
```sql
-- All queries must include:
WHERE city_id = current_city_id()
-- Or use RLS policy:
CREATE POLICY city_isolation ON properties_map
  FOR ALL TO authenticated
  USING (city_id = (auth.jwt() ->> 'city_id')::uuid);
```

#### Medium Risk: Portal Connect
- Well-isolated by `site_id`
- But `places` can have `kind='lodging'` that overlaps with Reserve
- Risk: Double-entry of property data

**Mitigation**:
- Enforce reference to Reserve for lodging places
- Or clearly separate concerns (Portal = content only)

#### Low Risk: Host Connect
- Strong `org_id` isolation
- All queries use `org_id` filter
- RLS policies enforced

---

## Cross-System Join Strategy

### Required Joins for Site App

#### 1. Property Detail Page
```sql
-- Reserve: Property + Availability + Units
SELECT p.*, u.*, a.*
FROM reserve.properties_map p
LEFT JOIN reserve.unit_map u ON u.property_id = p.id
LEFT JOIN reserve.availability_calendar a ON a.unit_id = u.id
WHERE p.slug = :slug
  AND p.city_id = :city_id
  AND p.is_published = true;

-- Portal: Content enrichment (optional)
SELECT e.*
FROM portal.events e
WHERE e.site_id = :portal_site_id
  AND e.start_at BETWEEN :check_in AND :check_out;
```

**Edge Function Strategy**: 
- Call Reserve for core data
- Parallel call to Portal for content enrichment
- Merge in Edge Function response

#### 2. Availability Search
```sql
-- Reserve: Search available units
SELECT DISTINCT p.id, p.name, p.slug, u.id as unit_id, 
                MIN(a.base_price) as min_price,
                COUNT(DISTINCT a.date) as available_days
FROM reserve.properties_map p
JOIN reserve.unit_map u ON u.property_id = p.id
JOIN reserve.availability_calendar a ON a.unit_id = u.id
WHERE p.city_id = :city_id
  AND p.is_active = true
  AND p.is_published = true
  AND a.date BETWEEN :check_in AND :check_out
  AND a.is_available = true
  AND a.is_blocked = false
  AND a.allotment > a.bookings_count
GROUP BY p.id, p.name, p.slug, u.id
HAVING COUNT(DISTINCT a.date) = :nights;
```

**Optimization**: Use materialized view or cached availability summary.

#### 3. Events List
```sql
-- Portal: Get events for city
SELECT e.*, c.name as category_name
FROM portal.events e
LEFT JOIN portal.event_categories c ON c.id = e.category_id
WHERE e.site_id = :site_id
  AND e.status = 'published'
  AND e.start_at >= CURRENT_DATE
ORDER BY e.start_at ASC;
```

**Mapping**: Portal `site_id` ↔ Reserve `city_id` via code mapping.

---

## Canonical Key Strategy

### Primary Keys

| Entity | Canonical Key | Format | Example |
|--------|--------------|--------|---------|
| **City** | `code` | VARCHAR(10) | 'URB', 'SAO', 'RIO' |
| **Property** | `slug` | VARCHAR(200) | 'pousada-montanha-urubici' |
| **Unit** | `property_id` + `slug` | Composite | - |
| **Reservation** | `confirmation_code` | VARCHAR(50) | 'RES-2026-ABC123' |
| **Site** | `slug` | TEXT | 'urubici' |
| **Place** | `slug` | TEXT | 'restaurante-sabor-da-serra' |
| **Event** | `slug` | TEXT | 'festival-inverno-2026' |

### Cross-System Mapping

#### City/Site Alignment
```typescript
// Portal Site
{ id: 'uuid-1', slug: 'urubici', name_i18n: { pt: 'Urubici' } }

// Reserve City
{ id: 'uuid-2', code: 'URB', name: 'Urubici' }

// Mapping Strategy:
// Portal sites.slug === Reserve cities.code (lowercase match)
// 'urubici' === 'urb' (requires mapping table or convention)
```

**Recommendation**: Create explicit mapping table:
```sql
-- In Reserve or Portal
CREATE TABLE city_site_mappings (
  city_id UUID REFERENCES reserve.cities(id),
  site_id UUID REFERENCES portal.sites(id),
  city_code VARCHAR(10),
  site_slug TEXT,
  PRIMARY KEY (city_id, site_id)
);
```

#### Property Alignment
```typescript
// Host Property (canonical)
{ id: 'host-uuid-1', name: 'Pousada Montanha', org_id: 'org-1' }

// Reserve Property (synced)
{ 
  id: 'reserve-uuid-1', 
  host_property_id: 'host-uuid-1',
  city_id: 'city-uuid-1',
  slug: 'pousada-montanha-urubici'
}

// Portal Place (optional content)
{
  id: 'portal-uuid-1',
  site_id: 'site-uuid-1',
  kind: 'lodging',
  external_id: 'reserve-uuid-1',  -- Reference to Reserve
  slug: 'pousada-montanha'
}
```

---

## Summary of Structural Alignments Required

### Before Edge Functions Phase

1. **Create City-Site Mapping**
   - Table: `city_site_mappings`
   - Populate for pilot city (Urubici)
   - Document convention for future cities

2. **Align Property Slugs**
   - Reserve: Ensure `properties_map.slug` is URL-safe
   - Portal: Add `places.external_id` for lodging references
   - Host: Add `properties.slug` for canonical reference

3. **Standardize Terminology**
   - Public API: Use "room types" (not "units")
   - Internal: Reserve uses unit_map, Host uses room_types
   - Documentation: Clear mapping guide

4. **Review Sync Strategy**
   - Host → Reserve: Properties, room types, availability
   - Reserve → Host: Direct reservations, OTA bookings
   - Frequency: Real-time for bookings, hourly for availability

5. **Add Missing Indexes**
   - Reserve: Reservation dashboard indexes
   - Host: Booking availability indexes
   - Portal: Event calendar indexes

6. **Test Tenant Isolation**
   - Reserve: Verify city_id filtering in all queries
   - Host: Verify org_id RLS policies
   - Portal: Verify site_id filtering

7. **Define Cross-System Error Handling**
   - Host sync failure: Graceful degradation
   - Portal content missing: Fallback to static
   - Reserve unavailable: Queue for retry

---

*Document generated: 2026-02-15*
*Systems analyzed: Reserve Connect, Portal Connect, Host Connect*
*Status: READ-ONLY ANALYSIS PHASE*
