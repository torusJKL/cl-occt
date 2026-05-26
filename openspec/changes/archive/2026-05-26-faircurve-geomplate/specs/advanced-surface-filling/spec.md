## ADDED Requirements

### Requirement: Surface filling from boundary curves
The system SHALL fill a surface bounded by multiple curves with continuity constraints using `GeomPlate_BuildAveragePlate` and `GeomPlate_CurveConstraint`.

#### Scenario: Fill from 4 boundary curves
- **WHEN** user calls `(fill-surface-from-curves (list curve1 curve2 curve3 curve4))`
- **THEN** returns a surface filling the region bounded by the curves

#### Scenario: Fill with G1 continuity
- **WHEN** user calls `(fill-surface-from-curves curves :continuity :g1)`
- **THEN** returns a surface with tangent continuity at the boundaries

#### Scenario: Fill with supporting faces
- **WHEN** user calls `(fill-surface-from-curves curves :support-faces face-list :continuity :g1)`
- **THEN** returns a surface that maintains continuity with adjacent faces

#### Scenario: Fewer than 3 curves returns nil
- **WHEN** user calls `(fill-surface-from-curves (list curve1 curve2))`
- **THEN** returns nil
