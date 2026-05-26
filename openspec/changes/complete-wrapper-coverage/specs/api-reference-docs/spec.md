## MODIFIED Requirements

### Requirement: Document prs3d-tools functions in api-reference.md
The system SHALL add a "Prs3d Tools" section to `docs/api-reference.md` documenting `make-prs3d-cylinder-mesh`, `make-prs3d-sphere-mesh`, `make-prs3d-torus-mesh`, `make-prs3d-disk-mesh`, and related `prs3d-triangulation` accessors.

**Format**: Each function entry SHALL have a function signature in backticks, a description, and at least one usage example.

#### Scenario: Section added with all 4 mesh generators
- **WHEN** the section is added to api-reference.md
- **THEN** it SHALL have table entries for cylinder, sphere, torus, disk mesh generators with parameters and return types

### Requirement: Document prs3d-primitives functions in api-reference.md
The system SHALL add a "Prs3d Primitives" section to `docs/api-reference.md` documenting `make-prs3d-arrow`, `make-prs3d-text`, and `make-prs3d-bndbox` / `shape-bounding-box-display`.

#### Scenario: Section added with arrow, text, bndbox
- **WHEN** the section is added to api-reference.md
- **THEN** it SHALL have entries for arrow creation, text triangulation, and bounding box display

### Requirement: Document math-optimization functions in api-reference.md
The system SHALL add a "Math Optimization" section to `docs/api-reference.md` documenting `bfgs-minimize`, `frpr-minimize`, `pso-minimize`, `globoptmin-minimize`, and solver free functions.

#### Scenario: Section with all 4 solvers
- **WHEN** the section is added to api-reference.md
- **THEN** it SHALL document each solver's parameters, return plist format, and provide a usage example

### Requirement: Document inttools-intersection functions in api-reference.md
The system SHALL add an "IntTools Intersection" section to `docs/api-reference.md` documenting `intersect-edge-edge`, `intersect-edge-face`, and `intersect-face-face`.

#### Scenario: Section with 3 intersection functions
- **WHEN** the section is added to api-reference.md
- **THEN** it SHALL document each function's parameters, return plist format, and provide usage examples

## ADDED Requirements

### Requirement: Document xcaf-get-shape-layers in api-reference.md
The system SHALL document `xcaf-get-shape-layers` in the "XCAF Document Tools" section of `docs/api-reference.md`.

#### Scenario: Layer retrieval entry exists
- **WHEN** user inspects `docs/api-reference.md`
- **THEN** the XCAF section includes `xcaf-get-shape-layers` with its signature, description, and usage example

### Requirement: Remove stale set-transparent-shading entry from api-reference.md
The system SHALL remove any reference to `set-transparent-shading` as a distinct function in `docs/api-reference.md`, keeping only the `set-transparency-method` entry (which is the real implementation).

#### Scenario: No separate transparent shading entry
- **WHEN** user inspects `docs/api-reference.md`
- **THEN** there is no distinct entry for `set-transparent-shading` (it is only documented as an alias of `set-transparency-method`)

### Requirement: Docstrings for set-transparency-method follow convention
The `set-transparency-method` docstring SHALL be checked and updated to conform to the `docstring-markdown-convention` spec.

#### Scenario: Docstring reformatted
- **WHEN** user inspects `(describe 'set-transparency-method)`
- **THEN** the docstring uses `- **view**` and `- **method**` parameter format
- **AND** uses `**Returns:**` for the return value
- **AND** the existing `**Example:**` section uses 4-space-indented code
