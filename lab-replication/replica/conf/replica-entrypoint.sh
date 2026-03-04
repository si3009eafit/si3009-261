#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="/var/lib/postgresql/data"
PG_CONF="/etc/postgresql/postgresql.conf"

# Variables de entorno
: "${REPLICA_HOST:?Missing REPLICA_HOST}"
: "${REPLICA_PORT:?Missing REPLICA_PORT}"
: "${REPLICA_USER:?Missing REPLICA_USER}"
: "${REPLICA_PASSWORD:?Missing REPLICA_PASSWORD}"

export PGPASSWORD="${REPLICA_PASSWORD}"

# Si el directorio de datos está vacío, hacemos basebackup del leader
if [ ! -s "${DATA_DIR}/PG_VERSION" ]; then
  echo "[replica] Data directory empty. Performing pg_basebackup from leader..."

  rm -rf "${DATA_DIR:?}/"*

  # Esperar a que el leader acepte conexiones
  echo "[replica] Waiting for leader ${REPLICA_HOST}:${REPLICA_PORT}..."
  until pg_isready -h "${REPLICA_HOST}" -p "${REPLICA_PORT}" -U "${REPLICA_USER}" >/dev/null 2>&1; do
    sleep 1
  done

  # -R: crea automaticamente los archivos de standby (incluye primary_conninfo)
  # -X stream: stream de WAL durante backup
  # -C -S: crea y usa slot (si está permitido y no existe). Si falla, el lab igual funciona sin slot.
  echo "[replica] Running pg_basebackup..."
  pg_basebackup \
    -h "${REPLICA_HOST}" \
    -p "${REPLICA_PORT}" \
    -U "${REPLICA_USER}" \
    -D "${DATA_DIR}" \
    -Fp -Xs -P -R || {
      echo "[replica] pg_basebackup failed. Check leader pg_hba.conf and credentials."
      exit 1
    }

  # (Opcional) En algunos casos conviene fijar explícitamente el slot:
  # echo "primary_slot_name = 'replica_slot_1'" >> "${DATA_DIR}/postgresql.auto.conf"

  chown -R postgres:postgres "${DATA_DIR}"
  chmod 700 "${DATA_DIR}"
fi

echo "[replica] Starting postgres..."
exec gosu postgres postgres -c config_file="${PG_CONF}"