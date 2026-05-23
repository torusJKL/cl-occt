## ADDED Requirements

### Requirement: Topology explorer for sub-shapes
The system SHALL walk sub-shapes of a given type using `TopExp_Explorer`, providing a Lisp-idiomatic iteration interface.

#### Scenario: Explore faces of a box
- **WHEN** user calls `(map-shape-subshapes box :face)`
- **THEN** returns a list of 6 face shapes

#### Scenario: Explore edges of a box
- **WHEN** user calls `(map-shape-subshapes box :edge)`
- **THEN** returns a list of 12 edge shapes

#### Scenario: Explore vertices of a box
- **WHEN** user calls `(map-shape-subshapes box :vertex)`
- **THEN** returns a list of 8 vertex shapes

#### Scenario: Explore with compound type filter
- **WHEN** user calls `(map-shape-subshapes shape :edge :stop-at :face)`
- **THEN** explores edges but stops at faces (does not descend into sub-wires)

#### Scenario: Count sub-shapes
- **WHEN** user calls `(count-shape-subshapes box :face)`
- **THEN** returns 6

### Requirement: BRepTools shape dump and utilities
The system SHALL provide BRepTools utilities: shape triangulation (triangle count, vertex/face access), wire ordering verification, and text shape dump.

#### Scenario: Dump shape as text
- **WHEN** user calls `(dump-shape box)`
- **THEN** returns a string containing the topological structure of the shape

#### Scenario: Shape triangulation
- **WHEN** user calls `(shape-triangle-count box)`
- **THEN** returns the number of triangles after meshing

#### Scenario: Wire order check
- **WHEN** user calls `(wire-order-check-p wire face)`
- **THEN** returns t if the wire edges are in the correct order relative to the face

### Requirement: BRepAdaptor geometric queries
The system SHALL provide geometric access to BRep edges and faces via `BRepAdaptor_CompCurve`, `BRepAdaptor_Curve`, and `BRepAdaptor_Surface`, returning curves and surfaces from topological entities.

#### Scenario: Get curve from edge
- **WHEN** user calls `(edge->curve edge)`
- **THEN** returns a `curve` instance representing the edge's 3D curve (requires curve type from geometry-foundation)

#### Scenario: Get surface from face
- **WHEN** user calls `(face->surface face)`
- **THEN** returns a `surface` instance representing the face's underlying surface (requires surface type from geometry-foundation)

### Requirement: Vertex construction
The system SHALL construct a BRep vertex from a 3D point using `BRepBuilderAPI_MakeVertex`.

#### Scenario: Make vertex from coordinates
- **WHEN** user calls `(make-vertex 1.0 2.0 3.0)`
- **THEN** returns a shape representing a vertex at (1, 2, 3)

### Requirement: Polygon construction
The system SHALL construct a polygonal shape (wire of edges) from a sequence of 3D points using `BRepBuilderAPI_MakePolygon`.

#### Scenario: Make polygon from 4 points
- **WHEN** user calls `(make-polygon '((0 0 0) (10 0 0) (10 10 0) (0 10 0)))`
- **THEN** returns a shape (wire) containing 4 edges forming a closed rectangle

#### Scenario: Make open polygon
- **WHEN** user calls `(make-polygon '((0 0 0) (10 0 0) (10 10 0)) :closed nil)`
- **THEN** returns an open wire with 3 edges

#### Scenario: Invalid (too few points) returns nil
- **WHEN** user calls `(make-polygon '((0 0 0)))`
- **THEN** returns nil
