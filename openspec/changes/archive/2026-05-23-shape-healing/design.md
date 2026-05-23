## Context

Shape healing repairs topological and geometrical defects in BRep shapes. OCCT's ShapeFix package provides targeted fixes for specific problems (wires, solids, edges, faces). ShapeBuild_ReShape allows fine-grained sub-shape substitution. ShapeCustom handles NURBS conversion. ShapeUpgrade handles splitting and continuity upgrades. ShapeProcess provides a scriptable, batch-oriented healing pipeline.

These are all shape-in, shape-out operations. The fix functions follow the same pattern: create fixer, set parameters, perform fix, return result.

## Goals / Non-Goals

**Goals:**
- Fix common shape defects via ShapeFix_Shape/Wire/Solid/Edge/Face
- Diagnose shape problems via ShapeAnalysis
- Replace individual sub-shapes in a shape
- Convert shapes to/from NURBS representation
- Split faces and upgrade surface continuity
- Define and run healing pipelines

**Non-Goals:**
- No integration with ShapeProcess resource files (optional, provided via convenience)
- No custom ShapeFix parameter tuning beyond tolerance

## Decisions

### Decision 1: ShapeFix as single-function convenience
**Chosen:** `(fix-shape shape)` runs ShapeFix_Shape with sensible defaults. `(fix-wire wire face :tolerance 0.1)` runs targeted fixes.

**Rationale:** Most users want "fix this shape" without understanding the 20+ ShapeFix parameters. Targeted fixes are available for advanced users.

### Decision 2: ReShape as both single and batch substitution
**Chosen:** `(substitute-shape orig old new)` for single replacement, `(substitute-shape orig '((old1 new1) (old2 new2)))` for batch.

**Rationale:** ReShape can accumulate replacements; batch mode is more efficient for multiple changes.

### Decision 3: Default healing pipeline wraps common ShapeProcess operators
**Chosen:** `(heal-shape shape)` applies: SameParameter → FixShape → FixWire → FixSolid. This handles the most common import issues.

**Rationale:** Users should get a healed shape with one call. The pipeline is a reasonable default for STEP/STL imports.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| ShapeFix may modify geometry in unexpected ways (e.g., shifting vertices) | Document that fixing may change shape dimensions within tolerance |
| ShapeCustom NURBS conversion increases model size (BSpline surfaces have more control points) | Document memory/performance trade-off |
| ShapeProcess resource files are OCCT-specific and may not exist in all builds | Provide resource-file-optional API that works without external files |

## Migration Plan

All new APIs are additive.
