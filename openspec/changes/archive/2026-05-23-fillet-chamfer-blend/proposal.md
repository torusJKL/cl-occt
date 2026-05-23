## Why

Fillets and chamfers are among the most commonly used CAD operations — rounding sharp edges and beveling corners. Without them, CL-OCCT models look like wireframe prototypes. Adding fillet/chamfer/blend operations makes the library suitable for producing manufacturable, aesthetic solid models.

## What Changes

This change introduces **3 new capability areas**. Each follows the three-layer pattern: C bridge (`wrap/`), CFFI bindings (`src/ffi/bindings.lisp`), CLOS wrappers + public API (`src/core/`). Each includes unit tests.

**New capabilities:**
- `edge-fillet` — BRepFilletAPI_MakeFillet (constant and variable radius edge rounding) and MakeFillet2d (2D fillet on planar wires)
- `chamfer` — BRepFilletAPI_MakeChamfer (edge beveling with equal or unequal distances)
- `surface-blend` — FilletSurf and BlendFunc for surface blending between faces

No breaking changes to existing APIs.

## Capabilities

### New Capabilities
- `edge-fillet`: Round edges of a solid with constant or variable radius via `BRepFilletAPI_MakeFillet`. Supports selecting specific edges by edge shape reference. Also includes `BRepFilletAPI_MakeFillet2d` for filleting corners of a planar wire.
- `chamfer`: Bevel edges of a solid via `BRepFilletAPI_MakeChamfer`. Supports equal-distance chamfers and asymmetric (two-distance) chamfers.
- `surface-blend`: Create a blended surface between two faces via `FilletSurf`, and general surface blending functions in `BlendFunc`.

### Modified Capabilities
None.

## Impact

- **wrap/occt_wrap.h + .cpp**: ~20 new C bridge functions across 3 specs.
- **src/ffi/bindings.lisp**: Corresponding `%`-prefixed CFFI `defcfun` bindings.
- **src/core/**: New files:
  - `src/core/fillet.lisp` — edge fillet (3D) + 2D fillet
  - `src/core/chamfer.lisp` — edge chamfer
  - `src/core/blend.lisp` — surface blend
- **src/package.lisp**: ~20+ new exported symbols.
- **t/smoke-tests.lisp**: New test sections per spec.
- **README.md**: Updated with fillet/chamfer/blend API documentation.
