## ADDED Requirements

### Requirement: Model struct carries metadata slots
The `model` struct SHALL have `color`, `name`, and `layer` slots alongside the existing `cached-shape`.

#### Scenario: Metadata slots on model
- **WHEN** a model is registered with `:color (:generic 1 0 0)`, `:name "Part"`, and `:layer "mech"`
- **THEN** `(find-model 'my-model)` returns a struct with those values in its color, name, and layer slots

### Requirement: Metadata is preserved through re-evaluation
When a model is re-evaluated (e.g., due to parameter change), the metadata SHALL be recomputed from the model body and the new parameter values.

#### Scenario: Color param updates on re-evaluation
- **WHEN** `(defmodel col-box (:col) (:color (param :col)) (make-box 10 20 30))` is defined with `:col → (:generic 1 0 0)`, then `(set-param! :col (:generic 0 1 0))`
- **THEN** the model's color SHALL update to `(:generic 0 1 0)` after propagation

#### Scenario: Static metadata unchanged on re-evaluation
- **WHEN** `(defmodel static-col () (:color (:generic 1 0 0)) (make-box (param :w) 20 30))` is defined, then `(set-param! :w 50)`
- **THEN** the model's color SHALL remain `(:generic 1 0 0)` after propagation (static clause not affected by param change)

### Requirement: Metadata hash included in dirty-check
The `last-param-hash` comparison SHALL account for metadata parameters so that changing a metadata-only parameter triggers re-evaluation.

#### Scenario: Metadata param triggers re-evaluation
- **WHEN** `(defmodel col-box (:col) (:color (param :col)) (make-box 10 20 30))` is defined and evaluated, then `(set-param! :col (:generic 1 0 0))` is called with the same value
- **THEN** the model SHALL NOT be re-evaluated (hash comparison skips identical param states)

### Requirement: Metadata accessor functions
The system SHALL provide `model-color`, `model-name`, and `model-layer` functions that accept a model name symbol and return the corresponding metadata value, or nil if not set.

#### Scenario: Accessor for unset metadata
- **WHEN** `(defmodel plain () (make-box 10 20 30))` is defined and `(model-color 'plain)` is called
- **THEN** the result SHALL be nil

#### Scenario: Accessor for nonexistent model
- **WHEN** `(model-color 'nonexistent)` is called
- **THEN** the system SHALL signal an error (consistent with `find-model` behavior)
