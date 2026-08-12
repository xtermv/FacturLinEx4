#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 18 ]]; then
  echo "Uso:"
  echo "$0 <FECHA> <HOME> <DBNAME> <FACTURCONF> <PROTO> <HOST> <PORT> <USER> <PASS> <REMOTE_DIR> <PASSIVE> <CREATE_REMOTE_DIR> <COMPRESS> <FORMAT> <ENCRYPT> <ARCHIVE_PASS> <DELETE_SOURCE> <DELETE_ARCHIVE>"
  exit 2
fi

FECHA="$1"
HOME_USR="${2%/}"
DBNAME="$3"
FACTURCONF="$4"
PROTO="$5"
HOST="$6"
PORT="$7"
USERFTP="$8"
PASSFTP="$9"
shift 9

REMOTE_DIR="$1"
PASSIVE="$2"
CREATE_REMOTE_DIR="$3"
COMPRESS="$4"
FORMAT="$5"
ENCRYPT="$6"
ARCHIVE_PASS="$7"
DELETE_SOURCE="$8"
DELETE_ARCHIVE="$9"

BACKUP_BASE="$HOME_USR/backups/facturlinex"
LOGDIR="$BACKUP_BASE/logs"
mkdir -p "$LOGDIR"

STAMP="$(date +%Y%m%d_%H%M%S)"
LOGFILE="$LOGDIR/flx_backup_ftp_${STAMP}.log"

log() {
  printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOGFILE"
}

fail() {
  log "ERROR: $1"
  printf '\n' >> "$LOGFILE"
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "No se encuentra el comando requerido: $1"
}

log "========================================"
log "Inicio Backup FLX + FTP (PRO v2)"
log "DB=$DBNAME HOST=$HOST REMOTO=${REMOTE_DIR:-/}"

HOSTNAME="$(hostname -s 2>/dev/null || hostname)"
DEST_DIR="$BACKUP_BASE/${FECHA}_${STAMP}_${DBNAME}_${HOSTNAME}"

mkdir -p "$DEST_DIR/mysql_datadir"
mkdir -p "$DEST_DIR/config"

need_cmd mysql
need_cmd rsync
need_cmd 7z
need_cmd lftp
need_cmd sha256sum

MYSQL_BIN="$(command -v mysql)"
RSYNC_BIN="$(command -v rsync)"

MYSQL_DATADIR="$($MYSQL_BIN -Nse "SELECT @@datadir;" 2>/dev/null || true)"
MYSQL_DATADIR="${MYSQL_DATADIR%/}"
[[ -n "$MYSQL_DATADIR" ]] || fail "No puedo determinar MYSQL_DATADIR"

DBDIR="$MYSQL_DATADIR/$DBNAME"
[[ -d "$DBDIR" ]] || fail "Directorio DB no encontrado: $DBDIR"

FIFO="$(mktemp -u /tmp/flx_mysql_lock.XXXXXX)"
mkfifo "$FIFO"

cleanup() {
  rm -f "$FIFO" 2>/dev/null || true
}
trap cleanup EXIT

"$MYSQL_BIN" >/dev/null 2>&1 <"$FIFO" &
MYSQL_PID=$!

exec 3>"$FIFO"
echo "FLUSH TABLES;" >&3
echo "FLUSH TABLES WITH READ LOCK;" >&3
echo "DO SLEEP(1);" >&3

log "Copiando base de datos..."
"$RSYNC_BIN" -a --info=progress2 --delete "$DBDIR/" "$DEST_DIR/mysql_datadir/$DBNAME/" 2>&1 | tee -a "$LOGFILE"

for g in "$MYSQL_DATADIR/aria_log_control" "$MYSQL_DATADIR/aria_log."* "$MYSQL_DATADIR/aria_log"*; do
  if [[ -e "$g" ]]; then
    mkdir -p "$DEST_DIR/mysql_datadir/_global"
    "$RSYNC_BIN" -a "$g" "$DEST_DIR/mysql_datadir/_global/" 2>&1 | tee -a "$LOGFILE" || true
  fi
done

echo "UNLOCK TABLES;" >&3
exec 3>&-
wait "$MYSQL_PID" 2>/dev/null || true

if [[ -f "$FACTURCONF" ]]; then
  cp -a "$FACTURCONF" "$DEST_DIR/config/" 2>&1 | tee -a "$LOGFILE" || true
else
  log "WARN: FacturConf.ini no existe en: $FACTURCONF"
fi

{
  echo "FECHA_PARAM=$FECHA"
  echo "STAMP=$STAMP"
  echo "HOST=$HOSTNAME"
  echo "DBNAME=$DBNAME"
  echo "MYSQL_DATADIR=$MYSQL_DATADIR"
  echo "DBDIR=$DBDIR"
  echo "FACTURCONF_PATH=$FACTURCONF"
  echo "DEST_DIR=$DEST_DIR"
  echo "RSYNC=$RSYNC_BIN"
  echo "MYSQL=$MYSQL_BIN"
  echo "DATE=$(date -Is || true)"
  echo "SIZE_DEST=$(du -sh "$DEST_DIR" 2>/dev/null | awk '{print $1}' || true)"
} > "$DEST_DIR/manifest.txt"

log "Manifest generado: $DEST_DIR/manifest.txt"
log "Backup creado: $DEST_DIR"

ARCHIVE="$DEST_DIR.7z"

if [[ "$COMPRESS" == "1" ]]; then
  log "Comprimiendo backup..."
  if [[ "$ENCRYPT" == "1" ]]; then
    7z a -bsp1 -bso1 -bse1 -t7z -mhe=on -p"$ARCHIVE_PASS" "$ARCHIVE" "$DEST_DIR" 2>&1 | tee -a "$LOGFILE"
  else
    7z a -bsp1 -bso1 -bse1 -t7z "$ARCHIVE" "$DEST_DIR" 2>&1 | tee -a "$LOGFILE"
  fi
  [[ -f "$ARCHIVE" ]] || fail "No se ha creado el archivo comprimido: $ARCHIVE"
  log "Archivo comprimido: $ARCHIVE"
else
  fail "Esta versión PRO v2 requiere COMPRESS=1 para el flujo FTP."
fi

log "Calculando SHA256..."
sha256sum "$ARCHIVE" | tee "$ARCHIVE.sha256" | tee -a "$LOGFILE" >/dev/null
log "SHA256 generado: $ARCHIVE.sha256"

log "Verificando integridad..."
if [[ "$ENCRYPT" == "1" ]]; then
  7z t -bsp1 -bso1 -bse1 -p"$ARCHIVE_PASS" "$ARCHIVE" 2>&1 | tee -a "$LOGFILE"
else
  7z t -bsp1 -bso1 -bse1 "$ARCHIVE" 2>&1 | tee -a "$LOGFILE"
fi

log "Subiendo por FTP..."
RETRY=3
FTP_OK=0

for ((i=1;i<=RETRY;i++)); do
  log "Intento FTP $i de $RETRY"

  if [[ "$CREATE_REMOTE_DIR" == "1" ]]; then
    LFTP_CMDS="set ftp:passive-mode $PASSIVE; set net:max-retries 1; set net:timeout 20; set net:reconnect-interval-base 5; mkdir $REMOTE_DIR || true; cd $REMOTE_DIR; put \"$ARCHIVE\"; put \"$ARCHIVE.sha256\"; cls -1; bye"
  else
    LFTP_CMDS="set ftp:passive-mode $PASSIVE; set net:max-retries 1; set net:timeout 20; set net:reconnect-interval-base 5; cd $REMOTE_DIR; put \"$ARCHIVE\"; put \"$ARCHIVE.sha256\"; cls -1; bye"
  fi

  if lftp -u "$USERFTP","$PASSFTP" -p "$PORT" "$HOST" -e "$LFTP_CMDS" 2>&1 | tee -a "$LOGFILE"; then
    FTP_OK=1
    log "FTP OK"
    break
  else
    log "WARN: FTP fallo intento $i"
    sleep 5
  fi
done

[[ "$FTP_OK" == "1" ]] || fail "No se pudo completar la subida FTP tras $RETRY intentos"

if [[ "$DELETE_SOURCE" == "1" ]]; then
  log "Eliminando carpeta origen..."
  rm -rf "$DEST_DIR"
fi

if [[ "$DELETE_ARCHIVE" == "1" ]]; then
  log "Eliminando archivo comprimido..."
  rm -f "$ARCHIVE" "$ARCHIVE.sha256"
fi

if [[ -n "${SUDO_USER:-}" ]]; then
  chown -R "$SUDO_USER:$SUDO_USER" "$BACKUP_BASE" 2>/dev/null || true
fi

log "Backup FTP finalizado correctamente"
log "========================================"
printf '\n' >> "$LOGFILE"

exit 0
