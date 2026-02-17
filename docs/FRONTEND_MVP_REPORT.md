# Frontend MVP Report

## Routes
- `/` Landing page
- `/search` Search availability
- `/p/:slug` Property detail
- `/book/:slug` Booking flow
- `/login` Admin login
- `/admin` Admin dashboard
- `/admin/properties`
- `/admin/reservations`
- `/admin/ops`

## Edge Functions Used
Public:
- `search_availability`
- `get_property_detail`
- `create_booking_intent`
- `create_payment_intent_stripe`
- `create_pix_charge`
- `poll_payment_status`

Admin:
- `admin_list_properties`
- `admin_list_reservations`
- `admin_ops_summary`
- `reconciliation_job_placeholder`
- `cancel_reservation`

## Security Notes
- No direct table access from client.
- Admin endpoints require authenticated Supabase user and admin check server-side.
- Service role never exposed in client.

## Known Limitations
- Stripe checkout UI not embedded; payment status is polled and confirmed asynchronously.
- Admin details view is minimal; dedicated details page pending.

## Next Steps
1. Add Stripe checkout UI flow
2. Add admin reservation detail page
3. Add monitoring cards (ops dashboard summary)
