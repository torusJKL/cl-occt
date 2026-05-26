## ADDED Requirements

### Requirement: Project shape edges with hidden line removal
The system SHALL provide a function to project a 3D shape onto a plane and classify edges as visible/hidden using `HLRBRep_Algo`.

#### Scenario: HLR project a box with default projection
- **WHEN** a user calls `hlr-project` with a box shape and default parameters
- **THEN** the system returns a plist with visible and hidden edge groups

#### Scenario: HLR project with nil shape
- **WHEN** a user calls `hlr-project` with nil
- **THEN** the system returns nil

### Requirement: Extract HLR results into shape groups
The system SHALL provide a function to extract the computed HLR projection into categorized edge shapes (e.g., visible-visible, visible-hidden, etc.) using `HLRBRep_HLRToShape`.

#### Scenario: Extract visible outlines from projection
- **WHEN** a user obtains HLR result edges
- **THEN** the visible outline edges SHALL be topologically valid `TopoDS_Edge` shapes

#### Scenario: Extract hidden outlines from projection
- **WHEN** a user obtains HLR result edges
- **THEN** the hidden outline edges SHALL be available as valid shapes

#### Scenario: HLR extract with nil result
- **WHEN** a user calls `hlr-extract-shapes` with nil
- **THEN** the system returns nil
