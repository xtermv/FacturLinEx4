#!/usr/bin/env bash
set -Eeuo pipefail

MODE="check"
DB_NAME="facturlinex2"
DB_USER="facturlinex"
DB_HOST="localhost"
DB_CHARSET="utf8mb4"
DB_COLLATION="utf8mb4_spanish_ci"
SCHEMA_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/sql/facturlinex_schema_zero_data.sql"
MIN_DATA_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/sql/datos_minimos.sql"
T_SHOP_NAME=""
T_SHOP_ADDRESS=""
T_SHOP_CITY=""
T_SHOP_ZIP=""
T_SHOP_PROVINCE=""
T_SHOP_PHONE=""
T_SHOP_FAX=""
T_SHOP_NIF=""
T_SHOP_DB_HOST="localhost"
T_SHOP_DB_PORT="3306"
ROOT_USER="root"
ROOT_HOST="localhost"
ALLOW_EXISTING=0

usage() {
  cat <<USAGE
Uso:
  $0 --check [opciones]
  $0 --install [opciones]

Opciones:
  --database NOMBRE       Base de datos (defecto: facturlinex2)
  --db-user USUARIO       Usuario de aplicación (defecto: facturlinex)
  --db-host HOST          Host permitido para el usuario (defecto: localhost)
  --schema FICHERO        SQL del esquema vacío
  --min-data FICHERO      SQL de datos mínimos
  --shop-name TEXTO       Razón social de la tienda 0
  --shop-address TEXTO    Dirección
  --shop-city TEXTO       Localidad
  --shop-zip TEXTO        Código postal
  --shop-province TEXTO   Provincia
  --shop-phone TEXTO      Teléfono
  --shop-fax TEXTO        Fax (opcional)
  --shop-nif TEXTO        NIF/CIF del obligado
  --shop-db-host HOST     Host BD que se guarda en tiendas.T12
  --shop-db-port PUERTO   Puerto BD que se guarda en tiendas.T13
  --root-user USUARIO     Usuario administrador MariaDB (defecto: root)
  --root-host HOST        Servidor MariaDB (defecto: localhost)
  --allow-existing        Permite continuar si la base ya existe
  -h, --help              Ayuda

Seguridad:
  --check no modifica nada.
  --install solicita las contraseñas de forma oculta y pide confirmación.
  Nunca elimina ni sobrescribe una base existente.
USAGE
}

log(){ printf '%s\n' "$*"; }
fail(){ printf 'ERROR: %s\n' "$*" >&2; exit 1; }
command_exists(){ command -v "$1" >/dev/null 2>&1; }
valid_ident(){ [[ "$1" =~ ^[A-Za-z0-9_]+$ ]]; }

while (($#)); do
  case "$1" in
    --check) MODE="check";;
    --install) MODE="install";;
    --database) shift; DB_NAME="${1:-}";;
    --db-user) shift; DB_USER="${1:-}";;
    --db-host) shift; DB_HOST="${1:-}";;
    --schema) shift; SCHEMA_FILE="${1:-}";;
    --min-data) shift; MIN_DATA_FILE="${1:-}";;
    --shop-name) shift; T_SHOP_NAME="${1:-}";;
    --shop-address) shift; T_SHOP_ADDRESS="${1:-}";;
    --shop-city) shift; T_SHOP_CITY="${1:-}";;
    --shop-zip) shift; T_SHOP_ZIP="${1:-}";;
    --shop-province) shift; T_SHOP_PROVINCE="${1:-}";;
    --shop-phone) shift; T_SHOP_PHONE="${1:-}";;
    --shop-fax) shift; T_SHOP_FAX="${1:-}";;
    --shop-nif) shift; T_SHOP_NIF="${1:-}";;
    --shop-db-host) shift; T_SHOP_DB_HOST="${1:-}";;
    --shop-db-port) shift; T_SHOP_DB_PORT="${1:-}";;
    --root-user) shift; ROOT_USER="${1:-}";;
    --root-host) shift; ROOT_HOST="${1:-}";;
    --allow-existing) ALLOW_EXISTING=1;;
    -h|--help) usage; exit 0;;
    *) fail "Opción desconocida: $1";;
  esac
  shift
done

valid_ident "$DB_NAME" || fail "Nombre de base no válido: $DB_NAME"
valid_ident "$DB_USER" || fail "Usuario no válido: $DB_USER"
[[ "$DB_HOST" =~ ^[A-Za-z0-9._:%-]+$ ]] || fail "Host de usuario no válido"
[[ -f "$SCHEMA_FILE" ]] || fail "No existe el esquema: $SCHEMA_FILE"
[[ -f "$MIN_DATA_FILE" ]] || fail "No existen los datos mínimos: $MIN_DATA_FILE"

MYSQL_BIN=""
if command_exists mariadb; then MYSQL_BIN="$(command -v mariadb)";
elif command_exists mysql; then MYSQL_BIN="$(command -v mysql)";
else fail "No se encuentra el cliente mariadb/mysql. Ejecute primero flx_requisitos.sh --install"; fi

log "============================================================"
log " FacturLinEx 4.2.6 - Preparación MariaDB"
log "============================================================"
log "Modo:             $MODE"
log "Servidor:         $ROOT_HOST"
log "Base:             $DB_NAME"
log "Usuario app:      $DB_USER@$DB_HOST"
log "Esquema:          $SCHEMA_FILE"
log "Datos mínimos:    $MIN_DATA_FILE"
log "Cliente:          $MYSQL_BIN"
log

if [[ "$MODE" == "check" ]]; then
  log "[OK] Cliente MariaDB localizado."
  log "[OK] Fichero de esquema localizado ($(du -h "$SCHEMA_FILE" | awk '{print $1}'))."
  log "[OK] Datos mínimos localizados ($(du -h "$MIN_DATA_FILE" | awk '{print $1}'))."
  log "[INFO] No se ha conectado al servidor ni se ha modificado nada."
  log "[INFO] Para validar credenciales y crear la base use --install en un sistema de pruebas."
  exit 0
fi

read -rsp "Contraseña administrativa de MariaDB para ${ROOT_USER}@${ROOT_HOST}: " ROOT_PASS
echo
read -rsp "Nueva contraseña para ${DB_USER}@${DB_HOST}: " APP_PASS
echo
read -rsp "Repita la contraseña del usuario de aplicación: " APP_PASS2
echo
[[ -n "$APP_PASS" ]] || fail "La contraseña de aplicación no puede estar vacía"
[[ "$APP_PASS" == "$APP_PASS2" ]] || fail "Las contraseñas no coinciden"

# Datos de la tienda 0. Si llegan por parámetros (GUI) no se vuelven a pedir.
if [[ -z "$T_SHOP_NAME" ]]; then read -r -p "Razón social / nombre de la tienda 0: " T_SHOP_NAME; fi
if [[ -z "$T_SHOP_ADDRESS" ]]; then read -r -p "Dirección: " T_SHOP_ADDRESS; fi
if [[ -z "$T_SHOP_CITY" ]]; then read -r -p "Localidad: " T_SHOP_CITY; fi
if [[ -z "$T_SHOP_ZIP" ]]; then read -r -p "Código postal: " T_SHOP_ZIP; fi
if [[ -z "$T_SHOP_PROVINCE" ]]; then read -r -p "Provincia: " T_SHOP_PROVINCE; fi
if [[ -z "$T_SHOP_PHONE" ]]; then read -r -p "Teléfono: " T_SHOP_PHONE; fi
if [[ -z "$T_SHOP_FAX" ]]; then read -r -p "Fax (opcional): " T_SHOP_FAX; fi
if [[ -z "$T_SHOP_NIF" ]]; then read -r -p "NIF/CIF del obligado tributario: " T_SHOP_NIF; fi

[[ -n "$T_SHOP_NAME" ]] || fail "La razón social/nombre de tienda es obligatoria"
[[ -n "$T_SHOP_NIF" ]] || fail "El NIF/CIF es obligatorio"
[[ "$T_SHOP_DB_PORT" =~ ^[0-9]{1,5}$ ]] || fail "Puerto BD no válido"


MYSQL_ADMIN=("$MYSQL_BIN" --protocol=TCP -h "$ROOT_HOST" -u "$ROOT_USER" "-p${ROOT_PASS}")

log "Comprobando acceso administrativo..."
"${MYSQL_ADMIN[@]}" -NBe 'SELECT VERSION();' >/dev/null || fail "No se pudo autenticar en MariaDB"

DB_EXISTS="$("${MYSQL_ADMIN[@]}" -NBe "SELECT COUNT(*) FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='${DB_NAME}';")"
if [[ "$DB_EXISTS" != "0" && "$ALLOW_EXISTING" != "1" ]]; then
  fail "La base ${DB_NAME} ya existe. No se modifica. Use --allow-existing solo tras revisar el caso."
fi

cat <<SUMMARY
Se va a realizar:
  1. Crear la base ${DB_NAME} si no existe.
  2. Crear/actualizar el usuario ${DB_USER}@${DB_HOST}.
  3. Conceder permisos solo sobre ${DB_NAME}.
  4. Importar el esquema vacío únicamente si la base no tenía tablas.
  5. Cargar de forma idempotente los datos mínimos de FacturLinEx.
     - Tienda 0: ${T_SHOP_NAME:-<se solicitará>}
     - Serie inicial: A + dos últimas cifras del año actual.
     - Cliente 999999 / Artículo 9999999999999 / formas de pago / puestos / rutas / tarifas / usuario LINEX.

No se eliminarán bases ni tablas existentes.
SUMMARY
read -r -p "¿Continuar? [s/N] " CONFIRM
[[ "$CONFIRM" =~ ^[sS]$ ]] || { log "Cancelado."; exit 0; }

ESC_APP_PASS=${APP_PASS//\\/\\\\}
ESC_APP_PASS=${ESC_APP_PASS//\'/\'\'}

"${MYSQL_ADMIN[@]}" <<SQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`
  CHARACTER SET ${DB_CHARSET}
  COLLATE ${DB_COLLATION};
CREATE USER IF NOT EXISTS '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${ESC_APP_PASS}';
ALTER USER '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${ESC_APP_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'${DB_HOST}';
FLUSH PRIVILEGES;
SQL

TABLE_COUNT="$("${MYSQL_ADMIN[@]}" -NBe "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='${DB_NAME}';")"
if [[ "$TABLE_COUNT" == "0" ]]; then
  log "Importando esquema vacío..."
  "${MYSQL_ADMIN[@]}" "$DB_NAME" < "$SCHEMA_FILE"
else
  log "[AVISO] La base ya contiene ${TABLE_COUNT} tablas; no se importa el esquema para evitar sobrescrituras."
fi

sql_escape() {
  local v="$1"
  v=${v//\\/\\\\}
  v=${v//\'/\'\'}
  printf "%s" "$v"
}

# Solo cargar datos mínimos si existen las tablas necesarias.
# Los INSERT son idempotentes y no sobrescriben registros existentes.
REQUIRED_MIN_TABLES=(tiendas clientes artitien0000 seriesfactu formapago puestos0000 rutas0000 tarifas usuarios0000)
for T in "${REQUIRED_MIN_TABLES[@]}"; do
  EXISTS_T="$("${MYSQL_ADMIN[@]}" -NBe \
    "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='${DB_NAME}' AND TABLE_NAME='${T}';")"
  [[ "$EXISTS_T" == "1" ]] || fail "Falta la tabla requerida para datos mínimos: ${T}"
done

TMP_MIN="$(mktemp)"
trap 'rm -f "$TMP_MIN"' EXIT
{
  printf "SET @FLX_TIENDA_NOMBRE='%s';\n" "$(sql_escape "$T_SHOP_NAME")"
  printf "SET @FLX_TIENDA_DIRECCION='%s';\n" "$(sql_escape "$T_SHOP_ADDRESS")"
  printf "SET @FLX_TIENDA_LOCALIDAD='%s';\n" "$(sql_escape "$T_SHOP_CITY")"
  printf "SET @FLX_TIENDA_CP='%s';\n" "$(sql_escape "$T_SHOP_ZIP")"
  printf "SET @FLX_TIENDA_PROVINCIA='%s';\n" "$(sql_escape "$T_SHOP_PROVINCE")"
  printf "SET @FLX_TIENDA_TELEFONO='%s';\n" "$(sql_escape "$T_SHOP_PHONE")"
  printf "SET @FLX_TIENDA_FAX='%s';\n" "$(sql_escape "$T_SHOP_FAX")"
  printf "SET @FLX_TIENDA_NIF='%s';\n" "$(sql_escape "$T_SHOP_NIF")"
  printf "SET @FLX_DB_HOST='%s';\n" "$(sql_escape "$T_SHOP_DB_HOST")"
  printf "SET @FLX_DB_PORT='%s';\n" "$(sql_escape "$T_SHOP_DB_PORT")"
  cat "$MIN_DATA_FILE"
} > "$TMP_MIN"

log "Cargando/verificando datos mínimos idempotentes..."
"${MYSQL_ADMIN[@]}" "$DB_NAME" < "$TMP_MIN"

FINAL_TABLES="$("${MYSQL_ADMIN[@]}" -NBe "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='${DB_NAME}';")"
log
log "[OK] Base preparada. Tablas detectadas: ${FINAL_TABLES}"
log "[OK] Usuario de aplicación preparado: ${DB_USER}@${DB_HOST}"
log "[OK] Datos mínimos verificados/cargados de forma idempotente."
log "[INFO] Usuario inicial: LINEX / clave LINEX. Cámbiela tras el primer acceso."
log "No guarde la contraseña en scripts ni historiales de terminal."
