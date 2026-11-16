---
name: tasks-open
description: Open the user's personal "tasks" board in the browser.
disable-model-invocation: true
argument-hint: "[here | project-name]"
---

Run exactly one command and reply only with the URL it prints:

- no arguments: `bash "${CLAUDE_PLUGIN_ROOT}/bin/gh-tasks" open`
- `here`: `bash "${CLAUDE_PLUGIN_ROOT}/bin/gh-tasks" open --here`
- anything else: `bash "${CLAUDE_PLUGIN_ROOT}/bin/gh-tasks" open -p "$ARGUMENTS"`
