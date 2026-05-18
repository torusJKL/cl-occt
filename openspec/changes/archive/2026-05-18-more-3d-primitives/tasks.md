## 1. C Wrapper — Header declarations

- [x] 1.1 Add `make_torus`, `make_prism`, `make_revol` to `wrap/occt_wrap.h`

## 2. C Wrapper — Implementation

- [x] 2.1 Add `BRepPrimAPI_MakeTorus.hxx`, `BRepPrimAPI_MakePrism.hxx`, `BRepPrimAPI_MakeRevol.hxx` includes to `wrap/occt_wrap.cpp`
- [x] 2.2 Implement `make_torus(major_radius, minor_radius)` with validation
- [x] 2.3 Implement `make_prism(shape, dx, dy, dz)` with vector-magnitude validation
- [x] 2.4 Implement `make_revol(shape, ax, ay, az, angle_deg)` with angle validation

## 3. CFFI Bindings

- [x] 3.1 Add `%make-torus`, `%make-prism`, `%make-revol` to `src/ffi/bindings.lisp`

## 4. Core API

- [x] 4.1 Add `make-torus`, `make-prism`, `make-revol` to `src/core/primitives.lisp`

## 5. Package Exports

- [x] 5.1 Export new `%` symbols from `cl-occt.impl` and unprefixed symbols from `cl-occt` in `src/package.lisp`

## 6. Smoke Tests

- [x] 6.1 Add torus tests: valid, zero major radius, zero minor radius
- [x] 6.2 Add prism tests: valid extrusion, zero vector, nil shape
- [x] 6.3 Add revolution tests: valid revolve, zero angle, nil shape
- [x] 6.4 Register all new tests in `run-tests` list

## 7. README Update

- [x] 7.1 Update primitives API table in `README.md` to add `make-torus`, `make-prism`, `make-revol`
- [x] 7.2 Update `README.md` function counts (14→17 in architecture section, 14→17 in structure section)
- [x] 7.3 Update `README.md` `primitives.lisp` description to mention new functions

## 8. Build & Verify

- [x] 8.1 Rebuild `libocctwrap.so` with `just wrap`
- [x] 8.2 Run smoke tests with `(cl-occt::run-tests)`
