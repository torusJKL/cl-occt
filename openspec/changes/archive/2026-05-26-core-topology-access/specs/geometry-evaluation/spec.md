## ADDED Requirements

### Requirement: Curve evaluation at parameter
The system SHALL evaluate a `Geom_Curve` at a given parameter `t` and return the 3D point `(x, y, z)` via `Geom_Curve::Value(t)`.

#### Scenario: Line evaluated at parameter returns expected point
- **WHEN** a line along X-axis from origin is evaluated at t=5.0
- **THEN** the result SHALL be (5.0, 0.0, 0.0)

#### Scenario: Circle evaluated at parameter returns point on circle
- **WHEN** a circle of radius 5 in XY plane is evaluated at t=PI/2
- **THEN** the result SHALL be approximately (0.0, 5.0, 0.0)

#### Scenario: Null curve returns nil
- **WHEN** a null curve is evaluated
- **THEN** the result SHALL be nil

#### Scenario: Out of range parameter returns nil
- **WHEN** a curve is evaluated at a parameter outside its defined range
- **THEN** the result SHOULD be nil or the projected point (OCCT-dependent)

### Requirement: Surface evaluation at UV
The system SHALL evaluate a `Geom_Surface` at given `(u, v)` parameters and return the 3D point `(x, y, z)` via `Geom_Surface::Value(u, v)`.

#### Scenario: Plane evaluated at origin
- **WHEN** a plane at z=0 is evaluated at u=0, v=0
- **THEN** the result SHALL be (0.0, 0.0, 0.0)

#### Scenario: Cylinder evaluated at parameters
- **WHEN** a cylinder (radius=5, axis=Z) is evaluated at u=0, v=0
- **THEN** the result SHALL be approximately (5.0, 0.0, 0.0)

#### Scenario: Null surface returns nil
- **WHEN** a null surface is evaluated
- **THEN** the result SHALL be nil

### Requirement: Precision constants exposed
The system SHALL expose OCCT precision constants as Lisp constants for use by client code.

#### Scenario: Precision::Confusion is positive
- **WHEN** `+precision-confusion+` is accessed
- **THEN** it SHALL be a positive double-float (typically 1e-7)

#### Scenario: Precision::Angular is positive
- **WHEN** `+precision-angular+` is accessed
- **THEN** it SHALL be a positive double-float (typically 1e-12)

#### Scenario: Precision::Intersection is positive
- **WHEN** `+precision-intersection+` is accessed
- **THEN** it SHALL be a positive double-float (typically 1e-10)
