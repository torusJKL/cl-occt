## 1. C Wrapper — BOPAlgo Splitter

- [ ] 1.1 Add `#include <BOPAlgo_Splitter.hxx>` to `occt_wrap_operations.cpp`
- [ ] 1.2 Implement `split_shape` in `occt_wrap_operations.cpp`: accept shape + tool array + count, run BOPAlgo_Splitter, return result compound
- [ ] 1.3 Declare `split_shape` in `occt_wrap_features.h`

## 2. C Wrapper — BOPAlgo MakerVolume

- [ ] 2.1 Add `#include <BOPAlgo_MakerVolume.hxx>` to `occt_wrap_operations.cpp`
- [ ] 2.2 Implement `make_volume` in `occt_wrap_operations.cpp`: accept shape array + count, run BOPAlgo_MakerVolume, return result shapes
- [ ] 2.3 Declare `make_volume` in `occt_wrap_features.h`

## 3. C Wrapper — BOPAlgo CellsBuilder

- [ ] 3.1 Add `#include <BOPAlgo_CellsBuilder.hxx>` to `occt_wrap_operations.cpp`
- [ ] 3.2 Implement `cells_builder` in `occt_wrap_operations.cpp`: accept shapes + count + operation code + selection mask, return result compound
- [ ] 3.3 Declare `cells_builder` in `occt_wrap_features.h`

## 4. C Wrapper — BOPAlgo Utilities

- [ ] 4.1 Add `#include <BOPAlgo_ArgumentAnalyzer.hxx>`, `#include <BOPAlgo_MakeConnected.hxx>`, `#include <BOPAlgo_MakePeriodic.hxx>` to new `wrap/occt_wrap_bopalgo_utils.cpp`
- [ ] 4.2 Implement `argument_analyzer` in `occt_wrap_bopalgo_utils.cpp`: accept shape array + count, run BOPAlgo_ArgumentAnalyzer, return diagnostic strings or NULL
- [ ] 4.3 Implement `make_connected_shapes` in `occt_wrap_bopalgo_utils.cpp`: accept shape array + count, run BOPAlgo_MakeConnected, return result shape
- [ ] 4.4 Implement `make_shape_periodic` in `occt_wrap_bopalgo_utils.cpp`: accept shape + axis direction, run BOPAlgo_MakePeriodic, return result shape
- [ ] 4.5 Declare all new functions in new `wrap/occt_wrap_bopalgo_utils.h`

## 5. CFFI Bindings

- [ ] 5.1 Add CFFI `defcfun` bindings for all BOPAlgo C functions in `src/ffi/bindings-features.lisp`

## 6. Core CLOS Wrappers

- [ ] 6.1 Create `src/core/bop-splitter.lisp` with `split-shape`: accept shape + tool(s), call `%split-shape`, wrap with `make-shape`, nil propagation
- [ ] 6.2 Create `src/core/bop-volume.lisp` with `make-volume`: accept shape list, call `%make-volume`, extract individual volumes from compound, return list
- [ ] 6.3 Create `src/core/bop-volume.lisp` with `cells-builder`: accept shapes + operation keyword + select spec, call `%cells-builder`, return compound
- [ ] 6.4 Create `src/core/bop-utilities.lisp` with `boolean-argument-analyzer`: accept shape list, call `%argument-analyzer`, return list of strings
- [ ] 6.5 Implement `make-connected` in `src/core/bop-utilities.lisp`: call `%make-connected-shapes`, wrap with `make-shape`
- [ ] 6.6 Implement `make-periodic` in `src/core/bop-utilities.lisp`: call `%make-shape-periodic`, wrap with `make-shape`

## 7. System Integration

- [ ] 7.1 Add new core files to `cl-occt.asd`
- [ ] 7.2 Add new wrap files to `wrap/Makefile`
- [ ] 7.3 Export new public symbols from `src/package.lisp`

## 8. Tests

- [ ] 8.1 Add splitter tests: split box by plane, split by wire, nil input, multiple tools
- [ ] 8.2 Add make-volume tests: cavity between shells, no cavity returns nil, single shell
- [ ] 8.3 Add cells-builder tests: select specific fragments, select all, select none
- [ ] 8.4 Add argument-analyzer tests: valid shapes, invalid shapes, nil input
- [ ] 8.5 Add make-connected tests: connect two boxes, nil input
- [ ] 8.6 Add make-periodic tests: make box periodic, non-applicable shape returns nil
- [ ] 8.7 Register all new tests in the test runner function

## 9. Documentation

- [ ] 9.1 Add "Splitter" section to `doc/api-reference.md` with `split-shape` signature, description, and example
- [ ] 9.2 Add "Make Volume" section with `make-volume` signature, description, and example
- [ ] 9.3 Add "Cells Builder" section with `cells-builder` signature, description, and example
- [ ] 9.4 Add "Boolean Analysis" section with `boolean-argument-analyzer` signature, description, and example
- [ ] 9.5 Add "Shape Connectivity & Periodicity" section with `make-connected` and `make-periodic` signatures, descriptions, and examples

## 10. Build & Verify

- [ ] 10.1 Rebuild `lib/libocctwrap.so` with `just wrap`
- [ ] 10.2 Run `just test-all` to verify all new and existing tests pass
