## ADDED Requirements

### Requirement: Create textured shape
The system SHALL provide a constructor `make-textured-shape` that creates an `AIS_TexturedShape` — a shape with an image texture applied.

#### Scenario: Create textured shape from shape and texture file
- **WHEN** the user calls `(make-textured-shape shape texture-filename)`
- **THEN** the system returns an `ais-object` with the texture applied to the shape

#### Scenario: Create textured shape from nil shape returns nil
- **WHEN** the user calls `(make-textured-shape nil "texture.png")`
- **THEN** the system returns `nil`

#### Scenario: Set texture repeat
- **WHEN** the user calls `(set-texture-repeat tex-obj u-repeat v-repeat)`
- **THEN** the texture is tiled across the surface with the given repeat counts

#### Scenario: Set texture origin
- **WHEN** the user calls `(set-texture-origin tex-obj u-origin v-origin)`
- **THEN** the texture mapping origin is offset by the given UV values
