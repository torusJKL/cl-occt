## Context

`text.lisp` is the largest single file in this batch (26 functions). It covers font creation, text shaping (flat and 3D extruded), text labels, glyph metrics, multi-line text, and formatted text. The file mixes simple accessors (`text-font-ascender`), medium constructors (`make-text-shape`), and complex operations (`make-multi-line-text`).

## Goals / Non-Goals

**Goals:**
- Every public function gets docstring with example (or docstring-only for predicates)
- `See also:` links between text shaping functions and between glyph metric functions
- Examples demonstrate the font→text→display pipeline

**Non-Goals:**
- No functional or API changes

## Decisions

- **Setup examples** should use `make-brep-font-from-name` with a common font (e.g., "Arial")
- **Text shape examples** should show both flat and 3D extruded text
- **Multi-line text** example should show the splitting and layout
- **Glyph metric functions** (`text-font-ascender`, etc.) form a natural group for `See also:` cross-references
- **Setf functions** (`(setf ais-text-label-text)` etc.) follow the same docstring convention

## Risks / Trade-offs

- **Font availability varies by system** — examples should use "Arial" as default with a note that the font must be installed
