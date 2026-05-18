## 1. C Wrapper — boolean_section

- [x] 1.1 Add `#include <BRepAlgoAPI_Section.hxx>` to `wrap/occt_wrap.cpp`
- [x] 1.2 Implement `boolean_section(occt_shape a, occt_shape b)` following the existing null-check / IsDone / is_empty / exception pattern. Calls `maker.Build()` and returns the shape result as a compound of intersection edges.

## 2. CFFI Binding

- [x] 2.1 Add `(%boolean-section "boolean_section") :pointer (a :pointer) (b :pointer) (compute-wire :int)` to `src/ffi/bindings.lisp`

## 3. CLOS Core — section function

- [x] 3.1 Add `section` function to `src/core/booleans.lisp`: variadic, nil-propagating, with `&key compute-wire` keyword mapped to `%boolean-section` int flag

## 4. Package exports

- [x] 4.1 Export `section` from `cl-occt` package in `src/package.lisp`

## 5. Smoke tests

- [x] 5.1 Add section tests: solid-plane section, two intersecting solids, non-intersecting solids, nil propagation (first arg nil, second arg nil), variadic section, section with compute-wire
- [x] 5.2 Add 2D boolean tests: face cut (overlapping), face fuse (overlapping), face common (overlapping), face common (non-overlapping), 2D cut with nil
- [x] 5.3 Register all new tests in `run-tests` list in `t/smoke-tests.lisp`

## 6. README update

- [x] 6.1 Add `section` to the Booleans table in `README.md`: `(section a &rest others &key compute-wire)` row
- [x] 6.2 Update function counts and file references in architecture/structure sections

## 7. Build & verify

- [x] 7.1 Rebuild `libocctwrap.so` with `just wrap`
- [x] 7.2 Run smoke tests with `(cl-occt::run-tests)` — verify all section and 2D boolean tests pass
