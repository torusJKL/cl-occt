## 1. Build System — Link Libraries

- [x] 1.1 Add `-lTKDESTL -lTKMesh` to the `justfile` wrap recipe's g++ link line

## 2. C Wrapper — Header Declarations

- [x] 2.1 Add `write_stl`, `read_stl` declarations to `wrap/occt_wrap.h`

## 3. C Wrapper — Implementation

- [x] 3.1 Add `#include <BRepMesh_IncrementalMesh.hxx>`, `#include <StlAPI_Writer.hxx>`, `#include <StlAPI_Reader.hxx>` to `wrap/occt_wrap.cpp`
- [x] 3.2 Implement `write_stl(shape, filename, deflection)`: tessellates via `BRepMesh_IncrementalMesh`, writes via `StlAPI_Writer::Write`, returns 1/0
- [x] 3.3 Implement `read_stl(filename)`: reads via `StlAPI_Reader::Read`, returns shape or nullptr
- [x] 3.4 Verify: rebuild with `just wrap`, check no compilation errors

## 4. CFFI Bindings

- [x] 4.1 Add `%write-stl` and `%read-stl` `defcfun` forms to `src/ffi/bindings.lisp` with matching signatures

## 5. Core API

- [x] 5.1 Add `write-stl` function to `src/core/io.lisp` — wraps `%write-stl`, accepts `&key (deflection 0.1d0)`, returns t on success or nil on nil shape
- [x] 5.2 Add `read-stl` function to `src/core/io.lisp` — wraps `%read-stl`, returns shape via `make-shape`

## 6. Package Exports

- [x] 6.1 Export `%write-stl`, `%read-stl` from `cl-occt.impl` and `write-stl`, `read-stl` from `cl-occt` in `src/package.lisp`

## 7. DSL Help

- [x] 7.1 Update `help` function in `src/dsl/api.lisp` to list STL I/O functions

## 8. Smoke Tests

- [x] 8.1 Add test: `write-stl` valid box exports to file
- [x] 8.2 Add test: `write-stl` with nil shape returns nil
- [x] 8.3 Add test: `read-stl` round-trip after write
- [x] 8.4 Add test: `read-stl` on non-existent file returns nil
- [x] 8.5 Add test: `write-stl` with custom deflection produces valid STL
- [x] 8.6 Register all new tests in `run-tests` list in `t/smoke-tests.lisp`

## 9. README Update

- [x] 9.1 Add STL I/O row to "API Reference" table after STEP I/O section
- [x] 9.2 Update quickstart example to show STL export alongside STEP
- [x] 9.3 Update architecture section: function count 31→33, add "STL I/O" to src/core description
- [x] 9.4 Update project structure: `io.lisp` description to include write-stl, read-stl
- [x] 9.5 Update test count: "55 smoke tests" → "67 smoke tests"

## 10. Build & Verify

- [x] 9.1 Rebuild `libocctwrap.so` with `just wrap`
- [x] 9.2 Run `(cl-occt::run-tests)` — all tests pass including new STL tests
