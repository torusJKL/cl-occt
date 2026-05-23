## ADDED Requirements

### Requirement: Apply draft angle to faces of a solid
The system SHALL apply a draft (taper) angle to selected faces of a solid using `BRepOffsetAPI_DraftAngle`, specifying the angle, direction, and neutral plane.

#### Scenario: Draft on a face of a box
- **WHEN** user calls `(draft-face box face 10.0 direction neutral-plane)`
- **THEN** returns a shape with the specified face tapered by 10 degrees

#### Scenario: Draft with direction vector
- **WHEN** user calls `(draft-face box face 15.0 '(0 0 -1) '(0 0 0))`
- **THEN** returns a shape with the face tapered in the pull direction

#### Scenario: Draft beyond face geometry returns nil
- **WHEN** user calls `(draft-face box face 150.0 direction neutral-plane)`
- **THEN** returns nil (excessive draft angle)

### Requirement: Evolved solid construction
The system SHALL construct an evolved solid (profile swept along a spine with offset) using `BRepOffsetAPI_MakeEvolved`.

#### Scenario: Evolve a profile along a spine
- **WHEN** user calls `(make-evolved profile spine)`
- **THEN** returns a shape representing the evolved solid

#### Scenario: Evolve with offset
- **WHEN** user calls `(make-evolved profile spine :offset 2.0)`
- **THEN** returns a shape with the evolution offset by 2.0
