# CONFIGURAÇÃO SUPABASE VAULT - PII ENCRYPTION

## Status: ⏳ PENDENTE DE CONFIGURAÇÃO MANUAL

---

## ⚠️ IMPORTANTE

A criptografia de PII requer configuração manual no Dashboard do Supabase, pois envolve:
1. Habilitar extensão `pgsodium` (requer superusuário)
2. Configurar Vault com chaves de criptografia
3. Migrar dados existentes (se houver)

---

## 📋 PASSO A PASSO

### 1. Habilitar Extensão pgsodium

**Ação:** Acesse o SQL Editor do Supabase e execute:

```sql
-- Habilitar extensão de criptografia
CREATE EXTENSION IF NOT EXISTS pgsodium;

-- Verificar se foi criada
SELECT * FROM pg_extension WHERE extname = 'pgsodium';
```

**Status:** ⬜ Pendente

---

### 2. Criar Colunas Criptografadas

**Ação:** Execute no SQL Editor:

```sql
-- Adicionar colunas criptografadas (exemplo para travelers)
ALTER TABLE reserve.travelers 
ADD COLUMN email_encrypted TEXT,
ADD COLUMN phone_encrypted TEXT,
ADD COLUMN document_number_encrypted TEXT;

-- Adicionar colunas criptografadas para property_owners
ALTER TABLE reserve.property_owners 
ADD COLUMN email_encrypted TEXT,
ADD COLUMN phone_encrypted TEXT,
ADD COLUMN document_number_encrypted TEXT,
ADD COLUMN bank_details_encrypted TEXT;

-- Adicionar colunas para payments
ALTER TABLE reserve.payments 
ADD COLUMN stripe_client_secret_encrypted TEXT;
```

**Status:** ⬜ Pendente

---

### 3. Configurar Funções de Criptografia

**Ação:** Execute no SQL Editor:

```sql
-- Função para criptografar dados
CREATE OR REPLACE FUNCTION reserve.encrypt_pii(data TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN encode(
        pgsodium.crypto_secretbox_seal(
            convert_to(data, 'utf8'),
            (select key_id from pgsodium.valid_key where name = 'reserve_pii_key' limit 1)
        ),
        'base64'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Função para descriptografar (apenas para service_role)
CREATE OR REPLACE FUNCTION reserve.decrypt_pii(encrypted_data TEXT)
RETURNS TEXT AS $$
BEGIN
    -- Verificar se é service_role
    IF current_user != 'service_role' THEN
        RAISE EXCEPTION 'Unauthorized';
    END IF;
    
    RETURN convert_from(
        pgsodium.crypto_secretbox_seal_open(
            decode(encrypted_data, 'base64'),
            (select key_id from pgsodium.valid_key where name = 'reserve_pii_key' limit 1)
        ),
        'utf8'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

**Status:** ⬜ Pendente

---

### 4. Migrar Dados Existentes (se houver)

**Ação:** Se já existirem dados em produção:

```sql
-- Criar chave de criptografia primeiro (ver passo 5)

-- Migrar travelers
UPDATE reserve.travelers 
SET email_encrypted = reserve.encrypt_pii(email),
    phone_encrypted = reserve.encrypt_pii(phone),
    document_number_encrypted = reserve.encrypt_pii(document_number)
WHERE email_encrypted IS NULL;

-- Repetir para outras tabelas...

-- Depois de migrar, dropar colunas antigas (opcional)
-- ALTER TABLE reserve.travelers DROP COLUMN email;
-- ALTER TABLE reserve.travelers RENAME COLUMN email_encrypted TO email;
```

**Status:** ⬜ Pendente (não aplicável se não houver dados)

---

### 5. Criar Chave de Criptografia

**Ação:** No SQL Editor:

```sql
-- Criar chave para PII
SELECT pgsodium.create_key('reserve_pii_key', 'reserve');

-- Verificar chave criada
SELECT * FROM pgsodium.valid_key WHERE name = 'reserve_pii_key';
```

**Status:** ⬜ Pendente

---

## 🔒 COLUNAS QUE PRECISAM DE CRIPTOGRAFIA

### Tabela: travelers
- [ ] email
- [ ] phone
- [ ] document_number
- [ ] address_line_1
- [ ] address_line_2

### Tabela: property_owners
- [ ] email
- [ ] phone
- [ ] document_number
- [ ] bank_details (JSONB completo)

### Tabela: reservations
- [ ] guest_email
- [ ] guest_phone

### Tabela: payments
- [ ] stripe_client_secret

### Tabela: payouts
- [ ] bank_details (JSONB completo)

### Tabela: service_providers
- [ ] email
- [ ] phone
- [ ] document_number
- [ ] bank_details

---

## ✅ VERIFICAÇÃO APÓS CONFIGURAÇÃO

```sql
-- Testar criptografia
SELECT reserve.encrypt_pii('test@example.com') as encrypted;

-- Verificar se colunas existem
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'travelers' 
AND column_name LIKE '%encrypted%';

-- Verificar Vault
SELECT * FROM vault.secrets WHERE name LIKE '%reserve%';
```

---

## 🚨 ALTERNATIVA SIMPLES (Se Vault não estiver disponível)

Se a extensão pgsodium não estiver disponível no plano atual:

### Opção 1: Hashing (Irreversível)
```sql
-- Para campos que não precisam ser recuperados (ex: IP)
ALTER TABLE reserve.audit_logs 
ADD COLUMN ip_hash TEXT GENERATED ALWAYS AS (
    encode(digest(ip_address::text || 'salt_2024', 'sha256'), 'hex')
) STORED;
```

### Opção 2: Aplicação Layer
- Criptografar na Edge Function antes de salvar
- Usar biblioteca crypto do Deno
- Chave armazenada em environment variable

### Opção 3: Colunas Separadas
- Manter dados sensíveis em tabela separada
- Acesso apenas via service_role
- Não expor em public views

---

## 📊 STATUS ATUAL

**Migrações Aplicadas:** ✅ Sim (010 e 011)  
**RLS:** ✅ 100% habilitado  
**Ledger Balance Trigger:** ✅ Ativo  
**Payment Constraint:** ✅ Criado  
**Vault/Encryption:** ⏳ Pendente configuração manual  

**Próximo Passo:** Configurar Vault ou usar alternativa de aplicação layer

---

## ⏱️ ESTIMATIVA DE TEMPO

- Configuração Vault: 30-60 minutos
- Migração de dados: 15-30 minutos (se houver dados)
- Testes: 15-30 minutos

**Total:** 1-2 horas

---

## 🆘 SUPORTE

Se encontrar problemas:
1. Verificar se plano Supabase suporta Vault (Pro/Enterprise)
2. Contatar suporte Supabase para habilitar pgsodium
3. Considerar alternativa de criptografia na aplicação

---

**Documento criado:** 2026-02-16  
**Responsável:** Orquestrador/DBA  
**Prioridade:** HIGH (LGPD/GDPR Compliance)
