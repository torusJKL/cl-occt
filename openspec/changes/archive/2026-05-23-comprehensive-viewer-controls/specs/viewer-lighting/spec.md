## ADDED Requirements

### Requirement: Create ambient light
The system SHALL create a uniform ambient light with configurable color and intensity.

#### Scenario: Warm ambient
- **WHEN** user calls `(make-light :ambient :color '(0.3 0.2 0.1) :intensity 0.5)`
- **THEN** returns a `viewer-light` instance with ambient type, warm color, 0.5 intensity

### Requirement: Create directional light
The system SHALL create a directional light (sun-like, infinite) with configurable color, intensity, and direction.

#### Scenario: White directional light from above
- **WHEN** user calls `(make-light :directional :color :white :intensity 0.8 :direction '(0 -1 0))`
- **THEN** returns a `viewer-light` instance with directional type, white light shining downward

### Requirement: Create positional (point) light
The system SHALL create a point light with position in 3D space, color, and intensity.

#### Scenario: Red point light at origin
- **WHEN** user calls `(make-light :positional :color :red :position '(0 0 0) :intensity 1.0)`
- **THEN** returns a `viewer-light` instance with positional type, red, at origin

### Requirement: Create spot light
The system SHALL create a spot light with position, direction, color, intensity, cone angle, and concentration.

#### Scenario: Narrow spot light
- **WHEN** user calls `(make-light :spot :color :white :position '(5 5 5) :direction '(-1 -1 -1) :angle 15.0 :concentration 0.9)`
- **THEN** returns a `viewer-light` instance with spot type, 15-degree cone, sharp falloff

### Requirement: Add, remove, and toggle lights on viewer
The system SHALL manage lights as individual objects that can be added to a viewer, removed, turned on, and turned off.

#### Scenario: Add light to viewer
- **WHEN** user calls `(viewer-add-light viewer light)`
- **THEN** the light is registered with the viewer

#### Scenario: Remove light from viewer
- **WHEN** user calls `(viewer-remove-light viewer light)`
- **THEN** the light is removed from the viewer

#### Scenario: Toggle light on/off
- **WHEN** user calls `(viewer-light-on viewer light)` / `(viewer-light-off viewer light)`
- **THEN** the light is enabled/disabled

#### Scenario: Query light active state
- **WHEN** user calls `(viewer-light-p viewer light)`
- **THEN** returns `t` if the light is active, `nil` otherwise

### Requirement: Set headlight (camera-attached) mode
The system SHALL attach a directional light to the camera so it moves with the view.

#### Scenario: Enable headlight
- **WHEN** user calls `(set-headlight light t)`
- **THEN** the light follows the camera

### Requirement: Configure per-light properties after creation
The system SHALL allow modifying a light's color, intensity, direction, and position after creation.

#### Scenario: Change light color
- **WHEN** user calls `(set-light-color light :blue)`
- **THEN** the light color changes to blue

#### Scenario: Change light intensity
- **WHEN** user calls `(set-light-intensity light 0.7)`
- **THEN** the light intensity changes to 0.7

#### Scenario: Change light position
- **WHEN** user calls `(set-light-position light '(10 10 10))`
- **THEN** the light moves to (10,10,10)

#### Scenario: Change light direction
- **WHEN** user calls `(set-light-direction light '(0 0 -1))`
- **THEN** the light points along -Z

#### Scenario: Change spot light angle
- **WHEN** user calls `(set-light-angle light 30.0)`
- **THEN** the spot cone changes to 30 degrees

#### Scenario: Change spot concentration
- **WHEN** user calls `(set-light-concentration light 0.5)`
- **THEN** the spot falloff changes

### Requirement: Enable/disable shadow casting
The system SHALL toggle shadow casting on directional, positional, and spot lights.

#### Scenario: Enable shadows
- **WHEN** user calls `(set-light-shadows light t)`
- **THEN** the light casts shadows (requires ray-tracing mode)

### Requirement: Install default lights
The system SHALL restore the viewer's default lighting (ambient + directional headlight).

#### Scenario: Reset to defaults
- **WHEN** user calls `(viewer-default-lights viewer)`
- **THEN** the viewer reverts to the default ambient + headlight setup

### Requirement: Enumerate active lights
The system SHALL provide functions to list all lights and all active lights in a viewer.

#### Scenario: List all lights
- **WHEN** user calls `(viewer-lights viewer)`
- **THEN** returns a list of all `viewer-light` instances registered in the viewer

#### Scenario: List active lights
- **WHEN** user calls `(viewer-active-lights viewer)`
- **THEN** returns a list of `viewer-light` instances that are currently on

### Requirement: First-class light object
The system SHALL expose a `viewer-light` CLOS class with slots `%type`, `%color`, `%intensity`, `%direction`, `%position`, `%angle`, `%concentration`, `%headlight-p`, `%shadows-p`.

#### Scenario: Light type query
- **WHEN** user calls `(light-type light)`
- **THEN** returns `:ambient`, `:directional`, `:positional`, or `:spot`
