## ADDED Requirements

### Requirement: User can extract triangulation data from a meshed shape
The system SHALL provide access to `Poly_Triangulation` data from a meshed shape, including vertex positions, triangle index arrays, and triangle counts. Results SHALL be returned as Lisp-friendly data structures (lists or vectors).

#### Scenario: Get vertex positions from meshed box
- **WHEN** user calls `(mesh-get-vertices (mesh-shape (make-box 10 20 30)))`
- **THEN** returns a list of `(x y z)` triples representing mesh vertices

#### Scenario: Get triangle indices from meshed box
- **WHEN** user calls `(mesh-get-triangles (mesh-shape (make-box 10 20 30)))`
- **THEN** returns a list of `(i0 i1 i2)` 0-based index triples

#### Scenario: Get triangle count from meshed shape
- **WHEN** user calls `(mesh-get-triangle-count (mesh-shape (make-box 10 20 30)))`
- **THEN** returns the number of triangles as an integer

#### Scenario: Get triangulation from unmeshed shape
- **WHEN** user calls `(mesh-get-vertices (make-box 10 20 30))` (without meshing first)
- **THEN** returns nil (no triangulation available)

#### Scenario: Get triangulation from nil shape
- **WHEN** user calls `(mesh-get-vertices nil)`
- **THEN** returns nil

### Requirement: User can extract normals from a meshed shape
The system SHALL provide access to per-vertex or per-face normals from `Poly_Triangulation`.

#### Scenario: Get normals from meshed box
- **WHEN** user calls `(mesh-get-normals (mesh-shape (make-box 10 20 30)))`
- **THEN** returns a list of `(nx ny nz)` normal vectors, or nil if not available

### Requirement: User can access triangulation per face
The system SHALL allow extracting triangulation data for individual faces of a shape, returning the face-local triangulation (location and triangulation handle).

#### Scenario: Get face-local triangulation
- **WHEN** user calls `(mesh-face-triangulation face)`
- **THEN** returns a plist with `:vertices`, `:triangles`, `:location`, and `:triangle-count`
