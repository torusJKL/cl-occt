## ADDED Requirements

### Requirement: Define a parametric model
User SHALL be able to define a parametric model using the `defmodel` macro. The macro SHALL accept a name, a parameter list, and a body that produces a shape. The macro SHALL register the model in the global registry.

#### Scenario: Define a box model
- **WHEN** user evaluates `(defmodel my-box (:w :d :h) (make-box (param :w) (param :d) (param :h)))`
- **THEN** a model named `my-box` is registered and immediately evaluated with current global parameter values

### Requirement: Access parameters inside a model body
The `param` function SHALL return the value of a parameter key. Inside a DAG evaluation, it SHALL return values from the parameter snapshot. Called standalone, it SHALL read from the global `*params*`.

#### Scenario: Param in model body
- **WHEN** user defines a model using `(param :w)` and `*params*` contains `:w → 30`
- **THEN** evaluating the model SHALL use the value 30 for width

### Requirement: Reference another model
The `model-ref` function SHALL return the cached result of another registered model. It SHALL create a dependency edge in the DAG.

#### Scenario: Compose two models
- **WHEN** user defines `(defmodel bracket (:r :w :d :h) (let ((box (model-ref 'my-box)) (cyl (make-cylinder (param :r) 100))) (cut box cyl)))`
- **THEN** `bracket` depends on `my-box` in the DAG

### Requirement: Set a parameter and propagate
`set-param!` SHALL update the global parameter store and trigger reactive recomputation of all affected models.

#### Scenario: Change param triggers recomputation
- **WHEN** user calls `(set-param! :w 50)` after defining a model that uses `:w`
- **THEN** the model is marked dirty, re-evaluated, and its cached shape is updated

#### Scenario: No change when param unchanged
- **WHEN** user calls `(set-param! :w 50)` and `:w` is already 50
- **THEN** the model is NOT re-evaluated (hash comparison skips identical params)

### Requirement: Batch set multiple parameters
`set-params!` SHALL update multiple parameters atomically before triggering a single propagation pass. All models SHALL see a consistent snapshot of the parameter state.

#### Scenario: Batch update
- **WHEN** user calls `(set-params! :w 30 :d 20 :h 10)`
- **THEN** all parameters are set before any model is re-evaluated

### Requirement: Topological evaluation order
When a model changes, all models that depend on it (directly or transitively) SHALL be re-evaluated. Evaluation SHALL happen in dependency order: deps before dependents.

#### Scenario: Chain of dependencies
- **WHEN** model A depends on param `:x`, model B depends on A, model C depends on B
- **THEN** changing `:x` SHALL re-evaluate A, then B, then C in order

### Requirement: Dual-mode parameter resolution
A model defined with `defmodel` SHALL support two modes:
1. Global mode: parameters read from the global `*params*` store
2. Local mode: when called as `(my-box :w 10 :d 20 :h 30)` with keyword arguments, it SHALL use those values as local params, unaffected by `set-param!`

#### Scenario: Local override
- **WHEN** user calls `(my-box :w 100 :d 200 :h 300)` while global `:w` is 50
- **THEN** the result SHALL be a 100×200×300 box, not affected by the global :w

#### Scenario: Local call does not affect global state
- **WHEN** user calls `(my-box :w 100 :d 200 :h 300)` then calls `(param :w)`
- **THEN** `(param :w)` SHALL return the global value, not 100

### Requirement: Model redefinition
Redefining a model with `defmodel` SHALL unregister the old model, register the new one, mark dependents dirty, and trigger re-evaluation.

#### Scenario: Redefine model body
- **WHEN** user evaluates a new `defmodel my-box ...` with a changed body
- **THEN** dependents of `my-box` are marked dirty and re-evaluated

### Requirement: Nil propagation
If a model evaluates to nil (e.g., invalid parameters), models that depend on it SHALL receive nil as the value of `model-ref`.

#### Scenario: Nil propagates
- **WHEN** model A evaluates to nil and model B references `(model-ref 'A)`
- **THEN** model B's body receives nil for A, and may also evaluate to nil
