## Context

The current DSL (`defmodel`) produces bare `shape` objects with no metadata (color, name, layer). The DAG `model` struct caches only a `shape` pointer. The XDE-based STEP I/O layer (`read-step-assembly` / `write-step-assembly`) already supports name, color, and location — but only through an explicit `assembly` tree, disconnected from the DAG.

This design extends the DAG and DSL so that users can declare metadata in `defmodel`, have it propagate through the DAG, and have it round-trip through STEP.

## Goals / Non-Goals

**Goals:**
- Allow `defmodel` to accept optional `:name`, `:color`, `:layer` clauses
- Store metadata in the `model` struct alongside the cached shape
- Make metadata resolvable from parameters (e.g., `:color (param :col)`)
- Extend `write-step` to produce XDE STEP files with metadata from the DAG layer
- Extend `read-step` / `read-step-assembly` to populate DAG model metadata
- Ensure existing specs and tests pass without modification

**Non-Goals:**
- Per-shape metadata on bare `shape` objects (metadata lives in the model/DAG layer)
- Per-face or per-edge coloring (color applies to the whole model shape)
- Material, Uuid, or custom OCCT attributes beyond name/color/layer
- GUI or visual preview of colors

## Decisions

1. **Metadata lives in the `model` struct, not the `shape` class.** The `shape` class is a thin pointer wrapper with GC finalization. Adding mutable metadata would conflate geometry with presentation, complicate GC, and break the existing shape abstraction. The `model` struct already exists per-model and is the natural home.

2. **Metadata is specified as plist-valued slots in `defmodel`.** Following the existing `param` pattern, metadata slots have both a static value form and a parametric form. This is consistent with how `param-keys` are auto-detected by `%model-keys-from-params`.

3. **Color representation uses `(:type r g b a)` plists**, matching the existing `assembly` class convention. Type is one of `:generic`, `:surf`, `:curv` (mapping to OCCT `XCAFDoc_ColorGen/ColorSurf/ColorCurv`). Alpha is optional (defaults to 1.0).

4. **STEP export is `write-step-assembly`-only.** The simple `write-step` writes a bare `STEPControl_Writer` shape with no metadata. Users who want metadata must use `write-step-assembly` which walks the model registry and creates an XDE document. This preserves backward compatibility.

5. **STEP import populates the model registry.** When `read-step-assembly` loads a STEP file with metadata, it registers `defmodel`-like entries in the DAG so that models can be referenced. Simple `read-step` returns bare shapes as before.

6. **Non-goal: per-model STEP file export as assembly.** The assembly tree approach scales to one file with many parts. A future change could add single-model-with-metadata export, but for now models are exported by collecting all registered models.

## Risks / Trade-offs

- **Risk:** Metadata model explosion — every model carrying a color/layer plist increases memory. **Mitigation:** Metadata is stored only on models, which are typically few in number. Metadata can be nil (no cost).
- **Risk:** Breaking backward compatibility — `write-step` currently produces simple STEP. **Mitigation:** `write-step` semantics unchanged; metadata export requires explicit `write-step-assembly`.
- **Risk:** Color type complexity — OCCT supports three color types (generic, surf, curv). **Mitigation:** Default to `:generic` for model-level color. This matches the most common use case and the existing assembly convention.
