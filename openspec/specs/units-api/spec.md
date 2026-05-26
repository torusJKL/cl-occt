## ADDED Requirements

### Requirement: Convert between units
The system SHALL convert a numeric value between two unit systems via `UnitsAPI`.

#### Scenario: Convert mm to inch
- **WHEN** 25.4 mm is converted to inches
- **THEN** the result SHALL be 1.0

#### Scenario: Convert kg to lbm
- **WHEN** 1.0 kg is converted to lbm
- **THEN** the result SHALL be approximately 2.20462

### Requirement: Convert from SI
The system SHALL convert a value from SI units to a specified unit.

#### Scenario: SI meters to mm
- **WHEN** 1.0 (meters, SI) is converted to "mm"
- **THEN** the result SHALL be 1000.0
