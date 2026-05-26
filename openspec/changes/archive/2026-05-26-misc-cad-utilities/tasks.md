## 1. C Wrapper — Constrained 2D Geometry (GccAna)

- [x] 1.1 Create `wrap/occt_wrap_gccana.h` with declarations for 2D constraint functions
- [x] 1.2 Create `wrap/occt_wrap_gccana.cpp` with includes for `<GccAna_Circ2d2TanOn.hxx>`, `<GccAna_Lin2d2Tan.hxx>`, etc.
- [x] 1.3 Implement `gccana_circle_tangent_two_lines(x1,y1,dx1,dy1, x2,y2,dx2,dy2, radius, out_circles, count)` returning solutions
- [x] 1.4 Implement `gccana_line_through_two_points(x1,y1, x2,y2, out_params)` returning line parameters
- [x] 1.5 Add error handling

## 2. C Wrapper — Units API

- [x] 2.1 Create `wrap/occt_wrap_units.h` with declarations
- [x] 2.2 Create `wrap/occt_wrap_units.cpp` with include for `<UnitsAPI.hxx>`
- [x] 2.3 Implement `units_convert(value, from_unit, to_unit)` returning converted value
- [x] 2.4 Implement `units_convert_to_si(value, unit)` returning SI value
- [x] 2.5 Implement `units_convert_from_si(value, unit)` returning converted value from SI

## 3. C Wrapper — Expression Interpreter

- [x] 3.1 Create `wrap/occt_wrap_expr.h` with declaration
- [x] 3.2 Create `wrap/occt_wrap_expr.cpp` with include for `<ExprIntrp_GenExp.hxx>`, `<ExprIntrp.hxx>`
- [x] 3.3 Implement `evaluate_expression(string)` returning double value

## 4. C Wrapper — Extended Math Solvers

- [x] 4.1 Extend existing `wrap/occt_wrap_math_inttools.h` with additional solver declarations
- [x] 4.2 Extend existing `wrap/occt_wrap_math_inttools.cpp` with includes for `<math_FunctionRoot.hxx>`, `<math_BissecNewton.hxx>`, `<math_NewtonMinimum.hxx>`
- [x] 4.3 Implement `math_function_root(func_ptr, x0)` returning root
- [x] 4.4 Implement `math_newton_minimum(func_ptr, x0)` returning minimum

## 5. CFFI Bindings

- [x] 5.1 Create `src/ffi/bindings-gccana.lisp` with defcfun for 2D constraint functions
- [x] 5.2 Create `src/ffi/bindings-units.lisp` with defcfun for unit conversion
- [x] 5.3 Create `src/ffi/bindings-expr.lisp` with defcfun for expression evaluation
- [x] 5.4 Extend `src/ffi/bindings-math-inttools.lisp` with additional solver bindings

## 6. Core CLOS Wrappers

- [x] 6.1 Create `src/core/constrained-2d.lisp` with `circle-tangent-two-lines`, `line-through-two-points`
- [x] 6.2 Create `src/core/units-api.lisp` with `convert-units`, `convert-to-si`, `convert-from-si`
- [x] 6.3 Create `src/core/expression-interp.lisp` with `evaluate-expression`
- [x] 6.4 Extend `src/core/math-inttools.lisp` with `function-root`, `newton-minimum`

## 7. System Integration

- [x] 7.1 Add new C wrapper files to `wrap/Makefile`
- [x] 7.2 Register new core files in `cl-occt.asd`
- [x] 7.3 Export new public symbols in `src/package.lisp`

## 8. Tests

- [x] 8.1 Add constrained 2D tests: circle tangent to two lines, line through two points
- [x] 8.2 Add units tests: mm→inch, kg→lbm, SI round-trip
- [x] 8.3 Add expression tests: arithmetic, trig, invalid
- [x] 8.4 Add math solver tests: root finding, minimization
- [x] 8.5 Register all new tests in the test runner

## 9. Documentation

- [x] 9.1 Add "Constrained 2D Geometry" section to `doc/api-reference.md`
- [x] 9.2 Add "Units API" section to `doc/api-reference.md`
- [x] 9.3 Add "Expression Interpreter" section to `doc/api-reference.md`
- [x] 9.4 Add "Math Solvers" section to `doc/api-reference.md`

## 10. Build & Verify

- [x] 10.1 Rebuild `lib/libocctwrap.so` with `just wrap`
- [x] 10.2 Run `just test-all` to verify all new and existing tests pass
- [x] 10.3 Fix any compilation or test failures
