# cl-occt — Common Lisp OCCT Library

A Common Lisp library wrapping [OCCT 8.0](https://dev.opencascade.org/) for parametric 3D CAD geometry.
Provides CFFI bindings, a CLOS shape wrapper with GC, primitives, booleans, transforms, STEP I/O,
a reactive DAG engine, and a parametric DSL (`defmodel`, `param`, `model-ref`).

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

This configures a minimal OCCT build:
- Shared libraries only
- No Visualization (TKV3d, TKOpenGl)
- No ApplicationFramework (TKCAF)
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
              "result.step"))
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

## Architecture

Three layers:

```
 SBCL + CFFI  →  libocctwrap.so  →  OCCT shared libs
```

- `wrap/occt_wrap.cpp` — 31 `extern "C"` functions wrapping OCCT. No business logic.
- `src/ffi/` — CFFI `defcfun` bindings. Functions prefixed with `%` (e.g. `%make-box`).
- `src/core/` — CLOS `shape` and `geom2d` classes with `tg:finalize` GC, primitives, booleans, transforms, STEP I/O, 2D geometry, face construction.
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

### Parametric DSL

| Form | Description |
|------|-------------|
| `(defmodel name (keys) body...)` | Define a parametric model |
| `(param key)` | Read parameter (local then global) |
| `(model-ref name)` | Reference another model's cached result |
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

### Introspection

## Project structure

```
├── justfile              Build recipes (setup, wrap, start, clean)
├── cl-occt.asd           ASDF system definition
├── wrap/
│   ├── occt_wrap.h       C header (31 functions)
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
│   │   ├── transforms.lisp translate, rotate
│   │   ├── io.lisp       write-step, read-step
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
│   └── smoke-tests.lisp  55 smoke tests
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
