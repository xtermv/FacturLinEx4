#!/usr/bin/env bash
set -Eeuo pipefail
APP_ID="facturlinex2"
PURGE=0
ASSUME_YES=0
while (($#)); do
  case "$1" in
    --purge) PURGE=1 ;;
    --yes) ASSUME_YES=1 ;;
    -h|--help)
      echo "Uso: $0 [--purge] [--yes]"
      echo "Sin --purge conserva /etc/facturlinex2 y datos del usuario."
      exit 0 ;;
    *) echo "Opción desconocida: $1" >&2; exit 2 ;;
  esac
  shift
done
((EUID == 0)) || { echo "Ejecutar con sudo." >&2; exit 1; }
if ((ASSUME_YES == 0)); then
  read -r -p "¿Desinstalar FacturLinEx? [s/N] " a
  [[ "$a" =~ ^[sS]$ ]] || exit 0
fi
rm -f /usr/bin/FacturLinEx
rm -f /usr/share/applications/${APP_ID}.desktop
rm -f /usr/share/icons/hicolor/256x256/apps/${APP_ID}.png
rm -rf /usr/share/${APP_ID}
if ((PURGE == 1)); then
  rm -rf /etc/${APP_ID} /var/log/${APP_ID}
fi
echo "FacturLinEx desinstalado. La base de datos y los datos del usuario no se han eliminado."
