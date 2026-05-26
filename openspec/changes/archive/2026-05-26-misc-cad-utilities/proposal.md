## Why

Phases 1 and 2 covered essential topology data access, geometry evaluation, and advanced CAD modeling. This phase fills remaining gaps in OCCT's utility layer: constrained 2D geometry construction (e.g., circle tangent to two lines), a units conversion API for multi-unit CAD workflows, an expression interpreter for parametric formulas, and additional math solvers. These are lower-priority enhancements that complete the OCCT binding surface.

## What Changes

- **Constrained 2D geometry**: C wrapper + CFFI + core for `GccAna` (analytical 2D constraints) and `Geom2dGcc` (geometric 2D constraints) — solutions for circles/lines through points, tangent to lines/circles, etc.
- **Units API**: C wrapper + CFFI + core for `UnitsAPI` — unit conversion between SI, Imperial, and user-defined units
- **Expression interpreter**: C wrapper + CFFI + core for `ExprIntrp` — evaluate mathematical expressions from strings
- **Additional math solvers**: Extend existing `math-inttools` bindings with additional `math_*` classes (e.g., `math_FunctionRoot`, `math_BissecNewton`, `math_NewtonMinimum`)
- **Documentation**: Update `doc/api-reference.md` with all new function signatures

## Capabilities

### New Capabilities
- `constrained-2d-geometry`: GccAna and Geom2dGcc for 2D geometric constraints
- `units-api`: Unit conversion via UnitsAPI
- `expression-interpreter`: String expression evaluation via ExprIntrp
- `math-solvers-extended`: Additional OCCT math solvers

### Modified Capabilities
- *(no existing capabilities have requirement changes)*

## Impact

- **C wrapper** (`wrap/`): ~10 new `extern "C"` functions across 3-4 new files
- **CFFI layer** (`src/ffi/`): ~10 new `defcfun` bindings
- **Core layer** (`src/core/`): 3-4 new Lisp files, extend existing `math-inttools.lisp`
- **Tests** (`tests/`): ~40 new tests
- **Docs** (`doc/api-reference.md`): 4 new sections
