# cl-occt API Reference

## OCAF Document & Label Tree

OCAF (Open CASCADE Application Framework) document with label tree navigation.

### Classes

- **`ocaf-doc`** — CLOS class wrapping a `TDocStd_Document` handle.
- **`ocaf-label`** — Struct wrapping a `TDF_Label` handle. Labels are lightweight (no finalizer).

### Document Lifecycle

- **`(make-ocaf-doc)`** → `ocaf-doc` or `nil`
  Create a new OCAF document.
- **`(ocaf-free-doc doc)`** → `t`
  Free an OCAF document created with `make-ocaf-doc`.
- **`(ocaf-doc-p obj)`** → `boolean`
  Predicate for `ocaf-doc` type.

### Label Tree Navigation

- **`(ocaf-root-label doc)`** → `ocaf-label` or `nil`
  Return the root label (label 0:1) of the document.
- **`(ocaf-find-label doc tags &key create)`** → `ocaf-label` or `nil`
  Find or create a label by tag path. `tags` is a list of integers (e.g., `'(0 1 0)` for path 0:1:0). If `create` is true, missing labels are created.
- **`(ocaf-label-children label)`** → list of `ocaf-label` or `nil`
  Return the child labels of the given label.
- **`(ocaf-label-tag label)`** → integer
  Return the tag (integer) of the label.
- **`(ocaf-label-depth label)`** → integer
  Return the depth of the label in the label tree.
- **`(ocaf-label-p obj)`** → `boolean`
  Predicate for `ocaf-label` type.

### Document Transactions

- **`(ocaf-begin-transaction doc &optional name)` 
  Begin a transaction on the document.
- **`(ocaf-commit-transaction doc)` 
  Commit the current transaction.
- **`(ocaf-undo-transaction doc)` 
  Undo the last committed transaction.

---

## OCAF Attributes

Typed data attributes attached to labels.

### Integer Attributes

- **`(ocaf-set-integer label value)` 
  Set an integer attribute on the label.
- **`(ocaf-get-integer label)`** → integer
  Get the integer value from the label.
- **`(ocaf-has-integer-p label)`** → `boolean`
  Check if the label has an integer attribute.

### Real (Double) Attributes

- **`(ocaf-set-real label value)` 
  Set a real (double) attribute on the label.
- **`(ocaf-get-real label)`** → double
  Get the real value from the label.
- **`(ocaf-has-real-p label)`** → `boolean`
  Check if the label has a real attribute.

### String Attributes

- **`(ocaf-set-string label value)` 
  Set a string attribute on the label.
- **`(ocaf-get-string label)`** → string
  Get the string value from the label.
- **`(ocaf-has-string-p label)`** → `boolean`
  Check if the label has a string attribute.

### Name Attribute

- **`(ocaf-set-name label name)` 
  Set a name (extended string) attribute on the label.
- **`(ocaf-get-name label)`** → string or `nil`
  Get the name from the label.

---

## Topological Naming

Track shape identity through operations using `TNaming`.

### Evolution Keywords

The evolution of a named shape is specified by one of:
- `:primitive` — original shape
- `:generated` — shape generated from a previous shape
- `:modified` — shape modified from a previous shape
- `:deleted` — shape was deleted
- `:selected` — shape selected for an operation

### Functions

- **`(ocaf-name-shape label shape evolution)` 
  Name (tag) a shape on a label under the given evolution.
- **`(ocaf-get-named-shape label &optional (evolution :generated))`** → `shape` or `nil`
  Retrieve the named shape from the label. Returns `nil` if no shape is stored.
- **`(ocaf-shape-deleted-p label)`** → `boolean`
  Check if the named shape on this label was deleted.

---

## Parametric Functions

Define parametric function drivers and trigger recomputation.

- **`(ocaf-add-function label driver-guid)`** → `boolean`
  Create a `TFunction_Function` attribute on the label with the given driver GUID (string).
- **`(ocaf-set-function-input func-label input-label)`** → `boolean`
  Register `input-label` as an input to the function.
- **`(ocaf-set-function-output func-label output-label)`** → `boolean`
  Register `output-label` as an output of the function.
- **`(ocaf-recompute doc)`** → integer
  Recomputed all dirty functions in the document and returns the count.
- **`(ocaf-recompute-function func-label)`** → `boolean`
  Recompute a single function by its label.
