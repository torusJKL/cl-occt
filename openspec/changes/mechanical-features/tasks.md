## 1. C Bridge: hole/prism/revol features

- [x] 1.1 Add `make_cylindrical_hole` C bridge: BRepFeat_MakeCylindricalHole with shape, face, radius, depth, through flag
- [x] 1.2 Add `make_prism_feature` C bridge: BRepFeat_MakePrism with base face, profile, height, direction, operation (cut/add)
- [x] 1.3 Add `make_revol_feature` C bridge: BRepFeat_MakeRevol with base face, profile, axis, angle, operation

## 2. C Bridge: pipe feature

- [x] 2.1 Add `make_pipe_feature` C bridge: BRepFeat_MakePipe with base face, profile, path, operation

## 3. C Bridge: local operations

- [x] 3.1 Add `local_extrude` C bridge: LocOpe extrusion of a face
- [x] 3.2 Add `make_groove` C bridge: LocOpe groove
- [x] 3.3 Add `make_rib` C bridge: LocOpe rib

## 4. CFFI Bindings (bindings.lisp)

- [x] 4.1 Add `%`-prefixed defcfun bindings for all hole/prism/revol bridge functions
- [x] 4.2 Add `%`-prefixed defcfun bindings for pipe feature bridge functions
- [x] 4.3 Add `%`-prefixed defcfun bindings for local operations bridge functions

## 5. CLOS wrappers: hole/prism/revol (src/core/hole-prism-revol.lisp)

- [x] 5.1 Create `src/core/hole-prism-revol.lisp`
- [x] 5.2 Implement `make-cylindrical-hole` with :radius, :depth, :through keywords
- [x] 5.3 Implement `make-prism-feature` with :operation (:cut/:add), :direction keywords
- [x] 5.4 Implement `make-revol-feature` with :axis, :angle, :operation keywords
- [x] 5.5 Add nil propagation

## 6. CLOS wrappers: pipe feature (src/core/pipe-feature.lisp)

- [x] 6.1 Create `src/core/pipe-feature.lisp`
- [x] 6.2 Implement `make-pipe-feature` with :operation (:cut/:add) keyword

## 7. CLOS wrappers: local operations (src/core/local-ops.lisp)

- [x] 7.1 Create `src/core/local-ops.lisp`
- [x] 7.2 Implement `local-extrude`
- [x] 7.3 Implement `make-groove`
- [x] 7.4 Implement `make-rib`

## 8. Package exports

- [x] 8.1 Add all new `%`-prefixed CFFI symbols to `cl-occt.impl` package
- [x] 8.2 Add all public API symbols to `cl-occt` package

## 9. Tests

- [x] 9.1 Write tests for cylindrical hole (through, blind, on box)
- [x] 9.2 Write tests for prism feature (depression, protrusion)
- [x] 9.3 Write tests for revolve feature (depression, protrusion)
- [x] 9.4 Write tests for pipe feature (depression, protrusion)
- [x] 9.5 Write tests for local operations (extrude, groove, rib)
- [x] 9.6 Write edge case tests (nil args, invalid faces)
- [x] 9.7 Run `just test-core` and verify all existing tests still pass

## 10. Documentation

- [x] 10.1 Update README with hole/prism/revol API documentation
- [x] 10.2 Update README with pipe feature API documentation
- [x] 10.3 Update README with local operations API documentation
