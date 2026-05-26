## MODIFIED Requirements

### Requirement: BRepTools shape dump and utilities
Previously the `shape-triangle-count` function required the shape to already be meshed by an external operation. The system SHALL now automatically mesh the shape with default parameters before counting triangles when no triangulation exists. The system SHALL add `mesh-get-vertices`, `mesh-get-triangles`, `mesh-get-normals` and `mesh-get-triangle-count` functions for comprehensive access to mesh data.

#### Scenario: Shape triangle count triggers implicit meshing
- **WHEN** user calls `(shape-triangle-count (make-box 10 20 30))` on an unmeshed shape
- **THEN** the shape is implicitly meshed with default parameters and the triangle count is returned

#### Scenario: Existing call pattern continues to work
- **WHEN** user calls `(shape-triangle-count (mesh-shape (make-box 10 20 30)))`
- **THEN** returns the triangle count as before
