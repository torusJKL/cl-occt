## 1. C Wrapper — OCAF Core (TDF + TDocStd)

- [x] 1.1 Add includes for `TDF_Data.hxx`, `TDF_Label.hxx`, `TDF_Tool.hxx`, `TDocStd_Document.hxx`, `TDocStd_Application.hxx`, `TDataStd_Integer.hxx`, `TDataStd_Real.hxx`, `TDataStd_AsciiString.hxx`, `TDataStd_Name.hxx` to new `wrap/occt_wrap_ocaf_core.cpp`
- [x] 1.2 Implement `ocaf_new_doc` in `occt_wrap_ocaf_core.cpp`: create TDocStd_Document, return handle
- [x] 1.3 Implement `ocaf_free_doc`: free document handle
- [x] 1.4 Implement `ocaf_root_label`: return root label of document
- [x] 1.5 Implement `ocaf_find_label`: accept doc + tag array + count + create flag, return label
- [x] 1.6 Implement `ocaf_label_tag`: return tag integer
- [x] 1.7 Implement `ocaf_label_depth`: return depth integer
- [x] 1.8 Implement `ocaf_label_children`: accept label, return child label array + count
- [x] 1.9 Implement `ocaf_begin_transaction`: accept doc + name string
- [x] 1.10 Implement `ocaf_commit_transaction`: accept doc
- [x] 1.11 Implement `ocaf_undo_transaction`: accept doc
- [x] 1.12 Implement `ocaf_set_integer`, `ocaf_get_integer`, `ocaf_has_integer` for TDataStd_Integer
- [x] 1.13 Implement `ocaf_set_real`, `ocaf_get_real`, `ocaf_has_real` for TDataStd_Real
- [x] 1.14 Implement `ocaf_set_string`, `ocaf_get_string`, `ocaf_has_string` for TDataStd_AsciiString
- [x] 1.15 Implement `ocaf_set_name`, `ocaf_get_name` for TDataStd_Name
- [x] 1.16 Declare all new functions in new `wrap/occt_wrap_ocaf_core.h`

## 2. C Wrapper — OCAF Naming (TNaming)

- [x] 2.1 Add includes for `TNaming_Builder.hxx`, `TNaming_NamedShape.hxx` to new `wrap/occt_wrap_ocaf_naming.cpp`
- [x] 2.2 Implement `ocaf_name_shape`: accept label + shape + evolution code (int), run TNaming_Builder, store shape
- [x] 2.3 Implement `ocaf_get_named_shape`: accept label + evolution code, return shape or null
- [x] 2.4 Implement `ocaf_named_shape_is_deleted`: accept label, return boolean
- [x] 2.5 Declare all new functions in new `wrap/occt_wrap_ocaf_naming.h`

## 3. C Wrapper — OCAF Function (TFunction)

- [x] 3.1 Add includes for `TFunction_Function.hxx`, `TFunction_Driver.hxx`, `TFunction_Iterator.hxx`, `TFunction_Logbook.hxx` to new `wrap/occt_wrap_ocaf_function.cpp`
- [x] 3.2 Implement `ocaf_add_function`: accept label + driver GUID string, create TFunction_Function attribute
- [x] 3.3 Implement `ocaf_set_function_input`: accept function label + input label
- [x] 3.4 Implement `ocaf_set_function_output`: accept function label + output label
- [x] 3.5 Implement `ocaf_recompute_doc`: accept doc, run TFunction_Iterator to recompute all dirty functions
- [x] 3.6 Implement `ocaf_recompute_function`: accept function label, recompute single function
- [x] 3.7 Declare all new functions in new `wrap/occt_wrap_ocaf_function.h`

## 4. CFFI Bindings

- [x] 4.1 Add CFFI `defcfun` bindings for all OCAF core C functions in new `src/ffi/bindings-ocaf-core.lisp`
- [x] 4.2 Add CFFI bindings for naming functions in new `src/ffi/bindings-ocaf-naming.lisp`
- [x] 4.3 Add CFFI bindings for function functions in new `src/ffi/bindings-ocaf-function.lisp`

## 5. Core CLOS Wrappers

- [x] 5.1 Create `src/core/ocaf-label-tree.lisp` with `make-ocaf-doc`, `ocaf-root-label`, `ocaf-find-label`, `ocaf-label-children`, `ocaf-label-tag`, `ocaf-label-depth`
- [x] 5.2 Add document transaction functions: `ocaf-begin-transaction`, `ocaf-commit-transaction`, `ocaf-undo-transaction`
- [x] 5.3 Create `src/core/ocaf-attributes.lisp` with `ocaf-set-integer`, `ocaf-get-integer`, `ocaf-has-integer-p`, `ocaf-set-real`, `ocaf-get-real`, `ocaf-has-real-p`, `ocaf-set-string`, `ocaf-get-string`, `ocaf-has-string-p`, `ocaf-set-name`, `ocaf-get-name`
- [x] 5.4 Create `src/core/ocaf-naming.lisp` with `ocaf-name-shape`, `ocaf-get-named-shape`, `ocaf-shape-deleted-p` with evolution keyword mapping
- [x] 5.5 Create `src/core/ocaf-functions.lisp` with `ocaf-add-function`, `ocaf-set-function-input`, `ocaf-set-function-output`, `ocaf-recompute`, `ocaf-recompute-function`

## 6. System Integration

- [x] 6.1 Add new core files to `cl-occt.asd`
- [x] 6.2 Add new wrap files to `wrap/Makefile`
- [x] 6.3 Export new public symbols from `src/package.lisp`
- [x] 6.4 Update `src/core/xcaf-doc.lisp` if ocaf-doc class needs to be shared (no change needed — separate classes)

## 7. Tests

- [x] 7.1 Add OCAF document tests: create, root label, find label, children, tags, depth
- [x] 7.2 Add transaction tests: begin, commit, undo, undo restores previous state
- [x] 7.3 Add attribute tests: set/get integer, real, string, has-p, remove, name
- [x] 7.4 Add naming tests: name a shape, retrieve by evolution, check deleted
- [x] 7.5 Add function tests: add function, set inputs/outputs, trigger recompute
- [x] 7.6 Register all new tests in the test runner function

## 8. Documentation

- [x] 8.1 Add "OCAF Document & Label Tree" section to `doc/api-reference.md`
- [x] 8.2 Add "OCAF Attributes" section to `doc/api-reference.md`
- [x] 8.3 Add "Topological Naming" section to `doc/api-reference.md`
- [x] 8.4 Add "Parametric Functions" section to `doc/api-reference.md`

## 9. Build & Verify

- [x] 9.1 Rebuild `lib/libocctwrap.so` with `just wrap`
- [x] 9.2 Run `just test-all` to verify all new and existing tests pass
