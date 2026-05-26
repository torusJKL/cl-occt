## ADDED Requirements

### Requirement: Export shape to glTF file

User SHALL be able to export a shape to a glTF file. The system SHALL use OCCT RWGltf_CafWriter. Both `.gltf` (JSON) and `.glb` (binary) formats SHALL be supported.

#### Scenario: Export box to glTF
- **WHEN** user calls `(write-gltf (make-box 10 20 30) "box.gltf")`
- **THEN** file "box.gltf" is created and contains a valid glTF representation

#### Scenario: Export nil shape
- **WHEN** user calls `(write-gltf nil "nil.gltf")`
- **THEN** system returns nil

### Requirement: Export glTF with coordinate system

User SHALL be able to specify the coordinate system for glTF export. The system SHALL default to Zup (glTF standard) with Yup as an alternative.

#### Scenario: Export with default Zup
- **WHEN** user calls `(write-gltf (make-box 5 5 5) "box.gltf")`
- **THEN** file "box.gltf" uses Z-up orientation (glTF default)

#### Scenario: Export with Yup
- **WHEN** user calls `(write-gltf (make-box 5 5 5) "box-yup.gltf" :coordinate-system :yup)`
- **THEN** file "box-yup.gltf" uses Y-up orientation

### Requirement: Export glTF with per-vertex colors

User SHALL be able to export per-vertex colors with the glTF mesh.

#### Scenario: Export with per-vertex colors
- **WHEN** user calls `(write-gltf (make-box 5 5 5) "colored-box.gltf" :per-vertex-colors t)`
- **THEN** file "colored-box.gltf" contains vertex color attributes

### Requirement: Import shape from glTF file

User SHALL be able to read a glTF file and construct the corresponding shape. The system SHALL use OCCT RWGltf_CafReader.

#### Scenario: Import and verify round-trip
- **WHEN** user calls `(write-gltf (make-box 10 20 30) "tmp.gltf")` then `(read-gltf "tmp.gltf")`
- **THEN** system returns a shape object

#### Scenario: Import non-existent file
- **WHEN** user calls `(read-gltf "nonexistent.gltf")`
- **THEN** system returns nil

### Requirement: REPL-accessible path

File paths SHALL be relative to the current working directory of the SBCL process.

#### Scenario: Relative path export
- **WHEN** user calls `(write-gltf (make-box 1 2 3) "output/test.gltf")`
- **THEN** file is created at process working directory / "output/test.gltf"
