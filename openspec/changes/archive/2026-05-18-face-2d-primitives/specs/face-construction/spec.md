## ADDED Requirements

### Requirement: Edge construction from two 2D points
User SHALL be able to construct a linear edge by specifying start (x1, y1) and end (x2, y2) 2D coordinates. The system SHALL use OCCT BRepBuilderAPI_MakeEdge. The edge SHALL be a TopoDS_Edge.

#### Scenario: Construct a 2D line edge
- **WHEN** user calls `(make-edge 0.0 0.0 10.0 0.0)`
- **THEN** system returns a shape object representing a straight edge from (0,0) to (10,0)

### Requirement: Edge construction from two 3D points
User SHALL be able to construct a linear edge by specifying start (x1, y1, z1) and end (x2, y2, z2) 3D coordinates. The system SHALL use OCCT BRepBuilderAPI_MakeEdge.

#### Scenario: Construct a 3D line edge
- **WHEN** user calls `(make-edge-3d 0.0 0.0 0.0 10.0 0.0 0.0)`
- **THEN** system returns a shape object representing a straight edge from (0,0,0) to (10,0,0)

### Requirement: Edge construction from a 2D circle
User SHALL be able to construct a full circle edge by specifying center (x, y) and radius. The system SHALL use OCCT BRepBuilderAPI_MakeEdge with a Geom2d_Circle.

#### Scenario: Construct a circle edge
- **WHEN** user calls `(make-circle-edge 5.0 5.0 10.0)`
- **THEN** system returns a shape object representing a full circle edge centered at (5,5) with radius 10

#### Scenario: Construct a circle edge with zero radius
- **WHEN** user calls `(make-circle-edge 0.0 0.0 0.0)`
- **THEN** system returns nil

### Requirement: Edge construction from a 2D circular arc
User SHALL be able to construct a circular arc edge by specifying three 2D points: start, intermediate, and end. The system SHALL use OCCT GC_MakeArcOfCircle.

#### Scenario: Construct a circular arc edge
- **WHEN** user calls `(make-circular-arc 0.0 0.0 5.0 5.0 10.0 0.0)`
- **THEN** system returns a shape object representing a circular arc through the three specified points

#### Scenario: Construct an arc with collinear points
- **WHEN** user calls `(make-circular-arc 0.0 0.0 5.0 5.0 10.0 10.0)`
- **THEN** system returns nil

### Requirement: Wire construction from edges
User SHALL be able to construct a wire by specifying one or more edges. The system SHALL use OCCT BRepBuilderAPI_MakeWire. An empty edge list SHALL return nil.

#### Scenario: Construct a wire from two edges
- **WHEN** user calls `(make-wire (make-edge 0 0 10 0) (make-edge 10 0 10 10))`
- **THEN** system returns a shape object representing a wire composed of the two edges

#### Scenario: Construct a wire with no edges
- **WHEN** user calls `(make-wire)`
- **THEN** system returns nil

### Requirement: Planar face construction from a closed wire
User SHALL be able to construct a planar face from a closed wire. The system SHALL use OCCT BRepBuilderAPI_MakeFace and SHALL automatically compute the planar surface.

#### Scenario: Construct a face from a square wire
- **WHEN** user calls
  ```
  (let* ((e1 (make-edge 0 0 10 0))
         (e2 (make-edge 10 0 10 10))
         (e3 (make-edge 10 10 0 10))
         (e4 (make-edge 0 10 0 0))
         (w (make-wire e1 e2 e3 e4)))
    (make-face w))
  ```
- **THEN** system returns a shape object representing a 10×10 planar face in the XY plane

#### Scenario: Construct a face from a nil wire
- **WHEN** user calls `(make-face nil)`
- **THEN** system returns nil

### Requirement: Face construction on a user-specified plane
User SHALL be able to construct a planar face from a closed wire on an explicit plane defined by origin (ox, oy, oz) and normal direction (nx, ny, nz). This SHALL use BRepBuilderAPI_MakeFace with explicit plane specification.

#### Scenario: Construct a face on the YZ plane
- **WHEN** user calls `(make-face-on-plane w 0 0 0 1 0 0)` where w is a closed wire
- **THEN** system returns a shape object representing a planar face on the YZ plane

### Requirement: Shape identity
Each constructed edge, wire, and face MUST be a distinct CLOS instance of type `shape`.

#### Scenario: Distinct edge objects
- **WHEN** user calls `(make-edge 0 0 10 0)` twice
- **THEN** the two return values are not `eq`
