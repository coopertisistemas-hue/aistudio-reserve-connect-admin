#!/bin/bash
# DEPLOY SCRIPT - Reserve Connect Security Hardening
# Versão: 1.0
# Data: 2026-02-16
# ⚠️  EXECUTE APÓS VERIFICAR OS PRÉ-REQUISITOS

set -e  # Exit on error

echo "=========================================="
echo "DEPLOY - Reserve Connect Security Hardening"
echo "=========================================="
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================
# ETAPA 1: VERIFICAÇÃO PRÉ-DEPLOY
# ============================================
echo -e "${YELLOW}ETAPA 1: Verificação Pré-Deploy${NC}"
echo "------------------------------------------"

# 1.1 Verificar se está no diretório correto
if [ ! -f "supabase/config.toml" ]; then
    echo -e "${RED}✗ ERRO: Execute este script do diretório raiz do projeto${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Diretório do projeto confirmado${NC}"

# 1.2 Verificar conexão com Supabase
echo "Verificando conexão com Supabase..."
supabase link --project-ref ffahkiukektmhkrkordn > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ ERRO: Não foi possível conectar ao projeto Supabase${NC}"
    echo "Verifique suas credenciais e conexão de internet"
    exit 1
fi
echo -e "${GREEN}✓ Conectado ao projeto Supabase${NC}"

# 1.3 Verificar status das migrations
echo ""
echo "Status das Migrations:"
echo "----------------------"
supabase migration list

echo ""
echo -e "${YELLOW}⚠️  IMPORTANTE:${NC}"
echo "Verifique se as migrations 012-016 aparecem como 'not applied'"
echo "Se aparecerem como 'applied', aborte este script."
echo ""
read -p "As migrations 012-016 estão prontas para deploy? (s/n): " confirm
if [ "$confirm" != "s" ]; then
    echo -e "${RED}Deploy cancelado pelo usuário${NC}"
    exit 0
fi

# 1.4 Backup do banco de dados
echo ""
echo -e "${YELLOW}ETAPA 1.4: Backup do Banco de Dados${NC}"
echo "------------------------------------------"
echo "É ALTAMENTE RECOMENDADO fazer um backup antes de prosseguir."
echo ""
echo "Comando para backup (execute em outro terminal):"
echo "  supabase db dump -f backup_pre_security_hardening_$(date +%Y%m%d_%H%M%S).sql"
echo ""
read -p "Você já fez backup do banco? (s/n): " backup_done
if [ "$backup_done" != "s" ]; then
    echo -e "${YELLOW}⚠️  Por favor, faça o backup antes de continuar${NC}"
    echo "Comando: supabase db dump -f backup_pre_security_hardening_$(date +%Y%m%d_%H%M%S).sql"
    exit 0
fi

echo -e "${GREEN}✓ Backup confirmado${NC}"

# 1.5 Verificar extensão Vault
echo ""
echo -e "${YELLOW}ETAPA 1.5: Verificação do Supabase Vault${NC}"
echo "------------------------------------------"
echo "⚠️  IMPORTANTE: A extensão 'supabase_vault' deve estar habilitada no banco."
echo ""
echo "Para verificar no Dashboard:"
echo "  1. Acesse: https://supabase.com/dashboard/project/ffahkiukektmhkrkordn"
echo "  2. Vá em: Database > Extensions"
echo "  3. Procure por 'supabase_vault' e verifique se está habilitada"
echo ""
read -p "A extensão supabase_vault está habilitada? (s/n): " vault_enabled
if [ "$vault_enabled" != "s" ]; then
    echo -e "${RED}✗ ERRO: Habilite a extensão supabase_vault antes de continuar${NC}"
    echo "Dashboard > Database > Extensions > supabase_vault > Enable"
    exit 1
fi

echo -e "${GREEN}✓ Vault verificado${NC}"

# ============================================
# ETAPA 2: DEPLOY DAS MIGRATIONS
# ============================================
echo ""
echo -e "${YELLOW}ETAPA 2: Deploy das Migrations${NC}"
echo "------------------------------------------"
echo "Migrations a serem aplicadas:"
echo "  - 012_pii_vault_encryption.sql"
echo "  - 013_audit_log_redaction_retention.sql"
echo "  - 014_webhook_dedup_and_payment_safety.sql"
echo "  - 015_concurrency_and_booking_integrity.sql"
echo "  - 016_ops_monitoring_helpers.sql"
echo ""

read -p "Confirma o deploy dessas migrations? (s/n): " deploy_confirm
if [ "$deploy_confirm" != "s" ]; then
    echo -e "${YELLOW}Deploy cancelado${NC}"
    exit 0
fi

echo ""
echo "Iniciando deploy..."
echo ""

# Aplicar migrations
echo "Aplicando migrations..."
supabase db push

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Migrations aplicadas com sucesso!${NC}"
else
    echo -e "${RED}✗ ERRO: Falha ao aplicar migrations${NC}"
    echo "Verifique os logs acima para detalhes do erro"
    exit 1
fi

# ============================================
# ETAPA 3: VERIFICAÇÃO PÓS-DEPLOY
# ============================================
echo ""
echo -e "${YELLOW}ETAPA 3: Verificação Pós-Deploy${NC}"
echo "------------------------------------------"

# 3.1 Verificar se as migrations foram aplicadas
echo "Verificando status das migrations..."
supabase migration list | grep -E "(012|013|014|015|016)"

echo ""
echo -e "${GREEN}✓ Verificação das migrations completa${NC}"

# 3.2 Criar chaves de criptografia no Vault
echo ""
echo -e "${YELLOW}ETAPA 3.2: Criação das Chaves de Criptografia${NC}"
echo "------------------------------------------"
echo "As chaves de criptografia precisam ser criadas manualmente."
echo ""
echo "Execute os seguintes comandos no SQL Editor do Supabase Dashboard:"
echo ""
cat << 'EOF'
-- Criar chaves de criptografia
SELECT vault.create_key(
    name := 'travelers_pii_key',
    key_type := 'aead-det',
    comment := 'Encryption key for travelers personal data'
);

SELECT vault.create_key(
    name := 'owners_pii_key', 
    key_type := 'aead-det',
    comment := 'Encryption key for property owner data'
);

SELECT vault.create_key(
    name := 'bank_details_key',
    key_type := 'aead-det', 
    comment := 'Encryption key for banking information'
);

SELECT vault.create_key(
    name := 'payment_secrets_key',
    key_type := 'aead-det',
    comment := 'Encryption key for payment gateway secrets'
);

-- Verificar chaves criadas
SELECT name, key_type, created_at 
FROM vault.keys 
WHERE name LIKE '%_key';
EOF

echo ""
read -p "As chaves de criptografia foram criadas? (s/n): " keys_created
if [ "$keys_created" != "s" ]; then
    echo -e "${YELLOW}⚠️  Lembre-se de criar as chaves antes de usar a criptografia${NC}"
fi

# ============================================
# ETAPA 4: DEPLOY DAS EDGE FUNCTIONS
# ============================================
echo ""
echo -e "${YELLOW}ETAPA 4: Deploy das Edge Functions${NC}"
echo "------------------------------------------"
echo "Functions a serem deployadas:"
echo "  - webhook_stripe"
echo "  - create_payment_intent_stripe"
echo "  - create_pix_charge"
echo ""

read -p "Deployar as Edge Functions atualizadas? (s/n): " func_confirm
if [ "$func_confirm" == "s" ]; then
    echo "Deployando webhook_stripe..."
    supabase functions deploy webhook_stripe
    
    echo "Deployando create_payment_intent_stripe..."
    supabase functions deploy create_payment_intent_stripe
    
    echo "Deployando create_pix_charge..."
    supabase functions deploy create_pix_charge
    
    echo -e "${GREEN}✓ Edge Functions deployadas!${NC}"
else
    echo -e "${YELLOW}Deploy das Edge Functions pulado${NC}"
fi

# ============================================
# ETAPA 5: TESTES PÓS-DEPLOY
# ============================================
echo ""
echo -e "${YELLOW}ETAPA 5: Testes Pós-Deploy${NC}"
echo "------------------------------------------"
echo "Execute os seguintes testes no SQL Editor:"
echo ""

cat << 'EOF'
-- Teste 1: Verificar tabelas criadas
SELECT 'processed_webhooks' as table_name, 
       EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'processed_webhooks') as exists
UNION ALL
SELECT 'booking_locks',
       EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'booking_locks')
UNION ALL
SELECT 'retention_policies',
       EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'retention_policies');

-- Teste 2: Verificar views de monitoramento
SELECT COUNT(*) as view_count
FROM information_schema.views
WHERE table_schema = 'reserve'
AND table_name IN ('stuck_payments', 'overbooking_check', 'ledger_balance_check');
-- Expected: 3

-- Teste 3: Verificar funções de criptografia
SELECT proname, prosrc IS NOT NULL as has_implementation
FROM pg_proc
WHERE proname IN ('encrypt_pii', 'decrypt_pii', 'hash_for_lookup');

-- Teste 4: Health check
SELECT * FROM reserve.system_health_check();

-- Teste 5: Verificar triggers de estado
SELECT tgrelid::regclass as table_name, tgname, tgenabled
FROM pg_trigger
WHERE tgname IN ('trg_payment_state_validation', 'trg_intent_state_validation');
EOF

echo ""
echo -e "${YELLOW}Execute os comandos acima no SQL Editor para verificar o deploy${NC}"

# ============================================
# CONCLUSÃO
# ============================================
echo ""
echo "=========================================="
echo -e "${GREEN}DEPLOY CONCLUÍDO!${NC}"
echo "=========================================="
echo ""
echo "Próximos passos:"
echo "  1. Verifique os resultados dos testes acima"
echo "  2. Monitore os logs das Edge Functions"
echo "  3. Execute um teste de pagamento end-to-end"
echo "  4. Verifique se não há erros nos logs"
echo ""
echo "Comandos úteis para monitoramento:"
echo "  supabase functions logs webhook_stripe --tail"
echo "  supabase functions logs create_payment_intent_stripe --tail"
echo ""
echo "Documentação completa em: docs/POST_DEPLOY_VERIFICATION.md"
echo ""
