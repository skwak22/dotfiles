---
name: staff-review
description: >-
  Apply a Staff Engineer rubric for pre-implementation architectural specs and
  post-implementation code reviews. Use when asked to review a branch, PR,
  worktree diff, or design, or before implementing a complex cross-cutting
  feature. Enforces a strict anti-noise ("no theater") policy focused on
  Architecture & Boundaries, Correctness & Edge Cases, Test Integrity, and Diff
  Hygiene.
---

# Staff Engineer Architecture & Code Review (`staff-review`)

Use this skill in two scenarios:
1. **Mode A — Upfront Architecture Spec (Pre-Implementation)**: Before writing
   code for a complex or cross-cutting task.
2. **Mode B — Code Review Gate (Post-Implementation)**: Auditing a branch,
   working tree diff, or worker worktree (`.worktrees/<name>`).

---

## Mode A: Upfront Architecture Spec

Before implementation begins on a non-trivial change:
1. Search and read the target modules and existing callers/callees.
2. Produce a concise **Architectural Brief** (`.wt-spec.md` or inline):
   - **Target Files & Boundaries**: Exact files/packages to modify or create,
     and module boundaries that must not be violated.
   - **Existing Primitives to Reuse**: Helpers, error types, config patterns, or
     utilities already in the repository so they are not reinvented.
   - **Invariants & Edge Cases**: Concurrency, state transitions, backwards
     compatibility, or failure modes that must be preserved.
   - **Verification Plan**: Exact test commands and behavioral cases required.

---

## Mode B: Post-Implementation Code Review Rubric

### Anti-Noise Rule ("Presumption Against Theater")
- **NEVER** block or request changes over subjective formatting, minor naming
  preferences, or stylistic opinions if the code matches the surrounding file.
- **NEVER** invent hypothetical out-of-scope requirements.
- Every blocking finding **must** cite an exact `file:line` and explain the
  concrete failure mode, architectural violation, or test gap.

### The 4 High-Leverage Review Dimensions

1. **Architecture & Boundaries**:
   - Does this logic belong in this module/layer?
   - Does it introduce circular dependencies, leaky abstractions, or duplicate
     utilities that already exist in the codebase?
2. **Correctness & Edge Cases**:
   - Are error paths, nil/empty inputs, boundary conditions, race conditions,
     and resource cleanups handled properly?
   - Did the change break existing callers or invariants?
3. **Test Integrity**:
   - Are the new behaviors and key failure modes genuinely tested?
   - Reject tautological or mock-theater tests (e.g., tests that only assert a
     mock returns what it was hardcoded to return).
   - Run the test suite to verify all tests pass.
4. **Diff & Working Tree Hygiene**:
   - Is `git status --porcelain` clean (or are all intended changes staged/committed)?
   - Are there leftover debug logs, dead commented-out code, or accidental edits
     to unrelated files?

### Structured Verdict Output

Conclude every review with one of three verdicts:
- **`VERDICT: APPROVED`**: Zero blocking defects across all 4 dimensions.
- **`VERDICT: CHANGES_REQUESTED`**: Numbered list of concrete `file:line`
  blocking defects that must be fixed.
- **`VERDICT: ESCALATED`**: Fundamental product/design tradeoff requiring human
  judgment, or repeated review rounds (>3) without convergence.
