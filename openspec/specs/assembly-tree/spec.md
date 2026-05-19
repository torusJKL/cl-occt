## ADDED Requirements

### Requirement: Represent assembly tree

The system SHALL provide an `assembly` class that represents a node in a hierarchical assembly tree. Each node may carry a shape, name, color, location, and child nodes.

#### Scenario: Create leaf part
- **WHEN** user calls `(make-part (make-box 10 20 30) :name "bracket" :color '(:generic 1.0 0.0 0.0 1.0))`
- **THEN** system returns an `assembly` instance with the given shape, name, color, and no children

#### Scenario: Create branch assembly
- **WHEN** user calls `(make-assembly :name "sub-assy" :children (list part-a part-b))`
- **THEN** system returns an `assembly` instance with the given name and children, and nil shape

#### Scenario: Leaf predicate
- **WHEN** user calls `(assembly-leaf-p (make-part (make-box 1 2 3)))`
- **THEN** system returns `t`

#### Scenario: Branch predicate
- **WHEN** user calls `(assembly-branch-p (make-assembly :children (list (make-part (make-box 1 2 3)))))`
- **THEN** system returns `t`

### Requirement: Access node properties

The system SHALL provide accessors for `shape`, `name`, `color`, `location`, and `children` slots of an `assembly` node, with `nil` for unset properties.

#### Scenario: Access name
- **WHEN** user calls `(assembly-name (make-part (make-box 1 2 3) :name "foo"))`
- **THEN** system returns `"foo"`

#### Scenario: Access unset name
- **WHEN** user calls `(assembly-name (make-part (make-box 1 2 3)))`
- **THEN** system returns `nil`

#### Scenario: Access children of leaf
- **WHEN** user calls `(assembly-children (make-part (make-box 1 2 3)))`
- **THEN** system returns `nil`

#### Scenario: Access children of branch
- **WHEN** user calls `(assembly-children root)`
- **THEN** system returns the list of child `assembly` nodes

#### Scenario: Access shape of assembly branch
- **WHEN** user calls `(assembly-shape (make-assembly :name "root"))`
- **THEN** system returns `nil`

### Requirement: Mutate node properties

The system SHALL provide setf accessors for `assembly-name`, `assembly-color`, and `assembly-children`.

#### Scenario: Setf name
- **WHEN** user calls `(setf (assembly-name node) "renamed")`
- **THEN** subsequent `(assembly-name node)` returns `"renamed"`

#### Scenario: Setf color
- **WHEN** user calls `(setf (assembly-color node) '(:generic 0 0 1 1))`
- **THEN** subsequent `(assembly-color node)` returns `(:generic 0.0 0.0 1.0 1.0)`

#### Scenario: Setf children
- **WHEN** user calls `(setf (assembly-children node) (list child-a child-b))`
- **THEN** subsequent `(assembly-children node)` returns the new children list

### Requirement: Color representation

The system SHALL represent colors as plists with a type keyword and four double-float components in [0,1]: `(:generic r g b a)`, `(:surf r g b a)`, or `(:curv r g b a)`. `nil` means no color assigned.

#### Scenario: Generic color
- **WHEN** user creates `'(:generic 1.0 0.5 0.0 0.8)`
- **THEN** the color type is `:generic`, RGBA components are `1.0, 0.5, 0.0, 0.8`

#### Scenario: Surface color
- **WHEN** user creates `'(:surf 0.2 0.4 0.6 1.0)`
- **THEN** the color type is `:surf`

#### Scenario: No color
- **WHEN** user creates a part without specifying color
- **THEN** `(assembly-color part)` returns `nil`

### Requirement: Location representation

The system SHALL represent locations as a 4×4 homogeneous transformation matrix in row-major order: `#(a0 a1 a2 a3 b0 b1 b2 b3 c0 c1 c2 c3 d0 d1 d2 d3)`. `nil` means identity (no location).

#### Scenario: Set location
- **WHEN** user calls `(make-part (make-box 1 2 3) :location #(1 0 0 0 0 1 0 0 0 0 1 0 5 10 15 1))`
- **THEN** the part has a location translating by (5, 10, 15)

#### Scenario: No location
- **WHEN** user creates a part without location
- **THEN** `(assembly-location part)` returns `nil`
