---
name: commit
description: >-
  Create logically separate, atomic git commits. Use when the user asks to
  commit, split changes into commits, or stage work. Smaller commits, one
  concern each; never commit with failing tests.
disable-model-invocation: true
---

# Commit

## Principles

- Logically separate commits; smaller is better.
- A commit must work atomically — **never commit with test failures**.
- A commit should not mix unrelated changes.
- Prefer `git add -p` to select related lines when staging (human or interactive sessions). When patching is unavailable, stage whole files that share one concern.

## Workflow

1. `git status` and `git diff` — understand what changed.
2. Group changes by logical concern (one feature, one refactor, docs-only, etc.).
3. Run `./test` — all tests must pass before any commit.
4. Stage only the files (or hunks) for **one** concern.
5. Write a concise commit message focused on **why** (1–2 sentences).
6. Commit; repeat for remaining changes.

## Commit message

Use HEREDOC:

```bash
git commit -m "$(cat <<'EOF'
Short summary of why.

Model: [Name of current model]
EOF
)"
```

- Imperative mood: "add", "fix", "remove", not "added" or "fixes"
- Issue fixes: include `closes #N` when applicable

## Do not commit

- Secrets (`.env`, credentials)
- Unrelated drive-by changes mixed into a focused commit
- `requirements.txt.MAYBE` or other scratch/temp files unless explicitly requested

## After all commits

`git status` should be clean (except intentionally untracked files).
