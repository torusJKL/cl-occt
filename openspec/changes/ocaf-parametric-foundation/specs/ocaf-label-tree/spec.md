## ADDED Requirements

### Requirement: Create OCAF document
The system SHALL create an OCAF document with a label tree using `TDF_Data` and `TDocStd_Document`.

#### Scenario: Create new document
- **WHEN** user calls `(make-ocaf-doc)`
- **WHEN** returns an `ocaf-doc` instance with a root label

### Requirement: Navigate label tree
The system SHALL navigate the label tree hierarchy using `TDF_Label` and `TDF_Tool`.

#### Scenario: Root label exists
- **WHEN** user calls `(ocaf-root-label doc)`
- **THEN** returns the root label (label 0)

#### Scenario: Find label by tag path
- **WHEN** user calls `(ocaf-find-label doc '(0 1 0))`
- **THEN** returns the label at path 0:1:0 (or creates if :create t)

#### Scenario: Label children
- **WHEN** user calls `(ocaf-label-children label)`
- **THEN** returns a list of child labels

#### Scenario: Label tag
- **WHEN** user calls `(ocaf-label-tag label)`
- **THEN** returns the tag (integer) of the label

#### Scenario: Label depth
- **WHEN** user calls `(ocaf-label-depth label)`
- **THEN** returns the depth (integer) of the label in the tree

### Requirement: Document transactions
The system SHALL support document transactions (commit, undo, redo) via `TDocStd_Document`.

#### Scenario: Begin and commit transaction
- **WHEN** user calls `(ocaf-begin-transaction doc "modify")` then `(ocaf-commit-transaction doc)`
- **THEN** changes are committed

#### Scenario: Undo last transaction
- **WHEN** user calls `(ocaf-undo-transaction doc)`
- **THEN** reverts the last committed transaction
