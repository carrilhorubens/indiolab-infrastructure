# Shared Dev Server — `10.1.56.56`

> Este servidor é o **único ambiente compartilhado** para desenvolvimento da plataforma IndioLab. Hospeda o stack que serve `*.dev.indiolab.com.br` e é editado por 2-3 devs simultaneamente via VSCode Remote-SSH.

## Ambiente

| Item | Valor |
|---|---|
| Host | `10.1.56.56` (LAN interna `10.x`) |
| SSH | `ssh developer@10.1.56.56 -p 2223` |
| Sudo password | `pegasus` |
| Repo compartilhado | `/opt/indiolab/repo` (group-writable, grupo `developers`) |
| Stack runtime | Docker compose em `/opt/indiolab/repo/deploy/compose/` |
| Secrets | `/opt/indiolab/.env` (não versionado) |
| URLs | `{erp,crm,chat,admin,n8n}.dev.indiolab.com.br` |

## Acesso (de qualquer Mac na rede 10.x)

### 1. SSH key no servidor

Cada dev tem seu próprio par SSH no Mac. A public key precisa estar em `/home/developer/.ssh/authorized_keys` no servidor.

**Adicionar uma nova chave:**
```bash
# Do Mac do novo dev:
cat ~/.ssh/id_ed25519.pub
# Copiar saída

# Login do admin (você) no servidor:
ssh developer@10.1.56.56 -p 2223
nano ~/.ssh/authorized_keys
# Cola a chave em uma linha nova, salva
```

### 2. VSCode Remote-SSH

1. Instalar extensão **Remote - SSH** no VSCode
2. `Cmd+Shift+P` → **Remote-SSH: Connect to Host** → `developer@10.1.56.56:2223`
3. Em File → Open Folder → `/opt/indiolab/repo`
4. Pronto — editor está rodando no servidor, você edita como se fosse local

### 3. Git author por sessão (importante — 1 Linux user, N devs)

Como **todos os devs usam o mesmo Linux user `developer`**, `~/.gitconfig` é compartilhado. Sem ajuste, qualquer commit aparece com o mesmo autor.

**Solução**: cada dev exporta seu autor no terminal **da sessão**:

```bash
# No terminal do VSCode (ou .bashrc/.zshrc local do Mac via SSH)
export GIT_AUTHOR_NAME="Rubens Carrilho"
export GIT_AUTHOR_EMAIL="rubens@indiolab.com.br"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
```

Faça isso **uma vez por sessão** (sumir quando fechar o terminal — força a setar de novo, evitando atribuição errada).

**Atalho**: salvar como alias no Mac, em `~/.ssh/config`:
```
Host indiolab-dev
  HostName 10.1.56.56
  User developer
  Port 2223
  RemoteCommand export GIT_AUTHOR_NAME="..." GIT_AUTHOR_EMAIL="..."; bash
```

A SSH key do servidor (`~/.ssh/id_ed25519_github`) já está cadastrada na conta GitHub `carrilhorubens` — basta usar.

## Workflow git

Como o repo **é compartilhado**, dois devs editando o **mesmo arquivo** ao mesmo tempo causa conflito. Convenções:

1. **Branches separadas por feature**: nunca commit direto em `main`
2. **Pull antes de começar**: `git pull origin main` (no monorepo + `git submodule update --remote`)
3. **Fast-forward only**: `git pull --ff-only` (evita merge commits acidentais)
4. **Comunicar no Slack/Discord** quando começar a mexer em arquivo grande

### Comandos do dia a dia

```bash
# Atualizar repo + submódulos
cd /opt/indiolab/repo
git pull --ff-only
git submodule update --remote --merge

# Trabalhar em uma feature (no submódulo do app)
cd /opt/indiolab/repo/erp.dev.indiolab.com.br/erp-api
git checkout -b feat/nova-coisa
# ... edita ...
git add . && git commit -m "feat: nova coisa"
git push origin feat/nova-coisa

# Aplicar suas mudanças no stack rodando
cd /opt/indiolab/repo
./deploy/scripts/deploy.sh    # rebuild + restart só do que mudou
```

## Aplicar no stack

```bash
cd /opt/indiolab/repo
./deploy/scripts/deploy.sh
```

Idempotente: rebuilda imagens cujo Dockerfile/source mudou, recria containers afetados. **Qualquer dev** do grupo `developers` pode rodar.

## Hot-reload (opcional, sem Docker)

Pra iteração rápida em uma única API/frontend, sem rebuild de imagem:

```bash
# Matar o container production daquele app
docker stop indiolab-erp-api

# Rodar a API direto no host (a porta 5050 fica livre)
cd /opt/indiolab/repo/erp.dev.indiolab.com.br/erp-api/src/IndioLab.Erp.API
ASPNETCORE_ENVIRONMENT=Development dotnet watch run --urls http://+:5050

# Ou frontend (porta 3001 livre, vite dev server)
cd /opt/indiolab/repo/erp.dev.indiolab.com.br/erp-web
npm run dev -- --host 0.0.0.0 --port 3001
```

Nginx continua fazendo proxy pras mesmas portas — sem mudança no domínio. Quando terminar, reverte:
```bash
docker start indiolab-erp-api
```

## Diagnóstico

```bash
# Containers
docker compose -f /opt/indiolab/repo/deploy/compose/docker-compose.yml ps

# Logs de um app
docker logs -f --tail=200 indiolab-erp-api

# Health do postgres
docker exec indiolab-postgres pg_isready -U opticalcore

# Smoke HTTPS
curl -k -o /dev/null -w "%{http_code}\n" https://erp.dev.indiolab.com.br
```

## Adicionar novo dev (checklist)

1. [ ] Pega public SSH key do dev (Mac dele: `cat ~/.ssh/id_ed25519.pub`)
2. [ ] Adiciona em `~/.ssh/authorized_keys` do user `developer` (uma linha por chave)
3. [ ] Dev testa: `ssh developer@10.1.56.56 -p 2223`
4. [ ] Dev exporta `GIT_AUTHOR_*` em sua sessão (ver seção "Git author por sessão")
5. [ ] Dev abre `/opt/indiolab/repo` no VSCode Remote-SSH
6. [ ] Dev faz checkout de uma branch e push de teste

> **Auditoria mínima**: como o Linux user é o mesmo, a única forma de saber quem commitou é via `GIT_AUTHOR_*` na sessão. Se isso não estiver setado, todos os commits aparecem como o mesmo autor (último que commitou via `git config --global`). Reforce essa disciplina entre os devs.

## Convenções

- **Branches**: `feat/<área>-<descrição-curta>`, `fix/<bug>`, `chore/<tarefa>`
- **Main protegida**: PR review antes de merge (ainda manual; podemos adicionar branch protection no GitHub)
- **DB compartilhado**: schema changes precisam ser coordenadas — quem rodar migration nova avisa antes
- **`.env` é sagrado**: não commitar, não logar valores em chat
