## Context

cl-occt currently wraps ~200 OCCT functions. The user asked for bindings for 9 specific OCCT functions. Investigation reveals that **`BRepOffsetAPI_MakeThickSolid` is already fully bound** as `shell-shape` (C wrapper `shell_shape`, CFFI `%shell-shape`, core `shell-shape`, documented in api-reference.md). The remaining 8 functions require new bindings.

Existing architecture:
- **C wrapper** (`wrap/occt_wrap.h|cpp`): `extern "C"` functions with `try/catch(Standard_Failure)`, thread-local error state
- **CFFI** (`src/ffi/bindings.lisp`): `defcfun` with `%`-prefixed names
- **Core** (`src/core/`): CLOS wrappers with `make-shape` factory, `tg:finalize` GC, nil-on-null propagation
- **Tests** (`tests/`): Custom `deftest` framework with `assert-true`/`assert-shape`/`assert-nil`
- **Docs** (`docs/api-reference.md`): Per-section markdown tables with signature and example

## Goals / Non-Goals

**Goals:**
- Bind all 8 OCCT functions with C wrappers, CFFI bindings, CLOS wrappers, tests, and documentation

| # | OCCT Class | C function | Lisp function | Capability |
|---|-----------|-----------|--------------|------------|
| 1 | `BRepBuilderAPI_Sewing` | `sew_shapes` | `sew-shapes` | sewing |
| 2 | `BRepAlgoAPI_Defeaturing` | `defeature_shape` | `defeature-shape` | defeaturing |
| 3 | `BRepAlgoAPI_Check` | `check_shape_validity` | `check-shape-validity` | shape-check |
| 4 | `BRepAlgoAPI_BuilderAlgo` | `boolean_builder` | `boolean-builder` | shape-check |
| 5 | `HLRBRep_Algo` | `hlr_project` | `hlr-project` | hlr |
| 6 | `HLRBRep_HLRToShape` | `hlr_extract_shapes` | `hlr-extract-shapes` | hlr |
| 7 | `ShapeCustom_ConvertToRevolution` | `convert_to_revolution` | `convert-to-revolution` | shape-conversion |
| 8 | `ShapeCustom_SweptToElementary` | `convert_swept_to_elementary` | `convert-swept-to-elementary` | shape-conversion |

**Non-Goals:**
- MakeThickSolid is already bound; no changes needed there
- No viewer/rendering changes
- No changes to the build system or project structure
- No BREAKING changes to existing APIs

## Decisions

### 1. Group HLR into a single composite C function
`HLRBRep_Algo` and `HLRBRep_HLRToShape` are always used together (run algo, then extract). The C wrapper will expose a single `hlr_project` function that runs both, returning a Lisp-friendly plist of `(:visible-visible ... :visible-hidden ... :hidden-visible ... :hidden-hidden ...)`. This avoids exposing the intermediate `HLRBRep_Algo` state to the user.

### 2. Defeaturing via face selection
`BRepAlgoAPI_Defeaturing` removes features by passing a list of faces to remove. The C function signature follows the existing `shell_shape` pattern: `occt_shape* faces, int num_faces`. This is consistent with the codebase.

### 3. BuilderAlgo as general boolean
`BRepAlgoAPI_BuilderAlgo` is a low-level builder for boolean operations. The lisp wrapper will expose a higher-level interface (`boolean-builder shape1 shape2 operation`) where `operation` is `:cut`, `:fuse`, `:common`, or `:section`. This follows the existing boolean pattern but gives access to more granular control.

### 4. Sewing tolerance exposed
`BRepBuilderAPI_Sewing` has a tolerance parameter. The C wrapper will accept `tolerance` and `allow_non_manifold` flag, exposing what matters for CAD repair workflows.

### 5. ShapeCustom functions return new shape or nil
Both ShapeCustom functions follow the same pattern: take a shape, try to convert it, return a new shape or null. Simple wrappers with no extra parameters.

### 6. File organization per existing convention
- New C functions appended at end of `occt_wrap.cpp` and declared in `occt_wrap.h`
- CFFI bindings appended at end of `src/ffi/bindings.lisp`
- Each new capability gets its own core file: `src/core/sewing.lisp`, `src/core/defeaturing.lisp`, `src/core/shape-check.lisp`, `src/core/hlr.lisp`, `src/core/shape-conversion.lisp`
- Each capability gets its own test section added to tests files

## Risks / Trade-offs

- **HLR is projection-based**: HLR results are 2D edges projected from 3D. They are `TopoDS_Edge` but their 3D curves may not exist. Returning them as shapes is correct but consumers need to extract 2D curves via `edge->curve` and check for nil. The user-facing documentation will note this.
- **Defeaturing can produce invalid shapes**: If the removed faces don't form a valid removal region, the result is nil. Input validation will be minimal (null checks) — OCCT's error handling via try/catch is sufficient.
- **BuilderAlgo overlap with existing booleans**: The existing `cut`/`fuse`/`common`/`section` use `BRepAlgoAPI_Cut/Fuse/Common/Section` directly. `BRepAlgoAPI_BuilderAlgo` is the lower-level parent class. The new wrapper exposes the builder for advanced use cases (e.g., parallel building with shape sets).
- **ShapeCustom conversion may fail silently**: Not all shapes can be converted to revolution or swept elementary forms. Returns nil in those cases — no error is set by OCCT for "not applicable".
