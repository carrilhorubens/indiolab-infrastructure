#!/bin/bash
# bootstrap.sh — clona os 11 repos IndioLab na estrutura correta.
#
# Uso:
#   ./bootstrap.sh                          # WORK_DIR = /opt/indiolab (default)
#   INDIOLAB_ROOT=~/work ./bootstrap.sh     # WORK_DIR custom
#
# Estrutura criada (em WORK_DIR):
#   <WORK_DIR>/admin.dev.indiolab.com.br/{admin-api,admin-web}
#   <WORK_DIR>/chat.dev.indiolab.com.br/{chat-api,chat-web}
#   <WORK_DIR>/crm.dev.indiolab.com.br/{crm-api,crm-web}
#   <WORK_DIR>/erp.dev.indiolab.com.br/{erp-api,erp-web}
#   <WORK_DIR>/shared.dev.indiolab.com.br/{shared-api,shared-ui,shared-web}

set -e

WORK_DIR="${INDIOLAB_ROOT:-/opt/indiolab}"

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

echo "==> WORK_DIR = $WORK_DIR"
mkdir -p "$WORK_DIR"
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
