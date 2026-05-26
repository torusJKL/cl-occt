## ADDED Requirements

### Requirement: Edge-Edge intersection
The system SHALL provide a function to compute intersection between two edges via IntTools_EdgeEdge.

**Parameters**: Two edge shapes.

**Returns**: A plist `(:points ((x y z) ...) :parameters ((u v) ...))` or nil on no intersection/invalid input.

#### Scenario: Intersecting edges find a point
- **WHEN** calling `(intersect-edge-edge edge1 edge2)` where edge1 and edge2 cross
- **THEN** the result contains at least one intersection point

#### Scenario: Non-intersecting edges return nil
- **WHEN** calling `(intersect-edge-edge edge1 edge2)` where edges are disjoint
- **THEN** the result is nil

#### Scenario: Nil input returns nil
- **WHEN** calling `(intersect-edge-edge nil edge2)`
- **THEN** the result is nil

### Requirement: Edge-Face intersection
The system SHALL provide a function to compute intersection between an edge and a face via IntTools_EdgeFace.

**Parameters**: An edge shape and a face shape.

**Returns**: A plist `(:points ((x y z) ...) :parameters (u v w))` or nil on no intersection/invalid input.

#### Scenario: Edge piercing a face
- **WHEN** calling `(intersect-edge-face edge face)` where the edge passes through the face
- **THEN** the result contains the intersection point

#### Scenario: Edge above face returns nil
- **WHEN** calling `(intersect-edge-face edge face)` where the edge does not intersect
- **THEN** the result is nil

### Requirement: Face-Face intersection
The system SHALL provide a function to compute intersection curves between two faces via IntTools_FaceFace.

**Parameters**: Two face shapes.

**Returns**: A plist `(:curves (curve1 curve2 ...) :points ((x y z) ...))` or nil on no intersection/invalid input.

#### Scenario: Intersecting faces produce curves
- **WHEN** calling `(intersect-face-face face1 face2)` where two faces intersect
- **THEN** the result contains at least one intersection `curve` or a list of points

#### Scenario: Non-intersecting faces return nil
- **WHEN** calling `(intersect-face-face face1 face2)` where faces do not intersect
- **THEN** the result is nil
