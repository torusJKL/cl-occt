## Why

The C wrapper and FFI binding for `make_text_shape_on_plane_full` exist but are never called from Lisp code. This means the `:x-direction` parameter — which controls the text baseline direction on arbitrary planes — is inaccessible to users. Text placed on non-XY planes (e.g., XZ plane with normal `(0,1,0)`) can appear mirrored or reversed because OCCT's auto-computed X direction is unpredictable.

## What Changes

- `make-text-shape`, `make-text-shape-3d`, `make-text-shape-on-plane`, `make-multi-line-text`, and `make-formatted-text` gain a `:x-direction` keyword argument (3-element list, default `nil`)
- When `:x-direction` is provided, the system calls `%make-text-shape-on-plane-full` instead of `%make-text-shape-on-plane`
- Internal `make-text-shape` switches from two code paths (with/without plane) to a single code path that always uses the plane variant with defaults
- `%make-text-shape` (the no-coordinates C function) becomes dead code; the FFI binding is retained for backward C ABI compatibility but unused from Lisp
- `api-reference.md` is updated with the new parameter

## Capabilities

### New Capabilities

*(none — this extends an existing capability)*

### Modified Capabilities

- `text-positioning`: Add `:x-direction` requirement for explicit control over text baseline direction on a plane

## Impact

- `src/core/text.lisp` — modify `make-text-shape`, `make-text-shape-3d`, `make-text-shape-on-plane`, `make-multi-line-text`, `make-formatted-text`; update `%compute-gp-ax3` helper
- `src/ffi/bindings-text.lisp` — no changes needed (FFI binding already exists)
- `wrap/occt_wrap_text.cpp` — no changes needed
- `openspec/specs/text-positioning/spec.md` — add requirements and scenarios
- `docs/api-reference.md` — add `:x-direction` parameter documentation
