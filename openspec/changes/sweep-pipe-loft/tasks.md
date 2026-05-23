## 1. C Bridge: pipe/sweep

- [ ] 1.1 Add `sweep_pipe` C bridge: BRepPrimAPI_MakePipe(profile, spine)
- [ ] 1.2 Add `sweep_pipe_shell` C bridge: BRepPrimAPI_MakePipeShell(spine), then Add(section, param) for each section
- [ ] 1.3 Add `sweep_pipe_shell_sliding` C bridge: MakePipeShell with SetMode(sliding)
- [ ] 1.4 Add `sweep_pipe_shell_fixed` C bridge: MakePipeShell with SetMode(fixed)
- [ ] 1.5 Add `sweep_pipe_shell_aux` C bridge: MakePipeShell with auxiliary spine

## 2. C Bridge: loft

- [ ] 2.1 Add `loft_sections` C bridge: BRepOffsetAPI_ThruSections with array of wires, solid flag
- [ ] 2.2 Add `loft_sections_ruled` C bridge: ThruSections with ruled smoothing flag
- [ ] 2.3 Add `loft_sections_smooth` C bridge: ThruSections with vtx smoothing flag
- [ ] 2.4 Add `loft_sections_tangency` C bridge: ThruSections with tangency conditions

## 3. C Bridge: face filling

- [ ] 3.1 Add `fill_face` C bridge: BRepFill_Filling with boundary wire
- [ ] 3.2 Add `fill_face_constrained` C bridge: BRepFill_Filling with supporting faces and continuity
- [ ] 3.3 Add `fill_n_sided_face` C bridge: BRepFill_Filling with array of constraint edges

## 4. CFFI Bindings (bindings.lisp)

- [ ] 4.1 Add `%`-prefixed defcfun bindings for all pipe/sweep bridge functions
- [ ] 4.2 Add `%`-prefixed defcfun bindings for all loft bridge functions
- [ ] 4.3 Add `%`-prefixed defcfun bindings for all face filling bridge functions

## 5. CLOS wrappers: sweep (src/core/sweep.lisp)

- [ ] 5.1 Create `src/core/sweep.lisp`
- [ ] 5.2 Implement `sweep-profile` (MakePipe, face or wire profile)
- [ ] 5.3 Implement `sweep-sections` (MakePipeShell with sections + params)
- [ ] 5.4 Implement `:mode` keyword (:sliding / :fixed)
- [ ] 5.5 Implement `sweep-with-aux-spine`
- [ ] 5.6 Add nil propagation

## 6. CLOS wrappers: loft (src/core/loft.lisp)

- [ ] 6.1 Create `src/core/loft.lisp`
- [ ] 6.2 Implement `loft-sections` with :solid, :ruled, :smooth, :initial-tangent, :final-tangent keywords
- [ ] 6.3 Add nil propagation

## 7. CLOS wrappers: face filling (src/core/face-filling.lisp)

- [ ] 7.1 Create `src/core/face-filling.lisp`
- [ ] 7.2 Implement `fill-face` with :support-faces, :continuity keywords
- [ ] 7.3 Implement `fill-n-sided-face` with :continuity keyword

## 8. Package exports

- [ ] 8.1 Add all new `%`-prefixed CFFI symbols to `cl-occt.impl` package
- [ ] 8.2 Add all public API symbols to `cl-occt` package

## 9. Tests

- [ ] 9.1 Write tests for simple pipe sweep (circle along line, rect along curve)
- [ ] 9.2 Write tests for multi-section sweep (2 sections, 3 sections)
- [ ] 9.3 Write tests for sliding vs fixed sweep modes
- [ ] 9.4 Write tests for loft (2 wires, 3 wires, solid vs shell, ruled vs smooth)
- [ ] 9.5 Write tests for face filling (boundary fill, N-sided fill with constraints)
- [ ] 9.6 Write edge case tests (nil args, incompatible shapes)
- [ ] 9.7 Run `just test-core` and verify all existing tests still pass

## 10. Documentation

- [ ] 10.1 Update README with sweep/pipe API documentation
- [ ] 10.2 Update README with loft API documentation
- [ ] 10.3 Update README with face filling API documentation
