## ADDED Requirements

### Requirement: Create AIS_Animation instance
The system SHALL create an `AIS_Animation` instance with a given name string. The animation SHALL be wrapped in a `Handle(AIS_Animation)*` and returned as an `ais-animation` CLOS instance.

#### Scenario: Create named animation
- **WHEN** user calls `(make-animation "my-anim")`
- **THEN** system returns an `ais-animation` instance with non-null internal handle

#### Scenario: Create animation with empty name
- **WHEN** user calls `(make-animation "")`
- **THEN** system returns an `ais-animation` instance with non-null internal handle

#### Scenario: Create animation with nil name
- **WHEN** user calls `(make-animation nil)`
- **THEN** system returns nil

### Requirement: Start and stop animation
The system SHALL provide functions to start and stop an `AIS_Animation` timer.

#### Scenario: Start animation
- **WHEN** user calls `(ais-animation-start anim)`
- **THEN** the animation timer begins advancing

#### Scenario: Stop animation
- **WHEN** user calls `(ais-animation-stop anim)` on a running animation
- **THEN** the animation timer stops

#### Scenario: Start on nil
- **WHEN** user calls `(ais-animation-start nil)`
- **THEN** no error occurs

### Requirement: Check if animation is playing
The system SHALL report whether an animation's timer is currently running.

#### Scenario: Playing after start
- **WHEN** user calls `(ais-animation-playing-p anim)` after `(ais-animation-start anim)`
- **THEN** system returns `t`

#### Scenario: Not playing after stop
- **WHEN** user calls `(ais-animation-playing-p anim)` after `(ais-animation-stop anim)`
- **THEN** system returns `nil`

#### Scenario: Playing on nil
- **WHEN** user calls `(ais-animation-playing-p nil)`
- **THEN** system returns `nil`

### Requirement: Set and get animation duration
The system SHALL allow setting and querying the animation duration in seconds.

#### Scenario: Set duration
- **WHEN** user calls `(setf (ais-animation-duration anim) 5.0)`
- **THEN** the animation duration is set to 5.0 seconds

#### Scenario: Get duration
- **WHEN** user calls `(ais-animation-duration anim)`
- **THEN** system returns the current duration as a double-float

#### Scenario: Duration on nil
- **WHEN** user calls `(ais-animation-duration nil)`
- **THEN** system returns nil

### Requirement: Set and get animation progress
The system SHALL allow setting and querying the current progress as a fraction [0, 1].

#### Scenario: Set progress
- **WHEN** user calls `(setf (ais-animation-progress anim) 0.5)`
- **THEN** the animation progress advances to the midpoint

#### Scenario: Get progress
- **WHEN** user calls `(ais-animation-progress anim)` after setting to 0.5
- **THEN** system returns approximately 0.5

#### Scenario: Progress on nil
- **WHEN** user calls `(ais-animation-progress nil)`
- **THEN** system returns nil

### Requirement: Set start pause for delayed animation
The system SHALL support a start pause duration, delaying animation start by the specified time.

#### Scenario: Set start pause
- **WHEN** user calls `(setf (ais-animation-start-pause anim) 2.0)`
- **THEN** the animation waits 2 seconds before advancing after start

### Requirement: Manage animation children
The system SHALL support hierarchical animation trees by adding and removing child animations.

#### Scenario: Add child animation
- **WHEN** user calls `(add-animation parent child)`
- **THEN** the child animation is registered as a sub-animation of parent

#### Scenario: Remove child animation
- **WHEN** user calls `(remove-animation parent child)` after adding
- **THEN** the child animation is detached from parent

#### Scenario: Add nil child
- **WHEN** user calls `(add-animation parent nil)`
- **THEN** no error occurs

### Requirement: Free ais-animation
The system SHALL provide explicit `ais-animation-free` to delete the C `Handle<>*` immediately. The system SHALL also provide `tg:finalize` as a GC safety net.

#### Scenario: Free ais-animation
- **WHEN** user calls `(ais-animation-free anim)`
- **THEN** the C handle is released

#### Scenario: Double-free safety
- **WHEN** user calls `(ais-animation-free anim)` twice
- **THEN** no crash occurs on the second call

#### Scenario: Free nil
- **WHEN** user calls `(ais-animation-free nil)`
- **THEN** no error occurs
