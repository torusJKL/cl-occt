## 1. C Bridge: shape fix

- [x] 1.1 Add `fix_shape` C bridge: ShapeFix_Shape with Perform
- [x] 1.2 Add `fix_wire` C bridge: ShapeFix_Wire with face and tolerance
- [x] 1.3 Add `fix_solid` C bridge: ShapeFix_Solid with Perform
- [x] 1.4 Add `fix_edge` C bridge: ShapeFix_Edge
- [x] 1.5 Add `fix_face` C bridge: ShapeFix_Face
- [x] 1.6 Add `shape_analysis_free_edges` C bridge: ShapeAnalysis_FreeEdges
- [x] 1.7 Add `shape_analysis_check_intersections` C bridge: check surface-surface intersections
- [x] 1.8 Add `shape_analysis_wire_contains` C bridge: wire containment test
- [x] 1.9 Add `shape_analysis_contents` C bridge: count sub-shapes by type

## 2. C Bridge: shape rebuild

- [x] 2.1 Add `substitute_single` C bridge: ShapeBuild_ReShape with single old/new replacement
- [x] 2.2 Add `substitute_batch` C bridge: ShapeBuild_ReShape with array of old/new pairs
- [x] 2.3 Add `shape_to_nurbs` C bridge: ShapeCustom::ConvertToBSpline
- [x] 2.4 Add `shape_reduce_degree` C bridge: ShapeCustom::ReduceDegree with max degree
- [x] 2.5 Add `shape_to_rational_bspline` C bridge: ShapeCustom::ConvertToRationalBSpline
- [x] 2.6 Add `shape_split_u` C bridge: ShapeUpgrade_ShapeSewing / split along U
- [x] 2.7 Add `shape_upgrade_continuity` C bridge: ShapeUpgrade with continuity level

## 3. C Bridge: shape process pipeline

- [x] 3.1 Add `apply_shape_process` C bridge: ShapeProcess::Perform with operator name
- [x] 3.2 Add `apply_operator_sequence` C bridge: apply array of operators in sequence
- [x] 3.3 Add `apply_healing_pipeline` C bridge: ShapeProcessAPI with resource file
- [x] 3.4 Add `heal_shape_default` C bridge: default healing pipeline (SameParameter + FixShape + FixWire + FixSolid)

## 4. CFFI Bindings (bindings.lisp)

- [x] 4.1 Add `%`-prefixed defcfun bindings for all shape-fix bridge functions
- [x] 4.2 Add `%`-prefixed defcfun bindings for all shape-rebuild bridge functions
- [x] 4.3 Add `%`-prefixed defcfun bindings for all shape-process bridge functions

## 5. CLOS wrappers: shape fix (src/core/shape-fix.lisp)

- [x] 5.1 Create `src/core/shape-fix.lisp`
- [x] 5.2 Implement `fix-shape` (general repair)
- [x] 5.3 Implement `fix-wire` with :tolerance keyword
- [x] 5.4 Implement `fix-solid`, `fix-edge`, `fix-face`
- [x] 5.5 Implement shape analysis functions: `shape-analysis-free-edges`, `shape-analysis-check-intersections`, `shape-analysis-wire-contains-p`, `shape-analysis-contents`

## 6. CLOS wrappers: shape rebuild (src/core/shape-rebuild.lisp)

- [x] 6.1 Create `src/core/shape-rebuild.lisp`
- [x] 6.2 Implement `substitute-shape` (single and batch via list of pairs)
- [x] 6.3 Implement `shape-to-nurbs`, `shape-reduce-degree`, `shape-to-rational-bspline`
- [x] 6.4 Implement `shape-split-u`, `shape-upgrade-continuity`

## 7. CLOS wrappers: shape process (src/core/shape-process.lisp)

- [x] 7.1 Create `src/core/shape-process.lisp`
- [x] 7.2 Implement `apply-shape-process` (single operator or sequence)
- [x] 7.3 Implement `apply-healing-pipeline` with :resource keyword
- [x] 7.4 Implement `heal-shape` (default pipeline convenience)

## 8. Package exports

- [x] 8.1 Add all new `%`-prefixed CFFI symbols to `cl-occt.impl` package
- [x] 8.2 Add all public API symbols to `cl-occt` package

## 9. Tests

- [x] 9.1 Write tests for shape-fix (fix shape, wire, solid, edge, face)
- [x] 9.2 Write tests for shape analysis (free edges, intersections, wire containment, contents)
- [x] 9.3 Write tests for sub-shape substitution (single and batch)
- [x] 9.4 Write tests for NURBS conversion and degree reduction
- [x] 9.5 Write tests for surface splitting and continuity upgrade
- [x] 9.6 Write tests for default healing pipeline
- [x] 9.7 Write edge case tests (nil shape, already-valid shape)
- [x] 9.8 Run `just test-core` and verify all existing tests still pass

## 10. Documentation

- [x] 10.1 Update README with shape fix API documentation
- [x] 10.2 Update README with shape rebuild API documentation
- [x] 10.3 Update README with shape process pipeline API documentation
