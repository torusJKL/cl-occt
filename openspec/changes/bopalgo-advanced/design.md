## Context

cl-occt already wraps `BRepAlgoAPI_Fuse`/`Cut`/`Common`/`Section` and `BRepAlgoAPI_BuilderAlgo` (general boolean builder). The next level — `BOPAlgo_*` — provides more granular control. These classes live in `TKBO` and share the same architecture as the existing booleans (history support, parallel processing mode, fuzzy tolerance).

Existing architecture pattern for booleans:
- C wrapper calls the OCCT class, catches `Standard_Failure`, returns shape or null
- Core wrappers follow `(when (null shape) (return-from ... nil))` pattern
- All operations accept shape objects and return shape objects

## Goals / Non-Goals

**Goals:**
- Wrap `BOPAlgo_Splitter` for partition operations (single tool and multi-tool)
- Wrap `BOPAlgo_MakerVolume` for cavity-filling (create solids from enclosed spaces)
- Wrap `BOPAlgo_CellsBuilder` for selective fragment extraction from boolean results
- Wrap `BOPAlgo_ArgumentAnalyzer` for boolean failure diagnostics
- Wrap `BOPAlgo_MakeConnected` and `BOPAlgo_MakePeriodic`
- Update api-reference.md with all new operations

**Non-Goals:**
- No change to existing fuse/cut/common/section APIs
- No OCAF integration (history tracking for parametric workflows — that's ocaf-parametric-foundation)
- No viewer changes
- No gp_Trsf or axis placement wrappers

## Decisions

### 1. Splitter follows existing shape-list pattern
`BOPAlgo_Splitter` accepts a shape and a set of tools. The C signature: `split_shape(shape, tools_array, tools_count)` returning a compound. The Lisp wrapper accepts a single shape or a list of shapes.

### 2. MakerVolume returns sequential list
`BOPAlgo_MakerVolume` can produce multiple volumes. The C wrapper returns them as a compound; the Lisp wrapper extracts individual shapes. The user gets `(list volume1 volume2 ...)`.

### 3. CellsBuilder uses operation keyword + selection spec
CellsBuilder is more complex: it performs a boolean between arguments, then lets the user select which "cells" (fragments) to keep. The Lisp API: `(cells-builder shapes operation &key select)` where `select` is `:all`, `:in`, `:out`, or a list of cell indices.

### 4. ArgumentAnalyzer returns diagnostic strings
The analyzer checks for self-intersections, small edges, invalid tolerances, etc. Returns a list of strings describing issues, nil if clean.

### 5. File layout

| What | Where |
|------|-------|
| C BOPAlgo splitter | `wrap/occt_wrap_operations.cpp` (extend) |
| C BOPAlgo maker-volume | `wrap/occt_wrap_operations.cpp` |
| C BOPAlgo cells-builder | `wrap/occt_wrap_operations.cpp` |
| C BOPAlgo utilities | New `wrap/occt_wrap_bopalgo_utils.cpp` |
| CFFI bindings | `src/ffi/bindings-features.lisp` (extend) |
| Core splitter | New `src/core/bop-splitter.lisp` |
| Core maker-volume + cells-builder | New `src/core/bop-volume.lisp` |
| Core utilities | New `src/core/bop-utilities.lisp` |

### 6. API surface (preliminary)

```lisp
(split-shape shape tool)                                   → compound
(split-shape shape (list tool1 tool2))                      → compound
(make-volume (list shell1 shell2 ...))                      → list of volumes
(cells-builder shapes operation &key select)                → compound
(boolean-argument-analyzer (list shape1 shape2 ...))        → list of strings or nil
(make-connected (list shape1 shape2 ...))                    → shape
(make-periodic shape dx dy dz)                               → shape
```

## Risks / Trade-offs

- **CellsBuilder is complex.** The cell selection model requires understanding the boolean result decomposition. The initial API restricts to common selection patterns; advanced users can extend later.
- **BOPAlgo operations are slower than BRepAlgoAPI for simple cases.** Splitter, MakerVolume, and CellsBuilder do full BOP computation. For simple fuse/cut the existing functions are preferred.
- **MakePeriodic only works on specific shape types.** The function will return nil for shapes that cannot be made periodic, with no error message set by OCCT.
