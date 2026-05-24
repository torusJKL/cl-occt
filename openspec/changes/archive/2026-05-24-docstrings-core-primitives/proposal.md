## Why

Most public API functions in `cl-occt` lack docstrings and usage examples, making the library difficult to use from the REPL or in editors that display documentation inline. This change adds docstrings with examples to the core geometric primitives, boolean operations, transforms, compounds, and the shape predicate.

## What Changes

- Add docstrings with `Example:` blocks to every public function in the affected files
- Add `See also:` cross-references where natural (e.g., `cut` ↔ `fuse` ↔ `common` ↔ `section`)
- Trivial predicates (`shape-p`) get a docstring description without an example block
- No functional or API changes — documentation only

Files modified: `src/core/primitives.lisp`, `src/core/booleans.lisp`, `src/core/transforms.lisp`, `src/core/compounds.lisp`, `src/core/shape.lisp`

## Capabilities

### New Capabilities

None — this is a documentation enhancement, not a new feature.

### Modified Capabilities

None — no spec-level behavior changes.

## Impact

- `src/core/primitives.lisp`: 7 functions — `make-box`, `make-cylinder`, `make-sphere`, `make-cone`, `make-torus`, `make-prism`, `make-revol`
- `src/core/booleans.lisp`: 4 functions — `cut`, `fuse`, `common`, `section`
- `src/core/transforms.lisp`: 2 functions — `translate`, `rotate`
- `src/core/compounds.lisp`: 3 functions — `make-compound`, `add-to-compound`, `compound-shape-p`
- `src/core/shape.lisp`: 1 function — `shape-p` (docstring only, trivial predicate)
- No new dependencies
- All existing tests should pass unchanged
