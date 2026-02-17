@echo off
REM DEPLOY SCRIPT - Reserve Connect Security Hardening (Windows)
REM Versão: 1.0
REM Data: 2026-02-16
REM ⚠️  EXECUTE APÓS VERIFICAR OS PRÉ-REQUISITOS

echo ==========================================
echo DEPLOY - Reserve Connect Security Hardening
echo ==========================================
echo.

REM ============================================
REM ETAPA 1: VERIFICAÇÃO PRÉ-DEPLOY
REM ============================================
echo [ETAPA 1] Verificação Pré-Deploy
echo ------------------------------------------

REM 1.1 Verificar se está no diretório correto
if not exist "supabase\config.toml" (
    echo [ERRO] Execute este script do diretório raiz do projeto
    exit /b 1
)
echo [OK] Diretório do projeto confirmado

REM 1.2 Verificar conexão com Supabase
echo Verificando conexão com Supabase...
supabase link --project-ref ffahkiukektmhkrkordn >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Não foi possível conectar ao projeto Supabase
    echo Verifique suas credenciais e conexão de internet
    exit /b 1
)
echo [OK] Conectado ao projeto Supabase

REM 1.3 Verificar status das migrations
echo.
echo Status das Migrations:
echo ----------------------
supabase migration list

echo.
echo ⚠️  IMPORTANTE:
echo Verifique se as migrations 012-016 aparecem como "not applied"
echo Se aparecerem como "applied", aborte este script.
echo.
set /p confirm="As migrations 012-016 estão prontas para deploy? (s/n): "
if /I not "%confirm%"=="s" (
    echo [CANCELADO] Deploy cancelado pelo usuário
    exit /b 0
)

REM 1.4 Backup do banco de dados
echo.
echo [ETAPA 1.4] Backup do Banco de Dados
echo ------------------------------------------
echo É ALTAMENTE RECOMENDADO fazer um backup antes de prosseguir.
echo.
echo Comando para backup (execute em outro terminal):
echo   supabase db dump -f backup_pre_security_hardening_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.sql
echo.
set /p backup_done="Você já fez backup do banco? (s/n): "
if /I not "%backup_done%"=="s" (
    echo ⚠️  Por favor, faça o backup antes de continuar
    echo Comando: supabase db dump -f backup_pre_security_hardening_%date:~-4,4%%date:~-10,2%%date:~-7,2%.sql
    exit /b 0
)
echo [OK] Backup confirmado

REM 1.5 Verificar extensão Vault
echo.
echo [ETAPA 1.5] Verificação do Supabase Vault
echo ------------------------------------------
echo ⚠️  IMPORTANTE: A extensão 'supabase_vault' deve estar habilitada no banco.
echo.
echo Para verificar no Dashboard:
echo   1. Acesse: https://supabase.com/dashboard/project/ffahkiukektmhkrkordn
echo   2. Vá em: Database ^> Extensions
echo   3. Procure por 'supabase_vault' e verifique se está habilitada
echo.
set /p vault_enabled="A extensão supabase_vault está habilitada? (s/n): "
if /I not "%vault_enabled%"=="s" (
    echo [ERRO] Habilite a extensão supabase_vault antes de continuar
    echo Dashboard ^> Database ^> Extensions ^> supabase_vault ^> Enable
    exit /b 1
)
echo [OK] Vault verificado

REM ============================================
REM ETAPA 2: DEPLOY DAS MIGRATIONS
REM ============================================
echo.
echo [ETAPA 2] Deploy das Migrations
echo ------------------------------------------
echo Migrations a serem aplicadas:
echo   - 012_pii_vault_encryption.sql
echo   - 013_audit_log_redaction_retention.sql
echo   - 014_webhook_dedup_and_payment_safety.sql
echo   - 015_concurrency_and_booking_integrity.sql
echo   - 016_ops_monitoring_helpers.sql
echo.

set /p deploy_confirm="Confirma o deploy dessas migrations? (s/n): "
if /I not "%deploy_confirm%"=="s" (
    echo [CANCELADO] Deploy cancelado
    exit /b 0
)

echo.
echo Iniciando deploy...
echo.

REM Aplicar migrations
echo Aplicando migrations...
supabase db push

if errorlevel 1 (
    echo [ERRO] Falha ao aplicar migrations
    echo Verifique os logs acima para detalhes do erro
    exit /b 1
)
echo [OK] Migrations aplicadas com sucesso!

REM ============================================
REM ETAPA 3: VERIFICAÇÃO PÓS-DEPLOY
REM ============================================
echo.
echo [ETAPA 3] Verificação Pós-Deploy
echo ------------------------------------------

REM 3.1 Verificar se as migrations foram aplicadas
echo Verificando status das migrations...
supabase migration list | findstr "012 013 014 015 016"

echo.
echo [OK] Verificação das migrations completa

REM 3.2 Instruções para criar chaves de criptografia
echo.
echo [ETAPA 3.2] Criação das Chaves de Criptografia
echo ------------------------------------------
echo As chaves de criptografia precisam ser criadas manualmente.
echo.
echo Execute os seguintes comandos no SQL Editor do Supabase Dashboard:
echo.
echo -- Criar chaves de criptografia
ECHO SELECT vault.create_key(
ECHO     name := 'travelers_pii_key',
ECHO     key_type := 'aead-det',
ECHO     comment := 'Encryption key for travelers personal data'
ECHO ^);
ECHO.
ECHO SELECT vault.create_key(
ECHO     name := 'owners_pii_key', 
ECHO     key_type := 'aead-det',
ECHO     comment := 'Encryption key for property owner data'
ECHO ^);
ECHO.
ECHO SELECT vault.create_key(
ECHO     name := 'bank_details_key',
ECHO     key_type := 'aead-det', 
ECHO     comment := 'Encryption key for banking information'
ECHO ^);
ECHO.
ECHO SELECT vault.create_key(
ECHO     name := 'payment_secrets_key',
ECHO     key_type := 'aead-det',
ECHO     comment := 'Encryption key for payment gateway secrets'
ECHO ^);
ECHO.
ECHO -- Verificar chaves criadas
ECHO SELECT name, key_type, created_at 
ECHO FROM vault.keys 
ECHO WHERE name LIKE '%%_key';

echo.
set /p keys_created="As chaves de criptografia foram criadas? (s/n): "
if /I not "%keys_created%"=="s" (
    echo ⚠️  Lembre-se de criar as chaves antes de usar a criptografia
)

REM ============================================
REM ETAPA 4: DEPLOY DAS EDGE FUNCTIONS
REM ============================================
echo.
echo [ETAPA 4] Deploy das Edge Functions
echo ------------------------------------------
echo Functions a serem deployadas:
echo   - webhook_stripe
echo   - create_payment_intent_stripe
echo   - create_pix_charge
echo.

set /p func_confirm="Deployar as Edge Functions atualizadas? (s/n): "
if /I "%func_confirm%"=="s" (
    echo Deployando webhook_stripe...
    supabase functions deploy webhook_stripe
    
    echo Deployando create_payment_intent_stripe...
    supabase functions deploy create_payment_intent_stripe
    
    echo Deployando create_pix_charge...
    supabase functions deploy create_pix_charge
    
    echo [OK] Edge Functions deployadas!
) else (
    echo [PULADO] Deploy das Edge Functions pulado
)

REM ============================================
REM ETAPA 5: TESTES PÓS-DEPLOY
REM ============================================
echo.
echo [ETAPA 5] Testes Pós-Deploy
echo ------------------------------------------
echo Execute os seguintes testes no SQL Editor:
echo.

ECHO -- Teste 1: Verificar tabelas criadas
ECHO SELECT 'processed_webhooks' as table_name, 
ECHO        EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'processed_webhooks') as exists
ECHO UNION ALL
ECHO SELECT 'booking_locks',
ECHO        EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'booking_locks')
ECHO UNION ALL
ECHO SELECT 'retention_policies',
ECHO        EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'retention_policies');
ECHO.
ECHO -- Teste 2: Verificar views de monitoramento
ECHO SELECT COUNT(*) as view_count
ECHO FROM information_schema.views
ECHO WHERE table_schema = 'reserve'
ECHO AND table_name IN ('stuck_payments', 'overbooking_check', 'ledger_balance_check');
ECHO -- Expected: 3
ECHO.
ECHO -- Teste 3: Verificar funções de criptografia
ECHO SELECT proname, prosrc IS NOT NULL as has_implementation
ECHO FROM pg_proc
ECHO WHERE proname IN ('encrypt_pii', 'decrypt_pii', 'hash_for_lookup');
ECHO.
ECHO -- Teste 4: Health check
ECHO SELECT * FROM reserve.system_health_check();
ECHO.
ECHO -- Teste 5: Verificar triggers de estado
ECHO SELECT tgrelid::regclass as table_name, tgname, tgenabled
ECHO FROM pg_trigger
ECHO WHERE tgname IN ('trg_payment_state_validation', 'trg_intent_state_validation');

echo.
echo ⚠️  Execute os comandos acima no SQL Editor para verificar o deploy

REM ============================================
REM CONCLUSÃO
REM ============================================
echo.
echo ==========================================
echo [SUCESSO] DEPLOY CONCLUÍDO!
echo ==========================================
echo.
echo Próximos passos:
echo   1. Verifique os resultados dos testes acima
@echo   2. Monitore os logs das Edge Functions
echo   3. Execute um teste de pagamento end-to-end
@echo   4. Verifique se não há erros nos logs
echo.
echo Comandos úteis para monitoramento:
echo   supabase functions logs webhook_stripe --tail
@echo   supabase functions logs create_payment_intent_stripe --tail
echo.
echo Documentação completa em: docs/POST_DEPLOY_VERIFICATION.md
echo.

pause
