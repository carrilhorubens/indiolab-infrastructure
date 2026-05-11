# indiolab-infrastructure

Repositório de infraestrutura/orquestração da plataforma IndioLab.

Contém:
- `docker-compose.yml` — define todos os containers (8 apps + postgres + n8n)
- `nginx/` — configs do reverse proxy
- `scripts/` — scripts de deploy isolados por módulo
- `docs/` — documentação técnica

## Estrutura esperada no disco

Este repo precisa estar **lado a lado** com os 11 repos de código:

```
~/Documents/GitHub/              (ou /opt/indiolab/ no servidor)
├── indiolab-infrastructure/     ← este repo
├── admin.dev.indiolab.com.br/
│   ├── admin-api/               ← clone de github.com/carrilhorubens/admin-api
│   └── admin-web/               ← clone de github.com/carrilhorubens/admin-web
├── chat.dev.indiolab.com.br/
├── crm.dev.indiolab.com.br/
├── erp.dev.indiolab.com.br/
└── shared.dev.indiolab.com.br/
    ├── shared-api/
    ├── shared-ui/
    └── shared-web/
```

## Setup de novo dev

```bash
git clone https://github.com/carrilhorubens/indiolab-infrastructure
cd indiolab-infrastructure
./scripts/bootstrap.sh   # clona os 11 repos como siblings
```

## Deploy

```bash
./scripts/deploy-crm.sh         # api + web do CRM
./scripts/deploy-crm.sh api     # só backend
./scripts/deploy-chat.sh        # idem para chat
./scripts/deploy-admin.sh       # idem
./scripts/deploy-erp.sh         # idem
```

Cada deploy:
1. `git pull` nos repos do módulo
2. `git pull` no indiolab-infrastructure
3. Rebuild + recreate apenas os containers do módulo
4. Smoke test `/login`

## Repos de código (siblings)

| Domínio | API | Web |
|---|---|---|
| admin | [admin-api](https://github.com/carrilhorubens/admin-api) | [admin-web](https://github.com/carrilhorubens/admin-web) |
| chat  | [chat-api](https://github.com/carrilhorubens/chat-api)   | [chat-web](https://github.com/carrilhorubens/chat-web)   |
| crm   | [crm-api](https://github.com/carrilhorubens/crm-api)     | [crm-web](https://github.com/carrilhorubens/crm-web)     |
| erp   | [erp-api](https://github.com/carrilhorubens/erp-api)     | [erp-web](https://github.com/carrilhorubens/erp-web)     |
| shared | [shared-api](https://github.com/carrilhorubens/shared-api), [shared-ui](https://github.com/carrilhorubens/shared-ui), [shared-web](https://github.com/carrilhorubens/shared-web) | |

## Pré-requisitos

- Docker + docker compose v2
- `git`
- `/opt/indiolab/.env` com secrets (não versionado neste repo)
