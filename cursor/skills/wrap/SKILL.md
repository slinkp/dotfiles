---
name: wrap
description: >-
  End-of-session handoff: refresh docs/planning/AGENT_HANDOFF.md so a future
  agent can continue. Use when the user says wrap, wrap up, /wrap, or
  /wrap-up, or asks to leave notes for the next session.
---

# Wrap up (agent handoff)

## Hard rules

1. **Update** [`docs/planning/AGENT_HANDOFF.md`](../../docs/planning/AGENT_HANDOFF.md) so it is true *as of now*. That file is the handoff — not chat history.
2. **Do not invent milestones** or reverse locked decisions. If status is unclear, say so in the file.
3. Keep the handoff **short**. Session narrative belongs in a brief “Since last wrap” section, not a transcript.
4. **Do not** dump the full handoff into chat. Reply with: path updated, 1–3 line “where we left off,” uncommitted leftovers.
5. **Do not commit** unless the user asked to commit / wrap-and-commit. List dirty files instead.
6. Do **not** start new product work in the same turn.

## Procedure

1. Read current [`AGENT_HANDOFF.md`](../../docs/planning/AGENT_HANDOFF.md) and skim [`project_plan_baby_steps.md`](../../docs/planning/project_plan_baby_steps.md) locked decisions.
2. `git status -sb` and `git log --oneline -8` (and branch name).
3. Rewrite/update the handoff in place:
   - **Last updated** and **Since last wrap** headings: local **US/Eastern** time with **explicit zone abbreviation and UTC offset**. Do not use date-only. Prefer:

     `TZ=America/New_York date '+%Y-%m-%d %H:%M %Z (UTC%z)'`

     Example: `2026-08-11 00:18 EDT (UTC-0400)`. If that command is unavailable, convert from known now using America/New_York (EDT = UTC−4, EST = UTC−5). Never write a bare timezone-less clock.
   - **Current status** table: M0–M3 (and anything new) — done / in progress / next.
   - **What to do next** — one default for the *next* agent, and one for the *user* if they own data entry.
   - **Since last wrap** — bullets of what this session actually changed (skills, tests, pytest, etc.). Replace the previous session’s bullets; don’t append forever.
   - **In flight** — uncommitted paths, branch ahead of origin, review checklists still `[ ]`.
   - Skills / commands / locked decisions: keep in sync; don’t delete locked decisions unless the user reversed them this session.
4. If [`dev-environment.mdc`](../../.cursor/rules/dev-environment.mdc) still points at the handoff, leave it. If a new always-on pointer is needed, add it.
5. Chat: short wrap (below).

## Chat reply (required, short)

```text
Handoff updated: docs/planning/AGENT_HANDOFF.md
Left off: <one sentence>
Next: <user does X> / <agent does Y when asked>
Uncommitted: <none | list>
```
