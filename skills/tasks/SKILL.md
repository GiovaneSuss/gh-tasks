---
name: tasks
description: Manage the user's personal GitHub task board (repo "tasks"). Use to list tasks, move a task between Todo / In Progress / Blocked / Done, comment on a task, re-tag its project, or read/update a project's running context. Triggers on "/tasks", "my tasks", "move #12 to done", "mark it blocked", "comment on the task", "project context".
argument-hint: "[list | move N status | comment N | context ...]"
---

All operations go through the bundled CLI. In every command below, `gh-tasks` means `bash ~/.claude/skills/tasks/bin/gh-tasks` (always type the full form). Use only these commands, copied as written.
Never call `gh` directly and never debug the CLI: if a command fails, show its error line to the user and stop.
The CLI checks the gh account itself. P defaults to the project detected from the current directory.

| Goal | Command |
|---|---|
| List open tasks here | `gh-tasks list` |
| List everything | `gh-tasks list -a` |
| Filter by status | `gh-tasks list -s blocked` |
| Include done | `gh-tasks list --closed` |
| Read one task | `gh-tasks show N` |
| Move | `gh-tasks move N todo\|in-progress\|blocked\|done` |
| Move + note why | `gh-tasks move N blocked -m "waiting on X"` |
| Comment | `gh-tasks comment N -m "text"` |
| Change title/project | `gh-tasks edit N -t "new title"` / `gh-tasks edit N -p other-project` |
| Read project context | `gh-tasks context` |
| Append to context | `gh-tasks context-add <<'EOF'` … `EOF` |
| Rewrite context | `gh-tasks context-set <<'EOF'` … `EOF` |

For long text use stdin: `-m -` or `-b -` with a `<<'EOF'` heredoc.
`done` closes the issue; moving out of `done` reopens it.

Context file (`projects/<P>/CONTEXT.md`): read it before planning work on a project. Append a short dated entry when a decision is made or a work session ends (what changed, what's next). Use `context-set` only when the user asks to rewrite or summarize it.

Keep replies short: echo the CLI output, don't restate it.
