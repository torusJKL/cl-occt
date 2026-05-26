## ADDED Requirements

### Requirement: User can display a raw polygonal mesh in the viewer
The system SHALL wrap `MeshVS_Mesh` and `MeshVS_DataSource` to allow creating and displaying polygonal meshes in the viewer without requiring a `TopoDS_Shape`. Users SHALL provide vertex arrays and triangle index arrays as data sources.

#### Scenario: Create and display a mesh in viewer
- **WHEN** user creates vertices `'((0 0 0) (10 0 0) (10 10 0) (0 10 0))` and triangles `'((0 1 2) (0 2 3))`, calls `(make-meshvs-mesh vertices triangles)` and `(ais-display ctx meshvs)`
- **THEN** the mesh is displayed in the viewer

#### Scenario: Mesh with custom vertex colors
- **WHEN** user provides per-vertex colors as `(r g b)` triples alongside vertices
- **THEN** the mesh is displayed with per-vertex coloring

#### Scenario: Display nil data source
- **WHEN** user calls `(ais-display ctx nil)`
- **THEN** system returns nil

### Requirement: User can free a MeshVS mesh
The system SHALL provide explicit cleanup for `MeshVS_Mesh` objects via `tg:finalize` and an explicit free function.

#### Scenario: Free mesh
- **WHEN** user calls `(meshvs-free mesh)`
- **THEN** the C handle is freed

### Requirement: User can set mesh display properties
The system SHALL allow setting mesh display mode (shaded, wireframe), material, and transparency on MeshVS mesh objects.

#### Scenario: Set mesh display mode
- **WHEN** user calls `(meshvs-set-display-mode mesh :wireframe)`
- **THEN** the mesh is displayed in wireframe mode

#### Scenario: Set mesh color
- **WHEN** user calls `(meshvs-set-color mesh ctx '(1 0 0))`
- **THEN** the mesh is displayed in red
