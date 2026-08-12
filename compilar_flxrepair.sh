#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")"
lazbuild -B FLXRepair/FLXRepair.lpk
echo "FLXRepair compilado correctamente."
