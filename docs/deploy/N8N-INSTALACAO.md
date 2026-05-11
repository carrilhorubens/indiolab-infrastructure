# n8n — Instalação em Produção

> Servidor: `10.1.56.56` · Subdomínio: `https://n8n.apli.indiolab.com.br/`
> Instalado em 2026-04-27. Versão: `n8nio/n8n:latest` (2.17.8 no momento do setup).

---

## Arquitetura

```
┌────────────────────────────────────────────────────────────┐
│  Browser                                                   │
│    └─→ https://n8n.apli.indiolab.com.br/                   │
└──────────────────────┬─────────────────────────────────────┘
                       │ TLS (cert wildcard *.apli.indiolab.com.br)
                       ▼
┌────────────────────────────────────────────────────────────┐
│  nginx (host) — /etc/nginx/sites-enabled/n8n.apli...       │
│    └─→ proxy_pass http://127.0.0.1:5678                    │
└──────────────────────┬─────────────────────────────────────┘
                       │
                       ▼
┌────────────────────────────────────────────────────────────┐
│  Container indiolab-n8n  (network: indiolab_default)       │
│    porta 5678 publicada apenas em 127.0.0.1                │
│    volume: /opt/indiolab/n8n/data → /home/node/.n8n        │
└──────────────────────┬─────────────────────────────────────┘
                       │
                       ▼
┌────────────────────────────────────────────────────────────┐
│  Container indiolab-postgres (postgres:17)                 │
│    database: n8n (owner: opticalcore)                      │
└────────────────────────────────────────────────────────────┘
```

---

## Configuração no docker-compose

Arquivo: `/opt/indiolab/docker-compose.yml` — bloco adicionado após `admin-web`:

```yaml
n8n:
  image: n8nio/n8n:latest
  container_name: indiolab-n8n
  restart: always
  ports:
    - "127.0.0.1:5678:5678"   # apenas localhost — nginx é o entrypoint
  environment:
    DB_TYPE: postgresdb
    DB_POSTGRESDB_HOST: postgres
    DB_POSTGRESDB_PORT: 5432
    DB_POSTGRESDB_DATABASE: n8n
    DB_POSTGRESDB_USER: opticalcore
    DB_POSTGRESDB_PASSWORD: ${POSTGRES_PASSWORD}
    N8N_ENCRYPTION_KEY: ${N8N_ENCRYPTION_KEY}
    N8N_HOST: n8n.apli.indiolab.com.br
    N8N_PORT: 5678
    N8N_PROTOCOL: https
    WEBHOOK_URL: https://n8n.apli.indiolab.com.br/
    N8N_EDITOR_BASE_URL: https://n8n.apli.indiolab.com.br/
    N8N_PROXY_HOPS: "1"
    GENERIC_TIMEZONE: America/Sao_Paulo
    TZ: America/Sao_Paulo
    N8N_DIAGNOSTICS_ENABLED: "false"
  volumes:
    - /opt/indiolab/n8n/data:/home/node/.n8n
  depends_on:
    postgres:
      condition: service_healthy
```

`/opt/indiolab/.env` recebeu a variável `N8N_ENCRYPTION_KEY` (gerada com `openssl rand -hex 32`).

---

## nginx vhost

Arquivo: `/etc/nginx/sites-available/n8n.apli.indiolab.com.br` (link em `sites-enabled`).

Pontos críticos:
- **WebSocket**: `proxy_set_header Upgrade $http_upgrade; proxy_set_header Connection "upgrade";` — necessário para o editor de workflows e execução em tempo real.
- **Timeouts longos** (`proxy_read_timeout 600s`): workflows e webhooks podem demorar.
- **`client_max_body_size 100M`**: uploads de binary data.
- TLS com cert wildcard `*.apli.indiolab.com.br` (já existe em `/etc/nginx/ssl/`).

---

## Banco de dados

Database `n8n` no Postgres compartilhado:

```sql
-- Já criado na instalação:
CREATE DATABASE n8n OWNER opticalcore;
```

n8n criou ~76 tabelas no schema `public` durante o primeiro start (migrations automáticas).

---

## ⚠️ Encryption Key — backup obrigatório

A variável `N8N_ENCRYPTION_KEY` no `.env` é usada para criptografar **todos os credentials** (API keys, OAuth tokens, senhas) que workflows armazenam. Sem essa chave, após restore os credentials ficam ilegíveis.

**Onde está**: `/opt/indiolab/.env` linha `N8N_ENCRYPTION_KEY=...`

**Backup**: incluir o `.env` em qualquer rotina de backup do servidor. Guardar uma cópia offline (cofre / vault corporativo).

---

## Backup

| O que | Caminho | Frequência sugerida |
|---|---|---|
| Banco | `pg_dump n8n` (container `indiolab-postgres`) | Diária |
| Volume (binary data, runners) | `/opt/indiolab/n8n/data` | Diária |
| Encryption key | `/opt/indiolab/.env` | Junto com primeiro backup, e a cada alteração |
| Compose | `/opt/indiolab/docker-compose.yml` | Já versionado neste repo |

Comando de dump rápido:
```bash
sudo docker exec indiolab-postgres pg_dump -U opticalcore -F c -d n8n > n8n-$(date +%F).dump
```

---

## DNS

`n8n.apli.indiolab.com.br` deve resolver para `10.1.56.56`:
- DNS interno (10.1.10.10): **adicionar registro A** apontando para `10.1.56.56` se ainda não existir.
- `/etc/hosts` do servidor: já tem `127.0.0.1 n8n.apli.indiolab.com.br` para uso interno.

---

## Operação

```bash
# Status
sudo docker ps --filter name=indiolab-n8n
sudo docker logs indiolab-n8n --tail 50

# Reiniciar
cd /opt/indiolab && sudo docker compose restart n8n

# Atualizar versão (puxa latest e recria)
cd /opt/indiolab && sudo docker compose pull n8n && sudo docker compose up -d n8n

# nginx
sudo nginx -t && sudo systemctl reload nginx

# Teste local rápido
curl -ks --resolve n8n.apli.indiolab.com.br:443:127.0.0.1 https://n8n.apli.indiolab.com.br/healthz
# Esperado: {"status":"ok"}
```

---

## Primeiro acesso

1. Abrir `https://n8n.apli.indiolab.com.br/` no navegador (na intranet).
2. n8n exibirá a tela de **setup do owner** — criar usuário admin, senha forte, email.
3. A partir daí, novos usuários são convidados pelo painel `Settings → Users`.

---

## Pendências e melhorias futuras

- **SSO via Keycloak**: integração OIDC com o realm `indiolab` (n8n suporta SSO em edição Enterprise; community usa basic auth interno).
- **Queue mode + Redis**: necessário se o número de execuções concorrentes crescer significativamente (hoje single-instance é mais que suficiente).
- **External task runners**: o container atual não tem Python — só JS task runner. Se precisar Python, configurar runner externo (`docs.n8n.io/hosting/configuration/task-runners/`).

---

## Histórico

- **2026-04-27**: instalação inicial. n8n previamente rodava standalone (SQLite, sem encryption key explícita); foi removido sem perda (0 workflows) e recriado via compose com Postgres + key gerenciada no `.env`. Vhost nginx criado. Backup do compose anterior em `/opt/indiolab/docker-compose.yml.bak-pre-n8n-20260427-111008`.
