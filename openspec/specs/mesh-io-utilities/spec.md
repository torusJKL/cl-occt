## ADDED Requirements

### Requirement: Query available mesh I/O coordinate systems

User SHALL be able to reference named coordinate systems for mesh I/O operations. The system SHALL support `:zup` (Z-axis up) and `:yup` (Y-axis up) as keyword values mapped to OCCT RWMesh_CoordinateSystem enum values.

#### Scenario: Use Zup coordinate system
- **WHEN** user calls `(write-obj (make-box 5 5 5) "box.obj" :coordinate-system :zup)`
- **THEN** the C wrapper receives the correct RWMesh_CoordinateSystem_Zup integer value

#### Scenario: Use Yup coordinate system
- **WHEN** user calls `(write-obj (make-box 5 5 5) "box.obj" :coordinate-system :yup)`
- **THEN** the C wrapper receives the correct RWMesh_CoordinateSystem_Yup integer value

#### Scenario: Default coordinate system is Zup
- **WHEN** user calls `(write-obj (make-box 5 5 5) "box.obj")` without specifying `:coordinate-system`
- **THEN** the C wrapper uses RWMesh_CoordinateSystem_Zup by default

### Requirement: Query available mesh I/O name formats

User SHALL be able to specify mesh I/O name format via a keyword. The system SHALL support `:auto`, `:short`, and `:full` corresponding to RWMesh_NameFormat enum values.

#### Scenario: Use auto name format
- **WHEN** user calls `(write-obj (make-box 5 5 5) "box.obj" :name-format :auto)`
- **THEN** the C wrapper receives the correct RWMesh_NameFormat_Auto integer value

#### Scenario: Use short name format
- **WHEN** user calls `(write-obj (make-box 5 5 5) "box.obj" :name-format :short)`
- **THEN** the C wrapper receives the correct RWMesh_NameFormat_Short integer value

#### Scenario: Use full name format
- **WHEN** user calls `(write-obj (make-box 5 5 5) "box.obj" :name-format :full)`
- **THEN** the C wrapper receives the correct RWMesh_NameFormat_Full integer value

#### Scenario: Invalid coordinate system keyword signals error
- **WHEN** user calls `(write-obj (make-box 5 5 5) "box.obj" :coordinate-system :invalid)`
- **THEN** system signals an error indicating an unknown coordinate system value

#### Scenario: Invalid name format keyword signals error
- **WHEN** user calls `(write-obj (make-box 5 5 5) "box.obj" :name-format :invalid)`
- **THEN** system signals an error indicating an unknown name format value
