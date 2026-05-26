## ADDED Requirements

### Requirement: Create solids from enclosed cavities
The system SHALL create solids representing the enclosed cavities between a set of shapes using `BOPAlgo_MakerVolume`.

#### Scenario: Cavity between two shells
- **WHEN** user calls `(make-volume (list shell1 shell2))`
- **THEN** returns a compound of solid volumes filling cavities between the shells

#### Scenario: No cavity exists
- **WHEN** user calls `(make-volume (list box))` on a solid box without cavities
- **THEN** returns a compound (MakerVolume may still produce output)

### Requirement: Cells builder for selective boolean results
The system SHALL select specific cells (fragments) from a boolean operation result using `BOPAlgo_CellsBuilder`.

#### Scenario: Select specific fragments by shape index
- **WHEN** user calls `(cells-builder (list shape1 shape2) 0 '(0))` (FUSE, select cells from shape index 0)
- **THEN** returns a compound containing only the selected fragments

#### Scenario: Select all (no selection)
- **WHEN** user calls `(cells-builder (list shape1 shape2) 0)` (FUSE, no selection)
- **THEN** returns a compound of all resulting fragments
