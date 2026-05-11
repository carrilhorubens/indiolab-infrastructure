#!/usr/bin/env bash
# Restaura backup .dump (custom format) no postgres do container.
# Pré-requisito: container indiolab-postgres rodando.
#
# Uso:
#   ./deploy/scripts/restore-db.sh /caminho/do/opticalcorecombr_<TS>.dump
set -euo pipefail

DUMP="${1:?uso: $0 <path/para/arquivo.dump>}"
DB_NAME="${DB_NAME:-opticalcore}"
PG_USER="${PG_USER:-opticalcore}"
CONTAINER="${CONTAINER:-indiolab-postgres}"

if [ ! -f "$DUMP" ]; then
  echo "ERR: arquivo não encontrado: $DUMP" >&2
  exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER}\$"; then
  echo "ERR: container $CONTAINER não está rodando" >&2
  exit 1
fi

echo "==> copiando dump pra dentro do container"
docker cp "$DUMP" "$CONTAINER:/tmp/restore.dump"

echo "==> drop + recreate database $DB_NAME"
docker exec "$CONTAINER" psql -U "$PG_USER" -d postgres -v ON_ERROR_STOP=1 -c "DROP DATABASE IF EXISTS $DB_NAME WITH (FORCE);"
docker exec "$CONTAINER" psql -U "$PG_USER" -d postgres -v ON_ERROR_STOP=1 -c "CREATE DATABASE $DB_NAME OWNER $PG_USER;"

echo "==> pg_restore (paralelo, 4 jobs)"
docker exec "$CONTAINER" pg_restore \
  -U "$PG_USER" -d "$DB_NAME" \
  --no-owner --no-privileges \
  --jobs=4 --verbose \
  /tmp/restore.dump 2>&1 | tail -30

echo "==> cleanup"
docker exec "$CONTAINER" rm -f /tmp/restore.dump

echo ""
echo "✓ restore concluído. Conferindo:"
docker exec "$CONTAINER" psql -U "$PG_USER" -d "$DB_NAME" -tAc "
SELECT 'schemas: ' || count(*) FROM pg_namespace WHERE nspname NOT LIKE 'pg_%' AND nspname != 'information_schema'
UNION ALL
SELECT 'permissions: ' || count(*) FROM public.permissions
UNION ALL
SELECT 'applications: ' || count(*) FROM public.applications;"
