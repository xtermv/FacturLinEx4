#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")"
lazbuild -B FLXCore/FLXCore.lpk
echo "FLXCore compilado correctamente."
