## ADDED Requirements

### Requirement: Create texture params

The system SHALL create a `Graphic3d_TextureParams` object. `make-texture-params` SHALL return a `texture-params` instance with default OCCT values (TRILINEAR filter, REPEAT wrap mode, no aniso).

#### Scenario: Create default params
- **WHEN** `make-texture-params` is called
- **THEN** a `texture-params` instance SHALL be returned with default settings

### Requirement: Set texture filter

The system SHALL set the texture filtering mode. `set-texture-params-filter` SHALL accept a `texture-params` and a filter keyword (`:nearest`, `:bilinear`, or `:trilinear`). The default SHALL be `:trilinear`.

#### Scenario: Set nearest filter
- **WHEN** `set-texture-params-filter` is called with `:nearest`
- **THEN** the texture SHALL use nearest-neighbor filtering

#### Scenario: Set bilinear filter
- **WHEN** `set-texture-params-filter` is called with `:bilinear`
- **THEN** the texture SHALL use bilinear filtering

#### Scenario: Set trilinear filter
- **WHEN** `set-texture-params-filter` is called with `:trilinear`
- **THEN** the texture SHALL use trilinear filtering (mipmapped)

### Requirement: Set wrap mode

The system SHALL set the texture wrap mode for S and T axes independently. `set-texture-params-wrap-s` and `set-texture-params-wrap-t` SHALL accept a `texture-params` and a wrap keyword (`:clamp`, `:repeat`, or `:mirror`). The default SHALL be `:repeat`.

#### Scenario: Set clamp
- **WHEN** `set-texture-params-wrap-s` is called with `:clamp`
- **THEN** the texture SHALL clamp in S direction

#### Scenario: Set mirror
- **WHEN** `set-texture-params-wrap-t` is called with `:mirror`
- **THEN** the texture SHALL mirror in T direction

### Requirement: Set anisotropy level

The system SHALL set the anisotropy filtering level. `set-texture-params-aniso` SHALL accept a `texture-params` and a non-negative integer. Level 0 disables anisotropic filtering. Default SHALL be 0.

#### Scenario: Set aniso level 4
- **WHEN** `set-texture-params-aniso` is called with 4
- **THEN** anisotropic filtering at level 4 SHALL be enabled

#### Scenario: Set aniso level 0
- **WHEN** `set-texture-params-aniso` is called with 0
- **THEN** anisotropic filtering SHALL be disabled

### Requirement: Texture params predicate

`texture-params-p` SHALL return t for `texture-params` instances and nil otherwise.

#### Scenario: Predicate on params
- **WHEN** `texture-params-p` is called on a valid `texture-params`
- **THEN** t SHALL be returned

#### Scenario: Predicate on nil
- **WHEN** `texture-params-p` is called on nil
- **THEN** nil SHALL be returned

### Requirement: GC finalization

`texture-params` SHALL be registered with `tg:finalize` to free the underlying C handle when garbage collected.

#### Scenario: GC collects params
- **WHEN** a `texture-params` instance goes out of scope
- **THEN** the C handle SHALL be freed
