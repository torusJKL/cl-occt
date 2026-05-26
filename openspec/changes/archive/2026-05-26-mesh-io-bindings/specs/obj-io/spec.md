## ADDED Requirements

### Requirement: Export shape to OBJ file

User SHALL be able to export a shape to an OBJ mesh file. The system SHALL use OCCT RWObj_CafWriter.

#### Scenario: Export box to OBJ
- **WHEN** user calls `(write-obj (make-box 10 20 30) "box.obj")`
- **THEN** file "box.obj" is created and contains a valid OBJ mesh representation

#### Scenario: Export nil shape
- **WHEN** user calls `(write-obj nil "nil.obj")`
- **THEN** system returns nil

### Requirement: Export OBJ with coordinate system

User SHALL be able to specify the coordinate system for OBJ export via an `:coordinate-system` keyword. The system SHALL support Zup (glTF default) and Yup (common in 3D tools).

#### Scenario: Export with Zup coordinate system
- **WHEN** user calls `(write-obj (make-box 5 5 5) "box-zup.obj" :coordinate-system :zup)`
- **THEN** file "box-zup.obj" uses Z-up orientation

#### Scenario: Export with Yup coordinate system
- **WHEN** user calls `(write-obj (make-box 5 5 5) "box-yup.obj" :coordinate-system :yup)`
- **THEN** file "box-yup.obj" uses Y-up orientation

### Requirement: Export OBJ with per-vertex colors

User SHALL be able to export per-vertex colors with the OBJ mesh. The system SHALL support face and face+vertex color modes via an `:name-format` keyword.

#### Scenario: Export with per-vertex colors
- **WHEN** user calls `(write-obj (make-box 5 5 5) "colored-box.obj" :per-vertex-colors t)`
- **THEN** file "colored-box.obj" contains color attributes per vertex

#### Scenario: Export without per-vertex colors (default)
- **WHEN** user calls `(write-obj (make-box 5 5 5) "box.obj")`
- **THEN** file "box.obj" contains no color attributes

### Requirement: Import shape from OBJ file

User SHALL be able to read an OBJ mesh file and construct the corresponding shape. The system SHALL use OCCT RWObj_CafReader.

#### Scenario: Import and verify round-trip
- **WHEN** user calls `(write-obj (make-box 10 20 30) "tmp.obj")` then `(read-obj "tmp.obj")`
- **THEN** system returns a shape object

#### Scenario: Import non-existent file
- **WHEN** user calls `(read-obj "nonexistent.obj")`
- **THEN** system returns nil

### Requirement: REPL-accessible path

File paths SHALL be relative to the current working directory of the SBCL process.

#### Scenario: Relative path export
- **WHEN** user calls `(write-obj (make-box 1 2 3) "output/test.obj")`
- **THEN** file is created at process working directory / "output/test.obj"
