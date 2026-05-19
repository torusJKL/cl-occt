## MODIFIED Requirements

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

#### Scenario: Import multi-root file returns nil
- **WHEN** user calls `(read-step multi-root.step)` where the file contains more than one top-level entity
- **THEN** system returns nil (use `read-step-assembly` instead)

## ADDED Requirements

### Requirement: Export colored assembly tree to STEP

User SHALL be able to export an assembly tree with named parts and colors to a STEP AP242 file. The system SHALL use OCCT STEPCAFControl_Writer.

#### Scenario: Export single part with color
- **WHEN** user calls `(let ((part (make-part (make-box 10 20 30) :name "box" :color '(:generic 1 0 0 1)))) (write-step-assembly part "colored-box.step"))`
- **THEN** file "colored-box.step" is created and when re-read, the part name is "box" and the color is red

#### Scenario: Export assembly hierarchy
- **WHEN** user calls `(write-step-assembly (make-assembly :name "root" :children (list part-a part-b)) "assy.step")`
- **THEN** file "assy.step" is created preserving the two children under the root assembly

#### Scenario: Export nil assembly
- **WHEN** user calls `(write-step-assembly nil "nil.step")`
- **THEN** system returns nil

### Requirement: Import colored assembly tree from STEP

User SHALL be able to read a STEP AP242 file and reconstruct the assembly tree with names, colors, and locations. The system SHALL use OCCT STEPCAFControl_Reader.

#### Scenario: Import simple assembly
- **WHEN** user calls `(read-step-assembly "colored-box.step")`
- **THEN** system returns an `assembly` node with a shape, name "box", and color `(:generic 1.0 0.0 0.0 1.0)`

#### Scenario: Import preserves hierarchy
- **WHEN** user reads a STEP file with 3 parts under a root
- **THEN** the returned assembly has 3 children, each with its own shape

#### Scenario: Import preserves locations
- **WHEN** user reads a STEP file where parts have placement transforms
- **THEN** the returned parts have `assembly-location` set to a non-nil 4×4 matrix

#### Scenario: Import preserves nested assemblies
- **WHEN** user reads a STEP file with sub-assemblies
- **THEN** the returned tree has nested `assembly` nodes matching the original hierarchy

#### Scenario: Round-trip assembly
- **WHEN** user writes then reads an assembly tree with 3 colored parts
- **THEN** the re-read tree has the same number of children with the same names and colors

#### Scenario: Import non-existent file
- **WHEN** user calls `(read-step-assembly "nonexistent.step")`
- **THEN** system returns nil
