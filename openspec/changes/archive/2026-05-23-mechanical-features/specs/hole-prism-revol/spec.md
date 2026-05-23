## ADDED Requirements

### Requirement: Create a cylindrical hole in a solid
The system SHALL create a cylindrical hole (through or blind) at a given position on a face using `BRepFeat_MakeCylindricalHole`.

#### Scenario: Through hole in a box
- **WHEN** user calls `(make-cylindrical-hole box face radius 1.0 :through t)`
- **THEN** returns a shape with a through hole of the given radius

#### Scenario: Blind hole in a box
- **WHEN** user calls `(make-cylindrical-hole box face radius depth)`
- **THEN** returns a shape with a blind hole of the given radius and depth

#### Scenario: Hole with nil shape returns nil
- **WHEN** user calls `(make-cylindrical-hole nil face radius depth)`
- **THEN** returns nil

### Requirement: Prismatic depression/protrusion from a face
The system SHALL extrude a face or wire from a base face to create a prismatic depression (remove material) or protrusion (add material) using `BRepFeat_MakePrism`.

#### Scenario: Prismatic depression (cut)
- **WHEN** user calls `(make-prism-feature base-face profile-face height :operation :cut)`
- **THEN** returns a shape with a prismatic depression of the given height

#### Scenario: Prismatic protrusion (add)
- **WHEN** user calls `(make-prism-feature base-face profile-face height :operation :add)`
- **THEN** returns a shape with a prismatic protrusion of the given height

#### Scenario: Prism with direction vector
- **WHEN** user calls `(make-prism-feature base-face profile-face height :direction '(0 0 -1))`
- **THEN** returns a shape extruded in the specified direction

### Requirement: Rotational depression/protrusion from a face
The system SHALL revolve a profile from a base face around an axis to create a rotational feature using `BRepFeat_MakeRevol`.

#### Scenario: Rotational depression
- **WHEN** user calls `(make-revol-feature base-face profile-face axis angle :operation :cut)`
- **THEN** returns a shape with a rotational depression of the given angle

#### Scenario: Rotational protrusion
- **WHEN** user calls `(make-revol-feature base-face profile-face axis angle :operation :add)`
- **THEN** returns a shape with a rotational protrusion
