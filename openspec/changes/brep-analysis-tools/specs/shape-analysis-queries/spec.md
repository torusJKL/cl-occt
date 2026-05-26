## ADDED Requirements

### Requirement: Shape proximity detection
The system SHALL detect proximity zones between two shapes within a given tolerance using `BRepExtrema_ShapeProximity`.

#### Scenario: Proximity between two near boxes
- **WHEN** user calls `(shape-proximity box1 box2 tolerance)`
- **THEN** returns a list of proximity zones, each containing the distance and involved subshapes

#### Scenario: Touching shapes
- **WHEN** user calls `(shape-proximity touching-box1 touching-box2 0.1)`
- **THEN** returns proximity zones at the contact region

#### Scenario: Well-separated shapes
- **WHEN** user calls `(shape-proximity far-box1 far-box2 0.1)`
- **THEN** returns nil (no proximity within tolerance)

### Requirement: Overlap detection
The system SHALL detect overlapping regions between two shapes using `BRepExtrema_OverlapTool`.

#### Scenario: Overlapping boxes
- **WHEN** user calls `(shape-overlap-p box1 overlapping-box2)`
- **THEN** returns t if shapes overlap

#### Scenario: Non-overlapping boxes
- **WHEN** user calls `(shape-overlap-p box1 far-box2)`
- **THEN** returns nil

#### Scenario: Detailed overlap result
- **WHEN** user calls `(shape-overlap box1 box2)`
- **THEN** returns the overlapping subshapes or nil

### Requirement: Self-intersection detection
The system SHALL detect self-intersections within a single shape using `BRepExtrema_SelfIntersection`.

#### Scenario: Valid shape has no self-intersection
- **WHEN** user calls `(shape-self-intersect-p (make-box 10 20 30))`
- **THEN** returns nil

#### Scenario: Self-intersecting shape
- **WHEN** user calls `(shape-self-intersect-p folded-shape)`
- **THEN** returns a list of self-intersection locations

### Requirement: Face-to-face distance extrema
The system SHALL compute minimum and maximum distance between two specific faces.

#### Scenario: Distance between parallel faces
- **WHEN** user calls `(face-distance face1 face2)`
- **THEN** returns the minimum distance between the two faces
