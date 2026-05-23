## Why

Shelling (hollowing) a solid, offsetting shapes inward/outward, and adding draft angles are common operations in injection-molded part design. CL-OCCT needs these to produce manufacturable thin-walled parts and tooling geometry.

## What Changes

This change introduces **3 new capability areas**. Each follows the three-layer pattern: C bridge (`wrap/`), CFFI bindings (`src/ffi/bindings.lisp`), CLOS wrappers + public API (`src/core/`). Each includes unit tests.

**New capabilities:**
- `thicken-shell` — BRepOffsetAPI_MakeThickSolid (hollow/shell a solid by removing faces)
- `offset-shape` — BRepOffsetAPI_MakeOffsetShape (offset a 3D shape inward/outward) and MakeOffset (offset a planar wire in 2D)
- `draft-angle` — BRepOffsetAPI_DraftAngle (apply taper to faces) and MakeEvolved (evolved solid from profile along spine)

No breaking changes to existing APIs.

## Capabilities

### New Capabilities
- `thicken-shell`: Hollow out a solid by removing specified faces and specifying wall thickness via `BRepOffsetAPI_MakeThickSolid`.
- `offset-shape`: Offset a solid shell/solid outward or inward (`MakeOffsetShape`) and offset a planar wire in the plane (`MakeOffset`).
- `draft-angle`: Apply a draft (taper) angle to selected faces of a solid (`DraftAngle`), and construct an evolved solid by sweeping a profile along a spine with offset (`MakeEvolved`).

### Modified Capabilities
None.

## Impact

- **wrap/occt_wrap.h + .cpp**: ~15 new C bridge functions.
- **src/ffi/bindings.lisp**: Corresponding `%`-prefixed CFFI `defcfun` bindings.
- **src/core/**: New files:
  - `src/core/shell.lisp` — thicken/shell operations
  - `src/core/offset.lisp` — shape offset and 2D wire offset
  - `src/core/draft.lisp` — draft angle and evolved solid
- **src/package.lisp**: ~15+ new exported symbols.
- **t/smoke-tests.lisp**: New test sections per spec.
- **README.md**: Updated with shell/offset/draft API documentation.
