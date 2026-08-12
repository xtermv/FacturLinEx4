#!/usr/bin/env bash
set -Eeuo pipefail

MODE="install"

usage() {
  cat <<'EOF'
Uso:
  flx_verificar_instalacion.sh --check
  flx_verificar_instalacion.sh --install

--check   Verificación prospectiva: no exige que ya existan los destinos
          que precisamente creará la instalación.
--install Verificación estricta posterior a la instalación.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check) MODE="check"; shift ;;
    --install) MODE="install"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Opción desconocida: $1" >&2; usage; exit 2 ;;
  esac
done

ERRORS=0
WARNINGS=0

check_file_installed() {
  local p="$1"
  if [[ -f "$p" ]]; then
    echo "[OK] $p"
  elif [[ "$MODE" == "check" ]]; then
    echo "[PREVISTO] Se creará durante la instalación: $p"
  else
    echo "[ERROR] Falta $p"
    ERRORS=$((ERRORS+1))
  fi
}

check_dir_installed() {
  local p="$1"
  if [[ -d "$p" ]]; then
    echo "[OK] $p"
  elif [[ "$MODE" == "check" ]]; then
    echo "[PREVISTO] Se creará durante la instalación: $p"
  else
    echo "[ERROR] Falta $p"
    ERRORS=$((ERRORS+1))
  fi
}

echo "============================================================"
echo " FacturLinEx - Verificación final"
echo "============================================================"
echo "Modo: $MODE"
echo

check_file_installed /usr/bin/FacturLinEx
if [[ -f /usr/bin/FacturLinEx ]]; then
  [[ -x /usr/bin/FacturLinEx ]] \
    && echo "[OK] El binario instalado es ejecutable" \
    || {
      if [[ "$MODE" == "check" ]]; then
        echo "[AVISO] El binario existente no es ejecutable"
        WARNINGS=$((WARNINGS+1))
      else
        echo "[ERROR] El binario no es ejecutable"
        ERRORS=$((ERRORS+1))
      fi
    }
fi

check_dir_installed /usr/share/facturlinex2
check_dir_installed /usr/share/facturlinex2/Report
check_dir_installed /usr/share/facturlinex2/Documentacion
check_dir_installed /etc/facturlinex2
check_dir_installed /var/log/facturlinex2
check_file_installed /usr/share/applications/facturlinex2.desktop

command -v openssl >/dev/null 2>&1 \
  && echo "[OK] OpenSSL" \
  || { echo "[ERROR] OpenSSL no localizado"; ERRORS=$((ERRORS+1)); }

if command -v mariadb >/dev/null 2>&1 || command -v mysql >/dev/null 2>&1; then
  echo "[OK] Cliente MariaDB/MySQL"
else
  echo "[ERROR] Cliente MariaDB/MySQL no localizado"
  ERRORS=$((ERRORS+1))
fi

echo
if ((ERRORS)); then
  echo "Verificación terminada con $ERRORS error(es) y $WARNINGS aviso(s)."
  exit 1
fi

if [[ "$MODE" == "check" ]]; then
  echo "Comprobación prospectiva correcta."
  echo "Los elementos marcados [PREVISTO] no existen todavía y serán creados por --install."
else
  echo "Instalación básica verificada correctamente."
fi

if ((WARNINGS)); then
  echo "Avisos: $WARNINGS"
fi

exit 0
