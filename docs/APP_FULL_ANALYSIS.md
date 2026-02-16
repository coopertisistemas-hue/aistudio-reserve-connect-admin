# APP FULL ANALYSIS

## Executive Summary

This document provides a comprehensive analysis of the **Reserve Connect Site App** (aistudio-reserve-connect-pc) and its data requirements across three interconnected systems: Reserve Connect, Portal Connect, and Host Connect.

### Key Findings

1. **Multi-System Architecture**: The application spans three distinct Supabase instances with different responsibilities:
   - **Host Connect**: Source of truth for properties, room types, bookings, and operational data
   - **Portal Connect**: Source of truth for content (sites, events, posts, places) and advertising
   - **Reserve Connect**: Distribution layer that syncs data from Host and Portal, handles reservations

2. **Current State**: The site app currently uses **100% mock/hardcoded data** - no active Supabase integration despite configuration being present.

3. **Critical Gaps Identified**:
   - No live data fetching from any system
   - Missing property synchronization
   - Missing availability calendar integration
   - Missing booking flow implementation
   - Missing authentication/authorization

4. **Data Ownership Conflicts**:
   - Properties exist in both Host (canonical) and Portal (cached/cacheable) and Reserve (synced)
   - Room types exist in Host (canonical) and Reserve (synced)
   - Events exist only in Portal
   - Places exist only in Portal

5. **Integration Points Required**:
   - 12 Edge Functions identified as needed
   - Cross-system join strategy required
   - Canonical key mapping strategy essential

---

## Application Architecture

### Tech Stack
- **Framework**: Vite + React 19 + TypeScript
- **Routing**: React Router v7
- **Styling**: Tailwind CSS v3
- **State**: React hooks (no global state management)
- **Animation**: Custom IntersectionObserver hooks
- **i18n**: react-i18next with browser detection
- **Build**: Vite with SWC

### Supabase Configuration
```
URL: https://ffahkiukektmhkrkordn.supabase.co
Anon Key: [Present in .env]
Current Usage: NONE (configured but not implemented)
```

---

## Page/Route Inventory

### 1. Public Pages (16 routes)

| Route | Component | Purpose | Current Data Source |
|-------|-----------|---------|---------------------|
| `/` | `home/page.tsx` | Landing with hero, search, featured | Hardcoded arrays |
| `/experiencias` | `experiencias/page.tsx` | Experience marketplace | Hardcoded |
| `/termos` | `termos/page.tsx` | Terms of service | Static content |
| `/politica-de-privacidade` | `politica-de-privacidade/page.tsx` | Privacy policy | Static content |
| `/cancelamento-e-reembolso` | `cancelamento-e-reembolso/page.tsx` | Refund policy | Static content |
| `/politica-de-cookies` | `politica-de-cookies/page.tsx` | Cookie policy | Static content |
| `/contato` | `contato/page.tsx` | Contact form | Static + Form API |
| `/city` | `city/page.tsx` | City search landing | Hardcoded |
| `/hospedagens` | `hospedagens/page.tsx` | Accommodation listing | Hardcoded (20+ items) |
| `/hospedagem/:id` | `hospedagem-detalhes/page.tsx` | Property detail | Hardcoded |
| `/eventos` | `eventos/page.tsx` | Events calendar | Hardcoded |
| `/grupos-e-agencias` | `grupos-e-agencias/page.tsx` | Group bookings | Static + Form API |
| `/onde-ir` | `onde-ir/page.tsx` | Attractions guide | Hardcoded |
| `/restaurantes` | `restaurantes/page.tsx` | Restaurant directory | Hardcoded |
| `/restaurante/:id` | `restaurante-detalhes/page.tsx` | Restaurant detail | Hardcoded |
| `/sobre` | `sobre/page.tsx` | About platform | Static content |
| `*` | `NotFound.tsx` | 404 error | Static |

---

## Feature Inventory with Data Requirements

### Feature 1: Hero Carousel (Home Page)
**Location**: `/` - Hero section
**Current Implementation**: Hardcoded array of 3 slides
**Required Data**:
- Slide images (CDN URLs)
- Headlines (i18n)
- Subheadlines (i18n)
- CTA buttons with links

**Schema Mapping**:
- Source: Portal Connect - `hero_banners` table
- Join: `hero_banners` → `media` (for images)
- Tenant: Filter by `site_id`

**Gap**: Currently hardcoded, needs Portal Connect integration

---

### Feature 2: Search Widget
**Location**: `/`, `/city`, `/hospedagens`
**Current Implementation**: Form with hardcoded suggestions
**Required Data**:
- Available cities list
- Date picker constraints
- Guest count limits

**Schema Mapping**:
- Cities: Reserve Connect - `cities` table (or Portal - `sites`)
- Availability: Reserve Connect - `availability_calendar`

**Gap**: No availability checking implemented

---

### Feature 3: Featured Accommodations
**Location**: `/` - Featured section, `/hospedagens` - Full listing
**Current Implementation**: Array of 20+ hardcoded accommodations
**Required Fields**:
```typescript
interface Accommodation {
  id: string;                    // UUID
  name: string;                  // Property name
  type: 'hotel' | 'pousada' | 'casa' | 'chale' | 'camping' | 'hostel';
  location: string;              // City/neighborhood
  price: number;                 // Nightly rate (BRL)
  rating: number;                // 0-5 scale
  reviews: number;               // Review count
  images: string[];              // Gallery URLs
  amenities: string[];           // Feature tags
  description: string;           // Short description
  freeCancellation: boolean;     // Policy flag
  available: number;             // Rooms available
  badge?: string;                // Promo badge text
  views?: number;                // View count
}
```

**Schema Mapping**:
| Field | Source Table | Column | Notes |
|-------|-------------|--------|-------|
| id | `properties_map` | `property_id` | Reserve Connect mapped ID |
| name | `properties_map` | `name` | Synced from Host |
| type | `properties_map` | `property_type` | Mapped from Host |
| location | `properties_map` | `city` + `state_province` | Composite |
| price | `availability_calendar` | `base_price` | Min across dates |
| rating | `properties_map` | `rating_cached` | Synced aggregate |
| reviews | `properties_map` | `review_count_cached` | Synced count |
| images | `properties_map` | `images_cached` | JSON array |
| amenities | `properties_map` | `amenities_cached` | JSON array |

**Gap**: Currently all mock data. Needs:
1. Reserve Connect sync from Host
2. Availability aggregation query
3. Image CDN migration

---

### Feature 4: Property Detail Page
**Location**: `/hospedagem/:id`
**Required Fields**:
```typescript
interface PropertyDetail {
  id: string;
  name: string;
  type: string;
  location: {
    address: string;
    city: string;
    state: string;
    coordinates: { lat: number; lng: number };
  };
  rating: number;
  reviewCount: number;
  description: string;
  images: string[];              // 5-10 gallery images
  amenities: string[];           // Full amenities list
  roomTypes: RoomType[];         // Available unit types
  reviews: Review[];             // Guest reviews
  policies: {
    checkIn: string;
    checkOut: string;
    cancellation: string;
  };
  similarProperties: string[];   // Related IDs
}

interface RoomType {
  id: string;
  name: string;
  description: string;
  maxOccupancy: number;
  baseCapacity: number;
  sizeSqm: number;
  bedConfiguration: string[];
  amenities: string[];
  images: string[];
  basePrice: number;
}

interface Review {
  id: string;
  author: string;
  rating: number;
  date: string;
  content: string;
}
```

**Schema Mapping**:
| Entity | Source System | Table | Key Field |
|--------|--------------|-------|-----------|
| Property | Reserve | `properties_map` | `slug` (URL param) |
| Room Types | Reserve | `unit_map` | `property_id` FK |
| Availability | Reserve | `availability_calendar` | `unit_id` + date range |
| Reviews | **GAP** | Not defined | Needs table |

**Gap**: Reviews system not implemented in any schema

---

### Feature 5: Availability Calendar
**Location**: `/hospedagem/:id` - Booking section
**Required Data**:
- Per-unit availability by date
- Pricing per date
- Minimum stay requirements
- Blocked dates

**Schema Mapping**:
- Table: `reserve.availability_calendar`
- Key query: Unit ID + date range
- Fields: `is_available`, `is_blocked`, `base_price`, `discounted_price`, `min_stay_override`

**Gap**: Currently hardcoded mock calendar

---

### Feature 6: Booking Flow
**Location**: `/hospedagem/:id` → Checkout
**Required Data**:
- Selected dates
- Selected room type
- Guest details
- Payment processing
- Confirmation code generation

**Schema Mapping**:
- Reservations: `reserve.reservations`
- Travelers: `reserve.travelers`
- Payment: External (Stripe)
- Confirmation: `reserve.generate_confirmation_code()`

**Gap**: No booking implementation, no payment integration

---

### Feature 7: Events Calendar
**Location**: `/eventos`
**Required Fields**:
```typescript
interface Event {
  id: string;
  category: string;
  title: string;
  description: string;
  startDate: string;             // ISO date
  endDate: string;               // ISO date
  location: string;
  image: string;
  urgency: string;               // "This weekend", "Coming soon"
}
```

**Schema Mapping**:
- Source: Portal Connect
- Table: `events`
- Key fields: `title_i18n`, `start_at`, `end_at`, `status='published'`

**Gap**: Currently hardcoded. Needs Portal Connect integration

---

### Feature 8: Restaurant Directory
**Location**: `/restaurantes`, `/restaurante/:id`
**Required Fields**:
```typescript
interface Restaurant {
  id: string;
  name: string;
  category: string;              // Cuisine type
  rating: string;                // Display rating
  reviews: string;               // Review count display
  image: string;
  description: string;
  address: string;
  phone: string;
  hours: string;
  menu?: string;                 // Menu URL
}
```

**Schema Mapping**:
- Source: Portal Connect
- Table: `places` (with `kind='food'`)
- Related: `place_categories`, `place_images`

**Gap**: Currently hardcoded mock data

---

### Feature 9: Attractions Guide
**Location**: `/onde-ir`
**Required Data**:
- Places with `kind='attraction'`
- Categories for filtering
- Images and descriptions

**Schema Mapping**:
- Source: Portal Connect
- Table: `places` (filtered by `kind`)

**Gap**: Hardcoded data

---

### Feature 10: Group Bookings
**Location**: `/grupos-e-agencias`
**Required Data**:
- Group type options
- Form submission handling
- Lead creation

**Schema Mapping**:
- Form submissions → External API (readdy.ai)
- Potential: Create `reserve.reservation_leads` via Edge Function

---

### Feature 11: Contact Form
**Location**: `/contato`
**Required Data**:
- Form fields validation
- Submission handling

**Schema Mapping**:
- Currently: `https://readdy.ai/api/form/...`
- Potential: Create support tickets in Host Connect

---

## Data Requirements Matrix

### Matrix Legend
- ✅ **Implemented**: Data exists and is accessible
- ⚠️ **Partial**: Partially implemented or needs sync
- ❌ **Missing**: Not implemented
- 🔄 **Sync Required**: Needs cross-system synchronization

### Core Entities

| Entity | Host Connect | Portal Connect | Reserve Connect | App Usage | Status |
|--------|-------------|----------------|-----------------|-----------|--------|
| **Properties** | ✅ Canonical | ⚠️ Optional | ✅ Synced | Primary | 🔄 Needs sync |
| **Room Types** | ✅ Canonical | ❌ N/A | ✅ Synced | Primary | 🔄 Needs sync |
| **Availability** | ✅ Canonical | ❌ N/A | ✅ Cache | Primary | 🔄 Needs sync |
| **Bookings** | ✅ Canonical | ❌ N/A | ✅ Synced | Write | 🔄 Needs sync |
| **Pricing** | ✅ Canonical | ❌ N/A | ✅ Synced | Read | 🔄 Needs sync |
| **Cities** | ❌ N/A | ⚠️ `sites` | ✅ Master | Reference | ⚠️ Alignment needed |
| **Events** | ❌ N/A | ✅ Master | ❌ N/A | Primary | ⚠️ Portal integration |
| **Restaurants** | ❌ N/A | ✅ Master | ❌ N/A | Primary | ⚠️ Portal integration |
| **Attractions** | ❌ N/A | ✅ Master | ❌ N/A | Primary | ⚠️ Portal integration |
| **Hero Content** | ❌ N/A | ✅ Master | ❌ N/A | Primary | ⚠️ Portal integration |
| **Reviews** | ❌ N/A | ❌ N/A | ❌ N/A | Missing | ❌ Needs creation |
| **Users/Auth** | ✅ Auth | ✅ Auth | ✅ Auth | Auth | ⚠️ Consolidation? |

### Field-Level Requirements by Page

#### Home Page (`/`)

| Feature | Required Fields | Source | Current Status |
|---------|----------------|--------|----------------|
| Hero Carousel | image, headline, cta | Portal.hero_banners | ❌ Hardcoded |
| Search Widget | cities list | Reserve.cities | ❌ Hardcoded |
| Featured Accommodations | id, name, price, rating, image | Reserve.properties_map | ❌ Hardcoded |
| Events Preview | id, title, date, image | Portal.events | ❌ Hardcoded |
| Restaurants Preview | id, name, category, image | Portal.places | ❌ Hardcoded |
| Trust Indicators | stats numbers | Analytics | ❌ Hardcoded |
| FAQ | questions, answers | Static | ✅ Static (OK) |

#### Accommodations Listing (`/hospedagens`)

| Feature | Required Fields | Source | Current Status |
|---------|----------------|--------|----------------|
| Context Bar | checkin, checkout, guests | URL params | ✅ Implemented |
| Filters | types, amenities, price ranges | Static config | ⚠️ Static (OK) |
| Property Cards | 10+ fields | Reserve.properties_map | ❌ Hardcoded |
| Pagination | count, page | Query result | ❌ Not implemented |
| Availability Badge | available rooms | Reserve.availability_calendar | ❌ Mock data |

#### Property Detail (`/hospedagem/:id`)

| Feature | Required Fields | Source | Current Status |
|---------|----------------|--------|----------------|
| Gallery | 5-10 images | Reserve.properties_map.images_cached | ❌ Hardcoded |
| Header Info | name, rating, location | Reserve.properties_map | ❌ Hardcoded |
| Amenities | list | Reserve.properties_map.amenities_cached | ❌ Hardcoded |
| Description | text | Reserve.properties_map.description | ❌ Hardcoded |
| Room Types | id, name, capacity, price | Reserve.unit_map + availability_calendar | ❌ Hardcoded |
| Availability Calendar | dates, prices, availability | Reserve.availability_calendar | ❌ Mock |
| Reviews | author, rating, content | **GAP** | ❌ Not implemented |
| Location Map | lat, lng | Reserve.properties_map | ❌ Hardcoded coords |
| Booking Form | dates, guests | User input | ✅ Implemented |
| Similar Properties | related IDs | Algorithm + Reserve.properties_map | ❌ Hardcoded |

#### Events (`/eventos`)

| Feature | Required Fields | Source | Current Status |
|---------|----------------|--------|----------------|
| Event Cards | 8+ fields | Portal.events | ❌ Hardcoded |
| Filter Chips | categories | Portal.event_categories | ❌ Hardcoded |
| Calendar View | dates, events | Portal.events | ❌ Not implemented |

#### Restaurants (`/restaurantes`)

| Feature | Required Fields | Source | Current Status |
|---------|----------------|--------|----------------|
| Restaurant Cards | 6+ fields | Portal.places | ❌ Hardcoded |
| Category Filter | cuisine types | Portal.place_categories | ❌ Hardcoded |
| Detail Page | full info + gallery | Portal.places + place_images | ❌ Hardcoded |

---

## Supabase Integration Status

### Current Configuration
```typescript
// Configured but NOT used
VITE_SUPABASE_URL=https://ffahkiukektmhkrkordn.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIs...
```

### Existing Edge Functions (in migrations)
1. `search_availability` - Search available room types
2. `sync_host_properties` - Sync properties from Host
3. `sync_host_room_types` - Sync room types from Host

### Required Edge Functions (Not Yet Created)

#### From Reserve Connect
1. `get_properties_by_city` - List properties with filters
2. `get_property_detail` - Full property with units
3. `check_availability` - Calendar availability query
4. `create_reservation` - Booking creation
5. `get_user_reservations` - Booking history

#### From Portal Connect
6. `get_hero_banners` - Homepage carousel
7. `get_events` - Events listing
8. `get_event_detail` - Single event
9. `get_restaurants` - Food places
10. `get_restaurant_detail` - Single restaurant
11. `get_attractions` - Things to do
12. `get_content_by_slot` - Homepage content sections

---

## Authentication Requirements

### Current State
- No authentication implemented
- No user state management
- No protected routes

### Required Auth Flows
1. **Traveler Registration/Login**
   - Source: Reserve Connect `travelers` table
   - Link to: `auth.users`
   - Fields: email, password, profile info

2. **Guest Booking** (Optional)
   - Allow bookings without registration
   - Create `travelers` record without `auth_user_id`

3. **Social Login** (Future)
   - Google OAuth
   - Facebook Login

### Auth Schema Mapping
```typescript
// Reserve Connect
interface Traveler {
  id: UUID;                      // PK
  auth_user_id: UUID?;           // FK to auth.users
  email: string;                 // Unique
  first_name: string;
  last_name: string;
  phone: string;
  preferences: JSONB;
  // ... address fields
}
```

---

## Data Volume Estimates

### Current Mock Data
- **Properties**: ~20 hardcoded items
- **Restaurants**: ~8 hardcoded items
- **Events**: ~6 hardcoded items
- **Reviews**: ~50 hardcoded reviews

### Expected Production Data
- **Properties per City**: 50-200
- **Room Types per Property**: 3-10
- **Availability Records**: 365 days × units × rate plans
- **Events per City**: 20-100 active
- **Restaurants per City**: 30-150
- **Attractions per City**: 20-80

### Query Performance Considerations
- Property listing: Pagination (20/page)
- Availability search: Date range queries with indexing
- Event filtering: Category + date range
- Map clustering: Geo queries for large datasets

---

## External Integrations

### Currently Integrated
1. **readdy.ai API**
   - Image CDN (`https://images.unsplash.com`)
   - Form submission endpoint
   
2. **Google Maps Embed**
   - Static map embeds
   - API Key required for production

3. **WhatsApp**
   - Click-to-chat links
   - No API integration

### Required Integrations
1. **Supabase Client**
   - Real-time subscriptions for availability
   - Auth flow
   - Edge Functions

2. **Payment Gateway (Stripe)**
   - Configured in package.json but not used
   - Payment intents for bookings
   - Webhook handling

3. **Image CDN Migration**
   - Move from Unsplash to managed storage
   - Supabase Storage or Cloudinary

---

## Risk Assessment

### High Risk
1. **No Data Integrity**: All mock data means zero testing with real schemas
2. **Multi-System Complexity**: Three Supabase instances require careful orchestration
3. **Sync Failure**: Host → Reserve sync failures could show stale data
4. **No Reviews System**: Critical feature completely missing

### Medium Risk
1. **Performance**: No query optimization tested
2. **i18n**: Content tables support i18n but implementation incomplete
3. **SEO**: All client-side rendered, no SSR

### Low Risk
1. **UI/UX**: Well-designed, responsive
2. **Static Content**: Terms, privacy pages complete

---

## Recommendations

### Immediate (Pre-Edge Function Phase)
1. **Create Reviews Schema**: Add to Reserve Connect
2. **Establish Canonical Keys**: Define `slug`, `city_code` standards
3. **Sync Strategy**: Define Host → Reserve sync intervals
4. **Portal Integration**: Define which content syncs vs. proxies

### Phase 1 (Core Booking)
1. Implement Supabase client
2. Connect property search to Reserve
3. Implement availability calendar
4. Create booking flow
5. Add authentication

### Phase 2 (Content)
1. Integrate Portal Connect for events
2. Integrate restaurants/attractions
3. Dynamic hero content
4. CMS-driven pages

### Phase 3 (Advanced)
1. Real-time availability
2. Reviews system
3. Payment processing
4. Admin dashboards

---

## Appendix: Environment Variables

```bash
# Supabase
VITE_SUPABASE_URL=https://ffahkiukektmhkrkordn.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIs...

# Build-time
BASE_PATH=/
IS_PREVIEW=false
PROJECT_ID=reserve-connect-pc
VERSION_ID=1.0.0
READDY_AI_DOMAIN=readdy.ai
```

## Appendix: Dependencies

```json
{
  "@supabase/supabase-js": "^2.49.1",
  "react": "^19.0.0",
  "react-router-dom": "^7.2.0",
  "react-i18next": "^15.4.1",
  "tailwindcss": "^3.4.17",
  "@stripe/stripe-js": "^5.8.0"  // Not used yet
}
```

---

*Document generated: 2026-02-15*
*Analysis scope: Site App + 3 Database Schemas*
*Status: READ-ONLY ANALYSIS PHASE*
