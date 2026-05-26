## ADDED Requirements

### Requirement: Create AIS_AnimationCamera
The system SHALL create an `AIS_AnimationCamera` that animates a view's camera between two states over time.

#### Scenario: Create animation camera with viewer reference
- **WHEN** user calls `(make-animation-camera "cam-anim" view start-cam end-cam)`
- **THEN** system returns an `ais-animation-camera` instance with non-null internal handle

#### Scenario: Create with nil view
- **WHEN** user calls `(make-animation-camera "cam-anim" nil start-cam end-cam)`
- **THEN** system returns nil

#### Scenario: Create with nil camera
- **WHEN** user calls `(make-animation-camera "cam-anim" view nil end-cam)`
- **THEN** system returns nil

### Requirement: Get start and end camera
The system SHALL provide access to the start and end `viewer-camera` states of the animation.

#### Scenario: Get start camera
- **WHEN** user calls `(animation-camera-start cam-anim)`
- **THEN** system returns the original start `viewer-camera` value object

#### Scenario: Get end camera
- **WHEN** user calls `(animation-camera-end cam-anim)`
- **THEN** system returns the original end `viewer-camera` value object

#### Scenario: Get start camera on nil
- **WHEN** user calls `(animation-camera-start nil)`
- **THEN** system returns nil

### Requirement: Animation-camera predicate
The system SHALL provide a predicate to distinguish animation-camera instances.

#### Scenario: Predicate returns t
- **WHEN** user calls `(ais-animation-camera-p anim)`
- **THEN** system returns `t` for `ais-animation-camera` instances

#### Scenario: Predicate returns nil for base class
- **WHEN** user calls `(ais-animation-camera-p (make-animation "base"))`
- **THEN** system returns `nil`

### Requirement: Free ais-animation-camera
The system SHALL free an `ais-animation-camera` via `ais-animation-free` (inherited from base class) with GC safety.

#### Scenario: Free animation camera
- **WHEN** user calls `(ais-animation-free cam-anim)`
- **THEN** the C handle is released
