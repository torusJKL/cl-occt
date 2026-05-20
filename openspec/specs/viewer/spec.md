## ADDED Requirements

### Requirement: Create graphic driver
The system SHALL create an OCCT `OpenGl_GraphicDriver` wrapped in a heap-allocated `Handle<>*`. The driver SHALL use the default platform display connection.

### Requirement: Create viewer
The system SHALL create a `V3d_Viewer` from a graphic driver handle. The viewer SHALL own the default lights and coordinate system.

### Requirement: Create view
The system SHALL create a `V3d_View` from a viewer handle. The view SHALL accept a native window handle for rendering.

### Requirement: Wrap native window
The system SHALL accept an opaque native window pointer and wrap it in an `Aspect_NeutralWindow` for OCCT rendering.

### Requirement: Viewer CLOS lifecycle
The Lisp API SHALL compose driver + viewer + view into a single `viewer` CLOS object with `tg:finalize` GC. An explicit `free-viewer` SHALL also be available.

#### Scenario: Create and free viewer
- **WHEN** user calls `(make-viewer)`
- **THEN** system returns a `viewer` instance with non-null internal handles
- **WHEN** user calls `(free-viewer v)`
- **THEN** all internal C handles are freed

#### Scenario: with-viewer macro
- **WHEN** user calls `(with-viewer (v) (fit-all v))`
- **THEN** a viewer is created before the body and freed after, even if body signals an error

#### Scenario: Double-free safety
- **WHEN** user calls `(free-viewer v)` twice
- **THEN** the second call does not crash (null-pointer check before delete)

### Requirement: Fit all
The system SHALL fit the view to show all displayed objects.

#### Scenario: Fit all after viewer creation
- **WHEN** user creates a viewer and calls `(fit-all v)`
- **THEN** no error occurs (may be a no-op with nothing displayed yet)
