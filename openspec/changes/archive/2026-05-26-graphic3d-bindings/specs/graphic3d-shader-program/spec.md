## ADDED Requirements

### Requirement: Create and free shader program
The system SHALL create an empty `Graphic3d_ShaderProgram` and free it. This is a handle-based type with `tg:finalize` GC.

#### Scenario: Create shader program
- **WHEN** user calls `(make-shader-program)`
- **THEN** returns a `shader-program` instance with non-null internal handle

#### Scenario: Free shader program
- **WHEN** user calls `(free-shader-program prog)`
- **THEN** the internal C handle is freed

#### Scenario: Double-free safety
- **WHEN** user calls `(free-shader-program prog)` twice
- **THEN** the second call does not crash

### Requirement: Set vertex and fragment shader sources
The system SHALL accept GLSL source strings for vertex and fragment shaders.

#### Scenario: Set vertex shader
- **WHEN** user calls `(set-shader-vertex-source prog "void main() {...}")`
- **THEN** the vertex shader source is stored in the program

#### Scenario: Set fragment shader
- **WHEN** user calls `(set-shader-fragment-source prog "void main() {...}")`
- **THEN** the fragment shader source is stored in the program

### Requirement: Set shader header
The system SHALL set a GLSL header string that is prepended to shader sources.

#### Scenario: Set header
- **WHEN** user calls `(set-shader-header prog "#version 330 core")`
- **THEN** the header is stored in the shader program

### Requirement: Predicate and type checking
The system SHALL provide a predicate for `shader-program` instances.

#### Scenario: shader-program-p
- **WHEN** user calls `(shader-program-p (make-shader-program))`
- **THEN** returns `t`
- **WHEN** user calls `(shader-program-p nil)`
- **THEN** returns `nil`
