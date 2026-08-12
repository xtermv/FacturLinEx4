#!/usr/bin/env bash
set -Eeuo pipefail

MODE="check"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SSH_USER="${SUDO_USER:-${USER:-facturlinex}}"
ASSUME_YES=0
LOG_DIR="/var/log/facturlinex2"
SERVER_DIR=""
REMOTE_SCRIPT=""
BACKUP_DIR="/var/backups/facturlinex"
CONF_DIR="/etc/facturlinex"
CONF_FILE="$CONF_DIR/backup.cnf"
SUDOERS_FILE="/etc/sudoers.d/facturlinex-backup"
DEST_SCRIPT="/usr/local/sbin/flx_remote_backup_server"
DB_BACKUP_USER="facturlinex_backup"

usage() {
  cat <<'USAGE'
Instalador de servidor FacturLinEx 4.2.6J

Uso:
  instalar_servidor_facturlinex.sh --check [--source DIR] [--ssh-user USUARIO]
  instalar_servidor_facturlinex.sh --verify [--source DIR] [--ssh-user USUARIO]
  sudo instalar_servidor_facturlinex.sh --install [--source DIR] [--ssh-user USUARIO] [--yes]

Prepara un servidor MariaDB que NO necesita ejecutar la aplicación gráfica:
  - mariadb-server y mariadb-client
  - mariadb-backup
  - openssh-server
  - sudo, tar, coreutils, openssl y utilidades
  - /usr/local/sbin/flx_remote_backup_server
  - usuario MariaDB facturlinex_backup con privilegios mínimos
  - /etc/facturlinex/backup.cnf (root:root 0600)
  - /etc/sudoers.d/facturlinex-backup (0440)
  - /var/backups/facturlinex
  - prueba final FLX_SERVER_OK

No instala /usr/bin/FacturLinEx ni componentes gráficos.
USAGE
}

need_value() {
  [[ $# -ge 2 ]] || { echo "ERROR: falta valor para $1" >&2; exit 2; }
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check) MODE="check"; shift ;;
    --verify) MODE="verify"; shift ;;
    --install) MODE="install"; shift ;;
    --source) need_value "$1" "$#"; SOURCE_DIR="$2"; shift 2 ;;
    --ssh-user) need_value "$1" "$#"; SSH_USER="$2"; shift 2 ;;
    --yes) ASSUME_YES=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "ERROR: opción desconocida: $1" >&2; usage; exit 2 ;;
  esac
done

SERVER_DIR="$SOURCE_DIR/Instalador/servidor"
REMOTE_SCRIPT="$SERVER_DIR/flx_remote_backup_server"

[[ -f "$REMOTE_SCRIPT" ]] || { echo "ERROR: falta $REMOTE_SCRIPT" >&2; exit 1; }
/bin/bash -n "$REMOTE_SCRIPT"

pkg_installed() { dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q 'ok installed'; }
cmd_state() { command -v "$1" >/dev/null 2>&1 && echo "[OK]" || echo "[SE INSTALARÁ]"; }

echo "============================================================"
echo " INSTALADOR SERVIDOR FACTURLINEX 4.2.6J"
echo "============================================================"
echo "Modo         : $MODE"
echo "Origen       : $SOURCE_DIR"
echo "Usuario SSH  : $SSH_USER"
echo "Script remoto: $REMOTE_SCRIPT"
echo

echo "Componentes del servidor:"
printf '  %-18s %s\n' "MariaDB" "$(cmd_state mariadb)"
printf '  %-18s %s\n' "mariadb-backup" "$(cmd_state mariadb-backup)"
printf '  %-18s %s\n' "SSH" "$(cmd_state sshd)"
printf '  %-18s %s\n' "sudo/visudo" "$(cmd_state visudo)"
printf '  %-18s %s\n' "openssl" "$(cmd_state openssl)"
printf '  %-18s %s\n' "tar" "$(cmd_state tar)"
printf '  %-18s %s\n' "sha256sum" "$(cmd_state sha256sum)"
echo

if [[ "$MODE" == "verify" ]]; then
  ERRORS=0
  echo "Verificación REAL del servidor instalado:"
  echo "------------------------------------------"

  command -v mariadb >/dev/null 2>&1 && echo "[OK] Cliente MariaDB" || { echo "[ERROR] No se encuentra mariadb"; ERRORS=$((ERRORS+1)); }
  command -v mariadb-backup >/dev/null 2>&1 && echo "[OK] mariadb-backup" || { echo "[ERROR] No se encuentra mariadb-backup"; ERRORS=$((ERRORS+1)); }

  if systemctl is-active --quiet mariadb 2>/dev/null; then echo "[OK] Servicio MariaDB activo"; else echo "[ERROR] Servicio MariaDB no está activo"; ERRORS=$((ERRORS+1)); fi
  if systemctl is-active --quiet ssh 2>/dev/null; then echo "[OK] Servicio SSH activo"; else echo "[ERROR] Servicio SSH no está activo"; ERRORS=$((ERRORS+1)); fi

  [[ -x "$DEST_SCRIPT" ]] && echo "[OK] $DEST_SCRIPT" || { echo "[ERROR] No existe o no es ejecutable: $DEST_SCRIPT"; ERRORS=$((ERRORS+1)); }

  # /etc/facturlinex es deliberadamente root:root 0700. Un usuario normal
  # no debe poder inspeccionar directamente backup.cnf. Su existencia,
  # permisos y credenciales se validan dentro de flx_remote_backup_server test,
  # ejecutado mediante el sudoers limitado.
  echo "[INFO] $CONF_FILE es privado de root; se valida mediante la prueba funcional."

  if [[ -f "$SUDOERS_FILE" ]]; then
    SUDO_STAT="$(stat -c '%U:%G:%a' "$SUDOERS_FILE" 2>/dev/null || true)"
    [[ "$SUDO_STAT" == "root:root:440" ]] && echo "[OK] $SUDOERS_FILE (root:root 0440)" || { echo "[ERROR] Permisos inesperados en $SUDOERS_FILE: ${SUDO_STAT:-desconocidos}"; ERRORS=$((ERRORS+1)); }
  else
    echo "[ERROR] No existe $SUDOERS_FILE"; ERRORS=$((ERRORS+1))
  fi

  if ! id "$SSH_USER" >/dev/null 2>&1; then
    echo "[ERROR] No existe el usuario Linux/SSH: $SSH_USER"
    ERRORS=$((ERRORS+1))
  elif [[ -x "$DEST_SCRIPT" ]]; then
    TEST_OUT="$(sudo -n "$DEST_SCRIPT" test 2>&1 || true)"
    echo "$TEST_OUT"
    if grep -q 'FLX_SERVER_OK' <<<"$TEST_OUT"; then
      echo "[OK] Sudoers, backup.cnf, credenciales MariaDB y prueba funcional remota"
    else
      echo "[ERROR] La prueba funcional no devolvió FLX_SERVER_OK"
      ERRORS=$((ERRORS+1))
    fi
  fi

  echo
  if [[ "$ERRORS" -eq 0 ]]; then
    echo "FLX_SERVER_VERIFY_OK"
    echo "FLX_SERVER_OK"
    exit 0
  fi
  echo "FLX_SERVER_VERIFY_ERROR=$ERRORS"
  exit 1
fi

if [[ "$MODE" == "check" ]]; then
  if id "$SSH_USER" >/dev/null 2>&1; then
    echo "[OK] Usuario Linux existente: $SSH_USER"
  else
    echo "[PREVISTO] Se creará el usuario Linux/SSH: $SSH_USER"
  fi
  echo "[PREVISTO] $DEST_SCRIPT"
  echo "[PREVISTO] $CONF_FILE"
  echo "[PREVISTO] $SUDOERS_FILE"
  echo "[PREVISTO] $BACKUP_DIR"
  echo
  echo "Comprobación prospectiva correcta. No se ha modificado el sistema."
  exit 0
fi

[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo "ERROR: --install requiere privilegios de administrador." >&2; exit 1; }

if [[ $ASSUME_YES -eq 0 ]]; then
  read -r -p "¿Preparar este equipo como servidor FacturLinEx? [s/N]: " ans
  [[ "${ans,,}" == "s" || "${ans,,}" == "si" ]] || exit 0
fi

install -d -o root -g root -m 0755 "$LOG_DIR"
LOG_FILE="$LOG_DIR/install_servidor_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "[1/7] Instalando dependencias..."
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y mariadb-server mariadb-client mariadb-backup openssh-server sudo tar coreutils openssl findutils grep gawk procps

echo "[2/7] Activando servicios..."
systemctl enable --now mariadb
systemctl enable --now ssh
systemctl is-active --quiet mariadb
systemctl is-active --quiet ssh

echo "[3/7] Preparando usuario Linux/SSH..."
if ! id "$SSH_USER" >/dev/null 2>&1; then
  if command -v adduser >/dev/null 2>&1; then
    adduser --disabled-password --gecos "" "$SSH_USER"
  else
    useradd -m -s /bin/bash "$SSH_USER"
  fi
  echo "[INFO] Usuario $SSH_USER creado sin contraseña interactiva."
  echo "[INFO] Para autenticación SSH por contraseña, asígnele después una con: passwd $SSH_USER"
else
  echo "[OK] Usuario existente: $SSH_USER"
fi

echo "[4/7] Instalando script remoto..."
install -d -o root -g root -m 0755 /usr/local/sbin
TMP_SCRIPT="$(mktemp)"
TMP_SUDOERS=""
trap 'rm -f "$TMP_SCRIPT" "${TMP_SUDOERS:-}" 2>/dev/null || true' EXIT
sed 's/\r$//' "$REMOTE_SCRIPT" > "$TMP_SCRIPT"
/bin/bash -n "$TMP_SCRIPT"
install -o root -g root -m 0755 "$TMP_SCRIPT" "$DEST_SCRIPT"
/bin/bash -n "$DEST_SCRIPT"
install -d -o root -g root -m 0700 "$CONF_DIR"
install -d -o root -g root -m 0700 "$BACKUP_DIR"

echo "[5/7] Creando credenciales MariaDB de backup..."
BACKUP_PASS="$(openssl rand -hex 24)"
SOCKET_PATH="$(mariadb -NBe 'SELECT @@socket;' | head -n 1)"
[[ -n "$SOCKET_PATH" ]] || SOCKET_PATH="/run/mysqld/mysqld.sock"

mariadb <<SQL
CREATE USER IF NOT EXISTS '${DB_BACKUP_USER}'@'localhost' IDENTIFIED BY '${BACKUP_PASS}';
ALTER USER '${DB_BACKUP_USER}'@'localhost' IDENTIFIED BY '${BACKUP_PASS}';
FLUSH PRIVILEGES;
SQL
if ! mariadb -e "GRANT RELOAD, PROCESS, LOCK TABLES, BINLOG MONITOR ON *.* TO '${DB_BACKUP_USER}'@'localhost';"; then
  echo "[AVISO] BINLOG MONITOR no está disponible; usando REPLICATION CLIENT."
  mariadb -e "GRANT RELOAD, PROCESS, LOCK TABLES, REPLICATION CLIENT ON *.* TO '${DB_BACKUP_USER}'@'localhost';"
fi
mariadb -e 'FLUSH PRIVILEGES;'

install -o root -g root -m 0600 /dev/null "$CONF_FILE"
cat > "$CONF_FILE" <<EOF_CNF
[client]
user=$DB_BACKUP_USER
password=$BACKUP_PASS
socket=$SOCKET_PATH
EOF_CNF
chown root:root "$CONF_FILE"
chmod 0600 "$CONF_FILE"

echo "[6/7] Configurando sudoers mínimo..."
TMP_SUDOERS="$(mktemp)"
cat > "$TMP_SUDOERS" <<EOF_SUDOERS
# FacturLinEx: permiso limitado al script controlado de copia/restauración.
# Generado automáticamente para el usuario Linux: $SSH_USER
$SSH_USER ALL=(root) NOPASSWD: \\
  $DEST_SCRIPT test, \\
  $DEST_SCRIPT backup *, \\
  $DEST_SCRIPT restore-slot *, \\
  $DEST_SCRIPT restore-check *, \\
  $DEST_SCRIPT restore *
EOF_SUDOERS
chmod 0440 "$TMP_SUDOERS"
visudo -cf "$TMP_SUDOERS"
install -o root -g root -m 0440 "$TMP_SUDOERS" "$SUDOERS_FILE"
visudo -cf "$SUDOERS_FILE"

# Validación global informativa: una incidencia antigua/ajena en otro fichero
# sudoers no debe abortar la instalación si nuestra regla es válida.
if ! visudo -c >/tmp/flx_visudo_global_check.txt 2>&1; then
  echo "[AVISO] La validación global de sudoers detecta incidencias previas/ajenas:"
  sed 's/^/  /' /tmp/flx_visudo_global_check.txt || true
  echo "[AVISO] La regla de FacturLinEx sí es válida: $SUDOERS_FILE"
fi
rm -f /tmp/flx_visudo_global_check.txt 2>/dev/null || true

echo "[7/7] Verificación final..."
command -v mariadb-backup
systemctl is-active mariadb
systemctl is-active ssh
[[ "$(stat -c '%U:%G:%a' "$CONF_FILE")" == "root:root:600" ]]
[[ -x "$DEST_SCRIPT" ]]
mariadb --defaults-extra-file="$CONF_FILE" --batch --skip-column-names -e 'SELECT CURRENT_USER(), 1'

if command -v runuser >/dev/null 2>&1; then
  TEST_OUT="$(runuser -u "$SSH_USER" -- sudo -n "$DEST_SCRIPT" test)"
else
  TEST_OUT="$(su -s /bin/bash "$SSH_USER" -c "sudo -n '$DEST_SCRIPT' test")"
fi
echo "$TEST_OUT"
grep -q 'FLX_SERVER_OK' <<<"$TEST_OUT"

echo
echo "============================================================"
echo " SERVIDOR FACTURLINEX PREPARADO CORRECTAMENTE"
echo "============================================================"
echo "Usuario SSH : $SSH_USER"
echo "Script      : $DEST_SCRIPT"
echo "Credenciales: $CONF_FILE"
echo "Sudoers     : $SUDOERS_FILE"
echo "Copias      : $BACKUP_DIR"
echo "Log         : $LOG_FILE"
echo
echo "La contraseña MariaDB de backup NO se muestra y queda únicamente"
echo "en $CONF_FILE con permisos root:root 0600."
echo "Respuesta de prueba: FLX_SERVER_OK"
