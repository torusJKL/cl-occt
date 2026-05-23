## ADDED Requirements

### Requirement: Compute volume of a solid
The system SHALL compute the volume of a solid shape using `BRepGProp::VolumeProperties`.

#### Scenario: Volume of a box
- **WHEN** user calls `(shape-volume (make-box 10 20 30))`
- **THEN** returns approximately 6000.0

#### Scenario: Volume of invalid shape returns nil
- **WHEN** user calls `(shape-volume nil)`
- **THEN** returns nil

### Requirement: Compute surface area of a shape
The system SHALL compute the surface area of a shape using `BRepGProp::SurfaceProperties`.

#### Scenario: Surface area of a sphere
- **WHEN** user calls `(shape-area (make-sphere 10))`
- **THEN** returns approximately 1256.637

### Requirement: Compute center of mass
The system SHALL compute the center of mass of a solid shape.

#### Scenario: Center of mass of a box
- **WHEN** user calls `(shape-center-of-mass (make-box 10 20 30))`
- **THEN** returns `(5.0 10.0 15.0)`

### Requirement: Compute inertia tensor
The system SHALL compute the inertia tensor (principal moments and axes) of a solid shape.

#### Scenario: Inertia of a box
- **WHEN** user calls `(shape-inertia (make-box 10 20 30))`
- **THEN** returns a `gprops` instance with inertia components accessible via accessors

### Requirement: First-class gprops CLOS class
The system SHALL define a `gprops` CLOS class with slots `%volume`, `%area`, `%center-of-mass`, `%inertia-matrix`, `%principal-moments`, `%principal-axes`.

#### Scenario: gprops from a batch query
- **WHEN** user calls `(shape-gprops (make-box 10 20 30))`
- **THEN** returns a `gprops` instance with all properties pre-computed
