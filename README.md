# cl-occt — Common Lisp OCCT Library

A Common Lisp library wrapping [OCCT 8.0](https://dev.opencascade.org/) for 3D CAD geometry.
Provides CFFI bindings, a CLOS shape wrapper with GC, primitives, booleans, transforms, STEP I/O, STL I/O,
a full 3D viewer with object display, styling, camera control, and a trihedron orientation aid.

This is a **library**, not an application. Use it to build CAD tools, scripts, or GUIs in SBCL.

Source repository: [github.com/torusJKL/cl-occt](https://github.com/torusJKL/cl-occt)

## Prerequisites

### Ubuntu 26.04 / Debian

```sh
sudo apt install sbcl curl build-essential cmake libc6 librapidjson-dev
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
