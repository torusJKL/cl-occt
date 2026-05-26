## ADDED Requirements

### Requirement: Evaluate mathematical expression
The system SHALL parse and evaluate a mathematical expression string via `ExprIntrp`.

#### Scenario: Simple arithmetic
- **WHEN** the expression "2 + 3 * 4" is evaluated
- **THEN** the result SHALL be 14.0

#### Scenario: Trigonometric functions
- **WHEN** the expression "sin(PI/2)" is evaluated
- **THEN** the result SHALL be approximately 1.0

#### Scenario: Invalid expression returns nil
- **WHEN** an invalid expression is evaluated
- **THEN** the result SHALL be nil
