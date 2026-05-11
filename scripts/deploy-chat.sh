#!/bin/bash
# Deploy isolado — só os containers deste módulo. Não toca outros.
# Uso: ./deploy-MOD.sh [api|web|all]

set -e

MOD="chat"
DOMAIN_FOLDER="${MOD}.dev.indiolab.com.br"
CONTAINER_PREFIX="${MOD}"
[ "$MOD" = "chat" ] && CONTAINER_PREFIX="ichat"

WHICH="${1:-all}"

# Raiz do indiolab-infrastructure (onde está o docker-compose.yml)
INFRA_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# Raiz onde estão os repos dos apps (sibling do indiolab-infrastructure)
WORK_DIR="$(cd "$INFRA_DIR/.." && pwd)"

case "$WHICH" in
  api)
    APP_REPO="${MOD}-api"; [ "$MOD" = "chat" ] && APP_REPO="chat-api"
    REPOS="$WORK_DIR/$DOMAIN_FOLDER/$APP_REPO"
    SERVICES="${MOD}-api"; [ "$MOD" = "chat" ] && SERVICES="ichat-api" ;;
  web)
    APP_REPO="${MOD}-web"; [ "$MOD" = "chat" ] && APP_REPO="chat-web"
    REPOS="$WORK_DIR/$DOMAIN_FOLDER/$APP_REPO"
    SERVICES="${MOD}-web"; [ "$MOD" = "chat" ] && SERVICES="ichat-web" ;;
  all|"")
    REPOS="$WORK_DIR/$DOMAIN_FOLDER/${MOD}-api $WORK_DIR/$DOMAIN_FOLDER/${MOD}-web"
    [ "$MOD" = "chat" ] && REPOS="$WORK_DIR/$DOMAIN_FOLDER/chat-api $WORK_DIR/$DOMAIN_FOLDER/chat-web"
    SERVICES="${MOD}-api ${MOD}-web"
    [ "$MOD" = "chat" ] && SERVICES="ichat-api ichat-web" ;;
  *) echo "Uso: $0 [api|web|all]"; exit 1 ;;
esac

echo "==> [1/4] git pull nos repos do módulo $MOD"
for r in $REPOS; do
  if [ -d "$r/.git" ]; then
    echo "    pull $r"
    git -C "$r" pull --ff-only 2>&1 | tail -1
  else
    echo "    AVISO: $r não existe (clone necessário)"
  fi
done

cd "$INFRA_DIR"

echo "==> [2/4] Pull do indiolab-infrastructure"
git pull --ff-only 2>&1 | tail -1

echo "==> [3/4] Build + recreate: $SERVICES"
docker compose --env-file /opt/indiolab/.env build $SERVICES 2>&1 | tail -3
docker compose --env-file /opt/indiolab/.env up -d --force-recreate --no-deps $SERVICES 2>&1 | tail -3

echo "==> [4/4] Status + smoke"
sleep 6
docker ps --format '{{.Names}} | {{.Status}}' | grep "indiolab-${CONTAINER_PREFIX}-" || true
curl -ksS -o /dev/null -w "  https://${MOD}.dev.indiolab.com.br/login -> %{http_code}\n" \
  "https://${MOD}.dev.indiolab.com.br/login" \
  --resolve "${MOD}.dev.indiolab.com.br:443:127.0.0.1"

echo "✓ deploy $MOD ($WHICH) concluído"
