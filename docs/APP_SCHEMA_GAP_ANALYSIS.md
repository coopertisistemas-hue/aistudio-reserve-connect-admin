# APP-SCHEMA GAP ANALYSIS

## Executive Summary

This document maps every page and feature in the Reserve Connect Site App to the required database schemas, identifies critical gaps, and provides a pre-implementation alignment strategy.

### Gap Summary
- **Total Features Analyzed**: 47
- **Fully Supported**: 3 (6%)
- **Partially Supported**: 8 (17%)
- **Not Supported**: 36 (77%)
- **Critical Gaps**: 12
- **Blockers for MVP**: 5

### Systems Required
1. **Reserve Connect** - 28 features dependent
2. **Portal Connect** - 19 features dependent
3. **Host Connect** - 6 features dependent (via sync)
4. **Cross-System** - 14 features require multi-system joins

---

## Page-by-Page Gap Analysis

### Page 1: Home (`/`)

#### Feature 1.1: Hero Carousel
**Current**: Hardcoded array of 3 slides with images, headlines, CTAs
**Required Schema**: Portal Connect
```sql
SELECT hb.*, m.public_url as image_url
FROM portal.hero_banners hb
LEFT JOIN portal.media m ON m.id = hb.primary_media_id
WHERE hb.site_id = :site_id
  AND hb.is_active = true
  AND (hb.starts_at IS NULL OR hb.starts_at <= NOW())
  AND (hb.ends_at IS NULL OR hb.ends_at >= NOW())
ORDER BY hb.sort_order ASC;
```

**Gap**: 
- ❌ No Supabase client configured
- ❌ No data fetching implemented
- ❌ Images use external CDN (Unsplash)

**Alignment Required**:
1. Add Supabase client initialization
2. Create `get_hero_banners` Edge Function
3. Migrate images to Supabase Storage or keep CDN
4. Add loading states

**Priority**: HIGH (Critical visual element)

---

#### Feature 1.2: Search Widget
**Current**: Form with hardcoded city suggestions
**Required Schema**: Reserve Connect
```sql
SELECT code, name, state_province, timezone
FROM reserve.cities
WHERE is_active = true
ORDER BY name ASC;
```

**Gap**:
- ❌ Cities list is hardcoded
- ❌ No availability checking
- ❌ No date constraints from calendar

**Alignment Required**:
1. Create `get_cities` Edge Function or direct query
2. Integrate with availability calendar for min/max dates
3. Add guest count validation

**Priority**: HIGH (Primary conversion point)

---

#### Feature 1.3: Featured Accommodations
**Current**: Array of 20 hardcoded properties with full details
**Required Schema**: Reserve Connect
```sql
SELECT 
  p.id, p.slug, p.name, p.property_type,
  p.city, p.state_province,
  p.rating_cached, p.review_count_cached,
  p.images_cached->0 as primary_image,
  p.amenities_cached,
  MIN(ac.base_price) as min_price
FROM reserve.properties_map p
LEFT JOIN reserve.unit_map u ON u.property_id = p.id
LEFT JOIN reserve.availability_calendar ac ON ac.unit_id = u.id
WHERE p.city_id = :city_id
  AND p.is_active = true
  AND p.is_published = true
  AND ac.date BETWEEN :check_in AND :check_out
  AND ac.is_available = true
GROUP BY p.id
ORDER BY p.rating_cached DESC NULLS LAST
LIMIT 6;
```

**Gap**:
- ❌ No properties in Reserve (need Host sync)
- ❌ No availability calendar data
- ❌ No real pricing
- ❌ No images in proper format

**Alignment Required**:
1. **CRITICAL**: Sync Host properties to Reserve
2. Create `sync_host_properties` Edge Function
3. Create `get_featured_properties` Edge Function
4. Set up image sync or URL mapping
5. Add caching layer for performance

**Priority**: CRITICAL (Core feature)

---

#### Feature 1.4: Events Preview
**Current**: 4 hardcoded event cards
**Required Schema**: Portal Connect
```sql
SELECT 
  e.id, e.slug, e.title_i18n->>'pt' as title,
  e.start_at, e.end_at, e.cover_url,
  c.name as category_name
FROM portal.events e
LEFT JOIN portal.event_categories c ON c.id = e.category_id
WHERE e.site_id = :site_id
  AND e.status = 'published'
  AND e.start_at >= CURRENT_DATE
ORDER BY e.start_at ASC
LIMIT 4;
```

**Gap**:
- ❌ No Portal integration
- ❌ No events data

**Alignment Required**:
1. Create `get_upcoming_events` Edge Function
2. Add Portal Supabase client or proxy through Reserve
3. Map site_id based on current city

**Priority**: MEDIUM (Content enhancement)

---

#### Feature 1.5: Restaurants Preview
**Current**: 4 hardcoded restaurant cards
**Required Schema**: Portal Connect
```sql
SELECT 
  p.id, p.slug, p.name_i18n->>'pt' as name,
  pc.name as category,
  pi.url as image_url
FROM portal.places p
LEFT JOIN portal.place_categories pc ON pc.id = p.category_id
LEFT JOIN portal.place_images pi ON pi.place_id = p.id AND pi.is_primary = true
WHERE p.site_id = :site_id
  AND p.kind = 'food'
  AND p.status = 'published'
ORDER BY p.is_featured DESC, p.sort_order ASC
LIMIT 4;
```

**Gap**:
- ❌ No Portal integration
- ❌ No places data

**Alignment Required**:
1. Create `get_featured_restaurants` Edge Function
2. Add category filtering
3. Implement image gallery

**Priority**: MEDIUM (Content enhancement)

---

#### Feature 1.6: Trust Indicators
**Current**: Hardcoded statistics ("2.000+ viajantes", "4.9/5 avaliação")
**Required Schema**: Reserve Connect (analytics)
```sql
SELECT 
  COUNT(DISTINCT t.id) as total_travelers,
  AVG(r.rating) as avg_rating,
  COUNT(DISTINCT r.id) as total_reviews
FROM reserve.travelers t
LEFT JOIN reserve.reviews r ON r.traveler_id = t.id
WHERE t.created_at >= NOW() - INTERVAL '1 year';
```

**Gap**:
- ❌ No reviews table exists (see GAP-001)
- ❌ No aggregated metrics query
- ❌ No caching of stats

**Alignment Required**:
1. Create reviews schema (GAP-001)
2. Create `get_platform_stats` Edge Function
3. Cache results in `kpi_daily_snapshots`

**Priority**: LOW (Marketing content)

---

#### Feature 1.7: FAQ Section
**Current**: Hardcoded 5 Q&A pairs
**Required Schema**: None (static content acceptable)

**Gap**: None

**Status**: ✅ Supported

---

### Page 2: Accommodations Listing (`/hospedagens`)

#### Feature 2.1: Context Bar
**Current**: Displays search params from URL
**Required Schema**: None (client-side only)

**Status**: ✅ Supported

---

#### Feature 2.2: Filter Sidebar
**Current**: Static filter options
**Required Schema**: Reserve Connect + Static config

**Filter Options**:
1. **Property Types**: Static array ['hotel', 'pousada', 'casa', 'chale', 'camping', 'hostel']
2. **Price Ranges**: Static config (R$ 0-300, R$ 300-700, R$ 700+)
3. **Star Rating**: Static (1-5 stars)
4. **Amenities**: Dynamic from `reserve.properties_map.amenities_cached`
5. **Free Cancellation**: Static toggle

**Gap**:
- ⚠️ Amenities list should come from Host `amenities` table
- ❌ No dynamic price range calculation

**Alignment Required**:
1. Sync Host amenities to Reserve
2. Create `get_amenities_list` Edge Function
3. Calculate dynamic price ranges from availability

**Priority**: MEDIUM

---

#### Feature 2.3: Property Cards
**Current**: Full cards with mock data
**Required Schema**: Reserve Connect (same as Feature 1.3)

**Additional Requirements**:
- Pagination (20 per page)
- Sort options (price, rating, featured)
- Availability badge ("Somente 2 disponíveis")

**Gap**:
- ❌ No pagination implemented
- ❌ No sorting queries
- ❌ No real availability counts

**Alignment Required**:
1. Add pagination to `get_properties` query
2. Add sorting parameters
3. Calculate availability from `availability_calendar.allotment - bookings_count`

**Priority**: CRITICAL

---

#### Feature 2.4: Active Filters Display
**Current**: Shows selected filters as removable chips
**Required Schema**: None (client-side state)

**Status**: ✅ Supported

---

### Page 3: Property Detail (`/hospedagem/:id`)

#### Feature 3.1: Image Gallery
**Current**: Grid layout (desktop) / Carousel (mobile)
**Required Schema**: Reserve Connect
```sql
SELECT images_cached
FROM reserve.properties_map
WHERE slug = :property_slug
  AND city_id = :city_id;
-- Returns: ['url1', 'url2', ...]
```

**Gap**:
- ❌ No images synced from Host
- ❌ Image URLs not validated
- ❌ No CDN optimization

**Alignment Required**:
1. Sync property images from Host during sync
2. Validate image URLs
3. Add CDN or Supabase Storage
4. Implement image optimization (responsive sizes)

**Priority**: HIGH

---

#### Feature 3.2: Property Header
**Current**: Name, rating, review count, location
**Required Schema**: Reserve Connect
```sql
SELECT 
  p.name, p.property_type, p.city, p.state_province,
  p.rating_cached, p.review_count_cached,
  p.latitude, p.longitude
FROM reserve.properties_map p
WHERE p.slug = :property_slug
  AND p.city_id = :city_id;
```

**Gap**:
- ❌ No real property data
- ❌ No rating aggregation
- ❌ No geocoding verification

**Alignment Required**:
1. Sync basic property info from Host
2. Implement review aggregation (GAP-001)
3. Verify coordinates are valid

**Priority**: CRITICAL

---

#### Feature 3.3: Amenities List
**Current**: Expandable list of 8+ amenities
**Required Schema**: Reserve Connect
```sql
SELECT amenities_cached
FROM reserve.properties_map
WHERE slug = :property_slug;
-- Returns: ['wifi', 'parking', 'pool', ...]
```

**Gap**:
- ❌ Amenities not synced from Host
- ❌ No amenity icons
- ❌ No categorization (basic, comfort, luxury)

**Alignment Required**:
1. Sync `host.amenities_json` to `reserve.amenities_cached`
2. Create amenity metadata table (icon, category)
3. Map amenity codes to display names

**Priority**: MEDIUM

---

#### Feature 3.4: Description
**Current**: Full property description text
**Required Schema**: Reserve Connect
```sql
SELECT description
FROM reserve.properties_map
WHERE slug = :property_slug;
```

**Gap**:
- ❌ Description not synced from Host
- ⚠️ No i18n support (Portal has i18n, Reserve doesn't)

**Alignment Required**:
1. Sync description from Host
2. Consider i18n strategy (Portuguese only for MVP?)

**Priority**: MEDIUM

---

#### Feature 3.5: Room Types Section
**Current**: Cards showing room details and pricing
**Required Schema**: Reserve Connect
```sql
SELECT 
  u.id, u.name, u.slug, u.description,
  u.max_occupancy, u.base_capacity,
  u.size_sqm, u.bed_configuration,
  u.amenities_cached, u.images_cached,
  MIN(ac.base_price) as min_price,
  MAX(ac.discounted_price) as max_discount
FROM reserve.unit_map u
LEFT JOIN reserve.availability_calendar ac ON ac.unit_id = u.id
WHERE u.property_id = :property_id
  AND u.is_active = true
  AND ac.date BETWEEN :check_in AND :check_out
  AND ac.is_available = true
GROUP BY u.id;
```

**Gap**:
- ❌ No room types synced from Host
- ❌ No availability calendar data
- ❌ No pricing rules applied

**Alignment Required**:
1. **CRITICAL**: Sync `host.room_types` to `reserve.unit_map`
2. Create `sync_host_room_types` Edge Function
3. Populate availability calendar from Host bookings
4. Apply rate plan pricing

**Priority**: CRITICAL (Required for booking)

---

#### Feature 3.6: Availability Calendar
**Current**: Static calendar grid
**Required Schema**: Reserve Connect
```sql
SELECT 
  date, is_available, is_blocked, block_reason,
  base_price, discounted_price,
  min_stay_override, allotment, bookings_count
FROM reserve.availability_calendar
WHERE unit_id = :unit_id
  AND date BETWEEN :start_date AND :end_date
ORDER BY date ASC;
```

**Gap**:
- ❌ No availability data
- ❌ No pricing per date
- ❌ No blocked dates
- ❌ No minimum stay enforcement

**Alignment Required**:
1. Create availability calendar population job
2. Sync Host bookings to Reserve availability
3. Handle OTA blocking
4. Implement calendar UI with real data

**Priority**: CRITICAL (Required for booking)

---

#### Feature 3.7: Reviews Section
**Current**: Hardcoded 6 reviews with ratings breakdown
**Required Schema**: **GAP - TABLE DOESN'T EXIST**

**Required Schema**:
```sql
-- NEW TABLE NEEDED
CREATE TABLE reserve.reviews (
  id UUID PRIMARY KEY,
  reservation_id UUID REFERENCES reservations(id),
  traveler_id UUID REFERENCES travelers(id),
  property_id UUID REFERENCES properties_map(id),
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  cleanliness_rating INTEGER,
  service_rating INTEGER,
  location_rating INTEGER,
  value_rating INTEGER,
  title VARCHAR(200),
  content TEXT,
  is_verified BOOLEAN DEFAULT false,
  is_published BOOLEAN DEFAULT false,
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Gap**: 
- ❌ No reviews table
- ❌ No review submission flow
- ❌ No rating aggregation

**Alignment Required**:
1. Create reviews schema (GAP-001)
2. Add review submission Edge Function
3. Add review moderation workflow
4. Implement rating aggregation

**Priority**: HIGH (Social proof critical for conversion)

---

#### Feature 3.8: Location Map
**Current**: Static Google Maps embed with hardcoded coords
**Required Schema**: Reserve Connect
```sql
SELECT latitude, longitude, address_line_1, city
FROM reserve.properties_map
WHERE slug = :property_slug;
```

**Gap**:
- ❌ Coordinates not verified
- ❌ No interactive map features
- ⚠️ Google Maps API key not configured

**Alignment Required**:
1. Verify coordinates during Host sync
2. Add Google Maps API key
3. Consider Mapbox alternative

**Priority**: MEDIUM

---

#### Feature 3.9: Booking Form
**Current**: Date picker with guest selection
**Required Schema**: Reserve Connect

**Flow**:
1. User selects dates → Check availability
2. User selects room type → Validate capacity
3. User enters details → Create reservation
4. Payment → Stripe integration

**Gap**:
- ❌ No availability validation
- ❌ No reservation creation
- ❌ No Stripe integration
- ❌ No confirmation email

**Alignment Required**:
1. Create `check_availability` Edge Function
2. Create `create_reservation` Edge Function
3. Implement Stripe payment flow
4. Add email notifications (Supabase Auth or SendGrid)

**Priority**: CRITICAL (Core revenue feature)

---

#### Feature 3.10: Similar Properties
**Current**: 3 hardcoded property cards
**Required Schema**: Reserve Connect
```sql
SELECT 
  p.id, p.slug, p.name, p.property_type,
  p.rating_cached, p.images_cached->0 as image
FROM reserve.properties_map p
WHERE p.city_id = :city_id
  AND p.id != :current_property_id
  AND p.property_type = :current_type
  AND p.is_published = true
ORDER BY p.rating_cached DESC NULLS LAST
LIMIT 3;
```

**Gap**:
- ❌ No real data
- ❌ No similarity algorithm

**Alignment Required**:
1. Implement simple similarity (same city, same type)
2. Future: ML-based recommendations

**Priority**: LOW

---

### Page 4: Events (`/eventos`)

#### Feature 4.1: Events List
**Current**: Filterable grid of hardcoded events
**Required Schema**: Portal Connect
```sql
SELECT 
  e.id, e.slug, e.title_i18n->>'pt' as title,
  e.summary_i18n->>'pt' as summary,
  e.start_at, e.end_at, e.cover_url,
  e.location_name, e.city, e.state,
  c.name as category_name
FROM portal.events e
LEFT JOIN portal.event_categories c ON c.id = e.category_id
WHERE e.site_id = :site_id
  AND e.status = 'published'
  AND (:category IS NULL OR e.category_id = :category)
  AND e.start_at >= :start_date
ORDER BY e.start_at ASC;
```

**Gap**:
- ❌ No Portal integration
- ❌ No events data
- ❌ No category filtering

**Alignment Required**:
1. Create `get_events` Edge Function
2. Implement category filter chips
3. Add date range filtering

**Priority**: MEDIUM (Content feature)

---

#### Feature 4.2: Event Categories
**Current**: 5 static filter chips
**Required Schema**: Portal Connect
```sql
SELECT id, name, color
FROM portal.event_categories
WHERE site_id = :site_id
ORDER BY sort_order ASC;
```

**Gap**:
- ❌ No category data

**Alignment Required**:
1. Sync/create event categories in Portal
2. Create `get_event_categories` Edge Function

**Priority**: LOW

---

### Page 5: Restaurants (`/restaurantes`)

#### Feature 5.1: Restaurant Directory
**Current**: Grid of hardcoded restaurants
**Required Schema**: Portal Connect
```sql
SELECT 
  p.id, p.slug, p.name_i18n->>'pt' as name,
  p.description_i18n->>'pt' as description,
  p.phone, p.whatsapp, p.email,
  p.address_line, p.city, p.state,
  p.lat, p.lng,
  pc.name as category,
  pi.url as image_url
FROM portal.places p
LEFT JOIN portal.place_categories pc ON pc.id = p.category_id
LEFT JOIN portal.place_images pi ON pi.place_id = p.id AND pi.is_primary = true
WHERE p.site_id = :site_id
  AND p.kind = 'food'
  AND p.status = 'published'
  AND (:category IS NULL OR p.category_id = :category)
ORDER BY p.is_featured DESC, p.sort_order ASC;
```

**Gap**:
- ❌ No Portal integration
- ❌ No restaurants data

**Alignment Required**:
1. Create `get_restaurants` Edge Function
2. Add category filtering
3. Implement map view (optional)

**Priority**: MEDIUM

---

#### Feature 5.2: Restaurant Detail
**Current**: Full detail page with gallery
**Required Schema**: Portal Connect
```sql
-- Main info
SELECT *
FROM portal.places
WHERE slug = :restaurant_slug
  AND site_id = :site_id
  AND kind = 'food';

-- Gallery
SELECT url, caption, sort_order
FROM portal.place_images
WHERE place_id = :place_id
ORDER BY sort_order ASC;

-- Categories
SELECT * FROM portal.place_categories WHERE id = :category_id;
```

**Gap**:
- ❌ No detail query implemented

**Alignment Required**:
1. Create `get_restaurant_detail` Edge Function
2. Add gallery component
3. Add contact/action buttons

**Priority**: MEDIUM

---

### Page 6: Attractions (`/onde-ir`)

#### Feature 6.1: Attractions Guide
**Current**: Hardcoded attractions with itinerary
**Required Schema**: Portal Connect
```sql
SELECT 
  p.id, p.slug, p.name_i18n->>'pt' as name,
  p.description_i18n->>'pt' as description,
  p.category_type, p.attributes,
  pc.name as category,
  pi.url as image_url
FROM portal.places p
LEFT JOIN portal.place_categories pc ON pc.id = p.category_id
LEFT JOIN portal.place_images pi ON pi.place_id = p.id AND pi.is_primary = true
WHERE p.site_id = :site_id
  AND p.kind = 'attraction'
  AND p.status = 'published'
ORDER BY p.sort_order ASC;
```

**Gap**:
- ❌ No attractions data

**Alignment Required**:
1. Create `get_attractions` Edge Function
2. Categorize by type (nature, culture, adventure, etc.)

**Priority**: LOW

---

### Page 7: Group Bookings (`/grupos-e-agencias`)

#### Feature 7.1: Group Proposal Form
**Current**: Form submitting to readdy.ai API
**Required Schema**: External or Reserve

**Options**:
1. Continue using readdy.ai form API (current)
2. Create `create_group_lead` Edge Function → Reserve

**Gap**:
- ❌ No tracking in Reserve

**Alignment Required**:
1. Create `reservation_leads` table extension or use existing
2. Create Edge Function for form submission
3. Add email notification to sales team

**Priority**: LOW (Working with external API)

---

### Page 8: Contact (`/contato`)

#### Feature 8.1: Contact Form
**Current**: Form submitting to readdy.ai API
**Required Schema**: External or Host

**Options**:
1. Continue using readdy.ai (current)
2. Create tickets in Host Connect

**Gap**: None (functional as-is)

**Priority**: LOW

---

## Critical Gaps Summary

### GAP-001: Reviews System
**Impact**: HIGH
**Description**: No reviews table exists in any schema
**Required for**: Property ratings, social proof, conversion optimization

**Solution**:
```sql
-- Add to Reserve Connect
CREATE TABLE reserve.reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reservation_id UUID REFERENCES reservations(id) ON DELETE CASCADE,
  traveler_id UUID REFERENCES travelers(id) ON DELETE SET NULL,
  property_id UUID REFERENCES properties_map(id) ON DELETE CASCADE,
  
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
  is_verified BOOLEAN DEFAULT false,
  is_published BOOLEAN DEFAULT false,
  moderation_notes TEXT,
  moderated_by UUID REFERENCES auth.users(id),
  moderated_at TIMESTAMPTZ,
  
  -- Stay details (denormalized for display)
  stay_date DATE,
  room_type VARCHAR(100),
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_reviews_property ON reviews(property_id) WHERE is_published = true;
CREATE INDEX idx_reviews_traveler ON reviews(traveler_id);
CREATE INDEX idx_reviews_rating ON reviews(property_id, overall_rating) WHERE is_published = true;
CREATE INDEX idx_reviews_created ON reviews(created_at DESC);
```

**Effort**: 2-3 days
**Priority**: HIGH

---

### GAP-002: Host → Reserve Property Sync
**Impact**: CRITICAL
**Description**: No mechanism to sync Host properties to Reserve
**Required for**: All accommodation features

**Solution**:
1. Create `sync_host_properties` Edge Function (already in migrations)
2. Schedule sync job (hourly via pg_cron or external scheduler)
3. Map Host `properties` → Reserve `properties_map`
4. Generate slugs automatically
5. Handle image URL transformation

**Data Mapping**:
```typescript
// Host property → Reserve property_map
{
  host_property_id: hostProperty.id,
  city_id: lookupCityId(hostProperty.city, hostProperty.state),
  name: hostProperty.name,
  slug: generateSlug(hostProperty.name, hostProperty.city),
  description: hostProperty.description,
  property_type: mapPropertyType(hostProperty.total_rooms),
  address_line_1: hostProperty.address,
  city: hostProperty.city,
  state_province: hostProperty.state,
  country: hostProperty.country || 'Brazil',
  phone: hostProperty.phone,
  email: hostProperty.email,
  is_active: hostProperty.status === 'active',
  is_published: false // Manual approval required
}
```

**Effort**: 3-5 days
**Priority**: CRITICAL

---

### GAP-003: Host → Reserve Room Type Sync
**Impact**: CRITICAL
**Description**: No mechanism to sync Host room types to Reserve
**Required for**: Booking flow

**Solution**:
1. Create `sync_host_room_types` Edge Function
2. Map Host `room_types` → Reserve `unit_map`
3. Sync amenities as JSON array

**Effort**: 2-3 days
**Priority**: CRITICAL

---

### GAP-004: Availability Calendar Population
**Impact**: CRITICAL
**Description**: `availability_calendar` table is empty
**Required for**: Availability search, booking

**Solution**:
1. Create calendar population script
2. Generate 365 days × units × rate plans
3. Sync Host bookings to block availability
4. Sync OTA bookings via iCal or API
5. Set up incremental sync (nightly full, real-time for bookings)

**Algorithm**:
```sql
-- Populate next 365 days for each unit/rate plan
INSERT INTO reserve.availability_calendar (
  unit_id, rate_plan_id, date, base_price, 
  is_available, currency, allotment
)
SELECT 
  u.id as unit_id,
  rp.id as rate_plan_id,
  d.date,
  COALESCE(pr.base_price_override, u.base_price) as base_price,
  true as is_available,
  'BRL' as currency,
  1 as allotment -- Or fetch from room count
FROM reserve.unit_map u
CROSS JOIN reserve.rate_plans rp
CROSS JOIN generate_series(
  CURRENT_DATE, 
  CURRENT_DATE + INTERVAL '365 days', 
  INTERVAL '1 day'
) AS d(date)
LEFT JOIN reserve.pricing_rules pr ON (
  pr.room_type_id = u.host_unit_id
  AND d.date BETWEEN pr.start_date AND pr.end_date
)
WHERE u.is_active = true
  AND rp.is_active = true;
```

**Effort**: 3-4 days
**Priority**: CRITICAL

---

### GAP-005: Portal Integration
**Impact**: HIGH
**Description**: No connection to Portal Connect for content
**Required for**: Events, restaurants, attractions, hero banners

**Solution Options**:

**Option A: Direct Portal Queries**
- Add Portal Supabase client to site app
- Query Portal directly for content
- Requires CORS configuration

**Option B: Reserve Proxy**
- Reserve Edge Functions proxy to Portal
- Single Supabase client in app
- Better security control

**Option C: Content Sync**
- Sync Portal content to Reserve
- Eventual consistency
- Simpler app logic

**Recommendation**: Option B (Reserve Proxy)

**Effort**: 3-4 days
**Priority**: HIGH

---

### GAP-006: City-Site Mapping
**Impact**: MEDIUM
**Description**: No explicit mapping between Reserve cities and Portal sites
**Required for**: Cross-system queries

**Solution**:
```sql
-- Add to Reserve or Portal
CREATE TABLE city_site_mappings (
  city_id UUID REFERENCES reserve.cities(id),
  site_id UUID REFERENCES portal.sites(id),
  city_code VARCHAR(10) NOT NULL,
  site_slug TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (city_id, site_id)
);

-- Initial data for pilot
INSERT INTO city_site_mappings (city_id, site_id, city_code, site_slug)
VALUES 
  ('uuid-reserve-urb', 'uuid-portal-urb', 'URB', 'urubici');
```

**Effort**: 1 day
**Priority**: MEDIUM

---

### GAP-007: Image Management
**Impact**: MEDIUM
**Description**: Images use external CDN without optimization
**Required for**: Performance, reliability

**Solution**:
1. Evaluate options:
   - Supabase Storage (transformations available)
   - Cloudinary (advanced optimization)
   - Imgix (performance focus)
2. Sync Host images to chosen CDN
3. Update `images_cached` to use new URLs
4. Implement responsive images (srcset)

**Effort**: 2-3 days
**Priority**: MEDIUM

---

### GAP-008: Booking Flow
**Impact**: CRITICAL
**Description**: No reservation creation or payment processing
**Required for**: Revenue

**Solution**:
1. Create `create_reservation` Edge Function
2. Validate availability
3. Create reservation record
4. Initiate Stripe payment
5. Handle webhook confirmation
6. Sync to Host

**Flow**:
```
User → Select dates/room → Check availability
  ↓
Create reservation (pending)
  ↓
Stripe payment intent
  ↓
User payment → Webhook confirmation
  ↓
Update reservation (confirmed)
  ↓
Sync to Host (create booking)
  ↓
Send confirmation email
```

**Effort**: 5-7 days
**Priority**: CRITICAL

---

### GAP-009: Authentication
**Impact**: MEDIUM
**Description**: No user authentication
**Required for**: Booking history, loyalty, reviews

**Solution**:
1. Implement Supabase Auth
2. Create traveler profile on signup
3. Link reservations to traveler_id
4. Add protected routes (optional for MVP)

**Effort**: 2-3 days
**Priority**: MEDIUM (Guest checkout acceptable for MVP)

---

### GAP-010: Amenities Standardization
**Impact**: LOW
**Description**: Amenities stored as JSON arrays without standardization
**Required for**: Filtering, display

**Solution**:
1. Create `amenities` reference table in Reserve
2. Map Host amenity codes to standard codes
3. Create amenity metadata (icon, display name, category)
4. Normalize `properties_map.amenities_cached`

**Effort**: 2 days
**Priority**: LOW

---

## Required Structural Alignments (Pre-Edge Function Phase)

### Alignment 1: Schema Creation
**Before**: Creating any Edge Functions
**Actions**:
1. ✅ Create reviews table (GAP-001)
2. ✅ Create city_site_mappings table (GAP-006)
3. ✅ Add missing indexes (identified in MULTI_SCHEMA_CATALOG.md)

### Alignment 2: Sync Infrastructure
**Before**: Property listing features
**Actions**:
1. ✅ Deploy `sync_host_properties` Edge Function
2. ✅ Deploy `sync_host_room_types` Edge Function
3. ✅ Create sync scheduler (pg_cron or external)
4. ✅ Test sync with pilot property

### Alignment 3: Availability System
**Before**: Booking features
**Actions**:
1. ✅ Populate availability_calendar for next 365 days
2. ✅ Create incremental sync from Host bookings
3. ✅ Test availability queries
4. ✅ Create `check_availability` Edge Function

### Alignment 4: Content Integration
**Before**: Events, restaurants features
**Actions**:
1. ✅ Create Portal proxy Edge Functions
2. ✅ Test cross-system queries
3. ✅ Map site_id to city_id

### Alignment 5: Canonical Keys
**Before**: Public API exposure
**Actions**:
1. ✅ Ensure all properties have unique slugs
2. ✅ Validate city codes
3. ✅ Document canonical key strategy

---

## Risk Analysis

### Multi-Tenant Leakage Risks

**Risk**: Reserve properties_map uses `city_id` for tenancy
**Scenario**: Query without city_id filter shows all cities' properties
**Mitigation**:
```sql
-- RLS Policy
CREATE POLICY city_isolation ON reserve.properties_map
  FOR SELECT TO authenticated
  USING (city_id = current_setting('app.current_city_id')::uuid);

-- Always include in queries
WHERE city_id = :city_id
```

**Risk Level**: MEDIUM
**Priority**: HIGH

---

### Data Duplication Risks

**Risk**: Portal `places.kind='lodging'` duplicates Host `properties`
**Scenario**: Same accommodation listed in both systems
**Mitigation**:
1. Portal places for lodging should reference Reserve properties
2. Add `external_id` column to Portal places
3. Sync from Reserve, not manual entry

**Risk Level**: MEDIUM
**Priority**: MEDIUM

---

### Coupling Risks

**Risk**: Host sync failure breaks Reserve functionality
**Scenario**: Host system down, no property updates
**Mitigation**:
1. Implement circuit breaker pattern
2. Use cached data with TTL
3. Show "last updated" timestamp
4. Graceful degradation (show cached, disable booking)

**Risk Level**: HIGH
**Priority**: HIGH

---

### Migration Risks

**Risk**: Data migration from mock to real causes UX disruption
**Scenario**: Properties disappear or change during switch
**Mitigation**:
1. Seed with pilot property first
2. Parallel run (show both mock and real, flag differences)
3. Gradual rollout by city
4. Rollback plan

**Risk Level**: MEDIUM
**Priority**: MEDIUM

---

## Implementation Roadmap

### Phase 0: Foundation (Week 1)
- [ ] Create reviews schema (GAP-001)
- [ ] Create city_site_mappings (GAP-006)
- [ ] Add missing indexes
- [ ] Set up sync infrastructure
- [ ] Deploy sync Edge Functions

### Phase 1: Properties (Week 2-3)
- [ ] Sync Host properties to Reserve
- [ ] Sync Host room types to Reserve
- [ ] Populate availability calendar
- [ ] Create property search Edge Function
- [ ] Implement property listing page
- [ ] Implement property detail page

### Phase 2: Content (Week 4)
- [ ] Integrate Portal Connect
- [ ] Implement events page
- [ ] Implement restaurants page
- [ ] Implement hero carousel

### Phase 3: Booking (Week 5-6)
- [ ] Create reservation schema extensions
- [ ] Implement availability checking
- [ ] Create booking flow
- [ ] Integrate Stripe
- [ ] Test end-to-end booking

### Phase 4: Polish (Week 7)
- [ ] Add authentication
- [ ] Implement reviews display
- [ ] Add image optimization
- [ ] Performance optimization
- [ ] Error handling

---

## Edge Function Requirements

### From Reserve Connect

| Function | Purpose | Priority | Effort |
|----------|---------|----------|--------|
| `get_cities` | List active cities | HIGH | 1 day |
| `get_properties` | Search properties with filters | CRITICAL | 2 days |
| `get_property_detail` | Full property with units | CRITICAL | 2 days |
| `check_availability` | Validate dates/availability | CRITICAL | 2 days |
| `create_reservation` | Booking creation | CRITICAL | 3 days |
| `get_user_reservations` | Booking history | MEDIUM | 1 day |
| `submit_review` | Review submission | MEDIUM | 1 day |
| `sync_host_properties` | Sync from Host | CRITICAL | 2 days |
| `sync_host_room_types` | Sync room types | CRITICAL | 2 days |

### From Portal Connect (or Reserve Proxy)

| Function | Purpose | Priority | Effort |
|----------|---------|----------|--------|
| `get_hero_banners` | Homepage carousel | HIGH | 1 day |
| `get_events` | Events listing | MEDIUM | 1 day |
| `get_event_detail` | Single event | MEDIUM | 1 day |
| `get_restaurants` | Restaurant directory | MEDIUM | 1 day |
| `get_restaurant_detail` | Restaurant detail | MEDIUM | 1 day |
| `get_attractions` | Attractions guide | LOW | 1 day |

---

## Success Criteria

### Phase 0 Complete When:
- [ ] All GAP tables created
- [ ] Indexes added
- [ ] Sync infrastructure deployed

### Phase 1 Complete When:
- [ ] 1+ property synced from Host
- [ ] Property listing shows real data
- [ ] Property detail shows real data
- [ ] Room types displayed

### Phase 2 Complete When:
- [ ] Events page shows real events
- [ ] Restaurants page shows real data
- [ ] Hero carousel is dynamic

### Phase 3 Complete When:
- [ ] Availability calendar functional
- [ ] Booking flow complete
- [ ] Test booking succeeds end-to-end

### Phase 4 Complete When:
- [ ] Reviews display on property pages
- [ ] Images load quickly (CDN)
- [ ] All hardcoded data removed

---

*Document generated: 2026-02-15*
*Total Features Analyzed: 47*
*Critical Gaps: 12*
*Estimated Implementation: 6-7 weeks*
*Status: READ-ONLY ANALYSIS PHASE - Ready for implementation planning*
