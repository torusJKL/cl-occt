## ADDED Requirements

### Requirement: Document all new AIS functions in api-reference.md
The system SHALL update `docs/api-reference.md` with all new function signatures, descriptions, parameter details, return values, and usage examples.

#### Scenario: New AIS types section added
- **WHEN** a user reads `docs/api-reference.md`
- **THEN** the document contains a section titled "AIS Interactive Types" with entries for all 13 new AIS classes

#### Scenario: Each function has a table entry
- **WHEN** a user reads the AIS Interactive Types section
- **THEN** each function is listed with its signature and description in a markdown table row

#### Scenario: Usage examples provided for each type
- **WHEN** a user reads the documentation
- **THEN** at least one Lisp REPL example exists per new AIS type
