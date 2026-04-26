#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$SKILL_DIR/../.." && pwd)"
LOCAL_VERSION="$(cat "$SKILL_DIR/VERSION")"

if ! command -v git >/dev/null 2>&1; then
  echo "git is required" >&2
  exit 1
fi

if ! git -C "$REPO_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "local skill version:  $LOCAL_VERSION"
  echo "repo check skipped: $REPO_ROOT is not a git repo"
  echo "If this skill was installed from npm/postinstall, update the AWB CLI package and rerun install."
  exit 0
fi

git -C "$REPO_ROOT" fetch --quiet origin main || {
  echo "failed to fetch origin/main" >&2
  exit 2
}

REMOTE_VERSION="$(git -C "$REPO_ROOT" show origin/main:skills/awb/VERSION 2>/dev/null || true)"

if [[ -z "$REMOTE_VERSION" ]]; then
  echo "unable to read remote skill version" >&2
  exit 3
fi

echo "local skill version:  $LOCAL_VERSION"
echo "remote skill version: $REMOTE_VERSION"

if [[ "$LOCAL_VERSION" == "$REMOTE_VERSION" ]]; then
  echo "skill is up to date"
  exit 0
fi

echo "skill update available"
exit 10
