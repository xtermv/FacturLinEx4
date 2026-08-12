#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${1:-}"
HOME_USR="${2:-}"
DBNAME="${3:-}"
FACTURCONF_PATH="${4:-}"
RESTORE_CONF="${5:-0}"
RESTORE_ARIA="${6:-0}"
DO_PRE_BACKUP="${7:-1}"
APP_PID="${8:-}"
APP_USER="${9:-}"
APP_EXE="${10:-}"
APP_DISPLAY="${11:-}"
APP_XAUTHORITY="${12:-}"

HOME_USR="${HOME_USR%/}"
BACKUP_DIR="${BACKUP_DIR%/}"
APP_USER="${APP_USER:-root}"
APP_DISPLAY="${APP_DISPLAY:-:0}"

LOG_DIR="$HOME_USR/backups/facturlinex/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/restore_run_$(date +%Y%m%d_%H%M%S)_${DBNAME}.log"

exec > >(tee -a "$LOG_FILE") 2>&1

info() { echo "[$(date '+%F %T')] $*"; }
fail() { echo "[$(date '+%F %T')] ERROR: $*"; exit 1; }

[[ -n "$BACKUP_DIR" ]] || fail "BACKUP_DIR vacío"
[[ -n "$HOME_USR" ]] || fail "HOME_USR vacío"
[[ -n "$DBNAME" ]] || fail "DBNAME vacío"
[[ -n "$FACTURCONF_PATH" ]] || fail "FACTURCONF_PATH vacío"
[[ -n "$APP_PID" ]] || fail "APP_PID vacío"
[[ -f /usr/local/sbin/flx_backup.sh ]] || fail "No existe /usr/local/sbin/flx_backup.sh"
[[ -f /usr/local/sbin/flx_restore.sh ]] || fail "No existe /usr/local/sbin/flx_restore.sh"

info "================================================="
info "Inicio wrapper restore FLX"
info "BACKUP_DIR=$BACKUP_DIR"
info "HOME_USR=$HOME_USR"
info "DBNAME=$DBNAME"
info "FACTURCONF_PATH=$FACTURCONF_PATH"
info "RESTORE_CONF=$RESTORE_CONF"
info "RESTORE_ARIA=$RESTORE_ARIA"
info "DO_PRE_BACKUP=$DO_PRE_BACKUP"
info "APP_PID=$APP_PID"
info "APP_USER=$APP_USER"
info "APP_EXE=$APP_EXE"
info "DISPLAY=$APP_DISPLAY"
info "XAUTHORITY=$APP_XAUTHORITY"
info "LOG_FILE=$LOG_FILE"
info "================================================="

info "Esperando a que FacturLinEx termine completamente..."
WAIT_SECS=0
while kill -0 "$APP_PID" 2>/dev/null; do
  sleep 1
  WAIT_SECS=$((WAIT_SECS+1))
  if (( WAIT_SECS % 5 == 0 )); then
    info "...esperando cierre de FL2 (${WAIT_SECS}s)"
  fi
done
info "FacturLinEx ya está cerrado."

if [[ "$DO_PRE_BACKUP" = "1" ]]; then
  info "FASE 1/4 - Lanzando backup previo obligatorio..."
  FECHA_STR="$(date +%Y%m%d)"
  /usr/local/sbin/flx_backup.sh "$FECHA_STR" "$HOME_USR" "$DBNAME" "$FACTURCONF_PATH"
  info "Backup previo terminado."
else
  info "FASE 1/4 - Backup previo desactivado."
fi

info "FASE 2/4 - Restaurando copia..."
/usr/local/sbin/flx_restore.sh "$BACKUP_DIR" "$HOME_USR" "$DBNAME" "$FACTURCONF_PATH" "$RESTORE_CONF" "$RESTORE_ARIA"
info "Restore terminado."

info "FASE 3/4 - Espera corta post-restauración..."
sleep 2

if [[ -n "$APP_EXE" && -x "$APP_EXE" ]]; then
  info "FASE 4/4 - Reabriendo FacturLinEx..."
  if command -v runuser >/dev/null 2>&1; then
    runuser -u "$APP_USER" -- env DISPLAY="$APP_DISPLAY" XAUTHORITY="$APP_XAUTHORITY" nohup "$APP_EXE" >/dev/null 2>&1 &
  else
    su - "$APP_USER" -c "DISPLAY='$APP_DISPLAY' XAUTHORITY='$APP_XAUTHORITY' nohup '$APP_EXE' >/dev/null 2>&1 &"
  fi
  info "FacturLinEx relanzado."
else
  info "No se relanza FacturLinEx: APP_EXE vacío o no ejecutable."
fi

info "Proceso finalizado correctamente."
info "Log disponible en: $LOG_FILE"
sleep 5
exit 0
