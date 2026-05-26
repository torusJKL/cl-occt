## Why

The existing boolean operations (fuse, cut, common, section) cover basic CSG but miss several essential operations that real CAD workflows demand: splitting a shape by a tool, creating solids from enclosed cavities, selecting arbitrary cells from boolean results, analyzing boolean failures, and creating periodic/connected geometry. These are commonly needed for mold design, FEM prep, packaging studies, and assembly validation.

## What Changes

- **Splitter**: `BOPAlgo_Splitter` — split a shape by another shape or set of shapes
- **MakerVolume**: `BOPAlgo_MakerVolume` — create solids from enclosed cavities between shapes
- **CellsBuilder**: `BOPAlgo_CellsBuilder` — selectively build results from boolean fragments
- **ArgumentAnalyzer**: `BOPAlgo_ArgumentAnalyzer` — debug why a boolean operation fails
- **MakeConnected**: `BOPAlgo_MakeConnected` — connect shapes along faces to form a watertight result
- **MakePeriodic**: `BOPAlgo_MakePeriodic` — make a shape periodic along an axis

## Capabilities

### New Capabilities

- `bop-splitter`: Split a shape by another shape (partition into pieces)
- `bop-make-volume`: Create solids from cavities between shapes
- `bop-cells-builder`: Selectively build from boolean result cells
- `bop-utilities`: Argument analysis (debug booleans), MakeConnected, MakePeriodic

### Modified Capabilities

(none — these are independent additions to the booleans area)

## Impact

- **C wrapper** (`wrap/`): ~6 new `extern "C"` functions for the 6 BOPAlgo operations
- **CFFI layer** (`src/ffi/`): ~6 new `defcfun` bindings
- **Core layer** (`src/core/`): New `bop-splitter.lisp`, `bop-volume.lisp`, `bop-utilities.lisp`
- **Tests** (`t/`): New `bop-tests.lisp` — 14 tests covering all 6 operations
