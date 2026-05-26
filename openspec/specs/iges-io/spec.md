## ADDED Requirements

### Requirement: Export shape to IGES file

User SHALL be able to export a shape to an IGES file. The system SHALL use OCCT IGESControl_Writer.

#### Scenario: Export box to IGES
- **WHEN** user calls `(write-iges (make-box 10 20 30) "box.igs")`
- **THEN** file "box.igs" is created and contains a valid IGES representation of a 10×20×30 box

#### Scenario: Export nil shape
- **WHEN** user calls `(write-iges nil "nil.igs")`
- **THEN** system returns nil

#### Scenario: Export non-shape object
- **WHEN** user calls `(write-iges "not-a-shape" "bad.igs")`
- **THEN** system returns nil

### Requirement: Import shape from IGES file

User SHALL be able to read an IGES file and construct the corresponding shape. The system SHALL use OCCT IGESControl_Reader.

#### Scenario: Import and verify round-trip
- **WHEN** user calls `(write-iges (make-box 10 20 30) "tmp.igs")` then `(read-iges "tmp.igs")`
- **THEN** system returns a shape object

#### Scenario: Import non-existent file
- **WHEN** user calls `(read-iges "nonexistent.igs")`
- **THEN** system returns nil

### Requirement: Export colored assembly tree to IGES

User SHALL be able to export an assembly tree with named parts and colors to an IGES file. The system SHALL use OCCT IGESCAFControl_Writer.

#### Scenario: Export single part with color
- **WHEN** user calls `(let ((part (make-part (make-box 10 20 30) :name "box" :color '(:generic 1 0 0 1)))) (write-iges-assembly part "colored-box.igs"))`
- **THEN** file "colored-box.igs" is created and when re-read via `read-iges-assembly`, the part name is "box" and the color is red

#### Scenario: Export assembly hierarchy
- **WHEN** user calls `(write-iges-assembly (make-assembly :name "root" :children (list part-a part-b)) "assy.igs")`
- **THEN** file "assy.igs" is created preserving the two children under the root assembly

#### Scenario: Export nil assembly
- **WHEN** user calls `(write-iges-assembly nil "nil.igs")`
- **THEN** system returns nil

### Requirement: Import colored assembly tree from IGES

User SHALL be able to read an IGES file and reconstruct the assembly tree with names, colors, and locations. The system SHALL use OCCT IGESCAFControl_Reader.

#### Scenario: Import simple assembly
- **WHEN** user calls `(read-iges-assembly "colored-box.igs")`
- **THEN** system returns an `assembly` node with a shape, name "box", and color `(:generic 1.0 0.0 0.0 1.0)`

#### Scenario: Import preserves hierarchy
- **WHEN** user reads an IGES file with 3 parts under a root
- **THEN** the returned assembly has 3 children, each with its own shape

#### Scenario: Import preserves locations
- **WHEN** user reads an IGES file where parts have placement transforms
- **THEN** the returned parts have `assembly-location` set to a non-nil 4×4 matrix

#### Scenario: Import non-existent file
- **WHEN** user calls `(read-iges-assembly "nonexistent.igs")`
- **THEN** system returns nil

### Requirement: REPL-accessible path

File paths SHALL be relative to the current working directory of the SBCL process.

#### Scenario: Relative path export
- **WHEN** user calls `(write-iges (make-box 1 2 3) "output/test.igs")`
- **THEN** file is created at process working directory / "output/test.igs"
