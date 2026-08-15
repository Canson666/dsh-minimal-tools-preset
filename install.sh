#!/usr/bin/env bash
# install.sh — install the minimal-tools agent preset for DeepSeek Harness
# Usage: bash install.sh        (from the repo root)
#        bash <(curl -sL https://raw.githubusercontent.com/<you>/<repo>/main/install.sh)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$REPO_ROOT/minimal-tools"

if [ ! -f "$SRC/agent.cordis.yml" ]; then
  echo "agent.cordis.yml not found at $SRC — run this script from the repo root." >&2
  exit 1
fi

DSH_HOME="${DSH_HOME:-$HOME/.dsh}"
PRESET_ROOT="$DSH_HOME/.agent-presets"
DST="$PRESET_ROOT/minimal-tools"

mkdir -p "$PRESET_ROOT"
if [ -e "$DST" ]; then
  echo "Updating existing preset at $DST"
  rm -rf "$DST"
fi
cp -r "$SRC" "$DST"

echo "Installed 'minimal-tools' preset -> $DST"
echo "Start a NEW session in the GUI and pick 极简+工具包."
