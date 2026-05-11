#!/bin/bash
# bootstrap.sh — clona os 11 repos IndioLab na estrutura correta.
#
# Uso: ./bootstrap.sh
# Precisa ser rodado de DENTRO da pasta indiolab-infrastructure/scripts/.
# Vai criar/clonar os repos como SIBLINGS de indiolab-infrastructure/.

set -e

INFRA_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WORK_DIR="$(cd "$INFRA_DIR/.." && pwd)"

REPOS=(
  "admin.dev.indiolab.com.br:admin-api"
  "admin.dev.indiolab.com.br:admin-web"
  "chat.dev.indiolab.com.br:chat-api"
  "chat.dev.indiolab.com.br:chat-web"
  "crm.dev.indiolab.com.br:crm-api"
  "crm.dev.indiolab.com.br:crm-web"
  "erp.dev.indiolab.com.br:erp-api"
  "erp.dev.indiolab.com.br:erp-web"
  "shared.dev.indiolab.com.br:shared-api"
  "shared.dev.indiolab.com.br:shared-ui"
  "shared.dev.indiolab.com.br:shared-web"
)

cd "$WORK_DIR"
for entry in "${REPOS[@]}"; do
  parent="${entry%%:*}"
  repo="${entry##*:}"
  mkdir -p "$parent"
  if [ -d "$parent/$repo/.git" ]; then
    echo "==> $parent/$repo (já existe, pull)"
    git -C "$parent/$repo" pull --ff-only 2>&1 | tail -1
  else
    echo "==> clone $parent/$repo"
    git clone "https://github.com/carrilhorubens/$repo" "$parent/$repo" 2>&1 | tail -2
  fi
done

echo ""
echo "✓ bootstrap concluído. Estrutura criada em $WORK_DIR/"
