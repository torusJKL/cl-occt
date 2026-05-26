## ADDED Requirements

### Requirement: Access rendering params from viewer
The system SHALL retrieve the `Graphic3d_RenderingParams` from a viewer view. This is a value type (pointer to the view's internal params).

#### Scenario: Get rendering params
- **WHEN** user calls `(viewer-rendering-params view)`
- **THEN** returns a `rendering-params` instance pointing to the view's parameters

#### Scenario: Get from nil view
- **WHEN** user calls `(viewer-rendering-params nil)`
- **THEN** returns `nil`

### Requirement: Get/set rendering method
The system SHALL get and set the rendering method (`:rasterization` or `:ray-tracing`).

#### Scenario: Set rendering method
- **WHEN** user calls `(set-rendering-method params :ray-tracing)`
- **THEN** the rendering method is set to ray-tracing

#### Scenario: Get rendering method
- **WHEN** user calls `(rendering-method params)`
- **THEN** returns `:rasterization` or `:ray-tracing`

### Requirement: Get/set ray-tracing parameters
The system SHALL configure ray-tracing quality: shadows, reflections, refractions, and antialiasing.

#### Scenario: Set ray-tracing depth
- **WHEN** user calls `(set-ray-tracing-depth params n)`
- **THEN** the ray-tracing depth is set to n

#### Scenario: Enable/disable shadows
- **WHEN** user calls `(set-ray-traced-shadows params t)`
- **THEN** shadows are enabled in ray-tracing mode

#### Scenario: Enable/disable reflections
- **WHEN** user calls `(set-ray-traced-reflections params t)`
- **THEN** reflections are enabled

#### Scenario: Enable/disable antialiasing
- **WHEN** user calls `(set-rai-params-aa params t)`
- **THEN** ray-traced antialiasing is enabled

### Requirement: Get/set gamma correction
The system SHALL get and set the gamma correction value.

#### Scenario: Set gamma
- **WHEN** user calls `(set-rendering-gamma params 2.2)`
- **THEN** gamma correction is set to 2.2

#### Scenario: Get gamma
- **WHEN** user calls `(rendering-gamma params)`
- **THEN** returns the current gamma value as a double-float

### Requirement: Predicate
The system SHALL provide a predicate for `rendering-params` instances.

#### Scenario: rendering-params-p
- **WHEN** user calls `(rendering-params-p (viewer-rendering-params view))`
- **THEN** returns `t`
- **WHEN** user calls `(rendering-params-p nil)`
- **THEN** returns `nil`
