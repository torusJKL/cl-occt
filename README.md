# cl-occt — Common Lisp OCCT Library

A Common Lisp library wrapping [OCCT 8.0](https://dev.opencascade.org/) for parametric 3D CAD geometry.
Provides CFFI bindings, a CLOS shape wrapper with GC, primitives, booleans, transforms, STEP I/O, STL I/O,
a reactive DAG engine, a parametric DSL (`defmodel`, `param`, `model-ref`), a 3D viewer, and AIS display.

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

- `wrap/occt_wrap.cpp` — 86 `extern "C"` functions wrapping OCCT. No business logic.
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

### Rendering

| Function | Description |
|----------|-------------|
| `(set-msaa view samples)` | Set MSAA sample count (0, 2, 4, 8) |
| `(msaa view)` | Get current MSAA sample count |
| `(set-antialiasing view bool)` | Enable/disable anti-aliasing |
| `(antialiasing-p view)` | Check if anti-aliasing is enabled |
| `(invalidate-view view)` | Request view redraw after property changes |

### Grid

| Function | Description |
|----------|-------------|
| `(activate-grid viewer grid-type draw-mode)` | Show grid (`:rectangular`/`:circular`, `:lines`/`:points`) |
| `(deactivate-grid viewer)` | Hide grid |

### Introspection

## Project structure

```
├── justfile              Build recipes (setup, wrap, start, clean)
├── cl-occt.asd           ASDF system definition
├── wrap/
│   ├── occt_wrap.h       C header (81 functions)
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
│   └── smoke-tests.lisp  ~121 smoke tests
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
