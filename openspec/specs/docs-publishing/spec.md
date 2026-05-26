## ADDED Requirements

### Requirement: api-reference.md updated with Graphic3d bindings
The docs/api-reference.md SHALL be updated with function tables for all new Graphic3d capabilities.

#### Scenario: Clip plane functions documented
- **WHEN** the api-reference.md is updated
- **THEN** it SHALL include a section for clip-plane with functions: `make-clip-plane`, `free-clip-plane`, `clip-plane-p`, `set-clip-plane-equation`, `clip-plane-equation`, `set-clip-plane-on`, `clip-plane-on-p`, `set-clip-plane-capping`, `set-clip-plane-cap-color`

#### Scenario: Shader program functions documented
- **WHEN** the api-reference.md is updated
- **THEN** it SHALL include a section for shader-program with functions: `make-shader-program`, `free-shader-program`, `shader-program-p`, `set-shader-vertex-source`, `set-shader-fragment-source`, `set-shader-header`

#### Scenario: Aspect functions documented
- **WHEN** the api-reference.md is updated
- **THEN** it SHALL include sections for aspect-fill-area, aspect-line, aspect-marker, and aspect-text with corresponding create, free, predicate, and accessor functions

#### Scenario: Structure functions documented
- **WHEN** the api-reference.md is updated
- **THEN** it SHALL include a section for graphic-structure with functions: `make-graphic-structure`, `free-graphic-structure`, `graphic-structure-p`, `set-graphic-structure-visible`, `set-graphic-structure-transform`, `remove-graphic-structure-transform`, `graphic-structure-add-child`, `graphic-structure-remove-child`, `graphic-structure-display`, `graphic-structure-erase`

#### Scenario: Group functions documented
- **WHEN** the api-reference.md is updated
- **THEN** it SHALL include a section for graphic-group with functions: `make-graphic-group`, `graphic-group-p`, `set-graphic-group-visible`, `graphic-group-add-triangles`, `graphic-group-add-lines`, `graphic-group-add-points`, `graphic-group-add-text`, `set-graphic-group-aspect`, `set-graphic-group-line-aspect`

#### Scenario: Rendering params functions documented
- **WHEN** the api-reference.md is updated
- **THEN** it SHALL include a section for rendering-params with functions: `viewer-rendering-params`, `rendering-params-p`, `set-rendering-method`, `rendering-method`, `set-ray-tracing-depth`, `set-ray-traced-shadows`, `set-ray-traced-reflections`, `set-rai-params-aa`, `set-rendering-gamma`, `rendering-gamma`
