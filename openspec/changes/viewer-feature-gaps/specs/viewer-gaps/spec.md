## ADDED Requirements

### Requirement: viewer-camera CLOS class
The system SHALL provide a `viewer-camera` CLOS class that captures the current camera state (eye, target, up, projection type, FOV) as Lisp data, and a `set-viewer-camera` function to apply captured state to a view.

#### Scenario: Capture camera from view
- **WHEN** user calls `(viewer-camera view)`
- **THEN** returns a `viewer-camera` instance with `%eye`, `%target`, `%up`, `%projection-type`, `%fov` slots

#### Scenario: Apply camera to view
- **WHEN** user calls `(set-viewer-camera view cam)`
- **THEN** the view's camera is set to match the viewer-camera's parameters

#### Scenario: Viewer-camera predicate
- **WHEN** user calls `(viewer-camera-p obj)`
- **THEN** returns `t` for viewer-camera instances, `nil` otherwise

### Requirement: Light enumeration
The system SHALL provide functions to list all lights and active lights registered in a viewer.

#### Scenario: List all lights
- **WHEN** user calls `(viewer-lights viewer)`
- **THEN** returns a list of all `viewer-light` instances registered in the viewer

#### Scenario: List active lights
- **WHEN** user calls `(viewer-active-lights viewer)`
- **THEN** returns a list of `viewer-light` instances that are currently on

### Requirement: Trihedron wireframe color
The system SHALL set the color of the trihedron's wireframe representation.

#### Scenario: Blue wireframe trihedron
- **WHEN** user calls `(set-trihedron-wireframe-color tri :blue)`
- **THEN** the wireframe trihedron renders in blue

### Requirement: Default drawer (blocked)
The system SHOULD provide `set-default-drawer` on the viewer. Note: `V3d_Viewer` in OCCT 8.0 does not have `SetDefaultDrawer`. The alternative is through `AIS_InteractiveContext::DefaultDrawer()`. This requirement is blocked by OCCT 8.0 API limitations.

### Requirement: Alias functions for spec conformance
The system SHALL provide alias functions where the spec name differs from the implementation name.

#### Scenario: set-cube-map alias
- **WHEN** user calls `(set-cube-map view :pos-x "px.jpg" ...)`
- **THEN** calls `set-background-cubemap` with the same arguments, returns the result

#### Scenario: set-transparent-shading alias
- **WHEN** user calls `(set-transparent-shading view method)`
- **THEN** calls `set-transparency-method` with the same argument, returns the result

#### Scenario: set-default-gradient alias
- **WHEN** user calls `(set-default-gradient viewer :top color1 :bottom color2)`
- **THEN** calls `set-default-bg-gradient` with the colors, returns the result

### Requirement: Grid convenience functions
The system SHALL provide `set-grid-color`, `set-grid-size` convenience functions that wrap the existing `grid-display` and `set-grid-xy-size` functions. Query functions (`grid-color`, `grid-size`, `grid-offset`) SHALL return nil (no OCCT query API available).

#### Scenario: Set grid color via convenience
- **WHEN** user calls `(set-grid-color viewer :grey)`
- **THEN** the grid renders with the specified color

#### Scenario: Set grid size via convenience
- **WHEN** user calls `(set-grid-size viewer 10.0)`
- **THEN** grid spacing is set to 10 units in both X and Y

#### Scenario: Query grid properties (stub)
- **WHEN** user calls `(grid-color viewer)` / `(grid-size viewer)` / `(grid-offset viewer)`
- **THEN** returns nil (query not supported by OCCT 8.0 API)

### Requirement: Dimension convenience keywords
The system SHALL accept `:edge` keyword for length dimensions and `:edge1`/`:edge2` for angle dimensions in `make-dimension`.

#### Scenario: Length dimension from edge
- **WHEN** user calls `(make-dimension :length :edge edge-obj)`
- **THEN** sets the measured edge on the length dimension

#### Scenario: Angle dimension from two edges
- **WHEN** user calls `(make-dimension :angle :edge1 edge-a :edge2 edge-b)`
- **THEN** sets the measured edges on the angle dimension

### Requirement: Dimension text/arrow/extension convenience
The system SHALL provide `set-dimension-text`, `set-dimension-arrows`, `set-dimension-extension` convenience functions.

#### Scenario: Custom dimension label
- **WHEN** user calls `(set-dimension-text dim "Length = 10 mm")`
- **THEN** the dimension displays the custom label

#### Scenario: Arrow style
- **WHEN** user calls `(set-dimension-arrows dim :style :filled :size 5.0)`
- **THEN** dimension arrows render with the specified style and size

#### Scenario: Extension line properties
- **WHEN** user calls `(set-dimension-extension dim :offset 5.0 :length 10.0)`
- **THEN** dimension extension lines use the specified offset and length

### Requirement: Selection mode keyword map
The system SHALL map keyword symbols to integer selection modes in `ais-set-selection-mode`.

#### Scenario: Select faces via keyword
- **WHEN** user calls `(ais-set-selection-mode ctx obj :face)`
- **THEN** selection mode 1 (face) is activated

#### Scenario: Select edges via keyword
- **WHEN** user calls `(ais-set-selection-mode ctx obj :edge)`
- **THEN** selection mode 2 (edge) is activated

#### Scenario: Select vertices via keyword
- **WHEN** user calls `(ais-set-selection-mode ctx obj :vertex)`
- **THEN** selection mode 3 (vertex) is activated

#### Scenario: Select shape via keyword
- **WHEN** user calls `(ais-set-selection-mode ctx obj :shape)`
- **THEN** selection mode 0 (shape) is activated

### Requirement: Text label alignment convenience
The system SHALL provide a unified `set-text-label-align` function that dispatches to `set-text-label-hjustification` and `set-text-label-vjustification`.

#### Scenario: Horizontal alignment via convenience
- **WHEN** user calls `(set-text-label-align label :horizontal :center)`
- **THEN** text is center-aligned horizontally

#### Scenario: Vertical alignment via convenience
- **WHEN** user calls `(set-text-label-align label :vertical :top)`
- **THEN** text is top-aligned vertically

#### Scenario: Combined alignment
- **WHEN** user calls `(set-text-label-align label :horizontal :left :vertical :bottom)`
- **THEN** text is left/bottom-aligned
