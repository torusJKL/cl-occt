## MODIFIED Requirements

### Requirement: Shell / Thicken (Hollow)

The system SHALL provide a function to create thin-walled shells by removing faces from a solid using `BRepOffsetAPI_MakeThickSolid`.

#### Scenario: Shell a box by removing one face
- **WHEN** a user creates a box and calls `shell-shape` with one face and a thickness
- **THEN** the system returns a hollowed shell shape

#### Scenario: Shell with nil shape
- **WHEN** a user calls `shell-shape` with nil
- **THEN** the system returns nil

#### Scenario: Shell with outward offset
- **WHEN** a user calls `shell-shape` with `:offset :outward`
- **THEN** the system creates the shell by adding material outward

#### Scenario: Shell with excessive thickness
- **WHEN** a user calls `shell-shape` with thickness exceeding shape dimensions
- **THEN** the system returns nil
