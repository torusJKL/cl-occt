## ADDED Requirements

### Requirement: Create view cube
The system SHALL provide a constructor `make-view-cube` that creates an `AIS_ViewCube` — a 3D orientation cube widget.

#### Scenario: Create a view cube
- **WHEN** the user calls `(make-view-cube)`
- **THEN** the system returns an `ais-object` instance with a non-null C handle

#### Scenario: Display view cube
- **WHEN** the user creates a view cube and calls `(ais-display ctx view-cube)`
- **THEN** the view cube is shown in the corner of the view

#### Scenario: Set view cube size
- **WHEN** the user calls `(set-view-cube-size vc size)`
- **THEN** the view cube is rendered with the given size

#### Scenario: Set view cube box color
- **WHEN** the user calls `(set-view-cube-box-color vc r g b)`
- **THEN** the view cube faces use the given color

#### Scenario: Set view cube corner position
- **WHEN** the user calls `(set-view-cube-corner vc corner)`
- **THEN** the view cube is displayed in the specified corner
