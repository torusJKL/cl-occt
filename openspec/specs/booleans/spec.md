## ADDED Requirements

### Requirement: Boolean cut (subtraction)
User SHALL be able to subtract shape B from shape A. The system SHALL use OCCT BRepAlgoAPI_Cut. If the operation is not possible (invalid input), the system SHALL return nil.

#### Scenario: Cut two boxes
- **WHEN** user calls `(cut (make-box 10 20 30) (make-box 5 5 5))`
- **THEN** system returns a shape representing box A with box B removed from it

#### Scenario: Cut nil shape
- **WHEN** user calls `(cut nil (make-box 5 5 5))`
- **THEN** system returns nil

### Requirement: Boolean fuse (union)
User SHALL be able to union shape A and shape B. The system SHALL use OCCT BRepAlgoAPI_Fuse.

#### Scenario: Fuse two overlapping boxes
- **WHEN** user calls `(fuse (make-box 10 10 10) (translate (make-box 10 10 10) 5 0 0))`
- **THEN** system returns a shape representing the union of both boxes

### Requirement: Boolean common (intersection)
User SHALL be able to intersect shape A and shape B. The system SHALL use OCCT BRepAlgoAPI_Common. If shapes do not intersect, the system SHALL return nil.

#### Scenario: Intersect overlapping shapes
- **WHEN** user calls `(common (make-box 10 10 10) (translate (make-box 10 10 10) 5 5 5))`
- **THEN** system returns a shape representing the intersection volume

#### Scenario: Intersect non-overlapping shapes
- **WHEN** user calls `(common (make-box 10 10 10) (translate (make-box 10 10 10) 100 100 100))`
- **THEN** system returns nil

### Requirement: Variadic boolean operations
Boolean operations MUST accept two or more arguments, chaining left-to-right.

#### Scenario: Fuse three shapes
- **WHEN** user calls `(fuse a b c)`
- **THEN** result is equivalent to `(fuse (fuse a b) c)`

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
