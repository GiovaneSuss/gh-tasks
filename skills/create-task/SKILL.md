---
name: create-task
description: Create a task (GitHub issue) on the user's personal "tasks" board, in Todo, tagged with the current project.
disable-model-invocation: true
argument-hint: "[what needs to be done]"
---

Create one task from `$ARGUMENTS` (plus the current conversation if it adds needed detail).

1. Write a short imperative title (max ~70 chars) and a brief body: what and why, plus a checklist if there are clear steps. Keep the user's language. Don't invent scope.
2. Run exactly this, filling in TITLE and BODY. Do not run any other gh command and do not debug: if it fails, show the error line to the user and stop.

```bash
gh-tasks create -t "TITLE" -b - <<'EOF'
BODY
EOF
```

The project is detected from the current directory. Add `-p NAME` only if the user named a different project.

3. Reply with the single line plus URL that the command printed. Nothing else.
