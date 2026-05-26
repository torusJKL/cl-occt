## Context

OCAF (Open CASCADE Application Framework) is OCCT's document-oriented data model. It has three layers:
1. **TDF** (Tree Data Framework): the low-level label tree with attributes attached to nodes
2. **TNaming**: topological naming — tracks shape identity through operations
3. **TFunction**: parametric recomputation — defines functions that update when inputs change

The existing `xcaf-doc` wraps the highest layer (`XCAFDoc_ShapeTool`, `XCAFDoc_ColorTool`, etc.) which uses TDF internally but doesn't expose it. This change exposes the underlying TDF/TNaming/TFunction infrastructure while keeping the existing xcaf-doc API unchanged.

## Goals / Non-Goals

**Goals:**
- TDF_Data document with label tree navigation (root label, find, children, tags)
- TDataStd typed attributes (Integer, Real, String, Name)
- TNaming_Builder/NamedShape for shape identity tracking
- TFunction function definitions and recomputation
- TDocStd_Document transaction support (begin, commit, undo)

**Non-Goals:**
- No changes to existing xcaf-doc API
- No XCAF-specific tools (colors, layers, materials — those belong in xcaf-doc change if missing)
- No STEP/XDE persistence of OCAF documents (already exists via %xde-read-step/%xde-write-step)
- No assembly graph or view management — those are XCAF-level

## Decisions

### 1. OCAF document wraps TDocStd_Document
A new `ocaf-doc` CLOS class (or extend the existing `xcaf-doc` class — needs investigation) wraps `TDocStd_Document` handle. The existing `xcaf-doc` might itself wrap the same handle, in which case the new functions can operate on the same class.

### 2. Labels are lightweight wrappers
`TDF_Label` is a handle (not a pointer that needs freeing). The Lisp wrapper is a simple struct or class with no finalizer — labels are invalidated by the document, not by reference counting.

### 3. TNaming uses evolution model
`TNaming_Builder` supports `TNaming_Evolution` enum: `PRIMITIVE`, `GENERATED`, `MODIFIED`, `DELETED`, `SELECTED`. The Lisp API exposes these as keywords (`:selected`, `:generated`, `:modified`, `:deleted`, `:primitive`).

### 4. Functions use GUID-based driver registration
`TFunction_Driver` is identified by a GUID. The Lisp API will use a string-based GUID or a predefined set of driver GUIDs. The actual driver logic must be implemented in C++ (there's no way to register Lisp functions as OCCT drivers directly) — the Lisp side triggers recomputation.

### 5. File layout

| What | Where |
|------|-------|
| C TDF/TDocStd | New `wrap/occt_wrap_ocaf_core.cpp` |
| C TNaming | New `wrap/occt_wrap_ocaf_naming.cpp` |
| C TFunction | New `wrap/occt_wrap_ocaf_function.cpp` |
| CFFI | New CFFI bindings files in `src/ffi/` |
| Core label tree | New `src/core/ocaf-label-tree.lisp` |
| Core attributes | New `src/core/ocaf-attributes.lisp` |
| Core naming | New `src/core/ocaf-naming.lisp` |
| Core functions | New `src/core/ocaf-functions.lisp` |

## Risks / Trade-offs

- **TNaming is OCCT's most complex subsystem.** The naming model (evolutions, contexts, scope) is deep. The initial API covers the 80% case (SELECTED → GENERATED tracking), which is what an AI needs to answer "what happened to that face after the boolean?"
- **TFunction drivers must be C++** — Lisp cannot directly implement a TFunction_Driver. The initial implementation will use a generic driver that calls back into Lisp via a C function pointer, or will require pre-registered C++ drivers. This needs a prototype to validate.
- **OCAF documents have persistence drivers** (BinDrivers, XmlDrivers) that must be loaded for document operations to work. The C wrapper must initialize these.
