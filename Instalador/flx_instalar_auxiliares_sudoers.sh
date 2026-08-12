#!/usr/bin/env bash
set -Eeuo pipefail

MODE="check"
APP_USER="${SUDO_USER:-${USER}}"
SOURCE_DIR=""
DEST_DIR="/usr/local/sbin"
SUDOERS_FILE="/etc/sudoers.d/facturlinex2"
SCRIPTS=(flx_backup.sh flx_backup_run_ftp.sh flx_restore.sh flx_restore_run.sh)

usage() {
  cat <<'USAGE'
Uso:
  flx_instalar_auxiliares_sudoers.sh --check --source DIR
  sudo flx_instalar_auxiliares_sudoers.sh --install --source DIR --app-user USUARIO

Instala exclusivamente los auxiliares de backup/restore utilizados por un
puesto FacturLinEx en /usr/local/sbin. No instala scripts arbitrarios.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check) MODE="check"; shift ;;
    --install) MODE="install"; shift ;;
    --source) [[ $# -ge 2 ]] || exit 2; SOURCE_DIR="$2"; shift 2 ;;
    --app-user) [[ $# -ge 2 ]] || exit 2; APP_USER="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Opción desconocida: $1" >&2; usage; exit 2 ;;
  esac
done

[[ -n "$SOURCE_DIR" && -d "$SOURCE_DIR" ]] || { echo "ERROR: falta --source DIR válido." >&2; exit 2; }

MISSING=0
echo "Auxiliares FacturLinEx:" 
for script in "${SCRIPTS[@]}"; do
  if [[ -f "$SOURCE_DIR/$script" ]]; then
    /bin/bash -n "$SOURCE_DIR/$script"
    echo "  [OK] $script"
  else
    echo "  [FALTA] $SOURCE_DIR/$script"
    MISSING=1
  fi
done
[[ $MISSING -eq 0 ]] || exit 1

echo "Usuario autorizado: $APP_USER"
echo "Destino           : $DEST_DIR"
echo "Sudoers           : $SUDOERS_FILE"

if [[ "$MODE" == "check" ]]; then
  echo "[INFO] Simulación terminada; no se ha modificado el sistema."
  exit 0
fi

[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo "ERROR: --install debe ejecutarse como root." >&2; exit 1; }
id "$APP_USER" >/dev/null 2>&1 || { echo "ERROR: usuario inexistente: $APP_USER" >&2; exit 1; }
command -v visudo >/dev/null 2>&1 || { echo "ERROR: visudo no está instalado." >&2; exit 1; }

install -d -m 0755 -o root -g root "$DEST_DIR"
for script in "${SCRIPTS[@]}"; do
  TMP="$(mktemp)"
  sed 's/\r$//' "$SOURCE_DIR/$script" > "$TMP"
  /bin/bash -n "$TMP"
  install -m 0750 -o root -g root "$TMP" "$DEST_DIR/$script"
  rm -f "$TMP"
done

TMP_SUDOERS="$(mktemp)"
trap 'rm -f "$TMP_SUDOERS"' EXIT
cat > "$TMP_SUDOERS" <<EOF_SUDOERS
# FacturLinEx 4.2.6J - auxiliares locales de copia/restauración.
# Permisos limitados a los scripts instalados por root.
$APP_USER ALL=(root) NOPASSWD: \\
  $DEST_DIR/flx_backup.sh *, \\
  $DEST_DIR/flx_backup_run_ftp.sh *, \\
  $DEST_DIR/flx_restore.sh *, \\
  $DEST_DIR/flx_restore_run.sh *
EOF_SUDOERS
chmod 0440 "$TMP_SUDOERS"
visudo -cf "$TMP_SUDOERS"
install -m 0440 -o root -g root "$TMP_SUDOERS" "$SUDOERS_FILE"
visudo -cf "$SUDOERS_FILE"

echo "[ OK  ] Auxiliares instalados en /usr/local/sbin y sudoers validado."
