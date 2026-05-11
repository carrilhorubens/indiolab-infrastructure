# Migração de domínio — `app.indiolab.com.br` → `apli.indiolab.com.br`

> Runbook de cutover. Executar de preferência em janela de baixo tráfego.
> Servidor: `10.1.56.56` (SSH `developer@10.1.56.56 -p 2223`).

---

## Pré-requisito — código

- [x] **Feito localmente neste repo:**
  - 29 arquivos com referências `app.indiolab.com.br` → `apli.indiolab.com.br` (appsettings, Dockerfiles, AuthContexts, docs)
  - 4 diretórios renomeados (`crm/erp/chat/admin.app.` → `.apli.`)
- [ ] **Pendente:** commit + push (decidir escopo junto com o restructure do backend)

## Ordem de execução no servidor

### 1. DNS (AD Microsoft)

- [ ] Adicionar registros A em zona `apli.indiolab.com.br`:
  - `erp`, `crm`, `chat`, `admin`, `auth` → `10.1.56.56`
- [ ] **NÃO remover** ainda a zona `app.indiolab.com.br` — rollback depende dela
- [ ] Verificar resolução: `nslookup erp.apli.indiolab.com.br <dns-interno>`

### 2. Certificado wildcard

- [ ] Copiar `docs/deploy/gerar-cert-wildcard-apli.sh` pro servidor
- [ ] `sudo ./gerar-cert-wildcard-apli.sh`
- [ ] Distribuir `/etc/ssl/apli/ca.crt` pras máquinas dos usuários (ou via GPO no AD)

### 3. Nginx reverse proxy

- [ ] Copiar `docs/deploy/nginx-apli.conf` → `/etc/nginx/sites-available/apli.indiolab.com.br`
- [ ] **Preencher as portas** `<PORT_*>` com os valores do `docker-compose.yml`
- [ ] Criar snippet `/etc/nginx/snippets/apli-tls.conf` (conteúdo no topo do `nginx-apli.conf`)
- [ ] `ln -s /etc/nginx/sites-available/apli.indiolab.com.br /etc/nginx/sites-enabled/`
- [ ] `nginx -t && systemctl reload nginx`
- [ ] **Manter** o vhost antigo `app.indiolab.com.br` ativo em paralelo (rollback)

### 4. Keycloak

Ver `docs/deploy/KEYCLOAK-MIGRACAO-APLI.md`. Resumo:

- [ ] Realm `indiolab` → **Frontend URL** = `https://auth.apli.indiolab.com.br`
- [ ] Containerizado: atualizar `KC_HOSTNAME=auth.apli.indiolab.com.br` no `docker-compose.yml` e `docker compose up -d keycloak`
- [ ] Pros 4 clients (erp-web/crm-web/ichat-web/admin-web): adicionar `https://{app}.apli.indiolab.com.br/*` em **Valid Redirect URIs** e **Web Origins** (somar, não substituir ainda)

### 5. Rebuild containers

Os Dockerfiles têm `ARG VITE_API_URL=https://{app}.apli.indiolab.com.br/api` como default, então build novo já aponta pro domínio certo:

```bash
cd /caminho/do/deploy/apli.indiolab.com.br
git pull                              # após o push das mudanças locais
docker compose build --no-cache \
  erp-web crm-web ichat-web admin-web \
  erp-api crm-api ichat-api admin-api
docker compose up -d
```

- [ ] Verificar logs: `docker compose logs -f --tail=100`
- [ ] Healthcheck: `curl -sk https://erp.apli.indiolab.com.br/nginx-health` deve retornar `ok`

### 6. Validação end-to-end

- [ ] Browser anônimo → https://erp.apli.indiolab.com.br → redireciona pro Keycloak em `auth.apli.` → login OK → dashboard
- [ ] Idem crm / chat / admin
- [ ] DevTools: nenhuma request pro domínio antigo `*.app.indiolab.com.br`
- [ ] Logout funciona (invalida sessão no Keycloak)
- [ ] JWT aud/azp batem com os clients novos

### 7. Depreciar `app.indiolab.com.br`

**Só depois de 24-48h com tudo estável no `apli`:**

- [ ] Remover `https://{app}.app.indiolab.com.br/*` das **Valid Redirect URIs** dos 4 clients
- [ ] Desativar vhosts do `*.app.indiolab.com.br` no nginx (ou fazer redirect 301 → apli)
- [ ] Remover zona DNS `app.indiolab.com.br`
- [ ] Revogar o cert wildcard antigo (se aplicável)

---

## Rollback rápido

Se algo quebrar antes de passo 7:

1. DNS: clientes ainda resolvem `*.app.` → servidor. Nginx antigo ativo. Voltar URL no bookmark.
2. Keycloak: redirect URIs antigas ainda válidas (passo 4). Nenhum usuário perde acesso.
3. Containers: `docker compose` antigo ainda acessível via nome antigo.

---

## Artefatos deste runbook

| Arquivo                                   | Propósito |
|-------------------------------------------|-----------|
| `nginx-apli.conf`                         | Vhosts nginx reverse proxy (5 subdomínios) |
| `gerar-cert-wildcard-apli.sh`             | Gera CA + wildcard self-signed |
| `KEYCLOAK-MIGRACAO-APLI.md`               | Checklist dos 4 clients + realm |
| `MIGRACAO-APLI.md`                        | Este runbook (ordem e validação) |

## TODOs em aberto

- Portas `<PORT_*>` no `nginx-apli.conf` — não consegui descobrir sem ver o `docker-compose.yml` atual do servidor. Me manda o arquivo (ou `docker compose ps`) que eu preencho.
- Nome dos arquivos do cert antigo — se quiser migrar sem quebrar, me diga onde está o `*.app.indiolab.com.br.crt` atual.
- Se o admin-api usa Keycloak service account com client secret, o secret precisa ser rotacionado e refletido no `appsettings.Production.json` (fora do repo).
