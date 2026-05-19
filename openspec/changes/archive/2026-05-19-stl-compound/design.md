## Context

The codebase follows a strict 3-layer architecture: C wrapper (`wrap/occt_wrap.cpp`) → CFFI bindings (`src/ffi/bindings.lisp`) → CLOS core (`src/core/`). Compounds are a standard OCCT type (`TopoDS_Compound`) built with `BRep_Builder`. `StlAPI_Writer` already handles compounds transparently — no changes needed to `write-stl` or its C implementation.

The existing `make-shape` wrapper pattern (pointer wrapping + `tg:finalize` for GC) must be followed for consistency.

## Goals / Non-Goals

**Goals:**
- Expose `make-compound` & `add-to-compound` at the CLOS layer
- Support nil propagation: nil shapes in the input list are skipped; a list of all nils returns nil
- Support empty compounds (list of zero non-nil shapes)
- Compound passed to `write-stl` writes all sub-shapes as a single STL
- Follow the exact 3-layer pattern used by all other shape operations

**Non-Goals:**
- No DAG/DSL changes — compounds are assembled imperatively, not through defmodel
- No STEP compound export changes — STEP already handles assemblies via the `assembly` tree
- No nested compound flattening — OCCT handles this internally

## Decisions

1. **`make_compound` takes a list of shapes**, not varargs. This matches Lisp idioms better and avoids C varargs complexity.
   - *Alternative considered*: Two-phase (make empty compound + add shapes). Accepted as the internal implementation, but the public API should be a single call.

2. **`add-to-compound` is exposed for incremental building** in addition to `make-compound`. This covers REPL workflows where shapes are created one at a time.

3. **Nil shapes are silently skipped**, matching the existing `make-shape` nil-propagation convention. An empty valid list produces an empty compound (non-nil) so downstream `write-stl` gets a valid shape.

4. **`compound_is_empty` helper exposed** so Lisp code can query emptiness without C++ exceptions. Not exported in the public API but available for internal use.

5. **New file `src/core/compounds.lisp`** rather than adding to `primitives.lisp` or `io.lisp`, keeping the module structure clean.

## Risks / Trade-offs

- **Risk**: OCCT `BRep_Builder.Add()` does not deep-copy shapes — the compound references the original shapes. If shapes are freed (GC finalizer), the compound points to freed memory.
  → **Mitigation**: `from_shape` copies shapes via copy constructor (`new TopoDS_Shape(s)`), but `BRep_Builder.Add()` in OCCT may still reference the same underlying `TopoDS_TShape`. Lisp user must ensure shapes live as long as the compound. This matches OCCT's ownership model.

- **Risk**: Multiple `BRepMesh_IncrementalMesh` calls on the same shape are idempotent but waste time.
  → **Mitigation**: Not addressed in this change — OCCT handles re-meshing internally. Future optimization could add a meshing cache.

- **Trade-off**: Empty compound returns a valid non-nil shape (unlike `make-shape` returning nil for null pointer). This is intentional — `write-stl` with a compound of zero shapes produces an empty STL file rather than signaling an error, which is more useful for generative workflows.
