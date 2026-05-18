## Why

cl-occt currently implements only 4 of OCCT's standard 3D primitives (box, cylinder, sphere, cone). Torus, prism (linear extrusion), and revolution (rotational extrusion) are essential building blocks for parametric CAD workflows — needed for threaded parts, swept profiles, rotational solids, and pipe-like geometries. Adding them closes the most significant gap in primitive coverage.

## What Changes

- Add **torus** construction (`make-torus`) via OCCT `BRepPrimAPI_MakeTorus`
- Add **prism** (linear extrusion) (`make-prism`) via OCCT `BRepPrimAPI_MakePrism`
- Add **revolution** (rotational extrusion) (`make-revol`) via OCCT `BRepPrimAPI_MakeRevol`
- Add corresponding C wrapper functions, CFFI bindings, CLOS public API, package exports, and smoke tests for each

## Capabilities

### New Capabilities
- `torus`: Construction of torus shapes by major (sweep) radius and minor (section) radius
- `extrusion`: Linear extrusion (`make-prism`) and rotational extrusion (`make-revol`) of existing shapes along vectors or around axes

### Modified Capabilities
- `primitives`: Add torus requirement alongside existing box/cylinder/sphere/cone

## Impact

- **C wrapper** (`wrap/occt_wrap.h`, `wrap/occt_wrap.cpp`): 3 new `extern "C"` functions following existing error-handling pattern
- **CFFI bindings** (`src/ffi/bindings.lisp`): 3 new `defcfun` forms with `%` prefix
- **Core API** (`src/core/primitives.lisp`): new `make-torus`, `make-prism`, `make-revol` functions
- **Package exports** (`src/package.lisp`): new symbols in both `cl-occt.impl` and `cl-occt`
- **Tests** (`t/smoke-tests.lisp`): ~9 new test functions (valid + edge cases per primitive)
- **ASDF** (`cl-occt.asd`): no changes needed (same modules)
- No breaking API changes
