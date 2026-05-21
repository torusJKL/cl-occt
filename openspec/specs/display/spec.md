## EXTENDED BY

The display capabilities are extended by:
- `viewer-object-props` — per-object transparency, material presets, custom materials, line width, edges, selection mode, tessellation
- `viewer-drawer` — line / point / text / shading aspect control via ais-set-drawer-* functions

## ADDED Requirements

### Requirement: Create AIS context
The system SHALL create an `AIS_InteractiveContext` from a `V3d_Viewer` handle, wrapped in a heap-allocated `Handle<>*`. The context SHALL manage display and removal of interactive objects.

#### Scenario: Context from viewer
- **WHEN** user calls `(ais-create-context viewer-instance)`
- **THEN** system returns an `ais-context` instance with non-null internal handle

### Requirement: Create AIS shape
The system SHALL create an `AIS_Shape` from a `TopoDS_Shape` handle, returned as an `Handle(AIS_InteractiveObject)*` for polymorphic AIS operations.

#### Scenario: AIS shape from box
- **WHEN** user calls `(ais-create-shape (make-box 10 20 30))`
- **THEN** system returns an `ais-object` instance with non-null internal handle

#### Scenario: AIS shape from nil
- **WHEN** user calls `(ais-create-shape nil)`
- **THEN** system returns nil

### Requirement: Display object in context
The system SHALL display an interactive object in the context, making it visible in all associated views. The display function SHALL accept both `shape` instances (auto-creating the AIS_Shape) and `ais-object` instances.

#### Scenario: Display shape
- **WHEN** user calls `(ais-display context (make-box 10 20 30))`
- **THEN** system returns an `ais-object` that is displayed in the context

#### Scenario: Display ais-object
- **WHEN** user calls `(ais-display context existing-ais-object)`
- **THEN** the existing ais-object is displayed

### Requirement: Query display status
The system SHALL report whether an `ais-object` is currently displayed in a given context.

#### Scenario: Is displayed after display
- **WHEN** user calls `(ais-displayed-p context obj)` after `(ais-display context obj)`
- **THEN** system returns `t`

#### Scenario: Not displayed after erase
- **WHEN** user calls `(ais-displayed-p context obj)` after `(ais-erase context obj)`
- **THEN** system returns `nil`

### Requirement: Erase object
The system SHALL hide an object from view without removing it from the context. The object SHALL remain available for re-display.

### Requirement: Remove object
The system SHALL permanently remove an object from the context. The object's Lisp `ais-object` handle SHALL remain valid for `ais-free` but not for re-display.

### Requirement: Remove all objects
The system SHALL remove all objects from the context in one operation.

### Requirement: Free ais-object
The system SHALL provide explicit `ais-free` to delete the C `Handle<>*` immediately. The system SHALL also provide `tg:finalize` as a GC safety net.

#### Scenario: Double-free safety
- **WHEN** user calls `(ais-free obj)` twice
- **THEN** no crash occurs on the second call
