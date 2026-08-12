#!/usr/bin/env bash
set -Eeuo pipefail

MODE="install"
DB_NAME="facturlinex2"
DB_USER="facturlinex"
DB_HOST="localhost"

usage() {
  cat <<'EOF'
Uso:
  flx_verificar_mariadb.sh --check [opciones]
  flx_verificar_mariadb.sh --install [opciones]

Opciones:
  --database N
  --db-user U
  --db-host H

--check:
  No solicita contraseña y no intenta autenticar contra MariaDB.
  Comprueba únicamente que el cliente esté disponible y muestra qué se
  verificará después de la instalación.

--install:
  Solicita contraseña de forma oculta y valida conexión, base y tablas.
EOF
}

need_value() {
  local opt="$1"
  [[ $# -ge 2 ]] || { echo "ERROR: falta valor para $opt" >&2; exit 2; }
}

while (($#)); do
  case "$1" in
    --check) MODE="check"; shift ;;
    --install) MODE="install"; shift ;;
    --database) need_value "$1" "$#"; DB_NAME="$2"; shift 2 ;;
    --db-user) need_value "$1" "$#"; DB_USER="$2"; shift 2 ;;
    --db-host) need_value "$1" "$#"; DB_HOST="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Opción desconocida: $1" >&2; exit 1 ;;
  esac
done

if command -v mariadb >/dev/null 2>&1; then
  MYSQL="$(command -v mariadb)"
elif command -v mysql >/dev/null 2>&1; then
  MYSQL="$(command -v mysql)"
else
  echo "ERROR: falta mariadb/mysql"
  exit 1
fi

echo "============================================================"
echo " FacturLinEx - Verificación MariaDB"
echo "============================================================"
echo "Modo:      $MODE"
echo "Cliente:   $MYSQL"
echo "Servidor:  $DB_HOST"
echo "Base:      $DB_NAME"
echo "Usuario:   $DB_USER"
echo

if [[ "$MODE" == "check" ]]; then
  echo "[OK] Cliente MariaDB/MySQL localizado."
  echo "[PREVISTO] La conexión autenticada se verificará después de --install."
  echo "[PREVISTO] Se comprobarán base, número de tablas y verifactu_queue."
  exit 0
fi

read -rsp "Contraseña de ${DB_USER}@${DB_HOST}: " PASS
echo
[[ -n "$PASS" ]] || { echo "ERROR: contraseña vacía"; exit 1; }

ARGS=("$MYSQL" --protocol=TCP -h "$DB_HOST" -u "$DB_USER" "-p${PASS}")

"${ARGS[@]}" -NBe "SELECT DATABASE();" "$DB_NAME" >/dev/null
TABLES="$("${ARGS[@]}" -NBe \
  "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='${DB_NAME}';")"
VFQ="$("${ARGS[@]}" -NBe \
  "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='${DB_NAME}' AND TABLE_NAME='verifactu_queue';")"

printf '[OK] Conexión correcta\n'
printf '[OK] Base: %s\n' "$DB_NAME"
printf '[OK] Tablas: %s\n' "$TABLES"
if [[ "$VFQ" == "1" ]]; then
  printf '[OK] verifactu_queue existe\n'
else
  printf '[AVISO] verifactu_queue no existe todavía\n'
fi
