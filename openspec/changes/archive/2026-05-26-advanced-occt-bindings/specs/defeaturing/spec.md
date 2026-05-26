## ADDED Requirements

### Requirement: Remove features from a shape by face selection
The system SHALL provide a function to remove features from a shape by specifying a list of faces to remove, using `BRepAlgoAPI_Defeaturing`.

#### Scenario: Defeature a box by removing a face
- **WHEN** a user creates a shape and calls `defeature-shape` with a list of faces to remove
- **THEN** the system returns a shape with those features removed

#### Scenario: Defeature with nil shape
- **WHEN** a user calls `defeature-shape` with a nil shape
- **THEN** the system returns nil

#### Scenario: Defeature with empty face list
- **WHEN** a user calls `defeature-shape` with a valid shape but empty face list
- **THEN** the system returns the original shape unchanged

#### Scenario: Defeature removes multiple features
- **WHEN** a user calls `defeature-shape` with multiple faces from different features
- **THEN** the system removes all specified features and returns the result
