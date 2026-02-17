# Frontend QA Checklist

## Public Flow
- [ ] Landing page loads and language switcher works
- [ ] Search availability returns URB results
- [ ] Property detail loads with amenities and room cards
- [ ] Booking flow creates intent and starts payment (Stripe or PIX)
- [ ] Payment polling shows pending/succeeded states

## Admin Flow
- [ ] Login with Supabase Auth works
- [ ] Admin routes redirect unauthenticated users
- [ ] Dashboard shows health check data
- [ ] Reservations list loads and cancel action triggers
- [ ] Ops reconciliation trigger works

## i18n
- [ ] PT default
- [ ] EN and ES translations applied across public/admin

## Security
- [ ] No direct DB queries in frontend
- [ ] Authorization header sent on admin calls
