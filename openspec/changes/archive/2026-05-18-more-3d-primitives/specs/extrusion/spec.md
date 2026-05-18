## ADDED Requirements

### Requirement: Prism (linear extrusion)
User SHALL be able to linearly extrude a shape by specifying a 3D vector. The system SHALL use OCCT BRepPrimAPI_MakePrism. The extrusion vector MUST have non-zero magnitude.

#### Scenario: Extrude a face into a prism
- **WHEN** user calls `(make-prism <face-shape> 0 0 10)`
- **THEN** system returns a shape object representing the face extruded 10 units in the Z direction

#### Scenario: Prism with zero vector
- **WHEN** user calls `(make-prism <face-shape> 0 0 0)`
- **THEN** system returns nil

#### Scenario: Prism with nil shape
- **WHEN** user calls `(make-prism nil 0 0 10)`
- **THEN** system returns nil

### Requirement: Revolution (rotational extrusion)
User SHALL be able to rotationally extrude a shape around an axis by a specified angle. The axis is defined by a direction vector through the origin. The system SHALL use OCCT BRepPrimAPI_MakeRevol. The angle MUST be non-zero.

#### Scenario: Revolve a profile
- **WHEN** user calls `(make-revol <profile-shape> 0 0 1 360)`
- **THEN** system returns a shape object representing the profile revolved 360 degrees around the Z axis

#### Scenario: Revolution with zero angle
- **WHEN** user calls `(make-revol <profile-shape> 0 0 1 0)`
- **THEN** system returns nil

#### Scenario: Revolution with nil shape
- **WHEN** user calls `(make-revol nil 0 0 1 360)`
- **THEN** system returns nil
