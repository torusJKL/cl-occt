## Context

cl-occt currently supports B-Rep geometry operations and STEP I/O. STL is fundamentally different from STEP: STL is a mesh (triangle) format with no topological information, while STEP preserves exact B-Rep. Exporting to STL requires tessellation (converting B-Rep to a triangle mesh), and importing from STL produces a mesh shape.

The user needs control over tessellation quality — coarser meshes for quick previews, finer meshes for fabrication.

## Goals / Non-Goals

**Goals:**
- Binary STL export from any shape via `write-stl`, analogous to `write-step`
- STL import via `read-stl`, analogous to `read-step`
- Configurable tessellation via `:deflection` keyword (maps to `BRepMesh_IncrementalMesh` linear deflection)
- Reasonable default deflection (0.1) for general use
- Error handling matching the existing nil-propagation pattern

**Non-Goals:**
- ASCII STL export (binary STL is the de facto standard and more compact)
- STL color/attribute storage (STL is a pure geometry format)
- High-performance mesh generation for extremely large models
- STL-specific quality metrics beyond linear deflection (angular deflection uses OCCT default)

## Decisions

### C Wrapper: Two new functions for STL I/O

`write_stl(shape, filename, deflection)` — tessellates the shape with `BRepMesh_IncrementalMesh` using the given linear deflection, then writes via `StlAPI_Writer::Write`. Returns 1 on success, 0 on error (matching `write_step`).

`read_stl(filename)` — reads an STL file via `StlAPI_Reader::Read`, returns the shape pointer or nullptr on error (matching `read_step`).

**Alternatives considered:**
- *Separate tessellation control function*: Rejected — keeping tessellation as a parameter to `write_stl` is simpler and matches the "it's a single operation" mental model.
- *Angular deflection parameter*: Rejected for V1 — linear deflection is the primary quality control; angular deflection can be added later if needed.

### Tessellation via BRepMesh_IncrementalMesh

OCCT's `BRepMesh_IncrementalMesh` is the standard way to produce a triangulation for any `TopoDS_Shape`. It is called just before `StlAPI_Writer::Write`. The shape is modified in place (the triangulation is attached as a sub-shape property), so we pass the shape by value (OCCT handles copy-on-write internally).

### Link Libraries: Add TKSTL and TKMesh

The `justfile` wrap recipe needs two additional libraries:
- `-lTKDESTL` for `StlAPI_Writer` / `StlAPI_Reader`
- `-lTKMesh` for `BRepMesh_IncrementalMesh`

### Lisp API: Keyword argument for deflection

```lisp
(write-stl shape path &key (deflection 0.1d0))
```

The CL function wraps the `%write-stl` FFI call, passing the deflection value. `make-shape` handles the null-pointer → nil conversion on import.

### Spec scanning for BRepMesh headers

The `BRepMesh_IncrementalMesh` header path is `#include <BRepMesh_IncrementalMesh.hxx>`. The `StlAPI_Writer` and `StlAPI_Reader` headers are `#include <StlAPI_Writer.hxx>` and `#include <StlAPI_Reader.hxx>`.

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| `BRepMesh_IncrementalMesh` can be slow on complex shapes | Acceptable for V1; deflection can be increased for faster (coarser) meshes |
| STL import produces a faceted shape, not exact B-Rep | Documented behavior — `read-stl` returns a mesh, not a parametric shape |
| `TKSTL` or `TKMesh` may not be available in minimal OCCT builds | Ensure `BUILD_MODULE_DataExchange=ON` and `BUILD_MODULE_ModelingAlgorithms=ON` in setup; they already are |
| Large STL files may consume significant memory | Binary STL is more compact than ASCII; defer streaming support to future |
