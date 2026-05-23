## ADDED Requirements

### Requirement: General shape repair (ShapeFix_Shape)
The system SHALL repair a shape's topological and geometrical issues using `ShapeFix_Shape`, which internally runs fixes for wires, solids, edges, and faces.

#### Scenario: Fix an invalid shape
- **WHEN** user calls `(fix-shape invalid-shape)`
- **THEN** returns a repaired shape, or nil if repair is impossible

#### Scenario: Fix with nil returns nil
- **WHEN** user calls `(fix-shape nil)`
- **THEN** returns nil

### Requirement: Wire fixing (ShapeFix_Wire)
The system SHALL fix issues in a wire: closing gaps, removing self-intersections, correcting edge orientation using `ShapeFix_Wire`.

#### Scenario: Fix a wire with a gap
- **WHEN** user calls `(fix-wire wire face :tolerance 0.1)`
- **THEN** returns a wire with the gap closed

#### Scenario: Fix wire with self-intersection
- **WHEN** user calls `(fix-wire self-intersecting-wire face)`
- **THEN** returns a wire with self-intersections removed

### Requirement: Solid fixing (ShapeFix_Solid)
The system SHALL fix issues in a solid using `ShapeFix_Solid`.

#### Scenario: Fix a solid
- **WHEN** user calls `(fix-solid invalid-solid)`
- **THEN** returns a repaired solid

### Requirement: Edge and face fixing (ShapeFix_Edge, ShapeFix_Face)
The system SHALL fix issues in individual edges and faces.

#### Scenario: Fix an edge
- **WHEN** user calls `(fix-edge edge)`
- **THEN** returns a repaired edge shape

#### Scenario: Fix a face
- **WHEN** user calls `(fix-face face)`
- **THEN** returns a repaired face shape

### Requirement: Shape analysis queries
The system SHALL diagnose geometry/topology issues using `ShapeAnalysis` utilities.

#### Scenario: Check free edges
- **WHEN** user calls `(shape-analysis-free-edges shape)`
- **THEN** returns a list of free (unconnected) edges

#### Scenario: Check surface-surface intersections
- **WHEN** user calls `(shape-analysis-check-intersections shape)`
- **THEN** returns a list of surfaces that incorrectly intersect

#### Scenario: Wire containment check
- **WHEN** user calls `(shape-analysis-wire-contains-p wire point)`
- **THEN** returns t if the point is inside the wire boundary

#### Scenario: Shape contents summary
- **WHEN** user calls `(shape-analysis-contents shape)`
- **THEN** returns a plist with counts of sub-shapes by type
