## ADDED Requirements

### Requirement: 2D boolean cut on planar faces
User SHALL be able to subtract one planar face from another using `cut`. The system SHALL use OCCT `BRepAlgoAPI_Cut`, operating on faces as 2D regions. The result SHALL be a face (or compound of faces) representing region A with region B removed.

#### Scenario: Cut two overlapping planar faces
- **WHEN** user calls `(cut (make-face wire-a) (make-face wire-b))` where the faces are coplanar and overlap
- **THEN** system returns a shape representing face A with face B's region removed

#### Scenario: Cut non-overlapping faces
- **WHEN** user calls `(cut (make-face wire-a) (make-face wire-b))` where the faces are coplanar but do not overlap
- **THEN** system returns the first face unchanged

### Requirement: 2D boolean fuse on planar faces
User SHALL be able to union two planar faces using `fuse`. The system SHALL use OCCT `BRepAlgoAPI_Fuse`. The result SHALL be a face (or compound of faces) representing the union of both regions.

#### Scenario: Fuse two overlapping planar faces
- **WHEN** user calls `(fuse (make-face wire-a) (make-face wire-b))` where the faces are coplanar and overlap
- **THEN** system returns a shape representing the union of both face regions

### Requirement: 2D boolean common on planar faces
User SHALL be able to intersect two planar faces using `common`. The system SHALL use OCCT `BRepAlgoAPI_Common`. If the faces do not overlap, the system SHALL return nil.

#### Scenario: Common two overlapping planar faces
- **WHEN** user calls `(common (make-face wire-a) (make-face wire-b))` where the faces are coplanar and overlap
- **THEN** system returns a shape representing the intersection region

#### Scenario: Common non-overlapping planar faces
- **WHEN** user calls `(common (make-face wire-a) (make-face wire-b))` where the faces are coplanar but do not overlap
- **THEN** system returns nil

### Requirement: 2D boolean nil propagation
2D boolean operations MUST propagate nil: if any argument is nil, the result SHALL be nil.

#### Scenario: 2D cut with nil face
- **WHEN** user calls `(cut nil some-face)`
- **THEN** system returns nil
