## 1. C Bridge: shape fix

- [ ] 1.1 Add `fix_shape` C bridge: ShapeFix_Shape with Perform
- [ ] 1.2 Add `fix_wire` C bridge: ShapeFix_Wire with face and tolerance
- [ ] 1.3 Add `fix_solid` C bridge: ShapeFix_Solid with Perform
- [ ] 1.4 Add `fix_edge` C bridge: ShapeFix_Edge
- [ ] 1.5 Add `fix_face` C bridge: ShapeFix_Face
- [ ] 1.6 Add `shape_analysis_free_edges` C bridge: ShapeAnalysis_FreeEdges
- [ ] 1.7 Add `shape_analysis_check_intersections` C bridge: check surface-surface intersections
- [ ] 1.8 Add `shape_analysis_wire_contains` C bridge: wire containment test
- [ ] 1.9 Add `shape_analysis_contents` C bridge: count sub-shapes by type

## 2. C Bridge: shape rebuild

- [ ] 2.1 Add `substitute_single` C bridge: ShapeBuild_ReShape with single old/new replacement
- [ ] 2.2 Add `substitute_batch` C bridge: ShapeBuild_ReShape with array of old/new pairs
- [ ] 2.3 Add `shape_to_nurbs` C bridge: ShapeCustom::ConvertToBSpline
- [ ] 2.4 Add `shape_reduce_degree` C bridge: ShapeCustom::ReduceDegree with max degree
- [ ] 2.5 Add `shape_to_rational_bspline` C bridge: ShapeCustom::ConvertToRationalBSpline
- [ ] 2.6 Add `shape_split_u` C bridge: ShapeUpgrade_ShapeSewing / split along U
- [ ] 2.7 Add `shape_upgrade_continuity` C bridge: ShapeUpgrade with continuity level

## 3. C Bridge: shape process pipeline

- [ ] 3.1 Add `apply_shape_process` C bridge: ShapeProcess::Perform with operator name
- [ ] 3.2 Add `apply_operator_sequence` C bridge: apply array of operators in sequence
- [ ] 3.3 Add `apply_healing_pipeline` C bridge: ShapeProcessAPI with resource file
- [ ] 3.4 Add `heal_shape_default` C bridge: default healing pipeline (SameParameter + FixShape + FixWire + FixSolid)

## 4. CFFI Bindings (bindings.lisp)

- [ ] 4.1 Add `%`-prefixed defcfun bindings for all shape-fix bridge functions
- [ ] 4.2 Add `%`-prefixed defcfun bindings for all shape-rebuild bridge functions
- [ ] 4.3 Add `%`-prefixed defcfun bindings for all shape-process bridge functions

## 5. CLOS wrappers: shape fix (src/core/shape-fix.lisp)

- [ ] 5.1 Create `src/core/shape-fix.lisp`
- [ ] 5.2 Implement `fix-shape` (general repair)
- [ ] 5.3 Implement `fix-wire` with :tolerance keyword
- [ ] 5.4 Implement `fix-solid`, `fix-edge`, `fix-face`
- [ ] 5.5 Implement shape analysis functions: `shape-analysis-free-edges`, `shape-analysis-check-intersections`, `shape-analysis-wire-contains-p`, `shape-analysis-contents`

## 6. CLOS wrappers: shape rebuild (src/core/shape-rebuild.lisp)

- [ ] 6.1 Create `src/core/shape-rebuild.lisp`
- [ ] 6.2 Implement `substitute-shape` (single and batch via list of pairs)
- [ ] 6.3 Implement `shape-to-nurbs`, `shape-reduce-degree`, `shape-to-rational-bspline`
- [ ] 6.4 Implement `shape-split-u`, `shape-upgrade-continuity`

## 7. CLOS wrappers: shape process (src/core/shape-process.lisp)

- [ ] 7.1 Create `src/core/shape-process.lisp`
- [ ] 7.2 Implement `apply-shape-process` (single operator or sequence)
- [ ] 7.3 Implement `apply-healing-pipeline` with :resource keyword
- [ ] 7.4 Implement `heal-shape` (default pipeline convenience)

## 8. Package exports

- [ ] 8.1 Add all new `%`-prefixed CFFI symbols to `cl-occt.impl` package
- [ ] 8.2 Add all public API symbols to `cl-occt` package

## 9. Tests

- [ ] 9.1 Write tests for shape-fix (fix shape, wire, solid, edge, face)
- [ ] 9.2 Write tests for shape analysis (free edges, intersections, wire containment, contents)
- [ ] 9.3 Write tests for sub-shape substitution (single and batch)
- [ ] 9.4 Write tests for NURBS conversion and degree reduction
- [ ] 9.5 Write tests for surface splitting and continuity upgrade
- [ ] 9.6 Write tests for default healing pipeline
- [ ] 9.7 Write edge case tests (nil shape, already-valid shape)
- [ ] 9.8 Run `just test-core` and verify all existing tests still pass

## 10. Documentation

- [ ] 10.1 Update README with shape fix API documentation
- [ ] 10.2 Update README with shape rebuild API documentation
- [ ] 10.3 Update README with shape process pipeline API documentation
