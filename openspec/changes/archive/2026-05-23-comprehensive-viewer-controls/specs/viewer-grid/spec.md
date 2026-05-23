## ADDED Requirements

### Requirement: Set grid color
The system SHALL set the grid line color.

#### Scenario: Grey grid
- **WHEN** user calls `(set-grid-color viewer '(0.5 0.5 0.5))`
- **THEN** the grid renders in medium grey

#### Scenario: Grid color with named color
- **WHEN** user calls `(set-grid-color viewer :dark-grey)`
- **THEN** the grid renders in dark grey (requires viewer-colors spec)

### Requirement: Set grid size
The system SHALL set the grid spacing uniformly.

#### Scenario: Size-10 grid
- **WHEN** user calls `(set-grid-size viewer 10.0)`
- **THEN** the grid spacing is 10 scene units

### Requirement: Set non-uniform grid size
The system SHALL set X and Y grid spacing independently.

#### Scenario: Rectangular grid cells
- **WHEN** user calls `(set-grid-xy-size viewer 5.0 10.0)`
- **THEN** the grid has 5-unit X spacing and 10-unit Y spacing

### Requirement: Set grid offset
The system SHALL offset the grid from the world origin.

#### Scenario: Offset grid
- **WHEN** user calls `(set-grid-offset viewer '(2.5 3.5))`
- **THEN** the grid is offset by (2.5, 3.5) from the origin

### Requirement: Query grid properties
The system SHALL return the current grid color, size, and offset.

#### Scenario: Get grid state
- **WHEN** user calls `(grid-color viewer)`, `(grid-size viewer)`, `(grid-offset viewer)`
- **THEN** returns the current grid color as `(r g b)`, size as a number or `(x y)`, offset as `(x y)`

### Requirement: Grid active-p query
The system SHALL report whether the grid is currently active.

#### Scenario: Grid active check
- **WHEN** user calls `(grid-active-p viewer)`
- **THEN** returns `t` if grid is active, `nil` otherwise (complements existing activate-grid/deactivate-grid)
