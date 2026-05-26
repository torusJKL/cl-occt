## ADDED Requirements

### Requirement: Create AIS_Plane
The system SHALL provide a constructor `make-ais-plane` that creates an `AIS_Plane` from a position and normal vector.

#### Scenario: Create a plane overlay
- **WHEN** the user calls `(make-ais-plane position normal &key size)`
- **THEN** the system returns an `ais-object` representing an infinite plane

#### Scenario: Display plane in viewer
- **WHEN** the user creates a plane and calls `(ais-display ctx plane)`
- **THEN** the plane is displayed as a semi-transparent grid overlay

### Requirement: Create AIS_Axis
The system SHALL provide a constructor `make-ais-axis` that creates an `AIS_Axis` from an origin point and a direction vector.

#### Scenario: Create an axis overlay
- **WHEN** the user calls `(make-ais-axis origin direction)`
- **THEN** the system returns an `ais-object` representing an infinite axis line

### Requirement: Create AIS_Line
The system SHALL provide a constructor `make-ais-line` that creates an `AIS_Line` from two points or a point and direction.

#### Scenario: Create a line overlay between two points
- **WHEN** the user calls `(make-ais-line p1 p2)`
- **THEN** the system returns an `ais-object` representing a finite line segment

### Requirement: Create AIS_Circle
The system SHALL provide a constructor `make-ais-circle` that creates an `AIS_Circle` from a center point, normal, and radius.

#### Scenario: Create a circle overlay
- **WHEN** the user calls `(make-ais-circle center normal radius)`
- **THEN** the system returns an `ais-object` representing a circle
