## ADDED Requirements

### Requirement: Surface fillet between two faces
The system SHALL create a smooth blending surface between two faces of a solid using `FilletSurf`.

#### Scenario: Blend two adjacent faces
- **WHEN** user calls `(blend-faces face1 face2 radius)`
- **THEN** returns a shape representing the blended surface of the given radius

#### Scenario: Blend with non-adjacent faces
- **WHEN** user calls `(blend-faces distant-face1 distant-face2 radius)`
- **THEN** returns nil (blending requires adjacent or near faces)

### Requirement: General blend construction via BlendFunc
The system SHALL expose lower-level blend construction functions from `BlendFunc` for custom blending operations (constant radius, variable radius, chordal, etc.).

#### Scenario: Constant radius blend via BlendFunc
- **WHEN** user calls `(make-blend face1 face2 :constant radius)`
- **THEN** returns a shape with a constant-radius blend between the faces

#### Scenario: Blend with law-defined radius evolution
- **WHEN** user calls `(make-blend face1 face2 :evolving radius-law)`
- **THEN** returns a shape with the blend radius evolving along the blend according to the given law
