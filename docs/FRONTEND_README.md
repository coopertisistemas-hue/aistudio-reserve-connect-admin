# Frontend MVP (apps/web)

## Setup
```bash
cd apps/web
npm install
npm run dev
```

## Environment
Create `apps/web/.env` using:

```
VITE_SUPABASE_URL=
VITE_SUPABASE_ANON_KEY=
VITE_FUNCTIONS_BASE_URL=https://<project>.supabase.co/functions/v1
VITE_DEFAULT_CITY_CODE=URB
```

## Routes
- `/` Landing page
- `/search` Search results
- `/p/:slug` Property detail
- `/book/:slug` Booking flow
- `/login` Admin login
- `/admin` Admin dashboard
- `/admin/properties`
- `/admin/reservations`
- `/admin/ops`

## Running
```bash
npm run dev
```
