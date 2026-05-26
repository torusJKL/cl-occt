## ADDED Requirements

### Requirement: Create AIS_AnimationAxisRotation
The system SHALL create an `AIS_AnimationAxisRotation` that animates an ais-object's rotation around an arbitrary axis by a target angle.

#### Scenario: Create animation axis rotation
- **WHEN** user calls `(make-animation-axis-rotation "rot-anim" ais-obj origin direction angle)`
- **THEN** system returns an `ais-animation-axis-rotation` instance with non-null internal handle

#### Scenario: Create with nil ais-object
- **WHEN** user calls `(make-animation-axis-rotation "rot-anim" nil '(0 0 0) '(0 0 1) 90)`
- **THEN** system returns nil

#### Scenario: Create with zero angle
- **WHEN** user calls `(make-animation-axis-rotation "rot-anim" ais-obj '(0 0 0) '(0 0 1) 0)`
- **THEN** system returns an `ais-animation-axis-rotation` instance

### Requirement: Get rotation parameters
The system SHALL provide accessors for the axis, origin, and target angle of the rotation animation.

#### Scenario: Get axis
- **WHEN** user calls `(animation-rotation-axis rot-anim)`
- **THEN** system returns the axis direction as `(dx dy dz)`

#### Scenario: Get origin
- **WHEN** user calls `(animation-rotation-origin rot-anim)`
- **THEN** system returns the origin point as `(ox oy oz)`

#### Scenario: Get angle
- **WHEN** user calls `(animation-rotation-angle rot-anim)`
- **THEN** system returns the target angle in degrees

### Requirement: Animation-axis-rotation predicate
The system SHALL provide a predicate to distinguish animation-axis-rotation instances.

#### Scenario: Predicate returns t
- **WHEN** user calls `(ais-animation-axis-rotation-p anim)`
- **THEN** system returns `t` for `ais-animation-axis-rotation` instances

#### Scenario: Predicate returns nil for base class
- **WHEN** user calls `(ais-animation-axis-rotation-p (make-animation "base"))`
- **THEN** system returns `nil`

### Requirement: Free ais-animation-axis-rotation
The system SHALL free an `ais-animation-axis-rotation` via `ais-animation-free` (inherited from base class) with GC safety.

#### Scenario: Free animation axis rotation
- **WHEN** user calls `(ais-animation-free rot-anim)`
- **THEN** the C handle is released
