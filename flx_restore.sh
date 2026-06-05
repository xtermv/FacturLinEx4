#!/usr/bin/env bash
set -euo pipefail

#======================================================================
# flx_restore.sh  (FacturLinEx2 - Restore físico MyISAM/Aria)
#
# Restaura una copia creada por flx_backup.sh:
#   - datadir/<DBNAME>/
#   - ficheros globales Aria opcionales
#   - FacturConf.ini opcional
#
# USO:
#   flx_restore.sh <RUTA_BACKUP> <HOME_USUARIO> <DBNAME> <RUTA_FACTURCONF_INI> [RESTORE_CONF] [RESTORE_ARIA]
#
# Ejemplo:
#   flx_restore.sh \
#     "/home/usuario/backups/facturlinex/20260307_20260307_010101_facturlinex_mipc" \
#     "/home/usuario" \
#     "facturlinex" \
#     "/home/usuario/facturlinex/FacturConf.ini" \
#     "1" \
#     "1"
#
# Parámetros:
#   RESTORE_CONF : 1=restaurar FacturConf.ini ; 0=no
#   RESTORE_ARIA : 1=restaurar aria_log* globales ; 0=no
#
# Variables opcionales de entorno:
#   MYSQL_DATADIR=/var/lib/mysql
#   MARIADB_SERVICE=mariadb
#======================================================================

BACKUP_DIR="${1:-}"
HOME_USR="${2:-}"
DBNAME="${3:-}"
FACTURCONF_PATH="${4:-}"
RESTORE_CONF="${5:-1}"
RESTORE_ARIA="${6:-1}"

MARIADB_SERVICE="${MARIADB_SERVICE:-mariadb}"

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

info() {
  echo "INFO: $*"
}

warn() {
  echo "WARN: $*" >&2
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "no se encuentra el comando requerido: $1"
}

require_root() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    fail "este script debe ejecutarse como root"
  fi
}

read_manifest_value() {
  local key="$1"
  local file="$2"
  awk -F= -v k="$key" '$1==k {sub(/^[^=]*=/,""); print; exit}' "$file" 2>/dev/null || true
}

require_root
require_cmd rsync
require_cmd systemctl
require_cmd date
require_cmd awk
require_cmd hostname
require_cmd flock

[[ -n "$BACKUP_DIR" ]]      || fail "uso: $0 <RUTA_BACKUP> <HOME_USUARIO> <DBNAME> <RUTA_FACTURCONF_INI> [RESTORE_CONF] [RESTORE_ARIA]"
[[ -n "$HOME_USR" ]]        || fail "HOME_USUARIO vacío"
[[ -n "$DBNAME" ]]          || fail "DBNAME vacío"
[[ -n "$FACTURCONF_PATH" ]] || fail "RUTA_FACTURCONF_INI vacía"

[[ -d "$BACKUP_DIR" ]] || fail "la ruta de backup no existe: $BACKUP_DIR"
[[ -d "$HOME_USR" ]]   || fail "HOME_USUARIO no existe: $HOME_USR"

MANIFEST="$BACKUP_DIR/manifest.txt"
SRC_DB="$BACKUP_DIR/mysql_datadir/$DBNAME"
SRC_GLOBAL="$BACKUP_DIR/mysql_datadir/_global"
SRC_CONF="$BACKUP_DIR/config/$(basename "$FACTURCONF_PATH")"

[[ -f "$MANIFEST" ]] || fail "no existe manifest.txt en la copia: $MANIFEST"
[[ -d "$SRC_DB" ]]   || fail "no existe la carpeta de la BD a restaurar: $SRC_DB"

MANIFEST_DBNAME="$(read_manifest_value DBNAME "$MANIFEST")"
MANIFEST_HOST="$(read_manifest_value HOST "$MANIFEST")"
MANIFEST_DATE="$(read_manifest_value DATE "$MANIFEST")"
MANIFEST_DATADIR="$(read_manifest_value MYSQL_DATADIR "$MANIFEST")"

if [[ -n "$MANIFEST_DBNAME" && "$MANIFEST_DBNAME" != "$DBNAME" ]]; then
  fail "la copia pertenece a DBNAME='$MANIFEST_DBNAME' y se intenta restaurar sobre '$DBNAME'"
fi

MYSQL_DATADIR="${MYSQL_DATADIR:-$MANIFEST_DATADIR}"
MYSQL_DATADIR="${MYSQL_DATADIR%/}"

[[ -n "$MYSQL_DATADIR" ]] || fail "no puedo determinar MYSQL_DATADIR"
[[ -d "$MYSQL_DATADIR" ]] || fail "MYSQL_DATADIR no existe: $MYSQL_DATADIR"

DEST_DB="$MYSQL_DATADIR/$DBNAME"

STAMP="$(date +%Y%m%d_%H%M%S)"
HOST_NOW="$(hostname -s 2>/dev/null || hostname)"
PRE_DIR="$HOME_USR/backups/facturlinex/pre_restore_${DBNAME}_${STAMP}_${HOST_NOW}"
LOG_FILE="$PRE_DIR/restore.log"

mkdir -p "$PRE_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

info "==============================================="
info "Inicio restauración FacturLinEx2"
info "BACKUP_DIR      = $BACKUP_DIR"
info "HOME_USR        = $HOME_USR"
info "DBNAME          = $DBNAME"
info "FACTURCONF_PATH = $FACTURCONF_PATH"
info "RESTORE_CONF    = $RESTORE_CONF"
info "RESTORE_ARIA    = $RESTORE_ARIA"
info "MYSQL_DATADIR   = $MYSQL_DATADIR"
info "MARIADB_SERVICE = $MARIADB_SERVICE"
info "MANIFEST_HOST   = ${MANIFEST_HOST:-desconocido}"
info "MANIFEST_DATE   = ${MANIFEST_DATE:-desconocido}"
info "PRE_DIR         = $PRE_DIR"
info "LOG_FILE        = $LOG_FILE"
info "==============================================="

LOCKFILE="/var/lock/flx_restore_${DBNAME}.lock"
exec 201>"$LOCKFILE"
if ! flock -n 201; then
  fail "ya hay una restauración en curso para DB=$DBNAME (lock: $LOCKFILE)"
fi

info "Generando copia previa del estado actual..."
mkdir -p "$PRE_DIR/mysql_datadir"
if [[ -d "$DEST_DB" ]]; then
  mkdir -p "$PRE_DIR/mysql_datadir/$DBNAME"
  rsync -a "$DEST_DB/" "$PRE_DIR/mysql_datadir/$DBNAME/"
else
  warn "La BD actual no existe todavía en $DEST_DB"
fi

if [[ "$RESTORE_ARIA" == "1" ]]; then
  mkdir -p "$PRE_DIR/mysql_datadir/_global"
  for g in "$MYSQL_DATADIR/aria_log_control" "$MYSQL_DATADIR/aria_log."* "$MYSQL_DATADIR/aria_log"*; do
    if [[ -e "$g" ]]; then
      rsync -a "$g" "$PRE_DIR/mysql_datadir/_global/" || true
    fi
  done
fi

if [[ -f "$FACTURCONF_PATH" ]]; then
  mkdir -p "$PRE_DIR/config"
  cp -a "$FACTURCONF_PATH" "$PRE_DIR/config/" || true
fi
cp -a "$MANIFEST" "$PRE_DIR/manifest_origen.txt" || true

info "Parando servicio $MARIADB_SERVICE ..."
systemctl stop "$MARIADB_SERVICE"
if systemctl is-active --quiet "$MARIADB_SERVICE"; then
  fail "no se ha podido detener $MARIADB_SERVICE"
fi

info "Restaurando carpeta física de la BD..."
rm -rf "$DEST_DB"
mkdir -p "$DEST_DB"
rsync -a --delete "$SRC_DB/" "$DEST_DB/"

if [[ "$RESTORE_ARIA" == "1" ]]; then
  if [[ -d "$SRC_GLOBAL" ]]; then
    info "Restaurando ficheros globales Aria..."
    rsync -a "$SRC_GLOBAL/" "$MYSQL_DATADIR/"
  else
    warn "No existe carpeta _global en la copia. Se omite restauración Aria."
  fi
else
  info "RESTORE_ARIA=0, no se restauran ficheros Aria globales."
fi

if [[ "$RESTORE_CONF" == "1" ]]; then
  if [[ -f "$SRC_CONF" ]]; then
    info "Restaurando configuración..."
    mkdir -p "$(dirname "$FACTURCONF_PATH")"
    cp -a "$SRC_CONF" "$FACTURCONF_PATH"
  else
    warn "No existe copia de configuración en: $SRC_CONF"
  fi
else
  info "RESTORE_CONF=0, no se restaura FacturConf.ini."
fi

info "Ajustando permisos..."
chown -R mysql:mysql "$DEST_DB"
for g in "$MYSQL_DATADIR/aria_log_control" "$MYSQL_DATADIR/aria_log."* "$MYSQL_DATADIR/aria_log"*; do
  if [[ -e "$g" ]]; then
    chown mysql:mysql "$g" || true
  fi
done

info "Arrancando servicio $MARIADB_SERVICE ..."
systemctl start "$MARIADB_SERVICE"
if ! systemctl is-active --quiet "$MARIADB_SERVICE"; then
  fail "MariaDB no ha arrancado correctamente tras la restauración"
fi

{
  echo "RESTORE_DATE=$(date -Is || true)"
  echo "BACKUP_DIR=$BACKUP_DIR"
  echo "DBNAME=$DBNAME"
  echo "MYSQL_DATADIR=$MYSQL_DATADIR"
  echo "FACTURCONF_PATH=$FACTURCONF_PATH"
  echo "RESTORE_CONF=$RESTORE_CONF"
  echo "RESTORE_ARIA=$RESTORE_ARIA"
  echo "PRE_DIR=$PRE_DIR"
  echo "LOG_FILE=$LOG_FILE"
} > "$PRE_DIR/restore_result.txt"

info "OK: restauración finalizada correctamente."
info "Copia previa del estado anterior: $PRE_DIR"
info "Log de restauración: $LOG_FILE"
exit 0
