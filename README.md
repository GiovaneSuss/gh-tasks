# gh-tasks

Personal task board on GitHub, driven from Claude Code.

- Issues live in a private repo named `tasks` on your account.
- The board is a GitHub Project named `tasks` with the statuses Todo, In Progress, Blocked and Done.
- Each task has a `project:<name>` label. The name comes from the git repo you're working in.
- Running context per project lives in `projects/<name>/CONTEXT.md` inside the `tasks` repo.

## Install

Copy the skills into your global skills folder:

```bash
mkdir -p ~/.claude/skills && curl -fsSL https://github.com/GiovaneSuss/gh-tasks/archive/refs/heads/main.tar.gz | tar -xz -C ~/.claude/skills --strip-components=2 gh-tasks-main/skills
```

That's it. On first use the CLI creates the `tasks` repo and board on the active `gh` account and saves `~/.config/gh-tasks/config.json`.

Requirements: `gh` logged in with the `project` scope (`gh auth refresh -s project`) and `jq`.

To update, run the same command again. To uninstall:

```bash
rm -rf ~/.claude/skills/create-task ~/.claude/skills/tasks-open ~/.claude/skills/tasks ~/.config/gh-tasks
```

Your repo and board on GitHub are never deleted.

## Skills

| Slash command | What it does |
|---|---|
| `/create-task <what>` | Creates an issue in Todo, tagged with the current project |
| `/tasks-open [here\|name]` | Opens the board in the browser |
| `/tasks ...` | Lists, moves, comments and keeps the project context |

`/create-task` and `/tasks-open` are user-only (`disable-model-invocation`), so they cost no context until you call them.

## CLI

The skills only run the bundled CLI at `~/.claude/skills/tasks/bin/gh-tasks`, never raw `gh`. To use it yourself:

```bash
bash ~/.claude/skills/tasks/bin/gh-tasks help
```

## Developing

Symlink the skill folders instead of copying, so edits apply immediately:

```bash
for d in skills/*/; do ln -sfn "$PWD/$d" ~/.claude/skills/"$(basename "$d")"; done
```
