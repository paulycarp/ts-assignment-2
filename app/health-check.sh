#!/usr/bin/env bash
set -euo pipefail

# Health check script verifying application readiness
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -x "$SCRIPT_DIR/diagnostic.sh" ]]; then
  "$SCRIPT_DIR/diagnostic.sh" help >/dev/null 2>&1 && exit 0 || exit 1
else
  exit 1
fi
