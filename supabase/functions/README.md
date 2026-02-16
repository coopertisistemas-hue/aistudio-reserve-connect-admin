# RESERVE CONNECT - EDGE FUNCTIONS

## Overview

Backend-for-Frontend (BFF) Edge Functions for Reserve Connect booking platform.

## Functions Created

### 1. search_availability ✅
**Purpose**: Search available properties by dates and guests
**Auth**: Public (rate limited)
**Input**: city_code, check_in, check_out, guests, filters, pagination
**Output**: List of available properties with pricing
**File**: `search_availability/index.ts`

### 2. get_property_detail ✅
**Purpose**: Get full property details with availability
**Auth**: Public
**Input**: slug, optional check_in/check_out
**Output**: Property details, room types, availability, reviews
**File**: `get_property_detail/index.ts`

### 3. create_booking_intent ✅
**Purpose**: Create TTL-based booking hold
**Auth**: Public (session-based)
**Input**: session_id, city_code, property_slug, unit_id, dates, guests
**Output**: intent_id, expires_at, pricing breakdown
**Features**: Idempotency, soft holds, capacity validation
**File**: `create_booking_intent/index.ts`

### 4. create_payment_intent_stripe ✅
**Purpose**: Create Stripe Payment Intent
**Auth**: Public
**Input**: intent_id, payment_method_types
**Output**: client_secret, payment_intent_id
**Features**: Idempotency, metadata tracking
**File**: `create_payment_intent_stripe/index.ts`

### 5. create_pix_charge ✅
**Purpose**: Generate PIX QR code
**Auth**: Public
**Input**: intent_id, expires_in_minutes
**Output**: pix_id, qr_code_base64, copy_paste_key
**Features**: IOF 0.38% calculation, MercadoPago/OpenPIX support
**File**: `create_pix_charge/index.ts`

### 6. poll_payment_status ✅
**Purpose**: Check payment status (polling for PIX)
**Auth**: Public
**Input**: intent_id or payment_id
**Output**: current status, next_action
**File**: `poll_payment_status/index.ts`

### 7. webhook_stripe ✅
**Purpose**: Handle Stripe webhooks
**Auth**: Webhook signature verification
**Events**: payment_intent.succeeded, payment_intent.payment_failed, charge.refunded, charge.dispute.created
**Output**: 200 OK or error
**Features**: Automatic ledger entries, reservation creation trigger
**File**: `webhook_stripe/index.ts`

### 8. finalize_reservation_after_payment ✅
**Purpose**: Convert intent to reservation after payment
**Auth**: System (internal)
**Input**: payment_id or gateway_payment_id
**Output**: reservation_id, commission breakdown

### 9. host_commit_booking ✅
**Purpose**: Commit reservation to Host Connect
**Auth**: System
**Input**: reservation_id
**Output**: host_booking_id, status

### 10. cancel_reservation ✅
**Purpose**: Cancel reservation with refund handling
**Auth**: Authenticated (owner) or System
**Input**: reservation_id, reason
**Output**: refund_amount, status

### 11. host_webhook_receiver ✅
**Purpose**: Receive Host Connect webhooks
**Auth**: Webhook signature
**Events**: booking.created, booking.updated, booking.cancelled

### 12. reconciliation_job_placeholder ✅
**Purpose**: Reconciliation run placeholder
**Auth**: System
**Input**: run_id, dry_run
**Output**: summary report

## Functions to Create (Next)

### 13. emit_event
**Purpose**: Track analytics events
**Auth**: Public/System
**Input**: event_name, metadata
**Output**: success boolean

### 14. get_cities_list
**Purpose**: List active cities
**Auth**: Public
**Output**: cities array

### 15-22. [Additional functions for Portal integration, ADS, etc.]

## Configuration

### Environment Variables
See `.env.example` for all required variables.

Key variables:
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`
- `STRIPE_SECRET_KEY`
- `STRIPE_WEBHOOK_SECRET`
- `PIX_PROVIDER` (mercadopago/openpix)
- `PIX_API_KEY`

### Import Map
The `import_map.json` defines shared dependencies:
- Deno standard library
- Supabase client
- Stripe SDK

## Deployment

### Deploy All Functions
```bash
supabase functions deploy search_availability
supabase functions deploy get_property_detail
supabase functions deploy create_booking_intent
supabase functions deploy create_payment_intent_stripe
supabase functions deploy create_pix_charge
supabase functions deploy poll_payment_status
supabase functions deploy webhook_stripe
supabase functions deploy finalize_reservation_after_payment
supabase functions deploy host_commit_booking
supabase functions deploy cancel_reservation
supabase functions deploy host_webhook_receiver
supabase functions deploy reconciliation_job_placeholder
```

### Deploy Single Function
```bash
supabase functions deploy search_availability
```

### Test Locally
```bash
# Start Supabase locally
supabase start

# Serve specific function
supabase functions serve search_availability

# In another terminal, test:
curl -X POST http://localhost:54321/functions/v1/search_availability \
  -H "Content-Type: application/json" \
  -d '{"city_code":"URB","check_in":"2026-03-01","check_out":"2026-03-05","guests_adults":2}'
```

## API Usage Examples

### Search Properties
```bash
curl -X POST https://ffahkiukektmhkrkordn.supabase.co/functions/v1/search_availability \
  -H "Content-Type: application/json" \
  -d '{
    "city_code": "URB",
    "check_in": "2026-03-01",
    "check_out": "2026-03-05",
    "guests_adults": 2,
    "guests_children": 0,
    "filters": {
      "property_types": ["pousada"],
      "max_price": 500
    }
  }'
```

### Create Booking Intent
```bash
curl -X POST https://ffahkiukektmhkrkordn.supabase.co/functions/v1/create_booking_intent \
  -H "Content-Type: application/json" \
  -H "X-Session-ID: sess_abc123" \
  -d '{
    "session_id": "sess_abc123",
    "city_code": "URB",
    "property_slug": "pousada-montanha-urb",
    "unit_id": "uuid-unit",
    "check_in": "2026-03-01",
    "check_out": "2026-03-05",
    "guests_adults": 2
  }'
```

### Create Stripe Payment
```bash
curl -X POST https://ffahkiukektmhkrkordn.supabase.co/functions/v1/create_payment_intent_stripe \
  -H "Content-Type: application/json" \
  -H "X-Idempotency-Key: unique-key-123" \
  -d '{
    "intent_id": "uuid-intent",
    "payment_method_types": ["card"]
  }'
```

### Create PIX Charge
```bash
curl -X POST https://ffahkiukektmhkrkordn.supabase.co/functions/v1/create_pix_charge \
  -H "Content-Type: application/json" \
  -d '{
    "intent_id": "uuid-intent",
    "expires_in_minutes": 15
  }'
```

## Error Codes

| Code | Description | HTTP Status |
|------|-------------|-------------|
| RESERVE_001 | Validation error | 400 |
| RESERVE_002 | Not found | 404 |
| RESERVE_003 | Unauthorized | 401 |
| RESERVE_004 | Payment failed | 402 |
| RESERVE_005 | Host timeout | 504 |
| RESERVE_006 | Host rejected | 400 |
| RESERVE_007 | Idempotency conflict | 409 |
| RESERVE_008 | Rate limited | 429 |
| RESERVE_009 | Circuit breaker open | 503 |
| RESERVE_010 | Internal error | 500 |

## Security

- All functions use CORS headers
- Service role key for database operations
- Idempotency keys for mutations
- RLS policies protect data
- Webhook signature verification

## Testing

### Unit Tests
```bash
# TODO: Add Deno test suite
deno test --allow-all functions/search_availability/test.ts
```

### Integration Tests
```bash
# Test full booking flow
./scripts/test_booking_flow.sh
```

## Monitoring

All functions log to Supabase Logs:
- Dashboard → Logs → Edge Functions
- Filter by function name
- Check for errors and performance

## Next Steps

1. ✅ Create core functions (12 created)
2. ✅ Create finalization, host commit, cancellation, and webhook handlers
3. ✅ Add reconciliation placeholder
4. ⏳ Add comprehensive error handling
5. ⏳ Add rate limiting middleware
6. ⏳ Create integration tests
7. ⏳ Deploy to production

## Architecture

```
Site App → Edge Functions → Supabase DB
                ↓
           Stripe API (payments)
                ↓
           MercadoPago/OpenPIX (PIX)
                ↓
           Host Connect API (sync)
```

## Status

**Current**: 12/22 functions created
**Next**: emit_event, get_cities_list

## Support

For issues:
1. Check Edge Function logs
2. Verify environment variables
3. Test with curl
4. Review error codes
