## ADDED Requirements

### Requirement: Generate arrow triangulation via Prs3d_Arrow
The system SHALL provide a function to compute arrow vertex/normal arrays using Prs3d_Arrow.

**Parameters**: start point (x1 y1 z1), end point (x2 y2 z2), shaft radius, cone length, cone radius, number of facets.

**Returns**: A `prs3d-triangulation` object or nil on invalid parameters.

#### Scenario: Create arrow between two points
- **WHEN** calling `(make-prs3d-arrow '(0 0 0) '(10 0 0) :shaft-radius 0.5 :cone-length 2.0 :cone-radius 1.0)`
- **THEN** the result is a `prs3d-triangulation` forming an arrow from origin along X axis

#### Scenario: Arrow with nil start/end returns nil
- **WHEN** calling `(make-prs3d-arrow nil '(10 0 0))`
- **THEN** the result is nil

### Requirement: Generate text triangulation via Prs3d_Text
The system SHALL provide a function to compute 3D text vertex/normal arrays using Prs3d_Text.

**Parameters**: a `brep-font` handle, text string, position (x y z), and optional height.

**Returns**: A `prs3d-triangulation` object or nil on invalid parameters.

#### Scenario: Create 3D text triangulation
- **WHEN** calling `(make-prs3d-text font "Hello" '(0 0 0))` with a valid font handle
- **THEN** the result is a `prs3d-triangulation` containing the rendered text geometry

#### Scenario: Text with nil font returns nil
- **WHEN** calling `(make-prs3d-text nil "Hello" '(0 0 0))`
- **THEN** the result is nil

### Requirement: Generate bounding box display via Prs3d_BndBox
The system SHALL provide a function to compute a bounding box wireframe display.

**Parameters**: minimum corner (xmin ymin zmin), maximum corner (xmax ymax zmax), and optional color.

**Returns**: A `prs3d-triangulation` object (line segments forming the box) or nil on invalid parameters.

#### Scenario: Create bounding box display from corners
- **WHEN** calling `(make-prs3d-bndbox '(0 0 0) '(10 20 30))`
- **THEN** the result is a `prs3d-triangulation` with line vertices forming the box

#### Scenario: Create bounding box display from a shape
- **WHEN** calling `(shape-bounding-box-display shape)` with a valid shape
- **THEN** the result is a `prs3d-triangulation` with the shape's bounding box

#### Scenario: BndBox with nil input returns nil
- **WHEN** calling `(make-prs3d-bndbox nil '(10 20 30))`
- **THEN** the result is nil
