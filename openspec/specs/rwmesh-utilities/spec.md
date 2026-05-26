## ADDED Requirements

### Requirement: User can specify coordinate system for mesh I/O
The system SHALL expose `RWMesh_CoordinateSystem` enum values as keywords for use in mesh I/O functions. Supported systems SHALL include `:zup` (Z-up, default for glTF), `:yup` (Y-up, default for OBJ), and others as supported by OCCT.

#### Scenario: Coordinate system keywords resolve to correct int
- **WHEN** user passes `:zup` to a mesh I/O function
- **THEN** the C wrapper receives the correct `RWMesh_CoordinateSystem` enum value

#### Scenario: Default coordinate system
- **WHEN** user calls a mesh I/O function without specifying coordinate system
- **THEN** the system uses the OCCT default (Z-up)

### Requirement: User can specify name format for mesh I/O
The system SHALL expose `RWMesh_NameFormat` enum values as keywords. Supported formats SHALL include `:auto`, `:short`, and others as defined by OCCT.

#### Scenario: Name format keywords resolve to correct int
- **WHEN** user passes `:auto` to a mesh I/O function
- **THEN** the C wrapper receives the correct `RWMesh_NameFormat` enum value
