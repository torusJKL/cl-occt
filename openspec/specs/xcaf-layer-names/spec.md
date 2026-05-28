## ADDED Requirements

### Requirement: Retrieve layer names from XCAF documents

`xcaf-get-shape-layers` SHALL return a list of layer name strings for a shape in an XCAF document. The system SHALL use `XCAFDoc_LayerTool` to iterate layer labels and extract names via `TDataStd_Name`.

#### Scenario: Shape assigned to one layer
- **WHEN** user calls `(xcaf-add-shape-to-layer doc shape "Design")` then `(xcaf-get-shape-layers doc shape)`
- **THEN** system returns `("Design")`

#### Scenario: Shape assigned to multiple layers
- **WHEN** user calls `(xcaf-add-shape-to-layer doc shape "LayerA")` and `(xcaf-add-shape-to-layer doc shape "LayerB")` then `(xcaf-get-shape-layers doc shape)`
- **THEN** system returns `("LayerA" "LayerB")`

#### Scenario: Shape with no layers
- **WHEN** user calls `(xcaf-get-shape-layers doc shape)` on a shape with no layer assignments
- **THEN** system returns `nil`

#### Scenario: Nil document or shape returns nil
- **WHEN** user calls `(xcaf-get-shape-layers nil shape)` or `(xcaf-get-shape-layers doc nil)`
- **THEN** system returns `nil`

### Requirement: Docstring follows Markdown convention

`xcaf-get-shape-layers` SHALL have a docstring formatted per the `docstring-markdown-convention` spec, with `- **doc**`, `- **shape**` parameter entries, `**Returns:**` listing `` `nil` `` or a list of strings, and an `**Example:**` section.

#### Scenario: Docstring has parameters, returns, and example
- **WHEN** user inspects the `xcaf-get-shape-layers` docstring via `(describe 'xcaf-get-shape-layers)`
- **THEN** it SHALL contain `- **doc**` and `- **shape**` parameter descriptions
- **AND** it SHALL contain `**Returns:**`
- **AND** it SHALL contain `**Example:**` with at least one 4-space-indented usage example
