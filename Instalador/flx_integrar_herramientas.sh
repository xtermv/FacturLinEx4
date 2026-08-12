#!/usr/bin/env bash
set -Eeuo pipefail

MODE="check"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check) MODE="check"; shift ;;
    --install) MODE="install"; shift ;;
    --root) ROOT="$2"; shift 2 ;;
    *) echo "Uso: $0 [--check|--install] [--root DIR]"; exit 2 ;;
  esac
done

TOOLS="$ROOT/Bin/FLXTools"
MAINT="$ROOT/Bin/FLXMantenimiento"
INSTALLER="$ROOT/Bin/FLXInstaller"

echo "FacturLinEx - Integración de herramientas"
for F in "$TOOLS" "$MAINT" "$INSTALLER"; do
  if [[ -x "$F" ]]; then
    echo "[ OK ] $F"
  else
    echo "[AVISO] No localizado: $F"
  fi
done

if [[ "$MODE" == "check" ]]; then
  echo "Simulación terminada. No se ha modificado nada."
  exit 0
fi

[[ $EUID -eq 0 ]] || { echo "ERROR: --install requiere sudo."; exit 1; }

[[ -x "$TOOLS" ]] && install -m 0755 "$TOOLS" /usr/bin/FLXTools
[[ -x "$MAINT" ]] && install -m 0755 "$MAINT" /usr/bin/FLXMantenimiento
[[ -x "$INSTALLER" ]] && install -m 0755 "$INSTALLER" /usr/bin/FLXInstaller

if [[ -f "$ROOT/FLXTools/facturlinex-tools.desktop" ]]; then
  install -m 0644 "$ROOT/FLXTools/facturlinex-tools.desktop"     /usr/share/applications/facturlinex-tools.desktop
fi

if [[ -f "$ROOT/FLXMantenimiento/facturlinex-mantenimiento.desktop" ]]; then
  install -m 0644 "$ROOT/FLXMantenimiento/facturlinex-mantenimiento.desktop"     /usr/share/applications/facturlinex-mantenimiento.desktop
fi

echo "[ OK ] Herramientas integradas."
