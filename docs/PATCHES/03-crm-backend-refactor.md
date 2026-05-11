# Patch F3 — CRM Backend Refactor (Onda 2 + 2.5)

> Refactor de qualidade: ApplySort allowlist, IEntityTypeConfiguration split, MeService clean arch, ICurrentUserService adoption, health/correlation observability, BaseAuditableEntity setters internal. **NÃO inclui** RLS/interceptor (vide F5).

## Escopo

### Segurança (refactor)
- `QueryableExtensions.ApplySort` reescrito — allowlist `IReadOnlyDictionary<string, Expression<Func<T, object>>>` por entidade (anti reflection injection); 10 services adaptados

### Clean Architecture
- `MeController.cs` raw SQL → `IMeService` interface + `MeService` implementation (cross-schema parametrizado)
- `LeadsCrmController.GetUserId()` + `DespesasCrmController` → `ICurrentUserService.UserId`
- `ApplicationDbContext`/`TenantDbContext`: 24 `IEntityTypeConfiguration<T>` em `Persistence/Configurations/Tenant/` (Lead, Oportunidade, Atividade já existiam; +21 novos)

### Observability
- `KeycloakHealthCheck` (NEW) tolerante a dev (4xx → Healthy "issuer alive sem KC server separado")
- `/health/live` (sem deps) + `/health/ready` (postgresql + keycloak) + `/health` legacy
- `CorrelationIdMiddleware` (NEW) — `X-Correlation-Id` header lê/gera/ecoa + Serilog `LogContext`

### Performance (DB)
- 22 índices Postgres em `TenantSchemaService.cs` (pg_trgm GIN + parciais soft-delete + compostos FK) — aplicados em ambos `GetCreateTablesSql` e `RunIncrementalMigrationsAsync`

### Domain
- `BaseAuditableEntity`: setters `CreatedAt/By, UpdatedAt/By, DeletedAt/By` → `internal set`
- Métodos `Activate()`, `Deactivate()`, `MarkAsDeleted(Guid?)`
- `IndioLab.Crm.Domain.csproj` + `InternalsVisibleTo Include="IndioLab.Crm.Infrastructure"`
- 7 controllers de domínio refatorados para usar `MarkAsDeleted()`

### Limpeza
- DELETED: `Migrations/20260327152452_AddSoftDeleteConversa.cs` + `.Designer.cs` (orphan iChat)
- DELETED: `Application/Features/Pessoas/DTOs 2/` (pasta inválida com nome de merge não resolvido)

## Arquivos

### Application
```
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Application/Common/QueryableExtensions.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Application/Interfaces/IMeService.cs              # NEW
```

### Domain
```
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Domain/Common/BaseAuditableEntity.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Domain/IndioLab.Crm.Domain.csproj
```

### API (Controllers + Middlewares + HealthChecks)
```
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/Controllers/MeController.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/Controllers/LeadsCrmController.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/Controllers/DespesasCrmController.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/Controllers/Admin/CompaniesController.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/Controllers/Dominios/DominiosOrigemLeadController.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/Controllers/Dominios/DominiosTipoAtividadeCrmController.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/Controllers/Dominios/DominiosStatusOportunidadeController.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/Controllers/Dominios/DominiosStatusAtividadeCrmController.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/Controllers/Dominios/DominiosStatusVisitaController.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/Controllers/Dominios/DominiosTipoVisitaController.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/Controllers/Dominios/DominiosNivelInteresseController.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/HealthChecks/KeycloakHealthCheck.cs           # NEW
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/Middlewares/CorrelationIdMiddleware.cs        # NEW
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/Program.cs
```

### Infrastructure (configs split + indexes + new MeService)
```
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Persistence/Configurations/Tenant/  # 24 NEW files
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Persistence/QueryableExtensions.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/MeService.cs              # NEW
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/TenantSchemaService.cs    # +índices (RLS está em F5)
```

### DELETIONS
```
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Persistence/Migrations/20260327152452_AddSoftDeleteConversa.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Persistence/Migrations/20260327152452_AddSoftDeleteConversa.Designer.cs
crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Application/Features/Pessoas/DTOs 2/
```

## Comando git

```bash
# Stage tudo de Application/Domain/API/Infrastructure (excluindo MultiTenancy/ que vai em F5)
git add crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Application/ \
        crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Domain/ \
        crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.API/ \
        crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Persistence/ \
        crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/MeService.cs \
        crm.dev.indiolab.com.br/crm-api/src/IndioLab.Crm.Infrastructure/Services/TenantSchemaService.cs

# IMPORTANTE: NÃO incluir nesta etapa:
# - crm-api/src/IndioLab.Crm.Infrastructure/MultiTenancy/  (F5)
# - crm-api/src/IndioLab.Crm.Infrastructure/DependencyInjection.cs  (F5 — interceptor reg)
# - crm-api/src/IndioLab.Crm.Infrastructure/Services/Lead|Oportunidade|... (F5 cleanup obsolete)

git status
git diff --cached --stat
```

⚠️ **Nota:** os 15 services modificados pelo cleanup das 107 chamadas obsoletas a `EnsureTenantContextAsync` ficam em **F5** (multi-tenant security). Esses arquivos têm changes de F3 (allowlist sort) e F5 (cleanup obsolete) misturadas. Considerar:
- **Opção A:** F3 e F5 commitados juntos (mais simples)
- **Opção B:** dividir manualmente por hunk usando `git add -p`

Recomendação: **Opção A** — commitar F3 + F5 juntos com mensagem combinada.

## Mensagem de commit sugerida (F3 standalone)

```
refactor(crm-api): ApplySort allowlist + IEntityTypeConfiguration split + observability + indexes

Application:
- QueryableExtensions.ApplySort com allowlist IReadOnlyDictionary<string, Expression> por entidade (anti reflection-injection); 10 services adaptados
- MeController raw SQL → IMeService + MeService (cross-schema parametrizado)
- LeadsCrmController/DespesasCrmController → ICurrentUserService.UserId

Domain:
- BaseAuditableEntity: setters audit (Created/Updated/DeletedAt/By) → internal set; métodos Activate/Deactivate/MarkAsDeleted
- Domain.csproj: InternalsVisibleTo IndioLab.Crm.Infrastructure
- 7 controllers de domínio usam MarkAsDeleted()

Infrastructure:
- 24 IEntityTypeConfiguration<T> extraídos para Persistence/Configurations/Tenant/
- 22 índices Postgres em TenantSchemaService (pg_trgm GIN + parciais !is_deleted + compostos FK)

Observability:
- KeycloakHealthCheck (tolerante a dev — 4xx → Healthy "issuer sem KC separado")
- /health/live + /health/ready (postgresql + keycloak)
- CorrelationIdMiddleware com Serilog LogContext + echo X-Correlation-Id

Cleanup:
- removida migration órfã 20260327152452_AddSoftDeleteConversa (iChat)
- removida pasta inválida Application/Features/Pessoas/DTOs 2/

Build: 0 errors. dotnet build limpo.
```
