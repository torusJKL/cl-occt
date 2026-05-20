## ADDED Requirements

### Requirement: Create trihedron
The system SHALL create an `AIS_Trihedron` axis indicator from origin, normal direction, and X-direction vectors. The trihedron SHALL display red (X), green (Y), and blue (Z) axes.

#### Scenario: Default trihedron
- **WHEN** user calls `(make-trihedron)`
- **THEN** system returns an `ais-object` with axes at origin (0,0,0), Z up, X right

#### Scenario: Custom trihedron
- **WHEN** user calls `(make-trihedron :origin '(1 2 3) :normal '(0 1 0) :x-direction '(-1 0 0))`
- **THEN** system returns a trihedron at (1,2,3) with Y as up and -X as right

#### Scenario: Zero normal
- **WHEN** user calls `(make-trihedron :normal '(0 0 0))`
- **THEN** system returns nil (zero vector rejected)

### Requirement: Set datum display mode
The system SHALL switch the trihedron between wireframe and shaded appearance.

#### Scenario: Shaded trihedron
- **WHEN** user calls `(set-trihedron-mode tri :shaded)`
- **THEN** trihedron renders with shaded axes

#### Scenario: Wireframe trihedron
- **WHEN** user calls `(set-trihedron-mode tri :wireframe)`
- **THEN** trihedron renders with wireframe axes

### Requirement: Toggle arrows
The system SHALL show or hide arrowheads on the trihedron axes.

#### Scenario: Hide arrows
- **WHEN** user calls `(set-trihedron-arrows tri nil)`
- **THEN** trihedron axes render without arrowheads

### Requirement: Set trihedron size
The system SHALL set the visual size of the trihedron in pixels or scene units.

#### Scenario: Larger trihedron
- **WHEN** user calls `(set-trihedron-size tri 100)`
- **THEN** trihedron renders at size 100

### Requirement: Set screen-corner persistence
The system SHALL pin the trihedron to a fixed screen position so it stays in view regardless of camera orbit.

#### Scenario: Lower-left corner
- **WHEN** user calls `(set-trihedron-corner tri :lower-left)`
- **THEN** trihedron remains fixed in the lower-left corner when the view orbits

#### Scenario: Upper-right corner with offset
- **WHEN** user calls `(set-trihedron-corner tri :upper-right :x-offset 100 :y-offset 20)`
- **THEN** trihedron remains fixed 100px from right edge, 20px from top

### Requirement: Show trihedron convenience
The system SHALL provide a single function to create, configure, and display a trihedron in one call.

#### Scenario: One-call trihedron
- **WHEN** user calls `(show-trihedron context viewer :corner :lower-right :size 60)`
- **THEN** a size-60 trihedron is displayed in the lower-right corner of the viewport
