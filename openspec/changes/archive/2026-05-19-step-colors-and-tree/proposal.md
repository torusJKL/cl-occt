## Why

STEP files from other CAD tools routinely contain multiple parts with distinct colors arranged in assembly hierarchies. cl-occt currently collapses everything into a single flat shape, discarding colors, names, and structure. This makes it impossible to round-trip a STEP file (read → inspect → modify properties → write) without data loss.

## What Changes

- **New `assembly` class**: A tree node representing an assembly or part, with slots for shape, name, color, location, and children
- **New C wrapper layer**: ~15 `extern "C"` functions exposing OCCT's XDE (Extended Data Exchange) document API for reading/writing colored assemblies
- **New public API**: `read-step-assembly`, `write-step-assembly`, `make-part`, `make-assembly`, `node-name`, `node-color`, `node-children`, `node-shape`, `node-location` accessors
- **Modified `write-step`**: Switch from `STEPControl_AsIs` to `STEPControl_Assembly` mode, matching the existing spec
- **Build change**: Enable `ApplicationFramework` module (OCAF) in OCCT build; link `TKXDESTEP`, `TKXCAF`, `TKCAF` in C wrapper
- **BREAKING**: `read-step` returns `nil` for multi-root STEP files (use `read-step-assembly` instead)

## Capabilities

### New Capabilities
- `assembly-tree`: Lisp-side tree data model for hierarchical assemblies with named parts, colors, and locations

### Modified Capabilities
- `step-io`: Add requirements for colored multi-part STEP import/export with assembly tree preservation

## Impact

- `justfile` — enable `BUILD_MODULE_ApplicationFramework=ON`, add new link flags; existing OCCT install needs rebuild
- `wrap/occt_wrap.cpp` — add ~15 new functions for XDE document lifecycle, label navigation, attribute read/write
- `wrap/occt_wrap.h` — new function declarations
- `src/ffi/bindings.lisp` — new `defcfun` forms
- `src/core/assembly.lisp` — new file for the `assembly`/`part` classes and API
- `src/core/io.lisp` — add `read-step-assembly` / `write-step-assembly`; update `write-step` to use assembly mode
- `src/package.lisp` — export new symbols
- `t/smoke-tests.lisp` — round-trip tests with colors and assembly structure
- `README.md` — update build instructions, add assembly API docs
