## 1. C Wrapper — Header Declarations

- [x] 1.1 Add to `wrap/occt_wrap.h`:
  - `void v3d_view_set_bg_color(void* view, double r, double g, double b);`
  - `void ais_context_set_color(void* ctx, void* obj, double r, double g, double b);`
  - `void ais_context_unset_color(void* ctx, void* obj);`
  - `void ais_context_set_display_mode(void* ctx, void* obj, int mode);`
  - `void v3d_view_set_proj(void* view, int orientation);`
  - `void v3d_view_set_msaa(void* view, int samples);`
  - `int  v3d_view_get_msaa(void* view);`
  - `void v3d_view_set_antialiasing(void* view, int on);`
  - `int  v3d_view_get_antialiasing(void* view);`
  - `void v3d_viewer_activate_grid(void* viewer, int gridType, int drawMode);`
  - `void v3d_viewer_deactivate_grid(void* viewer);`
  - `void v3d_view_invalidate(void* view);`

## 2. C Wrapper — Implementation

- [x] 2.1 Implement `v3d_view_set_bg_color` — call `view->SetBackgroundColor(Quantity_Color(r,g,b,Quantity_TOC_RGB))`
- [x] 2.2 Implement `ais_context_set_color` — call `ctx->SetColor(obj, Quantity_Color(r,g,b,Quantity_TOC_RGB), false)`
- [x] 2.3 Implement `ais_context_unset_color` — call `ctx->UnsetColor(obj, false)`
- [x] 2.4 Implement `ais_context_set_display_mode` — call `ctx->SetDisplayMode(obj, mode, false)`
- [x] 2.5 Implement `v3d_view_set_proj` — call `view->SetProj(static_cast<V3d_TypeOfOrientation>(orientation))`
- [x] 2.6 Implement `v3d_view_set_msaa` — call `view->ChangeRenderingParams().NbMsaaSamples = samples`
- [x] 2.7 Implement `v3d_view_get_msaa` — return `view->ChangeRenderingParams().NbMsaaSamples`
- [x] 2.8 Implement `v3d_view_set_antialiasing` — call `view->ChangeRenderingParams().IsAntialiasingEnabled = (on != 0)`
- [x] 2.9 Implement `v3d_view_get_antialiasing` — return `view->ChangeRenderingParams().IsAntialiasingEnabled ? 1 : 0`
- [x] 2.10 Implement `v3d_viewer_activate_grid` — call `viewer->ActivateGrid(static_cast<Aspect_GridType>(gridType), static_cast<Aspect_GridDrawMode>(drawMode))`
- [x] 2.11 Implement `v3d_viewer_deactivate_grid` — call `viewer->DeactivateGrid()`
- [x] 2.12 Implement `v3d_view_invalidate` — call `view->Invalidate()`
- [x] 2.13 Add `#include <Aspect_GridType.hxx>`, `#include <Aspect_GridDrawMode.hxx>`, `#include <V3d_TypeOfOrientation.hxx>` (Quantity_Color.hxx already present)
- [x] 2.14 Verified: rebuild with `just wrap` — compiles clean

## 3. CFFI Bindings

- [x] 3.1 Add defcfun forms to `src/ffi/bindings.lisp` matching the 12 C functions above

## 4. Lisp API — Color

- [x] 4.1 Add `defparameter` enum maps:
  - `*v3d-orientation-map*` — `:x-pos` → 0, `:y-pos` → 1, etc.
  - `*ais-display-mode-map*` — `:wireframe` → 0, `:shaded` → 1
  - `*grid-type-map*` — `:rectangular` → 0, `:circular` → 1
  - `*grid-draw-mode-map*` — `:lines` → 0, `:points` → 1
- [x] 4.2 Implement `set-background` — wraps `%v3d-viewer-set-bg-color`, accepts 3 doubles or a list
- [x] 4.3 Implement `ais-set-color` — wraps `%ais-context-set-color`, accepts context + object + `(r g b)` list
- [x] 4.4 Implement `ais-unset-color` — wraps `%ais-context-unset-color`

## 5. Lisp API — Display Mode

- [x] 5.1 Implement `ais-set-display-mode` — translates keyword (`:wireframe` / `:shaded`) to int, calls `%ais-context-set-display-mode`

## 6. Lisp API — Camera

- [x] 6.1 Implement `set-view-projection` — translates keyword to int, calls `%v3d-view-set-proj`
- [x] 6.2 Verify `fit-all` exists (Phase 1) — confirmed in `src/core/viewer.lisp:35`

## 7. Lisp API — MSAA & Antialiasing

- [x] 7.1 Implement `set-msaa` and `msaa` — wraps `%v3d-view-set-msaa` / `%v3d-view-get-msaa`
- [x] 7.2 Implement `set-antialiasing` and `antialiasing-p` — wraps `%v3d-view-set-antialiasing` / `%v3d-view-get-antialiasing`

## 8. Lisp API — Grid

- [x] 8.1 Implement `activate-grid` — translates grid type + draw mode keywords, calls `%v3d-viewer-activate-grid`
- [x] 8.2 Implement `deactivate-grid` — calls `%v3d-viewer-deactivate-grid`

## 9. Lisp API — Invalidate

- [x] 9.1 Implement `invalidate-view` — wraps `%v3d-view-invalidate`

## 10. Package Exports

- [x] 10.1 Export new `%` symbols from `cl-occt.impl`
- [x] 10.2 Export new public symbols from `cl-occt`: `set-background`, `ais-set-color`, `ais-unset-color`, `ais-set-display-mode`, `set-view-projection`, `set-msaa`, `msaa`, `set-antialiasing`, `antialiasing-p`, `activate-grid`, `deactivate-grid`, `invalidate-view`

## 11. Smoke Tests

- [x] 11.1 Add test: set-background with valid RGB does not error
- [x] 11.2 Add test: ais-set-color on displayed shape does not error
- [x] 11.3 Add test: ais-set-display-mode with :wireframe does not error
- [x] 11.4 Add test: set-view-projection with :iso-pers does not error
- [x] 11.5 Add test: set-msaa round-trip (set to 4, read back)
- [x] 11.6 Add test: set-antialiasing round-trip (set to t, read back)
- [x] 11.7 Add test: activate-grid with :rectangular :lines does not error
- [x] 11.8 Add test: activate-grid with :circular :points does not error
- [x] 11.9 Register all new tests in `run-tests` list

## 12. README — Styling, Camera, Grid Documentation

- [x] 12.1 Add "Styling" section to API Reference table:
- [x] 12.2 Add "Camera" section:
- [x] 12.3 Add "Rendering" section:
- [x] 12.4 Add "Grid" section:
- [x] 12.5 Update C function count in Architecture section (74 → 86)
- [x] 12.6 Update test count

## 13. Build & Verify

- [x] 13.1 Rebuilt `libocctwrap.so` with `just wrap` — success
- [x] 13.2 Ran `(cl-occt::run-tests)` — 121 pass, 0 fail, 0 errors
