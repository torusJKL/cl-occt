## ADDED Requirements

### Requirement: Generate parametric cylinder triangulation
The system SHALL provide a function to generate a triangulated cylinder mesh via Prs3d_ToolCylinder.

**Parameters**: radius, height, number of samples along height (n slices), number of samples around axis (n stacks).

**Returns**: A `prs3d-triangulation` object containing vertex positions and normals as flat float arrays, or nil on invalid parameters (nil/zero radius, nil/zero height).

#### Scenario: Generate cylinder with default tessellation
- **WHEN** calling `(make-prs3d-cylinder-mesh 5.0 10.0)`
- **THEN** the result is a `prs3d-triangulation` with vertices and normals matching a radius-5 height-10 cylinder

#### Scenario: Generate cylinder with custom tessellation
- **WHEN** calling `(make-prs3d-cylinder-mesh 5.0 10.0 :n-slices 32 :n-stacks 16)`
- **THEN** the result is a `prs3d-triangulation` with the specified mesh resolution

#### Scenario: Cylinder with invalid parameters returns nil
- **WHEN** calling `(make-prs3d-cylinder-mesh 0.0 10.0)`
- **THEN** the result is nil

### Requirement: Generate parametric sphere triangulation
The system SHALL provide a function to generate a triangulated sphere mesh via Prs3d_ToolSphere.

**Parameters**: radius, number of slices (meridians), number of stacks (parallels).

**Returns**: A `prs3d-triangulation` object or nil on invalid parameters.

#### Scenario: Generate sphere with default tessellation
- **WHEN** calling `(make-prs3d-sphere-mesh 5.0)`
- **THEN** the result is a `prs3d-triangulation` with vertices and normals matching a radius-5 sphere

#### Scenario: Generate sphere with custom tessellation
- **WHEN** calling `(make-prs3d-sphere-mesh 5.0 :n-slices 48 :n-stacks 24)`
- **THEN** the result is a `prs3d-triangulation` with the specified mesh resolution

### Requirement: Generate parametric torus triangulation
The system SHALL provide a function to generate a triangulated torus mesh via Prs3d_ToolTorus.

**Parameters**: major radius, minor radius, number of slices (around tube), number of stacks (around axis).

**Returns**: A `prs3d-triangulation` object or nil on invalid parameters.

#### Scenario: Generate torus with default tessellation
- **WHEN** calling `(make-prs3d-torus-mesh 10.0 3.0)`
- **THEN** the result is a `prs3d-triangulation` with vertices and normals matching a major-10 minor-3 torus

### Requirement: Generate parametric disk triangulation
The system SHALL provide a function to generate a triangulated disk mesh via Prs3d_ToolDisk.

**Parameters**: inner radius, outer radius, number of slices (radial), number of stacks (angular).

**Returns**: A `prs3d-triangulation` object or nil on invalid parameters.

#### Scenario: Generate solid disk mesh
- **WHEN** calling `(make-prs3d-disk-mesh 0.0 5.0)`
- **THEN** the result is a `prs3d-triangulation` with vertices matching a radius-5 filled disk

#### Scenario: Generate annular disk mesh
- **WHEN** calling `(make-prs3d-disk-mesh 2.0 5.0)`
- **THEN** the result is a `prs3d-triangulation` forming a ring (inner radius 2, outer radius 5)

### Requirement: Access prs3d-triangulation data
The system SHALL provide accessors for `prs3d-triangulation` objects: vertex count, triangle count, vertex positions as flat float vectors, normals as flat float vectors, and triangle indices.

#### Scenario: Query triangle count
- **WHEN** calling `(prs3d-triangulation-triangle-count mesh)` on a valid mesh
- **THEN** the result is a positive integer

#### Scenario: Access vertex positions
- **WHEN** calling `(prs3d-triangulation-vertices mesh)`
- **THEN** the result is a list of (x y z) triples

### Requirement: Free prs3d-triangulation
The system SHALL provide a function to explicitly free a `prs3d-triangulation`'s C handle. Calling free on nil SHALL be a no-op.

#### Scenario: Free mesh handle
- **WHEN** calling `(free-prs3d-triangulation mesh)` on a valid mesh
- **THEN** the C handle is freed and further access is undefined but safe
