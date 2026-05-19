## Why

The DSL (`defmodel`) can only produce bare geometric shapes — there is no way to attach metadata like color, name, or layer to a model. The underlying OCCT XDE layer and the STEP AP203/AP242 formats both support color, name, and other attributes, so the Lisp DSL and DAG should expose them. This enables parametric models with visual metadata that round-trips through STEP export/import.

## What Changes

- Add an optional `:metadata` (or `:color`, `:name`) clause to `defmodel` so users can specify metadata inline
- Extend the `model` struct to carry metadata alongside the cached shape
- Add a DAG-aware metadata resolution path so metadata can be parametric (e.g., color from a param)
- Extend `write-step-assembly` / `write-step` to produce XDE STEP files that include metadata from the DAG layer
- Extend `read-step-assembly` / `read-step` to populate metadata into the DAG model cache

## Capabilities

### New Capabilities
- `dsl-metadata`: DSL support for specifying shape metadata (color, name, layer) in `defmodel` definitions, with parametric resolution support

### Modified Capabilities
- `reactive-dag`: The `model` struct gains metadata slots; propagation preserves metadata through re-evaluation
- `step-io`: STEP export writes DAG model metadata as XDE attributes; STEP import populates DAG model metadata

## Impact

- `src/dag/model.lisp` — `model` struct gains `name`, `color`, `layer` slots
- `src/dag/propagation.lisp` — metadata preserved during evaluation
- `src/dsl/defmodel.lisp` — `defmodel` accepts metadata clauses (e.g., `:color (param :col)`)
- `src/core/io.lisp` — `write-step-assembly` reads metadata from DAG model structs; `read-step-assembly` writes metadata back
- `src/core/shape.lisp` — `shape` class unchanged; metadata lives in the model/DAG layer, not on the shape itself
- `t/smoke-tests.lisp` — new tests for metadata DSL, propagation, STEP round-trip with metadata
