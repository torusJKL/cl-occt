## Why

Mechanical features — holes, slots, ribs, bosses — are the building blocks of engineering parts. CL-OCCT currently has no way to add or remove material from a solid based on feature sketches (linear extrusion, revolution, pipe sweep). These features are distinct from booleans: they are positioned relative to a face and can be either depressions (cuts) or protrusions (adds).

## What Changes

This change introduces **3 new capability areas**. Each follows the three-layer pattern: C bridge (`wrap/`), CFFI bindings (`src/ffi/bindings.lisp`), CLOS wrappers + public API (`src/core/`). Each includes unit tests.

**New capabilities:**
- `hole-prism-revol` — BRepFeat_MakeCylindricalHole, MakePrism (linear extrusion from face), MakeRevol (rotational sweep from face)
- `pipe-feature` — BRepFeat_MakePipe (pipe-shaped depression/protrusion along a path)
- `local-operations` — LocOpe package for local shape operations (local extrusion, groove, rib)

No breaking changes to existing APIs.

## Capabilities

### New Capabilities
- `hole-prism-revol`: Create cylindrical holes (through or blind) via BRepFeat_MakeCylindricalHole, prismatic depressions/protrusions via BRepFeat_MakePrism (extrude a face or wire from a base face), and rotational features via BRepFeat_MakeRevol (revolve a profile from a face around an axis). Each supports both removal (depression) and addition (protrusion).
- `pipe-feature`: Create pipe-shaped features (depression or protrusion) by sweeping a profile along a path from a base face, via BRepFeat_MakePipe.
- `local-operations`: Local shape modification operations via LocOpe — local boolean operations on a single face, groove creation, rib creation.

### Modified Capabilities
None.

## Impact

- **wrap/occt_wrap.h + .cpp**: ~20 new C bridge functions across 3 specs.
- **src/ffi/bindings.lisp**: Corresponding `%`-prefixed CFFI `defcfun` bindings.
- **src/core/**: New files:
  - `src/core/hole-prism-revol.lisp` — hole, prismatic, and rotational features
  - `src/core/pipe-feature.lisp` — pipe-shaped features
  - `src/core/local-ops.lisp` — local operations
- **src/package.lisp**: ~20+ new exported symbols.
- **t/smoke-tests.lisp**: New test sections per spec.
- **README.md**: Updated with mechanical features API documentation.
