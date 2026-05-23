## ADDED Requirements

### Requirement: Loft through multiple section wires
The system SHALL create a solid or shell passing through a sequence of section wires using `BRepOffsetAPI_ThruSections`.

#### Scenario: Loft two rectangular wires into a solid
- **WHEN** user calls `(loft-sections '(wire1 wire2))`
- **THEN** returns a shape lofting from wire1 to wire2

#### Scenario: Loft three circular wires
- **WHEN** user calls `(loft-sections '(wire1 wire2 wire3))`
- **THEN** returns a shape passing through all three sections

### Requirement: Solid loft (closed) vs shell loft
The system SHALL support both solid (closed along the loft) and shell (open) loft modes.

#### Scenario: Solid loft (closed)
- **WHEN** user calls `(loft-sections wires :solid t)`
- **THEN** returns a closed solid

#### Scenario: Shell loft (open)
- **WHEN** user calls `(loft-sections wires :solid nil)`
- **THEN** returns an open shell

### Requirement: Loft with smoothing
The system SHALL support ruled (linear interpolation between sections) and smoothed (vtx) loft modes.

#### Scenario: Ruled loft
- **WHEN** user calls `(loft-sections wires :ruled t)`
- **THEN** returns a loft with linear interpolation between sections

#### Scenario: Smooth loft (vtx smoothing)
- **WHEN** user calls `(loft-sections wires :smooth t)`
- **THEN** returns a loft with vertex smoothing

### Requirement: Loft with tangency conditions
The system SHALL support tangency constraints on the first and last sections.

#### Scenario: Loft with tangency at first section
- **WHEN** user calls `(loft-sections wires :initial-tangent face-ref)`
- **THEN** the loft is tangent to the given face at the start

### Requirement: Nil sections return nil
- **WHEN** user calls `(loft-sections nil)`
- **THEN** returns nil
