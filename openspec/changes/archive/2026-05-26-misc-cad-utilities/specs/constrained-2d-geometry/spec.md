## ADDED Requirements

### Requirement: Circle tangent to two lines
The system SHALL compute circles tangent to two given 2D lines via `GccAna_Circ2d2TanOn`.

#### Scenario: Circle tangent to two lines returns solutions
- **WHEN** two intersecting lines are provided
- **THEN** the result SHALL include at least one circle tangent to both lines

#### Scenario: Parallel lines return no solutions
- **WHEN** two parallel lines are provided
- **THEN** the result SHALL be an empty list

### Requirement: Line through two points
The system SHALL compute a 2D line through two given points.

#### Scenario: Two distinct points return a line
- **WHEN** two distinct 2D points are provided
- **THEN** the result SHALL be a line passing through both points

#### Scenario: Coincident points return nil
- **WHEN** two identical 2D points are provided
- **THEN** the result SHALL be nil
