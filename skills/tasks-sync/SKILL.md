---
name: tasks-sync
description: Check the user's open tasks for news in Slack, GitHub, Jira and other connected tools, and flag the ones that changed. Meant for scheduled morning briefs.
disable-model-invocation: true
argument-hint: "[project ...]"
---

Find news for open tasks and flag them on the board. Never move tasks between columns.

`gh-tasks` below means `bash "${CLAUDE_PLUGIN_ROOT}/bin/gh-tasks"` (always type the full form). Never call `gh` for the board directly. If a gh-tasks command fails, report the error line and stop.

1. Load tasks. With arguments, once per project: `gh-tasks list -p PROJECT --json`. Without arguments: `gh-tasks list -a --json`.
   Each item has number, status, title, project, updated, url and body.
2. For each task, look for activity since the previous working day, using the tools this environment has (Slack, GitHub, Jira, email...). Start from the URLs and keys in the body's `## Links` section, then search by title keywords. Skip tasks whose project this environment has no tools for.
3. Only real news counts: a new comment, review, status change, reply or decision about that specific task. Skip bots, noise and anything older than the last working day. If unsure that an item is about the task, skip it.
4. For each task with news, run once:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/gh-tasks" flag N -m - <<'EOF'
🔔 Brief YYYY-MM-DD
- what changed (link)
- what changed (link)
Suggested: move to <column> because <reason>   (only if the news clearly calls for it)
EOF
```

   One bullet per item, with its link. Keep the user's language.
5. Finish with a short summary: which tasks were flagged and one line each. If nothing changed, say so in one line.
