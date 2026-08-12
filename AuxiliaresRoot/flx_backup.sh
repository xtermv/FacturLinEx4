#!/usr/bin/env bash
set -euo pipefail

#======================================================================
# Script flx_backup.sh (Modo A: lock + rsync + copia FacturConf.ini)
#     Guárdalo como:
#         /usr/local/sbin/flx_backup.sh
#     Permisos:
#         chmod 750 /usr/local/sbin/flx_backup.sh
#         chown root:root /usr/local/sbin/flx_backup.sh

# Sudoers mínimo (para que FL lo pueda lanzar sin password)
# En /etc/sudoers.d/flx-backup (con visudo):
# usuario ALL=(root) NOPASSWD: /usr/local/sbin/flx_backup.sh

# sudo chmod 750 /usr/local/sbin/flx_backup.sh
# sudo chown root:root /usr/local/sbin/flx_backup.sh

# Desde FL llamamos a la ruta RutaIni + 'FacturConf.ini' (mejor usando IncludeTrailingPathDelimiter(RutaIni))

# Si alguna máquina no quiere sudoers sin password, lo más parecido a gksu es polkit (pkexec).
# Llamada:
#     pkexec /usr/local/sbin/flx_backup.sh ...

#======================================================================

# ------------------------------------------------------------
# flx_backup.sh  (FacturLinEx2 - Backup Modo A)
#   - MyISAM/Aria: bloqueo corto (FTWRL) + rsync incremental
#   - Copia:
#       * BBDD indicada (datadir/<DBNAME>/)
#       * ficheros globales Aria (aria_log_*, aria_log_control) si existen
#       * FacturConf.ini (ruta exacta pasada como parámetro)
#
# Uso:
#   flx_backup.sh <YYYYMMDD> <HOME_USUARIO> <DBNAME> <RUTA_FACTURCONF_INI>
#
# Variables opcionales (entorno):
#   BACKUP_DEST=/ruta/destino                (por defecto: <HOME>/backups/facturlinex)
#   MYSQL_LOGIN_PATH=flxbackup               (recomendado: mysql_config_editor)
#   MYSQL_USER=... MYSQL_PASS=...            (fallback; menos recomendado)
#   MYSQL_SOCKET=/run/mysqld/mysqld.sock     (opcional)
#   MYSQL_DATADIR=/var/lib/mysql             (opcional; si no, se auto-detecta por @@datadir)
# ------------------------------------------------------------

FECHA="${1:-}"
HOME_USR="${2:-}"
DBNAME="${3:-}"
FACTURCONF_PATH="${4:-}"

if [[ -z "$FECHA" || -z "$HOME_USR" || -z "$DBNAME" || -z "$FACTURCONF_PATH" ]]; then
  echo "ERROR: uso: $0 <YYYYMMDD> <HOME_USUARIO> <DBNAME> <RUTA_FACTURCONF_INI>" >&2
  exit 2
fi

if [[ ! -d "$HOME_USR" ]]; then
  echo "ERROR: HOME_USUARIO no existe: $HOME_USR" >&2
  exit 2
fi

# Destino base
DEST_BASE="${BACKUP_DEST:-$HOME_USR/backups/facturlinex}"
BACKUP_KEEP="${BACKUP_KEEP:-20}"

HOST="$(hostname -s 2>/dev/null || hostname)"
STAMP="$(date +%Y%m%d_%H%M%S)"
DEST_DIR="$DEST_BASE/${FECHA}_${STAMP}_${DBNAME}_${HOST}"
mkdir -p "$DEST_DIR"

# Evitar dos backups simultáneos de la misma DB
LOCKFILE="/var/lock/flx_backup_${DBNAME}.lock"
exec 200>"$LOCKFILE"
if ! flock -n 200; then
  echo "ERROR: ya hay una copia en curso para DB=$DBNAME (lock: $LOCKFILE)" >&2
  exit 3
fi

# Comprobar rsync
RSYNC_BIN="$(command -v rsync || true)"
if [[ -z "$RSYNC_BIN" ]]; then
  echo "ERROR: rsync no está instalado." >&2
  exit 7
fi

# Cliente mysql/mariadb
MYSQL_BIN="$(command -v mysql || true)"
if [[ -z "$MYSQL_BIN" ]]; then
  echo "ERROR: no se encuentra el cliente mysql. Instala 'mariadb-client' o 'mysql-client'." >&2
  exit 4
fi

# Args mysql (preferencia: login-path)
MYSQL_ARGS=(--protocol=socket)
if [[ -n "${MYSQL_SOCKET:-}" ]]; then
  MYSQL_ARGS+=(--socket="$MYSQL_SOCKET")
fi

if [[ -n "${MYSQL_LOGIN_PATH:-}" ]]; then
  MYSQL_ARGS+=(--login-path="$MYSQL_LOGIN_PATH")
else
  # fallback (menos recomendado)
  if [[ -n "${MYSQL_USER:-}" ]]; then MYSQL_ARGS+=(-u"$MYSQL_USER"); fi
  if [[ -n "${MYSQL_PASS:-}" ]]; then MYSQL_ARGS+=(-p"$MYSQL_PASS"); fi
fi

# Datadir: auto por @@datadir si no se fuerza
MYSQL_DATADIR="${MYSQL_DATADIR:-}"
if [[ -z "$MYSQL_DATADIR" ]]; then
  MYSQL_DATADIR="$("$MYSQL_BIN" "${MYSQL_ARGS[@]}" -Nse "SELECT @@datadir;" 2>/dev/null || true)"
  MYSQL_DATADIR="${MYSQL_DATADIR%/}"
fi

if [[ -z "$MYSQL_DATADIR" || ! -d "$MYSQL_DATADIR" ]]; then
  echo "ERROR: no puedo determinar MYSQL_DATADIR. Define MYSQL_DATADIR=/var/lib/mysql (o el tuyo)." >&2
  exit 5
fi

DBDIR="$MYSQL_DATADIR/$DBNAME"
if [[ ! -d "$DBDIR" ]]; then
  echo "ERROR: la carpeta de la BBDD no existe: $DBDIR" >&2
  exit 6
fi

# Preparar destinos
mkdir -p "$DEST_DIR/mysql_datadir"
mkdir -p "$DEST_DIR/config"

# ------------------------------------------------------------
# BLOQUEO + COPIA CONSISTENTE (FTWRL en misma sesión)
# ------------------------------------------------------------
FIFO="$(mktemp -u /tmp/flx_mysql_lock.XXXXXX)"
mkfifo "$FIFO"

cleanup() {
  rm -f "$FIFO" 2>/dev/null || true
}
trap cleanup EXIT

# Mantener conexión abierta leyendo del FIFO
"$MYSQL_BIN" "${MYSQL_ARGS[@]}" >/dev/null 2>&1 <"$FIFO" &
MYSQL_PID=$!

# Abrir FIFO para escritura
exec 3>"$FIFO"

# Lock global (MyISAM/Aria)
echo "FLUSH TABLES;" >&3
echo "FLUSH TABLES WITH READ LOCK;" >&3
echo "DO SLEEP(1);" >&3

# Copiar carpeta de la DB (rsync incremental)
"$RSYNC_BIN" -a --delete "$DBDIR/" "$DEST_DIR/mysql_datadir/$DBNAME/"

# Copiar ficheros globales Aria si existen (útil para recuperación)
for g in "$MYSQL_DATADIR/aria_log_control" "$MYSQL_DATADIR/aria_log."* "$MYSQL_DATADIR/aria_log"*; do
  if [[ -e "$g" ]]; then
    mkdir -p "$DEST_DIR/mysql_datadir/_global"
    "$RSYNC_BIN" -a "$g" "$DEST_DIR/mysql_datadir/_global/" || true
  fi
done

# Unlock y cerrar sesión
echo "UNLOCK TABLES;" >&3
exec 3>&-
wait "$MYSQL_PID" 2>/dev/null || true

# ------------------------------------------------------------
# COPIA CONFIG (FacturConf.ini)
# ------------------------------------------------------------
if [[ -f "$FACTURCONF_PATH" ]]; then
  cp -a "$FACTURCONF_PATH" "$DEST_DIR/config/" || true
else
  echo "WARN: FacturConf.ini no existe en: $FACTURCONF_PATH" >&2
fi

# Manifest (auditoría)
{
  echo "FECHA_PARAM=$FECHA"
  echo "STAMP=$STAMP"
  echo "HOST=$HOST"
  echo "DBNAME=$DBNAME"
  echo "MYSQL_DATADIR=$MYSQL_DATADIR"
  echo "DBDIR=$DBDIR"
  echo "FACTURCONF_PATH=$FACTURCONF_PATH"
  echo "DEST_DIR=$DEST_DIR"
  echo "RSYNC=$RSYNC_BIN"
  echo "MYSQL=$MYSQL_BIN"
  echo "DATE=$(date -Is || true)"
  echo "SIZE_DEST=$(du -sh "$DEST_DIR" 2>/dev/null | awk '{print $1}' || true)"
} > "$DEST_DIR/manifest.txt"

# ------------------------------------------------------------
# ROTACIÓN (por DB y host): conservar las BACKUP_KEEP más recientes
# ------------------------------------------------------------
if [[ "$BACKUP_KEEP" =~ ^[0-9]+$ ]] && [[ "$BACKUP_KEEP" -gt 0 ]]; then
  mapfile -t LISTA < <(ls -1d "$DEST_BASE"/*_"$DBNAME"_"$HOST" 2>/dev/null | sort || true)

  TOTAL="${#LISTA[@]}"
  if [[ "$TOTAL" -gt "$BACKUP_KEEP" ]]; then
    BORRAR=$((TOTAL - BACKUP_KEEP))
    for ((i=0; i<BORRAR; i++)); do
      rm -rf -- "${LISTA[$i]}" || true
    done
    echo "OK: Rotación aplicada. Conservadas $BACKUP_KEEP, eliminadas $BORRAR (DB=$DBNAME, HOST=$HOST)"
  fi
else
  echo "WARN: BACKUP_KEEP inválido ($BACKUP_KEEP). No se aplica rotación." >&2
fi

echo "OK: Backup finalizado en: $DEST_DIR"
exit 0

