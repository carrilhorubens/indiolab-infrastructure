# Migração Keycloak — `app.` → `apli.`

> Checklist pra atualizar os 4 clients do realm `indiolab` após troca de domínio.
> Executar **no admin console do Keycloak** (https://auth.apli.indiolab.com.br — ou ainda `auth.app.` se o DNS antigo estiver ativo durante o cutover).

---

## 1. Realm config

**Realm Settings → General**

- [ ] `Frontend URL`: `https://auth.apli.indiolab.com.br`

## 2. Clients (fazer pra cada um: erp-web, crm-web, ichat-web, admin-web)

Pra cada client, em **Clients → {client-id} → Settings**:

- [ ] **Root URL**: `https://{app}.apli.indiolab.com.br`
- [ ] **Home URL**: `https://{app}.apli.indiolab.com.br`
- [ ] **Valid redirect URIs**: `https://{app}.apli.indiolab.com.br/*`
- [ ] **Valid post logout redirect URIs**: `https://{app}.apli.indiolab.com.br/*`
- [ ] **Web origins**: `https://{app}.apli.indiolab.com.br` (ou `+` pra herdar de redirect URIs)

Onde `{app}` é:

| Client      | Subdomínio |
|-------------|--------------------------|
| `erp-web`   | `erp.apli.indiolab.com.br`   |
| `crm-web`   | `crm.apli.indiolab.com.br`   |
| `ichat-web` | `chat.apli.indiolab.com.br`  |
| `admin-web` | `admin.apli.indiolab.com.br` |

## 3. Service accounts (se tiver)

Se o `admin-api` usa service account pra chamar Admin REST API:

- [ ] **Clients → admin-api → Credentials**: rotacionar client secret (opcional, boa prática no cutover)
- [ ] Atualizar `Keycloak:AdminApi:ClientSecret` no `appsettings.Production.json` do admin-api

## 4. Cutover sem downtime (opcional)

Pra evitar janela de erro, manter **os dois domínios no Keycloak** durante a transição:

- [ ] Adicionar em **Valid redirect URIs** também as URIs antigas `https://{app}.app.indiolab.com.br/*` (sem remover ainda)
- [ ] Após 24h com DNS propagado e clientes todos no `apli`, remover as URIs `app.`

## 5. Verificação pós-cutover

```bash
# JWKS endpoint respondendo?
curl -sk https://auth.apli.indiolab.com.br/realms/indiolab/.well-known/openid-configuration | jq .

# Discovery aponta pro novo domínio?
# → "issuer": "https://auth.apli.indiolab.com.br/realms/indiolab"  ✔
```

No browser:

- [ ] Acessar https://erp.apli.indiolab.com.br → redireciona pro Keycloak → login → volta com token
- [ ] Idem crm / chat / admin
- [ ] DevTools → Network: nenhuma request pro `app.indiolab.com.br` antigo
- [ ] DevTools → Application → Storage: cookies do Keycloak com domain `auth.apli.indiolab.com.br`

## 6. Rollback

Se der problema: reverter **Frontend URL** e as **Valid Redirect URIs** pro `app.` antigo. Como as duas ficam cadastradas simultaneamente no passo 4, o rollback é só fechar DNS de volta.
