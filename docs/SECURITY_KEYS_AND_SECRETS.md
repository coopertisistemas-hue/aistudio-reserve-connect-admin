# SECURITY KEYS AND SECRETS MANAGEMENT
## Reserve Connect - Key Management & Rotation Procedures

**Version:** 2.0  
**Effective Date:** 2026-02-16  
**Classification:** CONFIDENTIAL - RESTRICTED ACCESS  
**Owner:** Security Team + Infrastructure  

---

## OVERVIEW

This document defines the management, storage, rotation, and emergency procedures for all cryptographic keys and secrets used by the Reserve Connect platform.

### Key Categories

1. **Database Encryption Keys** (Supabase Vault)
2. **API Keys** (Stripe, MercadoPago, OpenPIX)
3. **Service Authentication** (Supabase service_role)
4. **JWT Secrets**
5. **Webhook Secrets**
6. **Hash Salts**

---

## KEY INVENTORY

### 1. Database Encryption Keys (Supabase Vault)

**Purpose:** Encrypt/decrypt PII in database  
**Storage:** Supabase Vault (pgsodium)  
**Access:** Database only, service_role  

| Key Name | Purpose | Algorithm | Created | Rotate By |
|----------|---------|-----------|---------|-----------|
| travelers_pii_key | Travelers PII encryption | AES-256-GCM | 2026-02-16 | 2026-05-16 |
| owners_pii_key | Property owners PII | AES-256-GCM | 2026-02-16 | 2026-05-16 |
| bank_details_key | Banking information | AES-256-GCM | 2026-02-16 | 2026-05-16 |
| payment_secrets_key | Payment gateway secrets | AES-256-GCM | 2026-02-16 | 2026-05-16 |

**Verification:**
```sql
-- List all Vault keys
SELECT id, name, key_type, created_at
FROM vault.keys
WHERE name LIKE '%_key';

-- Verify key status
SELECT name, 
       CASE WHEN id IS NOT NULL THEN 'ACTIVE' ELSE 'MISSING' END as status
FROM vault.keys;
```

### 2. API Keys (Third-Party Services)

#### Stripe
**Purpose:** Payment processing  
**Environment Variables:**
- `STRIPE_SECRET_KEY` - Live/production key (sk_live_*)
- `STRIPE_PUBLISHABLE_KEY` - Client-side key (pk_live_*)
- `STRIPE_WEBHOOK_SECRET` - Webhook verification (whsec_*)

**Storage:** Supabase Secrets (Edge Functions)  
**Access:** webhook_stripe, create_payment_intent_stripe Edge Functions  
**Rotation:** Every 6 months or on suspected compromise  

**Rotation Procedure:**
1. Generate new keys in Stripe Dashboard
2. Update Supabase Secrets
3. Test in staging
4. Deploy to production
5. Revoke old keys after 24 hours

```bash
# Update Supabase Secret
supabase secrets set STRIPE_SECRET_KEY=sk_live_newkey

# Verify
supabase secrets list | grep STRIPE
```

#### MercadoPago (PIX)
**Purpose:** PIX payment processing  
**Environment Variable:** `PIX_API_KEY`  
**Storage:** Supabase Secrets  
**Rotation:** Every 6 months  

#### OpenPIX (Alternative)
**Purpose:** PIX payment processing  
**Environment Variable:** `OPENPIX_API_KEY`  
**Storage:** Supabase Secrets  
**Rotation:** Every 6 months  

### 3. Supabase Service Authentication

#### Service Role Key
**Purpose:** Database administrative access  
**Environment Variable:** `SUPABASE_SERVICE_ROLE_KEY`  
**Storage:** Supabase Secrets + Edge Functions  
**Access:** All Edge Functions  
**Rotation:** Every 3 months or on team member departure  

**Rotation Procedure:**
1. Generate new key in Supabase Dashboard (Project Settings > API)
2. Update all Edge Functions simultaneously
3. Deploy all functions
4. Revoke old key immediately

⚠️ **CRITICAL:** This key has full database access. Never expose to client.

#### Anon Key
**Purpose:** Public database access (RLS-protected)  
**Environment Variable:** `SUPABASE_ANON_KEY`  
**Storage:** Client application + Edge Functions  
**Rotation:** Rarely (requires app update)  

### 4. JWT Secrets

**Purpose:** Sign/verify authentication tokens  
**Storage:** Supabase-managed (not directly accessible)  
**Access:** Automatic via Supabase Auth  
**Rotation:** Managed by Supabase, rotated every 3 months  

**Note:** Do not attempt to rotate manually. Supabase handles this.

### 5. Webhook Secrets

#### Stripe Webhook Secret
**Purpose:** Verify Stripe webhook authenticity  
**Environment Variable:** `STRIPE_WEBHOOK_SECRET`  
**Storage:** Supabase Secrets  
**Rotation:** Regenerate in Stripe Dashboard on suspected compromise  

#### PIX Webhook Secret (Future)
**Purpose:** Verify PIX provider webhooks  
**Environment Variable:** `PIX_WEBHOOK_SECRET`  
**Status:** Not yet implemented  

### 6. Hash Salts

**Purpose:** One-way hashing of PII for lookups  
**Salts Defined:**

| Salt | Usage | Location |
|------|-------|----------|
| `reserve_lookup_salt_2024` | Email/phone hashing for search | `reserve.hash_for_lookup()` function |
| `reserve_ip_salt_2024` | IP address hashing | `reserve.hash_ip_address()` function |

⚠️ **CRITICAL:** Never change salts after production use. Would break all lookups.

**Verification:**
```sql
-- Verify salts are set
SELECT 
  proname,
  prosrc LIKE '%reserve_lookup_salt_2024%' as has_lookup_salt,
  prosrc LIKE '%reserve_ip_salt_2024%' as has_ip_salt
FROM pg_proc
WHERE proname IN ('hash_for_lookup', 'hash_ip_address');
```

---

## KEY ROTATION PROCEDURES

### Pre-Rotation Checklist

- [ ] Schedule maintenance window (low traffic)
- [ ] Notify on-call engineer
- [ ] Prepare rollback plan
- [ ] Test new keys in staging
- [ ] Backup current key configuration

### Database Encryption Key Rotation

**Frequency:** Every 3 months  
**Impact:** Brief performance degradation during re-encryption  

**Procedure:**

1. **Create New Key**
```sql
SELECT vault.create_key(
  name := 'travelers_pii_key_v2',
  key_type := 'aead-det',
  comment := 'Rotation of travelers_pii_key - 2026-05-16'
);
```

2. **Dual-Key Operation (Grace Period)**
```sql
-- Update encryption function to try both keys
CREATE OR REPLACE FUNCTION reserve.decrypt_pii(encrypted TEXT, key_name TEXT)
RETURNS TEXT AS $$
BEGIN
  -- Try new key first
  RETURN vault.decrypt(encrypted::bytea, 
    (SELECT id FROM vault.keys WHERE name = key_name || '_v2'));
EXCEPTION
  WHEN OTHERS THEN
    -- Fall back to old key
    RETURN vault.decrypt(encrypted::bytea,
      (SELECT id FROM vault.keys WHERE name = key_name));
END;
$$;
```

3. **Re-encrypt Data** (Background job)
```sql
-- Update all encrypted fields to use new key
UPDATE reserve.travelers
SET email_encrypted = reserve.encrypt_pii(
  reserve.decrypt_pii(email_encrypted, 'travelers_pii_key'),
  'travelers_pii_key_v2'
)
WHERE email_encrypted IS NOT NULL;
```

4. **Remove Old Key** (After 30 days)
```sql
SELECT vault.delete_key(
  (SELECT id FROM vault.keys WHERE name = 'travelers_pii_key')
);
```

### API Key Rotation

#### Stripe Keys

**Live Key Rotation:**
1. Go to Stripe Dashboard > Developers > API Keys
2. Click "Create secret key" (restricted key recommended)
3. Set permissions:
   - Standard read permissions
   - Write: Charges, PaymentIntents, Refunds
4. Update Supabase Secret
5. Deploy Edge Functions
6. Test payment flow
7. Revoke old key after 24 hours

**Test Key Rotation:**
- Can rotate anytime (no production impact)
- Update in development environments

#### Supabase Service Role Key

**Rotation Procedure:**
1. Go to Supabase Dashboard > Project Settings > API
2. Click "Generate new service role key"
3. **CRITICAL:** Copy new key immediately (shown only once)
4. Update all Edge Functions:
   ```bash
   supabase secrets set SUPABASE_SERVICE_ROLE_KEY=newkey
   ```
5. Redeploy all functions:
   ```bash
   supabase functions deploy --all
   ```
6. Test critical functions
7. Revoke old key in Dashboard

⚠️ **DOWNTIME WARNING:** Brief downtime while deploying functions. Coordinate with team.

---

## SECRET STORAGE

### Supabase Secrets (Edge Functions)

**Access:**
```bash
# List all secrets
supabase secrets list

# Set secret
supabase secrets set KEY_NAME=value

# Unset secret
supabase secrets unset KEY_NAME
```

**Current Secrets Inventory:**
```
SUPABASE_URL
SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
STRIPE_SECRET_KEY
STRIPE_PUBLISHABLE_KEY
STRIPE_WEBHOOK_SECRET
PIX_API_KEY
PIX_PROVIDER
OPENPIX_API_KEY
```

### Environment-Specific Secrets

**Development:**
- Use Stripe test keys (sk_test_*, pk_test_*)
- Use MercadoPago sandbox
- Local Supabase instance

**Staging:**
- Use Stripe test keys
- Separate Supabase project
- Isolated from production

**Production:**
- Use Stripe live keys (sk_live_*, pk_live_*)
- Production Supabase project
- Restricted key permissions

---

## ACCESS CONTROL

### Who Has Access

| Secret | Engineering | DevOps | Security | Management |
|--------|-------------|--------|----------|------------|
| Database encryption keys | Read (via functions) | None | Full | None |
| Stripe live keys | None | Read/Write | Full | View only |
| Service role key | None | Full | Full | None |
| Webhook secrets | None | Read/Write | Full | None |

### Access Logging

All access to secrets is logged:
```
- Supabase Dashboard: Login + actions logged
- Supabase CLI: Commands logged to audit trail
- Database: All queries logged in audit_logs
```

**Suspicious Activity Alert:**
- Multiple failed login attempts
- Secret access outside business hours
- Bulk secret retrieval

---

## COMPROMISE RESPONSE

### Detection

**Signs of Compromise:**
- Unauthorized transactions
- Unexpected API calls
- Unusual data access patterns
- Alert from security monitoring

### Immediate Response (First 15 Minutes)

1. **Confirm Compromise**
   - Review logs
   - Verify with team members
   - Determine scope

2. **Containment**
   ```bash
   # Revoke compromised keys immediately
   # Stripe: Dashboard > Developers > API Keys > Revoke
   # Supabase: Dashboard > Settings > API > Revoke
   ```

3. **Notification**
   - Security team
   - Engineering lead
   - CTO
   - Legal (if customer data affected)

### Recovery (Next Hour)

1. **Generate New Keys**
   - Follow rotation procedures above
   - Use emergency rotation (faster)

2. **Deploy New Keys**
   ```bash
   supabase secrets set KEY_NAME=new_value
   supabase functions deploy --all
   ```

3. **Verify System**
   - Test payment flow
   - Test booking flow
   - Check webhook processing
   - Run health check

### Investigation (Within 24 Hours)

1. **Audit Trail Review**
```sql
-- Check recent secret access
SELECT * FROM reserve.audit_logs
WHERE table_name IN ('vault.keys', 'secrets')
AND created_at > NOW() - INTERVAL '24 hours'
ORDER BY created_at DESC;
```

2. **Impact Assessment**
- Which data was accessed?
- Which systems were affected?
- Customer impact?

3. **Forensic Analysis**
- Preserve logs
- Capture system state
- Identify attack vector

### Post-Incident

1. **Customer Notification** (if required by law)
2. **Security Improvements**
3. **Key Rotation Schedule Review**
4. **Team Training**

---

## BACKUP AND RECOVERY

### Database Encryption Keys

**Backup:** Keys are automatically backed up by Supabase Vault  
**Recovery:** Contact Supabase support for key recovery  
**Note:** Cannot export keys (security feature)

### API Keys

**Backup Procedure:**
```bash
# Export current secrets
supabase secrets list > secrets_backup_$(date +%Y%m%d).txt

# Encrypt backup
gpg --encrypt --recipient security@company.com secrets_backup_*.txt

# Store in secure location
# (Password manager or encrypted S3)
```

**Recovery:**
- Retrieve from password manager
- Or regenerate new keys (preferred)

---

## COMPLIANCE

### PCI DSS Requirements

| Requirement | Implementation |
|-------------|----------------|
| 3.6 | Cryptographic keys stored securely | Supabase Vault |
| 3.6.1 | Key generation | Supabase-managed |
| 3.6.2 | Key distribution | Secure channels only |
| 3.6.3 | Key storage | Encrypted at rest |
| 3.6.4 | Cryptographic key changes | 90-day rotation |
| 3.6.5 | Key retirement | Automatic archival |
| 3.6.6 | Manual key-management | DBA procedures documented |
| 3.6.7 | Key custodians | Security team only |

### Audit Trail

All key operations logged:
- Creation
- Rotation
- Access (read/write)
- Deletion

**Log Retention:** 2 years  
**Log Location:** `reserve.audit_logs` + Supabase audit trail

---

## CHECKLISTS

### Monthly Security Review

- [ ] Review key rotation schedule
- [ ] Check for unused/expired keys
- [ ] Review access logs
- [ ] Verify backup procedures
- [ ] Update key inventory

### Quarterly Rotation

- [ ] Database encryption keys (staggered)
- [ ] Stripe API keys
- [ ] PIX API keys
- [ ] Service role key (if due)
- [ ] Update rotation schedule

### Annual Security Audit

- [ ] Full key inventory
- [ ] Access review (remove former employees)
- [ ] Key strength assessment
- [ ] Rotation procedure test
- [ ] Compromise response drill

---

## EMERGENCY CONTACTS

| Role | Name | Phone | Escalation |
|------|------|-------|------------|
| Security On-Call | [Name] | [PagerDuty] | Immediate |
| Engineering Lead | [Name] | [Phone] | 15 min |
| CTO | [Name] | [Phone] | 30 min |
| Supabase Support | - | support@supabase.com | For key recovery |
| Stripe Support | - | support.stripe.com | For API issues |

---

## REVISION HISTORY

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-08-01 | Security Team | Initial key management |
| 2.0 | 2026-02-16 | Security Team | Added Vault encryption, rotation procedures |

---

## APPROVALS

| Role | Name | Signature | Date |
|------|------|-----------|------|
| CISO | [Name] | [Signature] | 2026-02-16 |
| CTO | [Name] | [Signature] | 2026-02-16 |
| Engineering Lead | [Name] | [Signature] | 2026-02-16 |

---

**END OF SECURITY KEYS AND SECRETS MANAGEMENT**

*This document is classified CONFIDENTIAL. Distribution restricted.*  
*Next review: 2026-05-16 (quarterly)*

**Document ID:** RC-SECRETS-2026-02-16  
**Classification:** CONFIDENTIAL - RESTRICTED
