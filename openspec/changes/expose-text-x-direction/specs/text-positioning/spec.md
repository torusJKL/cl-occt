## ADDED Requirements

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
- **WHEN** user calls `(make-multi-line-text <font> "Line1\\nLine2" :normal '(0 1 0) :x-direction '(1 0 0))`
- **THEN** system returns a compound shape with lines stacked vertically on the XZ plane, reading rightward along X

#### Scenario: X-direction defaults to nil (backward compatible)
- **WHEN** user calls `(make-text-shape <font> "Hello")` without `:x-direction`
- **THEN** system returns a shape using auto-computed X direction (same behavior as before)
