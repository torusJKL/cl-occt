## ADDED Requirements

### Requirement: Export DAG models to STEP with metadata
User SHALL be able to export all registered DAG models to a STEP file with metadata (name, color) using XDE-based export. The system SHALL collect all models from the registry, create an XDE document, assign each model's shape with its metadata, and write the document.

#### Scenario: Export models with colors
- **WHEN** `(defmodel box-a (:w) (:name "Box A") (:color (:generic 1 0 0)) (make-box (param :w) 20 30))` and `(defmodel box-b (:w) (:name "Box B") (:color (:generic 0 1 0)) (make-box (param :w) 20 30))` are defined, then `(write-step-assembly "models.step")` is called
- **THEN** file "models.step" is created containing both shapes with their names and colors preserved

#### Scenario: Export when no models registered
- **WHEN** no models are registered and `(write-step-assembly "empty.step")` is called
- **THEN** system returns nil or signals an error

### Requirement: Import STEP assembly into DAG model registry
User SHALL be able to read a STEP assembly file and populate the DAG model registry with models carrying the imported metadata.

#### Scenario: Import assembly populates registry
- **WHEN** `(read-step-assembly "models.step")` is called on a file previously written with `write-step-assembly`
- **THEN** the DAG model registry SHALL contain entries matching each part in the file, with name and color restored

#### Scenario: Imported models are findable
- **WHEN** a STEP file with a part named "Box A" is imported via `read-step-assembly`
- **THEN** `(model-ref 'box-a)` SHALL return the shape, and `(model-name 'box-a)` SHALL return "Box A"

### Requirement: Simple write-step unchanged
The existing `write-step` function SHALL continue to produce a bare STEP file without metadata. Users who want metadata SHALL use `write-step-assembly`.

#### Scenario: write-step still works without metadata
- **WHEN** user calls `(write-step (make-box 10 20 30) "bare.step")`
- **THEN** file "bare.step" is created and contains a valid STEP representation (no assembly structure)

### Requirement: Simple read-step unchanged
The existing `read-step` function SHALL continue to return a bare shape without populating the DAG registry.

#### Scenario: read-step returns bare shape
- **WHEN** user calls `(read-step "bare.step")`
- **THEN** the result is a `shape` object (not registered in the DAG)
