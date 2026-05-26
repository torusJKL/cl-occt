## ADDED Requirements

### Requirement: Export shape to VRML file

User SHALL be able to export a shape to a VRML 2.0 file. The system SHALL use OCCT VrmlAPI_Writer. VRML import is NOT supported (OCCT does not provide a VRML reader).

#### Scenario: Export box to VRML
- **WHEN** user calls `(write-vrml (make-box 10 20 30) "box.wrl")`
- **THEN** file "box.wrl" is created and contains a valid VRML representation

#### Scenario: Export nil shape
- **WHEN** user calls `(write-vrml nil "nil.wrl")`
- **THEN** system returns nil

### Requirement: Export VRML with deflection

User SHALL be able to control tessellation quality via a `:deflection` keyword argument. Lower deflection produces a finer mesh. Default deflection SHALL be 0.1.

#### Scenario: Export with custom deflection
- **WHEN** user calls `(write-vrml (make-sphere 10) "sphere.wrl" :deflection 0.01)`
- **THEN** file "sphere.wrl" contains a higher-resolution mesh than default

#### Scenario: Export with default deflection
- **WHEN** user calls `(write-vrml (make-box 5 5 5) "box.wrl")`
- **THEN** tessellation uses the default deflection of 0.1

### Requirement: REPL-accessible path

File paths SHALL be relative to the current working directory of the SBCL process.

#### Scenario: Relative path export
- **WHEN** user calls `(write-vrml (make-box 1 2 3) "output/test.wrl")`
- **THEN** file is created at process working directory / "output/test.wrl"
