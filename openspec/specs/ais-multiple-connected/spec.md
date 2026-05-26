## ADDED Requirements

### Requirement: Create multiple connected interactive object
The system SHALL provide a constructor `make-multiple-connected` that creates an `AIS_MultipleConnectedInteractive` — a compound of connected/delegated interactive objects.

#### Scenario: Create from list of AIS objects
- **WHEN** the user calls `(make-multiple-connected list-of-ais-objs)`
- **THEN** the system returns an `ais-object` that composites all source objects

#### Scenario: Create from nil returns nil
- **WHEN** the user calls `(make-multiple-connected nil)`
- **THEN** the system returns `nil`

#### Scenario: Connect additional object
- **WHEN** the user calls `(connect-to-multiple obj-to-add)`
- **THEN** the multiple-connected object gains the geometry of the added object

#### Scenario: Display multiple connected
- **WHEN** the user displays a multiple-connected object
- **THEN** all referenced sub-objects are visible in the viewer
