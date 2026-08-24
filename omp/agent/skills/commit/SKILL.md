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
7. Identify the coding agent currently making the change. This is the host
   program running the agent, not the repository owner, Git author, user, or
   model name. For an OpenCode session, the agent name is `OpenCode <noreply@opencode.ai>`.
   Never derive the agent identity from `git config`,
   commit history, repository ownership, or the user's identity - it is a
   property of the currently running agent program only.
8. Add a co-author trailer for that coding agent. This is an attribution marker for the user's benefit and does not need to
   map to a GitHub account. 
9. Commit; repeat for remaining changes.

## Commit message

Use HEREDOC:

```bash
git commit -m "$(cat <<'EOF'
Short summary of why.

Closes #N  # Include this line only when an issue number is known.

Co-authored-by: Agent Name <agent-email>
Model: Current AI model
EOF
)"
```

- Imperative mood: "add", "fix", "remove", not "added" or "fixes"
- Issue fixes: include `Closes #N` only when an issue number is known; omit the line otherwise.
- Co-authorship: Use the current host program's documented identity/email, not the repository user's identity or model name alone. For OpenCode, the documented default is `OpenCode <noreply@opencode.ai>`; GitHub account recognition is not required.
- `Model:` is optional metadata and is not a substitute for the co-author trailer.

## Do not commit

- Secrets (`.env`, credentials)
- Unrelated drive-by changes mixed into a focused commit
- Obviously-named scratch/temp files eg `requirements.txt.MAYBE`, `foo.py.OLD` etc unless explicitly requested

## After all commits

`git status` should be clean (except intentionally untracked files).
