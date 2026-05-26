## MODIFIED Requirements

### Requirement: Export STL with configurable deflection
Previously the `write-stl` function accepted only a `:deflection` keyword. The system SHALL now also accept `:angle` (angular deviation in radians) and `:relative` (boolean for relative deflection) keyword arguments. When not provided, these SHALL default to the existing `BRepMesh_IncrementalMesh` defaults (angle=0.5, relative=false).

#### Scenario: Export with custom angle
- **WHEN** user calls `(write-stl (make-box 10 20 30) "box.stl" :deflection 0.1 :angle 0.2)`
- **THEN** file "box.stl" uses angular deviation of 0.2 radians

#### Scenario: Export with relative deflection
- **WHEN** user calls `(write-stl (make-box 10 20 30) "box.stl" :relative t)`
- **THEN** file "box.stl" uses relative deflection mode

#### Scenario: Backward compatibility
- **WHEN** user calls `(write-stl (make-box 10 20 30) "box.stl" :deflection 0.1)`
- **THEN** behavior is unchanged from previous versions
