## ADDED Requirements

### Requirement: README documents text API
The README SHALL be updated to include documentation for all new text capabilities, including function reference, keyword arguments, and code examples.

#### Scenario: README has text positioning docs
- **WHEN** user reads the README
- **THEN** it includes documentation for `make-text-shape` with `:position` and `:normal` keyword arguments

#### Scenario: README has font enumeration docs
- **WHEN** user reads the README
- **THEN** it includes the `list-available-fonts` function

#### Scenario: README has AIS text label docs
- **WHEN** user reads the README
- **THEN** it includes `make-ais-text-label` and notes that labels are viewer-only and excluded from STL/STEP export

#### Scenario: README has multi-line text docs
- **WHEN** user reads the README
- **THEN** it documents newline-based multi-line text and the `make-formatted-text` function

#### Scenario: README has per-glyph API docs
- **WHEN** user reads the README
- **THEN** it includes glyph metrics functions (`text-font-ascender`, etc.) and per-glyph rendering

#### Scenario: README has DSL docs
- **WHEN** user reads the README
- **THEN** it documents the `text` macro for use in `defmodel` forms

### Requirement: README includes usage examples
The README SHALL include working code examples for each new capability.

#### Scenario: README has positioning example
- **WHEN** user reads the README
- **THEN** there is a code example showing text on a rotated plane
