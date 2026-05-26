## ADDED Requirements

### Requirement: Create solids from enclosed cavities
The system SHALL create solids representing the enclosed cavities between a set of shapes using `BOPAlgo_MakerVolume`.

#### Scenario: Cavity between two shells
- **WHEN** user calls `(make-volume (list shell1 shell2))`
- **THEN** returns a list of solid volumes filling cavities between the shells

#### Scenario: Single shape with cavity
- **WHEN** user calls `(make-volume (list shell))`
- **THEN** returns the enclosed volume (if any)

#### Scenario: No cavity exists
- **WHEN** user calls `(make-volume (list (make-box 10 20 30)))`
- **THEN** returns nil (no cavity in a solid box)

### Requirement: Cells builder for selective boolean results
The system SHALL select specific cells (fragments) from a boolean operation result using `BOPAlgo_CellsBuilder`.

#### Scenario: Select specific fragments
- **WHEN** user calls `(cells-builder (list shape1 shape2) :common :select '(:fragment-1 :fragment-3))`
- **THEN** returns a compound containing only the selected fragments

#### Scenario: Select all
- **WHEN** user calls `(cells-builder (list shape1 shape2) :fuse :select :all)`
- **THEN** returns a compound of all resulting fragments
