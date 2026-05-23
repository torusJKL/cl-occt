## REMOVED Requirements

### Requirement: Text in defmodel
**Reason**: The `text` convenience macro inside `defmodel` is removed. No OCCT counterpart.
**Migration**: Use `make-text-shape` directly.

### Requirement: make-text-shape works in DSL without defmodel
**Reason**: The `text` convenience macro is removed.
**Migration**: Use `make-text-shape` directly with the same arguments.
