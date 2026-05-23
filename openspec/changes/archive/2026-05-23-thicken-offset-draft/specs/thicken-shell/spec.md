## ADDED Requirements

### Requirement: Hollow/shell a solid by removing faces
The system SHALL remove specified faces from a solid and create a thin-walled shell with a given wall thickness using `BRepOffsetAPI_MakeThickSolid`.

#### Scenario: Shell a box by removing top face
- **WHEN** user calls `(shell-shape box '(top-face) :thickness 2.0)`
- **THEN** returns a hollow shell with 2.0mm wall thickness and the top face removed (open)

#### Scenario: Shell a box by removing multiple faces
- **WHEN** user calls `(shell-shape box '(top-face bottom-face) :thickness 1.5)`
- **THEN** returns a hollow shell with 1.5mm walls and both ends open

#### Scenario: Shell with outward offset
- **WHEN** user calls `(shell-shape box '(top-face) :thickness 2.0 :offset :outward)`
- **THEN** returns a shell with walls offset outward from the original faces

#### Scenario: Shell with nil shape returns nil
- **WHEN** user calls `(shell-shape nil '(face) :thickness 2.0)`
- **THEN** returns nil

#### Scenario: Shell with thickness larger than feature returns nil
- **WHEN** user calls `(shell-shape box '(face) :thickness 999.0)`
- **THEN** returns nil (operation fails)
