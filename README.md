# cl-occt — Common Lisp OCCT Library

A Common Lisp library wrapping [OCCT 8.0](https://dev.opencascade.org/) for 3D CAD geometry.
Provides CFFI bindings, a CLOS shape wrapper with GC, primitives, booleans, transforms, STEP I/O, STL I/O,
a full 3D viewer with object display, styling, camera control, and a trihedron orientation aid.

This is a **library**, not an application. Use it to build CAD tools, scripts, or GUIs in SBCL.

Source repository: [github.com/torusJKL/cl-occt](https://github.com/torusJKL/cl-occt)

## Prerequisites

### Ubuntu 26.04 / Debian

```sh
sudo apt install sbcl curl build-essential cmake libc6
```

### Quicklisp (Common Lisp package manager)

```sh
curl -Lo /tmp/quicklisp.lisp https://beta.quicklisp.org/quicklisp.lisp
sbcl --load /tmp/quicklisp.lisp --eval "(quicklisp-quickstart:install)" --quit
```

This installs to `~/quicklisp/` and adds the init block to `~/.sbclrc`.

### Other platforms

Linux x86-64 is actively tested. macOS/Windows should work with equivalent tooling (Homebrew for macOS, MSYS2 for Windows).

## Build

### One-time: download and build OCCT 8.0 (~15 min)

```sh
just setup
```

This configures an OCCT build with:
- Shared libraries only
- Visualization enabled (TKV3d, TKOpenGl, TKService linked)
- ApplicationFramework (TKCAF) enabled for XDE color/assembly support
- Installs to `.local/`

### Compile the C wrapper library

```sh
just wrap
```

Produces `lib/libocctwrap.so` — a thin C bridge over OCCT C++ APIs.

### Launch the REPL

```sh
just start
```

This loads Quicklisp, finds the `cl-occt` system, and drops you into the `CL-OCCT` package.

## Quickstart

### Geometry

```lisp
(in-package :cl-occt)

(let ((box (make-box 30 20 10))
      (sphere (make-sphere 8)))
  (write-step (cut box (translate sphere 15 10 5))
              "result.step")
  (write-stl (cut box (translate sphere 15 10 5))
             "result.stl"
             :deflection 0.05)
  ;; Export multiple shapes as a single STL
  (write-stl (make-compound (list box sphere))
             "compound.stl"
             :deflection 0.05))
```

### 3D Viewer (requires a GUI window)

```lisp
;; Native window handle from Qt/GLFW/etc.
;; On Qt: (cffi:pointer-to-int (widget-win-id widget))
;; On GLFW: glfwGetWin32Window or glfwGetX11Window
;; Pass as :native-window-handle to make-viewer
(with-viewer (v)
  (fit-all v))

;; Display a shape in the 3D view
(with-viewer (v)
  (let ((ctx (ais-create-context v)))
    (ais-display ctx (make-box 10 20 30))
    (show-trihedron ctx v :corner :lower-left)
    (fit-all v)))
```

### Run the test suite

```lisp
(cl-occt::run-tests)
;; or
(asdf:test-system :cl-occt)
```

### Read a STEP file

```lisp
(read-step "existing-model.step")
```

### Read/write colored assemblies

```lisp
;; Read a multi-part STEP file preserving colors and hierarchy
(let ((assy (read-step-assembly "colored-assembly.step")))
  ;; Inspect parts
  (dolist (part (assembly-children assy))
    (format t "Part: ~A, Color: ~A~%"
            (assembly-name part)
            (assembly-color part))))

;; Create and write a colored assembly
(let* ((red-box (make-part (make-box 10 20 30)
                           :name "red-box"
                           :color '(:generic 1.0 0.0 0.0 1.0)))
       (blue-cyl (make-part (make-cylinder 5 20)
                            :name "blue-cyl"
                            :color '(:generic 0.0 0.0 1.0 1.0)
                            :location #(1 0 0 0 0 1 0 0 0 0 1 0 15 0 0 1)))
       (assy (make-assembly :name "demo"
                            :children (list red-box blue-cyl))))
  (write-step-assembly assy "demo.step"))
```

## Architecture

Three layers:

```
 ┌──────────────────────────────────────────────────────┐
 │  SBCL + CFFI (viewer CLOS, ais-context, ais-object,  │
 │              ais-display, ais-erase, ais-remove, ...) │
 └──────────────────────┬───────────────────────────────┘
                        ↓
 ┌──────────────────────────────────────────────────────┐
 │  libocctwrap.so (graphic-driver, viewer, view,       │
 │                  neutral-window, fit-all, resize,     │
 │                  ais_* context + shape functions)     │
 └──────────────────────┬───────────────────────────────┘
                        ↓
 ┌──────────────────────────────────────────────────────┐
 │  OCCT shared libs (TKV3d, TKOpenGl, TKService, AIS)  │
 └──────────────────────────────────────────────────────┘
```

- `wrap/occt_wrap.cpp` — 95 `extern "C"` functions wrapping OCCT. No business logic.
- `src/ffi/` — CFFI `defcfun` bindings. Functions prefixed with `%` (e.g. `%make-box`).
- `src/core/` — CLOS `shape`, `geom2d`, `ais-context`, and `ais-object` classes with `tg:finalize` GC, primitives, booleans, compounds, transforms, STEP I/O, STL I/O, 2D geometry, face construction, viewer, AIS display.

Design decisions documented in `openspec/changes/v1-core/design.md`.

## API Reference

See [docs/api-reference.md](docs/api-reference.md) for the complete API reference (function signatures, descriptions, and examples).

## Project structure

```
├── justfile              Build recipes (setup, wrap, start, clean)
├── cl-occt.asd           ASDF system definition
├── wrap/
│   ├── occt_wrap.h       C header (100+ functions)
│   └── occt_wrap.cpp     C wrapper implementation
├── src/
│   ├── package.lisp      Package definitions
│   ├── ffi/
│   │   ├── loader.lisp   Foreign library loading
│   │   └── bindings.lisp CFFI defcfun bindings
│   ├── core/
│   │   ├── shape.lisp    CLOS shape class
│   │   ├── errors.lisp   OCCT error condition
│   │   ├── primitives.lisp make-shape, make-box, make-cylinder, make-cone, make-torus, make-prism, make-revol
│   │   ├── text.lisp      brep-font, ais-text-label, font loading, text shapes, positioning, bounding-box, multi-line, per-glyph metrics, font enumeration, text labels
│   │   ├── geom2d.lisp    geom2d class, make-pnt2d, make-vec2d, make-dir2d, make-line2d, make-circle2d
│   │   ├── faces.lisp     make-edge, make-edge-3d, make-circle-edge, make-circular-arc, make-wire, make-face, make-face-on-plane
│   │   ├── booleans.lisp cut, fuse, common, section
│   │   ├── compounds.lisp make-compound, add-to-compound, compound-shape-p
│   │   ├── transforms.lisp translate, rotate
│   │   ├── assembly.lisp assembly, make-part, make-assembly, predicates
│   │   ├── shape-fix.lisp      ShapeFix wrappers and ShapeAnalysis queries
│   │   ├── shape-rebuild.lisp  ShapeBuild_ReShape, ShapeCustom, ShapeUpgrade
│   │   ├── shape-process.lisp  ShapeProcess pipeline and heal-shape convenience
│   │   ├── io.lisp       write-step, read-step, write-stl, read-stl, read-step-assembly, write-step-assembly
│   │   ├── mass-properties.lisp  gprops, shape-volume, shape-area, shape-center-of-mass, shape-gprops
│   │   ├── shape-analysis.lisp   shape-distance, point-in-solid-p, shape-valid-p, shape-check, intersect-curve-shape
│   │   ├── topology.lisp         map-shape-subshapes, dump-shape, edge->curve, face->surface, make-vertex, make-polygon
│   │   ├── fillet.lisp           fillet-edge, fillet-edges, fillet-edge-variable, fillet-wire-corner, fillet-wire-all-corners
│   │   ├── chamfer.lisp          chamfer-edge, chamfer-edges, chamfer-edge-asymmetric, chamfer-edge-on-face
│   │   ├── blend.lisp            blend-faces, make-blend
│   │   ├── sweep.lisp            sweep-profile, sweep-sections, sweep-with-aux-spine
│   │   ├── loft.lisp             loft-sections
│   │   ├── face-filling.lisp     fill-face, fill-n-sided-face
│   │   ├── shell.lisp            shell-shape (BRepOffsetAPI_MakeThickSolid)
│   │   ├── offset.lisp           offset-shape, offset-wire
│   │   └── draft.lisp            draft-face, make-evolved
│   │   ├── viewer.lisp   viewer class, ais-context/object, trihedron, projection, grid, MSAA/AA
│   │   ├── viewer-colors.lisp     named colors, hex/HLS parsing, color-delta
│   │   ├── viewer-camera.lisp     camera control (eye/target/up, FOV, clip planes, perspective)
│   │   ├── viewer-object-props.lisp  transparency, materials, line width, edges, selection, tessellation
│   │   ├── viewer-lighting.lisp   ambient/directional/positional/spot lights
│   │   ├── viewer-grid.lisp       grid values, offset, GPU shader grid display
│   │   ├── viewer-background.lisp gradient, image, cube-map background
│   │   ├── viewer-rendering.lisp  computed mode, back-face, frustum culling, transparency method
│   │   ├── viewer-text-labels.lisp  text label angle, alignment, display type
│   │   ├── viewer-defaults.lisp   viewer-level defaults (bg, projection, size)
│   │   ├── viewer-drawer.lisp    Prs3d drawer: line/point/text/shading aspect control
│   │   └── viewer-dimensions.lisp  length, angle, diameter, radius dimensions
├── t/
│   └── smoke-tests.lisp  ~305 smoke tests
├── openspec/             OpenSpec change management
└── AGENTS.md             AI agent instructions
```

## Error handling

Invalid operations (nil inputs, degenerate geometry) return `nil` rather than signaling an error.

C-level errors can be inspected:

```lisp
(get-error-message)
```

## License

**cl-occt** — MIT License (see `LICENSE`).

This project uses [Open CASCADE Technology](https://dev.opencascade.org/) v8.0.0,
which is licensed under **LGPL 2.1 with the Open CASCADE Exception v1.0**.
OCCT is dynamically linked via `lib/libocctwrap.so`; end users can relink
with modified OCCT builds. See `NOTICE` for details and attribution of other
dependencies.

The test font bundled in `t/fonts/Cousine-Regular.ttf` is part of the
[Croscore font family](https://github.com/google/fonts/tree/main/apache/croscore)
by Google Inc., licensed under the **SIL Open Font License v1.1**.
See `licenses/COUSINE-FONT-OFL.txt` for the full license text.
