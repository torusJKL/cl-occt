## ADDED Requirements

### Requirement: Create texture from file

The system SHALL create a `Graphic3d_Texture2D` from an image file path. `texture-2d-from-file` SHALL accept a path string and return a `texture-2d` instance, or nil on failure. The image is loaded by OCCT's internal image loader.

#### Scenario: Create from valid file
- **WHEN** `texture-2d-from-file` is called with a path to a valid image file
- **THEN** a `texture-2d` instance SHALL be returned with non-nil handle

#### Scenario: Create from non-existent file
- **WHEN** `texture-2d-from-file` is called with a non-existent path
- **THEN** nil SHALL be returned

#### Scenario: Create with nil
- **WHEN** `texture-2d-from-file` is called with nil
- **THEN** nil SHALL be returned

### Requirement: Create texture from image

The system SHALL create a `Graphic3d_Texture2D` from an existing `image` instance. `texture-2d-from-image` SHALL accept an `image` and return a `texture-2d` instance, or nil on failure.

#### Scenario: Create from loaded image
- **WHEN** `texture-2d-from-image` is called with a valid `image`
- **THEN** a `texture-2d` instance SHALL be returned

#### Scenario: Create from nil image
- **WHEN** `texture-2d-from-image` is called with nil
- **THEN** nil SHALL be returned

### Requirement: Set texture parameters

The system SHALL allow attaching `texture-params` to a `texture-2d`. `(setf texture-params)` on a `texture-2d` SHALL call `Graphic3d_Texture2D::SetParams` with the given params handle.

#### Scenario: Set params on valid texture
- **WHEN** texture params are set on a `texture-2d` using `(setf (texture-params tex) params)`
- **THEN** the texture SHALL use the given params for subsequent rendering

#### Scenario: Set nil params
- **WHEN** `(setf (texture-params tex) nil)` is called
- **THEN** the texture SHALL have no custom params

### Requirement: Read texture parameters

`texture-params` (reader) on a `texture-2d` instance SHALL return the current `texture-params` associated with the texture, or nil if none.

#### Scenario: Reader on texture with custom params
- **WHEN** `texture-params` is called on a texture that has had params set
- **THEN** the `texture-params` instance SHALL be returned

#### Scenario: Reader on texture without params
- **WHEN** `texture-params` is called on a texture created from file
- **THEN** nil SHALL be returned (params are lazily created by OCCT)

### Requirement: GC finalization

The system SHALL register a `texture-2d` instance with `tg:finalize` to automatically free the C handle when the instance is garbage collected.

#### Scenario: GC collects texture
- **WHEN** a `texture-2d` instance goes out of scope
- **THEN** `free_texture` SHALL be called on the underlying C handle

### Requirement: Texture predicate

The system SHALL provide a `texture-2d-p` predicate that returns t for `texture-2d` instances and nil otherwise.

#### Scenario: Predicate on texture
- **WHEN** `texture-2d-p` is called on a valid `texture-2d`
- **THEN** t SHALL be returned

#### Scenario: Predicate on nil
- **WHEN** `texture-2d-p` is called on nil
- **THEN** nil SHALL be returned
