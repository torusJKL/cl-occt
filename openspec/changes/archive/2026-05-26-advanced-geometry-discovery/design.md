## Context

Phase 1 added core topology data access (vertex coords, edge ranges, UV bounds, tolerance, copy). This phase extends the binding layer with tools for programmatic shape discovery and advanced CAD modeling. Many of these are standalone OCCT classes that follow established wrapping patterns.

The change covers 11 capabilities. Each maps to a well-defined OCCT class or small set of classes. Implementation order ensures early capabilities (uniform points, shape location) can be tested independently before more complex ones (normal projection, remove features).

## Goals / Non-Goals

**Goals:**
- Expose uniform point distribution on curves via `GCPnts_UniformAbscissa` and `GCPnts_UniformDeflection`
- Expose shape location (`TopLoc_Location`) for assembly-aware queries
- Expose edge finding by geometric type via `BRepLib_FindEdges`
- Expose normal projection via `BRepAlgo_NormalProjection`
- Expose parameter transfer via `ShapeAnalysis_TransferParameters`
- Expose BREP native format read/write via `BRepTools`
- Expose wedge primitive via `BRepPrimAPI_MakeWedge`
- Expose drafted prism feature via `BRepFeat_MakeDPrism`
- Expose remove features via `BRepAlgoAPI_RemoveFeatures`
- Expose fix small faces and tolerance tools via `ShapeFix`
- Expose low-level STL via `RWStl`
- Update `doc/api-reference.md` with all new signatures

**Non-Goals:**
- No changes to existing primitive/boolean/I/O APIs
- No visualization changes
- No OCAF changes
- No changes to core topology access (Phase 1)

## Decisions

### 1. File layout per capability

Each capability gets its own C wrapper file pair to keep compilation units focused and testable:

| Capability | C Wrapper File | Core Lisp File |
|---|---|---|
| Uniform point distribution | `occt_wrap_gcpnts.cpp` | `gcpnts-points.lisp` |
| Assembly location | `occt_wrap_location.cpp` | `assembly-location.lisp` |
| Edge finding | `occt_wrap_find_edges.cpp` | `find-edges.lisp` |
| Normal projection | `occt_wrap_normal_project.cpp` | `normal-project.lisp` |
| Transfer parameters | `occt_wrap_transfer_params.cpp` | `transfer-params.lisp` |
| BREP native I/O | `occt_wrap_brep_io.cpp` | `brep-io.lisp` |
| Wedge primitive | `occt_wrap_wedge.cpp` | `wedge-primitive.lisp` |
| Drafted prism | `occt_wrap_dprism.cpp` | `drafted-prism.lisp` |
| Remove features | `occt_wrap_remove_features.cpp` | `remove-features.lisp` |
| Fix small faces | `occt_wrap_small_faces.cpp` | `small-faces.lisp` |
| Tolerance tools | `occt_wrap_shape_tolerance.cpp` | `shape-tolerance.lisp` |
| RWStl | `occt_wrap_rwstl.cpp` | `rwstl-io.lisp` |

### 2. GCPnts uniform point distribution

`GCPnts_UniformAbscissa` computes N evenly-spaced points along a curve by arc length. `GCPnts_UniformDeflection` computes points with a maximum deflection tolerance. Both take a `GeomAdaptor_Curve` or `BRepAdaptor_Curve`.

The C wrapper will accept a `Geom_Curve` handle + parameter range + number of points (or deflection), construct the adaptor internally, run the algorithm, and return an array of `(x, y, z)` triples.

```c
int uniform_abscissa_points(occt_curve curve, double first, double last,
                             int num_points,
                             double* out_coords);  // returns count
```

### 3. TopLoc_Location

`TopLoc_Location` represents a coordinate system transformation. It wraps `gp_Trsf` with shared-data semantics. The C wrapper exposes:
- `location_from_trsf(dx, dy, dz)` — create location from translation
- `location_multiply(loc1, loc2)` — compose locations
- `location_inverted(loc)` — invert location
- `shape_location(shape)` — get shape's current location
- `shape_set_location(shape, loc)` — set shape's location
- `shape_moved(shape, loc)` — return shape moved by location (new shape)

### 4. BRepLib_FindEdges

`BRepLib_FindEdges` provides static methods to find edges in a shape by geometric type (line, circle, ellipse, etc.) and by geometric properties (radius, etc.).

The C wrapper exposes:
```c
occt_shape* find_edges_by_type(occt_shape shape, int curve_type, int* out_count);
occt_shape* find_edges_by_radius(occt_shape shape, double radius, int* out_count);
```

### 5. BRepAlgo_NormalProjection

Wraps `BRepAlgo_NormalProjection` to project a shape (wire or edge) onto a face along the face normal. Returns the projected shape.

```c
occt_shape normal_project(occt_shape shape_to_project, occt_shape face);
```

### 6. RWStl

`RWStl` provides lower-level STL control than `StlAPI`. Exposes:
- `RWStl::ReadFile` — read STL as `Poly_Triangulation`
- `RWStl::WriteFile` — write `Poly_Triangulation` as STL

## Risks / Trade-offs

- **GCPnts performance**: Computing hundreds of uniform points on a complex B-Spline curve can be slow. The C wrapper should use `GeomAdaptor_Curve` with caching for repeated calls.
- **TopLoc_Location semantics**: Locations are shared (copy-on-reference) in OCCT. Setting a location on a shape that's referenced by other shapes may produce surprising results. The `shape_moved` variant creates a new shape to avoid this.
- **Normal projection limitations**: `BRepAlgo_NormalProjection` works best on simple faces (planes, cylinders). On complex B-Spline surfaces, projection may fail or produce unexpected results.
- **Remove features vs defeaturing**: `BRepAlgoAPI_RemoveFeatures` removes specific features (holes, protrusions) from a shape, complementing the existing `defeature-shape` which performs automatic defeaturing. Both should be available for different use cases.
- **BREP I/O portability**: The `.brep` format is OCCT-native and not portable to other CAD systems. It's meant for fast save/load within OCCT-based applications.
- **RWStl vs StlAPI**: The existing `StlAPI` is simpler but provides less control. `RWStl` allows direct access to the triangulation data.
