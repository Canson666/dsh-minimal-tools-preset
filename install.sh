#!/usr/bin/env bash
# install.sh — install the minimal-tools agent preset for DeepSeek Harness
# Usage:
#   One-command (downloads from GitHub when not run from a checkout):
#     bash <(curl -sL https://raw.githubusercontent.com/Canson666/dsh-minimal-tools-preset/main/install.sh)
#   From a repo checkout:
#     bash install.sh

set -euo pipefail

REPO="Canson666/dsh-minimal-tools-preset"
REPO_NAME="${REPO##*/}"
BRANCH="main"
DST="${DSH_HOME:-$HOME/.dsh}/.agent-presets/minimal-tools"

install_from() {
  if [ ! -f "$1/agent.cordis.yml" ]; then
    echo "agent.cordis.yml not found at $1" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$DST")"
  if [ -e "$DST" ]; then
    echo "Updating existing preset at $DST"
    rm -rf "$DST"
  fi
  cp -r "$1" "$DST"
}

# Local checkout mode: the preset files sit next to this script.
SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"
fi
SRC=""
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/minimal-tools/agent.cordis.yml" ]; then
  SRC="$SCRIPT_DIR/minimal-tools"
fi

if [ -n "$SRC" ]; then
  install_from "$SRC"
else
  # Remote mode (e.g. `bash <(curl -sL ...)` outside a checkout): download from GitHub.
  echo "Local preset files not found — downloading from GitHub ($REPO@$BRANCH)..."
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/heads/$BRANCH" -o "$TMP/repo.tar.gz"
  tar -xzf "$TMP/repo.tar.gz" -C "$TMP"
  install_from "$TMP/$REPO_NAME-$BRANCH/minimal-tools"
fi

echo "Installed 'minimal-tools' preset -> $DST"
echo "Start a NEW session in the GUI and pick 极简+工具包."
