## ADDED Requirements

### Requirement: Project shape onto face along normal
The system SHALL project a shape (wire or edge) onto a face along the face surface normal via `BRepAlgo_NormalProjection`.

#### Scenario: Edge projected onto plane
- **WHEN** an edge is projected onto a planar face along the face normal
- **THEN** the result SHALL be a valid shape on the face surface

#### Scenario: Projection failure returns nil
- **WHEN** an edge is projected onto a face it cannot intersect
- **THEN** the result SHALL be nil

#### Scenario: Null input returns nil
- **WHEN** a null shape is projected
- **THEN** the result SHALL be nil
