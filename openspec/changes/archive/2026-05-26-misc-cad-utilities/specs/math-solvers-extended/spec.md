## ADDED Requirements

### Requirement: Find function root
The system SHALL find a root of a 1D function via `math_FunctionRoot`.

#### Scenario: Linear function root
- **WHEN** finding the root of f(x) = x - 5
- **THEN** the root SHALL be approximately 5.0

### Requirement: Minimize function
The system SHALL find a minimum of a function via `math_NewtonMinimum`.

#### Scenario: Quadratic function minimum
- **WHEN** minimizing f(x) = x^2 + 2x + 1
- **THEN** the minimum SHALL be near x = -1.0
