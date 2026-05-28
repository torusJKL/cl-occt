## ADDED Requirements

### Requirement: Document make-text-shape-3d extrusion-follows-normal behavior in docs/api-reference.md

The `docs/api-reference.md` description of `make-text-shape-3d` SHALL explicitly state that when `:normal` is provided, extrusion follows the plane normal direction (not always Z).

#### Scenario: make-text-shape-3d description includes normal extrusion
- **WHEN** user inspects the `make-text-shape-3d` entry in `docs/api-reference.md`
- **THEN** the entry SHALL mention that extrusion follows the plane normal when `:normal` is provided

### Requirement: Add text API section to doc/api-reference.md

The `doc/api-reference.md` file SHALL include a "3D Text" section that documents all public text API functions, matching the content in `docs/api-reference.md`.

#### Scenario: Text section exists in doc/api-reference.md
- **WHEN** user inspects `doc/api-reference.md`
- **THEN** it SHALL contain a "3D Text" subsection with entries for `make-brep-font-from-file`, `make-brep-font-from-name`, `make-text-shape`, `make-text-shape-3d`, `make-text-shape-on-plane`, `make-multi-line-text`, `make-formatted-text`, and all font metric/query functions

### Requirement: doc/api-reference.md stays consistent with primary docs

The text API section in `doc/api-reference.md` SHALL match the function signatures and descriptions in `docs/api-reference.md`.

#### Scenario: Consistent description for make-text-shape-3d
- **WHEN** user compares `make-text-shape-3d` entries in both files
- **THEN** the description in `doc/api-reference.md` SHALL be consistent with `docs/api-reference.md` (including extrusion-follows-normal behavior)
