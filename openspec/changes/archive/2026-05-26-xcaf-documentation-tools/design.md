## Context

The cl-occt library currently supports XCAF documents only for assembly I/O (`read-step-assembly`, `write-step-assembly`). The underlying OCCT XCAF framework provides a rich set of document-level metadata tools that are entirely inaccessible from Lisp. The existing C wrapper already uses XCAF internally (for STEP/IGES assembly colors and names) but does not expose standalone XCAF tool APIs.

## Goals / Non-Goals

**Goals:**
- Expose OCCT's XCAF document metadata tools via the standard 3-layer architecture (C wrapper → FFI → core wrappers)
- Support document creation via `XCAFApp_Application`
- Support layers, materials, dimensions/tolerances, views, notes, visual materials, clipping planes, and document editing
- Create an idiomatic Lisp API that follows existing conventions (nil propagation, keyword arguments, GC finalization)
- Update `docs/api-reference.md` for AI agent consumption

**Non-Goals:**
- Full OCCT XDE document API coverage (only the 9 tools listed)
- GUI or viewer integration for XCAF metadata display
- STEP/IGES roundtrip changes (existing assembly I/O is unchanged)
- Performance optimization of XCAF document operations

## Decisions

### 1. New core file vs. extending existing files
**Decision**: New file `src/core/xcaf-doc.lisp`
**Rationale**: XCAF document tools are a distinct domain from shape geometry, I/O, and assembly tree management. A dedicated file keeps concerns separated and follows the pattern of other domain files (`assembly.lisp`, `io.lisp`, `primitives.lisp`).

### 2. CLOS class for XCAF document vs. raw pointer
**Decision**: New `xcaf-doc` CLOS class wrapping `Handle(TDocStd_Document)*` with `tg:finalize`
**Rationale**: Consistent with `shape`, `geom2d`, `curve`, `surface`, etc. GC finalization prevents leaks. The class carries the document handle and an application handle for lifecycle management.

### 3. Return style: plists vs. accessor functions
**Decision**: Accessor functions for individual properties; plists for batch queries (e.g., layer names for all shapes)
**Rationale**: Follows existing patterns (`assembly-name`, `assembly-color`, `assembly-children`). Batch operations that return multiple values use plists for composability.

### 4. Error handling strategy
**Decision**: Invalid/degenerate inputs return nil; C-level errors via `(get-error-message)` and `occt-error` condition
**Rationale**: Consistent with every other function in cl-occt. Users check for nil rather than wrapping in handler-case for common cases.

### 5. Function naming convention
**Decision**: `xcaf-` prefix for all public API functions (e.g., `xcaf-add-layer`, `xcaf-set-density`)
**Rationale**: Clear domain namespace. Distinct from `%`-prefixed FFI internals and from the `xde-` prefix used in assembly I/O. Avoids ambiguity with `xde-` functions that deal with different abstraction level.

## Risks / Trade-offs

- **OCCT API instability**: XCAF tool APIs may vary between OCCT versions (7.x → 8.x). We are targeting OCCT 8.0 (what's installed). Mitigation: compile-time checks in C wrapper where possible.
- **Partial coverage**: Only 9 of the many XCAF tools are bound. Users needing other tools will need follow-up changes. This is acceptable given the scope.
- **Memory management**: `Handle(TDocStd_Document)*` lifetime must outlive any tool handles derived from it. Mitigation: `xcaf-doc` finalizer frees the document; tool functions receive the doc pointer each call (no separate tool handle caching).
