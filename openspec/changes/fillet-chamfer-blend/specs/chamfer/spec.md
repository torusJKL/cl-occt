## ADDED Requirements

### Requirement: Equal-distance chamfer on edges
The system SHALL bevel edges of a solid with equal distances on both adjacent faces using `BRepFilletAPI_MakeChamfer`.

#### Scenario: Chamfer a single edge of a box
- **WHEN** user calls `(chamfer-edge box edge 5.0)`
- **THEN** returns a shape with the specified edge chamfered at distance 5.0

#### Scenario: Chamfer multiple edges
- **WHEN** user calls `(chamfer-edges box '(edge1 edge2) 3.0)`
- **THEN** returns a shape with both edges chamfered at distance 3.0

#### Scenario: Chamfer with distance larger than face width returns nil
- **WHEN** user calls `(chamfer-edge box edge 999.0)`
- **THEN** returns nil

### Requirement: Asymmetric two-distance chamfer
The system SHALL chamfer an edge with different distances on each adjacent face.

#### Scenario: Asymmetric chamfer
- **WHEN** user calls `(chamfer-edge box edge 5.0 3.0)`
- **THEN** returns a shape with the edge chamfered at distance 5.0 on the first face and 3.0 on the second

### Requirement: Chamfer by edge and face
The system SHALL allow specifying which face to chamfer relative to (useful for asymmetric chamfers on edges with ambiguous face adjacency).

#### Scenario: Chamfer relative to specific face
- **WHEN** user calls `(chamfer-edge box edge 5.0 :face face-ref)`
- **THEN** returns a shape chamfered with distance 5.0 measured from the specified face
