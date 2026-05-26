## ADDED Requirements

### Requirement: Face area query
The system SHALL compute the area of a face using `BRepGProp_Face`.

#### Scenario: Area of a box face
- **WHEN** user calls `(face-area (first (map-shape-subshapes box :face)))`
- **THEN** returns the area as a double-float (e.g., 200.0d0 for a 10x20x30 box)

#### Scenario: Nil face returns nil
- **WHEN** user calls `(face-area nil)`
- **THEN** returns nil

### Requirement: Edge length query
The system SHALL compute the 3D length of an edge using `BRepGProp::LinearProperties`.

#### Scenario: Length of a box edge
- **WHEN** user calls `(edge-length (first (map-shape-subshapes box :edge)))`
- **THEN** returns the 3D curve length as a double-float

### Requirement: Face normal at center
The system SHALL compute the geometric normal at the center of a face using `BRepLProp_SLProps`.

#### Scenario: Normal of a planar face
- **WHEN** user calls `(face-normal-at-center (first (map-shape-subshapes (make-box 10 20 30) :face)))`
- **THEN** returns three values (nx ny nz) representing the outward unit normal

### Requirement: Face surface type
The system SHALL return the surface type of a face (`:plane`, `:cylinder`, `:cone`, `:sphere`, `:torus`, `:bspline`, or nil).

#### Scenario: Box face returns plane
- **WHEN** user calls `(face-surface-type box-face)`
- **THEN** returns `:plane`

#### Scenario: Cylindrical face returns cylinder
- **WHEN** user calls `(face-surface-type cylinder-lateral-face)`
- **THEN** returns `:cylinder`

### Requirement: Edge curve type
The system SHALL return the curve type of an edge (`:line`, `:circle`, `:ellipse`, `:bspline`, or nil).

#### Scenario: Box edge returns line
- **WHEN** user calls `(edge-curve-type box-edge)`
- **THEN** returns `:line`

### Requirement: Face bounding box
The system SHALL compute the bounding box of a single face.

#### Scenario: Bounding box of a box face
- **WHEN** user calls `(face-bounding-box face)`
- **THEN** returns six values (xmin ymin zmin xmax ymax zmax)

### Requirement: Edge bounding box
The system SHALL compute the bounding box of a single edge.

#### Scenario: Bounding box of a box edge
- **WHEN** user calls `(edge-bounding-box edge)`
- **THEN** returns six values (xmin ymin zmin xmax ymax zmax)

### Requirement: Face center point
The system SHALL compute the center (UV midpoint mapped to 3D) of a face.

#### Scenario: Center of a box face
- **WHEN** user calls `(face-center face)`
- **THEN** returns three values (x y z)

### Requirement: Face orientation query
The system SHALL return the orientation (`:forward` or `:reversed`) of a face relative to its surface.

#### Scenario: Box face orientation
- **WHEN** user calls `(face-orientation box-face)`
- **THEN** returns `:forward` or `:reversed`

### Requirement: Edge orientation query
The system SHALL return the orientation (`:forward` or `:reversed`) of an edge relative to its curve.

#### Scenario: Box edge orientation
- **WHEN** user calls `(edge-orientation box-edge)`
- **THEN** returns `:forward` or `:reversed`

### Requirement: Subshape bounding box multi-return
The system SHALL compute the bounding box of any subshape (not just the top-level shape).

#### Scenario: Bounding box of a vertex
- **WHEN** user calls `(subshape-bounding-box vertex)`
- **THEN** returns six values where xmin=xmax, etc. (a degenerate box at the point)

### Requirement: Shape extent along direction
The system SHALL compute the extent (min/max projection) of a shape along a given direction vector.

#### Scenario: Height of a box
- **WHEN** user calls `(shape-extent-along (make-box 10 20 30) 0 0 1)`
- **THEN** returns two values (min-projection max-projection), e.g., 0.0d0 and 30.0d0


