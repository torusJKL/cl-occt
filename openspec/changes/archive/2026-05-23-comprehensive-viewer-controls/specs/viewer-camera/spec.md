## ADDED Requirements

### Requirement: Set eye, target, and up vectors
The system SHALL position the camera via eye (position), target (look-at point), and up vectors. All vectors SHALL be 3-element lists of doubles.

#### Scenario: Look at origin from positive Z
- **WHEN** user calls `(set-camera view :eye '(0 0 10) :target '(0 0 0) :up '(0 1 0))`
- **THEN** the view looks down the -Z axis toward the origin

#### Scenario: Partial call (eye only)
- **WHEN** user calls `(set-camera view :eye '(5 5 5))`
- **THEN** only the eye position changes; target and up remain at their previous values

#### Scenario: Get camera state as a Lisp object
- **WHEN** user calls `(viewer-camera view)`
- **THEN** returns a `viewer-camera` CLOS instance with slots `%eye`, `%target`, `%up`, `%fov`, `%projection-type`

### Requirement: Toggle perspective / orthographic projection
The system SHALL switch between perspective and orthographic camera modes.

#### Scenario: Perspective mode
- **WHEN** user calls `(set-perspective view t)`
- **THEN** the camera switches to perspective projection

#### Scenario: Orthographic mode
- **WHEN** user calls `(set-perspective view nil)`
- **THEN** the camera switches to orthographic projection

#### Scenario: Query projection type
- **WHEN** user calls `(perspective-p view)`
- **THEN** returns `t` if perspective, `nil` if orthographic

### Requirement: Set field of view
The system SHALL set the camera's field of view in degrees (converted to radians for OCCT).

#### Scenario: 45-degree FOV
- **WHEN** user calls `(set-fov view 45.0)`
- **THEN** the camera's field of view is set to 45 degrees

### Requirement: Set Z-clipping planes
The system SHALL set near and far clipping plane distances.

#### Scenario: Custom clip planes
- **WHEN** user calls `(set-clip-planes view :near 0.1 :far 1000.0)`
- **THEN** the camera clips geometry outside the [0.1, 1000.0] range

### Requirement: Fit all for individual shapes
The system SHALL fit the view to show the extents of a specific AIS object, not just all displayed objects.

#### Scenario: Fit to shape
- **WHEN** user calls `(fit-all view ais-obj)`
- **THEN** the view zooms to frame only that object

### Requirement: Camera pan and zoom
The system SHALL provide programmatic pan (translate) and zoom (scale) operations.

#### Scenario: Pan view
- **WHEN** user calls `(pan-camera view 50 30)`
- **THEN** the view shifts by 50 pixels horizontally and 30 vertically

#### Scenario: Zoom
- **WHEN** user calls `(zoom-camera view 2.0)`
- **THEN** the view zooms in by 2x

### Requirement: Camera rotation
The system SHALL rotate the camera around its axes.

#### Scenario: Rotate around X axis
- **WHEN** user calls `(rotate-camera view 45 0 0)`
- **THEN** the view rotates 45 degrees around the X axis

### Requirement: Reset to default view
The system SHALL reset the view to its default orientation and mapping.

#### Scenario: Reset view
- **WHEN** user calls `(reset-view view)`
- **THEN** the view returns to its default orientation

### Requirement: First-class camera object
The system SHALL expose a `viewer-camera` CLOS class with `%eye`, `%target`, `%up`, `%fov`, `%projection-type` slots, backed by the OCCT `Graphic3d_Camera` handle.

#### Scenario: Camera round-trip
- **WHEN** user calls `(let ((cam (viewer-camera view))) ...)`
- **THEN** the camera object is a valid CLOS instance whose slots reflect the current camera state

#### Scenario: Set camera from object
- **WHEN** user calls `(set-viewer-camera view cam)`
- **THEN** the view adopts the camera parameters from the `viewer-camera` object
