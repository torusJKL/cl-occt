## ADDED Requirements

### Requirement: Set per-object transparency
The system SHALL set the transparency level of a displayed object, from 0.0 (opaque) to 1.0 (fully transparent).

#### Scenario: Semi-transparent object
- **WHEN** user calls `(ais-set-transparency ctx obj 0.5)`
- **THEN** the object renders at 50% opacity

#### Scenario: Fully opaque
- **WHEN** user calls `(ais-set-transparency ctx obj 0.0)`
- **THEN** the object renders fully opaque

#### Scenario: Invalid transparency value
- **WHEN** user calls `(ais-set-transparency ctx obj -0.1)` or `(ais-set-transparency ctx obj 1.5)`
- **THEN** returns nil (clamped or rejected by OCCT)

### Requirement: Set per-object material preset
The system SHALL set a material from ~50 OCCT named presets.

#### Scenario: Gold material
- **WHEN** user calls `(ais-set-material ctx obj :gold)`
- **THEN** the object renders with gold appearance

#### Scenario: Glass material
- **WHEN** user calls `(ais-set-material ctx obj :glass)`
- **THEN** the object renders transparent and refractive

#### Scenario: Plastic material
- **WHEN** user calls `(ais-set-material ctx obj :plastic)`
- **THEN** the object renders with matte plastic appearance

#### Scenario: Unknown material keyword
- **WHEN** user calls `(ais-set-material ctx obj :nonexistent)`
- **THEN** returns nil

### Requirement: Set custom material
The system SHALL create and apply a custom material with ambient, diffuse, specular, emissive colors, and shininess.

#### Scenario: Custom red shiny material
- **WHEN** user calls `(ais-set-material ctx obj (make-material :ambient '(0.2 0.0 0.0) :diffuse '(0.8 0.1 0.1) :specular '(1.0 1.0 1.0) :shininess 0.9))`
- **THEN** the object renders with a shiny red custom material

#### Scenario: Material with transparency
- **WHEN** user calls `(ais-set-material ctx obj (make-material :diffuse '(0.5 0.5 0.5) :transparency 0.3))`
- **THEN** the object renders with 30% transparency

### Requirement: Set line width
The system SHALL set the line/edge width in pixels for a displayed object in wireframe mode.

#### Scenario: Thick edges
- **WHEN** user calls `(ais-set-line-width ctx obj 3.0)`
- **THEN** the object's edges render 3 pixels wide

#### Scenario: Default line width
- **WHEN** user calls `(ais-set-line-width ctx obj 1.0)`
- **THEN** the object's edges render at normal thickness

### Requirement: Shaded with edges
The system SHALL display an object in shaded mode with visible edges overlaid.

#### Scenario: Show edges on shaded
- **WHEN** user calls `(ais-show-edges ctx obj t)`
- **THEN** the object renders shaded with visible edge lines

#### Scenario: Hide edges on shaded
- **WHEN** user calls `(ais-show-edges ctx obj nil)`
- **THEN** the object renders shaded without edge lines

#### Scenario: Set edge line color and width
- **WHEN** user calls `(ais-set-edge-styling ctx obj :color '(0.5 0.5 0.5) :width 1.5)`
- **THEN** edges render in grey at 1.5px

### Requirement: Set selection mode
The system SHALL set the selection mode on an object (shape, face, edge, vertex).

#### Scenario: Select faces
- **WHEN** user calls `(ais-set-selection-mode ctx obj :face)`
- **THEN** clicking on the object selects individual faces

#### Scenario: Select edges
- **WHEN** user calls `(ais-set-selection-mode ctx obj :edge)`
- **THEN** clicking on the object selects individual edges

#### Scenario: Select vertices
- **WHEN** user calls `(ais-set-selection-mode ctx obj :vertex)`
- **THEN** clicking on the object selects individual vertices

#### Scenario: Select shape (default)
- **WHEN** user calls `(ais-set-selection-mode ctx obj :shape)`
- **THEN** clicking selects the entire object

#### Scenario: Disable selection
- **WHEN** user calls `(ais-set-selection-mode ctx obj nil)`
- **THEN** the object cannot be selected

### Requirement: Set tessellation quality
The system SHALL control the tessellation quality (chordal deflection) of an object, trading visual fidelity for performance.

#### Scenario: High quality (low deflection)
- **WHEN** user calls `(ais-set-tessellation obj :quality 0.01)`
- **THEN** the object tessellates with 0.01 chordal deflection (high quality)

#### Scenario: Low quality (high deflection)
- **WHEN** user calls `(ais-set-tessellation obj :quality 1.0)`
- **THEN** the object tessellates with 1.0 chordal deflection (coarse)

### Requirement: Set display mode with custom modes
The system SHALL extend existing display mode to support additional AIS display modes beyond wireframe/shaded.

#### Scenario: Set display mode by integer
- **WHEN** user calls `(ais-set-display-mode ctx obj 2)`
- **THEN** the object uses display mode 2 (if defined by the interactive object)

### Requirement: First-class material object
The system SHALL expose a `viewer-material` CLOS class with slots `%ambient`, `%diffuse`, `%specular`, `%emissive`, `%shininess`, `%transparency`.

#### Scenario: Material slot access
- **WHEN** user calls `(material-ambient mat)`, `(material-diffuse mat)`, `(material-shininess mat)`
- **THEN** returns the corresponding material property
