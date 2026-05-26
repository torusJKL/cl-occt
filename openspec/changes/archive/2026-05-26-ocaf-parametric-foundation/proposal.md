## Why

The existing XCAF layer provides assembly/color/layer metadata on top of OCAF documents, but the underlying OCAF framework — the label tree (`TDF_Label`), attributes (`TDataStd_*`), topological naming (`TNaming`), and parametric recomputation (`TFunction`) — is completely unwrapped. Without these, cl-occt cannot track which specific face or edge corresponds to which after a boolean operation, cannot maintain a feature tree with history, and cannot support parametric regeneration. This is the foundation for true parametric CAD in Lisp.

## What Changes

- **TDF Label Tree**: `TDF_Data`, `TDF_Label` — create/open documents, navigate the label hierarchy, find/add labels
- **Standard Attributes**: `TDataStd_Integer`, `TDataStd_Real`, `TDataStd_AsciiString` — attach typed data to labels
- **Topological Naming**: `TNaming_Builder`, `TNaming_NamedShape` — track shape identity through boolean operations (select a face, do a cut, identify the resulting face)
- **Function / Recompute**: `TFunction_Function`, `TFunction_Driver` — define parametric functions that recompute when inputs change
- **Document Transactions**: `TDocStd_Document` — commit/undo transactions for parametric workflows
- **Documentation**: Update `api-reference.md` with all new function signatures

## Capabilities

### New Capabilities

- `ocaf-label-tree`: TDF_Data document, TDF_Label navigation (root label, find label, tag-based addressing), label children iteration
- `ocaf-attributes`: TDataStd typed attributes (Integer, Real, String) — set, get, remove on labels
- `ocaf-topological-naming`: TNaming_Builder to name shapes, TNaming_NamedShape to retrieve named shapes by label, identity tracking through boolean operations
- `ocaf-parametric-functions`: TFunction — define parametric drivers with input/output labels, trigger recomputation

### Modified Capabilities

(none — new capability area, existing xcaf-doc spec covers higher-level application tools)

## Impact

- **C wrapper** (`wrap/`): ~15 new `extern "C"` functions across 4 capability areas
- **CFFI layer** (`src/ffi/`): ~15 new `defcfun` bindings
- **Core layer** (`src/core/`): New `ocaf-label-tree.lisp`, `ocaf-attributes.lisp`, `ocaf-naming.lisp`, `ocaf-functions.lisp`
- **Tests** (`tests/`): Label tree tests, attribute tests, naming tests, function tests
- **Docs** (`doc/api-reference.md`): OCAF Framework sections
