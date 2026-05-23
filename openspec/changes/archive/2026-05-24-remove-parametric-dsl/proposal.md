## Why

The library should be a clean, thin wrapper around OCCT — 1:1 Lisp bindings and wrappers for native OCCT C++ functions. The parametric DSL (`defmodel`, `param`, DAG propagation, etc.) adds ~260 lines of non-OCCT code, increasing maintenance burden and diverging from the project's core purpose.

This change removes all convenience functions and parametric DSL machinery, leaving only CL functions that have a corresponding OCCT function.

## What Changes

- **Remove entire `src/dag/` module** — `*params*`, `*model-registry*`, `model` struct, registry operations, dirty propagation, topological sort
- **Remove entire `src/dsl/` module** — `defmodel` macro, `param`, `with-params`, `model-ref`, `model-color`, `model-display-name`, `model-layer`, `text` macro, `help` function
- **Remove `src/core/api.lisp`** — `set-param!`, `set-params!`, `%mark-models-dirty`
- **Remove DAG-specific I/O** — `write-dag-models-to-step`, `read-step-into-dag`, `*dag-import-counter*`, `%dag-import-name`, `%import-node-into-dag`
- **Clean up `cl-occt.asd`** — remove `dag` and `dsl` module references, remove `core/api` file entry
- **Clean up `src/package.lisp`** — remove all DAG/DSL symbol exports from `cl-occt.impl` and `cl-occt`
- **Remove DAG/DSL tests** — all DSL-specific test functions and their references in `run-core-tests`
- **Update `README.md`** — remove references to parametric DSL, DAG, parameter system

## Capabilities

### New Capabilities
None — this is purely a removal change.

### Modified Capabilities

- `reactive-dag`: **REMOVED** — entire parametric DAG capability removed
- `dsl-metadata`: **REMOVED** — metadata clauses on `defmodel` removed
- `text-dsl`: **REMOVED** — text convenience DSL removed
- `step-io`: **MODIFIED** — remove `write-dag-models-to-step` and `read-step-into-dag`; `write-step` and `read-step` remain

## Impact

- **Removed**: ~260 lines across `src/dag/` and `src/dsl/`, plus `src/core/api.lisp` (31 lines)
- **Modified**: `cl-occt.asd`, `src/package.lisp`, `src/core/io.lisp`, `t/smoke-tests.lisp`, `README.md`, `AGENTS.md`
- **Dependencies**: No external dependency changes
- **Breaking**: All code using `defmodel`, `param`, `model-ref`, `set-param!`, `set-params!`, `with-params`, `text` will need migration
- **STEP format**: DAG-specific STEP export/import removed; use plain `write-step`/`read-step`
