## Why

The viewer styling, coloring, lighting, object property, drawer, dimension, and text label APIs are extensive and nuanced. Users cannot discover parameter semantics or usage patterns without documentation. Many functions accept color keywords, RGB triples, or named presets — all undocumented.

## What Changes

- Add docstrings with `Example:` blocks to all public functions across 7 viewer styling files
- Add missing examples to 2 existing docstrings (`ais-selected-objects`, `ais-selected-shapes`)
- Trivial predicates (`viewer-color-p`, `viewer-light-p`, `material-p`) get docstring description without example
- No functional or API changes — documentation only

Files modified: `src/core/viewer-colors.lisp`, `src/core/viewer-defaults.lisp`, `src/core/viewer-lighting.lisp`, `src/core/viewer-object-props.lisp`, `src/core/viewer-drawer.lisp`, `src/core/viewer-dimensions.lisp`, `src/core/viewer-text-labels.lisp`

## Capabilities

### New Capabilities

None — documentation enhancement only.

### Modified Capabilities

None — no spec-level behavior changes.

## Impact

- `src/core/viewer-colors.lisp`: 14 functions — `viewer-color-p`, `make-color`, `color-rgb`, `normalize-color`, `named-color`, `list-named-colors`, `named-color-exists-p`, `hex-to-rgb`, `hex-digit-char-p`, `parse-hex-value`, `parse-hex-6`, `parse-hex-3`, `hls-to-rgb`, `color-delta`
- `src/core/viewer-defaults.lisp`: 8 functions
- `src/core/viewer-lighting.lisp`: 19 functions — `viewer-light-p`, `make-light`, `free-light`, `viewer-add-light`, `viewer-remove-light`, `viewer-light-on`, `viewer-light-off`, `viewer-light-active-p`, `set-light-color`, `set-light-intensity`, `set-light-direction`, `set-light-position`, `set-light-angle`, `set-light-concentration`, `set-headlight`, `set-light-shadows`, `viewer-default-lights`, `viewer-lights`, `viewer-active-lights`
- `src/core/viewer-object-props.lisp`: 37 functions — includes material, transparency, selection, hilighting APIs
- `src/core/viewer-drawer.lisp`: 14 functions
- `src/core/viewer-dimensions.lisp`: 12 functions
- `src/core/viewer-text-labels.lisp`: 7 functions
- All existing tests should pass unchanged
