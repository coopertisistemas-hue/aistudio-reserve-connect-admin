# Ops Dashboard Guide

## Overview
The ops dashboard is built from database views and health checks. It provides a single-row summary plus alerts for operators.

## Primary Queries
```sql
-- Single pane of glass
SELECT * FROM reserve.ops_dashboard_summary;

-- Active alerts
SELECT * FROM reserve.ops_dashboard_alerts;

-- Full health checklist
SELECT * FROM reserve.system_health_check();
```

## Recommended Usage
1. Run `reserve.ops_dashboard_summary` every 5-15 minutes.
2. Review `reserve.ops_dashboard_alerts` for actionable items.
3. Use `reserve.system_health_check()` before and after deployments.

## Evidence Queries
Each alert includes an `evidence_query` column with a SQL statement to run for details.

## Scheduling
Use Supabase Scheduled Functions or an external cron to call the reconciliation placeholder and to run health checks:

```bash
curl -X POST https://<project>.supabase.co/functions/v1/reconciliation_job_placeholder \
  -H "Authorization: Bearer <service_role>" \
  -H "apikey: <service_role>" \
  -d '{"run_id":"recon_daily_001"}'
```

## Safety Notes
- Health checks are read-only.
- Retention helpers default to dry-run and must be executed with service_role credentials.
