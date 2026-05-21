## ADDED Requirements

### Requirement: Mouse detection via MoveTo
The system SHALL allow detecting objects under a screen-space pixel coordinate.

#### Scenario: Move to returns detection status
- **WHEN** `ais-move-to` is called with a context, viewer, and pixel coordinates
- **THEN** it returns an integer status code corresponding to `AIS_StatusOfDetection`

#### Scenario: Move to returns several-good when over displayed shapes
- **WHEN** a shape is displayed in the context and `ais-move-to` is called with coordinates over that shape
- **THEN** the returned status is the integer for `:several-good` or `:only-one-good`

### Requirement: Selection from detected objects
The system SHALL allow confirming detected objects as selected using a selection scheme.

#### Scenario: Select detected confirms detection
- **WHEN** `ais-move-to` has detected an object and `ais-select-detected` is called with a scheme keyword
- **THEN** the detected object becomes selected

#### Scenario: Select detected returns pick status
- **WHEN** `ais-select-detected` is called
- **THEN** it returns an integer status code corresponding to `AIS_StatusOfPick`

### Requirement: Point-based selection
The system SHALL allow selecting objects by screen-space point coordinates with a selection scheme.

#### Scenario: Select point selects topmost object
- **WHEN** `ais-select-point` is called with a context, viewer, pixel coordinates, and scheme
- **THEN** the topmost object at that point is selected (or deselected, depending on scheme)

#### Scenario: Select point returns pick status
- **WHEN** `ais-select-point` is called
- **THEN** it returns an integer status code corresponding to `AIS_StatusOfPick`

### Requirement: Selection scheme keyword map
The system SHALL provide `*selection-scheme-map*` mapping keywords to OCCT `AIS_SelectionScheme` integer values: `:replace` (0), `:add` (1), `:remove` (2), `:xor` (3), `:clear` (4), `:replace-extra` (5).

#### Scenario: Scheme map contains all entries
- **WHEN** `*selection-scheme-map*` is inspected
- **THEN** it contains all six scheme mappings

### Requirement: Status code keyword maps
The system SHALL provide `*status-of-detection-map*` and `*status-of-pick-map*` for decoding integer status return values to keywords.

#### Scenario: Detection map available
- **WHEN** `*status-of-detection-map*` is inspected
- **THEN** it contains all `AIS_StatusOfDetection` values

#### Scenario: Pick map available
- **WHEN** `*status-of-pick-map*` is inspected
- **THEN** it contains all `AIS_StatusOfPick` values
