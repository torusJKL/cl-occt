## ADDED Requirements

### Requirement: Face-to-edge navigation
The system SHALL return the bounding edges of a face using `TopExp_Explorer` with face→edge traversal.

#### Scenario: Box face has 4 edges
- **WHEN** user calls `(face-edges box-face)`
- **THEN** returns a list of 4 edge shapes

#### Scenario: Nil face returns nil
- **WHEN** user calls `(face-edges nil)`
- **THEN** returns nil

### Requirement: Edge-to-vertex navigation
The system SHALL return the two vertices bounding an edge using `TopExp::Vertices`.

#### Scenario: Box edge has 2 vertices
- **WHEN** user calls `(edge-vertices box-edge)`
- **THEN** returns two values: the start vertex and end vertex shapes

#### Scenario: Nil edge returns nil
- **WHEN** user calls `(edge-vertices nil)`
- **THEN** returns nil

### Requirement: Vertex-to-edge navigation
The system SHALL return all edges incident to a vertex using `TopExp_Explorer` with vertex context.

#### Scenario: Box corner has 3 incident edges
- **WHEN** user calls `(vertex-edges box-vertex)`
- **THEN** returns a list of 3 edge shapes

#### Scenario: Nil vertex returns nil
- **WHEN** user calls `(vertex-edges nil)`
- **THEN** returns nil

### Requirement: Edge-to-face navigation
The system SHALL return the one or two faces sharing an edge.

#### Scenario: Interior edge has 2 faces
- **WHEN** user calls `(edge-faces interior-edge)`
- **THEN** returns a list of 2 face shapes

#### Scenario: Boundary edge has 1 face
- **WHEN** user calls `(edge-faces boundary-edge)`
- **THEN** returns a list of 1 face shape

### Requirement: Face-to-wire decomposition
The system SHALL return the outer wire and any inner wires (holes) of a face using `BRepTools::OuterWire` and wire iteration.

#### Scenario: Box face has one wire
- **WHEN** user calls `(face-wires box-face)`
- **THEN** returns a list with 1 wire (the outer wire)

#### Scenario: Face with hole has two wires
- **WHEN** user calls `(face-wires face-with-hole)`
- **THEN** returns a list of 2 wires (outer wire + hole wire)

### Requirement: Wire-to-edge decomposition
The system SHALL return the ordered edges of a wire using `BRepTools_WireExplorer`.

#### Scenario: Rectangular wire has 4 edges
- **WHEN** user calls `(wire-edges rect-wire)`
- **THEN** returns a list of 4 edge shapes in order

### Requirement: Subshape orientation query
The system SHALL return the orientation (`:forward`, `:reversed`, `:internal`, or `:external`) of any subshape.

#### Scenario: Face orientation
- **WHEN** user calls `(subshape-orientation box-face)`
- **THEN** returns `:forward`

### Requirement: Subshape type query
The system SHALL return the type (`:face`, `:edge`, `:vertex`, `:wire`, `:shell`, `:solid`, `:compound`, `:compsolid`) of any shape.

#### Scenario: Box top-level type
- **WHEN** user calls `(shape-type (make-box 10 20 30))`
- **THEN** returns `:solid`


