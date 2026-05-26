## ADDED Requirements

### Requirement: Attach typed data to labels
The system SHALL attach and retrieve standard attributes (Integer, Real, String) to/from labels using `TDataStd_Integer`, `TDataStd_Real`, `TDataStd_AsciiString`.

#### Scenario: Set and get integer attribute
- **WHEN** user calls `(ocaf-set-integer label 42)` then `(ocaf-get-integer label)`
- **THEN** returns 42

#### Scenario: Set and get real attribute
- **WHEN** user calls `(ocaf-set-real label 3.14)` then `(ocaf-get-real label)`
- **THEN** returns 3.14d0

#### Scenario: Set and get string attribute
- **WHEN** user calls `(ocaf-set-string label "hello")` then `(ocaf-get-string label)`
- **THEN** returns "hello"

#### Scenario: Has attribute predicate
- **WHEN** user calls `(ocaf-has-integer-p label)` or `(ocaf-has-real-p label)` or `(ocaf-has-string-p label)`
- **THEN** returns t if the attribute exists on that label

#### Scenario: Remove attribute
- **WHEN** user calls `(ocaf-remove-attribute label 'integer)`
- **THEN** returns t and subsequent has-p returns nil

### Requirement: Named attributes via TDataStd_Name
The system SHALL support named attributes for any label.

#### Scenario: Set and get name
- **WHEN** user calls `(ocaf-set-name label "MyLabel")` then `(ocaf-get-name label)`
- **THEN** returns "MyLabel"
