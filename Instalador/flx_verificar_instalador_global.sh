#!/usr/bin/env bash
set -Eeuo pipefail

echo "============================================================"
echo " FacturLinEx 4.2.6 - Verificación global del instalador"
echo "============================================================"

errors=0
warnings=0

ok()   { echo "[ OK  ] $1"; }
warn() { echo "[AVISO] $1"; warnings=$((warnings+1)); }
fail() { echo "[ERROR] $1"; errors=$((errors+1)); }

[[ -x /usr/bin/FacturLinEx ]] && ok "Binario instalado" || fail "Falta /usr/bin/FacturLinEx"
[[ -d /usr/share/facturlinex2 ]] && ok "Directorio de recursos" || fail "Falta /usr/share/facturlinex2"
[[ -d /usr/share/facturlinex2/Report ]] && ok "Directorio de informes" || fail "Falta el directorio Report"
[[ -f /usr/share/applications/facturlinex2.desktop ]] && ok "Acceso de escritorio" || warn "No existe acceso de escritorio"
[[ -f /etc/facturlinex2/FacturConf.ini ]] && ok "Configuración global" || fail "Falta FacturConf.ini"

command -v openssl >/dev/null 2>&1 && ok "OpenSSL disponible" || fail "OpenSSL no localizado"
(command -v mariadb >/dev/null 2>&1 || command -v mysql >/dev/null 2>&1) \
  && ok "Cliente MariaDB/MySQL" || fail "Cliente MariaDB/MySQL no localizado"
command -v rsync >/dev/null 2>&1 && ok "rsync disponible" || fail "rsync no localizado"
(command -v xdg-open >/dev/null 2>&1 || command -v gio >/dev/null 2>&1) \
  && ok "Apertura de documentos disponible" || warn "No se localiza xdg-open ni gio"

echo
echo "Resumen:"
echo "  Errores: $errors"
echo "  Avisos : $warnings"

if [[ $errors -gt 0 ]]; then
  echo "Resultado: INSTALACIÓN INCOMPLETA"
  exit 1
elif [[ $warnings -gt 0 ]]; then
  echo "Resultado: INSTALACIÓN OPERATIVA CON AVISOS"
  exit 0
else
  echo "Resultado: INSTALACIÓN CORRECTA"
  exit 0
fi
