## Why

cl-occt lacks bindings for several important OCCT algorithms: sewing (stitching surfaces), defeaturing (removing features from shapes), shape validity checking, hidden line removal (HLR), advanced shelling via MakeThickSolid, and shape type conversion (to revolution/swept surfaces). These capabilities are needed for real-world CAD workflows — repair, analysis, drafting, and model simplification.

## What Changes

Add CFFI bindings and CLOS wrappers for 9 OCCT functions across 6 capability areas:

- **Sewing**: `BRepBuilderAPI_Sewing` — stitch adjacent faces/shells into a single watertight shape
- **Defeaturing**: `BRepAlgoAPI_Defeaturing` — remove selected features (holes, protrusions, fillets, etc.)
- **Shape Check / Builder Algo**: `BRepAlgoAPI_Check`, `BRepAlgoAPI_BuilderAlgo` — validity checks and generalized boolean builder
- **Hidden Line Removal**: `HLRBRep_Algo`, `HLRBRep_HLRToShape` — project 3D edges to 2D with visibility classification
- **Thick Solid**: `BRepOffsetAPI_MakeThickSolid` — shell a solid by offsetting faces
- **Shape Conversion**: `ShapeCustom_ConvertToRevolution`, `ShapeCustom_SweptToElementary` — convert analytic surface types
- **API Reference**: Update `api-reference.md` with all new function signatures for AI agent consumption

## Capabilities

### New Capabilities

- `sewing`: BRepBuilderAPI_Sewing — stitch adjacent faces/shells into a single watertight shape with configurable tolerance
- `defeaturing`: BRepAlgoAPI_Defeaturing — remove features from a shape by specifying faces to remove
- `shape-check`: BRepAlgoAPI_Check, BRepAlgoAPI_BuilderAlgo — validate shape validity and build boolean operations programmatically
- `hlr`: HLRBRep_Algo, HLRBRep_HLRToShape — compute hidden line removal projections and extract visible/hidden edge results
- `shape-conversion`: ShapeCustom_ConvertToRevolution, ShapeCustom_SweptToElementary — convert shapes between analytic representations
- `api-reference-docs`: Update api-reference.md with documentation of all new bindings

### Modified Capabilities

- `thicken-shell`: Extend with BRepOffsetAPI_MakeThickSolid for shelling solids by offsetting selected faces (removing faces to create an opening)

## Impact

- **C wrapper** (`wrap/occt_wrap.h|cpp`): ~9 new extern "C" functions
- **CFFI layer** (`src/ffi/`): ~9 new `defcfun` bindings (`%`-prefixed)
- **Core layer** (`src/core/`): New CLOS wrapper functions for each capability, with `tg:finalize` GC and nil-on-null-pointer semantics
- **Tests** (`tests/`): New test files for each capability area
- **Docs** (`doc/api-reference.md`): Updated with all new functions
