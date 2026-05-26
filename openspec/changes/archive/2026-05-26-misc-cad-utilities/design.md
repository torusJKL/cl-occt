## Context

Phase 1 and 2 cover the essential topology, geometry, and modeling gaps. This phase addresses lower-priority but still valuable OCCT utilities: constrained 2D geometry (GccAna for analytical solutions), units conversion (UnitsAPI), expression evaluation (ExprIntrp), and additional math solvers.

These capabilities are largely independent of each other and can be implemented in any order.

## Goals / Non-Goals

**Goals:**
- Expose analytical 2D geometry constraints via `GccAna` (line through two points, circle tangent to two lines, etc.)
- Expose geometric 2D geometry constraints via `Geom2dGcc` for curve-based solutions
- Expose unit conversion via `UnitsAPI` (SI ↔ Imperial, user-defined units)
- Expose expression evaluation via `ExprIntrp` (parse and evaluate string expressions)
- Extend `math-inttools` with additional solver classes (root finding, minimization)
- Update `doc/api-reference.md` with all new signatures

**Non-Goals:**
- No topological or geometric changes beyond constrained 2D
- No visualization changes
- No I/O format changes

## Decisions

### 1. GccAna for analytical 2D constraints

`GccAna` provides analytical solutions for 2D geometry constraints — circle tangent to two lines, circle tangent to three circles, etc. The C wrapper follows OCCT's function naming:

```c
// Number of solutions
int gccana_num_solutions(int problem_type, params...);
// Get solution as GP circle/line
int gccana_solution(int problem_type, params..., int idx, double* out_params);
```

Each problem type (circle tangent to 2 lines, circle through point tangent to line, etc.) gets a dedicated wrapper function for clarity.

### 2. UnitsAPI

`UnitsAPI` provides unit conversion. Expose as simple functions:
- `convert_units(value, from_unit, to_unit)` — convert numeric value
- `convert_units_si(value, unit)` — convert from SI
- `convert_units_to_si(value, unit)` — convert to SI

Units are specified by string (e.g., `"mm"`, `"inch"`, `"kg"`, `"lbm"`).

### 3. ExprIntrp

`ExprIntrp` parses and evaluates mathematical expressions. Expose as:
- `evaluate_expression(string)` — parse and evaluate, return numeric result
- Variables can be set via string substitution before evaluation

### 4. Math solvers

Extend existing `math-inttools` wrappers with:
- `math_FunctionRoot`: Find root of a function
- `math_BissecNewton`: Root finding using bisection + Newton
- `math_NewtonMinimum`: Find minimum using Newton's method

## Risks / Trade-offs

- **GccAna solution multiplicity**: 2D constraint problems often have multiple solutions (e.g., 4 circles tangent to 2 circles). The API returns an array of all valid solutions; callers must select the desired one.
- **UnitsAPI complexity**: OCCT's UnitsAPI has a complex interface with unit dictionaries and conversion tables. The simplified API above covers the common case. Advanced usage (custom units, compound units) would require deeper wrapping.
- **Expression interpreter overhead**: `ExprIntrp` uses OCCT's `Expr` package which has dependencies on `ExprIntrp`, `Expr`, and related toolkits. Ensure these are linked in the build.
