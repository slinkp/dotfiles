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
3. Run the repo's test suite if any, respecting any local test-related skills - all tests must pass before any commit.
4. Stage only the files (or hunks) for **one** concern.
5. Write a concise commit message focused on **why** (1–2 sentences).
6. Add the issue-closing line only when an issue number is explicitly available from the task, branch, PR, or surrounding commit context; otherwise omit it.
7. Add this *exact* co-author trailer: `Co-authored-by: OMP <noreply@omp.sh>`
8. Commit; repeat for remaining changes.

## Commit message

Use HEREDOC:

```bash
git commit -m "$(cat <<'EOF'
Short summary of why.

Closes #N  # Include this line only when an issue number is known.

Co-authored-by: OMP <noreply@omp.sh>
Model: Current AI model
EOF
)"
```

- Imperative mood: "add", "fix", "remove", not "added" or "fixes"
- Issue fixes: include `Closes #N` only when an issue number is known; omit the line otherwise.
- `Model:` is optional metadata and is not a substitute for the co-author trailer.

## Do not commit

- Secrets (`.env`, credentials)
- Unrelated drive-by changes mixed into a focused commit
- Obviously-named scratch/temp files eg `requirements.txt.MAYBE`, `foo.py.OLD` etc unless explicitly requested

## After all commits

`git status` should be clean (except intentionally untracked files).
