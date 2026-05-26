## ADDED Requirements

### Requirement: Sew shapes together
The system SHALL provide a function to stitch adjacent faces/shells into a single watertight shape using `BRepBuilderAPI_Sewing`.

#### Scenario: Sew two adjacent boxes
- **WHEN** a user creates two adjacent boxes and calls `sew-shapes` with a tolerance
- **THEN** the system returns a single sewn shape

#### Scenario: Sew with nil input
- **WHEN** a user calls `sew-shapes` with a nil input
- **THEN** the system returns nil

#### Scenario: Sew with non-manifold option
- **WHEN** a user calls `sew-shapes` with `:allow-non-manifold t`
- **THEN** the system creates a sewn shape allowing non-manifold topology

#### Scenario: Sew shapes with default arguments
- **WHEN** a user calls `sew-shapes` with shapes but no tolerance
- **THEN** the system uses a default tolerance (e.g., 1e-6) and returns a sewn shape
