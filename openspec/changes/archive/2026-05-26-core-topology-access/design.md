## Context

cl-occt currently wraps high-level topological operations (face→edges, edge→vertices, shape type queries) and geometric curves/surfaces, but the low-level `BRep_Tool` queries that extract raw data from shapes are not exposed. These include: vertex point coordinates, edge curve parameter ranges, face surface UV domains, shape tolerances, orientation reversal, and natural restriction flags.

The existing `edge->curve` and `face->surface` wrappers extract the geometric object but discard parameter bounds and UV domain information. This means callers get a curve without knowing which portion the edge covers, or a surface without knowing which UV rectangle the face occupies.

New functions will follow the established three-layer architecture: C `extern "C"` wrappers → CFFI `defcfun` → CLOS core wrappers with `tg:finalize` GC.

## Goals / Non-Goals

**Goals:**
- Expose vertex point as `(x, y, z)` via `BRep_Tool::Pnt`
- Expose edge curve + parameter range `(first, last)` via `BRep_Tool::Curve`
- Expose face surface + UV bounds `(u-min, u-max, v-min, v-max)` via `BRep_Tool::Surface` + `BRepAdaptor_Surface`
- Expose edge/face tolerance via `BRep_Tool::Tolerance`
- Expose deep shape copy via `BRepBuilderAPI_Copy`
- Expose `Precision::Confusion()`, `Precision::Angular()`, `Precision::Intersection()` as Lisp constants
- Expose curve evaluation at parameter via `Geom_Curve::Value(t)`
- Expose surface evaluation at UV via `Geom_Surface::Value(u, v)`
- Expose face natural restriction predicate via `BRep_Tool::NaturalRestriction`
- Expose shape orientation reversal via `TopoDS::Reversed`
- Update `doc/api-reference.md` with all new signatures

**Non-Goals:**
- No changes to existing `edge->curve` or `face->surface` API (backward compatible)
- No viewer/rendering changes
- No uniform point distribution (separate change)
- No assembly location queries (separate change)
- No shape healing changes

## Decisions

### 1. File layout for new C wrapper

A new file `wrap/occt_wrap_brep_tool.cpp` will hold all `BRep_Tool`-related functions (vertex point, curve+range, surface+UV, tolerance, natural restriction). The curve/surface evaluation functions go in `wrap/occt_wrap_geom_eval.cpp`. Copy goes in its own small file or appended to `occt_wrap_brep_tool.cpp`. This keeps the existing files focused.

| What | Where |
|------|-------|
| Vertex point, edge curve+range, face surface+UV, tolerance, natural restriction | `wrap/occt_wrap_brep_tool.cpp` + `.h` |
| Curve/surface evaluation at param/UV | `wrap/occt_wrap_geom_eval.cpp` + `.h` |
| Deep copy (`BRepBuilderAPI_Copy`) | `wrap/occt_wrap_shape_copy.cpp` + `.h` |
| Precision constants | `wrap/occt_wrap_precision.cpp` + `.h` |

### 2. Return convention for edge curve + range

The C function returns a struct or uses output parameters:
```c
occt_curve edge_get_curve(occt_shape edge, double* out_first, double* out_last);
```
Returns the curve pointer and writes `first`/`last` into output params. On failure, returns null and sets error.

### 3. Return convention for face surface + UV bounds

```c
occt_surface face_get_surface(occt_shape face, double* out_umin, double* out_umax,
                               double* out_vmin, double* out_vmax);
```

### 4. Copy semantics

`BRepBuilderAPI_Copy` performs a deep copy of the shape including all subshapes. The result is a new CLOS shape object with its own finalizer. The original shape remains independent.

### 5. Precision constants as Lisp constants

```lisp
(defparameter +precision-confusion+   <value from C>)
(defparameter +precision-angular+     <value from C>)
(defparameter +precision-intersection+ <value from C>)
```

Retrieved via C functions that simply return the constant values.

### 6. Orientation reversal

```c
occt_shape shape_reversed(occt_shape shape);
```

Returns a new shape handle with reversed orientation (wraps `TopoDS::Reversed`). Does NOT deep-copy — uses OCCT's shared topology. Add `%shape-reversed` in CFFI and `reverse-orientation` in core.

## Risks / Trade-offs

- **`BRep_Tool::Curve` vs `BRepAdaptor_Curve`**: `BRep_Tool::Curve` returns the underlying `Geom_Curve` directly with parameter bounds, while `BRepAdaptor_Curve` provides a richer interface. Using `BRep_Tool::Curve` is simpler and is what OCCT examples recommend. The range returned by `BRep_Tool::Curve` corresponds to the edge's trim on the curve.
- **`BRep_Tool::Surface` restrictions**: For faces with natural restriction (`NaturalRestriction == true`), the UV bounds match the full surface parameterization. For trimmed faces, the bounds correspond to the face's trim. Users must check `NaturalRestriction` to know which case applies.
- **Tolerance values**: Shape tolerance is the maximum deviation allowed when approximating the geometry. Edge tolerances are typically small (1e-7 to 1e-3). Face tolerances can be larger for imported geometry.
- **Deep copy with `BRepBuilderAPI_Copy`**: This registers a new shape in the OCCT shape arena. The copy is independent from the original. This is critical for non-destructive workflows but adds memory overhead.
- **Evaluation precision**: `Geom_Curve::Value(t)` and `Geom_Surface::Value(u, v)` use OCCT's internal evaluation. For B-Spline geometry this is accurate within machine precision but may be slow for complex surfaces.
