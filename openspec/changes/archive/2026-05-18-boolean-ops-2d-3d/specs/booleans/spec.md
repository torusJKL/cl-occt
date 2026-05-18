## ADDED Requirements

### Requirement: 2D boolean operations
Existing `cut`, `fuse`, and `common` SHALL accept planar faces as 2D region operands. The system SHALL use the same OCCT `BRepAlgoAPI_Cut`, `BRepAlgoAPI_Fuse`, and `BRepAlgoAPI_Common` algorithms. No behavior change to existing 3D operation.

#### Scenario: Face cut
- **WHEN** user calls `(cut (make-face wire) (make-face wire))`
- **THEN** system returns a shape representing the 2D boolean difference

#### Scenario: Face fuse
- **WHEN** user calls `(fuse (make-face wire) (make-face wire))`
- **THEN** system returns a shape representing the 2D boolean union

#### Scenario: Face common
- **WHEN** user calls `(common (make-face wire) (make-face wire))`
- **THEN** system returns a shape representing the 2D boolean intersection

### Requirement: Boolean section (intersection curves)
The system SHALL provide a `section` function wrapping OCCT `BRepAlgoAPI_Section` that computes intersection curves/edges between two shapes.

#### Scenario: Section two solids
- **WHEN** user calls `(section shape-a shape-b)`
- **THEN** system returns a shape containing intersection edges

#### Scenario: Section nil
- **WHEN** user calls `(section nil shape)`
- **THEN** system returns nil
