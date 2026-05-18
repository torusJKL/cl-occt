## Why

Build a REPL-driven parametric CAD system using Common Lisp (SBCL) and OCCT. V1 establishes the core geometry kernel, reactive DAG, and DSL — enough to define parametric models and export the result to STEP. This is the foundation: no visualization yet, but every piece of the pipeline is live and testable from the REPL.

## What Changes

- **C wrapper library** (`libocctwrap.so`): thin C bridge exposing OCCT primitives, booleans, transforms, and STEP I/O to Common Lisp via CFFI
- **CL bindings** (`cl-occt`): CLOS wrappers around OCCT shapes with `tg:finalize` garbage collection
- **Reactive DAG**: parameter store + dependency graph + topological evaluation — functional recomputation on param change
- **DSL**: `defmodel`, `param`, `model-ref`, `set-param!`, `set-params!` macros and functions
- **STEP export/import**: write OCCT shapes to STEP AP203, read STEP files into shapes

## Capabilities

### New Capabilities

- `primitives`: Box, cylinder, sphere, cone construction via OCCT BRepPrimAPI
- `booleans`: CSG cut, fuse, common operations via OCCT BRepAlgoAPI
- `transforms`: Translate and rotate shapes via OCCT gp_Trsf / BRepBuilderAPI_Transform
- `step-io`: Export shapes to STEP AP203 files and import STEP files into shapes
- `reactive-dag`: Parameter store, model registry, dependency tracking, topological sort, reactive recomputation on param change

### Modified Capabilities

None — this is the initial project.

## Impact

- New C++ wrapper library: `wrap/occt_wrap.cpp` → `lib/libocctwrap.so`
- New Common Lisp system: `cl-occt` ASDF system, ~12 source files
- New build tooling: `justfile` for OCCT setup + wrapper compilation
- Dependencies: OCCT 8.0 shared libs, CFFI, trivial-garbage, alexandria
