## Context

The codebase currently has two layers above the CFFI bindings:
1. **Core wrappers** (`src/core/`) — CLOS `shape`/`geom2d` objects, primitives, booleans, transforms, I/O — these wrap OCCT functions directly.
2. **Parametric DSL** (`src/dag/` + `src/dsl/` + `src/core/api.lisp`) — a reactive DAG with `defmodel`, parameter propagation, and metadata — no OCCT counterpart.

The goal is to strip layer 2 completely, leaving only layer 1.

## Goals / Non-Goals

**Goals:**
- Remove all code that has no corresponding OCCT function
- Clean up the system definition, package exports, tests, and docs
- Verify core tests still pass after removal

**Non-Goals:**
- No changes to core wrappers (`src/core/`) beyond removing DAG-specific I/O functions
- No changes to CFFI bindings (`src/ffi/`)
- No changes to C wrapper (`wrap/`)

## Decisions

1. **Delete vs. comment out** — Delete entirely. Files are under version control; git preserves history.
2. **`write-step` already exists** — `src/core/io.lisp` has a `write-step` function that works on individual shapes. DAG-specific `write-dag-models-to-step` and `read-step-into-dag` are removed; callers use `write-step`/`read-step` directly.
3. **Helper functions used by DSL only** — `%parse-color`, `parse-color` etc. are in `src/core/color.lisp` and are used by core wrappers too, so they stay.
4. **`help` function** — defined in `src/dsl/api.lisp`, documents entire API. After removal, there's no `help`. Remove it entirely; the user can read source docs.

## Risks / Trade-offs

- **[Breaking change]** All existing parametric DSL code will stop working. Migration: use `make-box`, `make-cylinder`, etc. directly.
- **[Test coverage]** Core tests will still run (~200 tests). Viewer tests unaffected.
