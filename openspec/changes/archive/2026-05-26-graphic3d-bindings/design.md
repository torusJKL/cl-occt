## Context

cl-occt follows a three-layer architecture: C wrapper (`wrap/occt_wrap.cpp` → `lib/libocctwrap.so`), CFFI bindings (`src/ffi/bindings.lisp`), and CLOS wrappers (`src/core/*.lisp`). Existing Graphic3d bindings (Texture2D, PBRMaterial, BSDF, Camera, CubeMap) follow this pattern: `extern "C"` functions in the wrap layer, `%`-prefixed `defcfun` in FFI, and CLOS classes with `tg:finalize` GC in core.

The six target OCCT classes are:
- `Graphic3d_ClipPlane` — value-type clipping plane with equation/plane/capping/on-off
- `Graphic3d_ShaderProgram` — handle-based shader program with source management
- `Graphic3d_AspectFillArea3d`, `AspectLine3d`, `AspectMarker3d`, `AspectText3d` — value-type visual aspect attributes
- `Graphic3d_Structure` — handle-based scene graph node (visibility, transforms, hierarchy, display)
- `Graphic3d_Group` — handle-based primitive container within a structure
- `Graphic3d_RenderingParams` — value-type rendering configuration object

## Goals / Non-Goals

**Goals:**
- C wrapper functions for all essential operations on the six Graphic3d types
- CFFI `defcfun` bindings wrapping each C function
- CLOS classes with `tg:finalize` for handle-based types (ShaderProgram, Structure, Group, ClipPlane)
- Value-type wrappers for aspect classes (FillArea3d, Line3d, Marker3d, Text3d) and RenderingParams
- Predicates and GC lifecycle management following existing conventions
- Public API exports in `src/package.lisp`
- API reference docs in `docs/api-reference.md`

**Non-Goals:**
- Full coverage of every OCCT method on these classes (only the most useful subset)
- High-level scene graph DSL (just the raw bindings + CLOS wrappers)
- Integration with AIS or viewer layer beyond what's needed for basic use

## Decisions

**1. Handle-based types use `Handle(Class)*` with `new`/`delete`**
Same pattern as existing `Handle(Graphic3d_Texture2D)*`. ShaderProgram, Structure, Group, and ClipPlane are reference-counted OCCT types that require `Handle<>` management at the C level. The wrapper will allocate with `new Handle(Class)(...)` and delete with `delete`.

**2. Aspect value types heap-allocated as raw pointers**
`Graphic3d_AspectFillArea3d`, `AspectLine3d`, `AspectMarker3d`, `AspectText3d`, and `RenderingParams` are OCCT value types. We allocate them on the heap with `new` and use `tg:finalize` to free. This is consistent with how `Graphic3d_PBRMaterial` and `Graphic3d_BSDF` are already handled.

**3. Each capability gets its own core file**
Following the pattern of `viewer-rendering.lisp`, `viewer-lighting.lisp`, etc., each new capability will have a dedicated `.lisp` file in `src/core/`:
- `src/core/graphic3d-clip-plane.lisp`
- `src/core/graphic3d-shader-program.lisp`
- `src/core/graphic3d-aspects.lisp`
- `src/core/graphic3d-structure.lisp`
- `src/core/graphic3d-group.lisp`
- `src/core/graphic3d-rendering-params.lisp`

**4. Keyword enums for aspect types**
Aspect classes use OCCT enums for interior style (`Aspect_IS_EMPTY`, `Aspect_IS_HOLLOW`, `Aspect_IS_SOLID`, `Aspect_IS_HATCH`), line type, marker type, font style, etc. These will be mapped via `defparameter` alists, consistent with `*line-type-map*` and `*marker-type-map*` in `viewer-drawer.lisp`.

**5. Wrapper functions grouped by class in occt_wrap.cpp**
Each OCCT class gets a documented section block in `occt_wrap.cpp` with `// === Graphic3d_XXX ===` headers, matching the existing style.

**6. Structure and Group exposed as opaque pointers**
`Graphic3d_Structure` and `Graphic3d_Group` are complex OCCT objects with many methods. We expose them as opaque handles and provide functions for the most important operations: create/delete, visibility, transform, hierarchy (Structure), and add primitives (Group). Users interact through the CLOS layer.

## Risks / Trade-offs

- **Risk: ShaderProgram GL context dependency** → OCCT shader programs must be compiled in an active OpenGL context. Document that `compile-shader` requires an active viewer. Mitigation: provide both source-setting and separate compile steps.
- **Risk: Aspect objects are lightweight value types** → Users may create many of them. Mitigation: GC with `tg:finalize` handles cleanup; no global cache needed.
- **Risk: Structure/Group API surface is large** → We only bind the most common subset. Advanced users can extend later. Mitigation: cap at ~15-20 functions per class.
