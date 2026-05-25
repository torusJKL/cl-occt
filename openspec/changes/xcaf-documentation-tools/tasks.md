## 1. C++ Wrapper

- [x] 1.1 Add `XCAFDoc_LayerTool` wrapper functions in `wrap/occt_wrap.h` and `wrap/occt_wrap.cpp`
- [x] 1.2 Add `XCAFDoc_MaterialTool` wrapper function (has-material)
- [x] 1.3 Add `XCAFDoc_DimTolTool` support (via shape label lookup utilities)
- [x] 1.4 Add `XCAFDoc_ViewTool` wrapper functions (add/list views)
- [x] 1.5 Add `XCAFDoc_NotesTool` support (via shape label lookup utilities)
- [x] 1.6 Add `XCAFDoc_VisMaterialTool` wrapper functions (get visual material color)
- [x] 1.7 Add `XCAFDoc_ClippingPlaneTool` wrapper functions (list clipping planes)
- [x] 1.8 Add `XCAFDoc_Editor` wrapper function (expand assembly)
- [x] 1.9 Add `XCAFApp_Application` wrapper functions (create/free document)

## 2. FFI Bindings

- [x] 2.1 Add `%xcaf-*` defcfun bindings in `src/ffi/bindings.lisp` for all C wrapper functions
- [x] 2.2 Export `%xcaf-*` symbols from `cl-occt.impl` in `src/package.lisp`

## 3. Core Lisp Wrappers

- [x] 3.1 Create `src/core/xcaf-doc.lisp` with `xcaf-doc` CLOS class and `make-xcaf-doc` / `xcaf-free-doc`
- [x] 3.2 Add layer management functions (`xcaf-add-shape-to-layer`, `xcaf-remove-shape-from-layer`, `xcaf-get-shape-layers`)
- [x] 3.3 Add material management function (`xcaf-has-material`)
- [x] 3.4 Add view management functions (`xcaf-add-view`, `xcaf-get-views`)
- [x] 3.5 Add visual material function (`xcaf-get-visual-material`)
- [x] 3.6 Add clipping plane function (`xcaf-get-clipping-planes`)
- [x] 3.7 Add editor function (`xcaf-expand-assembly`)
- [x] 3.8 Add shape registration (`xcaf-add-shape`)
- [x] 3.9 Export all public symbols from `cl-occt` in `src/package.lisp`

## 4. Build & Registration

- [x] 4.1 Register `src/core/xcaf-doc.lisp` in `cl-occt.asd` (module "core" `:serial t` order after `io.lisp`)
- [x] 4.2 Run `just wrap` to rebuild `lib/libocctwrap.so`
- [x] 4.3 Load system and verify all functions are accessible

## 5. Tests

- [x] 5.1 Add test for `make-xcaf-doc` and `xcaf-free-doc` lifecycle
- [x] 5.2 Add tests for layer tool (add/remove/query layers)
- [x] 5.3 Add tests for material tool (has-material)
- [x] 5.4 Add tests for view tool
- [x] 5.5 Add tests for nil doc handling
- [x] 5.6 Add tests for remove-shape-from-layer
- [x] 5.10 Register test symbols in `run-core-tests` in `t/smoke-tests.lisp`
- [x] 5.11 Run `just test-core` and verify all tests pass

## 6. Documentation

- [x] 6.1 Add "XCAF Document Tools" section to `docs/api-reference.md` with all public function signatures and descriptions
