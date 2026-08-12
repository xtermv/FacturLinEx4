#!/usr/bin/env bash
set -Eeuo pipefail

SOURCE=""
OUTPUT=""
VERSION="4.2.6"
EDITION="J"
BINARY=""
INCLUDE_SOURCE=0

usage() {
  cat <<'EOF'
Generador de paquete oficial FacturLinEx 4.2.6

Uso:
  flx_generar_paquete_oficial.sh --source DIR --output DIR [opciones]

Opciones:
  --version VERSION       Versión base. Predeterminado: 4.2.6
  --edition J|X           Edición del productor.
  --binary PATH           Binario a incluir.
  --include-source        Incluye el código fuente limpio.
  -h, --help

Genera:
  FacturLinEx-VERSION-EDICION/
  FacturLinEx-VERSION-EDICION.tar.gz
  FacturLinEx-VERSION-EDICION.sha256
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source) SOURCE="$2"; shift 2 ;;
    --output) OUTPUT="$2"; shift 2 ;;
    --version) VERSION="$2"; shift 2 ;;
    --edition) EDITION="${2^^}"; shift 2 ;;
    --binary) BINARY="$2"; shift 2 ;;
    --include-source) INCLUDE_SOURCE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Opción desconocida: $1" >&2; usage; exit 2 ;;
  esac
done

[[ -n "$SOURCE" && -d "$SOURCE" ]] || { echo "ERROR: falta --source DIR válido." >&2; exit 2; }
[[ -n "$OUTPUT" ]] || { echo "ERROR: falta --output DIR." >&2; exit 2; }
[[ "$EDITION" == "J" || "$EDITION" == "X" ]] || { echo "ERROR: edición debe ser J o X." >&2; exit 2; }

SOURCE="$(cd "$SOURCE" && pwd)"
mkdir -p "$OUTPUT"
OUTPUT="$(cd "$OUTPUT" && pwd)"

[[ -n "$BINARY" ]] || BINARY="$SOURCE/Bin/FacturLinEx"
[[ -x "$BINARY" ]] || { echo "ERROR: binario no válido: $BINARY" >&2; exit 1; }

FULL_VERSION="${VERSION}${EDITION}"
PKG_NAME="FacturLinEx-${FULL_VERSION}"
STAGE="$OUTPUT/$PKG_NAME"
ARCHIVE="$OUTPUT/${PKG_NAME}.tar.gz"
ARCHIVE_HASH="$OUTPUT/${PKG_NAME}.sha256"

rm -rf "$STAGE"
mkdir -p \
  "$STAGE/Bin" \
  "$STAGE/Instalador" \
  "$STAGE/Recursos" \
  "$STAGE/Documentacion" \
  "$STAGE/Metadatos"

install -m 0755 "$BINARY" "$STAGE/Bin/FacturLinEx"

copy_dir_if_exists() {
  local src="$1" dst="$2"
  [[ -d "$src" ]] || return 0
  mkdir -p "$dst"
  rsync -a \
    --exclude='.git/' \
    --exclude='.svn/' \
    --exclude='*.bak' \
    --exclude='*.o' \
    --exclude='*.ppu' \
    --exclude='*.compiled' \
    --exclude='*.zip' \
    --exclude='*.tar.gz' \
    "$src/" "$dst/"
}

copy_dir_if_exists "$SOURCE/Instalador" "$STAGE/Instalador"
copy_dir_if_exists "$SOURCE/Report" "$STAGE/Recursos/Report"
copy_dir_if_exists "$SOURCE/Documents" "$STAGE/Documentacion/Documents"
copy_dir_if_exists "$SOURCE/Documentacion" "$STAGE/Documentacion/Tecnica"
copy_dir_if_exists "$SOURCE/Manual FL2 2026 - V1" "$STAGE/Documentacion/Manual"

for icon in \
  "$SOURCE/facturLinex2-ico.png" \
  "$SOURCE/facturlinex.png" \
  "$SOURCE/FacturLinEx.png"; do
  if [[ -f "$icon" ]]; then
    install -m 0644 "$icon" "$STAGE/Recursos/"
    break
  fi
done

if [[ $INCLUDE_SOURCE -eq 1 ]]; then
  mkdir -p "$STAGE/CodigoFuente"
  rsync -a \
    --exclude='.git/' \
    --exclude='.svn/' \
    --exclude='bak/' \
    --exclude='backup/' \
    --exclude='*.bak' \
    --exclude='*.o' \
    --exclude='*.ppu' \
    --exclude='*.compiled' \
    --exclude='Bin/FacturLinEx' \
    --exclude='*.zip' \
    --exclude='*.tar.gz' \
    "$SOURCE/" "$STAGE/CodigoFuente/"
fi

BUILD_DATE="$(date --iso-8601=seconds)"
GIT_COMMIT=""
if command -v git >/dev/null 2>&1 && git -C "$SOURCE" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  GIT_COMMIT="$(git -C "$SOURCE" rev-parse HEAD 2>/dev/null || true)"
fi

cat > "$STAGE/Metadatos/VERSION.txt" <<EOF
Producto=FacturLinEx
Version=$VERSION
Edicion=$EDITION
VersionCompleta=$FULL_VERSION
FechaPaquete=$BUILD_DATE
CommitGit=$GIT_COMMIT
Productor=PENDIENTE_DE_COMPLETAR
IdentificadorSistema=FLX-$EDITION
Estado=PAQUETE_CANDIDATO_NO_CERTIFICADO
EOF

(
  cd "$STAGE"
  find . -type f ! -path './Metadatos/MANIFEST.sha256' -print0 \
    | sort -z \
    | xargs -0 sha256sum > Metadatos/MANIFEST.sha256
)

cat > "$STAGE/LEEME_PRIMERO.txt" <<EOF
FACTURLINEX $FULL_VERSION
========================

Este paquete es un candidato de instalación.

Antes de usarlo:
1. Verifique la integridad con Instalador/flx_verificar_paquete.sh.
2. Ejecute el instalador en modo --check.
3. Pruebe la instalación en un equipo no productivo.
4. Complete productor, declaración responsable y documentación final.

La declaración responsable solo cubrirá la edición y compilación oficial
identificadas en este paquete. Una recompilación o modificación de terceros
no queda amparada por ella.
EOF

tar -C "$OUTPUT" -czf "$ARCHIVE" "$PKG_NAME"
sha256sum "$ARCHIVE" > "$ARCHIVE_HASH"

echo "Paquete generado:"
echo "  Directorio : $STAGE"
echo "  Archivo    : $ARCHIVE"
echo "  SHA-256    : $ARCHIVE_HASH"
echo
echo "Versión completa: $FULL_VERSION"
echo "Identificador: FLX-$EDITION"
