## ADDED Requirements

### Requirement: Create PBR material

The system SHALL create a `Graphic3d_PBRMaterial` value. `make-pbr-material` SHALL return a `pbr-material` instance with default PBR values (white albedo, 0.0 metallic, 1.0 roughness, no emissive).

#### Scenario: Create default PBR material
- **WHEN** `make-pbr-material` is called
- **THEN** a `pbr-material` instance SHALL be returned with default properties

### Requirement: Set albedo (base color)

The system SHALL set the albedo/base color of a PBR material. `set-pbr-albedo` SHALL accept a `pbr-material` and RGB values in [0,1].

#### Scenario: Set red albedo
- **WHEN** `set-pbr-albedo` is called with 1.0, 0.0, 0.0
- **THEN** the material albedo SHALL be pure red

### Requirement: Set metalness

The system SHALL set the metalness of a PBR material. `set-pbr-metallic` SHALL accept a `pbr-material` and a double in [0,1]. 0 = dielectric, 1 = metal.

#### Scenario: Set metallic to 1.0
- **WHEN** `set-pbr-metallic` is called with 1.0
- **THEN** the material SHALL be fully metallic

#### Scenario: Set metallic to 0.0
- **WHEN** `set-pbr-metallic` is called with 0.0
- **THEN** the material SHALL be fully dielectric

### Requirement: Set roughness

The system SHALL set the roughness of a PBR material. `set-pbr-roughness` SHALL accept a `pbr-material` and a double in [0,1]. 0 = perfectly smooth, 1 = fully rough.

#### Scenario: Set roughness to 0.0
- **WHEN** `set-pbr-roughness` is called with 0.0
- **THEN** the material SHALL be mirror-smooth

#### Scenario: Set roughness to 0.5
- **WHEN** `set-pbr-roughness` is called with 0.5
- **THEN** the material SHALL have medium roughness

### Requirement: Set emissive

The system SHALL set the emissive color and intensity of a PBR material. `set-pbr-emissive` SHALL accept a `pbr-material`, RGB values in [0,1], and an intensity multiplier.

#### Scenario: Set faint red emissive
- **WHEN** `set-pbr-emissive` is called with 1.0, 0.0, 0.0, 0.5
- **THEN** the material SHALL emit faint red light

#### Scenario: Set no emissive
- **WHEN** `set-pbr-emissive` is called with 0.0, 0.0, 0.0, 0.0
- **THEN** the material SHALL have no emission

### Requirement: Set IOR

The system SHALL set the index of refraction. `set-pbr-ior` SHALL accept a `pbr-material` and a double >= 1.0.

#### Scenario: Set IOR to 1.5 (glass)
- **WHEN** `set-pbr-ior` is called with 1.5
- **THEN** the material's IOR SHALL be 1.5

### Requirement: Set transparency

The system SHALL set the transparency factor. `set-pbr-transparency` SHALL accept a `pbr-material` and a double in [0,1].

#### Scenario: Set 50% transparent
- **WHEN** `set-pbr-transparency` is called with 0.5
- **THEN** the material SHALL be 50% transparent

### Requirement: Set normal map texture

The system SHALL set a normal map texture on a PBR material. `set-pbr-normal-texture` SHALL accept a `pbr-material` and a `texture-2d`.

#### Scenario: Set normal map
- **WHEN** `set-pbr-normal-texture` is called with a valid `texture-2d`
- **THEN** the material SHALL use the texture as normal map

#### Scenario: Clear normal map
- **WHEN** `set-pbr-normal-texture` is called with nil
- **THEN** the material SHALL have no normal map

### Requirement: Set base color texture

The system SHALL set a base color texture on a PBR material. `set-pbr-base-color-texture` SHALL accept a `pbr-material` and a `texture-2d`.

#### Scenario: Set base color texture
- **WHEN** `set-pbr-base-color-texture` is called with a valid `texture-2d`
- **THEN** the material SHALL use the texture as base color

### Requirement: Set ORM texture

The system SHALL set a combined occlusion-roughness-metallic (ORM) texture. `set-pbr-orm-texture` SHALL accept a `pbr-material` and a `texture-2d`. The ORM texture encodes occlusion in R, roughness in G, metallic in B.

#### Scenario: Set ORM texture
- **WHEN** `set-pbr-orm-texture` is called with a valid `texture-2d`
- **THEN** the material SHALL use the ORM texture

### Requirement: Apply PBR material to AIS object

The system SHALL apply a `pbr-material` to an AIS interactive object. `ais-set-pbr-material` SHALL accept a context, an ais-object, and a `pbr-material`. The material SHALL be copied onto the object — subsequent changes to the `pbr-material` instance SHALL NOT affect the displayed object.

#### Scenario: Apply to displayed shape
- **WHEN** `ais-set-pbr-material` is called on a displayed ais-object with a configured PBR material
- **THEN** the object's surface appearance SHALL reflect the PBR properties

#### Scenario: Apply to nil obj
- **WHEN** `ais-set-pbr-material` is called with nil obj
- **THEN** nil SHALL be returned without error

### Requirement: PBR material predicate

`pbr-material-p` SHALL return t for `pbr-material` instances and nil otherwise.

#### Scenario: Predicate on PBR material
- **WHEN** `pbr-material-p` is called on a valid `pbr-material`
- **THEN** t SHALL be returned

#### Scenario: Predicate on nil
- **WHEN** `pbr-material-p` is called on nil
- **THEN** nil SHALL be returned

### Requirement: GC finalization

`pbr-material` SHALL be registered with `tg:finalize` to free the underlying C handle when garbage collected.

#### Scenario: GC collects material
- **WHEN** a `pbr-material` instance goes out of scope
- **THEN** the C handle SHALL be freed
