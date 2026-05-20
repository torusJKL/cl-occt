## ADDED Requirements

### Requirement: Enable/disable computed (ray-traced) rendering
The system SHALL toggle ray-traced rendering mode for photorealistic output.

#### Scenario: Enable ray-tracing
- **WHEN** user calls `(set-computed-mode view t)`
- **THEN** the view renders with ray-tracing (reflections, shadows, refractions)

#### Scenario: Disable ray-tracing
- **WHEN** user calls `(set-computed-mode view nil)`
- **THEN** the view renders with rasterization

#### Scenario: Query computed mode
- **WHEN** user calls `(computed-mode-p view)`
- **THEN** returns `t` if ray-tracing is enabled, `nil` otherwise

### Requirement: Set back-face model
The system SHALL control how back-facing polygons are handled.

#### Scenario: Auto back-face
- **WHEN** user calls `(set-back-face-model view :auto)`
- **THEN** back-face culling follows the OCCT default behavior

#### Scenario: Force back-face display
- **WHEN** user calls `(set-back-face-model view :force)`
- **THEN** back faces are always visible (useful for transparent objects)

#### Scenario: Disable back-faces
- **WHEN** user calls `(set-back-face-model view :disable)`
- **THEN** back faces are hidden

### Requirement: Enable/disable frustum culling
The system SHALL toggle frustum culling for performance optimization.

#### Scenario: Enable frustum culling
- **WHEN** user calls `(set-frustum-culling view t)`
- **THEN** objects outside the view frustum are not rendered

#### Scenario: Disable frustum culling
- **WHEN** user calls `(set-frustum-culling view nil)`
- **THEN** all objects are rendered regardless of frustum position

### Requirement: Enable/disable transparent shading sorting
The system SHALL toggle proper transparency sorting for correct alpha blending.

#### Scenario: Enable transparent sorting
- **WHEN** user calls `(set-transparent-shading view t)`
- **THEN** transparent objects are sorted for correct blending

#### Scenario: Disable transparent sorting
- **WHEN** user calls `(set-transparent-shading view nil)`
- **THEN** transparency uses simpler (potentially incorrect) blending

### Requirement: Force redraw
The system SHALL immediately redraw both the main and overlay content.

#### Scenario: Full redraw
- **WHEN** user calls `(redraw-view view)`
- **THEN** the view immediately redraws both main and immediate (overlay) content

### Requirement: Set immediate update mode
The system SHALL control whether display changes are flushed immediately or deferred.

#### Scenario: Immediate updates
- **WHEN** user calls `(set-immediate-update view t)`
- **THEN** display, erase, and color changes take effect immediately

#### Scenario: Deferred updates
- **WHEN** user calls `(set-immediate-update view nil)`
- **THEN** changes are batched until the next redraw or `update-view`
