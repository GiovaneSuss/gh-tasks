#!/usr/bin/env bash
# Install gh-tasks skills globally for Claude Code.
#   From a checkout:  ./install.sh
#   Remote (once published):
#     curl -fsSL https://raw.githubusercontent.com/<owner>/gh-tasks/main/install.sh | bash
# Skills are symlinked into ~/.claude/skills, the CLI into ~/.local/bin,
# so editing or pulling the source updates everything in place.
set -euo pipefail

REPO_URL="${GH_TASKS_REPO_URL:-https://github.com/GiovaneSuss/gh-tasks.git}"
REMOTE_DIR="${GH_TASKS_HOME:-$HOME/.local/share/gh-tasks}"
SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
BIN_DIR="${GH_TASKS_BIN_DIR:-$HOME/.local/bin}"

# Resolve the source: this checkout, or clone/pull when run via curl | bash.
SRC=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
if [[ -z "$SRC" || ! -d "$SRC/skills" ]]; then
  command -v git >/dev/null || { echo "error: git is required" >&2; exit 1; }
  if [[ -d "$REMOTE_DIR/.git" ]]; then
    git -C "$REMOTE_DIR" pull --ff-only --quiet
  else
    git clone --quiet "$REPO_URL" "$REMOTE_DIR"
  fi
  SRC="$REMOTE_DIR"
fi

for dep in gh jq; do
  command -v "$dep" >/dev/null || echo "warning: '$dep' not found; install it (brew install $dep)"
done

mkdir -p "$SKILLS_DIR" "$BIN_DIR"
chmod +x "$SRC/skills/tasks/bin/gh-tasks"

link() { # source, target
  if [[ -e "$2" && ! -L "$2" ]]; then
    echo "skip  $2 exists and is not a symlink (remove it to let gh-tasks manage it)"
    return
  fi
  ln -sfn "$1" "$2"
  echo "link  $2 -> $1"
}

for dir in "$SRC"/skills/*/; do
  name="$(basename "$dir")"
  link "${dir%/}" "$SKILLS_DIR/$name"
done
link "$SRC/skills/tasks/bin/gh-tasks" "$BIN_DIR/gh-tasks"

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo "warning: $BIN_DIR is not on PATH; add: export PATH=\"$BIN_DIR:\$PATH\"" ;;
esac

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/gh-tasks/config.json"
if [[ -f "$CONFIG" ]]; then
  echo "Installed. Config found at $CONFIG"
else
  echo "Installed. Next: run 'gh-tasks setup' once to create the repo, board and config."
fi
