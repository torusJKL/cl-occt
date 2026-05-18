# clocct — Common Lisp + OCCT Parametric CAD

## Project state

The initial implementation (v1-core, 44/44 tasks) is committed at `cfe2a0a` and archived at `openspec/changes/archive/2026-05-18-v1-core/`. No active changes.

## Workflow

- **Propose**: `/opsx-propose <name>` — creates proposal, design, tasks, specs
- **Implement**: `/opsx-apply <name>` — iterates through tasks, marks `[x]`
- **Archive**: `/opsx-archive <name>` — moves to `openspec/changes/archive/`
- **Explore**: `/opsx-explore` — thinking partner, no implementation
- Run `openspec list --json` to see active changes

## Architecture

```
SBCL + CFFI → libocctwrap.so → OCCT shared libs
```

- `wrap/occt_wrap.cpp` — 14 `extern "C"` functions, no business logic
- `src/ffi/` — CFFI `defcfun` bindings (`%`-prefixed)
- `src/core/` — CLOS `shape` + `tg:finalize` GC, primitives, booleans, transforms, STEP I/O
- `src/dag/` — reactive DAG: parameter store, model registry, topological evaluation
- `src/dsl/` — `defmodel`, `param`, `model-ref`, `set-param!` macros
- `src/package.lisp` — `cl-occt` and `cl-occt.impl` packages

## Build

- `just setup` — one-time ~15 min: downloads OCCT 8.0, CMake build, installs to `.local/`
- `just wrap` — compiles `wrap/occt_wrap.cpp` → `lib/libocctwrap.so`
- `just start` — SBCL with Quicklisp, loads system, lands in `CL-OCCT`
- `just repl` — SBCL standalone (no Quicklisp), loads system, lands in `CL-OCCT`
- `just clean` — removes OCCT build artifacts
- `.local/` and `lib/` are gitignored

## Testing

- `(asdf:test-system :cl-occt)` or `(cl-occt::run-tests)` — 27 smoke tests
- Tests: `t/smoke-tests.lisp` (primitives, booleans, transforms, IO, DAG, DSL)

## Conventions

- Dependencies: CFFI, trivial-garbage, alexandria (see `cl-occt.asd`)
- C wrapper errors: returns `nullptr`, thread-local error string via `get_error_code`/`get_error_message`
- DAG nil propagation: model returning nil passes nil to dependents
- C FFI functions use `%` prefix (`%make-box`, `%boolean-cut`)
- `make-shape` wraps pointer in CLOS `shape` + `tg:finalize`; returns nil on null pointer
- `defmodel` statically scans body for `(model-ref 'name)` to build dependency graph
