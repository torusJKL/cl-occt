## ADDED Requirements

### Requirement: Load font from file path
The system SHALL load a TrueType or OpenType font from a file path and return a `brep-font` object. The font size SHALL be specified in model units. An optional face ID SHALL default to 0. If the file cannot be found or loaded, the system SHALL return nil.

#### Scenario: Load a valid TTF font by path
- **WHEN** user calls `(make-brep-font-from-file "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf" 10.0)`
- **THEN** system returns a `brep-font` object

#### Scenario: Load font with explicit face ID
- **WHEN** user calls `(make-brep-font-from-file "/path/to/font.ttf" 12.0 1)`
- **THEN** system returns a `brep-font` object using face ID 1

#### Scenario: Load font from nonexistent path
- **WHEN** user calls `(make-brep-font-from-file "/nonexistent/font.ttf" 10.0)`
- **THEN** system returns nil

#### Scenario: Load font with zero size
- **WHEN** user calls `(make-brep-font-from-file "/path/to/font.ttf" 0.0)`
- **THEN** system returns nil

### Requirement: Load font by system name
The system SHALL look up a font by system name and font aspect, and return a `brep-font` object. Font aspect SHALL be one of `:regular`, `:bold`, `:italic`, `:bold-italic`. If the font name is not found, the system SHALL return nil.

#### Scenario: Load a system font by name with regular aspect
- **WHEN** user calls `(make-brep-font-from-name "Arial" :regular 10.0)`
- **THEN** system returns a `brep-font` object

#### Scenario: Load a system font with bold aspect
- **WHEN** user calls `(make-brep-font-from-name "DejaVu Sans" :bold 12.0)`
- **THEN** system returns a `brep-font` object

#### Scenario: Load font with unknown name
- **WHEN** user calls `(make-brep-font-from-name "NonexistentFontNameXYZ" :regular 10.0)`
- **THEN** system returns nil

### Requirement: Render flat text shape
The system SHALL render a text string as a flat BRep shape on the XY plane using a loaded font. The system SHALL support horizontal alignment (`:left`, `:center`, `:right`) and vertical alignment (`:bottom`, `:center`, `:top`, `:top-first-line`). Text SHALL be UTF-8 encoded. The returned shape SHALL be a compound of face shapes, one per glyph, positioned correctly with kerning.

#### Scenario: Render simple text with default alignment
- **WHEN** user calls `(make-text-shape <font> "Hello")`
- **THEN** system returns a `shape` object

#### Scenario: Render text with center alignment
- **WHEN** user calls `(make-text-shape <font> "Centered" :h-align :center :v-align :center)`
- **THEN** system returns a `shape` object

#### Scenario: Render text with right alignment
- **WHEN** user calls `(make-text-shape <font> "Right" :h-align :right :v-align :top)`
- **THEN** system returns a `shape` object

#### Scenario: Render text with UTF-8 characters
- **WHEN** user calls `(make-text-shape <font> "Café résumé 123")`
- **THEN** system returns a `shape` object

#### Scenario: Render text with nil font
- **WHEN** user calls `(make-text-shape nil "Hello")`
- **THEN** system returns nil

#### Scenario: Render empty string
- **WHEN** user calls `(make-text-shape <font> "")`
- **THEN** system returns nil

### Requirement: Render 3D text
The system SHALL provide a convenience function that renders text and extrudes it in one step. When `:normal` is not specified, the extrusion SHALL be in the Z direction. When `:normal` is specified, extrusion SHALL follow the plane normal direction. The function SHALL accept the same alignment keyword arguments as `make-text-shape`.

#### Scenario: Create 3D text with default alignment
- **WHEN** user calls `(make-text-shape-3d <font> "Hello 3D!" 2.0)`
- **THEN** system returns a `shape` object that is a 3D extrusion of the flat text

#### Scenario: Create 3D text with custom alignment
- **WHEN** user calls `(make-text-shape-3d <font> "Centered" 3.0 :h-align :center :v-align :center)`
- **THEN** system returns a `shape` object

#### Scenario: Create 3D text with nil font
- **WHEN** user calls `(make-text-shape-3d nil "Hello" 2.0)`
- **THEN** system returns nil

#### Scenario: Create 3D text with zero depth
- **WHEN** user calls `(make-text-shape-3d <font> "Hello" 0.0)`
- **THEN** system returns nil

#### Scenario: Extrude along non-default normal
- **WHEN** user calls `(make-text-shape-3d <font> "Normal" 3.0 :normal '(0 1 0))`
- **THEN** system returns a shape whose extent along Y is approximately 3.0 and extent along Z is approximately 0.0

### Requirement: Font lifecycle management
The system SHALL automatically release font resources when a `brep-font` object is garbage collected. The user MAY also free a font explicitly.

#### Scenario: Font object responds to predicate
- **WHEN** user calls `(brep-font-p <font>)` on a valid font
- **THEN** system returns true

#### Scenario: Font predicate returns nil for non-font
- **WHEN** user calls `(brep-font-p nil)`
- **THEN** system returns nil

### Requirement: Roundtrip text export
The system SHALL be able to write 3D text shapes to STEP and STL formats using existing I/O functions.

#### Scenario: Export 3D text to STEP
- **WHEN** user calls `(write-step (make-text-shape-3d <font> "Export" 2.0) "/tmp/text.step")`
- **THEN** system returns t and creates a valid STEP file

#### Scenario: Export 3D text to STL
- **WHEN** user calls `(write-stl (make-text-shape-3d <font> "Export" 2.0) "/tmp/text.stl" 0.05)`
- **THEN** system returns t and creates a valid STL file
