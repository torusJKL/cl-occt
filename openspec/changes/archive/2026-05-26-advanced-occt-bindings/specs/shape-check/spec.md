## ADDED Requirements

### Requirement: Validate shape validity with BRepAlgoAPI_Check
The system SHALL provide a function to check whether a shape is valid for boolean operations using `BRepAlgoAPI_Check`.

#### Scenario: Check valid shape
- **WHEN** a user calls `check-shape-validity` with a valid solid shape
- **THEN** the system returns nil (no errors)

#### Scenario: Check invalid shape
- **WHEN** a user calls `check-shape-validity` with an invalid shape
- **THEN** the system returns a non-nil value describing the issue

#### Scenario: Check shape with nil input
- **WHEN** a user calls `check-shape-validity` with nil
- **THEN** the system returns nil

### Requirement: Build boolean operations with BRepAlgoAPI_BuilderAlgo
The system SHALL provide a function to perform boolean operations using the general `BRepAlgoAPI_BuilderAlgo` with operation type selection.

#### Scenario: Boolean builder fuse
- **WHEN** a user calls `boolean-builder` with two shapes and `:operation :fuse`
- **THEN** the system returns the fused union shape

#### Scenario: Boolean builder cut
- **WHEN** a user calls `boolean-builder` with two shapes and `:operation :cut`
- **THEN** the system returns the subtracted shape

#### Scenario: Boolean builder common
- **WHEN** a user calls `boolean-builder` with two shapes and `:operation :common`
- **THEN** the system returns the intersection shape

#### Scenario: Boolean builder nil input
- **WHEN** a user calls `boolean-builder` with a nil input
- **THEN** the system returns nil
