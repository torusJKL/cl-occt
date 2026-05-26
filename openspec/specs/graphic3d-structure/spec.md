## ADDED Requirements

### Requirement: Create and free graphic structure
The system SHALL create a `Graphic3d_Structure` associated with a graphic driver or viewer, and free it. This is a handle-based type with `tg:finalize` GC.

#### Scenario: Create structure
- **WHEN** user calls `(make-graphic-structure viewer)`
- **THEN** returns a `graphic-structure` instance with non-null internal handle

#### Scenario: Free structure
- **WHEN** user calls `(free-graphic-structure gs)`
- **THEN** the internal C handle is freed

#### Scenario: Double-free safety
- **WHEN** user calls `(free-graphic-structure gs)` twice
- **THEN** the second call does not crash

### Requirement: Set structure visibility
The system SHALL show or hide a graphic structure.

#### Scenario: Set visible
- **WHEN** user calls `(set-graphic-structure-visible gs t)`
- **THEN** the structure is displayed in the viewer

#### Scenario: Set invisible
- **WHEN** user calls `(set-graphic-structure-visible gs nil)`
- **THEN** the structure is hidden

### Requirement: Set structure transform
The system SHALL apply a 4x4 transformation matrix to a graphic structure.

#### Scenario: Set transform
- **WHEN** user calls `(set-graphic-structure-transform gs matrix)`
- **THEN** the structure's vertices are transformed by the matrix

#### Scenario: Remove transform
- **WHEN** user calls `(remove-graphic-structure-transform gs)`
- **THEN** the structure's identity transform is restored

### Requirement: Structure hierarchy
The system SHALL support parent-child relationships between structures.

#### Scenario: Add child
- **WHEN** user calls `(graphic-structure-add-child parent child)`
- **THEN** child becomes a sub-structure of parent

#### Scenario: Remove child
- **WHEN** user calls `(graphic-structure-remove-child parent child)`
- **THEN** child is detached from parent

### Requirement: Display in viewer
The system SHALL display a graphic structure in a viewer or remove it.

#### Scenario: Display
- **WHEN** user calls `(graphic-structure-display gs viewer)`
- **THEN** the structure appears in the viewer

#### Scenario: Remove
- **WHEN** user calls `(graphic-structure-erase gs)`
- **THEN** the structure is removed from all viewers

### Requirement: Predicate
The system SHALL provide a predicate for `graphic-structure` instances.

#### Scenario: graphic-structure-p
- **WHEN** user calls `(graphic-structure-p (make-graphic-structure viewer))`
- **THEN** returns `t`
- **WHEN** user calls `(graphic-structure-p nil)`
- **THEN** returns `nil`
