## ADDED Requirements

### Requirement: Create AIS_AnimationObject
The system SHALL create an `AIS_AnimationObject` that animates an interactive object's local transformation over time. The constructor SHALL take an ais-object and a `gp_Trsf` describing the target transformation.

#### Scenario: Create animation object
- **WHEN** user calls `(make-animation-object "anim-obj" ais-obj trsf)`
- **THEN** system returns an `ais-animation-object` instance with non-null internal handle

#### Scenario: Create with nil ais-object
- **WHEN** user calls `(make-animation-object "anim-obj" nil trsf)`
- **THEN** system returns nil

#### Scenario: Create with nil trsf
- **WHEN** user calls `(make-animation-object "anim-obj" ais-obj nil)`
- **THEN** system returns nil

### Requirement: Get the animated ais-object
The system SHALL provide access to the ais-object being animated.

#### Scenario: Get animated object
- **WHEN** user calls `(animation-object ais-anim-obj)`
- **THEN** system returns the original `ais-object` instance

#### Scenario: Get animated object on nil
- **WHEN** user calls `(animation-object nil)`
- **THEN** system returns nil

### Requirement: Animation-object predicate
The system SHALL provide a predicate to distinguish animation-object instances from the base animation class.

#### Scenario: Predicate returns t
- **WHEN** user calls `(ais-animation-object-p anim)`
- **THEN** system returns `t` for `ais-animation-object` instances

#### Scenario: Predicate returns nil for base class
- **WHEN** user calls `(ais-animation-object-p (make-animation "base"))`
- **THEN** system returns `nil`

### Requirement: Free ais-animation-object
The system SHALL free an `ais-animation-object` via `ais-animation-free` (inherited from base class) with GC safety.

#### Scenario: Free animation object
- **WHEN** user calls `(ais-animation-free obj)`
- **THEN** the C handle is released
