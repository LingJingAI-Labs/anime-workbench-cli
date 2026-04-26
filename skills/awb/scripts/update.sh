#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$SKILL_DIR/../.." && pwd)"
DEFAULT_INSTALL_DIR="${HOME}/.cc-switch/skills/awb"
INSTALL_DIR="${AWB_SKILL_INSTALL_DIR:-$DEFAULT_INSTALL_DIR}"

if ! command -v git >/dev/null 2>&1; then
  echo "git is required" >&2
  exit 1
fi

if [[ "${AWB_SKIP_REPO_PULL:-0}" == "1" ]]; then
  echo "skip repo pull: AWB_SKIP_REPO_PULL=1"
elif git -C "$REPO_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git -C "$REPO_ROOT" pull --rebase --autostash origin main
  echo "repo updated"
else
  echo "skip repo pull: $REPO_ROOT is not a git repo" >&2
fi

if [[ "${AWB_SKILL_SYNC_INSTALL:-1}" != "0" && -d "$(dirname "$INSTALL_DIR")" ]]; then
  INSTALL_DIR_REAL="$(mkdir -p "$INSTALL_DIR" && cd "$INSTALL_DIR" && pwd -P)"
  SKILL_DIR_REAL="$(cd "$SKILL_DIR" && pwd -P)"
  if [[ "$INSTALL_DIR_REAL" != "$SKILL_DIR_REAL" ]]; then
    rm -rf "$INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
    cp -R "$SKILL_DIR"/. "$INSTALL_DIR"/
    find "$INSTALL_DIR" -name '.DS_Store' -delete
    echo "skill synced: $INSTALL_DIR"
  fi
fi
