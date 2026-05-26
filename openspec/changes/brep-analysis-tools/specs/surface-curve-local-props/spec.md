## ADDED Requirements

### Requirement: Curve tangent at parameter
The system SHALL compute the tangent vector of a curve at a given parameter using `BRepLProp_CLProps`.

#### Scenario: Tangent of a line
- **WHEN** user calls `(curve-tangent-at curve 0.5)`
- **THEN** returns the unit tangent vector as three values (tx ty tz)

### Requirement: Curve curvature at parameter
The system SHALL compute the curvature of a curve at a given parameter.

#### Scenario: Curvature of a circle
- **WHEN** user calls `(curve-curvature-at circle 0.0)`
- **THEN** returns 1/radius as a double-float

### Requirement: Surface normal at UV
The system SHALL compute the normal vector of a surface at given UV parameters using `BRepLProp_SLProps`.

#### Scenario: Normal of a plane
- **WHEN** user calls `(surface-normal-at plane 0.0 0.0)`
- **THEN** returns the unit normal as three values (nx ny nz)

### Requirement: Surface curvature at UV
The system SHALL compute the minimum and maximum curvature at a point on a surface.

#### Scenario: Curvature of a sphere surface
- **WHEN** user calls `(surface-curvature-at sphere-surface 0.0 0.0)`
- **THEN** returns two values: min-curvature, max-curvature (both = 1/radius for a sphere)

### Requirement: Face local properties
The system SHALL compute local properties (normal, curvature) at a UV point on a face.

#### Scenario: Face normal at UV
- **WHEN** user calls `(face-normal-at face u v)`
- **THEN** returns three values (nx ny nz) — the surface normal at that UV

#### Scenario: Face curvature at UV
- **WHEN** user calls `(face-curvature-at face u v)`
- **THEN** returns two values (min-curvature max-curvature)
