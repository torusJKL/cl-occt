## ADDED Requirements

### Requirement: Boolean section (intersection curves)
User SHALL be able to compute the intersection curves/edges between two shapes. The system SHALL use OCCT `BRepAlgoAPI_Section`. If the shapes do not intersect or the operation fails, the system SHALL return nil.

#### Scenario: Section a box with a plane
- **WHEN** user calls `(section (make-box 10 10 10) make-plane ...)` (via a plane face)
- **THEN** system returns a shape containing the intersection edges

#### Scenario: Section two intersecting solids
- **WHEN** user calls `(section (make-box 10 10 10) (translate (make-box 10 10 10) 5 5 5))`
- **THEN** system returns a shape containing the intersection edges between the two boxes

#### Scenario: Section non-intersecting solids
- **WHEN** user calls `(section (make-box 10 10 10) (translate (make-box 10 10 10) 100 100 100))`
- **THEN** system returns nil

#### Scenario: Section nil first argument
- **WHEN** user calls `(section nil (make-box 5 5 5))`
- **THEN** system returns nil

#### Scenario: Section nil second argument
- **WHEN** user calls `(section (make-box 5 5 5) nil)`
- **THEN** system returns nil

### Requirement: Variadic section
The section operation SHALL accept two or more shape arguments, chaining left-to-right.

#### Scenario: Section three shapes
- **WHEN** user calls `(section a b c)`
- **THEN** result is equivalent to `(section (section a b) c)`
