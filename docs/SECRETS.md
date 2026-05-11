# Gerenciamento de Secrets — IndioLab

> Procedimento operacional para credenciais de banco, JWT keys, e demais segredos
> dos backends `admin-api`, `crm-api`, `erp-api`, `chat-api`.

## Estado atual (2026-05-06)

- **Postgres role aplicação:** `indiolab_app` (não-superuser, com ownership das tabelas)
- **Postgres superuser `postgres`:** senha rotacionada após incidente da senha `pegasus` ter sido commitada
- **Mecanismo dev:** `dotnet user-secrets` (machine-local, fora do git)
- **Mecanismo prod recomendado:** variáveis de ambiente (env vars) ou secret manager (Vault/Azure Key Vault/AWS Secrets Manager)

---

## Desenvolvimento local (dotnet user-secrets)

### Por que user-secrets

ASP.NET Core, em ambiente `Development`, carrega automaticamente um arquivo de secrets local (`~/.microsoft/usersecrets/<UserSecretsId>/secrets.json` no macOS/Linux), sobrescrevendo `appsettings.json`. Esse arquivo **nunca** vai para o git.

### Configurar uma máquina nova

1. **Criar role aplicação no Postgres** (já feito uma vez por ambiente):

   ```bash
   PGPASSWORD=<senha_postgres> psql -U postgres -h localhost -d opticalcorecombr <<SQL
   CREATE ROLE indiolab_app WITH LOGIN PASSWORD '<senha_forte_32+_chars>';
   GRANT CONNECT ON DATABASE opticalcorecombr TO indiolab_app;
   ALTER DATABASE opticalcorecombr OWNER TO indiolab_app;
   -- Ownership de tabelas + sequences + views + schemas tenant
   -- (script completo no histórico de comandos da sessão de hardening)
   SQL
   ```

2. **Configurar user-secrets em cada api:**

   ```bash
   NEW_CONN="Host=localhost;Database=opticalcorecombr;Username=indiolab_app;Password=<senha>;Pooling=true;Maximum Pool Size=200"

   for project in \
     admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.API/IndioLab.Admin.API.csproj \
     crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/IndioLab.Crm.API.csproj \
     erp.dev.indiolab.com.br/erp-api/src/IndioLab.Erp.API/IndioLab.Erp.API.csproj \
     chat.dev.indiolab.com.br/chat-api/src/IndioLab.Chat.API/IndioLab.Chat.API.csproj
   do
     dotnet user-secrets init --project "$project"
     dotnet user-secrets set "ConnectionStrings:DefaultConnection" "$NEW_CONN" --project "$project"
   done
   ```

3. **Rodar cada api com `ASPNETCORE_ENVIRONMENT=Development`:**

   ```bash
   cd admin-api/src/IndioLab.Admin.API && \
     ASPNETCORE_ENVIRONMENT=Development dotnet run --urls http://localhost:5050
   ```

   Sem `Development`, user-secrets **não** é carregado e a app falha com `ArgumentNullException`.

### Verificar configuração

```bash
dotnet user-secrets list --project <caminho>/IndioLab.X.API.csproj
```

### Rotacionar a senha local

1. Trocar no Postgres: `ALTER ROLE indiolab_app WITH PASSWORD '<nova>';`
2. `dotnet user-secrets set "ConnectionStrings:DefaultConnection" "<nova_conn>" --project <proj>`
3. Reiniciar a api

---

## Produção

**NÃO** use user-secrets em produção (é arquivo machine-local). Use variáveis de ambiente, que sobrescrevem appsettings via `EnvironmentVariablesConfigurationProvider`.

### Convenção de env vars no ASP.NET Core

Hierarquia separa por `__` (duplo underscore, equivalente ao `:` do JSON):

```bash
ConnectionStrings__DefaultConnection="Host=...;Database=...;Username=indiolab_app;Password=...;SslMode=Require"
JwtSettings__RsaPrivateKeyPem="..."
JwtSettings__Issuer="https://auth.indiolab.com.br"
```

### Recomendações para deploy

| Plataforma | Mecanismo |
|---|---|
| **Docker** | env vars via `docker run -e` ou Compose `environment:` |
| **Docker Swarm / Kubernetes** | `secrets:` (Swarm) ou `Secret` resources (k8s) montados como env vars |
| **Azure App Service** | App Settings (são env vars) ou referência a Azure Key Vault |
| **AWS ECS / Fargate** | Task Definition `secrets:` apontando para Secrets Manager / Parameter Store |
| **VM tradicional** | systemd service file com `Environment=` (file mode 0600) |

### SSL na connection string em produção

Sempre incluir:

```
SslMode=Require;Trust Server Certificate=false
```

(ou `VerifyFull` com CA cert válido).

---

## Postergar senha do `postgres` superuser

A senha do `postgres` foi rotacionada em **2026-05-06**. A senha antiga `pegasus`:

- Está no histórico do git (commits anteriores em `appsettings*.json`)
- **Não funciona mais** no banco
- Mas pode ser tentada por atacantes que cloneem o repo histórico

### Limpeza do git history (operação coordenada com o time)

```bash
# Backup primeiro
git clone --mirror <repo> repo-backup.git

# Use git-filter-repo (mais seguro que filter-branch)
pip install git-filter-repo

# Remover senha de todos commits passados
git filter-repo --replace-text <(echo "pegasus==>***REMOVED***")

# Force push (todos os devs precisam re-clonar depois)
git push --force --all
git push --force --tags
```

**Pré-requisitos:**
- Aviso ao time de que vai haver force-push
- Todos rebasariam ou re-clonariam
- CI/CD precisa não ter cache do hash anterior
- Branches abertos precisam ser revalidados

**Alternativa pragmática se rewrite for inviável:** documentar que a senha foi rotacionada, marcar histórico como "comprometido mas mitigado", e forçar bom hábito daqui pra frente.

---

## JWT Keys (RsaPrivateKeyPem / RsaPublicKeyPem)

Hoje em dev: chaves RSA inline em `appsettings.Development.json` (NÃO commitar `Development.json` em prod).

Em produção:

- **Issuer (admin-api):** chave privada via env var `JwtSettings__RsaPrivateKeyPem`
- **Validators (crm-api/erp-api):** chave pública via env var `JwtSettings__RsaPublicKeyPem`
- Rotacionar pares periodicamente (90-180 dias)

---

## .gitignore atual

Já cobre:

```
.env
.env.local
.env.*.local
.env.production
appsettings.Development.json
```

**NÃO** adicionar `appsettings.json` ou `appsettings.Production.json` ao gitignore — esses arquivos devem existir no repo com **placeholders vazios** (`""`), e env vars sobrescrevem em runtime.

---

## Checklist para nova api

Quando criar um novo backend:

- [ ] `dotnet user-secrets init --project <new-api>.csproj`
- [ ] `dotnet user-secrets set "ConnectionStrings:DefaultConnection" "<conn>"`
- [ ] `appsettings.json` com `"DefaultConnection": ""` (placeholder)
- [ ] `<UserSecretsId>` no `.csproj` (gerado pelo `init`)
- [ ] Documentar env vars necessários para prod no README do projeto
- [ ] Verificar que rodando sem `ASPNETCORE_ENVIRONMENT=Development` falha cedo (não silencioso)

---

## Histórico

- **2026-05-06:** Hardening operacional (rotação `pegasus` → forte; criação `indiolab_app`; user-secrets nos 4 apis; sanitização de 5 `appsettings*.json` + `setup-local.sh`).
