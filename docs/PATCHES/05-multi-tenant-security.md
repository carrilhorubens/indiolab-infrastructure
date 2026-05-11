# Patch F5 — Multi-Tenant Security (RLS + Interceptor)

> Defesa em profundidade contra vazamento cross-tenant: 326 tabelas com Row Level Security; `TenantSearchPathCommandInterceptor` substitui chamadas manuais a `EnsureTenantContextAsync`; 107 call sites obsoletos limpos.

## Escopo

### 1. RLS (Row Level Security) — 326 tabelas
- Estratégia: policy `USING (current_schema() = '<tenant_schema>')` (sem session var, sem mudança no middleware)
- Aplicado em todas as tabelas tenant em ambos schemas existentes
- Idempotente em `TenantSchemaService.GetCreateTablesSql` (schemas novos) e `RunIncrementalMigrationsAsync` (schemas existentes)
- POC validou: `SELECT * FROM "tenantA".crm_leads` enquanto `current_schema()=tenantB` → 0 linhas (bloqueado)
- `indiolab_app.rolbypassrls = false` confirmado

### 2. `TenantSearchPathCommandInterceptor`
- Implementa `Microsoft.EntityFrameworkCore.Diagnostics.DbCommandInterceptor`
- Antes de cada comando EF, executa `SET search_path TO "<schema>", public`
- **Sem cache cliente-side** (descoberta importante: Npgsql `DISCARD ALL` no retorno ao pool resetava `search_path` server-side mas cache por `DbConnection` ficava "verde")
- Custo: ~0.1ms por comando (1 round-trip extra)
- Skip: conexão não-Npgsql, sem tenant na request, schema inválido
- Validação anti-SQLi: schema testado contra regex `^\d{11,14}$`

### 3. Cleanup de chamadas obsoletas (107 call sites)
- `EnsureTenantContextAsync` marcado `[Obsolete]` (mantido como fallback no-op)
- 107 `await _context.EnsureTenantContextAsync(...)` removidos de 16 services + 1 seed
- Build: 0 errors, 0 CS0618 warnings (vs 107 antes)

## Arquivos

### Interceptor + DI registration
```
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/MultiTenancy/TenantSearchPathCommandInterceptor.cs  # NEW
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/DependencyInjection.cs                              # registration
```

### `[Obsolete]` markers (compat fallback)
```
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Application/Interfaces/ITenantDbContext.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Persistence/TenantDbContext.cs
```

### TenantSchemaService — RLS aplicada (e índices também, vide F3)
```
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/TenantSchemaService.cs
```

⚠️ Este arquivo tem changes de **F3 (índices)** + **F5 (RLS)**. Se commits forem separados, fazer `git add -p` para escolher hunks. Caso contrário, commitar junto com F3.

### Services com cleanup de 107 call sites
```
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/AtividadeCrmService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/CampanhaService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/ClienteCrmService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/ComodatoService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/ContatoPessoaService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/DashboardService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/EnderecoService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/EtapaPipelineService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/LeadService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/MapaCrmService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/OportunidadeService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/PerfilCrmClienteService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/PessoaService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/RelatorioDespesaService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/VisitaService.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Persistence/Seeds/Crm/CrmSeed.cs
```

⚠️ Esses services também têm changes de **F3** (allowlist sort em alguns). Mesma decisão: commitar junto OU `git add -p`.

## Comando git

### Opção simples (recomendada): commitar F3 + F5 juntos

```bash
# Toda a refatoração + segurança do crm-api num só commit
git add crm.dev.indiolab.com.br/crm-api/src/

git status
git diff --cached --stat
```

### Opção rigorosa (separar F3 e F5)

```bash
# F5 standalone — apenas arquivos exclusivos de multi-tenant security
git add crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/MultiTenancy/ \
        crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/DependencyInjection.cs \
        crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Application/Interfaces/ITenantDbContext.cs \
        crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Persistence/TenantDbContext.cs

# Para Services + TenantSchemaService (mistura F3+F5), usar git add -p para selecionar hunks
git add -p crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/
```

## Mensagem de commit sugerida (F5 standalone)

```
security(crm-api): RLS multi-tenant + search_path interceptor + obsolete cleanup

Defense in depth contra vazamento cross-tenant — 3 camadas independentes
(search_path por request + interceptor + RLS no Postgres).

RLS:
- 326 tabelas tenant com ENABLE ROW LEVEL SECURITY + FORCE
- policy USING (current_schema() = '<tenant_schema>') — sem session var
- aplicado em GetCreateTablesSql (schemas novos) + RunIncrementalMigrationsAsync (existentes)
- indiolab_app.rolbypassrls = false confirmado

Interceptor:
- TenantSearchPathCommandInterceptor : DbCommandInterceptor (Reader/NonQuery/Scalar Executing)
- antes de cada comando EF, executa SET search_path
- SEM cache cliente-side (Npgsql DISCARD ALL no retorno ao pool zera search_path
  server-side mas cache ficava "verde" → bug crítico descoberto e corrigido)
- regex anti-SQLi para schema name (^\d{11,14}$)

Cleanup:
- EnsureTenantContextAsync marcado [Obsolete] (mantido como no-op fallback)
- 107 call sites removidos em 16 services + 1 seed
- build: 0 errors, 0 CS0618 warnings (vs 107 antes)

Custo perf: ~0.1ms extra por comando (round-trip do SET).

Validado:
- POC RLS: SELECT cross-schema bloqueado (0 rows)
- 7/7 endpoints (admin, crm, erp) retornam 200
- frontend CRM /leads carrega sem erros após login
- /health/live + /health/ready OK

Documentado em docs/MULTI_TENANT_SECURITY.md.
```

## Validação pós-commit

```bash
cd crm.dev.indiolab.com.br/crm-api && dotnet build src/IndioLab.Crm.API/IndioLab.Crm.API.csproj
# 0 errors esperado

# Smoke test:
curl -s http://localhost:5070/health/ready  # → 200 Healthy
```
