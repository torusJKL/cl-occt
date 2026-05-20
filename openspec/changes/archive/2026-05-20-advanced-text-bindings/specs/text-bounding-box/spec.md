## ADDED Requirements

### Requirement: Query text bounding box
User SHALL be able to query the bounding box of a text string without rendering it into a shape. The system SHALL return the width and height of the text as it would appear with the given font.

#### Scenario: Query bounding box dimensions
- **WHEN** user calls `(text-bounding-box font "Hello World")`
- **THEN** system returns `(values width height)` as double floats

#### Scenario: Bounding box of empty string
- **WHEN** user calls `(text-bounding-box font "")`
- **THEN** system returns nil
