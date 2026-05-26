## ADDED Requirements

### Requirement: Fix small faces on shape
The system SHALL detect and remove small faces on a shape via `ShapeFix_FixSmallFace`.

#### Scenario: Small face removed
- **WHEN** a shape with a small face is processed
- **THEN** the result SHALL have the small face removed

#### Scenario: No small faces returns shape unchanged
- **WHEN** a clean box is processed
- **THEN** the result SHALL be a valid shape

#### Scenario: Null input returns nil
- **WHEN** a null shape is processed
- **THEN** the result SHALL be nil
