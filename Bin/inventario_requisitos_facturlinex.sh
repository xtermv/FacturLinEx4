#!/usr/bin/env bash
# Inventario de requisitos de FacturLinEx
# Uso:
#   ./inventario_requisitos_facturlinex.sh /ruta/al/binario [/ruta/al/proyecto]
#
# No modifica el sistema. Solo genera informes en la carpeta actual.

set -u

BINARIO="${1:-}"
PROYECTO="${2:-}"
FECHA="$(date +%Y%m%d_%H%M%S)"
SALIDA="$PWD/inventario_facturlinex_$FECHA"

if [[ -z "$BINARIO" ]]; then
  echo "Uso: $0 /ruta/al/binario [/ruta/al/proyecto]" >&2
  exit 1
fi

if [[ ! -f "$BINARIO" ]]; then
  echo "No existe el binario: $BINARIO" >&2
  exit 1
fi

mkdir -p "$SALIDA"

{
  echo "=== FECHA ==="
  date --iso-8601=seconds 2>/dev/null || date
  echo
  echo "=== SISTEMA ==="
  cat /etc/os-release 2>/dev/null || true
  echo
  uname -a
  echo
  echo "Arquitectura dpkg: $(dpkg --print-architecture 2>/dev/null || echo desconocida)"
  echo "Arquitecturas adicionales: $(dpkg --print-foreign-architectures 2>/dev/null | tr '\n' ' ')"
} > "$SALIDA/01_sistema.txt"

{
  echo "=== BINARIO ==="
  printf 'Ruta: %s\n' "$(readlink -f "$BINARIO" 2>/dev/null || printf '%s' "$BINARIO")"
  ls -l "$BINARIO"
  echo
  command -v file >/dev/null 2>&1 && file "$BINARIO"
  echo
  if command -v readelf >/dev/null 2>&1; then
    echo "=== CABECERA ELF ==="
    readelf -h "$BINARIO"
    echo
    echo "=== BIBLIOTECAS NEEDED ==="
    readelf -d "$BINARIO" | grep -E 'NEEDED|RPATH|RUNPATH' || true
    echo
    echo "=== VERSIONES DE SÍMBOLOS ==="
    readelf --version-info "$BINARIO" 2>/dev/null || true
  else
    echo "readelf no está instalado (paquete binutils)."
  fi
} > "$SALIDA/02_binario.txt" 2>&1

{
  echo "=== SALIDA DE LDD ==="
  # Usar únicamente con el binario propio y de confianza.
  ldd "$BINARIO" 2>&1 || true
} > "$SALIDA/03_ldd.txt"

# Extraer rutas de bibliotecas de ldd y relacionarlas con paquetes Debian.
if command -v ldd >/dev/null 2>&1; then
  ldd "$BINARIO" 2>/dev/null |
    awk '
      /=> \// {print $3}
      /^\//   {print $1}
    ' |
    sort -u > "$SALIDA/04_rutas_bibliotecas.txt"

  {
    printf "%-42s | %-45s | %s\n" "PAQUETE" "BIBLIOTECA" "RUTA REAL"
    printf '%*s\n' 140 '' | tr ' ' '-'
    while IFS= read -r biblioteca; do
      [[ -n "$biblioteca" ]] || continue
      real="$(readlink -f "$biblioteca" 2>/dev/null || printf '%s' "$biblioteca")"
      propietario="$(
        dpkg-query -S "$biblioteca" 2>/dev/null | head -n1 ||
        dpkg-query -S "$real" 2>/dev/null | head -n1 ||
        true
      )"
      paquete="${propietario%%:*}"
      [[ -n "$paquete" ]] || paquete="NO IDENTIFICADO"
      printf "%-42s | %-45s | %s\n" "$paquete" "$(basename "$biblioteca")" "$real"
    done < "$SALIDA/04_rutas_bibliotecas.txt"
  } > "$SALIDA/05_bibliotecas_y_paquetes.txt"

  awk -F'|' '
    NR > 2 {
      gsub(/^[ \t]+|[ \t]+$/, "", $1);
      if ($1 != "" && $1 != "NO IDENTIFICADO") print $1
    }
  ' "$SALIDA/05_bibliotecas_y_paquetes.txt" |
    sort -u > "$SALIDA/06_paquetes_binario.txt"
fi

{
  echo "=== PAQUETES INSTALADOS POSIBLEMENTE RELACIONADOS ==="
  dpkg-query -W -f='${binary:Package}\t${Version}\n' 2>/dev/null |
    grep -Ei \
      '(^|:)(mariadb|mysql|libmariadb|libmysql|gtk|libgtk|glib|pango|cairo|cups|printer|ghostscript|poppler|openssl|libssl|curl|wget|zip|unzip|rsync|ssh|smtp|mail|xdg-utils|desktop-file-utils|libqt|libx11|libfontconfig|libfreetype)' |
    sort -u || true
} > "$SALIDA/07_paquetes_relacionados_instalados.txt"

if [[ -n "$PROYECTO" && -d "$PROYECTO" ]]; then
  {
    echo "=== ARCHIVOS DEL PROYECTO ==="
    find "$PROYECTO" -type f -printf '%m\t%u:%g\t%p\n' 2>/dev/null | sort
  } > "$SALIDA/08_archivos_proyecto.txt"

  {
    echo "=== SCRIPTS SHELL ==="
    find "$PROYECTO" -type f \( -iname '*.sh' -o -iname '*.bash' \) \
      -printf '%m\t%u:%g\t%p\n' 2>/dev/null | sort
  } > "$SALIDA/09_scripts_shell.txt"

  {
    echo "=== POSIBLES COMANDOS, LIBRERÍAS Y RUTAS EXTERNAS ==="
    echo "Revisar manualmente: puede contener falsos positivos."
    grep -RInE \
      --include='*.pas' --include='*.pp' --include='*.inc' \
      --include='*.lpr' --include='*.sh' --include='*.bash' \
      '(TProcess|ExecuteProcess|RunCommand|fpSystem|ShellExecute|LoadLibrary|dlopen|/usr/bin/|/bin/|/sbin/|mariadb|mysql|mysqldump|mariadb-dump|lp|lpr|cups|xdg-open|gio open|evince|atril|okular|zip|unzip|tar|gzip|bzip2|xz|rsync|ssh|scp|sftp|curl|wget|sendmail|mailx|openssl|wkhtmltopdf|libmysql|libmariadb|libssl|libcrypto)' \
      "$PROYECTO" 2>/dev/null || true
  } > "$SALIDA/10_referencias_externas_codigo.txt"

  {
    echo "=== RECURSOS QUE DEBEN EMPAQUETARSE ==="
    find "$PROYECTO" -type f \( \
      -iname '*.lrf' -o -iname '*.frf' -o -iname '*.sql' -o \
      -iname '*.cfg' -o -iname '*.conf' -o -iname '*.ini' -o \
      -iname '*.xml' -o -iname '*.json' -o -iname '*.csv' -o \
      -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o \
      -iname '*.svg' -o -iname '*.ico' -o -iname '*.desktop' -o \
      -iname '*.sh' -o -iname '*.pdf' -o -iname '*.html' -o \
      -iname '*.css' -o -iname '*.js' \
    \) -printf '%s\t%p\n' 2>/dev/null | sort -n
  } > "$SALIDA/11_recursos_para_empaquetar.txt"
else
  {
    echo "No se indicó una carpeta de proyecto válida."
    echo "Ejecute de nuevo pasando también la carpeta raíz del proyecto para analizar scripts y recursos."
  } > "$SALIDA/08_sin_proyecto.txt"
fi

cat > "$SALIDA/12_prueba_dinamica.txt" <<EOF
PRUEBA DINÁMICA RECOMENDADA
===========================

Instalar strace:
  sudo apt install strace

Ejecutar FacturLinEx con una BASE DE DATOS DE PRUEBA y recorrer sus funciones:
  strace -f -o "$SALIDA/facturlinex.strace" -e trace=file,process "$BINARIO"

Extraer procesos externos y archivos/librerías que no se encontraron:
  grep -E 'execve\(|ENOENT' "$SALIDA/facturlinex.strace" > "$SALIDA/13_strace_execve_enoent.txt"

IMPORTANTE:
- No use credenciales reales si FacturLinEx las pasa como argumentos a comandos externos.
- Revise y oculte contraseñas, usuarios, direcciones y datos de clientes antes de compartir el trace.
- Hay que probar impresión, PDF, correo, copias, restauración, importación/exportación,
  conexión MariaDB y cualquier módulo opcional.
EOF

{
  echo "Inventario generado en:"
  echo "$SALIDA"
  echo
  echo "Archivos más importantes:"
  echo "  05_bibliotecas_y_paquetes.txt"
  echo "  06_paquetes_binario.txt"
  echo "  10_referencias_externas_codigo.txt"
  echo "  11_recursos_para_empaquetar.txt"
  echo "  12_prueba_dinamica.txt"
} | tee "$SALIDA/00_LEEME.txt"

echo
echo "Terminado: $SALIDA"
