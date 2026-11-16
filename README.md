# gh-tasks

Personal task board on GitHub, driven from Claude Code. Ships as the Claude Code plugin `ghtasks`.

- Issues live in a private repo named `tasks` on your account.
- The board is a GitHub Project named `tasks` with the columns Todo, In Progress, Blocked, Review and Done. Review is for finished work waiting on someone else (PR review, QA, feedback). To change the columns, edit `STATUS_SPEC` in `bin/gh-tasks` and run `bin/gh-tasks setup`; existing tasks keep their status.
- Each task has a `project:<name>` label. The name comes from the git repo you're working in.
- Running context per project lives in `projects/<name>/CONTEXT.md` inside the `tasks` repo.

## Install

```bash
claude plugin marketplace add GiovaneSuss/gh-tasks
claude plugin install ghtasks@ghtasks
```

Or inside Claude Code: `/plugin marketplace add GiovaneSuss/gh-tasks`, then `/plugin install ghtasks@ghtasks`.

On first use the CLI creates the `tasks` repo and board on the active `gh` account and saves `~/.config/gh-tasks/config.json`.

Requirements: `gh` logged in with the `project` scope (`gh auth refresh -s project`) and `jq`.

## Sharing with other accounts

The board owner can give any GitHub account write access to the repo and the board:

```bash
bin/gh-tasks share OTHER_LOGIN
```

If that account is also logged in to `gh` on the same machine, the invite is accepted automatically. Each account needs the `project` scope once (`gh auth switch -u OTHER_LOGIN && gh auth refresh -s project`). The CLI then works with whichever account is active, as long as it has write access.

On a machine where only the other account is logged in, point setup at the owner's board:

```bash
bin/gh-tasks setup --owner OWNER_LOGIN
```

## Update

Every commit pushed to `main` is a new version. To pull it:

```bash
claude plugin marketplace update ghtasks && claude plugin update ghtasks@ghtasks
```

Or turn on auto-update once: `/plugin` → Marketplaces → ghtasks → Enable auto-update.

## Skills

| Slash command | What it does |
|---|---|
| `/ghtasks:create-task <what>` | Creates an issue in Todo, tagged with the current project |
| `/ghtasks:tasks-open [here\|updated\|name]` | Opens the board in the browser |
| `/ghtasks:tasks ...` | Lists, moves, comments and keeps the project context |
| `/ghtasks:tasks-sync [project...]` | For scheduled briefs: flags tasks that have news |

`create-task`, `tasks-open` and `tasks-sync` are user-only (`disable-model-invocation`), so they cost no context until you call them.

## Updates from scheduled briefs

A morning brief in each Claude environment (one with Qdrant tools, one with RapidCanvas, and so on) can run `/ghtasks:tasks-sync`, optionally limited to that environment's projects (`/ghtasks:tasks-sync qdrant-testing other-project`). For each open task it looks for news in the tools it has, starting from the task's `## Links` section. When it finds something, it comments what changed and adds the `updated` label. The task stays in its column; a column change is only suggested in the comment.

- See what changed: `/ghtasks:tasks-open updated`, or ask "what changed?".
- Clear it: "I saw #7" (`gh-tasks seen 7`, or `seen -a` for all). Moving a task clears it too.

## Layout

```
.claude-plugin/plugin.json        plugin manifest
.claude-plugin/marketplace.json   this repo is its own marketplace
bin/gh-tasks                      the CLI the skills run
skills/<name>/SKILL.md            one folder per skill
```

To add a skill, create `skills/<name>/SKILL.md` and push.

## CLI

The skills only run `bin/gh-tasks`, never raw `gh`. `bin/gh-tasks help` lists every command.

## Developing

Load the plugin from your checkout for one session, without installing:

```bash
claude --plugin-dir .
```

Check the manifests with `claude plugin validate .`.
