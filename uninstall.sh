#!/usr/bin/env bash
# Remove gh-tasks symlinks. Keeps your GitHub repo/board untouched.
#   ./uninstall.sh          remove skills and CLI links
#   ./uninstall.sh --purge  also delete the local config (~/.config/gh-tasks)
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
BIN_DIR="${GH_TASKS_BIN_DIR:-$HOME/.local/bin}"

unlink_if_ours() {
  if [[ -L "$1" ]]; then rm "$1" && echo "rm    $1"; fi
}

for dir in "$SRC"/skills/*/; do
  unlink_if_ours "$SKILLS_DIR/$(basename "$dir")"
done
unlink_if_ours "$BIN_DIR/gh-tasks"

if [[ "${1:-}" == "--purge" ]]; then
  rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/gh-tasks" && echo "rm    config"
fi
echo "Uninstalled."
