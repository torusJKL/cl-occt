## ADDED Requirements

### Requirement: Set per-axis colors
The system SHALL set the color of each trihedron axis independently (red for X, green for Y, blue for Z by default).

#### Scenario: Custom axis colors
- **WHEN** user calls `(set-trihedron-axis-colors tri :x '(1 0 0) :y '(0 1 0) :z '(0 0 1))`
- **THEN** the X axis renders in red, Y in green, Z in blue

#### Scenario: Partial axis color override
- **WHEN** user calls `(set-trihedron-axis-colors tri :x :orange)`
- **THEN** only the X axis changes to orange; Y and Z remain at their previous colors

#### Scenario: Named colors for axes
- **WHEN** user calls `(set-trihedron-axis-colors tri :x :crimson :y :lime-green :z :navy)`
- **THEN** each axis uses the corresponding named color (requires viewer-colors spec)

### Requirement: Set text color
The system SHALL set the color of the axis label text (X, Y, Z labels).

#### Scenario: White text labels
- **WHEN** user calls `(set-trihedron-text-color tri :white)`
- **THEN** the X/Y/Z text labels render in white

### Requirement: Set datum display mode with label control
The system SHALL control whether axis labels, arrows, or both are displayed (not just wireframe vs shaded).

#### Scenario: Show labels only (no arrows)
- **WHEN** user calls `(set-trihedron-datum-mode tri :labels-only)`
- **THEN** only text labels are shown, arrows are hidden

#### Scenario: Show arrows only (no labels)
- **WHEN** user calls `(set-trihedron-datum-mode tri :arrows-only)`
- **THEN** only arrows are shown, labels are hidden

#### Scenario: Show both labels and arrows
- **WHEN** user calls `(set-trihedron-datum-mode tri :both)`
- **THEN** both labels and arrows are displayed

### Requirement: Toggle draw-names (show/hide labels)
The system SHALL show or hide the X/Y/Z text labels on the trihedron.

#### Scenario: Hide labels
- **WHEN** user calls `(set-trihedron-draw-names tri nil)`
- **THEN** the XYZ text labels are hidden

### Requirement: Set trihedron wireframe color
The system SHALL set the color of the trihedron's wireframe representation when in wireframe datum mode.

#### Scenario: Blue wireframe trihedron
- **WHEN** user calls `(set-trihedron-wireframe-color tri :blue)`
- **THEN** the wireframe trihedron renders in blue
