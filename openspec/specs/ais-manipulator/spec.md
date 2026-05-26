## ADDED Requirements

### Requirement: Create manipulator gizmo
The system SHALL provide a constructor `make-manipulator` that creates an `AIS_Manipulator` interactive gizmo for translating, rotating, and scaling objects.

#### Scenario: Create a manipulator
- **WHEN** the user calls `(make-manipulator)`
- **THEN** the system returns an `ais-object` instance with a non-null C handle

#### Scenario: Set manipulator position
- **WHEN** the user calls `(set-manipulator-position manip x y z)`
- **THEN** the manipulator gizmo is positioned at the given world coordinates

#### Scenario: Set manipulator size
- **WHEN** the user calls `(set-manipulator-size manip size)`
- **THEN** the manipulator gizmo is displayed with the given size

#### Scenario: Attach manipulator to shape
- **WHEN** the user calls `(attach-manipulator manip shape)`
- **THEN** the manipulator is attached to the shape and follows its transformations

#### Scenario: Enable/disable manipulator axes
- **WHEN** the user calls `(set-manipulator-active-axes manip &key translate rotate scale)`
- **THEN** only the enabled axes modes are shown on the gizmo
