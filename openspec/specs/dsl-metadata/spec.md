## ADDED Requirements

### Requirement: Specify color on a model
User SHALL be able to specify a color on a `defmodel` definition using an optional `:color` clause. The color SHALL be a plist of the form `(:type r g b [a])` where type is `:generic`, `:surf`, or `:curv`, and r/g/b/a are float values in [0,1].

#### Scenario: Static color on a box
- **WHEN** user evaluates `(defmodel my-box (:w :d :h) (:color (:generic 1.0 0.0 0.0 1.0)) (make-box (param :w) (param :d) (param :h)))`
- **THEN** `my-box` is registered with color `(:generic 1.0 0.0 0.0 1.0)`

#### Scenario: Color from parameter
- **WHEN** user evaluates `(defmodel my-box (:w :d :h :col) (:color (param :col)) (make-box (param :w) (param :d) (param :h)))` and calls `(my-box :w 10 :d 20 :h 30 :col (:generic 0.5 0.5 0.5))`
- **THEN** the model SHALL have color `(:generic 0.5 0.5 0.5)`

#### Scenario: Color with alpha
- **WHEN** user specifies `:color (:generic 1.0 0.0 0.0 0.5)`
- **THEN** the alpha component SHALL be preserved as 0.5

#### Scenario: Default alpha
- **WHEN** user specifies `:color (:generic 1.0 0.0 0.0)` (no alpha)
- **THEN** the alpha SHALL default to 1.0

### Requirement: Specify name on a model
User SHALL be able to specify a name on a `defmodel` definition using an optional `:name` clause.

#### Scenario: Static name
- **WHEN** user evaluates `(defmodel my-box (:w :d :h) (:name "Red Box") (make-box (param :w) (param :d) (param :h)))`
- **THEN** `my-box` is registered with name `"Red Box"`

#### Scenario: Name from parameter
- **WHEN** user evaluates `(defmodel named-box (:n) (:name (param :n)) (make-box 10 20 30))` and calls `(named-box :n "My Part")`
- **THEN** the model SHALL have name `"My Part"`

### Requirement: Specify layer on a model
User SHALL be able to specify a layer name on a `defmodel` definition using an optional `:layer` clause.

#### Scenario: Static layer
- **WHEN** user evaluates `(defmodel my-box () (:layer "mechanical") (make-box 10 20 30))`
- **THEN** `my-box` is registered with layer `"mechanical"`

### Requirement: No metadata by default
If no `:color`, `:name`, or `:layer` clause is specified on `defmodel`, the model SHALL have no associated metadata (all slots nil).

#### Scenario: Default no metadata
- **WHEN** user evaluates `(defmodel plain-box () (make-box 10 20 30))`
- **THEN** `plain-box` SHALL have nil color, nil name, nil layer

### Requirement: Metadata accessible via model accessors
User SHALL be able to read metadata from a registered model using accessor functions.

#### Scenario: Read model color
- **WHEN** user evaluates `(defmodel col-box () (:color (:generic 0 1 0)) (make-box 10 20 30))` then calls `(model-color 'col-box)`
- **THEN** the result SHALL be `(:generic 0 1 0 1.0)`

#### Scenario: Read model name
- **WHEN** user evaluates `(defmodel named-box () (:name "Part A") (make-box 10 20 30))` then calls `(model-name 'named-box)`
- **THEN** the result SHALL be `"Part A"`

## REMOVED Requirements

### Requirement: Specify color on a model
**Reason**: Metadata clauses on `defmodel` removed. No OCCT counterpart.
**Migration**: Use `make-part` with `:color` keyword or AIS display attributes.

### Requirement: Specify name on a model
**Reason**: Metadata clauses on `defmodel` removed.
**Migration**: Use `make-part` with `:name` keyword.

### Requirement: Specify layer on a model
**Reason**: Metadata clauses on `defmodel` removed.
**Migration**: Use AIS display layer directly.

### Requirement: No metadata by default
**Reason**: Metadata on `defmodel` removed.

### Requirement: Metadata accessible via model accessors
**Reason**: `model-color`, `model-name`, `model-layer` removed.
**Migration**: Use `part-color`, `part-name` from assembly module.
