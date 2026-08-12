#!/usr/bin/env bash
set -Eeuo pipefail

errors=0

check_exec() {
  if [[ -x "$1" ]]; then
    echo "[ OK ] $1"
  else
    echo "[ERROR] $1"
    errors=$((errors+1))
  fi
}

check_exec /usr/bin/FacturLinEx
check_exec /usr/bin/FLXTools
check_exec /usr/bin/FLXMantenimiento
check_exec /usr/bin/FLXInstaller

[[ -f /usr/share/applications/facturlinex-tools.desktop ]]   && echo "[ OK ] Acceso FLXTools"   || echo "[AVISO] Falta acceso FLXTools"

[[ -f /usr/share/applications/facturlinex-mantenimiento.desktop ]]   && echo "[ OK ] Acceso Mantenimiento"   || echo "[AVISO] Falta acceso Mantenimiento"

if [[ $errors -gt 0 ]]; then
  echo "Resultado: INTEGRACIÓN INCOMPLETA"
  exit 1
fi

echo "Resultado: ECOSISTEMA INTEGRADO"
