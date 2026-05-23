## 1. C Bridge: curve type family

- [x] 1.1 Add `OccctCurve` C struct (kind tag + Handle) and `occt_curve` typedef to `occt_wrap.h`
- [x] 1.2 Add `make_line_3d`, `make_circle_3d`, `make_ellipse_3d`, `make_hyperbola`, `make_parabola` C bridge functions
- [x] 1.3 Add `make_bezier_curve` and `make_bspline_curve` C bridge functions
- [x] 1.4 Add `free_curve` C bridge function (switch on kind, delete Handle, delete struct)
- [x] 1.5 Add `curve_type` C bridge (returns integer kind tag)
- [x] 1.6 Add make_gc_line, make_gc_arc_of_circle C bridge functions (GC constructors)
- [x] 1.7 Add convert_curve_to_bspline C bridge function (Convert_CurveToBSpline)
- [x] 1.8 Add curve_bounding_box C bridge function (BndLib)

## 2. C Bridge: surface type family

- [x] 2.1 Add `OccctSurface` C struct (kind tag + Handle) and `occt_surface` typedef to `occt_wrap.h`
- [x] 2.2 Add `make_plane`, `make_cylindrical_surface`, `make_conical_surface` C bridge functions
- [x] 2.3 Add `make_spherical_surface`, `make_toroidal_surface` C bridge functions
- [x] 2.4 Add `make_bezier_surface` and `make_bspline_surface` C bridge functions
- [x] 2.5 Add `free_surface` and `surface_type` C bridge functions
- [x] 2.6 Add convert_surface_to_bspline C bridge function (Convert_SurfaceToBSpline)
- [x] 2.7 Add surface_bounding_box C bridge function (GeomBndLib)

## 3. C Bridge: geometric algorithms

- [x] 3.1 Add `project_point_on_curve` C bridge (GeomAPI_ProjectPointOnCurve, returns point+distance+param via out-params)
- [x] 3.2 Add `project_point_on_surface` C bridge (GeomAPI_ProjectPointOnSurf, returns point+u+v+distance)
- [x] 3.3 Add `intersect_curves` C bridge (GeomAPI_IntCurveCurve, returns list of points)
- [x] 3.4 Add `intersect_curve_surface` C bridge (GeomAPI_IntCurveSurface)
- [x] 3.5 Add `intersect_surfaces` C bridge (GeomAPI_IntSS, returns list of curves)
- [x] 3.6 Add `extrema_curve_curve` C bridge (GeomAPI_ExtremaCurveCurve)
- [x] 3.7 Add `extrema_curve_surface` C bridge (GeomAPI_ExtremaCurveSurface)
- [x] 3.8 Add `intersect_curves_2d` C bridge (Geom2dAPI_InterCurveCurve, using existing geom2d types)
- [x] 3.9 Add `project_point_on_curve_2d` C bridge (Geom2dAPI_ProjectPointOnCurve)
- [x] 3.10 Add `points_to_bspline` C bridge (GeomAPI_PointsToBSpline)
- [x] 3.11 Add `interpolate_points` C bridge (GeomAPI_Interpolate, with optional tangents)

## 4. C Bridge: helix

- [x] 4.1 Add `make_helix_curve` C bridge (HelixGeom, returns occt_curve with HELIX kind tag)
- [x] 4.2 Add `make_helix_edge` C bridge (HelixBRep, returns occt_shape)

## 5. CFFI Bindings (bindings.lisp)

- [x] 5.1 Add `%`-prefixed defcfun bindings for all curve bridge functions
- [x] 5.2 Add `%`-prefixed defcfun bindings for all surface bridge functions
- [x] 5.3 Add `%`-prefixed defcfun bindings for all geometric algorithm bridge functions
- [x] 5.4 Add `%`-prefixed defcfun bindings for all helix bridge functions

## 6. CLOS wrappers: curves (src/core/curves.lisp)

- [x] 6.1 Create `src/core/curves.lisp` with `make-curve` internal constructor (like `make-shape`)
- [x] 6.2 Define `curve` CLOS class with `%ptr` slot, `curve-type` accessor, `tg:finalize` GC
- [x] 6.3 Export public constructors: `make-line-3d`, `make-circle-3d`, `make-ellipse`, `make-hyperbola`, `make-parabola`
- [x] 6.4 Export `make-bezier-curve`, `make-bspline-curve` constructors
- [x] 6.5 Export `make-gc-line`, `make-gc-arc-of-circle` GC constructors
- [x] 6.6 Export `convert-curve-to-bspline`, `curve-bounding-box`, `curve-type` query functions
- [x] 6.7 Add nil propagation and double-float coercion to all constructors

## 7. CLOS wrappers: surfaces (src/core/surfaces.lisp)

- [x] 7.1 Create `src/core/surfaces.lisp` with `make-surface` internal constructor
- [x] 7.2 Define `surface` CLOS class with `%ptr` slot, `surface-type` accessor, `tg:finalize` GC
- [x] 7.3 Export public constructors: `make-plane`, `make-cylindrical-surface`, `make-conical-surface`
- [x] 7.4 Export `make-spherical-surface`, `make-toroidal-surface`, `make-bezier-surface`, `make-bspline-surface`
- [x] 7.5 Export `convert-surface-to-bspline`, `surface-bounding-box`, `surface-type` query functions

## 8. CLOS wrappers: geometric algorithms (src/core/geom-algorithms.lisp)

- [x] 8.1 Create `src/core/geom-algorithms.lisp` with projection functions
- [x] 8.2 Implement `project-point-on-curve` (returns values point distance parameter)
- [x] 8.3 Implement `project-point-on-surface` (returns values point u v distance)
- [x] 8.4 Implement intersection functions: `intersect-curves`, `intersect-curve-surface`, `intersect-surfaces`
- [x] 8.5 Implement extrema functions: `extrema-curve-curve`, `extrema-curve-surface`
- [x] 8.6 Implement 2D variants: `intersect-curves-2d`, `project-point-on-curve-2d`
- [x] 8.7 Implement `points-to-bspline` and `interpolate-points` (with keyword args for degree/tangents)

## 9. CLOS wrappers: helix (src/core/helix.lisp)

- [x] 9.1 Create `src/core/helix.lisp` with `make-helix-curve` (delegates to curve wrapper)
- [x] 9.2 Implement `make-helix-edge` (returns shape, follows existing shape GC pattern)
- [x] 9.3 Support keyword args: `:radius`, `:pitch`, `:height`, `:left-handed`, `:angle`

## 10. Package exports

- [x] 10.1 Add all new `%`-prefixed CFFI symbols to `cl-occt.impl` package in `src/package.lisp`
- [x] 10.2 Add all public API symbols (curve, surface, geom-algorithms, helix) to `cl-occt` package

## 11. Tests

- [x] 11.1 Write tests for curve construction: each type, type query, invalid params -> nil
- [x] 11.2 Write tests for surface construction: each type, type query, invalid params -> nil
- [ ] 11.3 Write tests for GC finalization (curve and surface instances freed correctly)
- [x] 11.4 Write tests for geometric algorithms: projection, intersection, extrema, fitting
- [x] 11.5 Write tests for helix curve and edge construction
- [x] 11.6 Write tests for NURBS conversion (curve-to-bspline, surface-to-bspline)
- [x] 11.7 Run `just test-core` and verify all existing tests still pass

## 12. Documentation

- [x] 12.1 Update README with curves and surfaces API documentation
- [x] 12.2 Update README with geometric algorithms API documentation
- [x] 12.3 Update README with helix API documentation
