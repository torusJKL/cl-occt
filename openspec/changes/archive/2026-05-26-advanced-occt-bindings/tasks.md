## 1. C Wrapper — Sewing

- [x] 1.1 Add `#include <BRepBuilderAPI_Sewing.hxx>` to `occt_wrap.cpp` includes
- [x] 1.2 Implement `sew_shapes` in `occt_wrap.cpp`: accept shape array + count + tolerance + allow_non_manifold, add to sewn shape, return result
- [x] 1.3 Declare `sew_shapes` in `occt_wrap.h`

## 2. C Wrapper — Defeaturing

- [x] 2.1 Add `#include <BRepAlgoAPI_Defeaturing.hxx>` to `occt_wrap.cpp` includes
- [x] 2.2 Implement `defeature_shape` in `occt_wrap.cpp`: accept shape + face array + count, run BRepAlgoAPI_Defeaturing, return result
- [x] 2.3 Declare `defeature_shape` in `occt_wrap.h`

## 3. C Wrapper — Shape Check & Builder

- [x] 3.1 Add `#include <BRepAlgoAPI_Check.hxx>` and `#include <BRepAlgoAPI_BuilderAlgo.hxx>` to `occt_wrap.cpp`
- [x] 3.2 Implement `check_shape_validity` in `occt_wrap.cpp`: accept shape, run BRepAlgoAPI_Check, return result description string or NULL
- [x] 3.3 Implement `boolean_builder` in `occt_wrap.cpp`: accept shape1 + shape2 + operation (int 0=fuse,1=cut,2=common,3=section), run BRepAlgoAPI_BuilderAlgo, return result shape
- [x] 3.4 Declare `check_shape_validity` and `boolean_builder` in `occt_wrap.h`

## 4. C Wrapper — HLR

- [x] 4.1 Add `#include <HLRBRep_Algo.hxx>` and `#include <HLRBRep_HLRToShape.hxx>` to `occt_wrap.cpp`
- [x] 4.2 Implement `hlr_project` in `occt_wrap.cpp`: accept shape + projection direction (dx dy dz) + optional projection point (px py pz), run HLRBRep_Algo + HLRBRep_HLRToShape, return compound or result shapes
- [x] 4.3 Implement `hlr_extract_shapes` in `occt_wrap.cpp`: accept HLR result + extraction flags (visible-visible, visible-hidden, etc.), return compound of extracted edges
- [x] 4.4 Declare `hlr_project` and `hlr_extract_shapes` in `occt_wrap.h`

## 5. C Wrapper — Shape Conversion

- [x] 5.1 Add `#include <ShapeCustom_ConvertToRevolution.hxx>` and `#include <ShapeCustom_SweptToElementary.hxx>` to `occt_wrap.cpp`
- [x] 5.2 Implement `convert_to_revolution` in `occt_wrap.cpp`: accept shape, run ShapeCustom_ConvertToRevolution, return new shape or null
- [x] 5.3 Implement `convert_swept_to_elementary` in `occt_wrap.cpp`: accept shape, run ShapeCustom_SweptToElementary, return new shape or null
- [x] 5.4 Declare `convert_to_revolution` and `convert_swept_to_elementary` in `occt_wrap.h`

## 6. CFFI Bindings

- [x] 6.1 Add CFFI `defcfun` bindings for the 8 new C functions in `src/ffi/bindings.lisp` following the existing `%`-prefix naming convention

## 7. Core CLOS Wrappers

- [x] 7.1 Create `src/core/sewing.lisp` with `sew-shapes` function: accept shape list + `&key tolerance allow-non-manifold`, wrap C pointer with `make-shape`, nil propagation
- [x] 7.2 Create `src/core/defeaturing.lisp` with `defeature-shape` function: accept shape + face list, wrap C pointer with `make-shape`, nil propagation
- [x] 7.3 Create `src/core/shape-check.lisp` with `check-shape-validity` (returns error message string or nil) and `boolean-builder` (accepts shape + shape + operation keyword, returns shape or nil)
- [x] 7.4 Create `src/core/hlr.lisp` with `hlr-project` and `hlr-extract-shapes` following the design's grouped approach, returning Lisp-friendly data structures
- [x] 7.5 Create `src/core/shape-conversion.lisp` with `convert-to-revolution` and `convert-swept-to-elementary` (each accept one shape, return shape or nil)

## 8. System Integration

- [x] 8.1 Add new core files to `cl-occt.asd` for system loading
- [x] 8.2 Export new public symbols from `src/package.lisp`

## 9. Tests

- [x] 9.1 Add sewing tests: sewn boxes, nil input, multiple shapes, non-manifold option
- [x] 9.2 Add defeaturing tests: remove face from box, nil input, multiple face removal
- [x] 9.3 Add shape-check tests: valid shape, invalid shape, nil input; boolean builder with fuse/cut/common
- [x] 9.4 Add HLR tests: project box, nil input, extract visible/hidden edges
- [x] 9.5 Add shape-conversion tests: convert shapes, nil input, non-convertible shapes
- [x] 9.6 Register all new tests in the test runner function

## 10. Documentation

- [x] 10.1 Add "Sewing" section to `docs/api-reference.md` with `sew-shapes` entry, description, and example
- [x] 10.2 Add "Defeaturing" section to `docs/api-reference.md` with `defeature-shape` entry, description, and example
- [x] 10.3 Add "Shape Check / Builder" entries to existing Booleans section or create new subsection for `check-shape-validity` and `boolean-builder`
- [x] 10.4 Add "HLR (Hidden Line Removal)" section to `docs/api-reference.md` with `hlr-project` and related entries
- [x] 10.5 Add "Shape Conversion" section to `docs/api-reference.md` with conversion function entries

## 11. Build & Verify

- [x] 11.1 Rebuild `lib/libocctwrap.so` with `just wrap`
- [x] 11.2 Run `just test-all` to verify all new and existing tests pass
