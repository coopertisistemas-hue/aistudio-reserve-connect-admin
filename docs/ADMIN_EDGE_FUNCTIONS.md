# Admin Edge Functions

## Functions
- `admin_list_properties`
- `admin_list_reservations`
- `admin_get_reservation`
- `admin_ops_summary`

## Security
These functions require:
- Valid Supabase Auth access token
- Admin check based on one of:
  - `app_metadata.role = "admin"`
  - `user_metadata.role = "admin"`
  - Email in `ADMIN_EMAIL_ALLOWLIST`

## Environment Variables
```
ADMIN_EMAIL_ALLOWLIST=admin@reserveconnect.com,ops@reserveconnect.com
```

## Deployment
```bash
supabase functions deploy admin_list_properties
supabase functions deploy admin_list_reservations
supabase functions deploy admin_get_reservation
supabase functions deploy admin_ops_summary
```
