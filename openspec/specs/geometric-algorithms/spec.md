## ADDED Requirements

### Requirement: Project point onto curve
The system SHALL project a 3D point onto a 3D curve using `GeomAPI_ProjectPointOnCurve`, returning the projected point and parameter.

#### Scenario: Project point onto line
- **WHEN** user calls `(project-point-on-curve (make-pnt 5 5 5) line-curve)`
- **THEN** returns the nearest point on the curve as a `(point distance parameter)` values

#### Scenario: Project point with no valid projection
- **WHEN** user calls `(project-point-on-curve point curve)` and the point is equidistant
- **THEN** returns the nearest solution or nil

### Requirement: Project point onto surface
The system SHALL project a 3D point onto a 3D surface using `GeomAPI_ProjectPointOnSurf`, returning the projected point and UV parameters.

#### Scenario: Project point onto plane
- **WHEN** user calls `(project-point-on-surface (make-pnt 5 5 5) plane-surface)`
- **THEN** returns the nearest point as `(point u v distance)`

### Requirement: Intersection of two 3D curves
The system SHALL compute intersection points between two 3D curves using `GeomAPI_IntCurveCurve`.

#### Scenario: Intersect two lines
- **WHEN** user calls `(intersect-curves line1 line2)`
- **THEN** returns a list of intersection points

#### Scenario: No intersection
- **WHEN** user calls `(intersect-curves parallel-lines)`
- **THEN** returns nil

### Requirement: Intersection of curve and surface
The system SHALL compute intersection points between a 3D curve and a surface using `GeomAPI_IntCurveSurface`.

#### Scenario: Intersect line with plane
- **WHEN** user calls `(intersect-curve-surface line plane)`
- **THEN** returns a list of intersection points

### Requirement: Intersection of two surfaces
The system SHALL compute the intersection curves between two surfaces using `GeomAPI_IntSS`.

#### Scenario: Intersect two planes
- **WHEN** user calls `(intersect-surfaces plane1 plane2)`
- **THEN** returns a list of intersection curves (as `curve` instances)

### Requirement: Minimum distance between two curves
The system SHALL compute the minimum and maximum distance between two 3D curves using `GeomAPI_ExtremaCurveCurve`.

#### Scenario: Min distance between two lines
- **WHEN** user calls `(extrema-curve-curve line1 line2)`
- **THEN** returns the minimum distance and the closest points on each curve

### Requirement: Minimum distance between curve and surface
The system SHALL compute the minimum distance between a 3D curve and a surface using `GeomAPI_ExtremaCurveSurface`.

#### Scenario: Min distance from curve to plane
- **WHEN** user calls `(extrema-curve-surface curve plane)`
- **THEN** returns the minimum distance and the closest point

### Requirement: Intersection of two 2D curves
The system SHALL compute intersection points between two 2D curves using `Geom2dAPI_InterCurveCurve`.

#### Scenario: Intersect two 2D lines
- **WHEN** user calls `(intersect-curves-2d line2d-1 line2d-2)`
- **THEN** returns a list of 2D intersection points

### Requirement: Project point onto 2D curve
The system SHALL project a 2D point onto a 2D curve using `Geom2dAPI_ProjectPointOnCurve`.

#### Scenario: Project 2D point onto 2D line
- **WHEN** user calls `(project-point-on-curve-2d (make-pnt2d 5 5) line2d)`
- **THEN** returns the nearest point and parameter

### Requirement: Approximate points with BSpline curve
The system SHALL approximate a set of 3D points with a BSpline curve using `GeomAPI_PointsToBSpline`.

#### Scenario: Fit BSpline through 4 points
- **WHEN** user calls `(points-to-bspline '((0 0 0) (1 2 3) (4 5 6) (7 8 9)))`
- **THEN** returns a `curve` instance of type `:bspline-curve` passing near the points

#### Scenario: Fit with degree constraint
- **WHEN** user calls `(points-to-bspline points :degree 3)`
- **THEN** returns a cubic BSpline approximation

### Requirement: Interpolate points with BSpline curve
The system SHALL interpolate a set of 3D points with a BSpline curve passing exactly through them using `GeomAPI_Interpolate`.

#### Scenario: Interpolate 4 points
- **WHEN** user calls `(interpolate-points '((0 0 0) (1 2 3) (4 5 6) (7 8 9)))`
- **THEN** returns a `curve` instance of type `:bspline-curve` passing exactly through all points

#### Scenario: Interpolate with tangents at endpoints
- **WHEN** user calls `(interpolate-points points :initial-tangent '(1 0 0) :final-tangent '(0 1 0))`
- **THEN** returns an interpolated BSpline with specified endpoint tangents
