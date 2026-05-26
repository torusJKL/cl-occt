## Context

cl-occt already wraps `BRepAlgoAPI_Fuse`/`Cut`/`Common`/`Section` and `BRepAlgoAPI_BuilderAlgo` (general boolean builder). The next level — `BOPAlgo_*` — provides more granular control. These classes live in `TKBO` and share the same architecture as the existing booleans (history support, parallel processing mode, fuzzy tolerance).

Existing architecture pattern for booleans:
- C wrapper calls the OCCT class, catches `Standard_Failure`, returns shape or null
- CFFI bindings map C functions to `%`-prefixed Lisp functions
- Thin Lisp wrappers handle list-to-C-array conversion and `make-shape` wrapping

## Goals / Non-Goals

**Goals:**
- Wrap `BOPAlgo_Splitter` for partition operations (single tool and multi-tool)
- Wrap `BOPAlgo_MakerVolume` for cavity-filling (create solids from enclosed spaces)
- Wrap `BOPAlgo_CellsBuilder` for selective fragment extraction from boolean results
- Wrap `BOPAlgo_ArgumentAnalyzer` for boolean failure diagnostics
- Wrap `BOPAlgo_MakeConnected` and `BOPAlgo_MakePeriodic`

**Non-Goals:**
- No change to existing fuse/cut/common/section APIs
- No OCAF integration (history tracking for parametric workflows — that's ocaf-parametric-foundation)
- No viewer changes
- No gp_Trsf or axis placement wrappers

## Decisions

### 1. Splitter follows existing shape-list pattern
`BOPAlgo_Splitter` accepts a shape and a set of tools. The C signature: `split_shape(shape, tools_array, tools_count)` returning a compound.

### 2. MakerVolume returns compound
`BOPAlgo_MakerVolume` can produce multiple volumes. The C wrapper returns them as a compound.

### 3. CellsBuilder uses index-based selection
CellsBuilder performs a boolean between arguments, then lets the user select which "cells" (fragments) to keep. The C signature: `cells_builder(shapes, num_shapes, operation, selection, sel_count)` where `selection` is an array of shape indices. NULL selects all.

### 4. ArgumentAnalyzer returns diagnostic strings
The analyzer checks for self-intersections, small edges, invalid tolerances, etc. Returns a C string describing issues, NULL if clean.

### 5. File layout

| What | Where |
|------|-------|
| C BOPAlgo splitter | `wrap/occt_wrap_operations.cpp` (extend) |
| C BOPAlgo maker-volume | `wrap/occt_wrap_operations.cpp` |
| C BOPAlgo cells-builder | `wrap/occt_wrap_operations.cpp` |
| C BOPAlgo utilities | New `wrap/occt_wrap_bopalgo_utils.cpp` |
| CFFI bindings | `src/ffi/bindings-features.lisp` (extend) |
| Core splitter | `src/core/bop-splitter.lisp` (new) |
| Core volume + cells | `src/core/bop-volume.lisp` (new) |
| Core utilities | `src/core/bop-utilities.lisp` (new) |

### 6. API surface

Each C function has a corresponding thin Lisp wrapper that handles list↔C-array conversion and `make-shape` wrapping:

| C function | Lisp wrapper |
|---|---|
| `split_shape(shape, tools[], n)` | `(split-shape shape tools)` — tools is a shape or list |
| `make_volume(shapes[], n)` | `(make-volume (list s1 s2 ...))` |
| `cells_builder(shapes[], n, op, sel, sel_n)` | `(cells-builder shapes operation &optional selection)` |
| `argument_analyzer(shapes[], n)` | `(boolean-argument-analyzer (list s1 s2 ...))` → string or nil |
| `make_connected_shapes(shapes[], n)` | `(make-connected (list s1 s2 ...))` |
| `make_shape_periodic(shape, dx, dy, dz)` | `(make-periodic shape dx dy dz)` |

### 7. Tests

| Test file | Contents |
|---|---|
| `t/bop-tests.lisp` | 14 tests: split-by-plane, split-multi, nil split; make-volume-two-shells, nil; cells-builder-all, with-selection, nil; argument-analyzer-valid, nil; make-connected-two-boxes, nil; make-periodic-box-along-x, nil |

### 8. Build verification

576 core tests pass (562 existing + 14 new), 0 failures. `just wrap` builds cleanly with zero warnings.

## Risks / Trade-offs

- **CellsBuilder is complex.** The cell selection model requires understanding the boolean result decomposition. The initial API restricts to common selection patterns; advanced users can extend later.
- **BOPAlgo operations are slower than BRepAlgoAPI for simple cases.** Splitter, MakerVolume, and CellsBuilder do full BOP computation. For simple fuse/cut the existing functions are preferred.
- **MakePeriodic only works on specific shape types.** The function will return NULL for shapes that cannot be made periodic.
