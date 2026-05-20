## 1. C Wrapper — Header Declarations

- [x] 1.1 Add `occt_brep_font` typedef to `wrap/occt_wrap.h`
- [x] 1.2 Declare `make_brep_font_from_file`, `make_brep_font_from_name`, `make_text_shape`, and `free_brep_font` in `wrap/occt_wrap.h`

## 2. C Wrapper — Implementation

- [x] 2.1 Add `#include` for `StdPrs_BRepFont.hxx`, `StdPrs_BRepTextBuilder.hxx`, `NCollection_String.hxx`, `Graphic3d_HorizontalTextAlignment.hxx`, `Graphic3d_VerticalTextAlignment.hxx` in `wrap/occt_wrap.cpp`
- [x] 2.2 Implement `make_brep_font_from_file` — create `Handle(StdPrs_BRepFont)` from file path, size, face ID; return NULL on failure with error message
- [x] 2.3 Implement `make_brep_font_from_name` — create `Handle(StdPrs_BRepFont)` via `FindAndCreate()` with font name, aspect, size; return NULL on failure
- [x] 2.4 Implement `free_brep_font` — delete the Handle pointer
- [x] 2.5 Implement `make_text_shape` — construct `StdPrs_BRepTextBuilder`, call `Perform()` with font, string, and alignment; return flat compound shape or NULL

## 3. CFFI Bindings

- [x] 3.1 Add `defcfun` for `%make-brep-font-from-file` in `src/ffi/bindings.lisp`
- [x] 3.2 Add `defcfun` for `%make-brep-font-from-name` in `src/ffi/bindings.lisp`
- [x] 3.3 Add `defcfun` for `%free-brep-font` in `src/ffi/bindings.lisp`
- [x] 3.4 Add `defcfun` for `%make-text-shape` in `src/ffi/bindings.lisp`
- [x] 3.5 Export new `%` symbols from `cl-occt.impl` package in `src/ffi/bindings.lisp`

## 4. CLOS Wrappers — New File

- [x] 4.1 Create `src/core/text.lisp` with `brep-font` CLOS class and `brep-font-p` predicate
- [x] 4.2 Implement `make-brep-font-from-file` — call `%make-brep-font-from-file`, wrap pointer in `brep-font` with `tg:finalize`
- [x] 4.3 Implement `make-brep-font-from-name` — same pattern with aspect enum mapping
- [x] 4.4 Implement `make-text-shape` — alignment keyword mapping (h: left/center/right, v: bottom/center/top/top-first-line), nil guarding, call `%make-text-shape`, wrap result in `shape`
- [x] 4.5 Implement `make-text-shape-3d` — flat text + `make-prism` in Z direction, nil guard for zero depth

## 5. Package Exports

- [x] 5.1 Export `%make-brep-font-from-file`, `%make-brep-font-from-name`, `%free-brep-font`, `%make-text-shape` from `cl-occt.impl`
- [x] 5.2 Export `brep-font`, `brep-font-p`, `make-brep-font-from-file`, `make-brep-font-from-name`, `make-text-shape`, `make-text-shape-3d` from `cl-occt`

## 6. Rebuild and Verify

- [x] 6.1 Run `just wrap` to recompile `lib/libocctwrap.so` with new font functions
- [x] 6.2 Load system in SBCL and verify `cl-occt` loads without errors

## 7. Unit Tests

- [x] 7.1 Add test for `make-brep-font-from-file` with a system font (valid path → returns brep-font-p, nonexistent path → nil)
- [x] 7.2 Add test for `make-brep-font-from-file` with zero size → nil
- [x] 7.3 Add test for `make-text-shape` with valid font and string → returns shape
- [x] 7.4 Add test for `make-text-shape` with nil font → nil
- [x] 7.5 Add test for `make-text-shape` with empty string → nil
- [x] 7.6 Add test for `make-text-shape-3d` with valid font → returns shape
- [x] 7.7 Add test for `make-text-shape-3d` with nil font → nil
- [x] 7.8 Add test for `make-text-shape-3d` with zero depth → nil
- [x] 7.9 Add test for STEP roundtrip of 3D text shape
- [x] 7.10 Add test for STL export of 3D text shape
- [x] 7.11 Add test for `brep-font-p` predicate on font and nil
- [x] 7.12 Run full test suite with `(cl-occt::run-tests)` and confirm all 89+ tests pass

## 8. Documentation

- [x] 8.1 Update `README.md` with 3D text usage section including code examples for font loading, flat text, and 3D text creation
- [x] 8.2 Document size unit convention (model units vs typographic points) with conversion formula
