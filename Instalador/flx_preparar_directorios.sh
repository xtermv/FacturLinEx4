#!/usr/bin/env bash
set -Eeuo pipefail

MODE="check"
APP_USER="${SUDO_USER:-${USER:-}}"
ASSUME_YES=0

usage(){
  cat <<'EOF'
Uso:
  flx_preparar_directorios.sh --check
  flx_preparar_directorios.sh --create --app-user USUARIO [--yes]
EOF
}
need_value(){ [[ $# -ge 2 ]] || { echo "ERROR: falta valor para $1" >&2; exit 2; }; }
while (($#)); do
  case "$1" in
    --check) MODE="check"; shift ;;
    --create|--install) MODE="create"; shift ;;
    --app-user) need_value "$1" "$#"; APP_USER="$2"; shift 2 ;;
    --yes) ASSUME_YES=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Opción desconocida: $1" >&2; exit 2 ;;
  esac
done

DIRS=(
  /usr/share/facturlinex2
  /usr/share/facturlinex2/Report
  /usr/share/facturlinex2/Documentacion
  /etc/facturlinex2
  /var/log/facturlinex2
)

if [[ "$MODE" == "check" ]]; then
  echo "Comprobación de directorios FacturLinEx"
  for d in "${DIRS[@]}"; do
    [[ -d "$d" ]] && echo "[OK] $d" || echo "[PREVISTO] Se creará durante la instalación: $d"
  done
  exit 0
fi

((EUID==0)) || { echo "ERROR: la creación requiere privilegios administrativos." >&2; exit 1; }
[[ -n "$APP_USER" ]] && id "$APP_USER" >/dev/null 2>&1 || { echo "ERROR: usuario de aplicación no válido: $APP_USER" >&2; exit 1; }

if ((ASSUME_YES==0)); then
  read -r -p "Se crearán directorios del sistema. ¿Continuar? [s/N] " answer
  [[ "$answer" =~ ^[sS]$ ]] || { echo "Cancelado."; exit 0; }
fi

install -d -m 0755 /usr/share/facturlinex2 /usr/share/facturlinex2/Report /usr/share/facturlinex2/Documentacion
install -d -m 0750 /etc/facturlinex2 /var/log/facturlinex2
chown -R "$APP_USER:$APP_USER" /usr/share/facturlinex2
chmod -R u+rwX,go+rX /usr/share/facturlinex2

echo "[OK] Directorios preparados."
echo "[OK] /usr/share/facturlinex2 -> ${APP_USER}:${APP_USER}, escritura para el usuario."
