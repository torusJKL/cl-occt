## ADDED Requirements

### Requirement: User can query triangle adjacency
The system SHALL wrap `Poly_Connect` to provide triangle adjacency queries. Given a triangle index and edge index (0-2), the system SHALL return the adjacent triangle index, or -1 if no adjacent triangle exists.

#### Scenario: Get adjacent triangle
- **WHEN** user calls `(mesh-triangle-adjacent shape tri-index edge-index)` on a meshed shape
- **THEN** returns the adjacent triangle index, or -1 if none

#### Scenario: Adjacent on boundary
- **WHEN** user calls `(mesh-triangle-adjacent shape 0 0)` where edge 0 of triangle 0 is on the boundary
- **THEN** returns -1

#### Scenario: Adjacent on nil shape
- **WHEN** user calls `(mesh-triangle-adjacent nil 0 0)`
- **THEN** returns nil

### Requirement: User can query triangle elements
The system SHALL provide a function to get the three vertex indices of a given triangle.

#### Scenario: Get triangle elements
- **WHEN** user calls `(mesh-triangle-elements shape tri-index)` on a meshed shape
- **THEN** returns three values (i0 i1 i2) representing vertex indices

#### Scenario: Elements on invalid index
- **WHEN** user calls `(mesh-triangle-elements shape -1)`
- **THEN** returns nil

### Requirement: User can query nodes of a triangle
The system SHALL provide a function returning the 3D points of a triangle's vertices.

#### Scenario: Get triangle nodes
- **WHEN** user calls `(mesh-triangle-nodes shape tri-index)` on a meshed shape
- **THEN** returns three values of `(x y z)` triples
