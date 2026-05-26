## ADDED Requirements

### Requirement: Create and manage XCAF documents

The system SHALL provide a CLOS class `xcaf-doc` wrapping an OCCT XCAF document handle, with automatic GC finalization. Documents SHALL be created via `XCAFApp_Application`.

#### Scenario: Create a new XCAF document
- **WHEN** user calls `(make-xcaf-doc)`
- **THEN** system returns an `xcaf-doc` instance backed by an OCCT document

#### Scenario: Create a named XCAF document
- **WHEN** user calls `(make-xcaf-doc "MyDoc")`
- **THEN** system returns an `xcaf-doc` instance with the given format name

#### Scenario: Free XCAF document
- **WHEN** user calls `(xcaf-free-doc doc)` on an existing `xcaf-doc`
- **THEN** system frees the underlying OCCT document handle

#### Scenario: Nil document returns nil
- **WHEN** user calls any xcaf-* function with nil
- **THEN** system returns nil

### Requirement: Manage layers via XCAFDoc_LayerTool

The system SHALL support adding shapes to layers, querying layer assignments, and listing all layers in a document.

#### Scenario: Add shape to layer
- **WHEN** user calls `(xcaf-add-shape-to-layer doc shape "LayerName")`
- **THEN** system returns t on success

#### Scenario: Remove shape from layer
- **WHEN** user calls `(xcaf-remove-shape-from-layer doc shape "LayerName")`
- **THEN** system returns t on success

#### Scenario: Query layer assignment
- **WHEN** user calls `(xcaf-get-shape-layers doc shape)`
- **THEN** system returns a list of layer name strings

#### Scenario: List all layers
- **WHEN** user calls `(xcaf-list-layers doc)`
- **THEN** system returns a list of layer name strings

#### Scenario: Layer operation on nil shape
- **WHEN** user calls `(xcaf-add-shape-to-layer doc nil "Layer")`
- **THEN** system returns nil

### Requirement: Manage materials via XCAFDoc_MaterialTool

The system SHALL support setting and querying material properties (density, name) on shapes.

#### Scenario: Set material with name and density
- **WHEN** user calls `(xcaf-set-material doc shape "Steel" 7.85)`
- **THEN** system returns t on success

#### Scenario: Set density only
- **WHEN** user calls `(xcaf-set-density doc shape 2.7)`
- **THEN** system returns t on success

#### Scenario: Get material name
- **WHEN** user calls `(xcaf-get-material-name doc shape)`
- **THEN** system returns a string or nil

#### Scenario: Get material density
- **WHEN** user calls `(xcaf-get-density doc shape)`
- **THEN** system returns a double or nil

#### Scenario: Set material on nil shape
- **WHEN** user calls `(xcaf-set-material doc nil "Steel" 7.85)`
- **THEN** system returns nil

### Requirement: Manage dimensions and tolerances via XCAFDoc_DimTolTool

The system SHALL support creating and querying dimension and tolerance annotations on shapes.

#### Scenario: Add dimension
- **WHEN** user calls `(xcaf-add-dimension doc shape value name)`
- **THEN** system returns t on success

#### Scenario: Get dimensions
- **WHEN** user calls `(xcaf-get-dimensions doc shape)`
- **THEN** system returns a list of dimension plists

### Requirement: Manage saved views via XCAFDoc_ViewTool

The system SHALL support saving and restoring named views in a document.

#### Scenario: Add a saved view
- **WHEN** user calls `(xcaf-add-view doc "Front" view-data)`
- **THEN** system returns t on success

#### Scenario: Get saved views
- **WHEN** user calls `(xcaf-get-views doc)`
- **THEN** system returns a list of view plists

### Requirement: Manage notes via XCAFDoc_NotesTool

The system SHALL support adding and querying textual notes on shapes.

#### Scenario: Add note to shape
- **WHEN** user calls `(xcaf-add-note doc shape "Note text")`
- **THEN** system returns t on success

#### Scenario: Get notes
- **WHEN** user calls `(xcaf-get-notes doc shape)`
- **THEN** system returns a list of note strings

### Requirement: Manage visual materials via XCAFDoc_VisMaterialTool

The system SHALL support setting and querying visual material properties (PBR, transparency, color) on shapes.

#### Scenario: Set visual material
- **WHEN** user calls `(xcaf-set-visual-material doc shape name &key color transparency)`
- **THEN** system returns t on success

#### Scenario: Get visual material
- **WHEN** user calls `(xcaf-get-visual-material doc shape)`
- **THEN** system returns a material plist or nil

### Requirement: Manage clipping planes via XCAFDoc_ClippingPlaneTool

The system SHALL support defining and querying clipping planes in a document.

#### Scenario: Add clipping plane
- **WHEN** user calls `(xcaf-add-clipping-plane doc plane-name origin direction)`
- **THEN** system returns t on success

#### Scenario: Get clipping planes
- **WHEN** user calls `(xcaf-get-clipping-planes doc)`
- **THEN** system returns a list of clipping plane plists

### Requirement: Document editing via XCAFDoc_Editor

The system SHALL support document-level editing operations: undo, redo, commit, and rollback.

#### Scenario: Begin edit session
- **WHEN** user calls `(xcaf-begin-edit doc)`
- **THEN** system returns t on success

#### Scenario: Commit edit session
- **WHEN** user calls `(xcaf-commit-edit doc)`
- **THEN** system returns t on success

#### Scenario: Undo last edit
- **WHEN** user calls `(xcaf-undo-edit doc)`
- **THEN** system returns t on success

#### Scenario: Redo last undo
- **WHEN** user calls `(xcaf-redo-edit doc)`
- **THEN** system returns t on success

#### Scenario: Undo count
- **WHEN** user calls `(xcaf-undo-count doc)`
- **THEN** system returns an integer count of available undo operations

### Requirement: API documentation for XCAF document tools

The system SHALL include a complete API reference section for all XCAF document tools in `docs/api-reference.md`.

#### Scenario: XCAF section exists
- **WHEN** user inspects `docs/api-reference.md`
- **THEN** document contains an "XCAF Document Tools" section with all public functions listed
