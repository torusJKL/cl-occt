## ADDED Requirements

### Requirement: 2D line construction
User SHALL be able to construct a 2D line by specifying an origin point (x, y) and a direction (dx, dy). The system SHALL use OCCT Geom2d_Line. A zero-magnitude direction SHALL return nil.

#### Scenario: Construct a 2D line
- **WHEN** user calls `(make-line2d 0.0 0.0 1.0 0.0)`
- **THEN** system returns a 2D line curve through origin (0,0) with direction +X

#### Scenario: Construct a 2D line with zero direction
- **WHEN** user calls `(make-line2d 0.0 0.0 0.0 0.0)`
- **THEN** system returns nil

### Requirement: 2D circle construction
User SHALL be able to construct a 2D circle by specifying center (x, y) and radius. The system SHALL use OCCT Geom2d_Circle. A non-positive radius SHALL return nil.

#### Scenario: Construct a 2D circle
- **WHEN** user calls `(make-circle2d 5.0 5.0 10.0)`
- **THEN** system returns a 2D circle curve centered at (5,5) with radius 10

#### Scenario: Construct a 2D circle with zero radius
- **WHEN** user calls `(make-circle2d 0.0 0.0 0.0)`
- **THEN** system returns nil

### Requirement: Memory management for 2D curves
Each 2D curve MUST be a distinct CLOS instance managed by `tg:finalize` for automatic garbage collection.

#### Scenario: Distinct curve objects
- **WHEN** user calls `(make-circle2d 0 0 5)` twice
- **THEN** the two return values are not `eq`
