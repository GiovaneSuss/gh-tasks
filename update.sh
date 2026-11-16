#!/usr/bin/env bash
# Update gh-tasks: pull the latest source (if it is a git checkout), then relink.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REMOTE_DIR="${GH_TASKS_HOME:-$HOME/.local/share/gh-tasks}"

# Prefer the remote-installed copy if this script was called from there or no checkout exists.
for dir in "$SRC" "$REMOTE_DIR"; do
  if [[ -d "$dir/.git" ]] && git -C "$dir" remote get-url origin >/dev/null 2>&1; then
    echo "pull  $dir"
    git -C "$dir" pull --ff-only --quiet
    exec "$dir/install.sh"
  fi
done

echo "no git remote to pull from; relinking local source"
exec "$SRC/install.sh"
