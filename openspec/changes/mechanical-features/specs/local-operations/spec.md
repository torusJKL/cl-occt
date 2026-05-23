## ADDED Requirements

### Requirement: Local extrusion on a face
The system SHALL perform a local extrusion operation on a single face of a shape using `LocOpe`.

#### Scenario: Local extrusion of a face
- **WHEN** user calls `(local-extrude face height)`
- **THEN** returns a shape with the given face extruded

### Requirement: Groove creation
The system SHALL create a groove (revolved cut) on a shape using `LocOpe` groove functions.

#### Scenario: Create a groove
- **WHEN** user calls `(make-groove shape face axis radius)`
- **THEN** returns a shape with a groove cut into the specified face

### Requirement: Rib creation
The system SHALL create a rib on a shape using `LocOpe` rib functions.

#### Scenario: Create a rib
- **WHEN** user calls `(make-rib shape profile-face thickness)`
- **THEN** returns a shape with a rib of the given thickness
