## ADDED Requirements

### Requirement: Edge filter creation and usage
The system SHALL allow creating an edge filter (`StdSelect_EdgeFilter`) that restricts selection to edges only.

#### Scenario: Create edge filter
- **WHEN** `make-edge-filter` is called
- **THEN** it returns an `edge-filter` instance with a valid C pointer

#### Scenario: Add edge filter to context
- **WHEN** `ais-add-filter` is called with a context and an edge filter
- **THEN** the edge filter is activated, restricting selection to edges

#### Scenario: Remove edge filter from context
- **WHEN** `ais-remove-filter` is called with a context and an edge filter
- **THEN** the edge filter is deactivated, restoring full selection

### Requirement: Face filter creation and usage
The system SHALL allow creating a face filter (`StdSelect_FaceFilter`) that restricts selection to faces only.

#### Scenario: Create face filter
- **WHEN** `make-face-filter` is called
- **THEN** it returns a `face-filter` instance with a valid C pointer

#### Scenario: Add face filter to context
- **WHEN** `ais-add-filter` is called with a context and a face filter
- **THEN** the face filter is activated, restricting selection to faces

### Requirement: Shape type filter creation and configuration
The system SHALL allow creating a shape type filter (`StdSelect_ShapeTypeFilter`) with configurable allowed shape types.

#### Scenario: Create shape type filter
- **WHEN** `make-shape-type-filter` is called
- **THEN** it returns a `shape-type-filter` instance

#### Scenario: Set allowed shape type on filter
- **WHEN** `set-filter-shape-type` is called with a shape type filter and a keyword (`:edge`, `:face`, `:wire`, `:vertex`, `:shell`, `:solid`)
- **THEN** the filter restricts selection to that shape type only

#### Scenario: Set multiple allowed types
- **WHEN** `set-filter-allowed-types` is called with a shape type filter and a list of keywords
- **THEN** the filter restricts selection to any of those shape types

### Requirement: Filter predicate
The system SHALL provide predicates for filter type detection.

#### Scenario: selection-filter-p returns t
- **WHEN** `selection-filter-p` is called with any filter instance
- **THEN** it returns a truthy value

#### Scenario: edge-filter-p returns t for edge filter
- **WHEN** `edge-filter-p` is called with an `edge-filter` instance
- **THEN** it returns a truthy value

#### Scenario: face-filter-p returns t for face filter
- **WHEN** `face-filter-p` is called with a `face-filter` instance
- **THEN** it returns a truthy value

#### Scenario: shape-type-filter-p returns t for shape type filter
- **WHEN** `shape-type-filter-p` is called with a `shape-type-filter` instance
- **THEN** it returns a truthy value

### Requirement: Filter disposal
The system SHALL allow freeing filter C handles explicitly.

#### Scenario: Free filter handle
- **WHEN** `free-filter` is called with a filter instance
- **THEN** the filter's C handle is freed and the pointer is set to null
- **THEN** subsequent predicate calls return nil

### Requirement: Reject nil on degenerate inputs
All filter creation functions SHALL return nil when given invalid or nil inputs.

#### Scenario: nil input returns nil
- **WHEN** any filter function receives nil
- **THEN** it returns nil
