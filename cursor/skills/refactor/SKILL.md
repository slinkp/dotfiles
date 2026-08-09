---
name: refactor
description: >-
  Minimal behavior-preserving refactor or simplification. Use when the user
  asks to refactor, simplify, clean up, or restructure code without changing
  behavior. Run tests before and after; no behavior change.
---

# Refactor

- Minimal change first: remove or inline before adding abstractions.
- No behavior change; preserve style, structure, and comments unless strictly required.
- Prefer direct delegation over extra layers.
- Split into small steps with working code at each step.
- Run all tests before and after; tests should not change except for required signatures/types.
