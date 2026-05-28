## ADDED Requirements

### Requirement: Text placement on arbitrary plane
User SHALL be able to position and orient text on any arbitrary plane, not just the XY plane. The system SHALL accept a position (x,y,z) and orientation (normal direction dx,dy,dz) for text placement.

#### Scenario: Place text on a rotated plane
- **WHEN** user calls `(make-text-shape-on-plane font "Hello" :position '(10 20 0) :normal '(0 1 0))`
- **THEN** system returns a shape object with the text oriented on the YZ plane

#### Scenario: Place text at custom position with default orientation
- **WHEN** user calls `(make-text-shape-on-plane font "Hello" :position '(5 5 5))`
- **THEN** system returns a shape object at position (5,5,5) on XY plane

### Requirement: make-text-shape accepts optional position/orientation
The existing `make-text-shape` function SHALL accept optional `:position` and `:normal` keyword arguments for convenience, maintaining backward compatibility when omitted.

#### Scenario: Backward-compatible call without position
- **WHEN** user calls `(make-text-shape font "Hello")`
- **THEN** system returns a shape at origin on XY plane (same as current behavior)

#### Scenario: make-text-shape with position
- **WHEN** user calls `(make-text-shape font "Hello" :position '(10 0 0))`
- **THEN** system returns a shape at position (10,0,0) on XY plane

### Requirement: make-text-shape-3d accepts optional position/orientation
The existing `make-text-shape-3d` function SHALL accept optional `:position` and `:normal` keyword arguments.

#### Scenario: Extruded text on rotated plane
- **WHEN** user calls `(make-text-shape-3d font "Hello" 5 :position '(0 0 0) :normal '(0 1 0))`
- **THEN** system returns an extruded shape with text on the YZ plane

### Requirement: Extruded text extrusion direction follows normal
The `make-text-shape-3d` function SHALL extrude text perpendicular to the specified plane. When `:normal` is provided, the extrusion vector SHALL be parallel to the normal direction. The extrusion depth SHALL be the magnitude of the extrusion vector.

#### Scenario: Verify extrusion direction on rotated plane
- **WHEN** user creates extruded text with `(make-text-shape-3d <font> "Deep" 3.0 :position '(0 0 0) :normal '(0 1 0))` and checks `(shape-extent-along <shape> 0 1 0)` and `(shape-extent-along <shape> 0 0 1)`
- **THEN** `shape-extent-along` along Y returns a max value ≈ 3.0 and along Z returns a max value ≈ 0.0

### Requirement: Text plane X-direction control
The system SHALL allow the caller to explicitly specify the X-direction (text baseline direction) when placing text on an arbitrary plane. The X-direction SHALL be a 3-element list of real numbers representing a direction vector. When provided, the system SHALL use `gp_Ax3(origin, normal, x-dir)` to construct the text placement frame. When not provided (`nil`), the system SHALL fall back to the auto-computed behavior. The X-direction SHALL be accepted by `make-text-shape`, `make-text-shape-on-plane`, `make-text-shape-3d`, `make-multi-line-text`, and `make-formatted-text`.

#### Scenario: Explicit X-direction on XY plane
- **WHEN** user calls `(make-text-shape <font> "Hello" :x-direction '(1 0 0))`
- **THEN** system returns a shape with text baseline aligned to the X axis

#### Scenario: Explicit X-direction on XZ plane
- **WHEN** user calls `(make-text-shape-on-plane <font> "Hello" :normal '(0 1 0) :x-direction '(1 0 0))`
- **THEN** system returns a shape with text reading rightward along X on the XZ plane

#### Scenario: Explicit X-direction with 3D text
- **WHEN** user calls `(make-text-shape-3d <font> "Hello" 5.0 :normal '(0 1 0) :x-direction '(1 0 0))`
- **THEN** system returns an extruded shape with text oriented correctly on the XZ plane

#### Scenario: Explicit X-direction with multi-line text
- **WHEN** user calls `(make-multi-line-text <font> "Line1\nLine2" :normal '(0 1 0) :x-direction '(1 0 0))`
- **THEN** system returns a compound shape with lines stacked vertically on the XZ plane, reading rightward along X

#### Scenario: X-direction defaults to nil (backward compatible)
- **WHEN** user calls `(make-text-shape <font> "Hello")` without `:x-direction`
- **THEN** system returns a shape using auto-computed X direction (same behavior as before)
