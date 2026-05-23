## 1. C Bridge: shell/thicken

- [ ] 1.1 Add `shell_shape` C bridge: BRepOffsetAPI_MakeThickSolid with shape, array of faces to remove, thickness, offset mode

## 2. C Bridge: offset

- [ ] 2.1 Add `offset_shape_3d` C bridge: BRepOffsetAPI_MakeOffsetShape with shape, offset distance, join type
- [ ] 2.2 Add `offset_wire_2d` C bridge: BRepOffsetAPI_MakeOffset with wire, offset distance

## 3. C Bridge: draft

- [ ] 3.1 Add `draft_face` C bridge: BRepOffsetAPI_DraftAngle with shape, face, angle, pull direction, neutral plane
- [ ] 3.2 Add `make_evolved` C bridge: BRepOffsetAPI_MakeEvolved with profile, spine, optional offset

## 4. CFFI Bindings (bindings.lisp)

- [ ] 4.1 Add `%`-prefixed defcfun bindings for all shell bridge functions
- [ ] 4.2 Add `%`-prefixed defcfun bindings for all offset bridge functions
- [ ] 4.3 Add `%`-prefixed defcfun bindings for all draft bridge functions

## 5. CLOS wrappers: shell (src/core/shell.lisp)

- [ ] 5.1 Create `src/core/shell.lisp`
- [ ] 5.2 Implement `shell-shape` with :thickness, :offset (:inward/:outward) keywords
- [ ] 5.3 Add nil propagation

## 6. CLOS wrappers: offset (src/core/offset.lisp)

- [ ] 6.1 Create `src/core/offset.lisp`
- [ ] 6.2 Implement `offset-shape` with :join (:arc/:tangent/:intersection) keyword
- [ ] 6.3 Implement `offset-wire` (2D planar wire offset)

## 7. CLOS wrappers: draft (src/core/draft.lisp)

- [ ] 7.1 Create `src/core/draft.lisp`
- [ ] 7.2 Implement `draft-face` with angle, pull-direction, neutral-plane
- [ ] 7.3 Implement `make-evolved` with :offset keyword

## 8. Package exports

- [ ] 8.1 Add all new `%`-prefixed CFFI symbols to `cl-occt.impl` package
- [ ] 8.2 Add all public API symbols to `cl-occt` package

## 9. Tests

- [ ] 9.1 Write tests for shell operation (box shelled, multiple faces removed, outward offset)
- [ ] 9.2 Write tests for 3D offset (outward, inward, join types)
- [ ] 9.3 Write tests for wire offset (outward, inward)
- [ ] 9.4 Write tests for draft angle on a face
- [ ] 9.5 Write tests for evolved solid
- [ ] 9.6 Write edge case tests (nil shapes, excessive thickness/offset/draft)
- [ ] 9.7 Run `just test-core` and verify all existing tests still pass

## 10. Documentation

- [ ] 10.1 Update README with shell API documentation
- [ ] 10.2 Update README with offset API documentation
- [ ] 10.3 Update README with draft angle API documentation
