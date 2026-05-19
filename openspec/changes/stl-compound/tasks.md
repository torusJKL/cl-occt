## 1. C Wrapper

- [x] 1.1 Add `#include <BRep_Builder.hxx>` and `#include <TopoDS_Compound.hxx>` to `wrap/occt_wrap.cpp`
- [x] 1.2 Implement `make_compound` C function — takes count + array of shapes, builds compound via `BRep_Builder`, returns `occt_shape`
- [x] 1.3 Implement `add_to_compound` C function — takes compound + shape, adds via `BRep_Builder`, returns compound
- [x] 1.4 Implement `compound_is_empty` C function — returns 1 if compound has no sub-shapes, 0 otherwise
- [x] 1.5 Declare all three new functions in `wrap/occt_wrap.h`

## 2. CFFI Bindings

- [x] 2.1 Add `%make-compound` binding: `(defcfun (%make-compound "make_compound") :pointer (count :int) (shapes :pointer))`
- [x] 2.2 Add `%add-to-compound` binding: `(defcfun (%add-to-compound "add_to_compound") :pointer (compound :pointer) (shape :pointer))`
- [x] 2.3 Add `%compound-is-empty` binding: `(defcfun (%compound-is-empty "compound_is_empty") :int (shape :pointer))`

## 3. Core CLOS Layer

- [x] 3.1 Create `src/core/compounds.lisp` with `make-compound`, `add-to-compound`, `compound-shape-p`
- [x] 3.2 Implement `make-compound` — filters nil shapes, calls `%make-compound` with CFFI vector of pointers, wraps result via `make-shape`
- [x] 3.3 Implement `add-to-compound` — nil propagation on both compound and shape args
- [x] 3.4 Implement `compound-shape-p` — checks via `%compound-is-empty` and `shape-p` (a compound is always non-nil and a shape)

## 4. Package & System

- [x] 4.1 Add `:make-compound`, `:add-to-compound`, `:compound-shape-p` to exports in `src/package.lisp`
- [x] 4.2 Update `cl-occt.asd` to include `src/core/compounds.lisp` in the module

## 5. Tests

- [x] 5.1 Add test: make-compound with two boxes, verify result is a shape
- [x] 5.2 Add test: make-compound skips nil shapes in input list
- [x] 5.3 Add test: make-compound with all-nil list returns nil
- [x] 5.4 Add test: make-compound with empty list returns valid compound
- [x] 5.5 Add test: add-to-compound adds shape to existing compound
- [x] 5.6 Add test: add-to-compound with nil shape returns compound unchanged
- [x] 5.7 Add test: add-to-compound with nil compound returns nil
- [x] 5.8 Add test: compound-shape-p returns t for compound, nil for simple shape, nil for nil
- [x] 5.9 Add test: write-stl with compound writes all sub-shapes
- [x] 5.10 Add test: write-stl with empty compound produces file

## 6. Rebuild & Verify

- [x] 6.1 Rebuild `lib/libocctwrap.so` with `just wrap`
- [x] 6.2 Run `(asdf:test-system :cl-occt)` to verify all tests pass
