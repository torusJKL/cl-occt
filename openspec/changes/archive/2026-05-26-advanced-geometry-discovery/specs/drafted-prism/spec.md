## ADDED Requirements

### Requirement: Create drafted prism feature
The system SHALL create a drafted prismatic feature (additive or subtractive) on a shape via `BRepFeat_MakeDPrism`.

#### Scenario: Additive drafted prism
- **WHEN** a drafted prism is created from a face with a profile, height, and draft angle
- **THEN** the result SHALL be a valid shape with the prism added

#### Scenario: Subtractive drafted prism
- **WHEN** a drafted prism is created with a subtractive operation
- **THEN** the result SHALL be a valid shape with material removed

#### Scenario: Invalid input returns nil
- **WHEN** a null shape or face is provided
- **THEN** the result SHALL be nil
