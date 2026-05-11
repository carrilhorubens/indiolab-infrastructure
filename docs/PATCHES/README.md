# Patches segmentados — sessão 2026-05-06

Estratégia para commitar o trabalho desta sessão sem misturar com a reestruturação maior do repo (que está em andamento — deleções massivas de `backend/` + `frontend/` + adição das pastas `admin.dev.indiolab.com.br/`, `crm.dev.indiolab.com.br/` etc).

---

## Por que não rodei `git commit` automaticamente

O working tree contém milhares de arquivos pendentes pré-existentes (deleção da estrutura antiga + estrutura nova `admin.dev.indiolab.com.br/`, etc — toda **untracked**). Um commit "tudo de uma vez" misturaria a reestruturação do projeto com o hardening/refactor desta sessão. Não é profissional.

---

## Frentes (em ordem recomendada de commit)

| # | Patch | Escopo | Risco | Ordem |
|---|---|---|---|---|
| 1 | [`01-admin-app.md`](./01-admin-app.md) | Admin frontend + backend (locale pt-BR, sidebar responsiva, 3-dialog, server-side pagination) | Baixo | Pode ir junto com o resto da reestruturação ou separado |
| 2 | [`02-crm-frontend.md`](./02-crm-frontend.md) | CRM frontend Onda 1 (locale, responsive, EtapasPipeline 3-dialog, slotProps, ReadOnlyField) | Baixo | Pode ir junto com o resto da reestruturação ou separado |
| 3 | [`03-crm-backend-refactor.md`](./03-crm-backend-refactor.md) | CRM backend Onda 2 + 2.5 (ApplySort allowlist, IEntityTypeConfiguration, MeService, ICurrentUserService, health/correlation, índices Postgres, BaseAuditableEntity setters internal) | Médio | Após F1+F2 |
| 4 | [`04-secrets-hardening.md`](./04-secrets-hardening.md) | Rotação de credenciais postgres + role `indiolab_app` + dotnet user-secrets em 4 apis + sanitização de 5 `appsettings.json` + setup-local.sh | **Alto** (operacional, exige rotação prod coordenada) | Standalone — separado |
| 5 | [`05-multi-tenant-security.md`](./05-multi-tenant-security.md) | RLS multi-tenant em 326 tabelas + `TenantSearchPathCommandInterceptor` + cleanup de 107 chamadas obsoletas a `EnsureTenantContextAsync` | Médio | Após F4 |
| 6 | [`06-docs.md`](./06-docs.md) | `docs/SECRETS.md` + `docs/MULTI_TENANT_SECURITY.md` + `docs/PLANO-CORRECAO-ADMIN-FRONTEND.md` | Baixo | Junto com cada frente correspondente OU como commit final unificado |

---

## Como aplicar cada patch

Cada arquivo de manifest tem:
1. **Resumo do escopo**
2. **Lista completa de arquivos** com status (NEW / MODIFIED / DELETED)
3. **Comando `git add`** com paths exatos (copy/paste)
4. **Mensagem de commit sugerida** (HEREDOC pronto)
5. **Pré-condições e validações**

Sequência geral por commit:

```bash
# 1. Stage exatamente os arquivos do manifest
git add <paths from manifest>

# 2. Verificar o que vai ser commitado
git status
git diff --cached --stat

# 3. Commitar com a mensagem sugerida
git commit -m "$(cat <<'EOF'
<mensagem do manifest>
EOF
)"
```

---

## Pendências fora do escopo (Onda 3 — decisão de time)

| Item | Por quê fora |
|---|---|
| `git filter-repo` para limpar `pegasus` do histórico | Operação destrutiva, requer force-push coordenado com time |
| Decisão CQRS direction | Decisão arquitetural, não solo |
| Domínios → `IndioLab.Shared.Domain` | Refactor multi-dia |
| Migrar `ApplicationDbContext` configs | Refactor mecânico, próxima sprint |
| Investigar 2 erros idempotentes pré-existentes em tenant migrations | Não-crítico |

Documentado em [`docs/SECRETS.md`](../SECRETS.md) e [`docs/MULTI_TENANT_SECURITY.md`](../MULTI_TENANT_SECURITY.md).
