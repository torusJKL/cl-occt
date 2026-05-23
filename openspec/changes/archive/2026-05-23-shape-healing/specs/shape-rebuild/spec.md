## ADDED Requirements

### Requirement: Replace sub-shapes within a shape
The system SHALL substitute a sub-shape (e.g., a face or edge) with a new one using `ShapeBuild_ReShape`.

#### Scenario: Replace a face in a solid
- **WHEN** user calls `(substitute-shape original-shape old-face new-face)`
- **THEN** returns a shape with the face replaced

#### Scenario: Replace multiple sub-shapes
- **WHEN** user calls `(substitute-shape original-shape '((old-face1 new-face1) (old-edge1 new-edge1)))`
- **THEN** returns a shape with all specified sub-shapes replaced

#### Scenario: Replace with nil returns nil
- **WHEN** user calls `(substitute-shape nil old new)`
- **THEN** returns nil

### Requirement: NURBS conversion (ShapeCustom)
The system SHALL convert elementary curves and surfaces to NURBS representation using `ShapeCustom`.

#### Scenario: Convert shape to NURBS
- **WHEN** user calls `(shape-to-nurbs shape)`
- **THEN** returns a shape where all faces use BSpline surfaces

#### Scenario: Degree reduction
- **WHEN** user calls `(shape-reduce-degree shape max-degree)`
- **THEN** returns a shape with surface/curve degrees reduced to at most the given degree

#### Scenario: Convert to rational BSpline
- **WHEN** user calls `(shape-to-rational-bspline shape)`
- **THEN** returns a shape with all surfaces converted to rational BSpline form

### Requirement: Surface splitting and upgrade (ShapeUpgrade)
The system SHALL split faces along U/V isoparams and upgrade surface continuity using `ShapeUpgrade`.

#### Scenario: Split a face along U
- **WHEN** user calls `(shape-split-u shape num-splits)`
- **THEN** returns a shape with faces split along U into the given number of segments

#### Scenario: Upgrade surface continuity
- **WHEN** user calls `(shape-upgrade-continuity shape :continuity :c2)`
- **THEN** returns a shape with surfaces upgraded to C2 continuity
