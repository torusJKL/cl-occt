## 1. Build System

- [x] 1.1 Create `justfile` with `setup`, `wrap`, `repl`, `clean` recipes
- [x] 1.2 Create `setup` recipe: download OCCT 8.0 tarball, cmake build with minimum modules (no Vis, no AppFramework), install to `.local/`
- [x] 1.3 Create `wrap` recipe: compile `wrap/occt_wrap.cpp` → `lib/libocctwrap.so` linking TKernel, TKBRep, TKPrim, TKBool, TKSTEP, TKSTEPBase, TKXSBase, TKMath, TKG2d, TKG3d
- [x] 1.4 Create `repl` recipe: launch SBCL with `cl-occt` system loaded
- [x] 1.5 Add `lib/` and `.local/` to `.gitignore`
- [x] 1.6 Verify: `just setup && just wrap && just repl` succeeds end-to-end

## 2. C Wrapper Library

- [x] 2.1 Create `wrap/occt_wrap.h` with opaque `void*` type aliases and `extern "C"` declarations for all 14 functions
- [x] 2.2 Implement primitives: `make_box`, `make_cylinder`, `make_sphere`, `make_cone` — each catches `Standard_Failure`, returns `nullptr` on error
- [x] 2.3 Implement booleans: `boolean_cut`, `boolean_fuse`, `boolean_common` — each checks `IsDone()`, returns `nullptr` on failure
- [x] 2.4 Implement transforms: `translate`, `rotate` using `gp_Trsf` + `BRepBuilderAPI_Transform`
- [x] 2.5 Implement `write_step` using `STEPControl_Writer::Transfer` + `Write`
- [x] 2.6 Implement `read_step` using `STEPControl_Reader::ReadFile` + `OneShape`
- [x] 2.7 Implement `free_shape` as `delete static_cast<TopoDS_Shape*>(p)`
- [x] 2.8 Implement error state: `get_error_code`, `get_error_message` via thread-local globals set on catch
- [x] 2.9 Verify: write a minimal C test program that links and calls every function

## 3. Common Lisp FFI Bindings

- [x] 3.1 Create `src/package.lisp` with `cl-occt` (public) and `cl-occt.impl` (internal) packages
- [x] 3.2 Create `src/ffi/loader.lisp` — `define-foreign-library libocctwrap` + `use-foreign-library`
- [x] 3.3 Create `src/ffi/bindings.lisp` — `defcfun` for all 14 C functions with `%` naming convention
- [x] 3.4 Create `cl-occt.asd` — system definition with 4 modules, correct dependencies, test system
- [x] 3.5 Verify: `(asdf:load-system :cl-occt)` succeeds and all `defcfun` resolve

## 4. CL Shape Wrapper

- [x] 4.1 Create `src/core/shape.lisp` — `shape` CLOS class with `%ptr` slot, `shape-p` predicate
- [x] 4.2 Create `src/core/errors.lisp` — `occt-error` condition, `get-error-message` wrapper
- [x] 4.3 Implement `make-shape` helper: wraps pointer in `shape` instance, registers `tg:finalize` for `%free-shape`, returns nil on null pointer
- [x] 4.4 Verify: `(make-box 10 20 30)` returns a shape, `(make-box 0 0 0)` returns nil

- [x] 5.1 Create `src/core/primitives.lisp` — `make-box`, `make-cylinder`, `make-sphere`, `make-cone` calling `%` FFI through `make-shape`
- [x] 5.2 Create `src/core/booleans.lisp` — `cut`, `fuse`, `common` with variadic chaining (left-to-right), nil propagation
- [x] 5.3 Create `src/core/transforms.lisp` — `translate`, `rotate` with nil propagation
- [x] 5.4 Create `src/core/io.lisp` — `write-step`, `read-step` wrapping `%` FFI
- [x] 5.5 Verify smoke test: `(write-step (cut (make-box 30 20 10) (translate (make-cylinder 5 30) 15 10 0)) "test.step")` produces valid STEP file

- [x] 6.1 Create `src/dag/params.lisp` — `*params*` plist, `set-param!`, `set-params!`
- [x] 6.2 Create `src/dag/registry.lisp` — `*model-registry*` hash-table, `register-model`, `find-model`, `unregister-model`
- [x] 6.3 Create `src/dag/model.lisp` — `model` struct with slots: name, fn, param-keys, model-deps, dependents, dirty, cached-shape, last-param-hash
- [x] 6.4 Create `src/dag/propagation.lisp` — `dirty-model!` (propagate to dependents), topological-sort, `propagate-changes` (find dirty models, sort, evaluate in order)
- [x] 6.5 Verify: `(set-param! :w 10)` triggers propagation; dependent models are re-evaluated in correct order

- [x] 7.1 Create `src/dsl/param.lisp` — `param` function with `*local-params*` fallback chain; `with-params` macro
- [x] 7.2 Create `src/dsl/defmodel.lisp` — `defmodel` macro that: statically scans body for `model-ref` calls, generates function with keyword args (local mode), generates DAG thunk, calls `register-model`
- [x] 7.3 Create `src/dsl/api.lisp` — re-export public symbols, `help` function listing available forms
- [x] 7.4 Verify DAG chain: define `my-box` → define `bracket` → `(set-param! :w 50)` → bracket recomputes

## 8. Tests

- [x] 8.1 Create `t/smoke-tests.lisp` — tests for each primitive (valid + degenerate), each boolean (valid + nil propagation), transforms, IO
- [x] 8.2 Add DAG tests: model definition, dependency tracking, param change propagation, nil propagation
- [x] 8.3 Add DSL tests: defmodel expansion, local mode keyword args, dual-mode param resolution
- [x] 8.4 Verify: `(asdf:test-system :cl-occt)` runs all tests

## 9. REPL Workflow Documentation

- [x] 9.1 Add `help` function to `src/dsl/api.lisp` listing all public symbols with brief docs
- [x] 9.2 Verify end-to-end workflow from a clean SBCL: load system → define models → set params → export STEP → view in external tool
