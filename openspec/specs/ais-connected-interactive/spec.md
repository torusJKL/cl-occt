## ADDED Requirements

### Requirement: Create connected interactive object
The system SHALL provide a constructor `make-connected-interactive` that creates an `AIS_ConnectedInteractive` — a shared reference to another interactive object's geometry.

#### Scenario: Create connected interactive from an existing AIS object
- **WHEN** the user calls `(make-connected-interactive source-ais-obj)`
- **THEN** the system returns a new `ais-object` that shares the source's geometry

#### Scenario: Create connected interactive from nil returns nil
- **WHEN** the user calls `(make-connected-interactive nil)`
- **THEN** the system returns `nil`

#### Scenario: Display both original and connected copy
- **WHEN** the user displays both the original AIS object and its connected copy
- **THEN** both are visible in the viewer, and changes to the source's geometry are reflected in the copy
