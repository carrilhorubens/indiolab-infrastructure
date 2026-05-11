# Patch F6 — Documentation

> 3 documentos novos em `docs/`. Pode ir junto com cada frente correspondente OU como commit final unificado.

## Arquivos

```
docs/SECRETS.md                              # NEW — gerenciamento de credenciais (associado a F4)
docs/MULTI_TENANT_SECURITY.md                # NEW — 3 camadas de defesa (associado a F5)
docs/PLANO-CORRECAO-ADMIN-FRONTEND.md        # NEW — plano admin (associado a F1)
docs/PATCHES/                                # NEW — este diretório (manifests por frente)
```

## Comando git (commit unificado)

```bash
git add docs/SECRETS.md \
        docs/MULTI_TENANT_SECURITY.md \
        docs/PLANO-CORRECAO-ADMIN-FRONTEND.md \
        docs/PATCHES/

git status
git diff --cached --stat
```

## Mensagem de commit sugerida

```
docs: secrets management + multi-tenant security + admin frontend plan

- docs/SECRETS.md: dotnet user-secrets em dev, env vars em prod, rotação,
  procedimento de limpeza de git history (filter-repo)
- docs/MULTI_TENANT_SECURITY.md: 3 camadas de defesa (search_path + interceptor + RLS),
  garantias por cenário de falha, rollback procedure
- docs/PLANO-CORRECAO-ADMIN-FRONTEND.md: plano de correção do admin frontend (5 frentes,
  já executado)
- docs/PATCHES/: manifests por frente desta sessão (segmentação dos commits)
```

## Alternativa: docs com cada frente

Se preferir docs juntos com a frente correspondente:

| Frente | Doc associado |
|---|---|
| F1 (admin) | `docs/PLANO-CORRECAO-ADMIN-FRONTEND.md` |
| F4 (secrets) | `docs/SECRETS.md` |
| F5 (multi-tenant) | `docs/MULTI_TENANT_SECURITY.md` |

`docs/PATCHES/` (este diretório) sempre como último commit (referência cruzada de tudo).
