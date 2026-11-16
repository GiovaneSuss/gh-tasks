---
name: tasks
description: Manage the user's personal GitHub task board (repo "tasks"). Use to list tasks, move a task between Todo / In Progress / Blocked / Review / Done, comment on a task, re-tag its project, see which tasks have news ("updated") and mark them seen, or read/update a project's running context. Triggers on "my tasks", "move #12 to done", "mark it blocked", "send it to review", "what changed", "I saw #7", "comment on the task", "project context".
argument-hint: "[list | move N status | comment N | context ...]"
---

All operations go through the bundled CLI. In every command below, `gh-tasks` means `bash "${CLAUDE_PLUGIN_ROOT}/bin/gh-tasks"` (always type the full form). Use only these commands, copied as written.
Never call `gh` directly and never debug the CLI: if a command fails, show its error line to the user and stop.
The CLI checks the gh account itself. P defaults to the project detected from the current directory.

| Goal | Command |
|---|---|
| List open tasks here | `gh-tasks list` |
| List everything | `gh-tasks list -a` |
| Filter by status | `gh-tasks list -s blocked` |
| Include done | `gh-tasks list --closed` |
| Read one task | `gh-tasks show N` |
| Move | `gh-tasks move N todo\|in-progress\|blocked\|review\|done` |
| Move + note why | `gh-tasks move N blocked -m "waiting on X"` |
| Send to review | `gh-tasks move N review -m "PR: <url>"` |
| Comment | `gh-tasks comment N -m "text"` |
| Tasks with news | `gh-tasks list -a --updated` |
| Mark as seen | `gh-tasks seen N [N...]` / all: `gh-tasks seen -a` |
| Change title/project | `gh-tasks edit N -t "new title"` / `gh-tasks edit N -p other-project` |
| Read project context | `gh-tasks context` |
| Append to context | `gh-tasks context-add <<'EOF'` … `EOF` |
| Rewrite context | `gh-tasks context-set <<'EOF'` … `EOF` |

For long text use stdin: `-m -` or `-b -` with a `<<'EOF'` heredoc.
`done` closes the issue; moving out of `done` reopens it.
Columns: Todo → In Progress → Review → Done, with Blocked for anything stuck. Use `review` when the work is finished but waits on someone else (PR review, QA, feedback); include the PR link or what is being reviewed in `-m`. Move to `done` only once the review passes.
Updates: scheduled briefs (`/ghtasks:tasks-sync`) add the `updated` label plus a comment with what changed; the task stays in its column. `*updated*` in `list` marks them. When the user asks what changed, run `gh-tasks list -a --updated`, then `gh-tasks show N` for each and summarize the latest brief comment. Mark seen only when the user says so; `move` clears the label automatically.

Context file (`projects/<P>/CONTEXT.md`): read it before planning work on a project. Append a short dated entry when a decision is made or a work session ends (what changed, what's next). Use `context-set` only when the user asks to rewrite or summarize it.

Keep replies short: echo the CLI output, don't restate it.
