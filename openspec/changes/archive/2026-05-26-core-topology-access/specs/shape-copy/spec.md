## ADDED Requirements

### Requirement: Deep shape copy
The system SHALL provide a function to create an independent deep copy of any shape via `BRepBuilderAPI_Copy`.

#### Scenario: Box copy is independent
- **WHEN** a box is copied and the original is modified (e.g., translated)
- **THEN** the copy SHALL remain at the original position

#### Scenario: Copy preserves geometry
- **WHEN** a box of dimensions 10x20x30 is copied
- **THEN** the copy SHALL have the same volume and face count as the original

#### Scenario: Copy has independent GC
- **WHEN** the original shape is freed (via GC or explicitly)
- **THEN** the copy SHALL remain valid

#### Scenario: Null shape returns nil
- **WHEN** a null shape is copied
- **THEN** the result SHALL be nil

#### Scenario: Copied shape can be used in boolean operations
- **WHEN** a copy of a box is used in a fuse operation with another shape
- **THEN** the operation SHALL succeed and produce a valid result
