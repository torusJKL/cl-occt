## ADDED Requirements

### Requirement: User can explicitly mesh a shape
User SHALL be able to invoke `BRepMesh_IncrementalMesh` on a shape with configurable deflection, angle, and relative mode parameters. The system SHALL wrap `BRepMesh_IncrementalMesh` providing controlled tessellation. Default deflection SHALL be 0.1. Default angle SHALL be 0.5 radians. Relative mode SHALL default to false.

#### Scenario: Mesh a box with default parameters
- **WHEN** user calls `(mesh-shape (make-box 10 20 30))`
- **THEN** the shape is triangulated with BRepMesh and the function returns the shape

#### Scenario: Mesh with custom deflection
- **WHEN** user calls `(mesh-shape (make-box 10 20 30) :deflection 0.01)`
- **THEN** the shape is triangulated with a finer mesh than default

#### Scenario: Mesh with custom angle
- **WHEN** user calls `(mesh-shape (make-sphere 10) :angle 0.1)`
- **THEN** the shape is triangulated with angular deviation 0.1 radians

#### Scenario: Mesh with relative mode
- **WHEN** user calls `(mesh-shape (make-box 10 20 30) :relative t)`
- **THEN** the shape is triangulated with relative deflection mode enabled

#### Scenario: Mesh nil shape
- **WHEN** user calls `(mesh-shape nil)`
- **THEN** system returns nil

### Requirement: Mesh shape returns shape for chaining
The `mesh-shape` function SHALL return the input shape to enable chaining with I/O functions.

#### Scenario: Chain mesh with STL export
- **WHEN** user calls `(write-stl (mesh-shape (make-box 10 20 30) :deflection 0.05) "box.stl")`
- **THEN** file "box.stl" is written with the meshed shape
