# clocct — Common Lisp + OCCT Parametric CAD

## Project state

**No source code committed yet.** The project is in spec-driven planning/execution phase. The sole active change is `v1-core` (44 tasks, 0 done). All work must follow the OpenSpec workflow.

## Workflow

- **Propose a change**: `/opsx-propose <name>` — creates proposal, design, tasks, specs
- **Implement**: `/opsx-apply <name>` — reads task list, implements iteratively, marks `[x]`
- **Archive**: `/opsx-archive <name>` — moves to `openspec/changes/archive/`
- **Explore**: `/opsx-explore` — thinking partner mode, no implementation

The `openspec` CLI is the source of truth. Run `openspec list --json` to see active changes and progress.

## Architecture (three-layer stack)

```
SBCL + CFFI  →  libocctwrap.so  →  OCCT shared libs
```

- **`wrap/occt_wrap.cpp`** — thin C bridge: 14 `extern "C"` functions wrapping OCCT C++ APIs. No business logic.
- **`src/ffi/`** — CFFI `defcfun` bindings to libocctwrap.so
- **`src/core/`** — CLOS wrapper (`shape` class with `tg:finalize` GC), primitives, booleans, transforms, STEP I/O
- **`src/dag/`** — reactive DAG: parameter store, model registry, topological evaluation
- **`src/dsl/`** — `defmodel`, `param`, `model-ref`, `set-param!` macros
- **`src/package.lisp`** — `cl-occt` and `cl-occt.impl` packages

## Build

- `just setup` — downloads OCCT 8.0 tarball, CMake build (no Vis, no AppFramework), installs to `.local/`
- `just wrap` — compiles `wrap/occt_wrap.cpp` → `lib/libocctwrap.so`
- `just repl` — launches SBCL with `cl-occt` system loaded
- `just clean` — removes build artifacts

`just setup` is a one-time ~15 min build. `.local/` and `lib/` are gitignored.

## Testing

- `(asdf:test-system :cl-occt)` runs all tests
- Tests live in `t/smoke-tests.lisp` (primitives, booleans, transforms, IO, DAG, DSL)
- Smoke test for the geometry pipeline: `(write-step (cut (make-box 30 20 10) (translate (make-cylinder 5 30) 15 10 0)) "test.step")`

## Environment

- **Common Lisp**: SBCL (SLIME/SWANK is the REPL — no in-app REPL, no GUI)
- **OCCT**: 8.0, shared libs only (10 minimum: TKernel, TKMath, TKG2d, TKG3d, TKBRep, TKPrim, TKBool, TKSTEP, TKSTEPBase, TKXSBase)
- **Build**: CMake for OCCT, `just` for project-level commands
- **C wrapper error handling**: returns `nullptr` on failure, thread-local error string via `get_error_code`/`get_error_message`
- **DAG nil propagation**: a model evaluating to nil passes nil to dependents

## Conventions

- C FFI functions use `%` prefix in CL (`%make-box`, `%boolean-cut`)
- OCCT shapes wrapped via `make-shape` helper (nullptr → nil, otherwise CLOS instance + `tg:finalize`)
- `defmodel` scans body statically for `(model-ref 'name)` to build dependency graph
