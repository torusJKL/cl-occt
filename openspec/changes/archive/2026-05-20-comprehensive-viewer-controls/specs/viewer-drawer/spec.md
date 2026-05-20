## ADDED Requirements

### Requirement: Access Prs3d_Drawer from any ais-object
The system SHALL provide access to the `Prs3d_Drawer` attribute set for any displayed object, returning a first-class `drawer` CLOS instance.

#### Scenario: Get drawer from ais-object
- **WHEN** user calls `(ais-drawer obj)`
- **THEN** returns a `drawer` instance that wraps the object's `Prs3d_Drawer` handle

### Requirement: Shading aspect access and modification
The system SHALL expose the shading aspect (`Graphic3d_AspectFillArea3d`) with interior color, back-face color, edge color, edge line type, edge width, and shading method.

#### Scenario: Set shading interior color
- **WHEN** user calls `(setf (shading-color drawer) :steel-blue)`
- **THEN** the object's surface color changes to steel blue

#### Scenario: Set shading edge color
- **WHEN** user calls `(setf (shading-edge-color drawer) '(0 0 0))`
- **THEN** the shading edges render in black

#### Scenario: Set shading method
- **WHEN** user calls `(setf (shading-method drawer) :fragment)`
- **THEN** the shading uses per-fragment (pixel) lighting

### Requirement: Line aspect access and modification
The system SHALL expose the line aspect (`Graphic3d_AspectLine3d`) with color, line type (solid/dash/dot/dot-dash), and width.

#### Scenario: Set line color
- **WHEN** user calls `(setf (line-color drawer) :red)`
- **THEN** the object's lines render in red

#### Scenario: Set dashed lines
- **WHEN** user calls `(setf (line-type drawer) :dash)`
- **THEN** lines render as dashed

#### Scenario: Set line width
- **WHEN** user calls `(setf (line-width drawer) 2.0)`
- **THEN** lines render at 2 pixels wide

### Requirement: Point (marker) aspect access and modification
The system SHALL expose the point aspect (`Graphic3d_AspectMarker3d`) with color, marker type, and scale.

#### Scenario: Set point color
- **WHEN** user calls `(setf (point-color drawer) :yellow)`
- **THEN** point markers render in yellow

#### Scenario: Set marker type
- **WHEN** user calls `(setf (point-type drawer) :x)`
- **THEN** vertices render as X markers

#### Scenario: Enumerate supported marker types
- **WHEN** user calls `(point-type drawer)`
- **THEN** returns `:point`, `:plus`, `:star`, `:o`, `:x`, `:ball`, or `:ring`

### Requirement: Text aspect access and modification
The system SHALL expose the text aspect (`Graphic3d_AspectText3d`) with color, font, height, style, angle, and display type.

#### Scenario: Set text color
- **WHEN** user calls `(setf (text-color drawer) :white)`
- **THEN** text annotations render in white

#### Scenario: Set text font
- **WHEN** user calls `(setf (text-font drawer) "Arial")`
- **THEN** text annotations use Arial

#### Scenario: Set text style
- **WHEN** user calls `(setf (text-style drawer) :bold)`
- **THEN** text annotations render in bold

### Requirement: Free boundary aspect and toggle
The system SHALL control free boundary edge display, with separate aspect control for color, type, and width.

#### Scenario: Enable free boundary display
- **WHEN** user calls `(setf (free-boundary-draw-p drawer) t)`
- **THEN** free boundaries are displayed

#### Scenario: Set free boundary color
- **WHEN** user calls `(setf (free-boundary-color drawer) :magenta)`
- **THEN** free boundaries render in magenta

### Requirement: Face boundary aspect and toggle
The system SHALL control face boundary edge display, with separate aspect control.

#### Scenario: Enable face boundary display
- **WHEN** user calls `(setf (face-boundary-draw-p drawer) t)`
- **THEN** face boundaries are displayed

#### Scenario: Set face boundary color
- **WHEN** user calls `(setf (face-boundary-color drawer) :cyan)`
- **THEN** face boundaries render in cyan

### Requirement: Iso-line aspects and toggles
The system SHALL control U and V iso-line display, with separate aspect controls for each direction.

#### Scenario: Enable U isos
- **WHEN** user calls `(setf (u-iso-draw-p drawer) t)`
- **THEN** U-direction iso-lines are displayed

#### Scenario: Set V iso color
- **WHEN** user calls `(setf (v-iso-color drawer) :green)`
- **THEN** V-direction iso-lines render in green

### Requirement: Wire aspect access
The system SHALL expose the wireframe-only aspect.

#### Scenario: Set wire color
- **WHEN** user calls `(setf (wire-color drawer) :orange)`
- **THEN** wireframe mode edges render in orange

### Requirement: Convenience shorthand functions
The system SHALL provide convenience functions that set common aspect combinations without navigating the drawer chain.

#### Scenario: Quick edge styling
- **WHEN** user calls `(ais-set-edge-styling ctx obj :color :black :width 2.0 :type :dash)`
- **THEN** object edges render as black dashed lines at 2px

#### Scenario: Quick shade + edge
- **WHEN** user calls `(ais-style ctx obj :color :blue :edges t :edge-color :white :material :plastic)`
- **THEN** object renders blue with white edges and plastic material

### Requirement: First-class drawer object with GC
The system SHALL ensure the `drawer` CLOS object properly manages its C handle via `tg:finalize`.

#### Scenario: Drawer lifecycle
- **WHEN** user obtains a drawer via `(ais-drawer obj)`
- **THEN** the drawer handle is valid and GC-managed
