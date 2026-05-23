## Why

Sweeping a profile along a spine and lofting through multiple sections are fundamental CAD operations for creating complex shapes from 2D profiles. CL-OCCT has basic extrusion (`make-prism`) and revolution (`make-revol`), but cannot sweep a profile along a curved path, create a pipe, or skin through multiple cross-sections. These operations bridge the gap between 2D sketching and 3D solid modeling.

## What Changes

This change introduces **3 new capability areas**. Each follows the three-layer pattern: C bridge (`wrap/`), CFFI bindings (`src/ffi/bindings.lisp`), CLOS wrappers + public API (`src/core/`). Each includes unit tests.

**New capabilities:**
- `pipe-sweep` — BRepPrimAPI_MakePipe (sweep profile along spine) and MakePipeShell (sweep with evolving sections, auxiliary spines, and spine/section matching)
- `loft` — BRepOffsetAPI_ThruSections (loft/skin through multiple section wires, optionally with tangency conditions)
- `face-filling` — BRepFill package (face filling from boundary wires, pipe/sweep surface construction)

No breaking changes to existing APIs.

## Capabilities

### New Capabilities
- `pipe-sweep`: Sweep a profile (face or wire) along a spine (edge or wire) via `BRepPrimAPI_MakePipe`. Advanced sweep via `BRepPrimAPI_MakePipeShell` with section evolution, auxiliary spines, and sliding/tangent matching.
- `loft`: Create a solid or shell through a set of section wires using `BRepOffsetAPI_ThruSections`. Supports solid (closed) loft, ruled/vtx smoothing, and optional tangency conditions on first/last sections.
- `face-filling`: Fill a face from a boundary wire using `BRepFill_Filling` (constrained surface filling / N-sided face). Pipe and sweep surface construction from BRepFill package.

### Modified Capabilities
None.

## Impact

- **wrap/occt_wrap.h + .cpp**: ~20 new C bridge functions across 3 specs.
- **src/ffi/bindings.lisp**: Corresponding `%`-prefixed CFFI `defcfun` bindings.
- **src/core/**: New files:
  - `src/core/sweep.lisp` — pipe and pipeshell sweep operations
  - `src/core/loft.lisp` — thru-sections lofting
  - `src/core/face-filling.lisp` — BRepFill face filling and surface construction
- **src/package.lisp**: ~20+ new exported symbols.
- **t/smoke-tests.lisp**: New test sections per spec.
- **README.md**: Updated with sweep/pipe/loft API documentation.
