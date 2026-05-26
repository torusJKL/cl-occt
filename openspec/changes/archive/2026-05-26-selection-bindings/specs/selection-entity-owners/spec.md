## ADDED Requirements

### Requirement: Entity owner access from selection iteration
The system SHALL allow retrieving the `SelectMgr_EntityOwner` during selection iteration, and querying its properties.

#### Scenario: Selected owner returns entity-owner
- **WHEN** `ais-selected-owner` is called during selection iteration with a selected object
- **THEN** it returns an `entity-owner` instance

#### Scenario: Selected owner returns nil when no selection
- **WHEN** `ais-selected-owner` is called with no selection active
- **THEN** it returns nil

#### Scenario: Owner priority query
- **WHEN** `owner-priority` is called with an `entity-owner` instance
- **THEN** it returns an integer representing the selection priority

#### Scenario: Owner selection mode query
- **WHEN** `owner-selection-mode` is called with an `entity-owner` instance
- **THEN** it returns an integer representing the selection mode

### Requirement: BRepOwner shape extraction
The system SHALL allow extracting the underlying `TopoDS_Shape` from a `StdSelect_BRepOwner` and querying its properties.

#### Scenario: BRepOwner shape extraction
- **WHEN** `brep-owner-shape` is called with a `brep-owner` instance that holds a shape
- **THEN** it returns a `shape` instance

#### Scenario: BRepOwner with no shape returns nil
- **WHEN** `brep-owner-shape` is called with a `brep-owner` that holds no shape
- **THEN** it returns nil

#### Scenario: Owner priority on brep-owner
- **WHEN** `owner-priority` is called with a `brep-owner` instance
- **THEN** it returns an integer representing the selection priority (inherited from `entity-owner`)

#### Scenario: Owner location query
- **WHEN** `owner-location` is called with a `brep-owner` instance
- **THEN** it returns a 4×4 transformation matrix as `#(16 double-floats)` or nil for identity

### Requirement: Entity-owner predicate
The system SHALL provide predicates for owner type detection.

#### Scenario: entity-owner-p returns t
- **WHEN** `entity-owner-p` is called with an `entity-owner` or `brep-owner` instance
- **THEN** it returns a truthy value

#### Scenario: brep-owner-p returns t
- **WHEN** `brep-owner-p` is called with a `brep-owner` instance
- **THEN** it returns a truthy value

#### Scenario: brep-owner-p returns nil for base entity-owner
- **WHEN** `brep-owner-p` is called with a plain `entity-owner` (non-BRep)
- **THEN** it returns nil

### Requirement: Owner disposal
The system SHALL allow freeing entity-owner C handles explicitly.

#### Scenario: Free owner handle
- **WHEN** `free-owner` is called with an entity-owner instance
- **THEN** the owner's C handle is freed and the pointer is set to null
- **THEN** subsequent predicate calls return nil

### Requirement: Reject nil on degenerate inputs
All entity-owner functions SHALL return nil when given invalid or nil inputs.

#### Scenario: nil input returns nil
- **WHEN** any entity-owner function receives nil
- **THEN** it returns nil
