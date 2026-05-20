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
