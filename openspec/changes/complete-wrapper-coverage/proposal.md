## Why

The C wrapper (`libocctwrap.so`) declares 733 `extern "C"` functions, but only 726 have corresponding CFFI `defcfun` bindings — 99.0% coverage. Two functions are missing: `v3d_view_set_transparent_shading` (duplicate declaration, no C implementation) and `xcaf_get_layer_name` (stub implementation). Additionally, the core `xcaf-get-shape-layers` function is marked "not yet implemented" and the api-reference document has gaps. This change closes the remaining gap and cleans up the dead declaration.

## What Changes

- Add CFFI binding `%v3d-view-set-transparent-shading` or remove the dead C declaration (and its duplicate)
- Add CFFI binding `%xcaf-get-layer-name`
- Implement `xcaf-get-shape-layers` core function using the new FFI binding
- Remove duplicate `v3d_view_set_transparent_shading` declaration from `wrap/occt_wrap_visual.h` (line 101) if the function is not actually needed
- Ensure any new public API functions are documented in `docs/api-reference.md`
- Add enriched Markdown docstrings to public functions following the `docstring-markdown-convention` spec (parameters, returns, examples, see-also)

## Capabilities

### New Capabilities
- `xcaf-layer-names`: Full layer name retrieval for shapes in XCAF documents

### Modified Capabilities
- `api-reference-docs`: New functions need documentation entries
- `viewer`: Clean up transparent shading declaration (dead/duplicate)

## Impact

- `wrap/occt_wrap_visual.h` — fix duplicate declaration
- `src/ffi/bindings-visual.lisp` — add missing binding (or mark as not needed)
- `src/ffi/bindings-xcaf.lisp` — add missing binding
- `src/core/xcaf-doc.lisp` — implement `xcaf-get-shape-layers` with Markdown docstring
- `src/core/viewer-rendering.lisp` — ensure `set-transparent-shading` / `set-transparency-method` docstrings follow convention
- `docs/api-reference.md` — document new functions
