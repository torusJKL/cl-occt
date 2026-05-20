## ADDED Requirements

### Requirement: Create interactive text label
User SHALL be able to create a 3D text annotation via `AIS_TextLabel` that is displayed in the AIS interactive context. These labels SHALL NOT be included when exporting to STL or STEP.

#### Scenario: Create and display a text label
- **WHEN** user calls `(make-ais-text-label "My Label")` then `(ais-display context label)`
- **THEN** system displays the label "My Label" in the viewer

#### Scenario: Text label is not exported to STL
- **WHEN** user calls `(export-stl label "output.stl")`
- **THEN** system returns nil or signals error — labels are not exportable shapes

### Requirement: Set text label attributes
User SHALL be able to set text, position, font, color, and height on an `ais-text-label`.

#### Scenario: Set label text and position
- **WHEN** user creates a label with `(make-ais-text-label "Label" :position '(10 20 30) :color '(1 0 0))`
- **THEN** system returns a label with the specified attributes

#### Scenario: Update label text
- **WHEN** user calls `(setf (ais-text-label-text label) "Updated Text")`
- **THEN** the label display updates to show "Updated Text"

### Requirement: Free text label
User SHALL be able to free an `ais-text-label` to release its underlying OCCT resources.

#### Scenario: Free a label
- **WHEN** user calls `(ais-free-text-label label)`
- **THEN** label pointer is released and label is no longer valid
