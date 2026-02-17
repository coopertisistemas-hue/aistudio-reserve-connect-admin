# DATA RETENTION POLICY
## Reserve Connect - LGPD/GDPR Compliance

**Version:** 2.0  
**Effective Date:** 2026-02-16  
**Review Date:** 2026-08-16 (Bi-annual)  
**Owner:** Data Protection Officer + Engineering  
**Classification:** CONFIDENTIAL

---

## PURPOSE

This document defines data retention and deletion policies for the Reserve Connect platform to ensure compliance with:
- **LGPD** (Lei Geral de Proteção de Dados) - Brazil
- **GDPR** (General Data Protection Regulation) - EU
- **PCI DSS** - Payment Card Industry standards
- **Accounting regulations** - Financial record retention

---

## DATA CLASSIFICATION

### 1. HIGH SENSITIVITY (PII)
**Definition:** Personally identifiable information that can identify an individual

| Data Type | Examples | Retention | Action |
|-----------|----------|-----------|---------|
| Email Address | customer@email.com | 2 years post-account closure | Anonymize |
| Phone Number | +55 11 99999-9999 | 2 years post-account closure | Anonymize |
| Document Number | CPF/CNPJ | 5 years (legal requirement) | Encrypt + Restrict Access |
| Bank Details | Account numbers, IBAN | Duration of relationship + 2 years | Encrypt + Delete |
| IP Address | 192.168.1.1 | 90 days | Hash then delete |
| Session Data | session_id, cookies | 30 days | Delete |

### 2. MEDIUM SENSITIVITY (Financial)
**Definition:** Transaction and financial data required for accounting

| Data Type | Examples | Retention | Action |
|-----------|----------|-----------|---------|
| Payment Records | Transaction IDs, amounts | 10 years (accounting) | Archive after 2 years |
| Booking History | Reservations, dates | 7 years | Anonymize PII after 2 years |
| Ledger Entries | Debits, credits | 10 years | Keep indefinitely |
| Invoice Data | Billing records | 10 years | Archive after 5 years |

### 3. LOW SENSITIVITY (Operational)
**Definition:** System logs and analytics data

| Data Type | Examples | Retention | Action |
|-----------|----------|-----------|---------|
| Audit Logs | Change history | 1 year active, 5 years archive | Archive then delete |
| Event Logs | System events | 90 days | Delete |
| Funnel Analytics | Conversion tracking | 90 days | Aggregate then delete |
| Error Logs | Stack traces | 30 days | Delete |
| Performance Metrics | Response times | 1 year | Aggregate then delete |

---

## RETENTION POLICIES BY TABLE

### Core Tables

#### 1. reserve.travelers (Customers)
**Purpose:** Customer account information  
**Legal Basis:** Contract execution + Legal obligation  

**Retention Schedule:**
- **Active Account:** Indefinite (while account active)
- **Closed Account:** 2 years after closure
- **Deletion Action:** Anonymization (keep ID for accounting)

**Anonymization Process:**
```sql
-- After 2 years of account closure
SELECT reserve.anonymize_traveler('traveler-uuid');

-- Result:
-- email → '[REDACTED-xxxxx]'
-- phone → '[REDACTED]'
-- document_number → '[REDACTED]'
-- name → '[REDACTED]'
-- But: Keep ID for ledger entries
```

**Exceptions:**
- Active disputes: Retain until resolution + 1 year
- Legal proceedings: Retain until case closed + 5 years
- Fraud investigation: Retain indefinitely (with DPO approval)

#### 2. reserve.reservations (Bookings)
**Purpose:** Booking records for operations  
**Legal Basis:** Contract execution + Accounting  

**Retention Schedule:**
- **Completed Bookings:** 7 years after checkout
- **Cancelled Bookings:** 2 years after cancellation
- **PII Anonymization:** 2 years after checkout/cancellation

**Data Transformation:**
```sql
-- After 2 years:
-- Anonymize: guest_email, guest_phone, guest_name
-- Keep: booking dates, amounts, property_id (for analytics)
```

#### 3. reserve.payments (Transactions)
**Purpose:** Payment processing and reconciliation  
**Legal Basis:** Financial regulations + PCI DSS  

**Retention Schedule:**
- **Active:** Indefinite (while payment valid)
- **Post-Refund:** 10 years (accounting requirement)
- **PII Removal:** Immediate (never store card numbers)

**Sensitive Data Handling:**
- ✅ Store: gateway_payment_id, amount, status
- ❌ Never Store: Full card numbers, CVV, stripe_client_secret (deprecated)
- ✅ Encrypt: Any payment metadata containing PII

#### 4. reserve.audit_logs (Change History)
**Purpose:** Compliance and security audit trail  
**Legal Basis:** Legal obligation (LGPD Art. 46)  

**Retention Schedule:**
- **Active:** 1 year (fast query performance)
- **Archive:** 5 years total (compressed storage)
- **PII Handling:** Already redacted at time of logging

**Implementation:**
```sql
-- Daily cleanup job moves old records to archive
SELECT * FROM reserve.run_retention_cleanup();

-- Archive table structure
reserve.audit_logs_archive (
  LIKE reserve.audit_logs,
  archived_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 5. reserve.events (System Events)
**Purpose:** Analytics and monitoring  
**Legal Basis:** Legitimate interest (analytics)  

**Retention Schedule:**
- **Raw Events:** 90 days
- **Aggregated Metrics:** 1 year
- **PII:** IP addresses hashed, no email/phone stored

**Cleanup Process:**
```sql
-- Deletes events older than 90 days
DELETE FROM reserve.events 
WHERE created_at < NOW() - INTERVAL '90 days';
```

#### 6. reserve.booking_intents (Shopping Cart)
**Purpose:** Temporary booking holds  
**Legal Basis:** Contract execution  

**Retention Schedule:**
- **Converted:** 30 days (then anonymize PII)
- **Expired:** 7 days (then delete)
- **Abandoned:** 7 days (then delete)

**Implementation:**
```sql
-- Anonymize after 30 days
UPDATE reserve.booking_intents
SET guest_email = '[REDACTED]',
    guest_phone = '[REDACTED]',
    session_id = '[REDACTED]'
WHERE created_at < NOW() - INTERVAL '30 days';

-- Delete expired after 7 days
DELETE FROM reserve.booking_intents
WHERE status = 'expired'
AND created_at < NOW() - INTERVAL '7 days';
```

#### 7. reserve.booking_locks (Concurrency Control)
**Purpose:** Prevent double-booking  
**Legal Basis:** System functionality  

**Retention Schedule:**
- **Active:** Until expires_at
- **Expired:** Immediate deletion (cleanup job runs every 5 min)

**No PII stored in this table**

---

## RIGHT TO ERASURE (GDPR Art. 17 / LGPD Art. 18)

### Process Overview

**1. Request Received**
- Customer emails privacy@company.com
- Verify identity via email + document
- Create erasure request ticket

**2. Legal Review** (48 hours)
- Check for active disputes
- Check for legal proceedings
- Determine if erasure can proceed

**3. Technical Execution** (7 days)
```sql
-- Step 1: Create erasure request record
INSERT INTO reserve.data_erasure_requests (
  entity_type,
  entity_id,
  email_hash,
  request_reason,
  status
) VALUES (
  'traveler',
  'traveler-uuid',
  'hash-of-email',
  'Customer request',
  'processing'
);

-- Step 2: Anonymize traveler data
SELECT reserve.anonymize_traveler('traveler-uuid');

-- Step 3: Anonymize associated reservations
UPDATE reserve.reservations
SET guest_email = '[REDACTED]',
    guest_phone = '[REDACTED]',
    guest_first_name = '[REDACTED]',
    guest_last_name = '[REDACTED]'
WHERE traveler_id = 'traveler-uuid';

-- Step 4: Mark as completed
UPDATE reserve.data_erasure_requests
SET status = 'completed',
    processed_at = NOW()
WHERE entity_id = 'traveler-uuid';
```

**4. Exceptions (Data Retained)**
Per LGPD Art. 16, we retain:
- ✅ Ledger entries (accounting requirement)
- ✅ Payment records (financial regulations)
- ✅ Anonymized booking statistics (aggregated, no PII)

**5. Confirmation** (Within 30 days)
- Email customer confirming erasure
- Provide anonymized reference ID for any follow-up

### Erasure Request Tracking

| ID | Entity | Requested | Completed | Status | Retention Justification |
|----|--------|-----------|-----------|--------|------------------------|
| ER-001 | traveler-uuid | 2026-02-01 | 2026-02-03 | completed | N/A |
| ER-002 | traveler-abc | 2026-02-10 | - | pending | Active dispute |

---

## AUTOMATED CLEANUP PROCEDURES

### Daily Cleanup Jobs

#### 1. Expired Booking Locks
**Schedule:** Every 5 minutes  
**Function:** `reserve.cleanup_expired_locks()`

```sql
DELETE FROM reserve.booking_locks
WHERE expires_at < NOW();
```

#### 2. Data Retention Enforcement
**Schedule:** Daily at 2:00 AM  
**Function:** `reserve.run_retention_cleanup()`

**Process:**
1. Archive audit_logs older than 365 days
2. Delete events older than 90 days
3. Anonymize booking_intents older than 30 days
4. Delete expired intents older than 7 days
5. Delete notification_outbox sent/failed older than 30 days

#### 3. System Health Check
**Schedule:** Daily at 3:00 AM  
**Function:** `reserve.system_health_check()`

**Alerts Generated:**
- Ledger imbalances
- Overbooking detected
- Stuck payments > 1 hour
- Failed webhooks > 5

### Weekly Cleanup

#### 1. IP Address Purging
**Schedule:** Weekly  
**Action:** Delete raw IP addresses after 90 days (keep hash)

```sql
-- Remove raw IP after 90 days
UPDATE reserve.audit_logs
SET ip_address = NULL
WHERE created_at < NOW() - INTERVAL '90 days'
AND ip_hash IS NOT NULL;
```

#### 2. Orphaned Data Cleanup
**Schedule:** Weekly  
**Action:** Remove records with broken foreign keys

### Monthly Cleanup

#### 1. Archive Compression
**Schedule:** Monthly  
**Action:** Compress audit_logs_archive older than 6 months

#### 2. Key Rotation Review
**Schedule:** Monthly  
**Action:** Review encryption key age, rotate if > 90 days

---

## IMPLEMENTATION DETAILS

### Database Configuration

**Migration:** `013_audit_log_redaction_retention.sql`

**Tables:**
- `reserve.retention_policies` - Configuration
- `reserve.data_erasure_requests` - Erasure tracking
- `reserve.audit_logs_archive` - Archived audit data
- `reserve.maintenance_task_log` - Cleanup job tracking

**Functions:**
- `reserve.run_retention_cleanup()` - Main cleanup routine
- `reserve.cleanup_old_events()` - Legacy cleanup
- `reserve.anonymize_traveler()` - GDPR erasure
- `reserve.system_health_check()` - Monitoring

### Monitoring

**Views for Compliance Team:**
```sql
-- Check retention statistics
SELECT * FROM reserve.retention_statistics;

-- Check pending erasure requests
SELECT * FROM reserve.data_erasure_requests
WHERE status IN ('pending', 'processing');

-- Verify anonymization worked
SELECT email, phone, document_number
FROM reserve.travelers
WHERE id = 'anonymized-traveler-uuid';
-- Expected: [REDACTED], [REDACTED], [REDACTED]
```

**Alerts:**
- Erasure request pending > 7 days
- Retention cleanup failed
- Audit log growth > 5GB/month

---

## COMPLIANCE CHECKLIST

### LGPD Requirements

| Article | Requirement | Implementation | Status |
|---------|-------------|----------------|--------|
| Art. 7 | Purpose limitation | Data collected only for booking/payment | ✅ |
| Art. 8 | Consent | Obtained at registration | ✅ |
| Art. 16 | Data retention | Policies defined above | ✅ |
| Art. 18 | Right to deletion | `anonymize_traveler()` function | ✅ |
| Art. 46 | Security measures | Encryption + audit logs | ✅ |

### GDPR Requirements

| Article | Requirement | Implementation | Status |
|---------|-------------|----------------|--------|
| Art. 5(1)(e) | Storage limitation | Retention policies enforced | ✅ |
| Art. 17 | Right to erasure | Automated erasure process | ✅ |
| Art. 25 | Privacy by design | Encryption at rest | ✅ |
| Art. 30 | Records of processing | Audit logs | ✅ |
| Art. 32 | Security | Encryption + access control | ✅ |

### PCI DSS Requirements

| Requirement | Implementation | Status |
|-------------|----------------|--------|
| 3.1 | Keep cardholder data to minimum | Only store gateway_payment_id | ✅ |
| 3.4 | Render PAN unreadable | Never store full card numbers | ✅ |
| 10.5 | Secure audit trails | Audit logs encrypted + access controlled | ✅ |

---

## AUDIT AND REPORTING

### Quarterly Compliance Report

**Generated By:** DPO  
**Recipients:** Executive team, Legal  

**Contents:**
1. Total PII records by type
2. Erasure requests processed
3. Exceptions granted (legal holds)
4. Data breach incidents (if any)
5. Retention policy violations
6. Encryption key rotation status

### Annual Data Protection Impact Assessment (DPIA)

**Required For:**
- High-volume processing of sensitive data
- Systematic monitoring
- Large-scale processing

**Contents:**
1. Data flows and processing activities
2. Risk assessment
3. Mitigation measures
4. Residual risk acceptance

---

## EXCEPTIONS AND APPROVALS

### Retention Extension

**Process:**
1. Legal/Compliance submits request
2. DPO reviews justification
3. CTO approves technical implementation
4. Extension logged with reason

**Justifications Accepted:**
- Active legal proceedings
- Fraud investigation
- Regulatory audit
- Contractual obligation

### Early Deletion

**Process:**
1. Customer requests early deletion
2. Verify no legal holds
3. Process erasure within 7 days
4. Confirm completion

---

## TRAINING AND AWARENESS

### Engineering Team
- Annual data protection training
- Secure coding practices
- Incident response procedures

### Customer Support
- Handling erasure requests
- Identity verification procedures
- Escalation paths

### Management
- Legal obligations overview
- Incident reporting requirements
- Vendor management

---

## REVISION HISTORY

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-08-01 | DPO | Initial policy |
| 2.0 | 2026-02-16 | Security Team | Added encryption, automated cleanup, LGPD alignment |

---

## APPROVALS

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Data Protection Officer | [Name] | [Signature] | 2026-02-16 |
| CTO | [Name] | [Signature] | 2026-02-16 |
| Legal Counsel | [Name] | [Signature] | 2026-02-16 |

---

**END OF DATA RETENTION POLICY**

*This document is reviewed bi-annually. Next review: 2026-08-16*

**Policy ID:** RC-DATA-RETENTION-2026-02-16  
**Classification:** CONFIDENTIAL  
**Distribution:** Engineering, Legal, Compliance, Executive Team
