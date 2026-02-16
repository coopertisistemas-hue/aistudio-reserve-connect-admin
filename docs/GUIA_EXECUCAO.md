# GUIA DE EXECUÇÃO - MIGRAÇÕES RESERVE CONNECT

## ⚠️ IMPORTANTE: Credenciais Necessárias

Para executar as migrações, você precisa da **Connection String** do banco Reserve Connect.

### Como Obter a Connection String

1. Acesse o [Supabase Dashboard](https://supabase.com/dashboard)
2. Selecione o projeto **Reserve Connect**
3. Vá em **Project Settings** → **Database**
4. Na seção **Connection Info**, copie a **URI**:
   ```
   postgresql://postgres:[YOUR-PASSWORD]@db.xxxxxxxxxx.supabase.co:5432/postgres
   ```

⚠️ **Segurança**: Mantenha esta URL em segredo! Não compartilhe ou commite em repositórios.

---

## 🚀 Opções de Execução

### OPÇÃO 1: Script Bash (Linux/Mac/Git Bash Windows)

```bash
# No terminal, na pasta do projeto:
./execute_migrations.sh "postgresql://postgres:[PASSWORD]@db.xxxxxxxxxx.supabase.co:5432/postgres"
```

Ou com variável de ambiente:
```bash
export DATABASE_URL="postgresql://postgres:[PASSWORD]@db.xxxxxxxxxx.supabase.co:5432/postgres"
./execute_migrations.sh
```

### OPÇÃO 2: Script Batch (Windows CMD/PowerShell)

```cmd
# No prompt de comando, na pasta do projeto:
execute_migrations.bat "postgresql://postgres:[PASSWORD]@db.xxxxxxxxxx.supabase.co:5432/postgres"
```

### OPÇÃO 3: Manual via psql

```bash
# Navegue até a pasta das migrações
cd supabase/migrations

# Execute cada arquivo em ordem:
psql "postgresql://postgres:[PASSWORD]@db.xxxxxxxxxx.supabase.co:5432/postgres" -f 001_foundation_schema.sql
psql "postgresql://postgres:[PASSWORD]@db.xxxxxxxxxx.supabase.co:5432/postgres" -f 002_booking_core.sql
psql "postgresql://postgres:[PASSWORD]@db.xxxxxxxxxx.supabase.co:5432/postgres" -f 003_financial_module.sql
psql "postgresql://postgres:[PASSWORD]@db.xxxxxxxxxx.supabase.co:5432/postgres" -f 004_operations_audit.sql
psql "postgresql://postgres:[PASSWORD]@db.xxxxxxxxxx.supabase.co:5432/postgres" -f 005_analytics_marketing.sql
psql "postgresql://postgres:[PASSWORD]@db.xxxxxxxxxx.supabase.co:5432/postgres" -f 006_future_placeholders.sql
psql "postgresql://postgres:[PASSWORD]@db.xxxxxxxxxx.supabase.co:5432/postgres" -f 007_qa_verification.sql
```

### OPÇÃO 4: Supabase Dashboard (Mais Seguro)

1. Acesse: https://supabase.com/dashboard
2. Selecione o projeto Reserve Connect
3. Vá em **SQL Editor** → **New query**
4. Cole o conteúdo de cada arquivo (001 → 007)
5. Execute um por um
6. Verifique o output

---

## 📋 Ordem de Execução

**IMPORTANTE: Execute na ordem exata!**

1. ✅ `001_foundation_schema.sql` - Cidades, propriedades, unidades
2. ✅ `002_booking_core.sql` - Viajantes, intenções, reservas  
3. ✅ `003_financial_module.sql` - Pagamentos, ledger, comissões
4. ✅ `004_operations_audit.sql` - Audit logs, notificações
5. ✅ `005_analytics_marketing.sql` - Eventos, reviews, ads
6. ✅ `006_future_placeholders.sql` - Owner portal, serviços
7. ✅ `007_qa_verification.sql` - Verificação de qualidade

---

## ✅ Verificação Pós-Execução

Após executar todas as migrações, verifique:

### 1. Tabelas Criadas
```sql
-- No SQL Editor do Supabase
SELECT tablename 
FROM pg_tables 
WHERE schemaname = 'reserve' 
ORDER BY tablename;
```

**Esperado**: 35+ tabelas

### 2. Dados de Teste
```sql
-- Verificar cidade
SELECT * FROM reserve.cities;

-- Verificar propriedade
SELECT * FROM reserve.properties_map;

-- Verificar reserva
SELECT * FROM reserve.reservations;

-- Verificar ledger balanceado
SELECT * FROM reserve.ledger_entries LIMIT 10;
```

### 3. RLS Policies
```sql
-- Verificar políticas
SELECT tablename, policyname 
FROM pg_policies 
WHERE schemaname = 'reserve'
ORDER BY tablename;
```

**Esperado**: 40+ políticas

### 4. QA Verification
O último script (`007_qa_verification.sql`) executa testes automáticos.

**Resultado esperado**: Todas as verificações devem mostrar "PASS"

---

## 🛠️ Solução de Problemas

### Erro: "password authentication failed"
- Verifique se a senha está correta
- Certifique-se de usar a senha do projeto Reserve Connect (não do Portal ou Host)

### Erro: "relation already exists"
- As migrações são idempotentes, mas se quiser resetar:
```sql
DROP SCHEMA reserve CASCADE;
CREATE SCHEMA reserve;
-- Re-execute as migrações
```

### Erro: "permission denied"
- Use a **Service Role Key** (não a anon key)
- Vá em Project Settings → API → service_role key

### Erro: "psql: command not found"
**Windows:**
```bash
scoop install postgresql
# ou
choco install postgresql
```

**Mac:**
```bash
brew install postgresql
```

**Linux:**
```bash
sudo apt-get install postgresql-client
```

---

## 📊 Tempo Estimado

- **001_foundation_schema.sql**: 10-20 segundos
- **002_booking_core.sql**: 5-10 segundos
- **003_financial_module.sql**: 10-20 segundos
- **004_operations_audit.sql**: 5-10 segundos
- **005_analytics_marketing.sql**: 10-20 segundos
- **006_future_placeholders.sql**: 10-15 segundos
- **007_qa_verification.sql**: 30-60 segundos

**Total**: ~2-5 minutos

---

## 🔒 Segurança

⚠️ **IMPORTANTE**:
- Nunca compartilhe sua connection string
- Não commite credenciais no git
- Use variáveis de ambiente quando possível
- Revogue a senha após o deploy se necessário

---

## ✨ Próximos Passos Após Execução

1. ✅ Verificar tabelas no Dashboard
2. ✅ Testar queries de exemplo
3. ✅ Configurar Stripe webhook
4. ✅ Configurar PIX provider
5. ✅ Deploy Edge Functions
6. ✅ Testar fluxo de reserva end-to-end

---

## 🆘 Suporte

Se encontrar problemas:
1. Verifique o log de erro completo
2. Confirme que está usando a ordem correta
3. Verifique se a connection string está correta
4. Certifique-se de ter permissões de admin/service_role

**Status**: Pronto para execução! 🚀
