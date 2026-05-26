## Why

The existing xcaf-doc API covers assembly structure, layers, and basic colors, but cannot represent GD&T (Geometric Dimensioning & Tolerancing) — dimensions, tolerances, datums, and geometric tolerances. OCCT's `XCAFDimTolObjects` provides the full GD&T model that STEP AP242 supports. For manufacturing-oriented workflows, an AI needs to create, query, and round-trip these annotations through STEP files.

## What Changes

- **Dimension Objects**: `XCAFDimTolObjects_DimensionObject` — linear, angular, diametric, radial dimensions with tolerances
- **Tolerance Objects**: `XCAFDimTolObjects_ToleranceObject` — tolerance types (profile, position, runout, flatness, etc.)
- **Datum Objects**: `XCAFDimTolObjects_DatumObject` — datum references (single, compound)
- **Geometric Tolerances**: `XCAFDimTolObjects_GeomToleranceObject` — full geometric tolerance with modifiers, material condition, zone
- **STEP Round-Trip**: Persist GD&T annotations through XDE STEP read/write
- **Documentation**: Update `api-reference.md` with all new function signatures

## Capabilities

### New Capabilities

- `xcaf-dimtol`: Dimension, tolerance, datum, and geometric tolerance objects in XCAF documents

### Modified Capabilities

- `xcaf-doc`: Add GD&T creation, query, and deletion functions (extends existing doc management)

## Impact

- **C wrapper** (`wrap/`): ~10 new `extern "C"` functions for XCAFDimTolObjects
- **CFFI layer** (`src/ffi/`): ~10 new `defcfun` bindings
- **Core layer** (`src/core/`): New `xcaf-dimtol.lisp` extending the xcaf-doc capabilities
- **Tests** (`tests/`): Dimension creation, tolerance creation, datum creation, STEP round-trip tests
- **Docs** (`doc/api-reference.md`): XCAF GD&T section
