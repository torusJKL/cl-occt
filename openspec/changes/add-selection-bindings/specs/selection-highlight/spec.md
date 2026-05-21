## ADDED Requirements

### Requirement: Manual selection highlight control
The system SHALL allow manually triggering highlight and unhighlight of selected objects, with an option to update the viewer immediately.

#### Scenario: Hilight selected highlights objects
- **WHEN** `ais-hilight-selected` is called with a context that has selected objects
- **THEN** the selected objects are highlighted in the viewer

#### Scenario: Unhilight selected removes highlight
- **WHEN** `ais-unhilight-selected` is called with a context that has highlighted selected objects
- **THEN** the highlight is removed from the selected objects

#### Scenario: Update parameter controls redraw
- **WHEN** `ais-hilight-selected` is called with `:update t` (default)
- **THEN** the viewer is redrawn after highlighting

#### Scenario: Update nil skips redraw
- **WHEN** `ais-hilight-selected` is called with `:update nil`
- **THEN** highlighting occurs without an immediate viewer redraw
