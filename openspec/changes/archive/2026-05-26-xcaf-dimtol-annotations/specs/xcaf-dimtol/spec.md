## ADDED Requirements

### Requirement: Create linear dimension
The system SHALL create a linear (length) dimension on a shape using `XCAFDimTolObjects_DimensionObject`.

#### Scenario: Dimension between two points
- **WHEN** user calls `(xcaf-add-linear-dimension doc shape (list p1 p2) :value 50.0)`
- **THEN** returns t on success

### Requirement: Create angular dimension
The system SHALL create an angular dimension on a shape.

#### Scenario: Angle between two edges
- **WHEN** user calls `(xcaf-add-angular-dimension doc shape (list edge1 edge2) :value 45.0)`
- **THEN** returns t on success

### Requirement: Create diametric/radial dimension
The system SHALL create a diametric or radial dimension on a cylindrical face or circular edge.

#### Scenario: Diameter on cylinder face
- **WHEN** user calls `(xcaf-add-diameter-dimension doc shape cylinder-face :value 20.0)`
- **THEN** returns t on success

### Requirement: Create tolerance
The system SHALL create a tolerance object (e.g., flatness, parallelism, position) using `XCAFDimTolObjects_ToleranceObject`.

#### Scenario: Flatness tolerance
- **WHEN** user calls `(xcaf-add-tolerance doc shape :flatness :value 0.1)`
- **THEN** returns t on success

#### Scenario: Position tolerance with modifiers
- **WHEN** user calls `(xcaf-add-tolerance doc shape :position :value 0.5 :modifiers '(:mmc :rfs))`
- **THEN** returns t on success

### Requirement: Create datum
The system SHALL create a datum reference using `XCAFDimTolObjects_DatumObject`.

#### Scenario: Single datum
- **WHEN** user calls `(xcaf-add-datum doc shape :label "A")`
- **THEN** returns t on success

#### Scenario: Compound datum
- **WHEN** user calls `(xcaf-add-datum doc shape :label "A-B")`
- **THEN** returns t on success

### Requirement: Create geometric tolerance with datum references
The system SHALL create a geometric tolerance that references one or more datums using `XCAFDimTolObjects_GeomToleranceObject`.

#### Scenario: Position tolerance with datum A
- **WHEN** user calls `(xcaf-add-geometric-tolerance doc shape :position 0.5 :datums '("A"))`
- **THEN** returns t on success

### Requirement: Query all GD&T on a shape
The system SHALL list all GD&T annotations attached to a shape in the document.

#### Scenario: Get dimensions
- **WHEN** user calls `(xcaf-get-dimensions doc shape)`
- **THEN** returns a list of dimension plists with type, value, and related subshapes

#### Scenario: Get tolerances
- **WHEN** user calls `(xcaf-get-tolerances doc shape)`
- **THEN** returns a list of tolerance plists

#### Scenario: Get datums
- **WHEN** user calls `(xcaf-get-datums doc shape)`
- **THEN** returns a list of datum plists

### Requirement: Round-trip GD&T through STEP
The system SHALL persist GD&T annotations through STEP export and import.

#### Scenario: Export and import GD&T
- **WHEN** user writes a STEP file with GD&T then reads it back
- **THEN** the GD&T annotations are preserved
