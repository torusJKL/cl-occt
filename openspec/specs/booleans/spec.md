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
