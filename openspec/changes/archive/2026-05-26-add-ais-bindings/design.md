## Context

cl-occt currently wraps three AIS interactive object types:
- `AIS_Shape` — basic shape display
- `AIS_Trihedron` — 3D axis indicator
- `AIS_TextLabel` — 3D text labels

All three follow the same C-wrapper pattern: a C function in `occt_wrap.cpp` creating/destroying the object, a `defcfun` in `src/ffi/bindings.lisp`, a CLOS class in `src/core/viewer.lisp`, and `tg:finalize` for GC. The existing `ais-object` CLOS class serves as the base-wrapper for all AIS objects.

The 13 new AIS classes span several categories:
- **Geometry overlays**: `AIS_Plane`, `AIS_Axis`, `AIS_Line`, `AIS_Circle` — display infinite/finite planar/linear/circular elements
- **Data visualization**: `AIS_PointCloud`, `AIS_Triangulation`, `AIS_ColorScale` — point clouds, colored meshes, color legend bars
- **Interaction widgets**: `AIS_Manipulator`, `AIS_ViewCube` — gizmo and orientation cube
- **Shape variants**: `AIS_ColoredShape`, `AIS_TexturedShape` — shape with per-subshape color, shape with texture
- **Compound/shared objects**: `AIS_ConnectedInteractive`, `AIS_MultipleConnectedInteractive` — shared references, compound copies
- **Light visualization**: `AIS_LightSource` — interactive light icon

## Goals / Non-Goals

**Goals:**
- Provide C wrapper create/free/get/set functions for all 13 AIS classes
- Provide CLOS wrappers with constructors, GC finalizers, and basic property accessors
- Follow existing patterns exactly (C wrapper → `defcfun` → CLOS class → `tg:finalize`)
- Reuse the existing `ais-object` class for wrappers where sensible
- Export minimal stable public API; keep implementation details in `cl-occt.impl`
- Document all new functions in `docs/api-reference.md`
- Add smoke tests verifying creation, property setting, display, and GC

**Non-Goals:**
- Exhaustive property coverage for every OCCT API method on these classes (only the most useful subset)
- Full `AIS_Manipulator` callback/event system — only creation, positioning, attachment, mode hiding
- Texture image loading for `AIS_TexturedShape` — accept an OCCT-compatible texture handle or filename; no image format conversion
- Point cloud vertex editing after creation — only creation from coordinate arrays and property access

## Decisions

1. **New file `src/core/viewer-ais-types.lisp`** — The existing `src/core/viewer.lisp` is already 682 lines. Adding 13 new classes there would make it unwieldy. A dedicated file keeps concerns separated and matches the convention of `viewer-text-labels.lisp`, `viewer-lighting.lisp`, etc.

2. **Reuse `ais-object` CLOS class for all types** — All AIS interactive objects inherit from `AIS_InteractiveObject` at the C++ level and can be passed to `ais-display`, `ais-erase`, `ais-remove`, `ais-set-color`, etc. as `void*` handles. A single wrapper class avoids class hierarchy complexity and keeps the API uniform. The `%ptr` slot and `ais-object-p` predicate already work generically.

3. **Separate create/destroy function per type** — Each AIS type has a distinct constructor signature (some take shapes, others take coordinate arrays, geometry handles, or nothing). A unified constructor would be convoluted. Instead, provide type-specific makers like `make-colored-shape`, `make-manipulator`, `make-view-cube`, etc. Freeing is uniform via `ais-free`.

4. **C wrapper naming convention: `ais_create_<type>` / `ais_<type>_set_*`** — Matches the existing `ais_create_shape`, `ais_create_trihedron`, `ais_trihedron_set_size` pattern. Keeps the codebase consistent and predictable.

5. **Minimalist first pass for setters** — For each type, bind 2–4 most useful property setters (e.g., manipulator: position, size, enabled axes; view-cube: size, box color; color-scale: range, number of intervals, title). Full property coverage can come later as needed.

6. **Tests use `with-viewer` and no X display** — Core AIS creation, property setting, and `ais-display` tests don't require an X display because OCCT's neutral window works in headless mode. This keeps tests in the `just test-core` category.

## Risks / Trade-offs

- **API surface growth** → Each new class adds 3–10 exported symbols. Mitigation: Keep everything behind `cl-occt.impl` unless it's a user-facing constructor or property setter.
- **OCCT version compatibility** → Some constructors changed between OCCT 7.x and 8.0. Mitigation: Cross-reference with OCCT 8.0 header files; avoid deprecated APIs.
- **`AIS_Manipulator` complexity** → Has a rich event/attachment model. Mitigation: Only bind creation, positioning, mode visibility, and attach-to-shape. Skip the callback/start/stop API.
- **`AIS_ViewCube` window dependency** → The view cube is tied to a V3d_View. Mitigation: Create but require `ais-display` into a context before it becomes functional — same as other AIS objects.
- **`AIS_ColorScale` requires explicit sizing** → Unlike other AIS objects, ColorScale needs width/height set before display. Mitigation: Document this requirement; provide convenience defaults.
