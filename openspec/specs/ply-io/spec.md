## ADDED Requirements

### Requirement: Export shape to PLY file

User SHALL be able to export a shape to a PLY (Polygon File Format) file. The system SHALL use OCCT RWPly_CafWriter. PLY import is NOT supported in this change (OCCT does not provide a standard PLY reader).

#### Scenario: Export box to PLY
- **WHEN** user calls `(write-ply (make-box 10 20 30) "box.ply")`
- **THEN** file "box.ply" is created and contains a valid PLY mesh representation

#### Scenario: Export nil shape
- **WHEN** user calls `(write-ply nil "nil.ply")`
- **THEN** system returns nil

### Requirement: Export PLY with coordinate system

User SHALL be able to specify the coordinate system for PLY export.

#### Scenario: Export with custom coordinate system
- **WHEN** user calls `(write-ply (make-box 5 5 5) "box-zup.ply" :coordinate-system :zup)`
- **THEN** file "box-zup.ply" uses the specified Z-up orientation

### Requirement: Export PLY with per-vertex colors

User SHALL be able to export per-vertex colors with the PLY mesh.

#### Scenario: Export with per-vertex colors
- **WHEN** user calls `(write-ply (make-box 5 5 5) "colored-box.ply" :per-vertex-colors t)`
- **THEN** file "colored-box.ply" contains vertex color attributes

### Requirement: REPL-accessible path

File paths SHALL be relative to the current working directory of the SBCL process.

#### Scenario: Relative path export
- **WHEN** user calls `(write-ply (make-box 1 2 3) "output/test.ply")`
- **THEN** file is created at process working directory / "output/test.ply"
