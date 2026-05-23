## ADDED Requirements

### Requirement: Scriptable healing pipeline (ShapeProcess)
The system SHALL apply a healing operator or a sequence of operators to a shape using `ShapeProcess`.

#### Scenario: Apply a single healing operator
- **WHEN** user calls `(apply-shape-process shape "FixShape")`
- **THEN** returns a shape with the specified healing operator applied

#### Scenario: Apply a custom operator sequence
- **WHEN** user calls `(apply-shape-process shape '("FixShape" "FixWire" "FixSolid" "SameParameter"))`
- **THEN** returns a shape with all operators applied in sequence

### Requirement: Healing pipeline from resource file
The system SHALL apply a healing pipeline defined in a resource file using `ShapeProcessAPI`.

#### Scenario: Apply healing from resource file
- **WHEN** user calls `(apply-healing-pipeline shape "my-pipeline" :resource "healing-resources")`
- **THEN** returns a shape with the named pipeline applied

#### Scenario: Default healing pipeline
- **WHEN** user calls `(heal-shape shape)`
- **THEN** returns a shape with a sensible default healing pipeline applied (fix wires, fix solids, same-parameter)

#### Scenario: Heal with nil returns nil
- **WHEN** user calls `(heal-shape nil)`
- **THEN** returns nil
