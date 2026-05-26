## ADDED Requirements

### Requirement: Create planar texture from file

The system SHALL create a `Graphic3d_Texture2Dplane` from an image file path. `texture-2dplane-from-file` SHALL accept a path string and return a `texture-2dplane` instance, or nil on failure. A `texture-2dplane` SHALL satisfy `texture-2d-p` (inheritance).

#### Scenario: Create from valid file
- **WHEN** `texture-2dplane-from-file` is called with a valid image path
- **THEN** a `texture-2dplane` instance SHALL be returned

#### Scenario: Create from nil
- **WHEN** `texture-2dplane-from-file` is called with nil
- **THEN** nil SHALL be returned

#### Scenario: Is texture-2d
- **WHEN** `texture-2d-p` is called on a `texture-2dplane` instance
- **THEN** t SHALL be returned

### Requirement: Set UV repeat

The system SHALL support setting UV repeat on a planar texture. `set-texture-plane-repeat` SHALL accept a `texture-2dplane`, boolean for U repeat, and boolean for V repeat.

#### Scenario: Set both repeat on
- **WHEN** `set-texture-plane-repeat` is called on a planar texture with t and t
- **THEN** the texture SHALL repeat in both U and V directions

#### Scenario: Set no repeat
- **WHEN** `set-texture-plane-repeat` is called with nil for both
- **THEN** the texture SHALL clamp in both U and V directions

### Requirement: Set UV origin

The system SHALL support setting UV origin offset on a planar texture. `set-texture-plane-origin` SHALL accept a `texture-2dplane` and two doubles for U and V origin.

#### Scenario: Set origin
- **WHEN** `set-texture-plane-origin` is called with U=0.5 and V=0.5
- **THEN** the texture mapping origin SHALL be offset by 0.5 in both UV axes

### Requirement: Set UV scale

The system SHALL support setting UV scale on a planar texture. `set-texture-plane-scale` SHALL accept a `texture-2dplane` and two doubles for U and V scale.

#### Scenario: Set scale
- **WHEN** `set-texture-plane-scale` is called with U=2.0 and V=1.0
- **THEN** the texture SHALL be scaled 2x in U and 1x in V

### Requirement: Set rotation

The system SHALL support setting rotation angle on a planar texture. `set-texture-plane-rotation` SHALL accept a `texture-2dplane` and an angle in degrees.

#### Scenario: Set rotation
- **WHEN** `set-texture-plane-rotation` is called with 45.0
- **THEN** the texture mapping SHALL be rotated by 45 degrees

### Requirement: Planar texture predicate

`texture-2dplane-p` SHALL return t for `texture-2dplane` instances and nil otherwise.

#### Scenario: Predicate on planar texture
- **WHEN** `texture-2dplane-p` is called on a valid `texture-2dplane`
- **THEN** t SHALL be returned

#### Scenario: Predicate on non-planar texture
- **WHEN** `texture-2dplane-p` is called on a `texture-2d` instance
- **THEN** nil SHALL be returned

### Requirement: GC finalization

`texture-2dplane` SHALL be registered with `tg:finalize` to free the underlying C handle when garbage collected.

#### Scenario: GC collects planar texture
- **WHEN** a `texture-2dplane` instance goes out of scope
- **THEN** the C handle SHALL be freed
