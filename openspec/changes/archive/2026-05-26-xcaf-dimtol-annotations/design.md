## Context

cl-occt already has a working `xcaf-doc` class with assembly/color/layer management. `XCAFDimTolObjects` is the module that provides GD&T data structures. These are stored as attributes on TDF labels and are automatically persisted through XCAF STEP readers/writers (already wrapped as `%xde-read-step`/`%xde-write-step`).

## Goals / Non-Goals

**Goals:**
- Create dimensions (linear, angular, diametric, radial) via XCAFDimTolObjects
- Create tolerances (flatness, position, profile, runout, etc.)
- Create datum references (single and compound)
- Create geometric tolerances with datum references and modifiers
- Query all GD&T attached to a shape
- Round-trip GD&T through STEP

**Non-Goals:**
- No display/visualization of GD&T (that requires PrsDim or custom AIS)
- No changes to the existing assembly tree or layer APIs
- No parametric GD&T (driven by TFunction)

## Decisions

### 1. GD&T uses the existing XCAF doc
`XCAFDimTolObjects` is integrated with `XCAFDoc_DimTolTool` which operates on the same XCAF document. No new document class needed.

### 2. GD&T is shape-centric
All GD&T annotations are attached to a shape within the XCAF document. The Lisp API takes `doc`, `shape`, and annotation parameters.

### 3. Return values use property lists
GD&T queries return plists with `:type`, `:value`, `:subshapes`, `:modifiers`, `:datums` keys for easy destructuring by AI agents.

### 4. File layout

| What | Where |
|------|-------|
| C XCAFDimTol | New `wrap/occt_wrap_xcaf_dimtol.cpp` |
| CFFI | New `src/ffi/bindings-xcaf-dimtol.lisp` |
| Core | New `src/core/xcaf-dimtol.lisp` |

## Risks / Trade-offs

- **GD&T attachment requires selected subshapes.** Dimensions must reference specific faces/edges on the shape. The AI must first identify the subshapes (using topology-ai-queries) before annotating them.
- **STEP round-trip fidelity depends on OCCT's STEP processor.** AP242 GD&T support is present in OCCT 8.0 but may not cover every GD&T symbol. The API will note limitations.
