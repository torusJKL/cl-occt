## ADDED Requirements

### Requirement: Box construction
User SHALL be able to construct a rectangular box by specifying width, depth, and height. The system SHALL use OCCT BRepPrimAPI_MakeBox. Dimensions MUST be positive (> Precision::Confusion).

#### Scenario: Construct a box
- **WHEN** user calls `(make-box 10 20 30)`
- **THEN** system returns a shape object representing a 10×20×30 box

#### Scenario: Construct a box with zero dimension
- **WHEN** user calls `(make-box 0 20 30)`
- **THEN** system returns nil

### Requirement: Cylinder construction
User SHALL be able to construct a cylinder by specifying radius and height.

#### Scenario: Construct a cylinder
- **WHEN** user calls `(make-cylinder 5 20)`
- **THEN** system returns a shape object representing a cylinder of radius 5 and height 20

### Requirement: Sphere construction
User SHALL be able to construct a sphere by specifying radius.

#### Scenario: Construct a sphere
- **WHEN** user calls `(make-sphere 10)`
- **THEN** system returns a shape object representing a sphere of radius 10

### Requirement: Cone construction
User SHALL be able to construct a cone by specifying bottom radius, top radius, and height.

#### Scenario: Construct a cone
- **WHEN** user calls `(make-cone 5 10 15)`
- **THEN** system returns a shape object representing a cone with r1=5, r2=10, height=15

### Requirement: Torus construction
User SHALL be able to construct a torus by specifying major radius (sweep radius) and minor radius (section radius). The system SHALL use OCCT BRepPrimAPI_MakeTorus. Both radii MUST be positive (> Precision::Confusion).

#### Scenario: Construct a torus
- **WHEN** user calls `(make-torus 10 3)`
- **THEN** system returns a shape object representing a torus with major radius 10 and minor radius 3

#### Scenario: Construct a torus with zero major radius
- **WHEN** user calls `(make-torus 0 3)`
- **THEN** system returns nil

#### Scenario: Construct a torus with zero minor radius
- **WHEN** user calls `(make-torus 10 0)`
- **THEN** system returns nil

### Requirement: Shape identity
Each constructed shape MUST be a distinct CLOS instance of type `shape`.

#### Scenario: Distinct shape objects
- **WHEN** user calls `(make-box 10 20 30)` twice
- **THEN** the two return values are not `eq`
