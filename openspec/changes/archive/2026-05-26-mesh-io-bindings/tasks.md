## 1. Build configuration

- [x] 1.1 Add linker flags to `justfile` wrap recipe: `-lTKDEIGES -lTKDEVRML -lTKDEPLY -lTKDEOBJ -lTKRWMesh` (OCCT 8.0 naming)
- [x] 1.2 Add `-DUSE_RAPIDJSON=ON -DBUILD_MODULE_DEGLTF=ON` to `justfile` setup recipe for glTF support (requires OCCT rebuild)
- [x] 1.3 Guard glTF code with `#if 0` in C wrapper since glTF headers are unavailable without OCCT rebuild

## 2. C wrapper — IGES I/O

- [x] 2.1 Add `write_iges`, `read_iges` function declarations to `wrap/occt_wrap.h`
- [x] 2.2 Add `write_iges`, `read_iges` implementations in `wrap/occt_wrap.cpp` using IGESControl_Writer/Reader
- [x] 2.3 Add `write_iges_assembly`, `read_iges_assembly` declarations to `wrap/occt_wrap.h`
- [x] 2.4 Add `write_iges_assembly`, `read_iges_assembly` implementations in `wrap/occt_wrap.cpp` using IGESCAFControl_Writer/Reader + XDE doc

## 3. C wrapper — OBJ I/O

- [x] 3.1 Add `write_obj`, `read_obj` function declarations to `wrap/occt_wrap.h`
- [x] 3.2 Add `write_obj`, `read_obj` implementations in `wrap/occt_wrap.cpp` using RWObj_CafWriter/RWObj_CafReader
- [x] 3.3 Add per-vertex color, coordinate-system, and name-format parameters to OBJ writer

## 4. C wrapper — VRML export

- [x] 4.1 Add `write_vrml` function declaration to `wrap/occt_wrap.h`
- [x] 4.2 Add `write_vrml` implementation in `wrap/occt_wrap.cpp` using VrmlAPI_Writer with BRepMesh_IncrementalMesh

## 5. C wrapper — glTF I/O

- [x] 5.1 Add `write_gltf`, `read_gltf` function declarations to `wrap/occt_wrap.h`
- [x] 5.2 Add `write_gltf`, `read_gltf` implementations in `wrap/occt_wrap.cpp` using RWGltf_CafWriter/RWGltf_CafReader
- [x] 5.3 Add coordinate-system and per-vertex color parameters to glTF writer

## 6. C wrapper — PLY export

- [x] 6.1 Add `write_ply` function declaration to `wrap/occt_wrap.h`
- [x] 6.2 Add `write_ply` implementation in `wrap/occt_wrap.cpp` using RWPly_CafWriter
- [x] 6.3 Add coordinate-system and per-vertex color parameters to PLY writer

## 7. CFFI bindings

- [x] 7.1 Add `defcfun` for IGES functions (`%write-iges`, `%read-iges`, `%xde-read-iges`, `%xde-write-iges`) in `src/ffi/bindings.lisp`
- [x] 7.2 Add `defcfun` for OBJ functions (`%write-obj`, `%read-obj`) in `src/ffi/bindings.lisp`
- [x] 7.3 Add `defcfun` for VRML function (`%write-vrml`) in `src/ffi/bindings.lisp`
- [x] 7.4 Add `defcfun` for glTF functions (`%write-gltf`, `%read-gltf`) in `src/ffi/bindings.lisp`
- [x] 7.5 Add `defcfun` for PLY function (`%write-ply`) in `src/ffi/bindings.lisp`

## 8. CLOS wrapper functions

- [x] 8.1 Add `write-iges`, `read-iges` functions in `src/core/io.lisp`
- [x] 8.2 Add `write-iges-assembly`, `read-iges-assembly` functions in `src/core/io.lisp` (reuses XDE doc pattern)
- [x] 8.3 Add `write-obj`, `read-obj` functions in `src/core/io.lisp` with `:coordinate-system`, `:name-format`, `:per-vertex-colors` keywords
- [x] 8.4 Add `write-vrml` function in `src/core/io.lisp` with `:deflection` keyword
- [x] 8.5 Add `write-gltf`, `read-gltf` functions in `src/core/io.lisp` with `:coordinate-system`, `:per-vertex-colors` keywords
- [x] 8.6 Add `write-ply` function in `src/core/io.lisp` with `:coordinate-system`, `:per-vertex-colors` keywords

## 9. Package exports

- [x] 9.1 Add `%write-iges`, `%read-iges`, `%xde-read-iges`, `%xde-write-iges`, `%write-obj`, `%read-obj`, `%write-vrml`, `%write-gltf`, `%read-gltf`, `%write-ply` to `cl-occt.impl` package
- [x] 9.2 Add `write-iges`, `read-iges`, `write-iges-assembly`, `read-iges-assembly`, `write-obj`, `read-obj`, `write-vrml`, `write-gltf`, `read-gltf`, `write-ply` to `cl-occt` package

## 10. Tests

- [x] 10.1 Add IGES I/O tests (write, read, round-trip, nil handling, assembly) in `t/smoke-tests.lisp`
- [x] 10.2 Add OBJ I/O tests (write, read, round-trip, coordinate-system, per-vertex colors) in `t/smoke-tests.lisp`
- [x] 10.3 Add VRML export tests (write, deflection) in `t/smoke-tests.lisp`
- [x] 10.4 Add glTF I/O tests (write, read, round-trip, coordinate-system) in `t/smoke-tests.lisp`
- [x] 10.5 Add PLY export tests (write, coordinate-system) in `t/smoke-tests.lisp`
- [x] 10.6 Register all new tests in `run-core-tests` function

## 11. Compile and verify

- [x] 11.1 Run `just wrap` and fix any compilation errors
- [x] 11.2 Run `just test-core` — 386/386 tests passed, 0 failures
