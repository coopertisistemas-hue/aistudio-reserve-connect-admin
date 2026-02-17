# Deploy do Frontend - Reserve Connect

## ✅ Configuração Concluída

Arquivos configurados:
- `.env` - Variáveis de ambiente com suas credenciais
- `vite.config.ts` - Configuração otimizada para produção
- `vercel.json` - Configuração para SPA routing

---

## 🚀 Deploy no Vercel

### Opção 1: Via CLI (Recomendado)

1. **Instale o Vercel CLI:**
```bash
npm i -g vercel
```

2. **Faça login:**
```bash
vercel login
```

3. **Deploy:**
```bash
cd apps/web
vercel --prod
```

4. **Configure as variáveis de ambiente no Vercel Dashboard:**
   - Acesse: https://vercel.com/dashboard
   - Selecione o projeto
   - Vá em **Settings** → **Environment Variables**
   - Adicione:
     ```
     VITE_SUPABASE_URL=https://ffahkiukektmhkrkordn.supabase.co
     VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZmYWhraXVrZWt0bWhrcmtvcmRuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1ODI0OTYsImV4cCI6MjA3NjE1ODQ5Nn0.7_GvkyT9thEyokfw_uc59jwdWPHAsAnkNswS38ngBWk
     VITE_FUNCTIONS_BASE_URL=https://ffahkiukektmhkrkordn.supabase.co/functions/v1
     VITE_DEFAULT_CITY_CODE=URB
     ```

### Opção 2: Via GitHub Integration

1. **Faça push do código:**
```bash
git add apps/web/.env apps/web/vite.config.ts apps/web/vercel.json
git commit -m "chore: configure vercel deployment"
git push origin main
```

2. **No Vercel Dashboard:**
   - Acesse: https://vercel.com/new
   - Importe seu repositório GitHub
   - Selecione o diretório `apps/web`
   - Configure as variáveis de ambiente acima
   - Clique em **Deploy**

---

## 📁 Estrutura de Deploy

```
apps/web/
├── .env                    # Variáveis de ambiente (não commitar!)
├── .env.example            # Template de variáveis
├── vercel.json            # Configuração Vercel
├── vite.config.ts         # Configuração Vite
├── package.json
├── src/
└── dist/                  # Build gerado automaticamente
```

---

## ⚠️ Importante: Segurança

⚠️ **NUNCA commite o arquivo `.env`!**

O arquivo `.env` contém suas credenciais sensíveis. Ele já está no `.gitignore` por padrão, mas verifique:

```bash
git status
```

O `.env` NÃO deve aparecer como modificado/novo. Se aparecer, adicione-o ao `.gitignore`:

```bash
echo ".env" >> apps/web/.gitignore
```

---

## 🔍 Pós-Deploy

### Verifique se está funcionando:

1. **Landing Page:**
   - Acesse a URL do deploy
   - Deve carregar a LP com o formulário de busca

2. **Busca:**
   - Selecione datas e hóspedes
   - Clique em "Buscar"
   - Deve redirecionar para `/search` com resultados

3. **Detalhes da Propriedade:**
   - Clique em uma propriedade
   - Deve abrir `/p/:slug`

4. **Admin (com bypass):**
   - Acesse `/login`
   - Use o bypass token: `rc_test_2025_seguro_bypass_admin`

---

## 🛠 Troubleshooting

### Problema: Página 404 em rotas SPA
**Solução:** O `vercel.json` já configura o rewrite para `index.html`. Se não funcionar:
```json
{
  "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }]
}
```

### Problema: Variáveis de ambiente não carregam
**Solução:** No Vercel Dashboard, vá em **Settings** → **Environment Variables** e verifique se todas estão configuradas. Depois faça **Redeploy**.

### Problema: API retorna 500
**Solução:** Verifique se `VITE_FUNCTIONS_BASE_URL` está correto. Deve ser:
```
https://ffahkiukektmhkrkordn.supabase.co/functions/v1
```

---

## 📱 Domínio Customizado

1. No Vercel Dashboard, vá em **Settings** → **Domains**
2. Adicione seu domínio
3. Configure os DNS conforme instruções

---

## 🔗 URLs Importantes

- **Vercel Dashboard:** https://vercel.com/dashboard
- **Supabase Dashboard:** https://supabase.com/dashboard/project/ffahkiukektmhkrkordn
- **Functions URL:** https://ffahkiukektmhkrkordn.supabase.co/functions/v1

---

## ✅ Checklist Pré-Deploy

- [ ] Variáveis de ambiente configuradas
- [ ] Build local funciona (`npm run build`)
- [ ] `.env` não está no git
- [ ] `vercel.json` configurado
- [ ] Testado localmente (`npm run preview`)

---

**Pronto para deploy!** 🚀

Qualquer problema, verifique os logs no Vercel Dashboard → **Deployments** → **Logs**.
