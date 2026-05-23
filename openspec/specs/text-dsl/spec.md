## ADDED Requirements

### Requirement: Text in defmodel
User SHALL be able to define text shapes declaratively within a `defmodel` form, with automatic dependency tracking of font and parameter changes.

#### Scenario: Basic text model
- **WHEN** user defines `(defmodel my-text (text "Hello" :font my-font :size 10))`
- **THEN** system creates a model that returns a shape when evaluated

#### Scenario: Text model with bound parameters
- **WHEN** user writes:
  ```lisp
  (defmodel greeting-text
    (text (model-ref 'greeting) :font (model-ref 'label-font) :size 12))
  ```
- **THEN** system tracks dependencies on `greeting` and `label-font` parameters

#### Scenario: Text model with position
- **WHEN** user writes `(defmodel positioned-text (text "Hi" :font f :position '(0 10 0) :normal '(0 0 1)))`
- **THEN** system creates a model with positioned text

### Requirement: make-text-shape works in DSL without defmodel
The `text` macro helper SHALL work both inside and outside `defmodel` forms.

#### Scenario: text outside defmodel
- **WHEN** user calls `(text "Hello" :font my-font)`
- **THEN** system returns a shape directly (same as `make-text-shape`)

## REMOVED Requirements

### Requirement: Text in defmodel
**Reason**: `text` convenience macro inside `defmodel` removed. No OCCT counterpart.
**Migration**: Use `make-text-shape` directly.

### Requirement: make-text-shape works in DSL without defmodel
**Reason**: `text` convenience macro removed.
**Migration**: Use `make-text-shape` directly with the same arguments.
