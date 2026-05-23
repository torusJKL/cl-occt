## 1. C Bridge: edge fillet

- [x] 1.1 Add `fillet_edge_constant` C bridge: BRepFilletAPI_MakeFillet with one edge + radius
- [x] 1.2 Add `fillet_edges_constant` C bridge: MakeFillet with array of edges + radius
- [x] 1.3 Add `fillet_edge_variable` C bridge: MakeFillet with one edge + array of (parameter radius) pairs
- [x] 1.4 Add `fillet_wire_corner` C bridge: BRepFilletAPI_MakeFillet2d with wire + radius
- [x] 1.5 Add `fillet_wire_all_corners` C bridge: MakeFillet2d with wire + radius applied to all corners

## 2. C Bridge: chamfer

- [x] 2.1 Add `chamfer_edge_equal` C bridge: BRepFilletAPI_MakeChamfer with one edge + distance
- [x] 2.2 Add `chamfer_edges_equal` C bridge: MakeChamfer with array of edges + distance
- [x] 2.3 Add `chamfer_edge_asym` C bridge: MakeChamfer with edge + distance1 + distance2
- [x] 2.4 Add `chamfer_edge_on_face` C bridge: MakeChamfer with edge + distance + face reference

## 3. C Bridge: surface blend

- [x] 3.1 Add `blend_faces_constant` C bridge: FilletSurf with two faces + radius
- [x] 3.2 Add `blend_make_constant` C bridge: BlendFunc constant radius blend

## 4. CFFI Bindings (bindings.lisp)

- [x] 4.1 Add `%`-prefixed defcfun bindings for all fillet bridge functions
- [x] 4.2 Add `%`-prefixed defcfun bindings for all chamfer bridge functions
- [x] 4.3 Add `%`-prefixed defcfun bindings for all blend bridge functions

## 5. CLOS wrappers: fillet (src/core/fillet.lisp)

- [x] 5.1 Create `src/core/fillet.lisp`
- [x] 5.2 Implement `fillet-edge` (single edge, constant radius)
- [x] 5.3 Implement `fillet-edges` (multiple edges, same radius)
- [x] 5.4 Implement `fillet-edge-variable` (one edge, variable radius via (param radius) list)
- [x] 5.5 Implement `fillet-wire-corner` and `fillet-wire-all-corners` (2D fillet)
- [x] 5.6 Add nil propagation and double-float coercion

## 6. CLOS wrappers: chamfer (src/core/chamfer.lisp)

- [x] 6.1 Create `src/core/chamfer.lisp`
- [x] 6.2 Implement `chamfer-edge` (single edge, equal distance)
- [x] 6.3 Implement `chamfer-edges` (multiple edges, equal distance)
- [x] 6.4 Implement `chamfer-edge-asymmetric` (two distances)
- [x] 6.5 Implement `chamfer-edge-on-face` (distance relative to named face)
- [x] 6.6 Add nil propagation

## 7. CLOS wrappers: blend (src/core/blend.lisp)

- [x] 7.1 Create `src/core/blend.lisp`
- [x] 7.2 Implement `blend-faces` (constant radius surface fillet)
- [x] 7.3 Implement `make-blend` (BlendFunc with :constant or :evolving type)

## 8. Package exports

- [x] 8.1 Add all new `%`-prefixed CFFI symbols to `cl-occt.impl` package
- [x] 8.2 Add all public API symbols (fillet, chamfer, blend) to `cl-occt` package

## 9. Tests

- [x] 9.1 Write tests for edge fillet (constant radius, variable radius, multiple edges)
- [x] 9.2 Write tests for 2D wire fillet
- [x] 9.3 Write tests for chamfer (equal, asymmetric, per-face)
- [x] 9.4 Write tests for surface blend (adjacent faces)
- [x] 9.5 Write edge case tests (nil shape, excessive radius, invalid edges)
- [x] 9.6 Run `just test-core` and verify all existing tests still pass

## 10. Documentation

- [x] 10.1 Update README with fillet API documentation
- [x] 10.2 Update README with chamfer API documentation
- [x] 10.3 Update README with surface blend API documentation
