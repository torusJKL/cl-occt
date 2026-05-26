## Context

cl-occt currently wraps STEP and STL I/O across 3 layers: C wrapper (`wrap/occt_wrap.h/cpp`), CFFI bindings (`src/ffi/bindings.lisp`), and CLOS wrappers (`src/core/io.lisp`). Each new format follows this exact layering. OCCT 8.0 is built with `BUILD_MODULE_DataExchange=ON`, which compiles all exchange toolkits (TKIGES, TKVrml, TKGltf, TKPly, TKOBJ, TKRWG) but they are not linked into `lib/libocctwrap.so`.

The user needs bindings for 6 additional format families: IGES, OBJ, VRML, glTF, PLY, plus mesh I/O utility enums.

## Goals / Non-Goals

**Goals:**
- Expose IGES import/export (basic + XCAF/assembly-aware) via CLOS functions
- Expose OBJ mesh import/export with per-vertex color support
- Expose VRML mesh export
- Expose glTF import/export with scene/color support
- Expose PLY mesh export
- Expose RWMesh_CoordinateSystem and RWMesh_NameFormat enums for mesh I/O configuration
- Follow existing 3-layer pattern: C wrapper → CFFI → CLOS wrappers
- Add tests matching the existing I/O test patterns

**Non-Goals:**
- DAG/reactive model support for new formats (assembly-tree format is STEP/XDE-only)
- Full OCCT CAF document API exposure — only reader/writer classes
- glTF/OBJ binary format handling details — delegate to OCCT
- GUI or viewer integration for new format previews
- Format conversion (e.g., IGES→STEP) — user must read then separately write

## Decisions

1. **Layer 1 — C wrapper style**: Follow existing pattern: `clear_error()`, null checks, `try`/`catch(Standard_Failure&)`, return `int` or `occt_shape`/`xde_doc`. For CAF-aware readers/writers that return documents, use `xde_doc` (already defined opaque type). For simple readers returning shapes, use `occt_shape`.

2. **Layer 2 — CFFI style**: Follow existing `%`-prefixed `defcfun` pattern in `src/ffi/bindings.lisp`. Format-specific naming: `%write-obj`, `%read-obj`, `%write-iges`, `%read-iges`, `%read-iges-assembly`, `%write-iges-assembly`, `%write-vrml`, `%write-gltf`, `%read-gltf`, `%write-ply`, etc.

3. **Layer 3 — CLOS style**: Follow existing `write-step`/`read-step` pattern in `src/core/io.lisp`. Write wrappers validate arguments, call `%`-prefixed CFFI, handle errors via `occt-condition`. Read wrappers use `make-shape` for shape-returning functions.

4. **CAF-aware readers return `assembly` trees**: IGESCAFControl and RWGltf_CafReader can read assemblies with colors/names. Rather than introducing a new doc type, follow the XDE pattern: return an `assembly` tree (reusing `make-assembly`/`make-part` from assembly-tree capability). This means reusing `%read-node`/`%write-node` logic for IGES and glTF CAF readers.

5. **Mesh utility enums**: Expose `RWMesh_CoordinateSystem` and `RWMesh_NameFormat` as keyword-based constants in CLOS wrappers (e.g., `:coordinate-system-zup`, `:name-auto`). The C wrapper will accept `int` values and the CLOS layer will provide the keyword→int mapping.

6. **Linker flags**: Add `-lTKIGES -lTKVrml -lTKGltf -lTKPly -lTKOBJ -lTKRWG` to the `justfile` `wrap:` recipe's `g++` command. These libraries are already built by the OCCT setup — only linking is missing.

7. **Per-vertex colors in OBJ**: `RWObj_CafWriter` already handles per-vertex colors via `RWMesh_CafWriter` base class. The C wrapper will accept an optional color attribute parameter. The CLOS wrapper will expose `:per-vertex-colors` keyword. `RWMesh_CoordinateSystem` will let users specify Yup/Zup.

8. **glTF coordinate system**: `RWGltf_CafWriter` and `RWGltf_CafReader` accept `RWMesh_CoordinateSystem` parameter. Default to Zup (glTF convention) but allow Yup via keyword.

## Risks / Trade-offs

- **Risk**: IGESCAFControl and RWGltf_CafReader may produce complex document structures that don't map cleanly to simple `assembly` trees → **Mitigation**: Flatten to the same XDE tree model used by STEP — only shape, name, color, location per node.
- **Risk**: Per-vertex color support in OBJ/glTF adds complexity to the C wrapper API (need mesh attribute access) → **Mitigation**: Use simple flag/pointer approach: pass colors as a flat array of RGBA floats if available.
- **Risk**: Adding 6 new library links to `libocctwrap.so` increases binary size and link time → **Acceptable**: Libraries are already built and lazy-loaded; size increase is proportional to the new functionality.
- **Risk**: VrmlAPI_Writer is limited to VRML 1.0/2.0 export only (no import) → **Acceptable**: This matches OCCT's capability; document as export-only.
- **Trade-off**: Can't easily test glTF/OBJ round-trips without reference files; unit tests will verify file creation and re-import rather than byte-exact comparison.
