## ADDED Requirements

### Requirement: Create BSDF material

The system SHALL create a `Graphic3d_BSDF` value. `make-bsdf` SHALL return a `bsdf` instance with default BSDF values.

#### Scenario: Create default BSDF
- **WHEN** `make-bsdf` is called
- **THEN** a `bsdf` instance SHALL be returned with default properties

### Requirement: Set ambient component

The system SHALL set the ambient color of a BSDF material. `set-bsdf-ambient` SHALL accept a `bsdf` and RGB values in [0,1].

#### Scenario: Set ambient to gray
- **WHEN** `set-bsdf-ambient` is called with 0.2, 0.2, 0.2
- **THEN** the ambient component SHALL be dark gray

### Requirement: Set diffuse component

The system SHALL set the diffuse color of a BSDF material. `set-bsdf-diffuse` SHALL accept a `bsdf` and RGB values in [0,1].

#### Scenario: Set diffuse to blue
- **WHEN** `set-bsdf-diffuse` is called with 0.0, 0.0, 1.0
- **THEN** the diffuse component SHALL be pure blue

### Requirement: Set specular component

The system SHALL set the specular color of a BSDF material. `set-bsdf-specular` SHALL accept a `bsdf` and RGB values in [0,1].

#### Scenario: Set specular to white
- **WHEN** `set-bsdf-specular` is called with 1.0, 1.0, 1.0
- **THEN** the specular component SHALL be white

### Requirement: Set transmission component

The system SHALL set the transmission color of a BSDF material. `set-bsdf-transmission` SHALL accept a `bsdf` and RGB values in [0,1].

#### Scenario: Set transmission to white
- **WHEN** `set-bsdf-transmission` is called with 1.0, 1.0, 1.0
- **THEN** the transmission component SHALL be fully white

### Requirement: Set reflection component

The system SHALL set the reflection color of a BSDF material. `set-bsdf-reflection` SHALL accept a `bsdf` and RGB values in [0,1].

#### Scenario: Set reflection to white
- **WHEN** `set-bsdf-reflection` is called with 1.0, 1.0, 1.0
- **THEN** the reflection component SHALL be fully white

### Requirement: Set refraction index

The system SHALL set the index of refraction of a BSDF material. `set-bsdf-refraction-index` SHALL accept a `bsdf` and a double >= 1.0.

#### Scenario: Set IOR to 2.42 (diamond)
- **WHEN** `set-bsdf-refraction-index` is called with 2.42
- **THEN** the material's IOR SHALL be 2.42

### Requirement: Set absorption color and coefficient

The system SHALL set the absorption color and coefficient of a BSDF material. `set-bsdf-absorption` SHALL accept a `bsdf`, RGB in [0,1], and a coefficient >= 0.

#### Scenario: Set green absorption
- **WHEN** `set-bsdf-absorption` is called with 0.0, 1.0, 0.0 and 0.5
- **THEN** the material SHALL absorb with a green tint at coefficient 0.5

### Requirement: Apply BSDF material to AIS object

The system SHALL apply a `bsdf` to an AIS interactive object. `ais-set-bsdf` SHALL accept a context, an ais-object, and a `bsdf`. The material SHALL be copied onto the object.

#### Scenario: Apply to displayed shape
- **WHEN** `ais-set-bsdf` is called on a displayed ais-object with a configured BSDF
- **THEN** the object's surface appearance SHALL reflect the BSDF properties

#### Scenario: Apply with nil obj
- **WHEN** `ais-set-bsdf` is called with nil obj
- **THEN** nil SHALL be returned without error

### Requirement: BSDF predicate

`bsdf-p` SHALL return t for `bsdf` instances and nil otherwise.

#### Scenario: Predicate on BSDF
- **WHEN** `bsdf-p` is called on a valid `bsdf`
- **THEN** t SHALL be returned

#### Scenario: Predicate on nil
- **WHEN** `bsdf-p` is called on nil
- **THEN** nil SHALL be returned

### Requirement: GC finalization

`bsdf` SHALL be registered with `tg:finalize` to free the underlying C handle when garbage collected.

#### Scenario: GC collects BSDF
- **WHEN** a `bsdf` instance goes out of scope
- **THEN** the C handle SHALL be freed
