## 1. C Wrapper — XCAFDimTolObjects

- [x] 1.1 Add includes for `XCAFDimTolObjects_DimensionObject.hxx`, `XCAFDimTolObjects_ToleranceObject.hxx`, `XCAFDimTolObjects_DatumObject.hxx`, `XCAFDimTolObjects_GeomToleranceObject.hxx`, `XCAFDoc_DimTolTool.hxx` to new `wrap/occt_wrap_xcaf_dimtol.cpp`
- [x] 1.2 Implement `xcaf_add_linear_dimension`: accept doc + shape + point array + count + value, create XCAFDimTolObjects dimension on shape
- [x] 1.3 Implement `xcaf_add_angular_dimension`: accept doc + shape + edge array + count + angle value
- [x] 1.4 Implement `xcaf_add_diameter_dimension`: accept doc + shape + face/edge + value
- [x] 1.5 Implement `xcaf_add_tolerance`: accept doc + shape + tolerance type code + value + modifier flags
- [x] 1.6 Implement `xcaf_add_datum`: accept doc + shape + label string
- [x] 1.7 Implement `xcaf_add_geometric_tolerance`: accept doc + shape + type code + value + datum array + count
- [x] 1.8 Implement `xcaf_get_dimensions`: accept doc + shape, return array of dimension plists
- [x] 1.9 Implement `xcaf_get_tolerances`: accept doc + shape, return array of tolerance plists
- [x] 1.10 Implement `xcaf_get_datums`: accept doc + shape, return array of datum plists
- [x] 1.11 Declare all new functions in new `wrap/occt_wrap_xcaf_dimtol.h`

## 2. CFFI Bindings

- [x] 2.1 Add CFFI `defcfun` bindings for all XCAFDimTol C functions in new `src/ffi/bindings-xcaf-dimtol.lisp`

## 3. Core CLOS Wrappers

- [x] 3.1 Create `src/core/xcaf-dimtol.lisp` with `xcaf-add-linear-dimension`, `xcaf-add-angular-dimension`, `xcaf-add-diameter-dimension`: call C wrappers, handle nil propagation
- [x] 3.2 Implement `xcaf-add-tolerance`: accept type keyword (`:flatness`, `:position`, `:parallelism`, etc.) + value + options
- [x] 3.3 Implement `xcaf-add-datum`: accept label string
- [x] 3.4 Implement `xcaf-add-geometric-tolerance`: accept type + value + datum list + modifiers
- [x] 3.5 Implement `xcaf-get-dimensions`, `xcaf-get-tolerances`, `xcaf-get-datums`: parse C arrays into Lisp plists

## 4. System Integration

- [x] 4.1 Add new core file to `cl-occt.asd`
- [x] 4.2 Add new wrap file to `wrap/Makefile`
- [x] 4.3 Export new public symbols from `src/package.lisp`

## 5. Tests

- [x] 5.1 Add linear dimension tests: create on box face, query, nil input
- [x] 5.2 Add angular dimension tests: create between edges, query
- [x] 5.3 Add diameter dimension tests: create on cylinder, query
- [x] 5.4 Add tolerance tests: flatness, position with modifiers, query
- [x] 5.5 Add datum tests: single datum, compound datum
- [x] 5.6 Add geometric tolerance tests: position with datum reference
- [x] 5.7 Add STEP round-trip test: write shape with GD&T, read back, verify annotations preserved
- [x] 5.8 Register all new tests in the test runner function

## 6. Documentation

- [x] 6.1 Add "XCAF GD&T (Dimensions, Tolerances, Datums)" section to `doc/api-reference.md` covering all new functions

## 7. Build & Verify

- [x] 7.1 Rebuild `lib/libocctwrap.so` with `just wrap`
- [x] 7.2 Run `just test-all` to verify all new and existing tests pass
