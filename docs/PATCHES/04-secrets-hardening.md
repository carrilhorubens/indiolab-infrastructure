# Patch F4 — Secrets Hardening (Operacional)

> **⚠️ Patch operacional de segurança.** Senha `pegasus` rotacionada no Postgres. Role aplicação `indiolab_app` (não-superuser) criada com ownership de 270 tabelas. `dotnet user-secrets` configurado em 4 apis. 5 `appsettings.json` sanitizados.

## Status do banco (já aplicado)

⚠️ Estas mudanças JÁ FORAM APLICADAS no Postgres local — não rodar de novo:

```sql
-- Senha postgres rotacionada (cat /tmp/postgres_pwd)
ALTER ROLE postgres WITH PASSWORD '<nova>';

-- Role aplicação criada
CREATE ROLE indiolab_app WITH LOGIN PASSWORD '<senha>'; -- cat /tmp/indiolab_app_pwd
GRANT CONNECT ON DATABASE opticalcorecombr TO indiolab_app;
ALTER DATABASE opticalcorecombr OWNER TO indiolab_app;
-- + ownership de 107 tabelas public + 163 tabelas tenant + sequences + views

-- indiolab_app.rolbypassrls = false (verificado)
```

## Status do user-secrets (já aplicado)

⚠️ user-secrets já configurado em 4 apis (machine-local). Para nova máquina, refazer conforme [`docs/SECRETS.md`](../SECRETS.md):

| API | UserSecretsId |
|---|---|
| admin-api | `e1fde506-6a62-4e24-add3-b31c5785cfe6` |
| crm-api | `5213f4dd-56e9-4c81-9ee0-c73ee739cd73` |
| erp-api | `c3d4a3f1-7483-45cd-abc4-4ff974b1e278` |
| chat-api | `bc3eb61e-e926-4064-90b5-07b9978d56e8` |

## Arquivos commitáveis

### appsettings.json sanitizados (string vazia, user-secrets sobrepõe em dev)
```
admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.API/appsettings.json
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/appsettings.json
erp.dev.indiolab.com.br/erp-api/src/IndioLab.Erp.API/appsettings.json
erp.dev.indiolab.com.br/erp-api/src/OpticalCore.API/appsettings.json
chat.dev.indiolab.com.br/chat-api/src/IndioLab.Chat.API/appsettings.json
chat.dev.indiolab.com.br/ichat-api/src/IndioLab.Chat.API/appsettings.json
```

### `.csproj` com `<UserSecretsId>` (gerado pelo `dotnet user-secrets init`)
```
admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.API/IndioLab.Admin.API.csproj
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/IndioLab.Crm.API.csproj
erp.dev.indiolab.com.br/erp-api/src/IndioLab.Erp.API/IndioLab.Erp.API.csproj
chat.dev.indiolab.com.br/chat-api/src/IndioLab.Chat.API/IndioLab.Chat.API.csproj
```

### Script setup-local
```
crm.dev.indiolab.com.br/scripts/setup-local.sh
```

## Comando git

```bash
git add admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.API/appsettings.json \
        admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.API/IndioLab.Admin.API.csproj \
        crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/appsettings.json \
        crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/IndioLab.Crm.API.csproj \
        erp.dev.indiolab.com.br/erp-api/src/IndioLab.Erp.API/appsettings.json \
        erp.dev.indiolab.com.br/erp-api/src/IndioLab.Erp.API/IndioLab.Erp.API.csproj \
        erp.dev.indiolab.com.br/erp-api/src/OpticalCore.API/appsettings.json \
        chat.dev.indiolab.com.br/chat-api/src/IndioLab.Chat.API/appsettings.json \
        chat.dev.indiolab.com.br/chat-api/src/IndioLab.Chat.API/IndioLab.Chat.API.csproj \
        chat.dev.indiolab.com.br/ichat-api/src/IndioLab.Chat.API/appsettings.json \
        crm.dev.indiolab.com.br/scripts/setup-local.sh

git status
git diff --cached
```

## Mensagem de commit sugerida

```
security: rotate postgres credentials + use dotnet user-secrets in 4 APIs

⚠️  OPERATIONAL: production deploy requires coordinated rollout.

What was rotated:
- postgres role password (was hardcoded "pegasus" in git history)
- created non-superuser application role `indiolab_app` with ownership of 270 tables

What was committed:
- emptied ConnectionStrings.DefaultConnection in 6 appsettings.json (admin, crm, erp×2, chat×2)
- added <UserSecretsId> to 4 .csproj (admin, crm, erp, chat)
- crm/scripts/setup-local.sh now requires DB_PASSWORD env var (no more hardcoded fallback)

Local dev:
- ConnectionStrings come from `dotnet user-secrets` (machine-local, gitignored automatically)
- requires ASPNETCORE_ENVIRONMENT=Development to load secrets

Production:
- use environment variables (ConnectionStrings__DefaultConnection)
- procedure documented in docs/SECRETS.md (separate commit)

Pending (NOT in this commit, requires team coordination):
- git filter-repo to scrub "pegasus" from history (force-push)
- production rotation rollout

Validated locally: pegasus invalid; indiolab_app authenticates; all 3 backends boot
with new credentials; login + leads/oportunidades/atividades endpoints functional;
indiolab_app.rolbypassrls = false (RLS works against it).
```

## Pré-condições para outra máquina (dev)

Quem clonar o repo após este commit precisa:

```bash
# 1. Banco local + role indiolab_app + ownership (script abaixo)
PGPASSWORD=<senha_postgres_local> psql -U postgres -h localhost -d opticalcorecombr <<'SQL'
DROP ROLE IF EXISTS indiolab_app;
CREATE ROLE indiolab_app WITH LOGIN PASSWORD '<senha_local_dev>';
GRANT CONNECT ON DATABASE opticalcorecombr TO indiolab_app;
GRANT USAGE, CREATE ON SCHEMA public TO indiolab_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO indiolab_app;
ALTER DATABASE opticalcorecombr OWNER TO indiolab_app;
-- ... (script completo em docs/SECRETS.md)
SQL

# 2. user-secrets em cada API
NEW_CONN="Host=localhost;Database=opticalcorecombr;Username=indiolab_app;Password=<senha_local>;Pooling=true;Maximum Pool Size=200"
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "$NEW_CONN" --project <cada_csproj>

# 3. Sempre rodar com ASPNETCORE_ENVIRONMENT=Development
ASPNETCORE_ENVIRONMENT=Development dotnet run
```

## Validação pós-commit

- `pegasus` não funciona: `PGPASSWORD=pegasus psql -U postgres ... → FATAL: password authentication failed`
- `indiolab_app` funciona: `PGPASSWORD=<nova> psql -U indiolab_app ... → 1 row`
- 3 backends bootam e `/health` retorna 200
