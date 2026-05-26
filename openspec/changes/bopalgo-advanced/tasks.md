## 1. C Wrapper — BOPAlgo Splitter

- [x] 1.1 Add `#include <BOPAlgo_Splitter.hxx>` to `occt_wrap_operations.cpp`
- [x] 1.2 Implement `split_shape` in `occt_wrap_operations.cpp`: accept shape + tool array + count, run BOPAlgo_Splitter, return result compound
- [x] 1.3 Declare `split_shape` in `occt_wrap_features.h`

## 2. C Wrapper — BOPAlgo MakerVolume

- [x] 2.1 Add `#include <BOPAlgo_MakerVolume.hxx>` to `occt_wrap_operations.cpp`
- [x] 2.2 Implement `make_volume` in `occt_wrap_operations.cpp`: accept shape array + count, run BOPAlgo_MakerVolume, return result shapes
- [x] 2.3 Declare `make_volume` in `occt_wrap_features.h`

## 3. C Wrapper — BOPAlgo CellsBuilder

- [x] 3.1 Add `#include <BOPAlgo_CellsBuilder.hxx>` to `occt_wrap_operations.cpp`
- [x] 3.2 Implement `cells_builder` in `occt_wrap_operations.cpp`: accept shapes + count + operation code + selection mask, return result compound
- [x] 3.3 Declare `cells_builder` in `occt_wrap_features.h`

## 4. C Wrapper — BOPAlgo Utilities

- [x] 4.1 Add `#include <BOPAlgo_ArgumentAnalyzer.hxx>`, `#include <BOPAlgo_MakeConnected.hxx>`, `#include <BOPAlgo_MakePeriodic.hxx>` to new `wrap/occt_wrap_bopalgo_utils.cpp`
- [x] 4.2 Implement `argument_analyzer` in `occt_wrap_bopalgo_utils.cpp`: accept shape array + count, run BOPAlgo_ArgumentAnalyzer, return diagnostic strings or NULL
- [x] 4.3 Implement `make_connected_shapes` in `occt_wrap_bopalgo_utils.cpp`: accept shape array + count, run BOPAlgo_MakeConnected, return result shape
- [x] 4.4 Implement `make_shape_periodic` in `occt_wrap_bopalgo_utils.cpp`: accept shape + axis direction, run BOPAlgo_MakePeriodic, return result shape
- [x] 4.5 Declare all new functions in new `wrap/occt_wrap_bopalgo_utils.h`

## 5. CFFI Bindings

- [x] 5.1 Add CFFI `defcfun` bindings for all BOPAlgo C functions in `src/ffi/bindings-features.lisp`

## 6. Core Lisp Wrappers

- [x] 6.1 Create `src/core/bop-splitter.lisp` with `split-shape`: accept shape + list of tools, convert to C array, call `%split-shape`, wrap with `make-shape`
- [x] 6.2 Create `src/core/bop-volume.lisp` with `make-volume`: accept list of shapes, convert to C array, call `%make-volume`, wrap with `make-shape`
- [x] 6.3 Create `src/core/bop-volume.lisp` with `cells-builder`: accept shapes + operation int + optional selection list, call `%cells-builder`, wrap with `make-shape`
- [x] 6.4 Create `src/core/bop-utilities.lisp` with `boolean-argument-analyzer`: accept list of shapes, convert to C array, call `%argument-analyzer`, return string or nil
- [x] 6.5 Create `src/core/bop-utilities.lisp` with `make-connected`: accept list of shapes, convert to C array, call `%make-connected-shapes`, wrap with `make-shape`
- [x] 6.6 Create `src/core/bop-utilities.lisp` with `make-periodic`: accept shape + dx dy dz, call `%make-shape-periodic`, wrap with `make-shape`

## 7. System Integration

- [x] 7.1 Add new core files to `cl-occt.asd`
- [x] 7.2 Add `-lTKBO` to `wrap/Makefile`
- [x] 7.3 Export public `cl-occt` symbols from `src/package.lisp`

## 8. Tests

- [x] 8.1 Create `t/bop-tests.lisp` with 14 tests covering all 6 operations
- [x] 8.2 Register tests in `test-runner.lisp` `run-core-tests`

## 9. Build & Verify

- [x] 9.1 Rebuild `lib/libocctwrap.so` with `just wrap` — clean build, no warnings
- [x] 9.2 Run `just test-core` — 576 pass (562 existing + 14 new), 0 fail
