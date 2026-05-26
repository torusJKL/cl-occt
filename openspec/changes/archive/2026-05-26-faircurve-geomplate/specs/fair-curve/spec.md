## ADDED Requirements

### Requirement: FairCurve Batten (physical spline)
The system SHALL create a curve that minimizes strain energy through a set of constraint points using `FairCurve_Batten`.

#### Scenario: Batten through three points
- **WHEN** user calls `(fair-curve-batten '((0 0 0) (5 5 0) (10 0 0)))`
- **THEN** returns a curve passing through all three points with minimum strain energy

#### Scenario: Batten with free ends
- **WHEN** user calls `(fair-curve-batten points :free-end t :free-slide t)`
- **THEN** returns a curve with free boundary conditions at both ends

#### Scenario: Batten with tangency constraints
- **WHEN** user calls `(fair-curve-batten points :initial-tangent '(1 0 0) :final-tangent '(-1 0 0))`
- **THEN** returns a curve with specified start and end tangents

### Requirement: FairCurve Minimal Variation
The system SHALL create a curve that minimizes curvature variation using `FairCurve_MinimalVariation`.

#### Scenario: Minimal variation curve
- **WHEN** user calls `(fair-curve-minvar points)`
- **THEN** returns a curve with minimal curvature variation through the points

#### Scenario: With slope constraints
- **WHEN** user calls `(fair-curve-minvar points :initial-slope '(1 0 0) :final-slope '(1 0 0))`
- **THEN** returns a curve with specified endpoint slopes
