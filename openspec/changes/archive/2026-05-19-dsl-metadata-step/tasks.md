## 1. DAG — Extend model struct with metadata slots

- [x] 1.1 Add `color`, `name`, `layer` slots to `model` defstruct in `src/dag/model.lisp`
- [x] 1.2 Add struct accessor exports to `cl-occt.impl` package in `src/package.lisp` (`model-color`, `model-name`, `model-layer`)

## 2. DSL — Extend defmodel to accept metadata clauses

- [x] 2.1 Update `defmodel` macro in `src/dsl/defmodel.lisp` to parse optional `:color`, `:name`, `:layer` clauses from the body (before shape-producing forms)
- [x] 2.2 Update the model creation form in `defmodel` expansion to pass metadata values to `make-model`
- [x] 2.3 Update static analysis (`%model-keys-from-params` or new helper) to detect `param` calls within metadata clause forms so metadata params are auto-detected
- [x] 2.4 Update the generated `defun` in `defmodel` expansion to bind metadata from keyword args when calling with local params

## 3. DAG — Propagation with metadata

- [x] 3.1 Update `evaluate-model` in `src/dag/propagation.lisp` to recompute metadata (color/name/layer) alongside cached-shape when a model is evaluated
- [x] 3.2 Ensure metadata is nil by default when no metadata clause is used (backward compatibility)

## 4. Public metadata accessors

- [x] 4.1 Add `model-color`, `model-name`, `model-layer` public functions in `src/dag/` or `src/dsl/` that read metadata from a registered model by name
- [x] 4.2 Export new accessors from `:cl-occt` package in `src/package.lisp`

## 5. STEP export from DAG registry

- [x] 5.1 Add function (e.g., `write-dag-models-to-step`) that collects all registered DAG models, creates an XDE document, assigns each model's shape with its metadata, and writes the STEP file
- [x] 5.2 Reuse `%xde-add-part` and `parse-color` helpers from `src/core/io.lisp` or refactor them into callable utilities
- [x] 5.3 Export the new function from `:cl-occt` package

## 6. STEP import into DAG registry

- [x] 6.1 Add function (e.g., `read-step-into-dag`) that reads a STEP assembly file and registers each part as a DAG model with shape, name, and color populated
- [x] 6.2 Decide naming convention for imported models (derive from STEP part name vs. auto-generated symbols)

## 7. Package exports and help

- [x] 7.1 Export all new public symbols (`model-color`, `model-name`, `model-layer`, `write-dag-models-to-step`, etc.) from `:cl-occt` package
- [x] 7.2 Update `help` in `src/dsl/api.lisp` to document new metadata capabilities
- [x] 7.3 Run `(asdf:test-system :cl-occt)` to confirm existing tests still pass

## 8. Tests

- [x] 8.1 Test: defmodel with static color, name, layer metadata
- [x] 8.2 Test: defmodel with metadata from parameters
- [x] 8.3 Test: metadata accessors return correct values
- [x] 8.4 Test: metadata accessors return nil for models without metadata
- [x] 8.5 Test: metadata preserved through model re-evaluation
- [x] 8.6 Test: metadata-only param change does not trigger re-evaluation if value unchanged
- [x] 8.7 Test: STEP round-trip with metadata from DAG models
- [x] 8.8 Test: simple `write-step` / `read-step` unchanged (no metadata)
