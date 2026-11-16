# gh-tasks

Personal task board on GitHub, driven from Claude Code.

- Issues live in a private repo named `tasks` on your account.
- The board is a GitHub Project named `tasks` with the statuses Todo, In Progress, Blocked and Done.
- Each task has a `project:<name>` label. The name comes from the git repo you're working in.
- Running context per project lives in `projects/<name>/CONTEXT.md` inside the `tasks` repo.

## Install

```bash
./install.sh        # symlinks skills into ~/.claude/skills and the CLI into ~/.local/bin
gh-tasks setup      # once: creates the repo, board and statuses, writes ~/.config/gh-tasks/config.json
gh-tasks check      # verifies account, token scope and access
```

Requires `gh` (logged in, with the `project` scope: `gh auth refresh -s project`) and `jq`.

Maintenance is plain scripts, no Claude needed:

```bash
./update.sh            # git pull (if this is a clone) and relink
./uninstall.sh         # remove the links (add --purge to drop the config)
```

## Skills

| Slash command | What it does |
|---|---|
| `/create-task <what>` | Creates an issue in Todo, tagged with the current project |
| `/tasks-open [here\|name]` | Opens the board in the browser |
| `/tasks ...` | Lists, moves, comments and keeps the project context |

`/create-task` and `/tasks-open` are user-only (`disable-model-invocation`), so they cost no context until you call them.

## CLI

`gh-tasks help` prints every command. Claude only runs these fixed commands, never raw `gh`.

## Publishing later

The layout follows the common `skills/<name>/SKILL.md` convention. Once this is pushed to GitHub, set `REPO_URL` in `install.sh` and install with:

```bash
curl -fsSL https://raw.githubusercontent.com/<owner>/gh-tasks/main/install.sh | bash
```
