## Context

Curves (`curves.lisp`), surfaces (`surfaces.lisp`), and 2D geometry (`geom2d.lisp`) form the mathematical geometry layer. Functions range from simple accessors (`curve-p`, `curve-type`) to complex constructors (`make-bspline-curve`, `make-bspline-surface`).

## Goals / Non-Goals

**Goals:**
- Every public function gets docstring with example (or docstring-only for predicates)
- Complex constructors (bspline, bezier) get thorough examples with pole arrays
- `See also:` linking between curve constructors and between surface constructors

**Non-Goals:**
- No functional or API changes

## Decisions

- **BSpline examples** are the most complex — show pole lists and knot/mult arrays inline
- **`curve-type` / `surface-type`** examples should show result for a known geometry type
- **`convert-curve-to-bspline` / `convert-surface-to-bspline`** examples should show round-trip conversion
- **2D geometry** (`geom2d.lisp`) examples are simpler since 2D types are less commonly used

## Risks / Trade-offs

- **BSpline examples are long** — they may span multiple lines. Keep them readable with line breaks between array entries.
