## 1. Build configuration

- [x] 1.1 Add `-lTKMeshVS` to `justfile` wrap recipe (MeshVS library from ApplicationFramework module)

## 2. C wrapper — BRepMesh_IncrementalMesh

- [x] 2.1 Add `mesh_shape` function declaration to `wrap/occt_wrap.h` with deflection, angle, and relative params
- [x] 2.2 Add `mesh_shape` implementation in `wrap/occt_wrap.cpp` using `BRepMesh_IncrementalMesh(shape, deflection, angle, relative)`

## 3. C wrapper — Poly_Triangulation data extraction

- [x] 3.1 Add `mesh_get_vertices` function declaration/implementation: iterate faces via `TopExp_Explorer`, call `BRep_Tool::Triangulation`, accumulate nodes via `Poly_Triangulation::Nodes()`
- [x] 3.2 Add `mesh_get_triangles` function declaration/implementation: return triangle index arrays via `Poly_Triangulation::Triangles()`
- [x] 3.3 Add `mesh_get_normals` function declaration/implementation: return per-vertex normals via `Poly_Triangulation::Normals()`
- [x] 3.4 Add `mesh_get_triangle_count` function declaration/implementation: return total triangle count across all faces

## 4. C wrapper — Poly_Connect connectivity

- [x] 4.1 Add `mesh_triangle_adjacent` function declaration/implementation using `Poly_Connect::Triangle()` method
- [x] 4.2 Add `mesh_triangle_elements` function declaration/implementation returning three node indices

## 5. C wrapper — MeshVS_Mesh + DataSource

- [x] 5.1 Add `meshvs_create_mesh` function declaration/implementation returning `MeshVS_Mesh` handle
- [x] 5.2 Add custom `MeshVS_DataSource` subclass in `occt_wrap.cpp` storing vertex/triangle/color data
- [x] 5.3 Add `meshvs_set_data` function declaration/implementation to populate the data source
- [x] 5.4 Add `meshvs_display` function declaration/implementation using `AIS_InteractiveContext::Display`
- [x] 5.5 Add `meshvs_free` function declaration/implementation

## 6. C wrapper — RWMesh utility enums

- [x] 6.1 Add `rwmesh_coordinate_system_from_keyword` and `rwmesh_name_format_from_keyword` helper functions (map keyword ints to OCCT enums)
- [x] 6.2 Add enum constant definitions for `RWMesh_CoordinateSystem` and `RWMesh_NameFormat` values

## 7. C wrapper — Update write-stl with meshing params

- [x] 7.1 Update `write_stl` declaration in `wrap/occt_wrap.h` to accept angle and relative params
- [x] 7.2 Update `write_stl` implementation to pass angle/relative to `BRepMesh_IncrementalMesh`

## 8. CFFI bindings

- [x] 8.1 Add `defcfun` for mesh functions (`%mesh-shape`, `%mesh-get-vertices`, `%mesh-get-triangles`, `%mesh-get-normals`, `%mesh-get-triangle-count`) in `src/ffi/bindings.lisp`
- [x] 8.2 Add `defcfun` for connectivity functions (`%mesh-triangle-adjacent`, `%mesh-triangle-elements`) in `src/ffi/bindings.lisp`
- [x] 8.3 Add `defcfun` for MeshVS functions (`%meshvs-create-mesh`, `%meshvs-set-data`, `%meshvs-display`, `%meshvs-free`) in `src/ffi/bindings.lisp`
- [x] 8.4 Add `defcfun` for updated `write-stl` (`%write-stl` signature update) in `src/ffi/bindings.lisp`

## 9. CLOS wrapper functions

- [x] 9.1 Create `src/core/mesh.lisp` with `mesh-shape` function wrapping `%mesh-shape`
- [x] 9.2 Add `mesh-get-vertices`, `mesh-get-triangles`, `mesh-get-normals`, `mesh-get-triangle-count` functions returning Lisp-friendly data
- [x] 9.3 Add `mesh-triangle-adjacent`, `mesh-triangle-elements` functions for connectivity queries
- [x] 9.4 Add `meshvs-mesh` CLOS class with `tg:finalize` for GC, and `make-meshvs-mesh` constructor
- [x] 9.5 Add `meshvs-display`, `meshvs-free` and property setter functions
- [x] 9.6 Add `*coordinate-system-map*` and `*name-format-map*` if not already present (from mesh-io-bindings)
- [x] 9.7 Update `write-stl` to accept `:angle` and `:relative` keyword arguments and pass to CFFI

## 10. Update shape-triangle-count

- [x] 10.1 Update `shape-triangle-count` in `src/core/topology.lisp` to auto-mesh via `mesh-shape` if no triangulation exists (C-level auto-mesh already present in shape_triangle_count)

## 11. Package exports

- [x] 11.1 Add `%mesh-shape`, `%mesh-get-vertices`, `%mesh-get-triangles`, `%mesh-get-normals`, `%mesh-get-triangle-count`, `%mesh-triangle-adjacent`, `%mesh-triangle-elements`, `%meshvs-create-mesh`, `%meshvs-set-data`, `%meshvs-display`, `%meshvs-free` to `cl-occt.impl` package
- [x] 11.2 Add `mesh-shape`, `mesh-get-vertices`, `mesh-get-triangles`, `mesh-get-normals`, `mesh-get-triangle-count`, `mesh-triangle-adjacent`, `mesh-triangle-elements`, `make-meshvs-mesh`, `meshvs-display`, `meshvs-free` to `cl-occt` package

## 12. Tests

- [x] 12.1 Add `mesh-shape` tests (default params, custom deflection, angle, relative mode, nil handling) in `t/smoke-tests.lisp`
- [x] 12.2 Add `mesh-get-vertices` and `mesh-get-triangles` tests (data extraction, unmeshed shape, nil shape) in `t/smoke-tests.lisp`
- [x] 12.3 Add `mesh-triangle-adjacent` and `mesh-triangle-elements` tests (adjacency, boundary edge, invalid index) in `t/smoke-tests.lisp`
- [x] 12.4 Add MeshVS tests (create, display, free, nil handling) in `t/smoke-tests.lisp`
- [x] 12.5 Add `write-stl` updated signature tests (angle, relative params) in `t/smoke-tests.lisp`
- [x] 12.6 Register all new tests in `run-core-tests` function

## 13. API reference

- [x] 13.1 Add Mesh Operations section to `docs/api-reference.md` with all new functions and descriptions
- [x] 13.2 Update `write-stl` entry to document `:angle` and `:relative` parameters

## 14. Compile and verify

- [x] 14.1 Run `just wrap` and fix any compilation errors
- [x] 14.2 Run `just test-core` and verify all tests pass
