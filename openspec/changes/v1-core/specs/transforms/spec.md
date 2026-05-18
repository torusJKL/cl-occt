## ADDED Requirements

### Requirement: Translate shape
User SHALL be able to move a shape by a displacement vector (x, y, z). The system SHALL return a new shape; the original SHALL remain unchanged.

#### Scenario: Translate a box
- **WHEN** user calls `(translate (make-box 10 10 10) 5 0 0)`
- **THEN** system returns a shape representing the box offset by 5 units on the x-axis

#### Scenario: Translate preserves original
- **WHEN** user calls `(let ((a (make-box 10 10 10))) (translate a 5 0 0) a)`
- **THEN** the final value is the original un-translated box

### Requirement: Rotate shape
User SHALL be able to rotate a shape around an arbitrary axis (ax, ay, az) by an angle in degrees.

#### Scenario: Rotate around Z axis
- **WHEN** user calls `(rotate (make-box 10 10 10) 0 0 1 45)`
- **THEN** system returns a shape representing the box rotated 45 degrees around the Z axis

### Requirement: Transform nil
Transforming a nil shape SHALL return nil.

#### Scenario: Translate nil
- **WHEN** user calls `(translate nil 5 0 0)`
- **THEN** system returns nil
