## ADDED Requirements

### Requirement: Create light source display object
The system SHALL provide a constructor `make-light-source` that creates an `AIS_LightSource` — an interactive representation of a light in the 3D scene.

#### Scenario: Create a light source from an existing viewer-light
- **WHEN** the user calls `(make-light-source light)` with a `viewer-light` object
- **THEN** the system returns an `ais-object` instance representing the light

#### Scenario: Create light source with nil returns nil
- **WHEN** the user calls `(make-light-source nil)`
- **THEN** the system returns `nil`

#### Scenario: Display light source in viewer
- **WHEN** the user creates a light source and calls `(ais-display ctx light-src)`
- **THEN** the light is shown as an interactive icon in the 3D scene
