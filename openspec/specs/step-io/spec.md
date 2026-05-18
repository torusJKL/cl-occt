## ADDED Requirements

### Requirement: Export shape to STEP file
User SHALL be able to export a shape to a STEP AP203 file. The system SHALL use OCCT STEPControl_Writer with ASSEMBLY mode.

#### Scenario: Export box to STEP
- **WHEN** user calls `(write-step (make-box 10 20 30) "box.step")`
- **THEN** file "box.step" is created and contains a valid STEP representation of a 10×20×30 box

#### Scenario: Export nil shape
- **WHEN** user calls `(write-step nil "nil.step")`
- **THEN** system returns nil or signals an error

### Requirement: Import shape from STEP file
User SHALL be able to read a STEP file and construct the corresponding shape. The system SHALL use OCCT STEPControl_Reader.

#### Scenario: Import and verify round-trip
- **WHEN** user calls `(write-step (make-box 10 20 30) "tmp.step")` then `(read-step "tmp.step")`
- **THEN** system returns a shape object (the exact topology may differ but the file round-trips without error)

#### Scenario: Import non-existent file
- **WHEN** user calls `(read-step "nonexistent.step")`
- **THEN** system returns nil

### Requirement: REPL-accessible path
File paths SHALL be relative to the current working directory of the SBCL process.

#### Scenario: Relative path export
- **WHEN** user calls `(write-step (make-box 1 2 3) "output/test.step")`
- **THEN** file is created at process working directory / "output/test.step"
