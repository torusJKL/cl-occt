## ADDED Requirements

### Requirement: Create compound from list of shapes

User SHALL be able to create a `TopoDS_Compound` from a list of one or more shapes. The system SHALL use `BRep_Builder` to build the compound in OCCT.

#### Scenario: Compound of two boxes
- **WHEN** user calls `(make-compound (list (make-box 10 20 30) (make-sphere 5)))`
- **THEN** system returns a shape object that is a valid compound containing both sub-shapes

#### Scenario: Compound of multiple shapes
- **WHEN** user calls `(make-compound (list (make-box 1 2 3) (make-sphere 4) (make-cylinder 5 6)))`
- **THEN** system returns a compound containing exactly 3 sub-shapes

#### Scenario: Compound with nil shapes skipped
- **WHEN** user calls `(make-compound (list (make-box 1 2 3) nil (make-sphere 4)))`
- **THEN** system returns a compound containing exactly 2 sub-shapes (nil is skipped)

#### Scenario: Compound of all nil shapes returns nil
- **WHEN** user calls `(make-compound (list nil nil))`
- **THEN** system returns nil

#### Scenario: Compound of empty list
- **WHEN** user calls `(make-compound '())`
- **THEN** system returns a valid (empty) compound shape

### Requirement: Add shape to existing compound

User SHALL be able to add a single shape to an existing compound using `add-to-compound`.

#### Scenario: Add box to compound
- **WHEN** user calls `(add-to-compound compound (make-box 5 5 5))`
- **THEN** system returns the compound with the box added as a sub-shape

#### Scenario: Add nil to compound
- **WHEN** user calls `(add-to-compound compound nil)`
- **THEN** system returns the compound unchanged

#### Scenario: Add to nil compound returns nil
- **WHEN** user calls `(add-to-compound nil (make-box 1 2 3))`
- **THEN** system returns nil

### Requirement: Compound in write-stl

User SHALL be able to pass a compound shape to `write-stl`. OCCT `StlAPI_Writer` SHALL write all sub-shapes as a single binary STL file.

#### Scenario: Write compound as STL
- **WHEN** user calls `(write-stl (make-compound (list (make-box 10 20 30) (make-sphere 5))) "compound.stl")`
- **THEN** file "compound.stl" is created and contains both the box and sphere in a single mesh

#### Scenario: Write empty compound as STL
- **WHEN** user calls `(write-stl (make-compound '()) "empty.stl")`
- **THEN** file "empty.stl" is created (empty STL file)

### Requirement: Compound shape predicate

User SHALL be able to test whether a shape is a compound using `compound-shape-p`.

#### Scenario: Compound returns true
- **WHEN** user calls `(compound-shape-p (make-compound (list (make-box 1 2 3))))`
- **THEN** system returns `t`

#### Scenario: Simple shape returns false
- **WHEN** user calls `(compound-shape-p (make-box 1 2 3))`
- **THEN** system returns `nil`

#### Scenario: nil returns false
- **WHEN** user calls `(compound-shape-p nil)`
- **THEN** system returns `nil`
