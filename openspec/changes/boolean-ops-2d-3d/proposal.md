## Why

OCCT provides `BRepAlgoAPI_Section` for computing intersection curves between shapes (e.g., plane-solid section views, face-face intersection curves) and fully supports boolean operations on planar faces as 2D regions. The clocct project currently only exposes 3D cut/fuse/common — no section and no 2D boolean operations. Adding these unlocks section cuts, 2D profile composition, and curve extraction from boolean results.

## What Changes

- Add `section` operation wrapping `BRepAlgoAPI_Section` — computes intersection curves/edges between two shapes
- Add 2D boolean operations: `cut`, `fuse`, `common` for planar faces as 2D regions
- Ensure section result can be consumed as edges/wires by downstream operations
- Extend existing booleans spec with 2D and section requirements
- Add tests covering section (3D, plane-solid, face-face) and 2D boolean (face union, face cut, face common)

## Capabilities

### New Capabilities
- `section-3d`: `BRepAlgoAPI_Section` wrapper — computes intersection curves/edges between two shapes. Supports solid-solid, solid-plane, face-face, and face-plane intersection.
- `booleans-2d`: Boolean operations on planar faces acting as 2D regions. Cut, fuse, and common for faces lying on the same plane.

### Modified Capabilities
- `booleans`: Add requirements for variadic section operation and 2D face-level boolean operations alongside existing 3D ops.

## Impact

- **C wrapper** (`wrap/occt_wrap.cpp`): Add `boolean_section` function
- **CFFI bindings** (`src/ffi/bindings.lisp`): Add `%boolean-section` binding
- **CLOS core** (`src/core/booleans.lisp`): Add `section` function (variadic, nil-propagating); enhance `cut`/`fuse`/`common` to document/accept 2D face input
- **Tests** (`t/smoke-tests.lisp`): Add ~8-12 new test cases for section and 2D booleans
- **Specs** (`openspec/specs/booleans/spec.md`): Extend with section and 2D requirements
