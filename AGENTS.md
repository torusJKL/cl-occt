# clocct — Common Lisp + OCCT Parametric CAD

## Project state

7 completed changes archived in `openspec/changes/archive/`. No active changes.

## Workflow (OpenCode slash commands)

- `/opsx-propose <name>` — create proposal + design + tasks + specs
- `/opsx-apply <name>` — implement tasks iteratively, marks `[x]`
- `/opsx-archive <name>` — move to `openspec/changes/archive/`
- `/opsx-explore` — thinking partner, no code generation

## Architecture

```
SBCL + CFFI → lib/libocctwrap.so → OCCT shared libs (.local/)
```

- `wrap/occt_wrap.[h|cpp]` — thin `extern "C"` bridge, no business logic
- `src/ffi/` — CFFI `defcfun` bindings (`%`-prefixed)
- `src/core/` — CLOS `shape` + `geom2d` with `tg:finalize` GC, primitives, booleans, transforms, faces, 2D curves, assembly tree, STEP/STL I/O
- `src/dag/` — reactive DAG: `*params*` store, `*model-registry*`, topological sort, dirty propagation
- `src/dsl/` — `defmodel`, `param`, `model-ref`, `set-param!`, `with-params` macros
- `src/package.lisp` — `cl-occt` (public API) and `cl-occt.impl` (internal)

## Build & test

| Command | What |
|---------|------|
| `just setup` | Download + CMake build OCCT 8.0 (~15 min, one-time) |
| `just wrap` | Compile `wrap/occt_wrap.cpp` → `lib/libocctwrap.so` |
| `just start` | SBCL + Quicklisp, loads system, lands in `CL-OCCT` |
| `just repl` | SBCL standalone (no Quicklisp) |
| `(asdf:test-system :cl-occt)` | 89 tests in `t/smoke-tests.lisp` |
| `(cl-occt::run-tests)` | Same |

Prerequisites: `sbcl curl build-essential cmake libc6`. Quicklisp required for `just start`.

## Conventions

- **Library, not app** — no GUI, no main entrypoint, use from REPL or scripts
- **`%` prefix** — CFFI functions (`%make-box`, `%boolean-cut`); use core wrappers instead
- **GC** — `make-shape` / `make-geom2d` wrap C pointer in CLOS + `tg:finalize`; return nil on null pointer
- **Error handling** — invalid/degenerate inputs return nil, C-level errors via `(get-error-message)` (defined in `src/core/errors.lisp`, inside `cl-occt` package)
- **DAG nil propagation** — model returning nil passes nil to all dependents
- **`defmodel`** — statically scans body for `(model-ref 'name)` to build dependency graph
- **Dependencies** — CFFI, trivial-garbage, alexandria (see `cl-occt.asd`)
