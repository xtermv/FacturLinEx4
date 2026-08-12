#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")"
mkdir -p ../Bin
lazbuild -B FLXTools.lpi
echo "FLXTools generado en ../Bin/FLXTools"
