## Context

Six files span geometry algorithms (projection, intersection, interpolation), physical properties (volume, area, center of mass), shape validity checking, shape fixing/healing, and NURBS rebuild. These are the most mathematically complex functions in cl-occt.

## Goals / Non-Goals

**Goals:**
- Every public function gets docstring with example
- Parameter descriptions for functions with many parameters (e.g., `interpolate-points`, `substitute-shape`)
- `See also:` linking between related functions (`shape-volume` ↔ `shape-area` ↔ `shape-center-of-mass`)

**Non-Goals:**
- No functional or API changes

## Decisions

- **Geometry algorithm examples** should use simple known shapes (box, sphere) as test inputs
- **Mass properties examples** should show `gprops` object accessors
- **Shape fix examples** can use `shape-check` to demonstrate validation before/after fix
- **Shape rebuild examples** should show degree reduction and continuity upgrade on a known shape

## Risks / Trade-offs

- **Interpolation and NURBS conversion** examples are inherently long — maintain readability
