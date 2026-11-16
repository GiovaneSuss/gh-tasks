---
name: tasks-open
description: Open the user's personal "tasks" board in the browser.
disable-model-invocation: true
argument-hint: "[here | project-name]"
---

Run exactly one command and reply only with the URL it prints:

- no arguments: `gh-tasks open`
- `here`: `gh-tasks open --here`
- anything else: `gh-tasks open -p "$ARGUMENTS"`
