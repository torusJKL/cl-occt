## ADDED Requirements

### Requirement: Distance between two shapes
The system SHALL compute the minimum distance between two shapes using `BRepExtrema_DistShapeShape`.

#### Scenario: Distance between two boxes
- **WHEN** user calls `(shape-distance box1 box2)`
- **THEN** returns the minimum distance as a double

#### Scenario: Distance with touching shapes
- **WHEN** user calls `(shape-distance touching-boxes)`
- **THEN** returns 0.0

#### Scenario: Distance returns solution points
- **WHEN** user calls `(shape-distance-extrema shape1 shape2)`
- **THEN** returns the minimum distance and the closest point on each shape

#### Scenario: Nil shape returns nil
- **WHEN** user calls `(shape-distance nil valid-shape)`
- **THEN** returns nil

### Requirement: Point-in-solid classification
The system SHALL classify whether a 3D point lies inside, outside, or on the surface of a solid using `BRepClass3d_SolidClassifier`.

#### Scenario: Point inside a box
- **WHEN** user calls `(point-in-solid-p (make-pnt 5 10 15) (make-box 10 20 30))`
- **THEN** returns `:inside`

#### Scenario: Point outside a box
- **WHEN** user calls `(point-in-solid-p (make-pnt 100 100 100) (make-box 10 20 30))`
- **THEN** returns `:outside`

#### Scenario: Point on surface of a box
- **WHEN** user calls `(point-in-solid-p (make-pnt 0 10 15) (make-box 10 20 30))`
- **THEN** returns `:on`

#### Scenario: Classify returns state and face
- **WHEN** user calls `(classify-point-in-solid point shape)`
- **THEN** returns `(:inside nil)` or `(:on face)` with the face if on surface

### Requirement: Shape validity checking
The system SHALL check a shape's topological validity using `BRepCheck_Analyzer`.

#### Scenario: Valid box is valid
- **WHEN** user calls `(shape-valid-p (make-box 10 20 30))`
- **THEN** returns t

#### Scenario: Invalid shape returns nil
- **WHEN** user calls `(shape-valid-p degraded-shape)`
- **THEN** returns nil

#### Scenario: Detailed validity report
- **WHEN** user calls `(shape-check shape)`
- **THEN** returns a list of validity issues, nil if valid

### Requirement: Curve-surface intersection on BRep shape
The system SHALL intersect a 3D curve with a BRep shape (finding hit faces, points, and parameters) using `BRepIntCurveSurface_Inter`.

#### Scenario: Intersect line with box
- **WHEN** user calls `(intersect-curve-shape line box)`
- **THEN** returns a list of intersection results, each containing (point face u v parameter)

#### Scenario: No intersection
- **WHEN** user calls `(intersect-curve-shape non-intersecting-line box)`
- **THEN** returns nil
