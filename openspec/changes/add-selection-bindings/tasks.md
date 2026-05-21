## 1. C Wrapper Layer

- [x] 1.1 Add selection function declarations to `wrap/occt_wrap.h`
- [x] 1.2 Add selection function implementations to `wrap/occt_wrap.cpp`

## 2. CFFI Bindings

- [x] 2.1 Add `%ais-context-*` defcfun bindings to `src/ffi/bindings.lisp`

## 3. CLOS Wrapper Layer

- [x] 3.1 Add enum keyword maps to `src/core/viewer.lisp`
- [x] 3.2 Add selection management CLOS functions to `src/core/viewer-object-props.lisp`
- [x] 3.3 Add selection iteration CLOS functions to `src/core/viewer-object-props.lisp`
- [x] 3.4 Add mouse detection CLOS functions to `src/core/viewer-object-props.lisp`
- [x] 3.5 Add highlight and configuration CLOS functions to `src/core/viewer-object-props.lisp`

## 4. Package Exports

- [x] 4.1 Add IMPL exports for all `%ais-context-*` symbols to `src/package.lisp`
- [x] 4.2 Add public exports for all CLOS functions and enum maps to `src/package.lisp`

## 5. Tests

- [x] 5.1 Add selection management tests to `t/smoke-tests.lisp`
- [x] 5.2 Add selection iteration tests to `t/smoke-tests.lisp`
- [x] 5.3 Add selection highlight tests to `t/smoke-tests.lisp`

## 6. Documentation

- [x] 6.1 Update README with selection API documentation

## 7. Build & Verify

- [x] 7.1 Rebuild `libocctwrap.so` and run `just test-all`
