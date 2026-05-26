## ADDED Requirements

### Requirement: Create and free clip plane
The system SHALL create a `Graphic3d_ClipPlane` with a default plane equation (X=0), and free it. This is a handle-based type with `tg:finalize` GC.

#### Scenario: Create clip plane
- **WHEN** user calls `(make-clip-plane)`
- **THEN** returns a `clip-plane` instance with non-null internal handle
- **WHEN** user calls `(make-clip-plane :equation '(1 0 0 -5))`
- **THEN** returns a clip plane with equation X=5

#### Scenario: Free clip plane
- **WHEN** user calls `(free-clip-plane cp)`
- **THEN** the internal C handle is freed

#### Scenario: Double-free safety
- **WHEN** user calls `(free-clip-plane cp)` twice
- **THEN** the second call does not crash

### Requirement: Set/get plane equation
The system SHALL get and set the clip plane equation as a 4-element list `(A B C D)`.

#### Scenario: Set equation
- **WHEN** user calls `(set-clip-plane-equation cp '(1 0 0 0))`
- **THEN** the plane equation is set to X=0

#### Scenario: Get equation
- **WHEN** user calls `(clip-plane-equation cp)`
- **THEN** returns `(A B C D)` as a list of double-floats

### Requirement: Enable/disable clip plane
The system SHALL toggle whether the clip plane is active.

#### Scenario: Enable
- **WHEN** user calls `(set-clip-plane-on cp t)`
- **THEN** the clip plane is active

#### Scenario: Disable
- **WHEN** user calls `(set-clip-plane-on cp nil)`
- **THEN** the clip plane is inactive

#### Scenario: Query on state
- **WHEN** user calls `(clip-plane-on-p cp)`
- **THEN** returns `t` if active, `nil` otherwise

### Requirement: Set capping properties
The system SHALL configure whether the clip plane caps the clipped geometry, and set the cap color and material.

#### Scenario: Toggle capping
- **WHEN** user calls `(set-clip-plane-capping cp t)`
- **THEN** capping is enabled on the clip plane

#### Scenario: Set cap color
- **WHEN** user calls `(set-clip-plane-cap-color cp '(0.5 0.5 0.5))`
- **THEN** the cap surface uses that color

### Requirement: Predicate and type checking
The system SHALL provide a predicate for `clip-plane` instances.

#### Scenario: clip-plane-p
- **WHEN** user calls `(clip-plane-p (make-clip-plane))`
- **THEN** returns `t`
- **WHEN** user calls `(clip-plane-p nil)` or `(clip-plane-p :not-a-plane)`
- **THEN** returns `nil`
