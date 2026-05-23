## 1. C Bridge: hole/prism/revol features

- [ ] 1.1 Add `make_cylindrical_hole` C bridge: BRepFeat_MakeCylindricalHole with shape, face, radius, depth, through flag
- [ ] 1.2 Add `make_prism_feature` C bridge: BRepFeat_MakePrism with base face, profile, height, direction, operation (cut/add)
- [ ] 1.3 Add `make_revol_feature` C bridge: BRepFeat_MakeRevol with base face, profile, axis, angle, operation

## 2. C Bridge: pipe feature

- [ ] 2.1 Add `make_pipe_feature` C bridge: BRepFeat_MakePipe with base face, profile, path, operation

## 3. C Bridge: local operations

- [ ] 3.1 Add `local_extrude` C bridge: LocOpe extrusion of a face
- [ ] 3.2 Add `make_groove` C bridge: LocOpe groove
- [ ] 3.3 Add `make_rib` C bridge: LocOpe rib

## 4. CFFI Bindings (bindings.lisp)

- [ ] 4.1 Add `%`-prefixed defcfun bindings for all hole/prism/revol bridge functions
- [ ] 4.2 Add `%`-prefixed defcfun bindings for pipe feature bridge functions
- [ ] 4.3 Add `%`-prefixed defcfun bindings for local operations bridge functions

## 5. CLOS wrappers: hole/prism/revol (src/core/hole-prism-revol.lisp)

- [ ] 5.1 Create `src/core/hole-prism-revol.lisp`
- [ ] 5.2 Implement `make-cylindrical-hole` with :radius, :depth, :through keywords
- [ ] 5.3 Implement `make-prism-feature` with :operation (:cut/:add), :direction keywords
- [ ] 5.4 Implement `make-revol-feature` with :axis, :angle, :operation keywords
- [ ] 5.5 Add nil propagation

## 6. CLOS wrappers: pipe feature (src/core/pipe-feature.lisp)

- [ ] 6.1 Create `src/core/pipe-feature.lisp`
- [ ] 6.2 Implement `make-pipe-feature` with :operation (:cut/:add) keyword

## 7. CLOS wrappers: local operations (src/core/local-ops.lisp)

- [ ] 7.1 Create `src/core/local-ops.lisp`
- [ ] 7.2 Implement `local-extrude`
- [ ] 7.3 Implement `make-groove`
- [ ] 7.4 Implement `make-rib`

## 8. Package exports

- [ ] 8.1 Add all new `%`-prefixed CFFI symbols to `cl-occt.impl` package
- [ ] 8.2 Add all public API symbols to `cl-occt` package

## 9. Tests

- [ ] 9.1 Write tests for cylindrical hole (through, blind, on box)
- [ ] 9.2 Write tests for prism feature (depression, protrusion)
- [ ] 9.3 Write tests for revolve feature (depression, protrusion)
- [ ] 9.4 Write tests for pipe feature (depression, protrusion)
- [ ] 9.5 Write tests for local operations (extrude, groove, rib)
- [ ] 9.6 Write edge case tests (nil args, invalid faces)
- [ ] 9.7 Run `just test-core` and verify all existing tests still pass

## 10. Documentation

- [ ] 10.1 Update README with hole/prism/revol API documentation
- [ ] 10.2 Update README with pipe feature API documentation
- [ ] 10.3 Update README with local operations API documentation
