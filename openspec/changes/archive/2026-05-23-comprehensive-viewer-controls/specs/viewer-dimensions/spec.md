## ADDED Requirements

### Requirement: Create length dimension
The system SHALL create a length dimension from two 3D points or from an edge, displaying the measured distance.

#### Scenario: Length dimension between two points
- **WHEN** user calls `(make-dimension :length :from '(0 0 0) :to '(10 0 0))`
- **THEN** returns an `ais-object` displaying the 10-unit distance

#### Scenario: Length dimension from edge
- **WHEN** user calls `(make-dimension :length :edge edge-obj)`
- **THEN** returns an `ais-object` displaying the edge's length

#### Scenario: Invalid points
- **WHEN** user calls `(make-dimension :length :from '(0 0 0) :to '(0 0 0))`
- **THEN** returns nil (zero-length dimension rejected)

### Requirement: Create angle dimension
The system SHALL create an angular dimension between two edges or three points.

#### Scenario: Angle dimension between two edges
- **WHEN** user calls `(make-dimension :angle :edge1 edge-a :edge2 edge-b)`
- **THEN** returns an `ais-object` displaying the angle between edges

#### Scenario: Angle dimension from three points
- **WHEN** user calls `(make-dimension :angle :vertex '(0 0 0) :point1 '(1 0 0) :point2 '(0 1 0))`
- **THEN** returns an `ais-object` displaying the 90-degree angle

### Requirement: Create diameter/radius dimension
The system SHALL create a diameter or radius dimension for circular edges or faces.

#### Scenario: Diameter dimension
- **WHEN** user calls `(make-dimension :diameter :edge circle-edge)`
- **THEN** returns an `ais-object` displaying the diameter

#### Scenario: Radius dimension
- **WHEN** user calls `(make-dimension :radius :face cylindrical-face)`
- **THEN** returns an `ais-object` displaying the radius

### Requirement: Display dimension in context
The system SHALL display dimension objects via the existing `ais-display` mechanism.

#### Scenario: Display and query
- **WHEN** user calls `(ais-display ctx dim)`
- **THEN** the dimension is displayed in the context
- **AND WHEN** user calls `(ais-displayed-p ctx dim)`
- **THEN** returns `t`

### Requirement: Set dimension text (string, font, height)
The system SHALL customize the dimension label text.

#### Scenario: Custom dimension label
- **WHEN** user calls `(set-dimension-text dim "Length = 10 mm")`
- **THEN** the dimension displays the custom label

#### Scenario: Set label font and size
- **WHEN** user calls `(set-dimension-text dim "10mm" :font "Arial" :height 14.0)`
- **THEN** the label uses Arial at 14 units

### Requirement: Set dimension color
The system SHALL set the color of the dimension lines, arrows, and text.

#### Scenario: Red dimension
- **WHEN** user calls `(ais-set-color ctx dim :red)`
- **THEN** the dimension and its text render in red

### Requirement: Set dimension arrow style
The system SHALL control the arrow style and size on dimension lines.

#### Scenario: Filled arrows
- **WHEN** user calls `(set-dimension-arrows dim :filled :size 5.0)`
- **THEN** dimension lines have filled arrowheads of size 5

#### Scenario: Open arrows
- **WHEN** user calls `(set-dimension-arrows dim :open)`
- **THEN** dimension lines have open arrowheads

### Requirement: Set dimension extension line properties
The system SHALL control the extension line offset from the measured points and their length beyond the dimension line.

#### Scenario: Custom extension lines
- **WHEN** user calls `(set-dimension-extension dim :offset 5.0 :length 10.0)`
- **THEN** extension lines start 5 units from the points and extend 10 units past the dimension line

### Requirement: Position dimension flyout
The system SHALL set the flyout (offset) distance between the dimension line and the measured object.

#### Scenario: Flyout distance
- **WHEN** user calls `(set-dimension-flyout dim 20.0)`
- **THEN** the dimension line is positioned 20 units away from the measured geometry
