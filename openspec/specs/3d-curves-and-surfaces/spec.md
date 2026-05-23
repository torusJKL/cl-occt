## ADDED Requirements

### Requirement: Curve type family with discriminated union
The system SHALL define a `curve` CLOS type backed by an `occt_curve` C opaque struct with a kind tag (analogous to `geom2d`). Supported subtypes SHALL include `line`, `circle`, `ellipse`, `hyperbola`, `parabola`, `bezier-curve`, `bspline-curve`. Each subtype SHALL be constructable via a dedicated C bridge function and queryable via a `curve-type` accessor returning a keyword.

#### Scenario: Construct a 3D line
- **WHEN** user calls `(make-line-3d (make-pnt 0 0 0) (make-dir 0 0 1))`
- **THEN** system returns a `curve` instance of type `:line`

#### Scenario: Construct a 3D circle
- **WHEN** user calls `(make-circle-3d (make-pnt 0 0 0) 10.0)`
- **THEN** system returns a `curve` instance of type `:circle`

#### Scenario: Construct a Bezier curve
- **WHEN** user calls `(make-bezier-curve '((0 0 0) (1 2 3) (4 5 6)))`
- **THEN** system returns a `curve` instance of type `:bezier-curve`

#### Scenario: Construct a BSpline curve
- **WHEN** user calls `(make-bspline-curve poles knots mults degree)`
- **THEN** system returns a `curve` instance of type `:bspline-curve`

#### Scenario: Query curve type
- **WHEN** user calls `(curve-type (make-line-3d ...))`
- **THEN** returns `:line`

#### Scenario: Invalid construction returns nil
- **WHEN** user calls `(make-circle-3d ...)` with zero radius
- **THEN** returns nil

#### Scenario: Curve is finalized with GC
- **WHEN** curve instance becomes unreachable
- **THEN** `tg:finalize` frees the underlying `Handle(Geom_Curve)`

### Requirement: Surface type family with discriminated union
The system SHALL define a `surface` CLOS type backed by an `occt_surface` C opaque struct with a kind tag. Supported subtypes SHALL include `plane`, `cylindrical-surface`, `conical-surface`, `spherical-surface`, `toroidal-surface`, `bezier-surface`, `bspline-surface`. Each subtype SHALL be constructable via a dedicated C bridge function and queryable via a `surface-type` accessor returning a keyword.

#### Scenario: Construct a plane
- **WHEN** user calls `(make-plane (make-pnt 0 0 0) (make-dir 0 0 1))`
- **THEN** system returns a `surface` instance of type `:plane`

#### Scenario: Construct a cylindrical surface
- **WHEN** user calls `(make-cylindrical-surface (make-pnt 0 0 0) (make-dir 0 0 1) 5.0)`
- **THEN** system returns a `surface` instance of type `:cylindrical-surface`

#### Scenario: Construct a spherical surface
- **WHEN** user calls `(make-spherical-surface (make-pnt 0 0 0) 10.0)`
- **THEN** system returns a `surface` instance of type `:spherical-surface`

#### Scenario: Construct a BSpline surface
- **WHEN** user calls `(make-bspline-surface poles uknots vknots umults vmults udeg vdeg)`
- **THEN** system returns a `surface` instance of type `:bspline-surface`

#### Scenario: Query surface type
- **WHEN** user calls `(surface-type (make-plane ...))`
- **THEN** returns `:plane`

### Requirement: GC constructors for curve/surface from geometric constraints
The system SHALL provide GCE2d and GC constructors for creating curves from geometric constraints (e.g., line through two points, circle through three points, arc of circle).

#### Scenario: Make line through two points (GC)
- **WHEN** user calls `(make-gc-line (make-pnt 0 0 0) (make-pnt 10 10 10))`
- **THEN** returns a curve of type `:line`

#### Scenario: Make arc through three points (GC_MakeArcOfCircle)
- **WHEN** user calls `(make-gc-arc-of-circle p1 p2 p3)`
- **THEN** returns a trimmed curve of type `:circle`

### Requirement: NURBS conversion (Convert routines)
The system SHALL provide conversion from elementary curves/surfaces to BSpline (NURBS) representation via the `Convert` package.

#### Scenario: Convert circle to BSpline curve
- **WHEN** user calls `(convert-curve-to-bspline (make-circle-3d ...))`
- **THEN** returns a curve of type `:bspline-curve`

#### Scenario: Convert plane to BSpline surface
- **WHEN** user calls `(convert-surface-to-bspline (make-plane ...))`
- **THEN** returns a surface of type `:bspline-surface`

### Requirement: Bounding boxes for curves and surfaces
The system SHALL compute axis-aligned bounding boxes for curves (`BndLib`) and surfaces (`GeomBndLib`).

#### Scenario: Bounding box of a curve
- **WHEN** user calls `(curve-bounding-box curve)`
- **THEN** returns `(xmin ymin zmin xmax ymax zmax)`

#### Scenario: Bounding box of a surface
- **WHEN** user calls `(surface-bounding-box surface)`
- **THEN** returns `(xmin ymin zmin xmax ymax zmax)`
