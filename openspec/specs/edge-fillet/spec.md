## ADDED Requirements

### Requirement: Constant-radius edge fillet on a solid
The system SHALL round edges of a solid with a constant radius using `BRepFilletAPI_MakeFillet`.

#### Scenario: Fillet a single edge of a box
- **WHEN** user calls `(fillet-edge box edge 5.0)`
- **THEN** returns a shape with the specified edge rounded to radius 5.0

#### Scenario: Fillet multiple edges with same radius
- **WHEN** user calls `(fillet-edges box '(edge1 edge2 edge3) 5.0)`
- **THEN** returns a shape with all 3 edges filleted at radius 5.0

#### Scenario: Fillet with radius larger than edge length returns nil
- **WHEN** user calls `(fillet-edge box edge 999.0)`
- **THEN** returns nil (operation fails gracefully)

#### Scenario: Nil shape returns nil
- **WHEN** user calls `(fillet-edge nil edge 5.0)`
- **THEN** returns nil

### Requirement: Variable-radius edge fillet
The system SHALL fillet an edge with different radii at different points along the edge using `BRepFilletAPI_MakeFillet::Add(radius, edge)` with multiple radius values.

#### Scenario: Variable radius on one edge
- **WHEN** user calls `(fillet-edge-variable box edge '((0.0 5.0) (0.5 3.0) (1.0 8.0)))`
- **THEN** returns a shape with the edge filleted at varying radius (5 at start, 3 at middle, 8 at end)

### Requirement: 2D fillet on planar wire
The system SHALL fillet (round) corners of a planar wire using `BRepFilletAPI_MakeFillet2d`.

#### Scenario: Fillet a corner of a rectangular wire
- **WHEN** user calls `(fillet-wire-corner wire radius)`
- **THEN** returns a shape with the wire corner rounded

#### Scenario: Fillet all corners of a wire
- **WHEN** user calls `(fillet-wire-all-corners wire radius)`
- **THEN** returns a shape with all wire corners rounded

#### Scenario: Invalid wire returns nil
- **WHEN** user calls `(fillet-wire-corner non-planar-wire radius)`
- **THEN** returns nil
