## ADDED Requirements

### Requirement: Helix parametric curve (HelixGeom)
The system SHALL define a parametric helix curve via `HelixGeom`, constructed from radius, pitch, height, and optionally left-handed orientation and initial angle.

#### Scenario: Construct a right-handed helix curve
- **WHEN** user calls `(make-helix-curve :radius 5.0 :pitch 2.0 :height 20.0)`
- **THEN** returns a `curve` instance of type `:helix` representing a right-handed helix

#### Scenario: Construct a left-handed helix curve
- **WHEN** user calls `(make-helix-curve :radius 5.0 :pitch 2.0 :height 20.0 :left-handed t)`
- **THEN** returns a `curve` instance of type `:helix` with left-handed winding

#### Scenario: Construct helix with initial angle
- **WHEN** user calls `(make-helix-curve :radius 5.0 :pitch 2.0 :height 20.0 :angle 45.0)`
- **THEN** returns a helix curve starting at 45 degrees around the axis

#### Scenario: Invalid helix parameters return nil
- **WHEN** user calls `(make-helix-curve :radius 0 :pitch 2.0 :height 20.0)`
- **THEN** returns nil

### Requirement: Helix BRep construction (HelixBRep)
The system SHALL construct a BRep edge or wire from helix parameters using `HelixBRep`, producing a shape suitable for use as an edge in wire/face construction.

#### Scenario: Construct a helix edge
- **WHEN** user calls `(make-helix-edge :radius 5.0 :pitch 2.0 :height 20.0)`
- **THEN** returns a `shape` instance representing a helix edge

#### Scenario: Construct a helix on cylindrical surface
- **WHEN** user calls `(make-helix-edge :radius 5.0 :pitch 2.0 :height 20.0 :on-surface cyl-surface)`
- **THEN** returns a helix edge lying on the given cylindrical surface

#### Scenario: Helix edge can be used in wire construction
- **WHEN** user calls `(make-wire (make-helix-edge ...) ...)`
- **THEN** the helix edge participates in wire assembly normally
