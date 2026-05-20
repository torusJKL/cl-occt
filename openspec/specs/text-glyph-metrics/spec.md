## ADDED Requirements

### Requirement: Render individual glyph
User SHALL be able to render a single glyph by its Unicode code point as a shape.

#### Scenario: Render glyph as shape
- **WHEN** user calls `(text-glyph-as-shape font 0x41)` (Unicode 'A')
- **THEN** system returns a shape representing the glyph 'A'

#### Scenario: Render glyph and extrude
- **WHEN** user calls `(text-glyph-as-shape-3d font 0x41 5)`
- **THEN** system returns an extruded shape of glyph 'A' with depth 5

### Requirement: Query font metrics
User SHALL be able to query font-level metrics: ascender, descender, and line spacing.

#### Scenario: Query ascender
- **WHEN** user calls `(text-font-ascender font)`
- **THEN** system returns a positive double representing the ascender height

#### Scenario: Query descender
- **WHEN** user calls `(text-font-descender font)`
- **THEN** system returns a negative double representing the descender depth

#### Scenario: Query line spacing
- **WHEN** user calls `(text-font-line-spacing font)`
- **THEN** system returns a positive double representing line spacing

### Requirement: Query glyph advance
User SHALL be able to query the horizontal and vertical advance between two glyphs.

#### Scenario: Query advance X between two glyphs
- **WHEN** user calls `(text-font-advance-x font 0x41 0x42)` (advance from 'A' to 'B')
- **THEN** system returns a double representing the horizontal advance

#### Scenario: Query advance Y between two glyphs
- **WHEN** user calls `(text-font-advance-y font 0x41 0x42)`
- **THEN** system returns a double representing the vertical advance

### Requirement: Set glyph rendering parameters
User SHALL be able to set width scaling and composite curve mode on a font.

#### Scenario: Set width scaling
- **WHEN** user calls `(text-font-set-width-scaling font 0.8)`
- **THEN** subsequent text rendered with this font is scaled to 80% width

#### Scenario: Set composite curve mode
- **WHEN** user calls `(text-font-set-composite-curve-mode font t)`
- **THEN** subsequent text rendering uses composite curves
