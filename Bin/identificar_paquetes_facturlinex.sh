#!/usr/bin/env bash
# Identifica los paquetes Debian propietarios de las bibliotecas de un ejecutable.
# No instala, elimina ni modifica ningún paquete.
#
# Uso:
#   ./identificar_paquetes_facturlinex.sh /ruta/al/FacturLinEx

set -u

BINARIO="${1:-}"

if [[ -z "$BINARIO" || ! -f "$BINARIO" ]]; then
  echo "Uso: $0 /ruta/al/FacturLinEx" >&2
  exit 1
fi

if ! command -v readelf >/dev/null 2>&1; then
  echo "Falta readelf. Instálelo con: sudo apt install binutils" >&2
  exit 1
fi

if ! command -v dpkg-query >/dev/null 2>&1; then
  echo "No se encuentra dpkg-query." >&2
  exit 1
fi

SALIDA="paquetes_facturlinex_$(date +%Y%m%d_%H%M%S).txt"
TMP_LDD="$(mktemp)"
TMP_NEEDED="$(mktemp)"
trap 'rm -f "$TMP_LDD" "$TMP_NEEDED"' EXIT

ldd "$BINARIO" > "$TMP_LDD" 2>&1

if grep -qi "not found" "$TMP_LDD"; then
  echo "ATENCIÓN: faltan bibliotecas:"
  grep -i "not found" "$TMP_LDD"
  echo
fi

readelf -d "$BINARIO" 2>/dev/null |
  sed -n 's/.*Biblioteca compartida: \[\(.*\)\]/\1/p' |
  sort -u > "$TMP_NEEDED"

buscar_paquete() {
  local ruta="$1"
  local real=""
  local usr_ruta=""
  local propietario=""

  [[ -n "$ruta" ]] || return 0

  real="$(readlink -f "$ruta" 2>/dev/null || printf '%s' "$ruta")"

  case "$ruta" in
    /lib/*|/bin/*|/sbin/*)
      usr_ruta="/usr$ruta"
      ;;
  esac

  for candidato in "$ruta" "$usr_ruta" "$real"; do
    [[ -n "$candidato" ]] || continue
    propietario="$(dpkg-query -S "$candidato" 2>/dev/null | head -n1 || true)"
    if [[ -n "$propietario" ]]; then
      printf '%s' "$propietario" | sed 's/: .*//'
      return 0
    fi
  done

  # Último intento: buscar por el nombre exacto del enlace de biblioteca.
  propietario="$(dpkg-query -S "*/$(basename "$ruta")" 2>/dev/null | head -n1 || true)"
  if [[ -n "$propietario" ]]; then
    printf '%s' "$propietario" | sed 's/: .*//'
  else
    printf 'NO IDENTIFICADO'
  fi
}

ruta_ldd_para() {
  local nombre="$1"
  awk -v lib="$nombre" '
    $1 == lib && $2 == "=>" { print $3; exit }
    $1 == lib && $1 ~ /^\// { print $1; exit }
  ' "$TMP_LDD"
}

{
  echo "INFORME DE PAQUETES DE FACTURLINEX"
  echo "================================="
  echo "Binario: $(readlink -f "$BINARIO")"
  echo "Fecha:   $(date --iso-8601=seconds 2>/dev/null || date)"
  echo

  echo "1. BIBLIOTECAS DIRECTAS DEL EJECUTABLE"
  echo "--------------------------------------"
  printf "%-34s | %-32s | %s\n" "BIBLIOTECA" "PAQUETE DEBIAN" "RUTA"
  printf '%*s\n' 120 '' | tr ' ' '-'

  while IFS= read -r biblioteca; do
    [[ -n "$biblioteca" ]] || continue
    ruta="$(ruta_ldd_para "$biblioteca")"
    paquete="$(buscar_paquete "$ruta")"
    printf "%-34s | %-32s | %s\n" "$biblioteca" "$paquete" "$ruta"
  done < "$TMP_NEEDED"

  echo
  echo "2. PAQUETES DIRECTOS ÚNICOS"
  echo "---------------------------"

  while IFS= read -r biblioteca; do
    [[ -n "$biblioteca" ]] || continue
    ruta="$(ruta_ldd_para "$biblioteca")"
    buscar_paquete "$ruta"
    echo
  done < "$TMP_NEEDED" |
    grep -v '^NO IDENTIFICADO$' |
    sort -u

  echo
  echo "3. TODAS LAS BIBLIOTECAS CARGADAS POR LDD"
  echo "------------------------------------------"
  printf "%-34s | %-32s | %s\n" "BIBLIOTECA" "PAQUETE DEBIAN" "RUTA"
  printf '%*s\n' 120 '' | tr ' ' '-'

  awk '
    /=> \// {print $1 "|" $3}
    /^\//   {print $1 "|" $1}
  ' "$TMP_LDD" |
    sort -u |
    while IFS='|' read -r biblioteca ruta; do
      paquete="$(buscar_paquete "$ruta")"
      printf "%-34s | %-32s | %s\n" "$biblioteca" "$paquete" "$ruta"
    done

  echo
  echo "NOTA:"
  echo "- La sección 2 es la candidata inicial para Depends."
  echo "- No añadiremos todavía MariaDB, impresión, PDF, correo o copias:"
  echo "  esas dependencias se comprobarán analizando el proyecto y los scripts."
} | tee "$SALIDA"

echo
echo "Informe guardado en: $SALIDA"
