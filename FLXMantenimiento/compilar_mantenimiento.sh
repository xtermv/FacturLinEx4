#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")"
mkdir -p ../Bin
lazbuild -B ../FLXRepair/FLXRepair.lpk
lazbuild -B FLXMantenimiento.lpi
echo
echo "FLXMantenimiento generado en ../Bin/FLXMantenimiento"
