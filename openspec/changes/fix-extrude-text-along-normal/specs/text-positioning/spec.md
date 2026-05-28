## ADDED Requirements

### Requirement: Extruded text extrusion direction follows normal
The `make-text-shape-3d` function SHALL extrude text perpendicular to the specified plane. When `:normal` is provided, the extrusion vector SHALL be parallel to the normal direction. The extrusion depth SHALL be the magnitude of the extrusion vector.

#### Scenario: Verify extrusion direction on rotated plane
- **WHEN** user creates extruded text with `(make-text-shape-3d <font> "Deep" 3.0 :position '(0 0 0) :normal '(0 1 0))` and checks `(shape-extent-along <shape> 0 1 0)` and `(shape-extent-along <shape> 0 0 1)`
- **THEN** `shape-extent-along` along Y returns a max value ≈ 3.0 and along Z returns a max value ≈ 0.0
