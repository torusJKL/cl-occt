## ADDED Requirements

### Requirement: Find edges by curve type
The system SHALL find all edges in a shape that have a specific curve type (line, circle, ellipse, etc.) via `BRepLib_FindEdges`.

#### Scenario: Box has 12 line edges
- **WHEN** a box's edges are searched for line type
- **THEN** the result SHALL contain 12 edges

#### Scenario: Cylinder has circular edges
- **WHEN** a cylinder's edges are searched for circle type
- **THEN** the result SHALL contain 2 circular edges (top and bottom)

### Requirement: Find edges by radius
The system SHALL find all circular edges with a specific radius.

#### Scenario: Cylinder with radius 5 has circular edges of radius 5
- **WHEN** a cylinder of radius 5 is searched for circular edges with radius 5.0
- **THEN** the result SHALL contain 2 edges

#### Scenario: No match returns empty list
- **WHEN** a box is searched for circular edges of radius 5
- **THEN** the result SHALL be an empty list
