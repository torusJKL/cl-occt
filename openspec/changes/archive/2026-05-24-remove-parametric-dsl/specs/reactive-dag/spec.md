## REMOVED Requirements

### Requirement: Define a parametric model
**Reason**: The entire reactive DAG system is removed. No OCCT counterpart.
**Migration**: Use core constructors directly, e.g. replace `(defmodel my-box (:w :d :h) (make-box (param :w) (param :d) (param :h)))` with `(make-box w d h)`.

### Requirement: Access parameters inside a model body
**Reason**: The `param` function and `*params*` store have no OCCT counterpart.
**Migration**: Pass values as function arguments directly.

### Requirement: Reference another model
**Reason**: The `model-ref` function and DAG dependency tracking have no OCCT counterpart.
**Migration**: Compose shapes using Lisp variables and function composition directly.

### Requirement: Set a parameter and propagate
**Reason**: The `set-param!` function and dirty propagation have no OCCT counterpart.
**Migration**: Rebuild shapes with new parameter values explicitly.

### Requirement: Batch set multiple parameters
**Reason**: The `set-params!` function has no OCCT counterpart.
**Migration**: Set values directly and call constructors again.

### Requirement: Topological evaluation order
**Reason**: DAG dependency evaluation has no OCCT counterpart.

### Requirement: Dual-mode parameter resolution
**Reason**: The `defmodel` macro and its local/global parameter modes have no OCCT counterpart.

### Requirement: Model redefinition
**Reason**: The `defmodel` macro and model registry have no OCCT counterpart.

### Requirement: Nil propagation
**Reason**: DAG nil propagation has no OCCT counterpart.

### Requirement: Model struct carries metadata slots
**Reason**: The `model` struct and metadata system have no OCCT counterpart.
**Migration**: Use `make-part`, `write-step-assembly` with names/colors.

### Requirement: Metadata is preserved through re-evaluation
**Reason**: DAG re-evaluation has no OCCT counterpart.

### Requirement: Metadata hash included in dirty-check
**Reason**: DAG dirty-checking has no OCCT counterpart.

### Requirement: Metadata accessor functions
**Reason**: `model-color`, `model-display-name`, `model-layer` have no OCCT counterpart.
**Migration**: Use `make-part` with `:name` and `:color` keywords, then `part-name`/`part-color` accessors.
