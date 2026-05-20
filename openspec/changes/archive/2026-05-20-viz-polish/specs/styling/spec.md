## ADDED Requirements

### Requirement: Set background color
The system SHALL set the viewer's background color via RGB values in [0,1] range.

#### Scenario: Set dark background
- **WHEN** user calls `(set-background viewer 0.1 0.1 0.2)`
- **THEN** the viewer background is rendered in dark blue-grey

### Requirement: Set object color
The system SHALL set the color of a displayed object via an (r g b) list in [0,1].

#### Scenario: Color a displayed shape
- **WHEN** user calls `(ais-set-color ctx obj '(1.0 0.0 0.0))`
- **THEN** the object renders in red

### Requirement: Unset object color
The system SHALL revert an object to its default (material) color.

### Requirement: Set display mode
The system SHALL switch an object between wireframe and shaded display.

#### Scenario: Switch to wireframe
- **WHEN** user calls `(ais-set-display-mode ctx obj :wireframe)`
- **THEN** the object renders as wireframe edges only

#### Scenario: Switch to shaded
- **WHEN** user calls `(ais-set-display-mode ctx obj :shaded)`
- **THEN** the object renders with shaded surfaces

### Requirement: Set camera projection
The system SHALL orient the view to a named direction.

#### Scenario: Isometric view
- **WHEN** user calls `(set-view-projection view :iso-pers)`
- **THEN** the view orients to an isometric perspective

#### Scenario: Front view
- **WHEN** user calls `(set-view-projection view :z-pos)`
- **THEN** the view orients to look along +Z

### Requirement: Configure MSAA
The system SHALL set and read the multisample anti-aliasing sample count.

#### Scenario: Set MSAA to 4
- **WHEN** user calls `(set-msaa view 4)` then `(msaa view)`
- **THEN** system returns 4

### Requirement: Configure anti-aliasing
The system SHALL enable or disable anti-aliasing.

#### Scenario: Enable antialiasing
- **WHEN** user calls `(set-antialiasing view t)` then `(antialiasing-p view)`
- **THEN** system returns t

### Requirement: Activate grid
The system SHALL display a grid in the viewer with configurable type and draw mode.

#### Scenario: Rectangular lines grid
- **WHEN** user calls `(activate-grid viewer :rectangular :lines)`
- **THEN** a rectangular line grid is displayed

#### Scenario: Circular points grid
- **WHEN** user calls `(activate-grid viewer :circular :points)`
- **THEN** a circular point grid is displayed

### Requirement: Deactivate grid
The system SHALL hide the grid.

#### Scenario: Turn off grid
- **WHEN** user calls `(deactivate-grid viewer)`
- **THEN** the grid is no longer displayed

### Requirement: Invalidate view
The system SHALL mark the view for redraw after property changes.

#### Scenario: Invalidate after style change
- **WHEN** user changes a property and calls `(invalidate-view view)`
- **THEN** the view redraws with updated properties
