# CONFIGURAÇÃO STRIPE WEBHOOK - PAYMENT PROCESSING

## Status: ⏳ PENDENTE DE CONFIGURAÇÃO NO DASHBOARD

---

## 📋 RESUMO

Para processar pagamentos Stripe automaticamente, é necessário configurar um webhook no Dashboard do Stripe que aponte para a Edge Function `webhook_stripe` já deployada.

---

## 🎯 OBJETIVO

Receber eventos do Stripe em tempo real:
- ✅ `payment_intent.succeeded` - Pagamento confirmado
- ✅ `payment_intent.payment_failed` - Pagamento falhou
- ✅ `charge.refunded` - Reembolso processado
- ✅ `charge.dispute.created` - Disputa aberta

---

## 📋 PASSO A PASSO

### 1. Acessar Dashboard Stripe

**URL:** https://dashboard.stripe.com

**Login:** Conta Stripe da Reserve Connect

**Status:** ⬜ Pendente

---

### 2. Navegar para Webhooks

**Caminho:**
```
Developers → Webhooks → Add endpoint
```

**Status:** ⬜ Pendente

---

### 3. Configurar Endpoint

**Endpoint URL:**
```
https://ffahkiukektmhkrkordn.supabase.co/functions/v1/webhook_stripe
```

**Description:** Reserve Connect Payment Webhook

**Status:** ⬜ Pendente

---

### 4. Selecionar Eventos

**Selecionar TODOS estes eventos:**

#### Payment Intents (Core)
- [ ] `payment_intent.amount_capturable_updated`
- [ ] `payment_intent.canceled`
- [ ] `payment_intent.created`
- [ ] `payment_intent.partially_funded`
- [ ] `payment_intent.payment_failed` ⭐ CRITICAL
- [ ] `payment_intent.processing`
- [ ] `payment_intent.requires_action`
- [ ] `payment_intent.succeeded` ⭐ CRITICAL

#### Charges (Core)
- [ ] `charge.captured`
- [ ] `charge.dispute.created` ⭐ IMPORTANT
- [ ] `charge.dispute.closed`
- [ ] `charge.expired`
- [ ] `charge.failed`
- [ ] `charge.pending`
- [ ] `charge.refund.updated`
- [ ] `charge.refunded` ⭐ IMPORTANT
- [ ] `charge.succeeded`
- [ ] `charge.updated`

#### Refunds (Core)
- [ ] `refund.created`
- [ ] `refund.failed`
- [ ] `refund.updated`

**Total:** ~15 eventos (foco nos marcados com ⭐)

**Status:** ⬜ Pendente

---

### 5. Salvar e Copiar Signing Secret

Após salvar o webhook:

1. **Revelar Signing Secret:**
   - Clique em "Reveal" no campo "Signing secret"
   - Copiar o valor (começa com `whsec_`)

2. **Armazenar no Supabase:**
   ```
   Nome: STRIPE_WEBHOOK_SECRET
   Valor: whsec_xxxxxxxxxx (copiado do Stripe)
   ```

**Status:** ⬜ Pendente

---

### 6. Configurar no Supabase

**Caminho:**
```
Supabase Dashboard → Project Settings → Edge Functions → Secrets
```

**Adicionar Secret:**
```
Key: STRIPE_WEBHOOK_SECRET
Value: whsec_xxxxxxxxxxxxxxxxxxxx (do passo 5)
```

**Status:** ⬜ Pendente

---

### 7. Testar Webhook

#### Test via Stripe CLI (Local)
```bash
# Instalar Stripe CLI
brew install stripe/stripe-cli/stripe

# Login
stripe login

# Forward webhook para local
stripe listen --forward-to localhost:54321/functions/v1/webhook_stripe
```

#### Test via Stripe Dashboard
1. No webhook criado, clicar em "Send test event"
2. Selecionar `payment_intent.succeeded`
3. Enviar
4. Verificar logs no Supabase Dashboard

**Status:** ⬜ Pendente

---

## 🔐 SEGURANÇA

### Signature Verification

A Edge Function já implementa verificação de assinatura:

```typescript
const signature = req.headers.get('stripe-signature')
const event = stripe.webhooks.constructEvent(
  body, 
  signature, 
  webhookSecret
)
```

### Dados Sensíveis

- Nunca logar `stripe_client_secret` completo
- Nunca expor `webhookSecret` em código
- Usar apenas environment variables

---

## 🧪 TESTES RECOMENDADOS

### Teste 1: Pagamento Bem-sucedido
```bash
# Criar payment intent no Stripe Dashboard
# Ou via API

curl -X POST https://api.stripe.com/v1/payment_intents \
  -u sk_test_xxx: \
  -d amount=2000 \
  -d currency=brl \
  -d payment_method=pm_card_visa \
  -d confirm=true

# Verificar se webhook foi recebido
# Logs: Supabase Dashboard → Functions → webhook_stripe → Logs
```

### Teste 2: Reembolso
```bash
# No Stripe Dashboard
# 1. Encontrar charge
# 2. Criar refund
# 3. Verificar se webhook processou
```

### Teste 3: Disputa
```bash
# Usar cartão de teste: 4000000000000259 (dispute)
# Criar pagamento
# Esperar webhook de dispute
```

---

## 📊 MONITORAMENTO

### Dashboards para Acompanhar

1. **Stripe Dashboard:**
   - Webhooks → Recent deliveries
   - Verificar taxa de sucesso

2. **Supabase Dashboard:**
   - Functions → webhook_stripe → Logs
   - Erros e latência

3. **Métricas Importantes:**
   - Webhook delivery rate (>99%)
   - Response time (< 2s)
   - Error rate (< 1%)

### Alertas Configurar

- [ ] Webhook falhou 3x seguidas
- [ ] Response time > 5s
- [ ] Erro 500 na Edge Function

---

## 🚨 TROUBLESHOOTING

### Erro: "No signatures found matching the expected signature"

**Causa:** Signing secret incorreto

**Solução:**
1. Verificar se `STRIPE_WEBHOOK_SECRET` está correto
2. Copiar novamente do Stripe Dashboard
3. Redeploy Edge Function

---

### Erro: "Webhook endpoint not responding"

**Causa:** Edge Function offline ou erro

**Solução:**
1. Verificar se função está deployada
2. Verificar logs no Supabase
3. Testar endpoint manualmente:
   ```bash
   curl -X POST https://ffahkiukektmhkrkordn.supabase.co/functions/v1/webhook_stripe \
     -H "Content-Type: application/json" \
     -d '{"test": true}'
   ```

---

### Erro: "Ledger balance violation"

**Causa:** Trigger de ledger impedindo webhook

**Solução:**
1. Verificar se ledger entries estão balanceadas
2. Verificar logs de erro
3. Corrigir dados se necessário

---

## 📋 CHECKLIST DE CONFIGURAÇÃO

- [ ] Acessar Stripe Dashboard
- [ ] Criar novo webhook endpoint
- [ ] Configurar URL: `https://ffahkiukektmhkrkordn.supabase.co/functions/v1/webhook_stripe`
- [ ] Selecionar eventos (payment_intent.*, charge.*)
- [ ] Salvar webhook
- [ ] Copiar Signing Secret
- [ ] Adicionar secret no Supabase (`STRIPE_WEBHOOK_SECRET`)
- [ ] Testar envio de evento
- [ ] Verificar logs
- [ ] Confirmar ledger entries sendo criadas

---

## ✅ VERIFICAÇÃO FINAL

```bash
# Teste completo end-to-end

# 1. Criar intent de booking
# 2. Criar payment intent Stripe
# 3. Confirmar pagamento
# 4. Verificar:
#    - Webhook recebido
#    - Payment status = 'succeeded'
#    - Ledger entries criadas
#    - Reservation criada (se implementado)

# SQL para verificar:
SELECT * FROM reserve.payments 
WHERE status = 'succeeded' 
ORDER BY created_at DESC 
LIMIT 5;

SELECT * FROM reserve.ledger_entries 
ORDER BY created_at DESC 
LIMIT 10;
```

---

## 📞 CONTATOS

**Stripe Support:** https://support.stripe.com
**Supabase Support:** https://supabase.com/support

---

## ⏱️ ESTIMATIVA DE TEMPO

- Configuração webhook: 15-20 minutos
- Testes: 15-30 minutos
- Troubleshooting: 15-30 minutos (se necessário)

**Total:** 30-80 minutos

---

## 🎯 PRÓXIMOS PASSOS

1. ⬜ Configurar webhook no Stripe
2. ⬜ Adicionar secrets no Supabase
3. ⬜ Testar com pagamento de teste
4. ⬜ Verificar ledger entries
5. ⬜ Monitorar em produção

---

**Documento criado:** 2026-02-16  
**Responsável:** Orquestrador/DevOps  
**Prioridade:** CRITICAL (impede processamento de pagamentos)

---

**Nota:** Sem este webhook configurado, os pagamentos Stripe NÃO serão processados automaticamente. O sistema ficará aguardando webhook que nunca chega.
