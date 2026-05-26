## ADDED Requirements

### Requirement: Create wedge primitive
The system SHALL create a wedge (tapered box) shape via `BRepPrimAPI_MakeWedge`.

#### Scenario: Full wedge
- **WHEN** a wedge with dimensions (dx=10, dy=20, dz=30, ltx=5) is created
- **THEN** the result SHALL be a valid solid with 6 faces

#### Scenario: Corner wedge
- **WHEN** a wedge with arguments (dx, dy, dz, xmin, zmin, xmax, zmax) is created
- **THEN** the result SHALL be a valid solid

#### Scenario: Invalid dimensions return nil
- **WHEN** a wedge with zero or negative dimensions
- **THEN** the result SHALL be nil
