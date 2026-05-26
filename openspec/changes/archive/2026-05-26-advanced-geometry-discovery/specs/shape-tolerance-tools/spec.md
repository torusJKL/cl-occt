## ADDED Requirements

### Requirement: Set tolerance per subshape type
The system SHALL set the tolerance for all subshapes of a given type (vertices, edges, faces) in a shape via `ShapeFix_ShapeTolerance`.

#### Scenario: Set tolerance on all vertices
- **WHEN** a tolerance value is set on vertices of a shape
- **THEN** all vertices SHALL have at most the specified tolerance

#### Scenario: Set tolerance on all edges
- **WHEN** a tolerance value is set on edges of a shape
- **THEN** all edges SHALL have at most the specified tolerance

#### Scenario: Null shape returns nil
- **WHEN** a null shape is provided
- **THEN** the result SHALL be nil
