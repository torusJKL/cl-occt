## ADDED Requirements

### Requirement: Uniform abscissa points on curve
The system SHALL compute N evenly-spaced points along a curve by arc length via `GCPnts_UniformAbscissa`.

#### Scenario: Line returns evenly-spaced points
- **WHEN** a line from (0,0,0) to (10,0,0) is sampled with 5 points
- **THEN** the result SHALL be 5 points at x = 0, 2.5, 5.0, 7.5, 10.0

#### Scenario: Null curve returns nil
- **WHEN** a null curve is sampled
- **THEN** the result SHALL be nil

### Requirement: Uniform deflection points on curve
The system SHALL compute points along a curve with a maximum deflection tolerance via `GCPnts_UniformDeflection`.

#### Scenario: Circle returns points within deflection tolerance
- **WHEN** a circle is sampled with deflection=0.1
- **THEN** the chordal deviation SHALL be ≤ 0.1 between consecutive points
