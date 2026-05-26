## ADDED Requirements

### Requirement: Name shapes with topological naming
The system SHALL name (tag) a shape on a label using `TNaming_Builder`, and retrieve the named shape using `TNaming_NamedShape`.

#### Scenario: Name a shape
- **WHEN** user calls `(ocaf-name-shape label shape :current)`
- **THEN** associates the shape with the label under the CURRENT evolution

#### Scenario: Retrieve named shape
- **WHEN** user calls `(ocaf-get-named-shape label)`
- **THEN** returns the shape stored on that label

### Requirement: Track shape identity through operations
The system SHALL track how a shape's subshapes evolve through Boolean operations using `TNaming` evolutions (SELECTED, GENERATED, DELETED, MODIFIED).

#### Scenario: Select a face before boolean
- **WHEN** user calls `(ocaf-name-shape label selected-face :selected)` before a cut
- **THEN** the label records the face as SELECTED

#### Scenario: Find generated shape after boolean
- **WHEN** user calls `(ocaf-get-named-shape label :generated)` after an operation
- **THEN** returns the shape(s) generated from the originally named shape

#### Scenario: Check if shape was deleted
- **WHEN** user calls `(ocaf-shape-deleted-p label)`
- **THEN** returns t if the named shape was deleted by a subsequent operation
