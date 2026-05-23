## 1. C Bridge: edge fillet

- [ ] 1.1 Add `fillet_edge_constant` C bridge: BRepFilletAPI_MakeFillet with one edge + radius
- [ ] 1.2 Add `fillet_edges_constant` C bridge: MakeFillet with array of edges + radius
- [ ] 1.3 Add `fillet_edge_variable` C bridge: MakeFillet with one edge + array of (parameter radius) pairs
- [ ] 1.4 Add `fillet_wire_corner` C bridge: BRepFilletAPI_MakeFillet2d with wire + radius
- [ ] 1.5 Add `fillet_wire_all_corners` C bridge: MakeFillet2d with wire + radius applied to all corners

## 2. C Bridge: chamfer

- [ ] 2.1 Add `chamfer_edge_equal` C bridge: BRepFilletAPI_MakeChamfer with one edge + distance
- [ ] 2.2 Add `chamfer_edges_equal` C bridge: MakeChamfer with array of edges + distance
- [ ] 2.3 Add `chamfer_edge_asym` C bridge: MakeChamfer with edge + distance1 + distance2
- [ ] 2.4 Add `chamfer_edge_on_face` C bridge: MakeChamfer with edge + distance + face reference

## 3. C Bridge: surface blend

- [ ] 3.1 Add `blend_faces_constant` C bridge: FilletSurf with two faces + radius
- [ ] 3.2 Add `blend_make_constant` C bridge: BlendFunc constant radius blend

## 4. CFFI Bindings (bindings.lisp)

- [ ] 4.1 Add `%`-prefixed defcfun bindings for all fillet bridge functions
- [ ] 4.2 Add `%`-prefixed defcfun bindings for all chamfer bridge functions
- [ ] 4.3 Add `%`-prefixed defcfun bindings for all blend bridge functions

## 5. CLOS wrappers: fillet (src/core/fillet.lisp)

- [ ] 5.1 Create `src/core/fillet.lisp`
- [ ] 5.2 Implement `fillet-edge` (single edge, constant radius)
- [ ] 5.3 Implement `fillet-edges` (multiple edges, same radius)
- [ ] 5.4 Implement `fillet-edge-variable` (one edge, variable radius via (param radius) list)
- [ ] 5.5 Implement `fillet-wire-corner` and `fillet-wire-all-corners` (2D fillet)
- [ ] 5.6 Add nil propagation and double-float coercion

## 6. CLOS wrappers: chamfer (src/core/chamfer.lisp)

- [ ] 6.1 Create `src/core/chamfer.lisp`
- [ ] 6.2 Implement `chamfer-edge` (single edge, equal distance)
- [ ] 6.3 Implement `chamfer-edges` (multiple edges, equal distance)
- [ ] 6.4 Implement `chamfer-edge-asymmetric` (two distances)
- [ ] 6.5 Implement `chamfer-edge-on-face` (distance relative to named face)
- [ ] 6.6 Add nil propagation

## 7. CLOS wrappers: blend (src/core/blend.lisp)

- [ ] 7.1 Create `src/core/blend.lisp`
- [ ] 7.2 Implement `blend-faces` (constant radius surface fillet)
- [ ] 7.3 Implement `make-blend` (BlendFunc with :constant or :evolving type)

## 8. Package exports

- [ ] 8.1 Add all new `%`-prefixed CFFI symbols to `cl-occt.impl` package
- [ ] 8.2 Add all public API symbols (fillet, chamfer, blend) to `cl-occt` package

## 9. Tests

- [ ] 9.1 Write tests for edge fillet (constant radius, variable radius, multiple edges)
- [ ] 9.2 Write tests for 2D wire fillet
- [ ] 9.3 Write tests for chamfer (equal, asymmetric, per-face)
- [ ] 9.4 Write tests for surface blend (adjacent faces)
- [ ] 9.5 Write edge case tests (nil shape, excessive radius, invalid edges)
- [ ] 9.6 Run `just test-core` and verify all existing tests still pass

## 10. Documentation

- [ ] 10.1 Update README with fillet API documentation
- [ ] 10.2 Update README with chamfer API documentation
- [ ] 10.3 Update README with surface blend API documentation
