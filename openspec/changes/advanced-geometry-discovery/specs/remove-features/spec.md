## ADDED Requirements

### Requirement: Remove features from shape
The system SHALL remove specified features (holes, protrusions) from a shape via `BRepAlgoAPI_RemoveFeatures`.

#### Scenario: Remove hole from face
- **WHEN** a hole is removed from a face
- **THEN** the result SHALL be a face without the hole

#### Scenario: Multiple features removed
- **WHEN** multiple features are removed from a shape
- **THEN** the result SHALL have all specified features removed

#### Scenario: Null input returns nil
- **WHEN** a null shape is provided
- **THEN** the result SHALL be nil
