#!/usr/bin/env bash
set -Eeuo pipefail

MODE="check"
CONFIG_DEST="/etc/facturlinex2/FacturConf.ini"
APP_CONFIG_DIR="/etc/facturlinex2"
APP_USER="${SUDO_USER:-${USER}}"
DB_HOST="127.0.0.1"
DB_PORT="3306"
DB_NAME="facturlinex2"
DB_USER="facturlinex"
VF_MODE="PRUEBAS"
OPENSSL_PATH=""
CERT_P12=""
CERT_PEM=""
KEY_PEM=""
CA_FILE=""

usage() {
  cat <<'EOF'
Uso:
  flx_configurar_facturlinex.sh --check [opciones]
  sudo flx_configurar_facturlinex.sh --install [opciones]

Opciones:
  --config PATH          Destino de FacturConf.ini
  --app-user USUARIO     Usuario que ejecutará FacturLinEx
  --db-host HOST
  --db-port PUERTO
  --db-name BASE
  --db-user USUARIO
  --vf-mode MODO         PRUEBAS o PRODUCCION
  --openssl PATH         Ruta explícita; vacío = detección por PATH
  --cert-p12 PATH
  --cert-pem PATH
  --key-pem PATH
  --ca-file PATH

La contraseña de la base de datos se solicita de forma oculta en --install.
Nunca se incluye en la línea de comandos ni en el historial del shell.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check) MODE="check"; shift ;;
    --install) MODE="install"; shift ;;
    --config) CONFIG_DEST="$2"; shift 2 ;;
    --app-user) APP_USER="$2"; shift 2 ;;
    --db-host) DB_HOST="$2"; shift 2 ;;
    --db-port) DB_PORT="$2"; shift 2 ;;
    --db-name) DB_NAME="$2"; shift 2 ;;
    --db-user) DB_USER="$2"; shift 2 ;;
    --vf-mode) VF_MODE="${2^^}"; shift 2 ;;
    --openssl) OPENSSL_PATH="$2"; shift 2 ;;
    --cert-p12) CERT_P12="$2"; shift 2 ;;
    --cert-pem) CERT_PEM="$2"; shift 2 ;;
    --key-pem) KEY_PEM="$2"; shift 2 ;;
    --ca-file) CA_FILE="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Opción desconocida: $1" >&2; usage; exit 2 ;;
  esac
done

if [[ "$VF_MODE" != "PRUEBAS" && "$VF_MODE" != "PRODUCCION" ]]; then
  echo "ERROR: --vf-mode debe ser PRUEBAS o PRODUCCION." >&2
  exit 2
fi

resolve_openssl() {
  if [[ -n "$OPENSSL_PATH" && -x "$OPENSSL_PATH" ]]; then
    printf '%s' "$OPENSSL_PATH"; return
  fi
  command -v openssl 2>/dev/null || true
}

OPENSSL_RESOLVED="$(resolve_openssl)"

echo "============================================================"
echo " FacturLinEx 4.2.6 - Configuración inicial"
echo "============================================================"
echo "Modo de operación : $MODE"
echo "Destino           : $CONFIG_DEST"
echo "Usuario aplicación: $APP_USER"
echo "MariaDB           : $DB_USER@$DB_HOST:$DB_PORT/$DB_NAME"
echo "VeriFactu         : $VF_MODE"
echo "OpenSSL           : ${OPENSSL_RESOLVED:-NO LOCALIZADO}"
echo

check_file() {
  local label="$1" path="$2" required="$3"
  if [[ -z "$path" ]]; then
    if [[ "$required" == "yes" ]]; then
      echo "[AVISO] $label no configurado."
    else
      echo "[INFO ] $label no configurado."
    fi
  elif [[ -f "$path" ]]; then
    echo "[ OK  ] $label: $path"
  else
    echo "[ERROR] $label no existe: $path"
  fi
}

[[ -n "$OPENSSL_RESOLVED" ]] && echo "[ OK  ] OpenSSL localizado." || echo "[ERROR] OpenSSL no localizado."
check_file "Certificado P12" "$CERT_P12" "no"
check_file "Certificado PEM" "$CERT_PEM" "no"
check_file "Clave privada PEM" "$KEY_PEM" "no"
check_file "Cadena CA" "$CA_FILE" "no"

if [[ "$MODE" == "check" ]]; then
  if [[ -f "$CONFIG_DEST" ]]; then
    echo "[INFO ] Ya existe una configuración; no será sobrescrita automáticamente."
  else
    echo "[INFO ] La configuración se crearía durante --install."
  fi
  exit 0
fi

if [[ $EUID -ne 0 ]]; then
  echo "ERROR: --install debe ejecutarse con sudo." >&2
  exit 1
fi

if ! id "$APP_USER" >/dev/null 2>&1; then
  echo "ERROR: el usuario $APP_USER no existe." >&2
  exit 1
fi

if [[ -f "$CONFIG_DEST" ]]; then
  BACKUP="${CONFIG_DEST}.bak.$(date +%Y%m%d_%H%M%S)"
  cp -a "$CONFIG_DEST" "$BACKUP"
  echo "Copia de seguridad creada: $BACKUP"
fi

read -r -s -p "Contraseña del usuario MariaDB '$DB_USER': " DB_PASSWORD
echo
if [[ -z "$DB_PASSWORD" ]]; then
  echo "ERROR: la contraseña no puede quedar vacía." >&2
  exit 1
fi

install -d -m 0750 -o root -g "$APP_USER" "$APP_CONFIG_DIR"

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

cat > "$TMP" <<EOF
[BaseDatos]
Host=$DB_HOST
Puerto=$DB_PORT
BaseDatos=$DB_NAME
Usuario=$DB_USER
Password=$DB_PASSWORD

[VeriFactu]
Modo=$VF_MODE
OpenSSLPath=$OPENSSL_RESOLVED
CertificadoP12=$CERT_P12
CertificadoPEM=$CERT_PEM
ClavePEM=$KEY_PEM
CAFile=$CA_FILE

[Aplicacion]
RutaDatos=/usr/share/facturlinex2
RutaInformes=/usr/share/facturlinex2/Report
RutaDocumentacion=/usr/share/facturlinex2/Documentacion
EOF

install -m 0640 -o root -g "$APP_USER" "$TMP" "$CONFIG_DEST"
echo "[ OK  ] Configuración instalada en $CONFIG_DEST"
echo "[INFO ] Revise los nombres exactos de las claves con la configuración estable antes de producción."
