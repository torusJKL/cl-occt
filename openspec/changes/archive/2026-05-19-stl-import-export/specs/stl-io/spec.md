## ADDED Requirements

### Requirement: Export shape to STL file
User SHALL be able to export a shape to a binary STL file. The system SHALL use OCCT StlAPI_Writer with BRepMesh_IncrementalMesh for tessellation.

#### Scenario: Export box to STL
- **WHEN** user calls `(write-stl (make-box 10 20 30) "box.stl")`
- **THEN** file "box.stl" is created and contains a valid binary STL representation of a 10×20×30 box

#### Scenario: Export nil shape
- **WHEN** user calls `(write-stl nil "nil.stl")`
- **THEN** system returns nil

### Requirement: Export STL with configurable deflection
User SHALL be able to control tessellation quality by passing a `:deflection` keyword argument. Lower deflection produces a finer mesh. The default deflection SHALL be 0.1.

#### Scenario: Export with custom deflection
- **WHEN** user calls `(write-stl (make-sphere 10) "sphere.stl" :deflection 0.01)`
- **THEN** file "sphere.stl" contains a higher-resolution (more triangles) mesh than default

#### Scenario: Export with default deflection
- **WHEN** user calls `(write-stl (make-box 5 5 5) "box.stl")`
- **THEN** tessellation uses the default deflection of 0.1

### Requirement: Import shape from STL file
User SHALL be able to read a binary STL file and construct the corresponding shape. The system SHALL use OCCT StlAPI_Reader.

#### Scenario: Import and read STL file
- **WHEN** user calls `(write-stl (make-box 10 20 30) "tmp.stl")` then `(read-stl "tmp.stl")`
- **THEN** system returns a shape object

#### Scenario: Import non-existent file
- **WHEN** user calls `(read-stl "nonexistent.stl")`
- **THEN** system returns nil

### Requirement: REPL-accessible path
File paths SHALL be relative to the current working directory of the SBCL process.

#### Scenario: Relative path export
- **WHEN** user calls `(write-stl (make-box 1 2 3) "output/test.stl")`
- **THEN** file is created at process working directory / "output/test.stl"
