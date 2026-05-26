## Context

cl-occt currently uses `BRepMesh_IncrementalMesh` and `Poly_Triangulation` internally within the C wrapper (for STL/VRML/OBJ/PLY/glTF export, AIS_Triangulation), but these are not exposed as public API. The `shape-triangle-count` function in `src/core/topology.lisp` provides limited access via `BRep_Tool::Triangulation`. `Poly_Connect` and `MeshVS_Mesh`/`MeshVS_DataSource` are not used at all. The `-lTKMesh` and `-lTKRWMesh` libraries are already linked in the `justfile`.

The existing 3-layer pattern (C wrapper → CFFI → CLOS) is well-established. The new mesh API will follow this same layering. MeshVS requires `-lTKMeshVS` which is part of the Visualization module already built with `BUILD_MODULE_ApplicationFramework=ON`.

## Goals / Non-Goals

**Goals:**
- Expose `BRepMesh_IncrementalMesh` as a public `mesh-shape` CLOS function with deflection, angle, and relative parameters
- Expose `Poly_Triangulation` vertex/triangle/normal data extraction as `mesh-get-vertices`, `mesh-get-triangles`, `mesh-get-normals`
- Expose `Poly_Connect` triangle adjacency and element queries as `mesh-triangle-adjacent`, `mesh-triangle-elements`, `mesh-triangle-nodes`
- Expose `MeshVS_Mesh` + `MeshVS_DataSource` for viewer-based mesh display without TopoDS_Shape
- Expose `RWMesh_CoordinateSystem` and `RWMesh_NameFormat` enum mappings (supplemental to mesh-io-bindings)
- Update `write-stl` to accept `:angle` and `:relative` keyword arguments
- Add `mesh-get-triangle-count` as a more explicit replacement path for `shape-triangle-count`
- Follow existing 3-layer pattern: C wrapper → CFFI → CLOS wrappers
- Add tests matching the existing test patterns

**Non-Goals:**
- DAG/reactive model support for mesh operations
- Full OCCT mesh data structure API exposure — only vertex/triangle/normal/adjacency
- Mesh refinement or decimation algorithms
- Mesh smoothing, hole filling, or repair
- Mesh file format conversion (covered by mesh-io-bindings)
- Integration with the assembly tree
- MeshVS advanced selection, clipping, or culling features

## Decisions

1. **Layer 1 — C wrapper for BRepMesh_IncrementalMesh**: Add `mesh_shape(shape, deflection, angle, relative)` returning `occt_shape`. Follow existing error pattern: `clear_error()`, null checks, `try`/`catch(Standard_Failure&)`. The function calls `BRepMesh_IncrementalMesh` on the shape and returns the shape for chaining.

2. **Layer 1 — C wrapper for Poly_Triangulation extraction**: Add `mesh_get_vertices(shape, out_verts, max_count)` returning the number of vertices written, `mesh_get_triangles(shape, out_tris, max_count)` returning triangle indices, `mesh_get_normals(shape, out_normals, max_count)` returning normals. Use `BRep_Tool::Triangulation` on each face, then `Poly_Triangulation::Nodes()` and `Poly_Triangulation::Triangles()` to extract data. Accumulate across all faces.

3. **Layer 1 — C wrapper for Poly_Connect**: Add `mesh_triangle_adjacent(shape, tri_index, edge_index)` returning adjacent index, `mesh_triangle_elements(shape, tri_index, out_n1, out_n2, out_n3)` returning three node indices.

4. **Layer 1 — C wrapper for MeshVS**: Add `meshvs_create_mesh()` returning `void*`, `meshvs_set_mesh_data(mesh, verts, vcount, tris, tcount, colors)` to populate data, `meshvs_display(ctx, mesh)` to display. Use `MeshVS_Mesh` with a custom `MeshVS_DataSource` that stores vertex/triangle data. Follow the AIS pattern for context display.

5. **Layer 2 — CFFI style**: Follow existing `%`-prefixed `defcfun` pattern in `src/ffi/bindings.lisp`. New functions: `%mesh-shape`, `%mesh-get-vertices`, `%mesh-get-triangles`, `%mesh-get-normals`, `%mesh-triangle-adjacent`, `%mesh-triangle-elements`, `%meshvs-create-mesh`, `%meshvs-set-data`, `%meshvs-display`, `%meshvs-free`.

6. **Layer 3 — CLOS style**: Create a new file `src/core/mesh.lisp` for mesh-specific wrapper functions. Follow `make-ais-triangulation` pattern from `viewer-ais-types.lisp` for data marshaling. MeshVS mesh objects will be their own CLOS class with `tg:finalize` for GC.

7. **Update write-stl**: Modify the existing C wrapper `write_stl` and CLOS `write-stl` to accept `angle` and `relative` parameters. Pass these through to `BRepMesh_IncrementalMesh` constructor. Backward compatible — existing calls with only `:deflection` continue to work.

8. **MeshVS library linkage**: Add `-lTKMeshVS` to the `justfile` wrap recipe. This library is already built by `BUILD_MODULE_ApplicationFramework=ON`.

9. **Per-face triangulation**: Use `TopExp_Explorer` to iterate faces, call `BRep_Tool::Triangulation` on each, accumulate vertices/triangles with face-offset index remapping for the per-face extraction API.

10. **Enum mapping for RWMesh**: Reuse the existing `*coordinate-system-map*` and `*name-format-map*` from `src/core/io.lisp` (added by mesh-io-bindings). If not yet present, add them. This avoids duplicate enum definitions.

## Risks / Trade-offs

- **Risk**: `Poly_Connect` requires the full triangulation to be loaded in memory → **Mitigation**: Document that mesh connectivity queries materialize the entire triangulation; users should mesh shapes at an appropriate resolution before connectivity queries.
- **Risk**: MeshVS requires `-lTKMeshVS` which may not be built if `BUILD_MODULE_ApplicationFramework` is off → **Mitigation**: The setup recipe already enables this flag. Guard MeshVS functions with an `#ifdef` in the C wrapper for safety.
- **Risk**: Per-face triangulation accumulation is O(faces) in memory/copy time → **Mitigation**: Use a single pass that writes data into pre-allocated arrays; accept that large meshes will be memory-intensive.
- **Risk**: `RWMesh_CoordinateSystem` enum values differ between OCCT versions → **Mitigation**: Expose through a keyword map in the CLOS layer rather than hard-coding C wrapper values.
- **Trade-off**: `MeshVS_DataSource` custom implementation (rather than wrapping the full OCCT class) limits advanced features but keeps the C wrapper simple.
- **Trade-off**: Implicit meshing in `shape-triangle-count` changes behavior slightly (auto-meshes if no triangulation exists) but provides a better user experience.
