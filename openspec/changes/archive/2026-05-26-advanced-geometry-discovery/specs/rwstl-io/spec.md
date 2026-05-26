## ADDED Requirements

### Requirement: Read STL with RWStl
The system SHALL read an STL file and return a triangulation via `RWStl::ReadFile`.

#### Scenario: Valid STL file returns triangulation
- **WHEN** a valid binary or ASCII STL file is read
- **THEN** the result SHALL be a non-nil triangulation with vertices and triangles

### Requirement: Write STL with RWStl
The system SHALL write a triangulation to an STL file via `RWStl::WriteFile`.

#### Scenario: Triangulation written to STL
- **WHEN** a triangulation is written to an STL file
- **THEN** the file SHALL be a valid STL that can be read back

#### Scenario: Null input returns nil
- **WHEN** a null file path is provided
- **THEN** the result SHALL be nil
