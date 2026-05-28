## MODIFIED Requirements

### Requirement: Render 3D text
The system SHALL provide a convenience function that renders text and extrudes it in one step. When `:normal` is not specified, the extrusion SHALL be in the Z direction. When `:normal` is specified, extrusion SHALL follow the plane normal direction. The function SHALL accept the same alignment keyword arguments as `make-text-shape`.

#### Scenario: Create 3D text with default alignment
- **WHEN** user calls `(make-text-shape-3d <font> "Hello 3D!" 2.0)`
- **THEN** system returns a `shape` object that is a 3D extrusion of the flat text

#### Scenario: Create 3D text with custom alignment
- **WHEN** user calls `(make-text-shape-3d <font> "Centered" 3.0 :h-align :center :v-align :center)`
- **THEN** system returns a `shape` object

#### Scenario: Create 3D text with nil font
- **WHEN** user calls `(make-text-shape-3d nil "Hello" 2.0)`
- **THEN** system returns nil

#### Scenario: Create 3D text with zero depth
- **WHEN** user calls `(make-text-shape-3d <font> "Hello" 0.0)`
- **THEN** system returns nil

#### Scenario: Extrude along non-default normal
- **WHEN** user calls `(make-text-shape-3d <font> "Normal" 3.0 :normal '(0 1 0))`
- **THEN** system returns a shape whose extent along Y is approximately 3.0 and extent along Z is approximately 0.0
