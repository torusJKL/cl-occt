## ADDED Requirements

### Requirement: Create location from translation
The system SHALL create a `TopLoc_Location` from a translation vector via `gp_Trsf`.

#### Scenario: Translation location moves shape
- **WHEN** a location from (5, 10, 15) is applied to a vertex at (0,0,0)
- **THEN** the moved vertex SHALL be at (5, 10, 15)

### Requirement: Compose locations
The system SHALL compose two locations via multiplication.

#### Scenario: Two translations compose
- **WHEN** location A (5,0,0) and location B (3,0,0) are composed
- **THEN** the result SHALL be equivalent to translation (8, 0, 0)

### Requirement: Invert location
The system SHALL invert a location.

#### Scenario: Translation inversion
- **WHEN** a location (5, 0, 0) is inverted
- **THEN** the inverted location SHALL be equivalent to (-5, 0, 0)

### Requirement: Get shape location
The system SHALL query the `TopLoc_Location` of a shape.

#### Scenario: Box has identity location
- **WHEN** a box is queried for its location
- **THEN** the location SHALL be the identity

### Requirement: Move shape by location
The system SHALL return a new shape with a location applied, without mutating the original.

#### Scenario: Box moved by location is at new position
- **WHEN** a box is moved by a translation location
- **THEN** the moved box's bounding box SHALL be shifted by the translation
