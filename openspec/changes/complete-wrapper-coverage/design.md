## Context

The C wrapper (`wrap/occt_wrap*.h`) declares 733 `extern "C"` functions compiled into `libocctwrap.so`. The FFI layer (`src/ffi/`) defines 726 `defcfun` bindings. Two functions lack CFFI bindings:

1. `v3d_view_set_transparent_shading` — declared twice in `occt_wrap_visual.h` (lines 88, 101) but **never implemented** in any `.cpp` file. The real OCCT function is `V3d_View::SetTransparencyMethod()`, already wrapped as `v3d_view_set_transparency_method` with FFI binding `%v3d-view-set-transparency-method`. The core already defines `set-transparent-shading` as an alias for `set-transparency-method`.

2. `xcaf_get_layer_name` — declared in `occt_wrap_xcaf.h` (line 18), implemented as a stub in `occt_wrap_xcaf.cpp` (lines 113-127, sets `buf[0] = '\0'`). The core `xcaf-get-shape-layers` in `src/core/xcaf-doc.lisp` (line 87) warns "not yet implemented".

## Goals / Non-Goals

**Goals:**
- Add CFFI binding `%xcaf-get-layer-name` for the existing C wrapper
- Implement the C stub `xcaf_get_layer_name` to actually retrieve layer names via `XCAFDoc_LayerTool`
- Implement core `xcaf-get-shape-layers` using the new FFI binding
- Remove the duplicate dead declaration of `v3d_view_set_transparent_shading` from the header
- Clean up the `v3d_view_set_transparent_shading` entry in `api-reference.md` (it already has `set-transparency-method`)
- Update api-reference.md with `xcaf-get-shape-layers`
- Add enriched Markdown docstrings to `xcaf-get-shape-layers` and ensure `set-transparency-method` / `set-transparent-shading` docstrings conform to the `docstring-markdown-convention` spec

**Non-Goals:**
- No new OCCT functionality beyond closing the coverage gap
- No changes to `set-transparent-shading` / `set-transparency-method` behavior (already works)
- No re-architecting of the wrapper or FFI generation system
- No global docstring audit — only functions touched by this change

## Decisions

1. **Remove `v3d_view_set_transparent_shading` declarations, don't add FFI binding.** The function has no C implementation and never will — OCCT uses `SetTransparencyMethod` for this purpose. The duplicate declarations at lines 88 and 101 are dead code. The core layer already routes `set-transparent-shading` to `%v3d-view-set-transparency-method`. Removing the declarations eliminates confusion and avoids linker errors if someone adds an FFI binding for it.

2. **Fix the `xcaf_get_layer_name` C stub, then add FFI binding.** The C stub needs to use `XCAFDoc_LayerTool::GetLayers()` to iterate layer labels and extract their names via `TDataStd_Name`. The FFI binding returns the name via a buffer (existing pattern), with the core function converting to a Lisp string.

3. **Core `xcaf-get-shape-layers` iterates layer count + name per index.** Pattern: call `xcaf_get_layer_count` to determine iteration count, then call `xcaf_get_layer_name` for each index, collecting results into a list.

4. **Docstrings follow existing `docstring-markdown-convention` spec.** Parameters use `- **name** description` format, return values use `**Returns:**`, examples use `**Example:**` followed by 4-space-indented code. See `openspec/specs/docstring-markdown-convention/spec.md` for full format rules.

## Risks / Trade-offs

- **Layer name encoding** — OCCT layer names use `TDataStd_Name`, which stores UCS-2. The current buffer approach may truncate or mangle non-ASCII names. Mitigation: Use a reasonably large buffer (256 chars) and document the limitation.
- **Stub complexity** — The `xcaf_get_layer_name` C stub was never completed, suggesting the OCCT API for retrieving layer names by index may be non-trivial. Mitigation: Study `XCAFDoc_LayerTool` API to ensure correct iteration over layer labels.
