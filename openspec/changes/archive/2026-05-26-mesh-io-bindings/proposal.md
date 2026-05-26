## Why

cl-occt currently only supports STEP and STL file formats for CAD data exchange. Users need access to additional industry-standard formats — IGES (legacy CAD), OBJ (mesh/3D printing), VRML (web 3D), glTF (modern web/rendering), and PLY (point clouds/scanned data) — to interoperate with the broader CAD/3D ecosystem.

## What Changes

- Add C wrapper functions in `wrap/occt_wrap.h` and `wrap/occt_wrap.cpp` for:
  - **IGES import/export**: `IGESControl_Reader`, `IGESControl_Writer` (basic), `IGESCAFControl_Reader`, `IGESCAFControl_Writer` (assembly-aware with colors/names)
  - **OBJ import/export**: `RWObj_CafReader`, `RWObj_CafWriter` (per-vertex color support via `RWMesh_CafWriter`)
  - **VRML export**: `VrmlAPI_Writer`
  - **glTF import/export**: `RWGltf_CafReader`, `RWGltf_CafWriter`
  - **PLY export**: `RWPly_CafWriter`
  - **Mesh utility enums**: `RWMesh_CoordinateSystem`, `RWMesh_NameFormat`
- Add CFFI `defcfun` bindings in `src/ffi/bindings.lisp`
- Add CLOS wrapper functions in `src/core/io.lisp` following existing patterns (`write-step`, `read-step`, etc.)
- Add tests in `t/smoke-tests.lisp`
- Update `justfile` to link additional OCCT libraries: `-lTKIGES`, `-lTKVrml`, `-lTKGltf`, `-lTKPly`, `-lTKOBJ`, `-lTKRWG`
- Update `src/package.lisp` to export new symbols

## Capabilities

### New Capabilities
- `iges-io`: IGES format import/export (basic shapes via IGESControl, colored assemblies via IGESCAFControl)
- `obj-io`: OBJ mesh format import/export with per-vertex color support via RWObj_CafReader/RWObj_CafWriter
- `vrml-io`: VRML format export via VrmlAPI_Writer
- `gltf-io`: glTF format import/export with scene/color support via RWGltf_CafReader/RWGltf_CafWriter
- `ply-io`: PLY mesh format export via RWPly_CafWriter
- `mesh-io-utilities`: RWMesh_CoordinateSystem and RWMesh_NameFormat enums for mesh I/O configuration

### Modified Capabilities
- *(none — no existing capability requirements are changing)*

## Impact

- **`wrap/occt_wrap.h`**: ~30 new `extern "C"` function declarations
- **`wrap/occt_wrap.cpp`**: ~600-800 new lines of C++ wrapper code
- **`src/ffi/bindings.lisp`**: ~30 new `defcfun` declarations
- **`src/core/io.lisp`**: ~150-200 new lines of CLOS wrapper functions
- **`src/package.lisp`**: ~30 new exported symbols across `cl-occt.impl` and `cl-occt`
- **`t/smoke-tests.lisp`**: ~80-100 new test cases
- **`justfile`**: 6 new linker flags (`-lTKIGES`, `-lTKVrml`, `-lTKGltf`, `-lTKPly`, `-lTKOBJ`, `-lTKRWG`)
- **OCCT CMake flags**: No change needed — `BUILD_MODULE_DataExchange=ON` already builds these toolkits
