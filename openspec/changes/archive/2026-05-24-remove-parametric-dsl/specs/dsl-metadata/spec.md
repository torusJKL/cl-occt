## REMOVED Requirements

### Requirement: Specify color on a model
**Reason**: Metadata clauses on `defmodel` are removed. No OCCT counterpart.
**Migration**: Use `make-part` with `:color` keyword and `part-color` accessor, or use AIS display attributes directly.

### Requirement: Specify name on a model
**Reason**: Metadata clauses on `defmodel` are removed.
**Migration**: Use `make-part` with `:name` keyword.

### Requirement: Specify layer on a model
**Reason**: Metadata clauses on `defmodel` are removed.
**Migration**: Use AIS display layer functionality directly.

### Requirement: No metadata by default
**Reason**: Metadata on `defmodel` is removed.

### Requirement: Metadata accessible via model accessors
**Reason**: `model-color`, `model-name`, `model-layer` accessors are removed.
**Migration**: Use `part-color`, `part-name` from the assembly module.
