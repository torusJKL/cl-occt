## ADDED Requirements

### Requirement: Split shape by another shape
The system SHALL split a shape by a tool shape using `BOPAlgo_Splitter`, partitioning the shape into disjoint pieces along the intersection with the tool.

#### Scenario: Split box by plane
- **WHEN** user calls `(split-shape box (make-face-on-plane ...))`
- **THEN** returns a compound of two solid pieces

#### Scenario: Split by wire
- **WHEN** user calls `(split-shape shape wire)`
- **THEN** returns a compound of pieces partitioned along the wire path

#### Scenario: Nil shape returns nil
- **WHEN** user calls `(split-shape nil tool)`
- **THEN** returns nil

#### Scenario: Nil tool returns shape unchanged
- **WHEN** user calls `(split-shape shape nil)`
- **THEN** returns the original shape

### Requirement: Split by multiple tools
The system SHALL split a shape by a list of tool shapes in one operation.

#### Scenario: Split by two planes
- **WHEN** user calls `(split-shape shape (list plane1 plane2))`
- **THEN** returns a compound of 4 pieces (if planes intersect within the shape)
