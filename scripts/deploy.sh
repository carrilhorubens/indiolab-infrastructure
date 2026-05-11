#!/usr/bin/env bash
# Deploy script — pull, build, up
# Idempotente: pode ser executado múltiplas vezes.
#
# Pré-requisitos no servidor:
#   - /opt/indiolab/repo/ (git clone)
#   - /opt/indiolab/.env  (copiado de deploy/compose/.env.example e preenchido)
#   - docker + docker compose v2
#
# Uso (no servidor): cd /opt/indiolab/repo && ./deploy/scripts/deploy.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ENV_FILE="${ENV_FILE:-/opt/indiolab/.env}"
COMPOSE_FILE="$REPO_ROOT/deploy/compose/docker-compose.yml"

echo "==> repo: $REPO_ROOT"
echo "==> env:  $ENV_FILE"
echo "==> compose: $COMPOSE_FILE"

if [ ! -f "$ENV_FILE" ]; then
  echo "ERR: $ENV_FILE não existe. Copie deploy/compose/.env.example e preencha." >&2
  exit 1
fi

echo "==> garantindo dirs de dados"
sudo mkdir -p /opt/indiolab/data/{postgres,n8n,uploads/erp,uploads/ichat}

echo "==> git pull (--ff-only)"
cd "$REPO_ROOT"
git pull --ff-only

echo "==> build images"
docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" build --pull

echo "==> up -d (recreate as needed)"
docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" up -d --remove-orphans

echo "==> aguardando postgres healthy"
for i in $(seq 1 30); do
  if docker exec indiolab-postgres pg_isready -U opticalcore >/dev/null 2>&1; then
    echo "    postgres ready (try $i)"
    break
  fi
  sleep 2
done

echo ""
echo "==> status final"
docker compose -f "$COMPOSE_FILE" ps
echo ""
echo "✓ deploy concluído"
