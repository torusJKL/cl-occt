## ADDED Requirements

### Requirement: Write shape to BREP file
The system SHALL write any shape to a `.brep` file via `BRepTools::Write`.

#### Scenario: Box written and read back matches
- **WHEN** a 10x20x30 box is written to a .brep file and read back
- **THEN** the read shape SHALL have the same volume and face count

#### Scenario: Write failure returns nil
- **WHEN** writing to an invalid path
- **THEN** the result SHALL be nil

### Requirement: Read shape from BREP file
The system SHALL read any shape from a `.brep` file via `BRepTools::Read`.

#### Scenario: Null path returns nil
- **WHEN** reading from a null or empty path
- **THEN** the result SHALL be nil

#### Scenario: Non-existent file returns nil
- **WHEN** reading from a non-existent file
- **THEN** the result SHALL be nil
