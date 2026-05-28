## Context

The text positioning API was extended in commit f4b7c68 to expose `x-direction` control and fix extrusion to follow the plane normal. Source docstrings (in `src/core/text.lisp`) were updated as part of the commit and are correct. Two documentation files need updating:

- **`docs/api-reference.md`** (1901 lines) — the primary API reference, was partially updated in the commit but the `make-text-shape-3d` description is incomplete
- **`doc/api-reference.md`** (457 lines) — an older/OEM copy that predates the entire text subsystem; no text API section at all

## Goals / Non-Goals

**Goals:**
- `docs/api-reference.md` accurately describes that `make-text-shape-3d` extrudes along the plane normal when `:normal` is provided
- `doc/api-reference.md` includes a complete text API section covering all public text functions
- Both files are consistent with the actual API and source docstrings

**Non-Goals:**
- No behavioral code changes
- No restructuring of markdown files
- No automated doc generation pipeline changes (out of scope)

## Decisions

- **Mirror `docs/api-reference.md` content into `doc/api-reference.md`**: The two files cover different API areas (`doc/api-reference.md` focuses on OCAF/XCAF/topology, `docs/` covers the full API). Rather than merging, add a parallel text API section to the older file.
- **Use same table format**: Both files use GitHub-flavored markdown tables for function signatures. Consistent formatting avoids confusion.
- **Source docstrings are canonical**: The markdown docs should match the source docstrings, not diverge. No docstring changes needed.

## Risks / Trade-offs

- [Stale copy risk] Having two `api-reference.md` files increases the chance they drift apart → Mitigation: Add a note to the older file pointing to the primary `docs/api-reference.md`
- [No validation] No automated test verifies doc accuracy → Mitigation: Manual review step in tasks
