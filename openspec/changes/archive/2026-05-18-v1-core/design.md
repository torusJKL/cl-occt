## Context

A Common Lisp parametric CAD needs three layers: a C++ geometry kernel (OCCT), a C bridge, and the CL system. V1 delivers the geometry pipeline without visualization — results are verified via STEP export and third-party viewers.

The system has five capabilities (defined in specs/): primitives, booleans, transforms, step-io, and reactive-dag. Every operation is usable from the REPL; ALL OCCT operations use native B-Rep (not tessellated derivatives).

## Goals / Non-Goals

**Goals:**
- CLOS shape wrappers around OCCT TopoDS_Shape with tg:finalize GC
- Common Lisp DSL for parametric model definition (defmodel, param, model-ref)
- Reactive DAG: parameter changes trigger topological-sorted recomputation
- STEP export/import for result verification and interop
- Build system: just script downloads + builds OCCT, compiles C wrapper
- Cross-platform in principle (Linux now, macOS/Windows later)

**Non-Goals:**
- No visualization — results viewed in third-party STEP viewers
- No in-app REPL — SLIME/SWANK is the REPL interface
- No GUI — REPL-only interaction
- No error recovery beyond nil propagation

## Decisions

### Architecture: Thin C Bridge

```
SBCL + CFFI  →  libocctwrap.so  →  OCCT shared libs
```

OCCT is C++. CFFI can only call C. Each OCCT class operation becomes a C function that manages opaque `void*` pointers. The C wrapper is pure mechanical translation — no business logic, just `extern "C"` wrappers around OCCT constructors and methods.

**Alternatives considered:**
- *IPC to separate process*: Rejected — adds complexity, loses REPL interactivity
- *SWIG CFFI generator*: Rejected — experimental, unmaintained
- *Thick wrapper*: Rejected — put logic in CL where it's REPL-changeable

### Shape Memory Management: Finalizer-Based GC

```lisp
(defun make-shape (ptr)
  (if (null-pointer-p ptr)
      nil
      (let ((s (make-instance 'shape :ptr ptr)))
        (tg:finalize s (lambda () (%free-shape ptr)))
        s)))
```

Each OCCT TopoDS_Shape is heap-allocated in C++, wrapped by a CLOS shape. When the CLOS instance becomes unreachable, tg:finalize calls free_shape. The reactive DAG holds references to current shapes, so only obsolete shapes get collected.

**Alternatives considered:**
- *Manual free*: Rejected — violates "functional generation" spirit
- *OCCT Handle ref-counting only*: Rejected — doesn't integrate with CL GC

### Error Handling: Return Nil

All C wrapper functions return `nullptr` on failure and set a thread-local error string. `make-shape` converts `nullptr` to CL `nil`. In the DAG, nil propagates: a model that evaluates to nil passes nil to dependents, and the shape disappears from cache.

### Reactive DAG: Explicit Deps via model-ref

`defmodel` scans its body at macro-expand time for `(model-ref 'name)` calls to build the dependency graph statically. `param` is a lookup function that checks `*local-params*` (when DAG-bound) then `*params*` (global). Topological sort (Kahn's algorithm) determines evaluation order.

**Alternatives considered:**
- *Runtime dependency tracking*: Rejected — simpler to analyze statically
- *Cells/dataflow constraints*: Rejected — more power than needed, extra dependency

### Param Resolution: Dynamic Scoping with Fallback

```lisp
(defun param (key)
  (or (and (boundp '*local-params*)
           (getf *local-params* key))
      (getf *params* key)
      (error "Param ~S not found" key)))
```

This gives every defmodel dual-mode operation: global params through *params*, or local override when called as a function with keyword args.

### Build System: Justfile + CMake

`just setup` downloads an OCCT release tarball, builds with CMake as shared libraries (Visualization and ApplicationFramework disabled), installs to `.local/`. `just wrap` compiles `libocctwrap.so` linking against the minimum 10 OCCT libs. `just repl` loads SBCL with cl-occt.

### C Wrapper: 14 Functions for V1

Minimum viable surface:

| Group | Functions |
|---|---|
| Primitives | `make_box`, `make_cylinder`, `make_sphere`, `make_cone` |
| Booleans | `boolean_cut`, `boolean_fuse`, `boolean_common` |
| Transforms | `translate`, `rotate` |
| STEP I/O | `write_step`, `read_step` |
| Memory | `free_shape` |
| Error | `get_error_code`, `get_error_message` |

### Minimum OCCT Library Link

10 shared libs: TKernel, TKMath, TKG2d, TKG3d, TKBRep, TKPrim, TKBool, TKSTEP, TKSTEPBase, TKXSBase. Visualization (TKV3d, TKOpenGl) and ApplicationFramework (TKCAF) are excluded.

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| OCCT C++ exceptions leak through | Catch all Standard_Failure in every wrapper func |
| OCCT build is slow (~15 min) | Only needed once; cached in .local/ |
| tg:finalize may not run promptly | Acceptable for V1; SBCL GC runs frequently |
| nil in DAG could cascade silently | Keep it simple for V1; add error visualization later |
| C wrapper must be manually maintained | 14 functions for V1; automate with codegen if it grows |
