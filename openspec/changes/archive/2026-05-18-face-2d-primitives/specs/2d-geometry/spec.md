## ADDED Requirements

### Requirement: 2D point construction
User SHALL be able to construct a 2D point by specifying x and y coordinates. The system SHALL use OCCT gp_Pnt2d. Points are used internally for edge and curve construction.

#### Scenario: Construct a 2D point
- **WHEN** user calls `(make-pnt2d 10.0 20.0)`
- **THEN** system returns a 2D point object with x=10.0, y=20.0

### Requirement: 2D vector construction
User SHALL be able to construct a 2D vector by specifying x and y components. The system SHALL use OCCT gp_Vec2d. Vectors are used internally for curve direction specification.

#### Scenario: Construct a 2D vector
- **WHEN** user calls `(make-vec2d 3.0 4.0)`
- **THEN** system returns a 2D vector object with x=3.0, y=4.0

### Requirement: 2D direction construction
User SHALL be able to construct a 2D direction (unit vector) by specifying x and y components. The system SHALL use OCCT gp_Dir2d and SHALL normalize the input. A zero-magnitude input SHALL return nil.

#### Scenario: Construct a 2D direction
- **WHEN** user calls `(make-dir2d 1.0 0.0)`
- **THEN** system returns a 2D direction object representing the +X direction

#### Scenario: Construct a 2D direction from zero vector
- **WHEN** user calls `(make-dir2d 0.0 0.0)`
- **THEN** system returns nil

### Requirement: Memory management for 2D geometry
Each 2D point, vector, and direction MUST be a distinct CLOS instance managed by `tg:finalize` for automatic garbage collection.

#### Scenario: Distinct 2D objects
- **WHEN** user calls `(make-pnt2d 1 2)` twice
- **THEN** the two return values are not `eq`
