## ADDED Requirements

### Requirement: Create colored shape from shape and color map
The system SHALL provide a constructor `make-colored-shape` that wraps a shape with per-subshape color assignments using `AIS_ColoredShape`.

#### Scenario: Create a colored shape from a box and color map
- **WHEN** the user calls `(make-colored-shape shape color-map)` with a box shape and a color map
- **THEN** the system returns an `ais-object` instance with a non-null C handle

#### Scenario: Create colored shape with nil shape returns nil
- **WHEN** the user calls `(make-colored-shape nil color-map)`
- **THEN** the system returns `nil`

#### Scenario: Display a colored shape
- **WHEN** the user creates a colored shape and calls `(ais-display ctx colored-obj)`
- **THEN** the shape is displayed in the viewer with the assigned per-subshape colors
