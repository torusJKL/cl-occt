## Why

cl-occt currently hard-codes BRepMesh_IncrementalMesh inside C wrapper I/O functions and uses Poly_Triangulation only internally for viewer triangulation display. Users have no API-level control over meshing parameters (deflection, angle), cannot access mesh geometry data (vertices, triangles, normals) programmatically, cannot query triangle adjacency via Poly_Connect, and cannot display raw polygonal meshes in the viewer via MeshVS. Exposing these OCCT mesh classes will enable custom meshing workflows, mesh analysis, and mesh visualization.

## What Changes

- Add C wrapper functions in `wrap/occt_wrap.h` and `wrap/occt_wrap.cpp` for:
  - **BRepMesh_IncrementalMesh**: `mesh_shape(shape, deflection, angle, relative)` to explicitly control shape meshing
  - **Poly_Triangulation access**: `mesh_get_triangulation(shape)` returning vertex array, triangle array, and triangle count; `mesh_get_normals(shape)` returning normal array
  - **Poly_Connect**: `mesh_triangle_adjacent(shape, tri_index, edge_index)` returning adjacent triangle index; `mesh_triangle-elements(shape, tri_index)` returning 3 vertex indices
  - **MeshVS_Mesh + MeshVS_DataSource**: `meshvs_create_mesh()` returning a MeshVS mesh object; `meshvs_set_data(source)` to attach data; `meshvs_display(ctx, mesh)` to display in viewer
  - **RWMesh utilities**: `rwmesh_coordinate_system` enum values and helper functions
- Add CFFI `defcfun` bindings in `src/ffi/bindings.lisp`
- Add CLOS wrapper functions in new `src/core/mesh.lisp` following existing patterns
- Add tests in `t/smoke-tests.lisp`
- Update `docs/api-reference.md` with new mesh API functions

## Capabilities

### New Capabilities
- `mesh-control`: BRepMesh_IncrementalMesh exposed as explicit mesh_shape with deflection/angle/relative control
- `mesh-data-access`: Poly_Triangulation vertex/triangle/normal data extraction from meshed shapes
- `mesh-connectivity`: Poly_Connect triangle adjacency and element queries
- `mesh-viewer-display`: MeshVS_Mesh + MeshVS_DataSource for raw polygonal mesh display in viewer
- `rwmesh-utilities`: RWMesh_CoordinateSystem and RWMesh_NameFormat enum wrappers (supplemental to existing mesh-io-utilities)

### Modified Capabilities
- `stl-io`: Update write-stl to accept optional deflection/angle parameters (currently hard-coded)
- `topology-navigation`: Extend shape-triangle-count to return nil gracefully on unmeshed shapes

## Impact

- **`wrap/occt_wrap.h`**: ~20 new `extern "C"` function declarations
- **`wrap/occt_wrap.cpp`**: ~400-600 new lines of C++ wrapper code (mesh creation, triangulation extraction, connectivity, MeshVS)
- **`src/ffi/bindings.lisp`**: ~20 new `defcfun` declarations
- **`src/core/mesh.lisp`** (new file): ~200-300 lines of CLOS wrapper functions
- **`src/package.lisp`**: ~25 new exported symbols across `cl-occt.impl` and `cl-occt`
- **`t/smoke-tests.lisp`**: ~80-100 new test cases
- **`docs/api-reference.md`**: New mesh API section
- **`justfile`**: No change needed — `-lTKMesh`, `-lTKRWMesh` already linked
