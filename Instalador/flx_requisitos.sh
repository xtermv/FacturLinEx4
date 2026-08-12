#!/usr/bin/env bash
set -Eeuo pipefail

APP_NAME="FacturLinEx"
REPORT=""
MODE="check"
ASSUME_YES=0

usage() {
  cat <<USAGE
Uso: $0 [--check] [--install] [--report RUTA]

  --check          Solo comprobar requisitos (predeterminado).
  --install        Instalar únicamente paquetes faltantes mediante apt.
  --report RUTA    Guardar informe de texto en la ruta indicada.
  --yes            No pedir confirmación en --install.
  -h, --help       Mostrar esta ayuda.

El modo --install requiere sudo y confirma antes de modificar el sistema.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check) MODE="check"; shift ;;
    --install) MODE="install"; shift ;;
    --report) REPORT="${2:-}"; [[ -n "$REPORT" ]] || { echo "Falta ruta para --report" >&2; exit 2; }; shift 2 ;;
    --yes) ASSUME_YES=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Opción desconocida: $1" >&2; usage; exit 2 ;;
  esac
done

if [[ -z "$REPORT" ]]; then
  REPORT="${PWD}/REQUISITOS_FACTURLINEX_$(date +%Y%m%d_%H%M%S).txt"
fi

# Paquetes obligatorios para instalación/operación básica.
REQUIRED_PACKAGES=(
  mariadb-client
  rsync
  openssl
  ca-certificates
  policykit-1
  xdg-utils
  cups-client
  zip
  unzip
  file
)

# Opcionales: solo amplían funciones concretas.
OPTIONAL_PACKAGES=(
  lftp
  p7zip-full
)

# Paquetes alternativos que pueden satisfacer una función.
declare -A COMMAND_FOR_PACKAGE=(
  [mariadb-client]="mariadb mysql"
  [rsync]="rsync"
  [openssl]="openssl"
  [ca-certificates]="update-ca-certificates"
  [policykit-1]="pkexec"
  [xdg-utils]="xdg-open"
  [cups-client]="lp lpr"
  [zip]="zip"
  [unzip]="unzip"
  [file]="file"
  [lftp]="lftp"
  [p7zip-full]="7z 7zz"
)

MISSING_REQUIRED=()
MISSING_OPTIONAL=()
FOUND_COUNT=0

have_any_command() {
  local cmd
  for cmd in $1; do
    if command -v "$cmd" >/dev/null 2>&1; then
      return 0
    fi
  done
  return 1
}

check_package() {
  local pkg="$1"
  local commands="${COMMAND_FOR_PACKAGE[$pkg]}"
  local found=""
  local cmd

  # Algunos paquetes (por ejemplo ca-certificates) son datos/configuración,
  # no una herramienta que deba tener un comando visible en PATH.
  if command -v dpkg-query >/dev/null 2>&1; then
    if dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q '^install ok installed$'; then
      for cmd in $commands; do
        if command -v "$cmd" >/dev/null 2>&1; then
          found="$(command -v "$cmd")"
          break
        fi
      done
      [[ -n "$found" ]] || found="paquete instalado"
      printf '[OK] %-20s %s\n' "$pkg" "$found"
      FOUND_COUNT=$((FOUND_COUNT + 1))
      return 0
    fi
  fi

  # Fallback por funcionalidad/comando para paquetes alternativos.
  if have_any_command "$commands"; then
    for cmd in $commands; do
      if command -v "$cmd" >/dev/null 2>&1; then
        found="$(command -v "$cmd")"
        break
      fi
    done
    printf '[OK] %-20s %s\n' "$pkg" "$found"
    FOUND_COUNT=$((FOUND_COUNT + 1))
    return 0
  fi

  return 1
}

{
  echo "============================================================"
  echo " $APP_NAME - Diagnóstico de requisitos"
  echo "============================================================"
  echo "Fecha:        $(date '+%d/%m/%Y %H:%M:%S')"
  echo "Equipo:       $(hostname 2>/dev/null || echo desconocido)"
  echo "Usuario:      ${USER:-desconocido}"
  echo "Sistema:      $(. /etc/os-release 2>/dev/null && echo "${PRETTY_NAME:-Linux}" || uname -s)"
  echo "Arquitectura: $(uname -m)"
  echo
  echo "REQUISITOS OBLIGATORIOS"
  echo "-----------------------"
  for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! check_package "$pkg"; then
      printf '[FALTA] %-17s instalar con apt\n' "$pkg"
      MISSING_REQUIRED+=("$pkg")
    fi
  done
  echo
  echo "REQUISITOS OPCIONALES"
  echo "---------------------"
  for pkg in "${OPTIONAL_PACKAGES[@]}"; do
    if ! check_package "$pkg"; then
      printf '[OPCIONAL] %-15s no instalado\n' "$pkg"
      MISSING_OPTIONAL+=("$pkg")
    fi
  done
  echo
  echo "RUTAS DE INSTALACIÓN PREVISTAS"
  echo "------------------------------"
  for path in /usr/bin /usr/share /etc /var/log; do
    if [[ -d "$path" ]]; then
      printf '[OK] %s\n' "$path"
    else
      printf '[ERROR] No existe %s\n' "$path"
    fi
  done
  echo
  echo "RESUMEN"
  echo "-------"
  echo "Obligatorios ausentes: ${#MISSING_REQUIRED[@]}"
  echo "Opcionales ausentes:   ${#MISSING_OPTIONAL[@]}"
  if [[ ${#MISSING_REQUIRED[@]} -eq 0 ]]; then
    echo "Resultado: SISTEMA PREPARADO PARA LA FASE DE INSTALACIÓN"
  else
    echo "Resultado: FALTAN DEPENDENCIAS OBLIGATORIAS"
    echo "Paquetes: ${MISSING_REQUIRED[*]}"
  fi
} | tee "$REPORT"

if [[ "$MODE" == "check" ]]; then
  echo
  echo "Informe guardado en: $REPORT"
  [[ ${#MISSING_REQUIRED[@]} -eq 0 ]] && exit 0 || exit 3
fi

if [[ ${#MISSING_REQUIRED[@]} -eq 0 ]]; then
  echo "No hay paquetes obligatorios pendientes. No se modifica el sistema."
  exit 0
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "ERROR: este asistente requiere apt-get (Debian/Ubuntu)." >&2
  exit 4
fi

echo
echo "Se instalarán estos paquetes obligatorios:"
printf '  - %s\n' "${MISSING_REQUIRED[@]}"
if ((ASSUME_YES == 0)); then
  read -r -p "¿Continuar? [s/N] " answer
  [[ "${answer,,}" == "s" || "${answer,,}" == "si" || "${answer,,}" == "sí" ]] || {
    echo "Operación cancelada. No se ha modificado el sistema."
    exit 0
  }
fi
apt-get update
apt-get install -y "${MISSING_REQUIRED[@]}"
echo "Dependencias instaladas."
