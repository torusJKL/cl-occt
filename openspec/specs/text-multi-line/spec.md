## ADDED Requirements

### Requirement: Multi-line text
User SHALL be able to render multi-line text where newline characters (`#\Newline`) in the input string produce separate lines of text stacked vertically.

#### Scenario: Render two-line text
- **WHEN** user calls `(make-text-shape font "Line1\nLine2")`
- **THEN** system returns a compound shape containing both lines, stacked vertically

#### Scenario: Multi-line text on arbitrary plane
- **WHEN** user calls `(make-text-shape font "A\nB" :position '(0 0 0) :normal '(1 0 0))`
- **THEN** system returns a compound shape with lines on the YZ plane

### Requirement: Formatted text via Font_TextFormatter
User SHALL be able to create formatted text with configurable line spacing and alignment using `Font_TextFormatter`.

#### Scenario: Formatted text with custom line spacing
- **WHEN** user calls `(make-formatted-text font "Hello\nWorld" :line-spacing 1.5)`
- **THEN** system returns a compound shape with 1.5x line spacing
