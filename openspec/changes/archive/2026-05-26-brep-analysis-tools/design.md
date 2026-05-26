## Context

cl-occt already has `shape-distance`, `shape-distance-extrema`, `shape-valid-p`, `shape-check`, `point-in-solid-p`, `classify-point-in-solid`, and `intersect-curve-shape` in `shape-analysis.lisp`. BRepExtrema functions (`DistShapeShape`) are already bound. This change extends to more powerful BRepExtrema algorithms and adds BRepLProp for local geometric queries.

## Goals / Non-Goals

**Goals:**
- Proximity zones between shapes (clearance analysis)
- Overlap/interference detection
- Self-intersection detection for shape quality
- Curve tangent and curvature at parameter
- Surface normal and curvature at UV
- Face-level local properties (normal, curvature)

**Non-Goals:**
- No viewer changes
- No changes to existing distance/classification APIs
- No global shape properties (already in mass-properties.lisp)
- No thickness analysis (requires BRepOffset infrastructure)

## Decisions

### 1. Proximity returns zone descriptors
`BRepExtrema_ShapeProximity` computes proximity zones — regions of two shapes that are within a tolerance. Returns a list of proximity results, each containing distance value and the involved subshapes from each shape.

### 2. Overlap uses BRepExtrema_OverlapTool
Simple boolean result: t/nil for `shape-overlap-p`, detailed subshape list for `shape-overlap`.

### 3. Self-intersection uses BRepExtrema_SelfIntersection
Returns a list of intersection point + face pairs where the shape intersects itself.

### 4. BRepLProp wrapped with parameterized queries
`curve-tangent-at`, `curve-curvature-at`, `surface-normal-at`, `surface-curvature-at` — each takes a geometric entity + parameter/UV, returns computed values.

### 5. File layout

| What | Where |
|------|-------|
| C BRepExtrema proximity | New `wrap/occt_wrap_extrema.cpp` |
| C BRepLProp | New `wrap/occt_wrap_lprop.cpp` |
| CFFI | New `src/ffi/bindings-extrema.lisp`, `src/ffi/bindings-lprop.lisp` |
| Core analysis | `src/core/shape-analysis.lisp` (extend) |
| Core local props | New `src/core/surface-curve-local-props.lisp` |

## Risks / Trade-offs

- **BRepExtrema_ShapeProximity is compute-intensive.** For large assemblies with many proximity queries, performance may be slow. The function will accept an optional tolerance parameter to limit the search region.
- **BRepLProp requires vertices/edges to be triangulated.** `BRepLProp_CLProps` and `SLProps` compute exact derivatives from the underlying geometry (not mesh), so they're accurate but may fail on degenerate geometry.
- **Self-intersection detection is slow on dense meshes.** It's recommended for validation after import, not for repeated interactive use.
