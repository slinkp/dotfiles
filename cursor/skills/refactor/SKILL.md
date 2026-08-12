---
name: refactor
description: >-
  Minimal behavior-preserving refactor or simplification. Use when the user
  asks to refactor, simplify, clean up, or restructure code without changing
  behavior. Run tests before and after; no behavior change.
---

# Refactor

- Refactors reorganize only. Do not change behavior at the same time.
- Minimal change first: remove or inline before adding abstractions. Prefer deleting code over adding it.
- Goal is less code, not more: drop unnecessary abstractions, wrappers, and redundant operations.
- Prefer direct delegation over extra layers or preprocessing. If a method can do the whole job, call it.
- Moved code must have zero functional or stylistic changes. Preserve structure, style, and comments verbatim unless a change is strictly required to support the move.
- Unless explicitly told otherwise, take the smallest possible step toward the goal. Working code after every step.
- Run all tests before and after. Tests must not change except for required signatures, call arguments, conventions, or return types.

## Direct delegation

```javascript
// Bad: wrapping layers
function processData(data) {
  const wrapper = new DataWrapper(data);
  const processor = new DataProcessor();
  return processor.process(wrapper.prepare());
}

// Good
function processData(data) {
  return dataProcessor.process(data);
}
```

```javascript
// Bad: preprocessing that the callee already handles
function validateAndTransform(input) {
  const validated = this.validate(input);
  const preprocessed = this.preprocess(validated);
  return this.transform(preprocessed);
}

// Good
function validateAndTransform(input) {
  return this.transform(input);
}
```
