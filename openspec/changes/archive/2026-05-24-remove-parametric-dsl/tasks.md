## 1. Remove DAG and DSL source directories

- [x] 1.1 Delete `src/dag/` directory (params.lisp, registry.lisp, model.lisp, propagation.lisp)
- [x] 1.2 Delete `src/dsl/` directory (param.lisp, defmodel.lisp, api.lisp)
- [x] 1.3 Delete `src/core/api.lisp` (set-param!, set-params!, %mark-models-dirty)

## 2. Clean up I/O layer

- [x] 2.1 Remove `write-dag-models-to-step`, `read-step-into-dag`, `*dag-import-counter*`, `%dag-import-name`, `%import-node-into-dag` from `src/core/io.lisp`

## 3. Update system definition

- [x] 3.1 Remove `:module "dag"` and `:module "dsl"` entries from `cl-occt.asd`
- [x] 3.2 Remove `(:file "api")` entry that points to `src/core/api.lisp` from `cl-occt.asd`

## 4. Clean up package exports

- [x] 4.1 Remove DAG/DSL related exports from `cl-occt.impl` in `src/package.lisp` (lines 384-404 — *params*, model struct + accessors, registry, propagation)
- [x] 4.2 Remove DAG/DSL related shadowing and exports from `cl-occt` in `src/package.lisp` (lines 408, 448-475 — defmodel, param, model-ref, set-param!, set-params!, with-params, *local-params*, *params*, *model-registry*, registry functions, model-color/model-display-name/model-layer shadows, write-dag-models-to-step, read-step-into-dag)

## 5. Update tests

- [x] 5.1 Remove DSL test functions from `t/smoke-tests.lisp` (lines 725-801 — dag-set-param through read-step-into-dag-valid)
- [x] 5.2 Remove DSL test references from `run-core-tests` in `t/smoke-tests.lisp` (lines 2899-2903)

## 6. Update documentation

- [x] 6.1 Update `README.md` — remove references to parametric DSL, DAG, `defmodel`, `param`, parameter system
- [x] 6.2 Update `AGENTS.md` — remove DSL/DAG related sections if present

## 7. Verify

- [x] 7.1 Run `just test-core` to confirm tests pass (requires `just setup` + `just wrap` first)
- [x] 7.2 Run `just test-all` for full test suite (requires `just setup` + `just wrap` first)
