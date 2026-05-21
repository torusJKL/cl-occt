## ADDED Requirements

### Requirement: Programmatic selection of displayed AIS objects
The system SHALL allow selecting, deselecting, and querying selection state of displayed AIS objects through the AIS context.

#### Scenario: Set selected replaces current selection
- **WHEN** `ais-set-selected` is called with a context and displayed AIS object
- **THEN** the object becomes selected and `ais-nb-selected` returns 1

#### Scenario: Add or remove selected toggles selection
- **WHEN** `ais-add-or-remove-selected` is called with a context and selected AIS object
- **THEN** the object becomes deselected and `ais-nb-selected` decrements by 1

#### Scenario: Clear selected deselects all
- **WHEN** `ais-clear-selected` is called with a context that has selected objects
- **THEN** `ais-nb-selected` returns 0

#### Scenario: Is selected queries selection state
- **WHEN** `ais-is-selected` is called with a context and a selected AIS object
- **THEN** it returns a truthy value

#### Scenario: Is selected returns false for non-selected
- **WHEN** `ais-is-selected` is called with a context and a non-selected AIS object
- **THEN** it returns nil

### Requirement: Selection iteration over selected objects
The system SHALL allow iterating over selected objects using the imperative InitSelected/MoreSelected/NextSelected pattern, and provide convenience functions that collect results into lists.

#### Scenario: Init/more/next iteration
- **WHEN** `ais-init-selected` is called, then `ais-more-selected` returns true, then `ais-next-selected` advances
- **THEN** the iteration traverses all selected objects

#### Scenario: Nb selected returns count
- **WHEN** multiple objects are selected
- **THEN** `ais-nb-selected` returns the correct count

#### Scenario: Selected objects convenience
- **WHEN** `ais-selected-objects` is called with a context that has selected AIS objects
- **THEN** it returns a list of `ais-object` instances, one per selected object

#### Scenario: Selected shapes convenience
- **WHEN** `ais-selected-shapes` is called with a context that has selected shapes
- **THEN** it returns a list of `shape` instances

### Requirement: Shape extraction from selection
The system SHALL allow extracting the underlying `TopoDS_Shape` from a selected interactive object when the selected owner holds a BRep shape.

#### Scenario: Has selected shape returns true for shape selections
- **WHEN** an AIS shape is displayed and selected
- **THEN** `ais-has-selected-shape` returns a truthy value

#### Scenario: Selected shape returns shape
- **WHEN** `ais-selected-shape` is called for a selected AIS shape
- **THEN** it returns a `shape` instance representing the underlying OCCT shape

### Requirement: Non-owning handle wrappers for selection queries
Calls to `ais-selected-interactive` SHALL return `ais-object` instances whose finalization is safe with respect to context ownership.

#### Scenario: Selected interactive returns ais-object
- **WHEN** `ais-selected-interactive` is called during iteration over selected objects
- **THEN** it returns an `ais-object` instance wrapping the selected interactive object
