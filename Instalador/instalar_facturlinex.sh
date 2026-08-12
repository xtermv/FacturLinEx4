#!/usr/bin/env bash
set -Eeuo pipefail

MODE="check"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BINARY=""
ICON=""
CONFIG=""
APP_USER="${SUDO_USER:-${USER}}"
LOG_DIR="/var/log/facturlinex2"
LOG_FILE=""
SKIP_DB=0
SKIP_SUDOERS=0
ASSUME_YES=0
DEFER_FIRST_RUN=0
VF_MODE="PRUEBAS"
SHOP_NAME=""
SHOP_ADDRESS=""
SHOP_CITY=""
SHOP_ZIP=""
SHOP_PROVINCE=""
SHOP_PHONE=""
SHOP_FAX=""
SHOP_NIF=""
SHOP_DB_HOST="localhost"
SHOP_DB_PORT="3306"
DB_NAME="facturlinex2"
DB_USER="facturlinex"

usage() {
  cat <<'EOF'
Instalador maestro FacturLinEx 4.2.6

Uso:
  instalar_facturlinex.sh --check [opciones]
  sudo instalar_facturlinex.sh --install [opciones]

Opciones:
  --source DIR         Raíz del paquete de instalación.
  --binary PATH        Binario FacturLinEx.
  --icon PATH          Icono PNG.
  --config PATH        FacturConf.ini inicial, opcional.
  --app-user USUARIO   Usuario que ejecutará FacturLinEx.
  --vf-mode MODO       PRUEBAS o PRODUCCION.
  --shop-name TEXTO     Razón social/nombre de la tienda 0.
  --shop-address TEXTO  Dirección de la tienda.
  --shop-city TEXTO     Localidad.
  --shop-zip TEXTO      Código postal.
  --shop-province TEXTO Provincia.
  --shop-phone TEXTO    Teléfono.
  --shop-fax TEXTO      Fax opcional.
  --shop-nif TEXTO      NIF/CIF del obligado.
  --shop-db-host HOST   Host BD guardado en la tienda (defecto localhost).
  --shop-db-port PORT   Puerto BD guardado en la tienda (defecto 3306).
  --db-name NOMBRE      Nombre de la base de datos (defecto facturlinex2).
  --db-user USUARIO     Usuario de la base de datos (defecto facturlinex).
  --skip-db             No preparar MariaDB.
  --skip-sudoers        No instalar auxiliares/sudoers.
  --yes                 No pedir confirmaciones internas.
  --defer-first-run     Dejar BBDD y FacturConf.ini para el primer inicio de FacturLinEx.
  -h, --help

El modo --check no modifica el sistema.
El modo --install requiere sudo y solicita confirmación antes de empezar.
EOF
}

need_value() {
  local opt="$1"
  local remaining="$2"
  if [[ "$remaining" -lt 2 ]]; then
    echo "ERROR: falta valor para ${opt}" >&2
    exit 2
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check) MODE="check"; shift ;;
    --install) MODE="install"; shift ;;
    --source) need_value "--source" "$#"; SOURCE_DIR="$2"; shift 2 ;;
    --binary) need_value "--binary" "$#"; BINARY="$2"; shift 2 ;;
    --icon) ICON="$2"; shift 2 ;;
    --config) CONFIG="$2"; shift 2 ;;
    --app-user) need_value "--app-user" "$#"; APP_USER="$2"; shift 2 ;;
    --vf-mode) need_value "--vf-mode" "$#"; VF_MODE="${2^^}"; shift 2 ;;
    --shop-name) need_value "--shop-name" "$#"; SHOP_NAME="$2"; shift 2 ;;
    --shop-address) need_value "--shop-address" "$#"; SHOP_ADDRESS="$2"; shift 2 ;;
    --shop-city) need_value "--shop-city" "$#"; SHOP_CITY="$2"; shift 2 ;;
    --shop-zip) need_value "--shop-zip" "$#"; SHOP_ZIP="$2"; shift 2 ;;
    --shop-province) need_value "--shop-province" "$#"; SHOP_PROVINCE="$2"; shift 2 ;;
    --shop-phone) need_value "--shop-phone" "$#"; SHOP_PHONE="$2"; shift 2 ;;
    --shop-fax) need_value "--shop-fax" "$#"; SHOP_FAX="$2"; shift 2 ;;
    --shop-nif) need_value "--shop-nif" "$#"; SHOP_NIF="$2"; shift 2 ;;
    --shop-db-host) need_value "--shop-db-host" "$#"; SHOP_DB_HOST="$2"; shift 2 ;;
    --shop-db-port) need_value "--shop-db-port" "$#"; SHOP_DB_PORT="$2"; shift 2 ;;
    --db-name) need_value "--db-name" "$#"; DB_NAME="$2"; shift 2 ;;
    --db-user) need_value "--db-user" "$#"; DB_USER="$2"; shift 2 ;;
    --skip-db) SKIP_DB=1; shift ;;
    --skip-sudoers) SKIP_SUDOERS=1; shift ;;
    --yes) ASSUME_YES=1; shift ;;
    --defer-first-run) DEFER_FIRST_RUN=1; SKIP_DB=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Opción desconocida: $1" >&2; usage; exit 2 ;;
  esac
done

[[ "$VF_MODE" == "PRUEBAS" || "$VF_MODE" == "PRODUCCION" ]] || {
  echo "ERROR: --vf-mode debe ser PRUEBAS o PRODUCCION." >&2
  exit 2
}

SCRIPT_DIR="$SOURCE_DIR/Instalador"
[[ -n "$BINARY" ]] || BINARY="$SOURCE_DIR/Bin/FacturLinEx"
[[ -n "$ICON" ]] || ICON="$SOURCE_DIR/facturLinex2-ico.png"

STEPS=(
  "Requisitos del sistema"
  "Preparación de directorios"
  "Instalación de archivos"
  "Preparación de MariaDB"
  "Configuración inicial"
  "Scripts auxiliares y sudoers"
  "Verificación final"
)

TOTAL=${#STEPS[@]}
CURRENT=0

progress() {
  local label="$1"
  CURRENT=$((CURRENT + 1))
  local pct=$(( CURRENT * 100 / TOTAL ))
  printf '\n[%d/%d] %3d%% - %s\n' "$CURRENT" "$TOTAL" "$pct" "$label"
  printf '%*s\n' 72 '' | tr ' ' '-'
}

require_script() {
  local script="$1"
  if [[ ! -f "$SCRIPT_DIR/$script" ]]; then
    echo "ERROR: falta el script: $SCRIPT_DIR/$script" >&2
    exit 1
  fi
}

for s in \
  flx_requisitos.sh \
  flx_preparar_directorios.sh \
  flx_instalar_archivos.sh \
  flx_preparar_mariadb.sh \
  flx_configurar_facturlinex.sh \
  flx_verificar_instalacion.sh; do
  require_script "$s"
done

if [[ "$MODE" == "install" && $EUID -ne 0 ]]; then
  echo "ERROR: --install requiere sudo." >&2
  exit 1
fi

if [[ "$MODE" == "install" ]]; then
  install -d -m 0755 "$LOG_DIR"
  LOG_FILE="$LOG_DIR/install_$(date +%Y%m%d_%H%M%S).log"
  exec > >(tee -a "$LOG_FILE") 2>&1
else
  LOG_FILE="$SOURCE_DIR/install_check_$(date +%Y%m%d_%H%M%S).log"
  exec > >(tee -a "$LOG_FILE") 2>&1
fi

on_error() {
  local code=$?
  echo
  echo "============================================================"
  echo "INSTALACIÓN INTERRUMPIDA"
  echo "Paso: ${STEPS[$((CURRENT>0 ? CURRENT-1 : 0))]}"
  echo "Código: $code"
  echo "Log: $LOG_FILE"
  echo "No se continuará con las fases posteriores."
  echo "============================================================"
  exit "$code"
}
trap on_error ERR

echo "============================================================"
echo " INSTALADOR FACTURLINEX 4.2.6J"
echo "============================================================"
echo "Modo       : $MODE"
echo "Origen     : $SOURCE_DIR"
echo "Binario    : $BINARY"
echo "Usuario    : $APP_USER"
echo "VeriFactu  : $VF_MODE"
echo "Base datos  : $DB_NAME"
echo "Usuario BD   : $DB_USER"
[[ $DEFER_FIRST_RUN -eq 1 ]] && echo "Primera config: DIFERIDA A FACTURLINEX"
if [[ $SKIP_DB -eq 0 ]]; then
  echo "Tienda 0    : ${SHOP_NAME:-se solicitará durante MariaDB}"
  echo "NIF/CIF     : ${SHOP_NIF:-se solicitará durante MariaDB}"
fi
echo "Log        : $LOG_FILE"
echo

if [[ "$MODE" == "install" && $ASSUME_YES -eq 0 ]]; then
  read -r -p "¿Desea comenzar la instalación? [s/N]: " answer
  [[ "${answer,,}" == "s" || "${answer,,}" == "si" ]] || {
    echo "Instalación cancelada."
    exit 0
  }
fi

progress "${STEPS[0]}"
if [[ "$MODE" == "install" ]]; then
  bash "$SCRIPT_DIR/flx_requisitos.sh" --install --yes
else
  bash "$SCRIPT_DIR/flx_requisitos.sh" --check
fi

progress "${STEPS[1]}"
if [[ "$MODE" == "install" ]]; then
  bash "$SCRIPT_DIR/flx_preparar_directorios.sh" --create --app-user "$APP_USER" --yes
else
  bash "$SCRIPT_DIR/flx_preparar_directorios.sh" --check
fi

progress "${STEPS[2]}"
args=("--$MODE" --source "$SOURCE_DIR" --binary "$BINARY" --app-user "$APP_USER")
[[ -f "$ICON" ]] && args+=(--icon "$ICON")
[[ -n "$CONFIG" && -f "$CONFIG" ]] && args+=(--config "$CONFIG")
[[ "$MODE" == "install" ]] && args+=(--yes)
bash "$SCRIPT_DIR/flx_instalar_archivos.sh" "${args[@]}"

progress "${STEPS[3]}"
if [[ $DEFER_FIRST_RUN -eq 1 ]]; then
  echo "[DIFERIDO] BBDD y datos iniciales se configurarán en la primera ejecución de FacturLinEx."
elif [[ $SKIP_DB -eq 1 ]]; then
  echo "[OMITIDO] Preparación de MariaDB por --skip-db."
else
  db_args=("--$MODE" --database "$DB_NAME" --db-user "$DB_USER")
  [[ -n "$SHOP_NAME" ]] && db_args+=(--shop-name "$SHOP_NAME")
  [[ -n "$SHOP_ADDRESS" ]] && db_args+=(--shop-address "$SHOP_ADDRESS")
  [[ -n "$SHOP_CITY" ]] && db_args+=(--shop-city "$SHOP_CITY")
  [[ -n "$SHOP_ZIP" ]] && db_args+=(--shop-zip "$SHOP_ZIP")
  [[ -n "$SHOP_PROVINCE" ]] && db_args+=(--shop-province "$SHOP_PROVINCE")
  [[ -n "$SHOP_PHONE" ]] && db_args+=(--shop-phone "$SHOP_PHONE")
  [[ -n "$SHOP_FAX" ]] && db_args+=(--shop-fax "$SHOP_FAX")
  [[ -n "$SHOP_NIF" ]] && db_args+=(--shop-nif "$SHOP_NIF")
  db_args+=(--shop-db-host "$SHOP_DB_HOST" --shop-db-port "$SHOP_DB_PORT")
  bash "$SCRIPT_DIR/flx_preparar_mariadb.sh" "${db_args[@]}"
fi

progress "${STEPS[4]}"
if [[ $DEFER_FIRST_RUN -eq 1 ]]; then
  echo "[DIFERIDO] FacturConf.ini se creará desde FacturLinEx en su primera ejecución."
else
  config_args=("--$MODE" --app-user "$APP_USER" --db-host "$SHOP_DB_HOST" --db-port "$SHOP_DB_PORT" --db-name "$DB_NAME" --db-user "$DB_USER" --vf-mode "$VF_MODE")
  bash "$SCRIPT_DIR/flx_configurar_facturlinex.sh" "${config_args[@]}"
fi

progress "${STEPS[5]}"
if [[ $SKIP_SUDOERS -eq 1 ]]; then
  echo "[OMITIDO] Scripts auxiliares/sudoers por --skip-sudoers."
elif [[ -d "$SOURCE_DIR/AuxiliaresRoot" ]] && compgen -G "$SOURCE_DIR/AuxiliaresRoot/*.sh" >/dev/null; then
  require_script "flx_instalar_auxiliares_sudoers.sh"
  bash "$SCRIPT_DIR/flx_instalar_auxiliares_sudoers.sh" \
    "--$MODE" --source "$SOURCE_DIR/AuxiliaresRoot" --app-user "$APP_USER"
else
  echo "[INFO] No existe AuxiliaresRoot con scripts; fase omitida."
fi

progress "${STEPS[6]}"
bash "$SCRIPT_DIR/flx_verificar_instalacion.sh" "--$MODE"
if [[ -f "$SCRIPT_DIR/flx_verificar_mariadb.sh" && $SKIP_DB -eq 0 ]]; then
  bash "$SCRIPT_DIR/flx_verificar_mariadb.sh" "--$MODE"
fi
if [[ $DEFER_FIRST_RUN -eq 1 ]]; then
  echo "[DIFERIDO] Verificación de FacturConf.ini: se realizará tras la primera ejecución."
elif [[ -f "$SCRIPT_DIR/flx_verificar_config_sudoers.sh" ]]; then
  bash "$SCRIPT_DIR/flx_verificar_config_sudoers.sh" "--$MODE" || {
    echo "[AVISO] La verificación de configuración/sudoers presenta incidencias."
  }
fi

if [[ $SKIP_SUDOERS -eq 0 ]]; then
  for aux in flx_backup.sh flx_backup_run_ftp.sh flx_restore.sh flx_restore_run.sh; do
    if [[ "$MODE" == "check" ]]; then
      if [[ -x "/usr/local/sbin/$aux" ]]; then
        echo "[OK] Auxiliar ya instalado: /usr/local/sbin/$aux"
      else
        echo "[PREVISTO] Se instalará: /usr/local/sbin/$aux"
      fi
    else
      [[ -x "/usr/local/sbin/$aux" ]] || { echo "[ERROR] Falta auxiliar instalado: /usr/local/sbin/$aux"; exit 1; }
      echo "[OK] Auxiliar instalado: /usr/local/sbin/$aux"
    fi
  done
fi

echo
echo "============================================================"
if [[ "$MODE" == "check" ]]; then
  echo "SIMULACIÓN FINALIZADA"
  echo "No se ha modificado el sistema."
else
  echo "INSTALACIÓN FINALIZADA"
  echo "Revise el informe y ejecute FacturLinEx en entorno de pruebas."
fi
echo "Log: $LOG_FILE"
echo "============================================================"
