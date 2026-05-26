## Why

OCCT's XCAF document framework provides rich metadata capabilities (layers, materials, dimensions/tolerances, views, notes, visual materials, clipping planes) that are currently inaccessible from cl-occt. The existing XDE document support is limited to assembly I/O — users cannot programmatically attach or query metadata on shapes within a document. Adding bindings for the core XCAF document tools unlocks document-centric CAD workflows directly from Common Lisp.

## What Changes

- Add C wrapper functions in `wrap/occt_wrap.h` and `wrap/occt_wrap.cpp` for:
  - `XCAFApp_Application` — application initialization, document creation
  - `XCAFDoc_LayerTool` — layer assignment and query on shapes
  - `XCAFDoc_MaterialTool` — material properties (density, name) on shapes
  - `XCAFDoc_DimTolTool` — dimension and tolerance annotations on shapes
  - `XCAFDoc_ViewTool` — saved view management in documents
  - `XCAFDoc_NotesTool` — textual notes/annotations
  - `XCAFDoc_VisMaterialTool` — visual material properties (PBR, transparency)
  - `XCAFDoc_ClippingPlaneTool` — clipping plane definitions
  - `XCAFDoc_Editor` — document-level editing operations
- Add FFI bindings (`%`-prefixed) in `src/ffi/bindings.lisp`
- Add core wrapper layer in `src/core/xcaf-doc.lisp` exposing a high-level API
- Add unit tests in `t/smoke-tests.lisp`
- Update `docs/api-reference.md` with new API section
- Export new public symbols from `cl-occt` in `src/package.lisp`

## Capabilities

### New Capabilities
- `xcaf-doc`: Document-level metadata management for XCAF documents — layers, materials, dims/tols, views, notes, visual materials, clipping planes, edit operations

### Modified Capabilities
<!-- No existing capability specs change — this is entirely new functionality -->

## Impact

- **C++ wrapper**: `wrap/occt_wrap.h` / `wrap/occt_wrap.cpp` — new extern "C" functions (~300-400 lines)
- **FFI layer**: `src/ffi/bindings.lisp` — new `%xcaf-*` defcfun bindings (~80 lines)
- **Core layer**: `src/core/xcaf-doc.lisp` — new file with CLOS wrappers (~400 lines)
- **ASDF**: `cl-occt.asd` — register the new `xcaf-doc.lisp` file
- **Package**: `src/package.lisp` — export new symbols from `cl-occt` and `cl-occt.impl`
- **Tests**: `t/smoke-tests.lisp` — ~15 new test cases
- **Docs**: `docs/api-reference.md` — new "XCAF Document Tools" section
- **Dependencies**: No new OCCT libraries needed; `-lTKXCAF -lTKCAF` are already linked
