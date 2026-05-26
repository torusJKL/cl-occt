## ADDED Requirements

### Requirement: Create point cloud from coordinate arrays
The system SHALL provide a constructor `make-point-cloud` that creates an `AIS_PointCloud` from arrays of 3D points.

#### Scenario: Create a point cloud from vertex array
- **WHEN** the user calls `(make-point-cloud vertices)` with a list of (x y z) triples
- **THEN** the system returns an `ais-object` instance with a non-null C handle

#### Scenario: Set point cloud colors
- **WHEN** the user calls `(set-point-cloud-colors pc colors)` with a list of (r g b) triples
- **THEN** the point cloud displays with per-point colors

#### Scenario: Set point size
- **WHEN** the user calls `(set-point-cloud-size pc size)`
- **THEN** the rendered points are drawn with the given pixel size

#### Scenario: Create point cloud with empty array returns nil
- **WHEN** the user calls `(make-point-cloud nil)`
- **THEN** the system returns `nil`
