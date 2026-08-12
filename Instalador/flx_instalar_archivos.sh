#!/usr/bin/env bash
set -Eeuo pipefail

APP_NAME="FacturLinEx"
APP_ID="facturlinex2"
PREFIX="/usr"
SHARE_DIR="${PREFIX}/share/${APP_ID}"
BIN_DIR="${PREFIX}/bin"
ETC_DIR="/etc/${APP_ID}"
LOG_DIR="/var/log/${APP_ID}"
DESKTOP_DIR="${PREFIX}/share/applications"
ICON_DIR="${PREFIX}/share/icons/hicolor/256x256/apps"
BACKUP_ROOT="/var/backups/${APP_ID}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
MODE="check"
APP_USER="${SUDO_USER:-${USER:-}}"
SOURCE_DIR="$PROJECT_ROOT"
BIN_SOURCE=""
ICON_SOURCE=""
CONFIG_SOURCE=""
ASSUME_YES=0

usage() {
  cat <<USAGE
Uso: $0 [opciones]

  --check                 Simula y valida la instalación (por defecto)
  --install               Realiza la instalación
  --source DIR            Raíz del paquete/proyecto a instalar
  --binary FICHERO        Binario FacturLinEx compilado
  --icon FICHERO          Icono PNG opcional
  --config FICHERO        FacturConf.ini inicial opcional
  --app-user USUARIO      Usuario propietario de /usr/share/facturlinex2
  --yes                   No pedir confirmación
  -h, --help              Mostrar ayuda

Ejemplo:
  $0 --check --binary ./Bin/FacturLinEx
  $0 --install --binary ./Bin/FacturLinEx --icon ./facturLinex2-ico.png
USAGE
}

while (($#)); do
  case "$1" in
    --check) MODE="check" ;;
    --install) MODE="install" ;;
    --source) shift; SOURCE_DIR="${1:?Falta DIR}" ;;
    --binary) shift; BIN_SOURCE="${1:?Falta fichero}" ;;
    --icon) shift; ICON_SOURCE="${1:?Falta fichero}" ;;
    --config) shift; CONFIG_SOURCE="${1:?Falta fichero}" ;;
    --yes) ASSUME_YES=1 ;;
    --app-user) shift; APP_USER="${1:-}"; [[ -n "$APP_USER" ]] || { echo "Falta usuario para --app-user" >&2; exit 2; } ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Opción desconocida: $1" >&2; usage; exit 2 ;;
  esac
  shift
done

SOURCE_DIR="$(readlink -f "$SOURCE_DIR")"

find_default_binary() {
  local candidate
  for candidate in \
    "$SOURCE_DIR/Bin/FacturLinEx" \
    "$SOURCE_DIR/FacturLinEx" \
    "$SOURCE_DIR/bin/FacturLinEx"; do
    [[ -f "$candidate" ]] && { printf '%s\n' "$candidate"; return 0; }
  done
  return 1
}

if [[ -z "$BIN_SOURCE" ]]; then
  BIN_SOURCE="$(find_default_binary || true)"
fi
[[ -n "$BIN_SOURCE" ]] && BIN_SOURCE="$(readlink -f "$BIN_SOURCE")"

if [[ -z "$ICON_SOURCE" ]]; then
  for f in "$SOURCE_DIR/facturLinex2-ico.png" "$SOURCE_DIR/FacturLinEx.png"; do
    [[ -f "$f" ]] && { ICON_SOURCE="$f"; break; }
  done
fi
[[ -n "$ICON_SOURCE" ]] && ICON_SOURCE="$(readlink -f "$ICON_SOURCE")"

if [[ -z "$CONFIG_SOURCE" && -f "$SOURCE_DIR/FacturConf.ini" ]]; then
  CONFIG_SOURCE="$SOURCE_DIR/FacturConf.ini"
fi
[[ -n "$CONFIG_SOURCE" ]] && CONFIG_SOURCE="$(readlink -f "$CONFIG_SOURCE")"

ERRORS=0
WARNINGS=0
ok()   { printf '  [OK] %s\n' "$*"; }
warn() { printf '  [AVISO] %s\n' "$*"; WARNINGS=$((WARNINGS+1)); }
err()  { printf '  [ERROR] %s\n' "$*"; ERRORS=$((ERRORS+1)); }

printf '\n============================================================\n'
printf ' %s - Instalación controlada de archivos\n' "$APP_NAME"
printf '============================================================\n\n'
printf 'Modo:     %s\n' "$MODE"
printf 'Origen:   %s\n' "$SOURCE_DIR"
printf 'Destino:  %s\n\n' "$SHARE_DIR"

[[ -d "$SOURCE_DIR" ]] && ok "Directorio de origen accesible" || err "No existe el origen: $SOURCE_DIR"
if [[ -n "$BIN_SOURCE" && -f "$BIN_SOURCE" ]]; then
  ok "Binario localizado: $BIN_SOURCE"
  [[ -x "$BIN_SOURCE" ]] || warn "El binario no tiene permiso de ejecución; se corregirá al instalar"
  if command -v file >/dev/null 2>&1; then
    file "$BIN_SOURCE" | grep -q 'ELF' && ok "El binario es ELF" || warn "No se ha confirmado que el binario sea ELF"
  fi
else
  err "No se ha localizado el binario FacturLinEx"
fi

[[ -n "$ICON_SOURCE" && -f "$ICON_SOURCE" ]] && ok "Icono localizado: $ICON_SOURCE" || warn "No se instalará icono personalizado"
[[ -n "$CONFIG_SOURCE" && -f "$CONFIG_SOURCE" ]] && ok "Configuración inicial localizada" || warn "No se copiará FacturConf.ini inicial"

for d in Report Documents Documentacion Manual\ FL2\ 2026\ -\ V1 SQL Scripts; do
  [[ -e "$SOURCE_DIR/$d" ]] && ok "Recurso detectado: $d"
done

printf '\nPlan de instalación:\n'
printf '  %s -> %s/FacturLinEx\n' "${BIN_SOURCE:-<sin binario>}" "$BIN_DIR"
printf '  Recursos seleccionados -> %s\n' "$SHARE_DIR"
printf '  Configuración -> %s/FacturConf.ini (sin sobrescribir)\n' "$ETC_DIR"
printf '  Acceso de escritorio -> %s/%s.desktop\n' "$DESKTOP_DIR" "$APP_ID"

if ((ERRORS > 0)); then
  printf '\nNo se puede continuar: %d error(es).\n' "$ERRORS" >&2
  exit 1
fi

if [[ "$MODE" == "check" ]]; then
  printf '\nSimulación terminada. No se ha modificado el sistema.\n'
  printf 'Avisos: %d\n\n' "$WARNINGS"
  exit 0
fi

if ((EUID != 0)); then
  echo "ERROR: --install debe ejecutarse con sudo o como root." >&2
  exit 1
fi

if ((ASSUME_YES == 0)); then
  read -r -p "¿Continuar con la instalación? [s/N] " answer
  [[ "$answer" =~ ^[sS]$ ]] || { echo "Instalación cancelada."; exit 0; }
fi

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$BACKUP_ROOT/$STAMP"
mkdir -p "$BACKUP_DIR"

backup_if_exists() {
  local path="$1"
  if [[ -e "$path" || -L "$path" ]]; then
    mkdir -p "$BACKUP_DIR$(dirname "$path")"
    cp -a "$path" "$BACKUP_DIR$path"
  fi
}

backup_if_exists "$BIN_DIR/FacturLinEx"
backup_if_exists "$SHARE_DIR"
backup_if_exists "$DESKTOP_DIR/$APP_ID.desktop"
backup_if_exists "$ICON_DIR/$APP_ID.png"

install -d -m 0755 "$SHARE_DIR" "$SHARE_DIR/Report" "$SHARE_DIR/Documentacion" \
  "$ETC_DIR" "$LOG_DIR" "$DESKTOP_DIR" "$ICON_DIR"
install -m 0755 "$BIN_SOURCE" "$BIN_DIR/FacturLinEx"

copy_tree_if_exists() {
  local src="$1" dst="$2"
  [[ -e "$src" ]] || return 0
  mkdir -p "$dst"
  cp -a "$src"/. "$dst"/
}

copy_tree_if_exists "$SOURCE_DIR/Report" "$SHARE_DIR/Report"
copy_tree_if_exists "$SOURCE_DIR/Documents" "$SHARE_DIR/Documents"
copy_tree_if_exists "$SOURCE_DIR/Documentacion" "$SHARE_DIR/Documentacion"
copy_tree_if_exists "$SOURCE_DIR/Manual FL2 2026 - V1" "$SHARE_DIR/Documentacion/Manual FL2 2026 - V1"
copy_tree_if_exists "$SOURCE_DIR/SQL" "$SHARE_DIR/SQL"
copy_tree_if_exists "$SOURCE_DIR/Scripts" "$SHARE_DIR/Scripts"

for cfg in "$SOURCE_DIR"/*.cfg "$SOURCE_DIR"/*.ini; do
  [[ -e "$cfg" ]] || continue
  install -m 0644 "$cfg" "$SHARE_DIR/$(basename "$cfg")"
done

if [[ -n "$CONFIG_SOURCE" && -f "$CONFIG_SOURCE" && ! -e "$ETC_DIR/FacturConf.ini" ]]; then
  install -m 0640 "$CONFIG_SOURCE" "$ETC_DIR/FacturConf.ini"
fi

if [[ -n "$ICON_SOURCE" && -f "$ICON_SOURCE" ]]; then
  install -m 0644 "$ICON_SOURCE" "$ICON_DIR/$APP_ID.png"
fi

cat > "$DESKTOP_DIR/$APP_ID.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=FacturLinEx
Comment=TPV y facturación para GNU/Linux
Exec=/usr/bin/FacturLinEx
Icon=$APP_ID
Terminal=false
Categories=Office;Finance;
StartupNotify=true
DESKTOP
chmod 0644 "$DESKTOP_DIR/$APP_ID.desktop"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$DESKTOP_DIR" >/dev/null 2>&1 || true
fi
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -f "${PREFIX}/share/icons/hicolor" >/dev/null 2>&1 || true
fi

cat > "$SHARE_DIR/INSTALLATION_INFO.txt" <<INFO
FacturLinEx - Información de instalación
Fecha: $(date '+%d/%m/%Y %H:%M:%S')
Origen: $SOURCE_DIR
Binario: $BIN_SOURCE
Copia de seguridad previa: $BACKUP_DIR
INFO
chmod 0644 "$SHARE_DIR/INSTALLATION_INFO.txt"

printf '\nInstalación finalizada correctamente.\n'
printf 'Copia de seguridad previa: %s\n' "$BACKUP_DIR"
printf 'Ejecutable: %s/FacturLinEx\n\n' "$BIN_DIR"


if [[ "$MODE" == "install" ]]; then
  if [[ -n "${APP_USER:-}" ]] && id "$APP_USER" >/dev/null 2>&1; then
    chown -R "$APP_USER:$APP_USER" "$SHARE_DIR"
    chmod -R u+rwX,go+rX "$SHARE_DIR"
    echo "[OK] ${SHARE_DIR} pertenece a ${APP_USER}:${APP_USER}; el usuario puede leer y escribir."
  fi
fi
