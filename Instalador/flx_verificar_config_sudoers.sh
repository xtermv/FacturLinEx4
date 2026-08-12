#!/usr/bin/env bash
set -Eeuo pipefail

MODE="install"
while (($#)); do
  case "$1" in
    --check) MODE="check"; shift ;;
    --install) MODE="install"; shift ;;
    *) shift ;;
  esac
done

ERRORS=0
WARNINGS=0

prospective() {
  local label="$1" path="$2" kind="$3"
  if [[ "$kind" == "file" && -f "$path" ]] || [[ "$kind" == "dir" && -d "$path" ]]; then
    echo "[ OK  ] $label"
    return
  fi

  if [[ "$MODE" == "check" ]]; then
    echo "[PREVISTO] $label: se creará durante la instalación"
  else
    echo "[ERROR] $label"
    ERRORS=$((ERRORS+1))
  fi
}

prospective "Configuración instalada" "/etc/facturlinex2/FacturConf.ini" file

if [[ -f /etc/facturlinex2/FacturConf.ini ]]; then
  perm="$(stat -c '%a' /etc/facturlinex2/FacturConf.ini 2>/dev/null || echo '')"
  [[ "$perm" == "640" || "$perm" == "600" ]] \
    && echo "[ OK  ] Configuración no accesible a todos" \
    || { echo "[AVISO] Revisar permisos de FacturConf.ini"; WARNINGS=$((WARNINGS+1)); }
else
  [[ "$MODE" == "check" ]] \
    && echo "[PREVISTO] Permisos restringidos para FacturConf.ini" \
    || true
fi

prospective "Directorio de auxiliares" "/usr/local/lib/facturlinex2" dir
prospective "Sudoers de FacturLinEx" "/etc/sudoers.d/facturlinex2" file

if ((ERRORS)); then
  echo "Verificación configuración/sudoers: $ERRORS error(es), $WARNINGS aviso(s)."
  exit 1
fi

if [[ "$MODE" == "check" ]]; then
  echo "[OK] Comprobación prospectiva de configuración/sudoers."
else
  echo "[OK] Configuración/sudoers verificados."
fi
exit 0
