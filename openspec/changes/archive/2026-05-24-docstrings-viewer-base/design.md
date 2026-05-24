## Context

Five files covering the viewer infrastructure: core viewer lifecycle (`viewer.lisp`), grid, background, camera, and rendering settings. `viewer.lisp` alone has 38 function definitions plus the `with-viewer` macro — it's the largest single file in this batch.

Functions span viewer creation/destruction, AIS context management, object display/erase/styling, trihedron display, grid activation, camera manipulation, projection modes, MSAA/antialiasing, and rendering back-face models.

## Goals / Non-Goals

**Goals:**
- Every public function gets docstring with example (docstring-only for 4 trivial predicates)
- View setup examples should follow the standard pattern: `make-viewer` → `ais-create-context` → `ais-display` → `fit-all`
- Camera and rendering examples build on basic viewer setup
- `with-viewer` macro gets an example showing its cleanup guarantee

**Non-Goals:**
- No functional or API changes

## Decisions

- **Viewer lifecycle** examples should show the canonical usage pattern
- **Camera examples** should demonstrate `set-view-projection`, `perspective-p`, `pan/zoom/rotate-camera`
- **Trihedron functions** should be demonstrated together in sequence
- **Grid functions** group naturally — show activation with type and draw mode, then query and deactivation
- **Rendering examples** should show `set-computed-mode` and `set-transparency-method` toggle

## Risks / Trade-offs

- **Viewer examples need a display** — functions that create windows won't work in headless mode. Examples should reference the need for an X display or `xvfb-run` but keep the example concise.
