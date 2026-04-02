#!/usr/bin/env bash
set -euo pipefail

if command -v awb >/dev/null 2>&1; then
  printf 'awb\n'
  exit 0
fi

if command -v opencli >/dev/null 2>&1; then
  printf 'opencli awb\n'
  exit 0
fi

printf 'No AWB CLI found. Install `@lingjingai/awb-cli` or the opencli plugin.\n' >&2
exit 1
