#!/usr/bin/env bash
set -Eeuo pipefail

PACKAGE=""

usage() {
  echo "Uso: flx_verificar_paquete.sh --package DIR"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --package) PACKAGE="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Opción desconocida: $1" >&2; usage; exit 2 ;;
  esac
done

[[ -n "$PACKAGE" && -d "$PACKAGE" ]] || { echo "ERROR: falta --package DIR válido." >&2; exit 2; }

MANIFEST="$PACKAGE/Metadatos/MANIFEST.sha256"
VERSION_FILE="$PACKAGE/Metadatos/VERSION.txt"

[[ -f "$MANIFEST" ]] || { echo "ERROR: falta el manifiesto SHA-256." >&2; exit 1; }
[[ -f "$VERSION_FILE" ]] || { echo "ERROR: falta VERSION.txt." >&2; exit 1; }
[[ -x "$PACKAGE/Bin/FacturLinEx" ]] || { echo "ERROR: falta el binario ejecutable." >&2; exit 1; }
[[ -x "$PACKAGE/Instalador/instalar_facturlinex.sh" ]] || {
  echo "ERROR: falta el instalador maestro." >&2
  exit 1
}

echo "============================================================"
echo " Verificación de paquete FacturLinEx"
echo "============================================================"
grep -E '^(VersionCompleta|Edicion|IdentificadorSistema|Estado)=' "$VERSION_FILE" || true
echo

(
  cd "$PACKAGE"
  sha256sum -c "Metadatos/MANIFEST.sha256"
)

echo
echo "[ OK ] Todos los archivos coinciden con el manifiesto."
echo "[INFO] La integridad técnica no equivale a certificación legal."
