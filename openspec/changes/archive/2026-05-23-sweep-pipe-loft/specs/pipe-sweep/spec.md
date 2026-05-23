## ADDED Requirements

### Requirement: Simple sweep (profile along spine)
The system SHALL sweep a profile (face or wire) along a spine (edge or wire) using `BRepPrimAPI_MakePipe`, producing a solid or shell.

#### Scenario: Sweep a circle along a line
- **WHEN** user calls `(sweep-profile circle-face spine-line)`
- **THEN** returns a shape (solid pipe) following the line spine

#### Scenario: Sweep a rectangular face along a curved spine
- **WHEN** user calls `(sweep-profile rect-face curved-spine)`
- **THEN** returns a shape with the rectangular cross-section swept along the curve

#### Scenario: Sweep with nil profile
- **WHEN** user calls `(sweep-profile nil spine)`
- **THEN** returns nil

### Requirement: Advanced sweep with evolving sections
The system SHALL sweep with section evolution using `BRepPrimAPI_MakePipeShell`, supporting multiple section wires at different positions along the spine.

#### Scenario: Sweep with two sections
- **WHEN** user calls `(sweep-sections spine '(section1 section2) '(0.0 1.0))`
- **THEN** returns a shape evolving from section1 at the start of the spine to section2 at the end

#### Scenario: Sweep with insertion of intermediate section
- **WHEN** user calls `(sweep-sections spine '(section-at-start section-at-mid section-at-end) '(0.0 0.5 1.0))`
- **THEN** returns a shape passing through all three sections

#### Scenario: Sweep with auxiliary spine
- **WHEN** user calls `(sweep-with-aux-spine profile main-spine aux-spine)`
- **THEN** returns a shape swept along the main spine, guided by the auxiliary spine

### Requirement: Sweep with sliding option
The system SHALL support sliding (section orientation follows spine tangent) and non-sliding (section orientation remains fixed) sweep modes.

#### Scenario: Sliding sweep (default)
- **WHEN** user calls `(sweep-profile profile spine :mode :sliding)`
- **THEN** the section orientation follows the spine's tangent

#### Scenario: Fixed sweep
- **WHEN** user calls `(sweep-profile profile spine :mode :fixed)`
- **THEN** the section orientation remains constant

### Requirement: Sweep with tangency constraints
The system SHALL support tangency conditions on the first and/or last section of a pipe shell sweep.

#### Scenario: Sweep with starting tangency
- **WHEN** user calls `(sweep-sections spine sections params :initial-tangent face)`
- **THEN** the sweep is tangent to the given face at the start
