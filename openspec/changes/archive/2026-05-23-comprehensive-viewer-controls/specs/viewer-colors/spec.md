## ADDED Requirements

### Requirement: Named color constants
The system SHALL expose ~260 OCCT named colors (`Quantity_NOC_*`) as Lisp keyword symbols, mapped to their RGB values.

#### Scenario: Look up named color
- **WHEN** user calls `(named-color :red)`
- **THEN** returns `(1.0 0.0 0.0)` (RGB triple)

#### Scenario: Translating named colors
- **WHEN** user calls `(named-color :sky-blue)`, `(named-color :steel-blue)`, `(named-color :alice-blue)`
- **THEN** returns the corresponding RGB values for each

#### Scenario: Unknown color
- **WHEN** user calls `(named-color :nonexistent-color)`
- **THEN** returns nil

#### Scenario: Color name -> RGB
- **WHEN** user calls `(color-rgb :gold)`
- **THEN** returns the RGB triple for the named color `:gold`

### Requirement: Color normalization
The system SHALL accept colors in multiple formats and normalize them to an `(r g b)` list.

#### Scenario: Keyword input
- **WHEN** user calls `(normalize-color :red)`
- **THEN** returns `(1.0 0.0 0.0)`

#### Scenario: RGB list input
- **WHEN** user calls `(normalize-color '(0.5 0.5 0.5))`
- **THEN** returns `(0.5 0.5 0.5)` (pass-through)

#### Scenario: Hex string input
- **WHEN** user calls `(normalize-color "#FF8800")`
- **THEN** returns `(1.0 0.533 0.0)`

#### Scenario: Short hex string input
- **WHEN** user calls `(normalize-color "#F80")`
- **THEN** returns `(1.0 0.533 0.0)`

#### Scenario: viewer-color instance
- **WHEN** user calls `(normalize-color viewer-color-instance)`
- **THEN** returns the RGB triple from the instance

#### Scenario: Invalid input
- **WHEN** user calls `(normalize-color "not-a-color")` or `(normalize-color 42)`
- **THEN** returns nil

### Requirement: HLS color support
The system SHALL create colors from HLS (hue, lightness, saturation) values.

#### Scenario: HLS to RGB
- **WHEN** user calls `(make-color :hls '(0.0 0.5 1.0))`
- **THEN** returns a `viewer-color` instance with the corresponding RGB values (pure red at 50% lightness, fully saturated)

### Requirement: Hex string to color
The system SHALL parse `#RRGGBB` and `#RGB` hex color strings.

#### Scenario: Hex to RGB
- **WHEN** user calls `(hex-to-rgb "#4A90D9")`
- **THEN** returns `(0.29 0.565 0.851)`

#### Scenario: Short hex to RGB
- **WHEN** user calls `(hex-to-rgb "#F80")`
- **THEN** returns `(1.0 0.533 0.0)`

#### Scenario: Invalid hex
- **WHEN** user calls `(hex-to-rgb "#GGG")`
- **THEN** returns nil

### Requirement: Color difference (Delta E)
The system SHALL compute the color difference between two colors using CIE76 (Euclidean in RGB) or DeltaE formula.

#### Scenario: Same color Delta E
- **WHEN** user calls `(color-delta :red :red)`
- **THEN** returns 0.0

#### Scenario: Different color Delta E
- **WHEN** user calls `(color-delta :red :blue)`
- **THEN** returns a positive number

### Requirement: First-class color object
The system SHALL expose a `viewer-color` CLOS class with slots `%r`, `%g`, `%b`, `%name` (optional), wrapping `Quantity_Color`.

#### Scenario: Create color from keyword
- **WHEN** user calls `(make-color :red)`
- **THEN** returns a `viewer-color` instance with the correct RGB values and name `:red`

#### Scenario: Create color from RGB
- **WHEN** user calls `(make-color :rgb '(0.5 0.5 0.5))`
- **THEN** returns a `viewer-color` instance with `%name = nil`

#### Scenario: Create color from HLS
- **WHEN** user calls `(make-color :hls '(0.6 0.5 0.8))`
- **THEN** returns a `viewer-color` instance with RGB converted from HLS

#### Scenario: Color type predicate
- **WHEN** user calls `(viewer-color-p obj)`
- **THEN** returns `t` for `viewer-color` instances, `nil` otherwise

### Requirement: List all named colors
The system SHALL return a list of all available named color keywords.

#### Scenario: Enumerate colors
- **WHEN** user calls `(list-named-colors)`
- **THEN** returns a list of ~260 keywords representing all available named colors
