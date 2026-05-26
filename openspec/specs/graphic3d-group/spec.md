## ADDED Requirements

### Requirement: Create group within structure
The system SHALL create a `Graphic3d_Group` inside a graphic structure. Groups are handle-based with `tg:finalize` GC.

#### Scenario: Create group
- **WHEN** user calls `(make-graphic-group structure)`
- **THEN** returns a `graphic-group` instance with non-null internal handle

### Requirement: Set group visibility
The system SHALL show or hide a group independently.

#### Scenario: Set visible
- **WHEN** user calls `(set-graphic-group-visible gg t)`
- **THEN** the group's primitives are visible

#### Scenario: Set invisible
- **WHEN** user calls `(set-graphic-group-visible gg nil)`
- **THEN** the group's primitives are hidden

### Requirement: Add polygon/primitives to group
The system SHALL add a primitive (triangles, lines, points, text) to a group using `Graphic3d_ArrayOfPrimitives` arrays.

#### Scenario: Add triangle set
- **WHEN** user calls `(graphic-group-add-triangles gg vertices normals)`
- **THEN** a triangle primitive is added to the group

#### Scenario: Add line strip
- **WHEN** user calls `(graphic-group-add-lines gg points)`
- **THEN** a line primitive is added to the group

#### Scenario: Add point set
- **WHEN** user calls `(graphic-group-add-points gg points)`
- **THEN** a point primitive is added to the group

#### Scenario: Add text
- **WHEN** user calls `(graphic-group-add-text gg "hello" position)`
- **THEN** a text primitive is added to the group

### Requirement: Set group aspect
The system SHALL apply a fill, line, marker, or text aspect to the group.

#### Scenario: Set fill aspect
- **WHEN** user calls `(set-graphic-group-aspect gg fill-aspect)`
- **THEN** subsequent primitives use the fill aspect

#### Scenario: Set line aspect
- **WHEN** user calls `(set-graphic-group-line-aspect gg line-aspect)`
- **THEN** subsequent line primitives use the line aspect

### Requirement: Predicate
The system SHALL provide a predicate for `graphic-group` instances.

#### Scenario: graphic-group-p
- **WHEN** user calls `(graphic-group-p (make-graphic-group structure))`
- **THEN** returns `t`
- **WHEN** user calls `(graphic-group-p nil)`
- **THEN** returns `nil`
