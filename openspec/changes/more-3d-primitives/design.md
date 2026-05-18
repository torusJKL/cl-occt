## Context

cl-occt currently wraps 4 OCST primitives (box, cylinder, sphere, cone) across 4 layers: C wrapper (`occt_wrap.cpp`), CFFI bindings (`bindings.lisp`), public CLOS API (`primitives.lisp`), and package exports (`package.lisp`). Each layer follows a strict pattern — C functions use snake_case, error handling via `thread_local` code/message, CFFI uses `%`-prefixed names, and the CLOS layer wraps `%` calls through `make-shape` which handles null-pointer → nil conversion and `tg:finalize` GC. The existing primitives spec at `openspec/specs/primitives/` covers the current 4.

## Goals / Non-Goals

**Goals:**
- Add OCCT `BRepPrimAPI_MakeTorus` — `make-torus` with major (sweep) and minor (section) radius
- Add OCCT `BRepPrimAPI_MakePrism` — `make-prism` shape + vector (dx, dy, dz) linear extrusion
- Add OCCT `BRepPrimAPI_MakeRevol` — `make-revol` shape + axis + angle rotational extrusion
- Full 4-layer implementation (C wrapper → CFFI → CLOS API → package exports) for each
- Smoke tests for valid construction and nil-on-error for each

**Non-Goals:**
- Pipe, PipeShell, ThickSolid, Wedge, HalfSpace (specialized primitives, future work)
- 2D primitives (wire, face, edge)
- Boolean operations with the new primitives (already work via existing shape interface)
- DAG/DSL integration (generic — works automatically since new functions return shapes)

## Decisions

**1. Torus parameter order: `make-torus major-radius minor-radius`**
Torus is a standalone primitive like box/sphere. OCCT's `BRepPrimAPI_MakeTorus` has constructors taking `(majorRadius, minorRadius)` and optionally `(anAngle)` for a partial torus. We expose the standard 2-param form. The major radius is the distance from the center of the hole to the center of the tube; the minor radius is the radius of the tube. This matches standard CAD conventions.

**2. Prism vs extrude naming: `make-prism`**
OCCT uses `BRepPrimAPI_MakePrism` for linear extrusion. The name `prism` follows OCCT convention. The function takes an existing shape (typically a planar face or wire) and a 3D vector: `(make-prism shape dx dy dz)`. A full/extended form accepting a `dir` + `height` could be added later.

**3. Revolution: `make-revol shape ax ay az angle-deg`**
`BRepPrimAPI_MakeRevol` rotates a shape around an axis defined by origin (0,0,0) and direction vector (ax, ay, az), through an angle in degrees. The function signature mirrors `rotate` from transforms: `(make-revol shape ax ay az angle-deg)`. A full/extended form accepting an arbitrary axis origin point could be added later.

**4. Follow existing patterns exactly**
Each primitive touches the same 4 files in the same way:
- C wrapper: header declaration + function body with `clear_error()`, validation, `try/catch`, `from_shape()`
- CFFI: `(defcfun (%<name> "<c_name>") :pointer ...)` with `:double` params
- Core: `(defun make-<name> (...) (make-shape (%make-<name> ...)))` with `coerce` to double-float
- Package: export `%` symbol from `cl-occt.impl` and unprefixed from `cl-occt`

**5. Torus added to existing primitives spec; extrusion as its own capability**
Torus is a `BRepPrimAPI_Make*` primitive like box/sphere, so it lives in the primitives spec. Prism and revolution are operations on existing shapes — they take a face/wire as input — so they form their own `extrusion` capability.

## Risks / Trade-offs

- **Prism/revol require valid face/wire input**: If the user passes an invalid shape (nil, or a solid without faces), OCCT will either fail at the C++ level or produce unexpected results. Existing `make-shape` returns nil on null pointer, so C-level errors propagate as nil to the user. Mitigation: rely on the existing error-handling pattern (null check → `set_error` → return `nullptr` → Lisp sees nil).
- **OCCT MakePrism/MakeRevol may produce degenerate shapes**: If the extrusion vector is zero-length or the revolution angle is zero, the result may be empty. Mitigation: validate vector magnitude and angle in the C wrapper.
- **Backward compatibility**: No risk — all new symbols. Existing code unaffected.
- **Build time**: Adding ~30 lines of C++ requires recompiling `libocctwrap.so` via `just wrap`.
