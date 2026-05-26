## ADDED Requirements

### Requirement: Convert shape surfaces to revolution form
The system SHALL provide a function to convert elementary surfaces of a shape into revolution surfaces using `ShapeCustom_ConvertToRevolution`.

#### Scenario: Convert to revolution with valid shape
- **WHEN** a user calls `convert-to-revolution` with a shape containing appropriate surfaces
- **THEN** the system returns a new shape with surfaces converted where possible

#### Scenario: Convert to revolution with nil shape
- **WHEN** a user calls `convert-to-revolution` with nil
- **THEN** the system returns nil

#### Scenario: Convert to revolution with non-convertible shape
- **WHEN** a user calls `convert-to-revolution` with a shape that cannot be converted
- **THEN** the system returns nil

### Requirement: Convert shape surfaces to elementary form
The system SHALL provide a function to convert swept surfaces of a shape into elementary surfaces using `ShapeCustom_SweptToElementary`.

#### Scenario: Convert swept to elementary with valid shape
- **WHEN** a user calls `convert-swept-to-elementary` with a shape containing appropriate surfaces
- **THEN** the system returns a new shape with surfaces converted where possible

#### Scenario: Convert swept to elementary with nil shape
- **WHEN** a user calls `convert-swept-to-elementary` with nil
- **THEN** the system returns nil

#### Scenario: Convert swept to elementary with non-convertible shape
- **WHEN** a user calls `convert-swept-to-elementary` with a shape that cannot be converted
- **THEN** the system returns nil
