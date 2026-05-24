## Context

The `cl-occt` package has 381 public API functions, none of which have docstrings with examples. This change targets 17 functions across 5 files that form the core geometric primitives, boolean operations, transforms, compounds, and shape predicate.

The user-provided `cut` example establishes the docstring convention:
- Description line explaining what the function does
- Parameter descriptions for complex functions
- `Example:` block with REPL-style usage
- `See also:` cross-references to related functions

## Goals / Non-Goals

**Goals:**
- Every public function in the target files gets a docstring
- Every non-trivial docstring includes a usage example
- Trivial predicates (`shape-p`) get a docstring description without example
- Cross-reference related functions via `See also:` where natural

**Non-Goals:**
- No functional or API changes
- No changes to internal (`%`-prefixed or `cl-occt.impl` package) functions
- No changes to test files
- No changes to existing specs

## Decisions

**Docstring format** — Loose template, not rigid:
  - Simple creators (`make-box`): description + brief example showing call with args
  - Boolean ops (`cut`/`fuse`/etc.): description + example showing `display` and `def` usage + `See also:`
  - Accessors (`compound-shape-p`): description + short example
  - Trivial predicates (`shape-p`): description only

**Example style** — REPL output is shown as comments. Examples should be self-contained where possible. For boolean ops, use `def` for intermediate shapes and `display` for result visualization (matching the user's `cut` example style).

**Cross-references** — `See also:` with backtick-quoted function names. For related groups (booleans, primitives), list sibling functions.

**No specs needed** — This is a documentation-only change. No requirement behavior changes.

## Risks / Trade-offs

- **Inconsistency risk** → Multiple files touched, but following the established `cut` example as a style guide minimizes drift
- **No automated validation** → Docstring correctness isn't testable. Manual review is the only check.
