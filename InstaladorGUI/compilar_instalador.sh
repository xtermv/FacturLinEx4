#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")"
mkdir -p ../Bin
lazbuild -B FLXInstaller.lpi
echo
echo "Instalador generado en:"
echo "$(cd ../Bin && pwd)/FLXInstaller"
