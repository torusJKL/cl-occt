## ADDED Requirements

### Requirement: Enumerate system fonts
User SHALL be able to enumerate all available system fonts. The system SHALL return a list of font names that can be passed to `make-brep-font-from-name`.

#### Scenario: List all available fonts
- **WHEN** user calls `(list-available-fonts)`
- **THEN** system returns a list of strings, one per available system font

#### Scenario: List is non-nil when fonts exist
- **WHEN** user calls `(list-available-fonts)`
- **THEN** system returns a list containing at least "Arial" or the system default font

### Requirement: Query font information
User SHALL be able to query details about a font, such as its family, style attributes, and whether it is scalable.

#### Scenario: Query font info
- **WHEN** user calls `(font-info "Arial")`
- **THEN** system returns a plist with `:family`, `:aspect`, `:scalable` keys
