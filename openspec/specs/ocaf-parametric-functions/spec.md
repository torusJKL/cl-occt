## ADDED Requirements

### Requirement: Define parametric function driver
The system SHALL define a parametric function on a label using `TFunction_Function` and `TFunction_Driver`.

#### Scenario: Create function on label
- **WHEN** user calls `(ocaf-add-function label driver-id)`
- **THEN** creates a TFunction_Function attribute on the label with the given driver GUID

#### Scenario: Set function inputs
- **WHEN** user calls `(ocaf-set-function-input label function-label)`
- **THEN** registers function-label as an input to the function

#### Scenario: Set function outputs
- **WHEN** user calls `(ocaf-set-function-output label result-label)`
- **THEN** registers result-label as an output of the function

### Requirement: Trigger recomputation
The system SHALL trigger recomputation of a function and its dependents using `TFunction_Iterator` and `TFunction_Logbook`.

#### Scenario: Recompute after input change
- **WHEN** user calls `(ocaf-recompute doc)`
- **THEN** all dirty functions in the document are recomputed

#### Scenario: Recompute specific function
- **WHEN** user calls `(ocaf-recompute-function function-label)`
- **THEN** only the specified function is recomputed
