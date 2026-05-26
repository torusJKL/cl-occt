## ADDED Requirements

### Requirement: Document sewing in API reference
The system SHALL document the `sew-shapes` function in `docs/api-reference.md` with signature, description, parameter details, return value, and usage example.

#### Scenario: Sewing entry exists
- **WHEN** a user reads `docs/api-reference.md`
- **THEN** the document contains a `(sew-shapes shapes &key tolerance allow-non-manifold)` entry with description and example

### Requirement: Document defeaturing in API reference
The system SHALL document the `defeature-shape` function in `docs/api-reference.md` with signature, description, parameter details, return value, and usage example.

#### Scenario: Defeaturing entry exists
- **WHEN** a user reads `docs/api-reference.md`
- **THEN** the document contains a `(defeature-shape shape faces)` entry with description and example

### Requirement: Document shape-check in API reference
The system SHALL document the `check-shape-validity` and `boolean-builder` functions in `docs/api-reference.md`.

#### Scenario: Shape check entries exist
- **WHEN** a user reads `docs/api-reference.md`
- **THEN** the document contains entries for `check-shape-validity` and `boolean-builder` with descriptions and examples

### Requirement: Document HLR in API reference
The system SHALL document the `hlr-project` and `hlr-extract-shapes` functions in `docs/api-reference.md`.

#### Scenario: HLR entries exist
- **WHEN** a user reads `docs/api-reference.md`
- **THEN** the document contains entries for HLR functions with descriptions and usage examples showing projection plane configuration

### Requirement: Document shape-conversion in API reference
The system SHALL document the `convert-to-revolution` and `convert-swept-to-elementary` functions in `docs/api-reference.md`.

#### Scenario: Shape conversion entries exist
- **WHEN** a user reads `docs/api-reference.md`
- **THEN** the document contains entries for both conversion functions with descriptions and examples
