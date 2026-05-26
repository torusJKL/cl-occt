## 1. Clean Up Dead C Declaration

- [x] 1.1 Remove duplicate `v3d_view_set_transparent_shading` declaraction from `wrap/occt_wrap_visual.h` (lines 88 and 101)
- [x] 1.2 Remove stale `set-transparent-shading` reference from `docs/api-reference.md`

## 2. Implement xcaf_get_layer_name C Wrapper

- [x] 2.1 Implement `xcaf_get_layer_name` in `wrap/occt_wrap_xcaf.cpp` to properly retrieve layer names via `XCAFDoc_LayerTool::GetLayers()` and `TDataStd_Name`
- [x] 2.2 Rebuild `lib/libocctwrap.so` with `just wrap`

## 3. Add CFFI Bindings

- [x] 3.1 Add `defcfun (%xcaf-get-layer-name "xcaf_get_layer_name")` to `src/ffi/bindings-xcaf.lisp`
- [x] 3.2 Export `%xcaf-get-layer-name` from `cl-occt.impl` package in `src/package.lisp`

## 4. Implement Core Layer

- [x] 4.1 Implement `xcaf-get-shape-layers` in `src/core/xcaf-doc.lisp` using `%xcaf-get-layer-count` and `%xcaf-get-layer-name`
- [x] 4.2 Export `xcaf-get-shape-layers` from `cl-occt` package in `src/package.lisp`

## 5. Enriched Markdown Docstrings

- [x] 5.1 Write Markdown docstring for `xcaf-get-shape-layers` following `docstring-markdown-convention` spec (`- **doc**`, `- **shape**`, `**Returns:**`, `**Example:**`)
- [x] 5.2 Update `set-transparency-method` docstring to use `- **view**` / `- **method**` parameter format per convention
- [x] 5.3 Update `set-transparent-shading` docstring to match the convention (alias reference)

## 6. Update API Reference

- [x] 6.1 Add `xcaf-get-shape-layers` entry to the \"XCAF Document Tools\" section in `docs/api-reference.md`
- [x] 6.2 Ensure `set-transparency-method` entry is accurate and `set-transparent-shading` is noted as alias only

## 7. Verify

- [x] 7.1 Run `just test-core` to confirm no regressions
- [x] 7.2 Run `just test-all` to confirm full test suite passes
