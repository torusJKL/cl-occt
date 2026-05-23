## ADDED Requirements

### Requirement: Offset a 3D shape outward or inward
The system SHALL offset a solid or shell shape by a given distance using `BRepOffsetAPI_MakeOffsetShape`, producing an enlarged or reduced version.

#### Scenario: Offset a box outward
- **WHEN** user calls `(offset-shape box 5.0)`
- **THEN** returns a shape enlarged by 5.0 in all directions

#### Scenario: Offset a box inward
- **WHEN** user calls `(offset-shape box -3.0)`
- **THEN** returns a shape reduced by 3.0

#### Scenario: Offset beyond feature size returns nil
- **WHEN** user calls `(offset-shape box -999.0)`
- **THEN** returns nil

### Requirement: Offset with join type control
The system SHALL support different join types (arc, tangent, intersection) for offset shape corners.

#### Scenario: Offset with arc join
- **WHEN** user calls `(offset-shape box 5.0 :join :arc)`
- **THEN** returns an offset with rounded corners

#### Scenario: Offset with intersection join
- **WHEN** user calls `(offset-shape box 5.0 :join :intersection)`
- **THEN** returns an offset with sharp corners

### Requirement: Offset a planar wire (2D offset)
The system SHALL offset a planar wire in its plane by a given distance using `BRepOffsetAPI_MakeOffset`.

#### Scenario: Offset a rectangular wire outward
- **WHEN** user calls `(offset-wire rect-wire 3.0)`
- **THEN** returns a wire enlarged by 3.0 in the plane

#### Scenario: Offset a wire inward
- **WHEN** user calls `(offset-wire rect-wire -2.0)`
- **THEN** returns a wire reduced by 2.0

#### Scenario: Wire offset with nil returns nil
- **WHEN** user calls `(offset-wire nil 5.0)`
- **THEN** returns nil
