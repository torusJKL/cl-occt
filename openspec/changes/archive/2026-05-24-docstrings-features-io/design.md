## Context

17 small files covering diverse functionality: mechanical features (fillet, chamfer, blend, draft, sweep, loft, shell, pipe, offset, local ops, holes), helix, face filling, assembly hierarchy, STEP/STL I/O, and error handling.

## Goals / Non-Goals

**Goals:**
- Every public function across all 17 files gets docstring with example
- I/O examples show file round-trips where possible
- Assembly examples show multi-level tree construction
- `See also:` grouping for related operations (fillet variants, chamfer variants, I/O functions)

**Non-Goals:**
- No functional or API changes

## Decisions

- **Fillet/chamfer examples** should show before/after on a box edge
- **STEP/STL examples** should write to `/tmp/` to avoid cluttering the workspace
- **Assembly examples** should build a 2-level tree with parts and sub-assemblies
- **`make-blend`** example should reference `face-filling` functions

## Risks / Trade-offs

- **I/O examples depend on file system** — show `write-step` to a temp path, then `read-step` back, verifying shape equality conceptually
