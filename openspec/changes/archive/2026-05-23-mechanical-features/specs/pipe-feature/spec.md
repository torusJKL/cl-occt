## ADDED Requirements

### Requirement: Pipe-shaped feature from a face
The system SHALL create a pipe-shaped depression or protrusion by sweeping a profile along a path from a base face using `BRepFeat_MakePipe`.

#### Scenario: Pipe depression
- **WHEN** user calls `(make-pipe-feature base-face profile path :operation :cut)`
- **THEN** returns a shape with a pipe-shaped depression following the path

#### Scenario: Pipe protrusion
- **WHEN** user calls `(make-pipe-feature base-face profile path :operation :add)`
- **THEN** returns a shape with a pipe-shaped protrusion following the path

#### Scenario: Pipe with nil profile returns nil
- **WHEN** user calls `(make-pipe-feature nil profile path :operation :cut)`
- **THEN** returns nil
