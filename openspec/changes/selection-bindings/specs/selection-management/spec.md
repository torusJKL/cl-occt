## ADDED Requirements

### Requirement: Entity owner access from selection iteration
The system SHALL allow retrieving the entity owner during selection iteration via `ais-selected-owner`.

#### Scenario: Selected owner returns owner
- **WHEN** `ais-selected-owner` is called during selection iteration with a selected object
- **THEN** it returns an `entity-owner` instance wrapping the underlying `SelectMgr_EntityOwner`

#### Scenario: Selected owner nil on no selection
- **WHEN** `ais-selected-owner` is called with no selection active
- **THEN** it returns nil

#### Scenario: BRepOwner shape extraction during iteration
- **WHEN** `ais-selected-owner` returns a `brep-owner` during selection of an AIS shape
- **THEN** `brep-owner-shape` extracts the underlying `TopoDS_Shape`
