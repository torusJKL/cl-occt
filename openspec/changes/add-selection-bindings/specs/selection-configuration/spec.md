## ADDED Requirements

### Requirement: Fit camera to selected objects
The system SHALL allow fitting the camera view to the bounding box of all selected objects.

#### Scenario: Fit selected adjusts camera
- **WHEN** `ais-fit-selected` is called with a context, viewer, and margin
- **THEN** the camera is adjusted to frame the selected objects

### Requirement: Detected object querying
The system SHALL allow querying and clearing detected (pre-selection) objects.

#### Scenario: Has detected returns status
- **WHEN** `ais-move-to` has detected objects and `ais-has-detected` is called
- **THEN** it returns a truthy value

#### Scenario: Detected interactive returns object
- **WHEN** `ais-has-detected` returns true and `ais-detected-interactive` is called
- **THEN** it returns an `ais-object` instance

#### Scenario: Clear detected resets detection
- **WHEN** `ais-clear-detected` is called
- **THEN** `ais-has-detected` returns nil

### Requirement: Selection sensitivity configuration
The system SHALL allow configuring per-object selection sensitivity and global pixel tolerance.

#### Scenario: Set selection sensitivity accepts mode and value
- **WHEN** `ais-set-selection-sensitivity` is called with a context, object, mode, and sensitivity value
- **THEN** the selection sensitivity is configured for that object and mode

#### Scenario: Set pixel tolerance
- **WHEN** `ais-set-pixel-tolerance` is called with a context and pixel count
- **THEN** the pixel tolerance is configured for mouse detection

### Requirement: Automatic highlight toggles
The system SHALL allow enabling or disabling automatic highlighting behavior.

#### Scenario: Set automatic hilight
- **WHEN** `ais-set-automatic-hilight` is called with a context and a boolean
- **THEN** automatic highlighting is enabled or disabled

#### Scenario: Set to hilight selected
- **WHEN** `ais-set-to-hilight-selected` is called with a context and a boolean
- **THEN** the hilight-selected-on-detection behavior is enabled or disabled
