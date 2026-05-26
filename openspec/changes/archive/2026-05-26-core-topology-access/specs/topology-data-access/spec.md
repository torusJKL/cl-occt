## ADDED Requirements

### Requirement: Vertex point coordinates
The system SHALL provide access to the 3D coordinates of a vertex via `BRep_Tool::Pnt`.

#### Scenario: Box vertex returns expected coordinates
- **WHEN** a vertex of a 10x20x30 box is queried
- **THEN** the returned coordinates SHALL match the expected spatial position

#### Scenario: Null vertex returns nil
- **WHEN** a null vertex is queried
- **THEN** the result SHALL be nil

### Requirement: Edge curve with parameter range
The system SHALL return the `Geom_Curve` underlying an edge together with the `(first, last)` parameter range that defines the edge's trim on that curve via `BRep_Tool::Curve`.

#### Scenario: Box edge returns line with parameter range
- **WHEN** an edge of a 10x20x30 box is queried
- **THEN** the curve SHALL be a line and first SHALL be 0.0, last SHALL be the edge length

#### Scenario: Circular edge returns circle with parameter range
- **WHEN** a circular edge (e.g., from a cylinder) is queried
- **THEN** the curve SHALL be a circle with first=0.0 and last=2*PI

#### Scenario: Null edge returns nil
- **WHEN** a null edge is queried
- **THEN** the result SHALL be nil

### Requirement: Face surface with UV bounds
The system SHALL return the `Geom_Surface` underlying a face together with the `(u-min, u-max, v-min, v-max)` UV domain bounds via `BRep_Tool::Surface` and `BRepAdaptor_Surface`.

#### Scenario: Box face returns plane with UV bounds
- **WHEN** a face of a 10x20x30 box is queried
- **THEN** the surface SHALL be a plane and UV bounds SHALL match the face dimensions

#### Scenario: Cylinder face returns cylindrical surface with UV bounds
- **WHEN** the lateral face of a cylinder (radius=5, height=10) is queried
- **THEN** the surface SHALL be cylindrical with U=[0, 2*PI], V=[0, 10]

#### Scenario: Null face returns nil
- **WHEN** a null face is queried
- **THEN** the result SHALL be nil

### Requirement: Shape tolerance query
The system SHALL expose the tolerance of edges and faces via `BRep_Tool::Tolerance`.

#### Scenario: Primitive edge has positive tolerance
- **WHEN** an edge of a box is queried
- **THEN** the returned tolerance SHALL be a positive double-float

#### Scenario: Null shape returns nil
- **WHEN** a null shape is queried for tolerance
- **THEN** the result SHALL be nil

### Requirement: Face natural restriction predicate
The system SHALL indicate whether a face has natural restriction (i.e., its UV bounds match the full surface parameterization) via `BRep_Tool::NaturalRestriction`.

#### Scenario: Box face has natural restriction
- **WHEN** a box face is queried
- **THEN** natural-restriction SHALL be true (the face IS the full plane)

#### Scenario: Trimmed face lacks natural restriction
- **WHEN** a trimmed face is queried
- **THEN** natural-restriction SHALL be false

### Requirement: Shape orientation reversal
The system SHALL provide a function to create a shape with reversed orientation from an existing shape via `TopoDS::Reversed`.

#### Scenario: Forward face becomes reversed
- **WHEN** a forward-oriented face is reversed
- **THEN** the resulting face orientation SHALL be `:reversed`

#### Scenario: Null shape returns nil
- **WHEN** a null shape is reversed
- **THEN** the result SHALL be nil

### Requirement: Orientation query on any shape
The system SHALL provide a function to query the orientation of any shape as a keyword.

#### Scenario: Box face has forward orientation
- **WHEN** a box face is queried for orientation
- **THEN** the result SHALL be `:forward`

#### Scenario: Reversed face has reversed orientation
- **WHEN** a reversed face is queried for orientation
- **THEN** the result SHALL be `:reversed`
