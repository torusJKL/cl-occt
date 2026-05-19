## 1. Build Setup

- [x] 1.1 Enable OCAF in OCCT build: change `BUILD_MODULE_ApplicationFramework=OFF` to `ON` in `justfile`
- [x] 1.2 Add XDE link flags to `just wrap`: `-lTKXDESTEP -lTKXCAF -lTKCAF`
- [x] 1.3 Rebuild OCCT: `just clean && just setup`
- [x] 1.4 Verify new wrap compiles: `just wrap`

## 2. C Wrapper — XDE Document Lifecycle

- [x] 2.1 Add `xde_new_doc()` — create empty `TDocStd_Document`, return opaque handle
- [x] 2.2 Add `xde_free_doc(handle)` — close document, free memory
- [x] 2.3 Add `xde_read_step(filename)` — `STEPCAFControl_Reader` → populate XDE doc, return handle
- [x] 2.4 Add `xde_write_step(handle, filename)` — `STEPCAFControl_Writer` → write STEP file, return bool

## 3. C Wrapper — Label Navigation

- [x] 3.1 Add `xde_get_root_labels(handle, &out, &count)` — get top-level label paths
- [x] 3.2 Add `xde_label_child_count(handle, label_path)` — number of children
- [x] 3.3 Add `xde_label_get_child(handle, label_path, index)` — child label path

## 4. C Wrapper — Attribute Read (Read Path)

- [x] 4.1 Add `xde_get_shape(handle, label_path)` — extract `TDataXtd_Shape` → `TopoDS_Shape*`
- [x] 4.2 Add `xde_get_name(handle, label_path)` — extract `TDataStd_Name` → char buffer
- [x] 4.3 Add `xde_get_color(handle, label_path, &type, &r, &g, &b, &a)` — extract `XCAFDoc_ColorTool` color
- [x] 4.4 Add `xde_get_location(handle, label_path, &matrix)` — extract `XCAFDoc_ShapeTool::GetLocation` → 4×4 matrix

## 5. C Wrapper — Attribute Write (Write Path)

- [x] 5.1 Add `xde_add_part(handle, path, shape, name, color, matrix, buf)` — composite add+set all properties
- [x] 5.2 Name stored via `TDataStd_Name::Set`
- [x] 5.3 Color stored via `XCAFDoc_ColorTool::SetColor`
- [x] 5.4 Location stored via `XCAFDoc_ShapeTool::SetLocation`

## 6. CFFI Bindings

- [x] 6.1 Add `defcfun` bindings for all 13 new C functions in `src/ffi/bindings.lisp`
- [x] 6.2 Add `defcfun` for `%xde-new-doc`, `%xde-free-doc`, `%xde-read-step`, `%xde-write-step`
- [x] 6.3 Add `defcfun` for label navigation: `%xde-get-root-count`, `%xde-get-root-path`, `%xde-get-child-count`, `%xde-get-child-path`
- [x] 6.4 Add `defcfun` for attribute read: `%xde-get-shape-at`, `%xde-get-name-at`, `%xde-get-color-at`, `%xde-get-location-at`
- [x] 6.5 Add `defcfun` for attribute write: `%xde-add-part`
- [x] 6.6 Export all `%`-prefixed symbols from `cl-occt.impl` in `src/package.lisp`

## 7. Lisp Assembly Tree Class

- [x] 7.1 Create `src/core/assembly.lisp` with the `assembly` class (shape, name, color, location, children slots)
- [x] 7.2 Implement `make-part` factory function
- [x] 7.3 Implement `make-assembly` factory function
- [x] 7.4 Implement accessors: `assembly-shape`, `assembly-name`, `assembly-color`, `assembly-location`, `assembly-children`
- [x] 7.5 Implement `assembly-leaf-p` and `assembly-branch-p` predicates
- [x] 7.6 Implement `(setf assembly-name)`, `(setf assembly-color)`, `(setf assembly-children)` mutators
- [x] 7.7 Export all new symbols from both `cl-occt` and `cl-occt.impl` packages

## 8. Lisp STEP I/O — Assembly Read/Write

- [x] 8.1 Implement `read-step-assembly` in `src/core/io.lisp` — call C, walk label tree, build `assembly` tree
- [x] 8.2 Implement `write-step-assembly` in `src/core/io.lisp` — walk `assembly` tree, create XDE labels, call C write
- [x] 8.3 Implement recursive `%read-node` helper (C tree → Lisp tree)
- [x] 8.4 Implement recursive `%write-node` helper (Lisp tree → C tree)
- [x] 8.5 Update `write-step` to use `STEPControl_Assembly` mode instead of `STEPControl_AsIs`

## 9. README Update

- [x] 9.1 Update build section: note OCAF is now enabled
- [x] 9.2 Add `assembly-tree` API reference table with `make-part`, `make-assembly`, accessors, predicates
- [x] 9.3 Add colored STEP I/O section with `read-step-assembly`/`write-step-assembly` examples
- [x] 9.4 Add multi-part round-trip example in README quickstart
- [x] 9.5 Update C wrapper function count from 31 to 44
- [x] 9.6 Update project structure diagram to include `assembly.lisp`

## 10. Tests

- [x] 10.1 Add test: create leaf part with `make-part`, verify accessors return correct values
- [x] 10.2 Add test: `assembly-leaf-p` returns `t` for leaf, `nil` for branch
- [x] 10.3 Add test: `assembly-branch-p` returns `t` for branch, `nil` for leaf
- [x] 10.4 Add test: setf on assembly slots mutates correctly
- [x] 10.5 Add test: `write-step-assembly` writes single part, `read-step-assembly` reads it back
- [x] 10.6 Add test: round-trip assembly tree with 2 colored parts preserves names, colors, hierarchy
- [x] 10.7 Add test: round-trip nested assemblies (sub-assembly under root)
- [x] 10.8 Add test: `read-step-assembly` on non-existent file returns nil
- [x] 10.9 Add test: `write-step-assembly` on nil returns nil
- [x] 10.10 Add test: color components stored correctly
- [x] 10.11 Add test: unset color/name returns nil
- [x] 10.12 Register all new tests in `run-tests` function
