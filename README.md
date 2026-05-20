# cl-occt — Common Lisp OCCT Library

A Common Lisp library wrapping [OCCT 8.0](https://dev.opencascade.org/) for parametric 3D CAD geometry.
Provides CFFI bindings, a CLOS shape wrapper with GC, primitives, booleans, transforms, STEP I/O, STL I/O,
a reactive DAG engine, a parametric DSL (`defmodel`, `param`, `model-ref`), a full 3D viewer with object display,
styling, camera control, and a trihedron orientation aid.

This is a **library**, not an application. Use it to build CAD tools, scripts, or GUIs in SBCL.

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

### Direct geometry (no DAG)

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

### Parametric DAG

```lisp
(in-package :cl-occt)

(set-params! :w 30 :d 20 :h 10 :r 8)

(defmodel my-box (:w :d :h)
  (make-box (param :w) (param :d) (param :h)))

(defmodel holey-box (:r :w :d :h)
  (let ((box (model-ref 'my-box))
        (sphere (make-sphere (param :r))))
    (cut box (translate sphere
                        (/ (param :w) 2)
                        (/ (param :d) 2)
                        (/ (param :h) 2)))))

(write-step (model-ref 'holey-box) "holey.step")

(set-param! :r 12)
(write-step (model-ref 'holey-box) "holey-bigger-hole.step")
```

### Local parameter override

```lisp
(my-box :w 100 :d 200 :h 300)  ; uses local params, doesn't touch globals
(param :w)                       ; => 30, global unchanged
```

### Model metadata (color, name, layer)

Models carry optional metadata that round-trips through STEP export.

```lisp
(set-params! :w 30 :d 20 :h 10 :col '(:generic 1.0 0.0 0.0 1.0))

;; Static metadata
(defmodel red-box (:w :d :h)
  (:color (:generic 1.0 0.0 0.0 1.0))
  (:name "Red Box")
  (:layer "mechanical")
  (make-box (param :w) (param :d) (param :h)))

;; Parametric metadata — color from a parameter
(defmodel colored-box (:w :d :h :col)
  (:color (param :col))
  (make-box (param :w) (param :d) (param :h)))

;; Read metadata
(model-color 'red-box)        ; => (:generic 1.0 0.0 0.0 1.0)
(model-display-name 'red-box) ; => "Red Box"
(model-layer 'red-box)        ; => "mechanical"

;; Export all DAG models with metadata to STEP
(write-dag-models-to-step "models.step")

;; Import a STEP assembly into the DAG registry
(read-step-into-dag "models.step")
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
- `src/dag/` — Reactive DAG: parameter store, model registry, topological sort, dirty propagation.
- `src/dsl/` — `defmodel`, `param`, `model-ref`, `set-param!`, `with-params` macros.

Design decisions documented in `openspec/changes/v1-core/design.md`.

## API Reference

### Primitives

| Function | Description |
|----------|-------------|
| `(make-box dx dy dz)` | Rectangular box |
| `(make-cylinder radius height)` | Cylinder |
| `(make-sphere radius)` | Sphere |
| `(make-cone r1 r2 height)` | Cone (r1=bottom, r2=top radius) |
| `(make-torus major-radius minor-radius)` | Torus (donut) |
| `(make-prism shape dx dy dz)` | Linear extrusion of a shape along a vector |
| `(make-revol shape ax ay az deg)` | Rotational extrusion of a shape around an axis |

Returns `nil` on invalid dimensions or degenerate parameters.

### Booleans

| Function | Description |
|----------|-------------|
| `(cut a &rest others)` | Subtract shapes, left-to-right chaining |
| `(fuse a &rest others)` | Union shapes |
| `(common a &rest others)` | Intersect shapes |
| `(section a &rest others)` | Intersection curves/edges between shapes |

All propagate nil: if any argument is nil, result is nil.

### Transforms

| Function | Description |
|----------|-------------|
| `(translate shape dx dy dz)` | Move shape by vector |
| `(rotate shape ax ay az deg)` | Rotate around axis by degrees |

Original shape is unchanged. Nil in → nil out.

### STEP I/O

| Function | Description |
|----------|-------------|
| `(write-step shape path)` | Export to STEP AP203 file |
| `(read-step path)` | Import from STEP file |
| `(write-dag-models-to-step path)` | Export all DAG models with metadata to STEP |
| `(read-step-into-dag path)` | Import STEP assembly into DAG registry as models |

### STL I/O

| Function | Description |
|----------|-------------|
| `(write-stl shape path &key deflection)` | Export to binary STL file (deflection=0.1) |
| `(read-stl path)` | Import from STL file |

### Compounds

| Function | Description |
|----------|-------------|
| `(make-compound list-of-shapes)` | Collect shapes into a `TopoDS_Compound` for multi-shape I/O |
| `(add-to-compound compound shape)` | Add a shape to an existing compound; returns updated compound |
| `(compound-shape-p obj)` | Predicate: returns `t` for compound shapes, `nil` otherwise |

Nil shapes in the input list are silently skipped. If all shapes are nil or the list is empty, returns nil. Pass the result directly to `(write-stl ...)` to export all sub-shapes as a single STL file.

```lisp
;; Export multiple shapes as one STL
(let ((c (make-compound (list (make-box 30 20 10)
                               (translate (make-sphere 8) 15 10 5)))))
  (write-stl c "assembly.stl" :deflection 0.05))

;; Incremental building
(let ((c (make-compound (list (make-box 10 20 30)))))
  (add-to-compound c (make-cylinder 5 20))
  (write-stl c "parts.stl"))
```

### Assembly Tree (Colored STEP I/O)

| Function | Description |
|----------|-------------|
| `(make-part shape &key name color location)` | Create a leaf node with geometry and optional metadata |
| `(make-assembly &key name children)` | Create a branch node with children and optional name |
| `(assembly-shape node)` | Get the shape of a node (nil for pure assemblies) |
| `(assembly-name node)` | Get the name string (nil if unset) |
| `(assembly-color node)` | Get color plist `(:type r g b a)` or nil |
| `(assembly-location node)` | Get 4×4 transformation matrix or nil |
| `(assembly-children node)` | Get list of child nodes (nil for leaves) |
| `(setf (assembly-name node) val)` | Set the name |
| `(setf (assembly-color node) val)` | Set the color |
| `(setf (assembly-children node) val)` | Set the children list |
| `(assembly-leaf-p node)` | True if node has no children |
| `(assembly-branch-p node)` | True if node has children |
| `(read-step-assembly path)` | Read a STEP file with colors and assembly structure |
| `(write-step-assembly assembly path)` | Write an assembly tree to STEP preserving colors |

Colors are plists: `(:generic r g b a)`, `(:surf r g b a)`, `(:curv r g b a)` with components in [0,1]. Locations are row-major 4×4 matrices as `#(16 double-floats)` or nil for identity.

### Parametric DSL

| Form | Description |
|------|-------------|
| `(defmodel name (keys) body...)` | Define a parametric model. Body may include `(:color ...)`, `(:name "...")`, `(:layer "...")` metadata clauses before shape forms |
| `(param key)` | Read parameter (local then global) |
| `(model-ref name)` | Reference another model's cached result |
| `(model-color name)` | Get model's color plist `(:type r g b a)` or nil |
| `(model-display-name name)` | Get model's display name string or nil |
| `(model-layer name)` | Get model's layer string or nil |
| `(set-param! key value)` | Set global parameter, trigger propagation |
| `(set-params! &rest kv)` | Batch-set parameters, single propagation pass |
| `(with-params (&rest kv) body...)` | Local parameter scope |
| `(name :key val ...)` | Call model function with local overrides |

### 2D Geometry (Geom2d)

| Function | Description |
|----------|-------------|
| `(make-pnt2d x y)` | 2D point |
| `(make-vec2d x y)` | 2D vector |
| `(make-dir2d x y)` | 2D direction (unit vector; nil on zero input) |
| `(make-line2d x y dx dy)` | 2D infinite line through point with direction |
| `(make-circle2d x y radius)` | 2D circle curve (nil on non-positive radius) |

Returns `geom2d` objects (distinct from `shape`), GC-managed via `tg:finalize`.

### Face Construction

| Function | Description |
|----------|-------------|
| `(make-edge x1 y1 x2 y2)` | Linear edge between two 2D points |
| `(make-edge-3d x1 y1 z1 x2 y2 z2)` | Linear edge between two 3D points |
| `(make-circle-edge x y radius)` | Full circle edge from 2D center and radius |
| `(make-circular-arc x1 y1 x2 y2 x3 y3)` | Circular arc through three 2D points |
| `(make-wire &rest edges)` | Connect edges into a wire |
| `(make-face wire)` | Planar face from a closed wire (auto-detects plane) |
| `(make-face-on-plane wire ox oy oz nx ny nz)` | Planar face on an explicit plane |

Returns `nil` on invalid input. Use `make-wire` → `make-face` → `make-prism`/`make-revol` to create solids from 2D profiles.

### Viewer

| Function | Description |
|----------|-------------|
| `(make-viewer)` | Create a 3D viewport |
| `(free-viewer v)` | Explicitly destroy a viewer |
| `(with-viewer (v) body...)` | Macro: auto-create and auto-free viewer |
| `(fit-all v)` | Zoom to fit all displayed objects |
| `(must-be-resized v)` | Call after window resize |

### Display

| Function | Description |
|----------|-------------|
| `(ais-create-context viewer)` | Create an AIS interactive context from a viewer |
| `(ais-free-context ctx)` | Destroy an AIS context |
| `(ais-create-shape shape)` | Create an interactive shape object from a geometry shape |
| `(ais-display ctx shape-or-obj &key update)` | Display a shape or ais-object; returns ais-object |
| `(ais-erase ctx obj &key update)` | Hide an object (remains in context) |
| `(ais-remove ctx obj &key update)` | Permanently remove an object from context |
| `(ais-remove-all ctx &key update)` | Remove all objects from context |
| `(ais-displayed-p ctx obj)` | Check if an object is currently displayed |
| `(ais-free obj)` | Free an ais-object's C handle |

### Styling

| Function | Description |
|----------|-------------|
| `(set-background viewer r g b)` | Set viewer background color (RGB in [0,1]) |
| `(ais-set-color ctx obj color)` | Set object color as `(r g b)` list |
| `(ais-unset-color ctx obj)` | Revert object to default color |
| `(ais-set-display-mode ctx obj mode)` | Set display mode (`:wireframe` or `:shaded`) |

### Camera

| Function | Description |
|----------|-------------|
| `(set-view-projection view orientation)` | Set camera orientation (`:iso-pers`, `:z-pos`, `:x-pos`, etc.) |
| `(set-camera view &key eye target up)` | Position camera with optional eye, target (look-at), and up vectors. Each is `(x y z)`. Partial calls update only the specified values. |
| `(set-perspective view bool)` | Switch between perspective (`t`) and orthographic (`nil`) projection. |
| `(perspective-p view)` | Return `t` if view uses perspective projection, `nil` for orthographic. |
| `(set-fov view degrees)` | Set vertical field of view in degrees. |
| `(set-clip-planes view &key near far)` | Set Z-clipping near and far plane distances. |
| `(pan-camera view dx dy)` | Pan (shift) the view by screen-space pixel amounts. |
| `(zoom-camera view factor)` | Set camera zoom scale factor. |
| `(rotate-camera view ax ay az)` | Rotate camera by angles in radians around X, Y, Z axes. |
| `(reset-view view)` | Restore default view orientation and mapping. |
| `(fit-all view &optional shape-or-obj)` | Zoom to fit all displayed objects, or a specific shape/ais-object when provided. |

### Rendering

| Function | Description |
|----------|-------------|
| `(set-msaa view samples)` | Set MSAA sample count (0, 2, 4, 8) |
| `(msaa view)` | Get current MSAA sample count |
| `(set-antialiasing view bool)` | Enable/disable anti-aliasing |
| `(antialiasing-p view)` | Check if anti-aliasing is enabled |
| `(invalidate-view view)` | Request view redraw after property changes |

### Object Properties

| Function | Description |
|----------|-------------|
| `(ais-set-transparency ctx obj value)` | Set object transparency (0.0 = opaque, 1.0 = fully transparent) |
| `(ais-set-material ctx obj preset)` | Set material preset by keyword (`:gold`, `:plastic`, `:glass`, `:chrome`, `:copper`, etc.) |
| `(material-preset-list)` | Return list of available material preset keywords |
| `(ais-set-line-width ctx obj width)` | Set wireframe/edge line width in pixels |
| `(ais-show-edges ctx obj bool)` | Show/hide edges on shaded display |
| `(ais-set-edge-styling ctx obj &key color width)` | Configure edge appearance (color and width) |
| `(ais-set-selection-mode ctx obj mode)` | Set selection mode (nil = deactivate, 0=shape, 1=face, 2=edge, 3=vertex) |
| `(ais-set-tessellation obj &key quality deviation)` | Set tessellation quality (lower = finer mesh, default 0.1) |

### Lighting

| Function | Description |
|----------|-------------|
| `(make-light type &key color intensity direction)` | Create a light (`:ambient` or `:directional`). `:color` accepts any color format, `:direction` is `(dx dy dz)` for directional lights. |
| `(viewer-light-p obj)` | Predicate for `viewer-light` instances. |
| `(free-light light)` | Free a light's C handle. |
| `(light-type light)` | Return `:ambient` or `:directional`. |
| `(viewer-add-light viewer light)` | Register a light with a viewer. |
| `(viewer-remove-light viewer light)` | Unregister a light. |
| `(viewer-light-on viewer light)` | Enable a registered light. |
| `(viewer-light-off viewer light)` | Disable a registered light. |
| `(viewer-light-active-p viewer light)` | Check if a light is enabled. |
| `(set-light-color light color)` | Change light color (any color format). |
| `(set-light-intensity light v)` | Set light brightness (0.0-1.0). |
| `(set-light-direction light direction)` | Set direction for directional lights. |
| `(set-headlight light bool)` | Attach/detach light from camera. |
| `(set-light-shadows light bool)` | Enable/disable shadow casting (ray-tracing). |
| `(viewer-default-lights viewer)` | Restore default ambient + directional lights. |

### Grid

| Function | Description |
|----------|-------------|
| `(activate-grid viewer grid-type draw-mode)` | Show grid (`:rectangular`/`:circular`, `:lines`/`:points`) |
| `(deactivate-grid viewer)` | Hide grid |
| `(grid-active-p viewer)` | Return `t` if grid is active, `nil` otherwise |

### Background

| Function | Description |
|----------|-------------|
| `(set-gradient-background view &key color1 color2 style)` | Two-color gradient background. `:style` is `:x-pos`, `:x-neg`, `:y-pos`, `:y-neg`, `:z-pos`, or `:z-neg`. |
| `(reset-background view)` | Reset background to solid black. |

### Rendering

| Function | Description |
|----------|-------------|
| `(set-computed-mode view bool)` | Enable/disable ray-traced rendering. |
| `(computed-mode-p view)` | Return `t` if ray-tracing is enabled. |
| `(set-back-face-model view model)` | Set back-face model (`:auto`, `:force`, `:disable`). |
| `(set-frustum-culling view bool)` | Enable/disable frustum culling. |
| `(redraw-view view)` | Force immediate redraw of main and overlay content. |
| `(set-immediate-update view bool)` | Control immediate flush of display changes. |

### Text Labels (Viewer)

| Function | Description |
|----------|-------------|
| `(set-text-label-angle label degrees)` | Rotate a text label by degrees. |
| `(make-text-label ctx text position &key color font height angle)` | Create, configure, and display a text label in one call. |

### Viewer Defaults

| Function | Description |
|----------|-------------|
| `(set-default-background viewer color)` | Set default background color for new views. |
| `(set-default-projection viewer orientation)` | Set default view orientation for new views. |
| `(set-default-view-size viewer size)` | Set default camera distance for new views. |
| `(set-default-view-type viewer type)` | Set default projection type (`:perspective` or `:orthographic`). |

### Trihedron

| Function | Description |
|----------|-------------|
| `(make-trihedron &key origin normal x-direction)` | Create a 3D axis indicator |
| `(set-trihedron-mode obj mode)` | Set datum mode (`:wireframe` or `:shaded`) |
| `(set-trihedron-arrows obj bool)` | Show/hide arrowheads |
| `(set-trihedron-size obj size)` | Set visual size |
| `(set-trihedron-corner obj corner &key x-offset y-offset)` | Pin to screen corner (`:lower-left`, `:upper-right`, etc.) |
| `(set-trihedron-axis-colors obj &key x y z)` | Set per-axis colors (accepts named colors or (r g b) lists; partial update: unspecified axes keep defaults) |
| `(set-trihedron-text-color obj color)` | Set the color of XYZ axis label text |
| `(show-trihedron ctx viewer &key corner size)` | Create, configure, and display a trihedron in one call |

### 3D Text

| Function | Description |
|----------|-------------|
| `(make-brep-font-from-file path size &optional face-id)` | Load a TrueType/OpenType font from a file path. Returns `brep-font` or nil. |
| `(make-brep-font-from-name name size &key aspect)` | Look up a system font by name. `aspect` is `:regular`, `:bold`, `:italic`, or `:bold-italic` (default `:regular`). Returns `brep-font` or nil. |
| `(brep-font-p obj)` | Predicate: returns t for `brep-font` objects, nil otherwise |
| `(make-text-shape font text &key h-align v-align position normal)` | Render text as a flat BRep shape. Supports optional `:position` `(x y z)` and `:normal` `(dx dy dz)` for arbitrary plane placement. Returns a `shape` or nil. |
| `(make-text-shape-3d font text depth &key h-align v-align position normal)` | Render and extrude text. Same position/normal args as `make-text-shape`. |
| `(make-text-shape-on-plane font text &key h-align v-align position normal)` | Convenience — explicit position/normal defaults for plane placement. |
| `(text-bounding-box font text &key h-align v-align)` | Query text extent without rendering. Returns `(values width height)` or nil. |
| `(list-available-fonts)` | Return a list of available system font name strings. |
| `(font-info name)` | Query font information (`:name`, `:key` plist) by name. |
| `(text-glyph-as-shape font codepoint)` | Render a single glyph by Unicode codepoint as a shape. |
| `(text-glyph-as-shape-3d font codepoint depth)` | Render and extrude a single glyph. |
| `(text-font-ascender font)` | Font ascender height above baseline. |
| `(text-font-descender font)` | Font descender depth below baseline. |
| `(text-font-line-spacing font)` | Default line spacing (baseline to baseline). |
| `(text-font-advance-x font c1 c2)` | Horizontal advance between two glyph codepoints (with kerning). |
| `(text-font-advance-y font c1 c2)` | Vertical advance between two glyph codepoints. |
| `(text-font-set-width-scaling font scale)` | Set glyph width scaling factor for subsequent rendering. |
| `(text-font-set-composite-curve-mode font bool)` | Toggle composite BSpline curves for glyph contours. |
| `(make-multi-line-text font text &key h-align v-align position normal line-spacing)` | Render multi-line text (split on `#\Newline`), lines stacked vertically by `line-spacing`. |
| `(make-formatted-text font text &key h-align v-align position normal line-spacing)` | Alias for `make-multi-line-text`. |
| `(make-ais-text-label text &key position color font height)` | Create an interactive 3D text label (`AIS_TextLabel`) for viewer display. Not exported to STL/STEP. |
| `(ais-text-label-p obj)` | Predicate for ais-text-label objects. |
| `(ais-free-text-label label)` | Free an ais-text-label's C handle. |

Font size is in **model units** (e.g., millimeters). To convert from typographic points: `sizeInMeters = 0.0254 * pt / 72.0`.

```lisp
;; From a font file — create flat text
(let* ((font (make-brep-font-from-file "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf" 10.0))
       (flat (make-text-shape font "Hello 3D!")))
  (write-step flat "flat-text.step"))

;; From a font file — create 3D text (one step)
(let* ((font   (make-brep-font-from-file "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf" 10.0))
       (text3d (make-text-shape-3d font "Hello 3D!" 2.0)))
  (write-step text3d "hello-3d.step")
  (write-stl text3d "hello-3d.stl" :deflection 0.05))

;; System font with bold style
(let* ((font   (make-brep-font-from-name "Arial" 12.0 :aspect :bold))
       (text3d (make-text-shape-3d font "Centered" 1.5
                                    :h-align :center :v-align :center)))
  (write-step text3d "centered.step"))

;; Text on a rotated plane (YZ plane in this example)
(let* ((font   (make-brep-font-from-name "Arial" 10.0))
       (rotated (make-text-shape font "Angled" :position '(0 0 0) :normal '(1 0 0))))
  (write-step rotated "angled-text.step"))

;; Multi-line text (lines stacked vertically)
(let* ((font (make-brep-font-from-name "Arial" 10.0))
       (multi (make-multi-line-text font "Line1\nLine2\nLine3")))
  (write-step multi "multiline-text.step"))

;; Bounding box query (useful for layout)
(let* ((font (make-brep-font-from-name "Arial" 10.0)))
  (multiple-value-bind (w h) (text-bounding-box font "Hello")
    (format t "Text is ~,1f × ~,1f model units~%" w h)))

;; List available system fonts
(list-available-fonts)

;; Per-glyph rendering
(let* ((font   (make-brep-font-from-name "Arial" 10.0))
       (glyphA (text-glyph-as-shape font (char-code #\A))))
  (write-step glyphA "glyph-A.step"))

;; Font metrics
(let* ((font (make-brep-font-from-name "Arial" 10.0)))
  (format t "Ascender: ~,2f  Descender: ~,2f  LineSpacing: ~,2f~%"
          (text-font-ascender font)
          (text-font-descender font)
          (text-font-line-spacing font)))

;; Interactive 3D text label (viewer only, not exported)
(with-viewer (v)
  (let* ((ctx   (ais-create-context v))
         (label (make-ais-text-label "My Label" :position '(0 0 0))))
    (ais-display ctx label)
    (fit-all v)))
```

### Interactive 3D Text Labels (Viewer)

| Function | Description |
|----------|-------------|
| `(make-ais-text-label text &key position color font height)` | Create an interactive 3D text label (`AIS_TextLabel`) for viewer display. Not exported to STL/STEP. |
| `(ais-text-label-p obj)` | Predicate for ais-text-label objects. |
| `(ais-free-text-label label)` | Free an ais-text-label's C handle. |

### Color System

| Function | Description |
|----------|-------------|
| `(named-color name)` | Look up a named color by keyword (e.g., `:red`, `:steel-blue`, `:gold`). Returns `(r g b)` or nil. |
| `(named-color-exists-p name)` | Check if a named color exists. |
| `(list-named-colors)` | Return a list of all ~160 named color keywords. |
| `(hex-to-rgb hex)` | Parse `#RRGGBB` or `#RGB` hex string. Returns `(r g b)` or nil. |
| `(normalize-color color)` | Accepts keyword, `(r g b)` list, `#RRGGBB` hex string, or `viewer-color` instance. Returns `(r g b)`. |
| `(make-color &key keyword rgb hls)` | Create a `viewer-color` instance. `:keyword` looks up a named color, `:rgb` takes `(r g b)`, `:hls` takes `(h l s)`. |
| `(viewer-color-p obj)` | Predicate for `viewer-color` instances. |
| `(color-rgb color)` | Get `(r g b)` from any color input type. |
| `(color-r c)` / `(color-g c)` / `(color-b c)` | Red, green, blue components from `viewer-color`. |
| `(color-name c)` | The keyword name of a `viewer-color` (or nil if unnamed). |
| `(color-delta c1 c2)` | Euclidean color difference between two colors (any input types). Returns nil on invalid input. |

Named colors include the standard X11/web color palette (`:alice-blue`, `:bisque`, `:crimson`, `:dark-olive-green`, `:gold`, `:indian-red`, `:khaki`, `:lavender`, `:medium-aquamarine`, `:navy`, `:olive-drab`, `:pale-goldenrod`, `:sienna`, `:tomato`, `:wheat`, etc.) plus numbered variants (`:blue-1`, `:gray-50`, `:orange-1`) and grey spellings (`:grey`, `:dark-grey`).

### Introspection

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
│   │   ├── io.lisp       write-step, read-step, write-stl, read-stl, read-step-assembly, write-step-assembly
│   │   ├── viewer.lisp   viewer class, make-viewer, free-viewer, fit-all, must-be-resized, with-viewer, ais-context, ais-object, ais-display, ais-erase, ais-remove
│   │   └── api.lisp      set-param!, set-params!
│   ├── dag/
│   │   ├── params.lisp   *params* global parameter store
│   │   ├── registry.lisp *model-registry* hash table
│   │   ├── model.lisp    Model struct definition
│   │   └── propagation.lisp Topological sort, dirty propagation
│   └── dsl/
│       ├── param.lisp    param function, with-params macro
│       ├── defmodel.lisp defmodel macro, model-ref function
│       └── api.lisp      help function
├── t/
│   └── smoke-tests.lisp  ~165 smoke tests
├── openspec/             OpenSpec change management
└── AGENTS.md             AI agent instructions
```

## Error handling

Invalid operations (nil inputs, degenerate geometry) return `nil` rather than
signaling an error. In the DAG, nil propagates to dependents.

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
