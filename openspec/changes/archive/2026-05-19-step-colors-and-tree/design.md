## Context

cl-occt currently performs STEP I/O through `STEPControl_Reader`/`STEPControl_Writer`, which treats any STEP file as a single flat shape. All metadata (colors, names, assembly hierarchy, layer assignments) is discarded. OCCT provides a richer path through `STEPCAFControl_Reader`/`STEPCAFControl_Writer`, which reads/writes into an XDE (Extended Data Exchange) document — an OCAF label tree where each label can carry shape, name, color, location, and other attributes as attached tags.

The current C wrapper links `TKDESTEP`/`TKXSBase` but not the XDE libraries. The OCCT build disables `ApplicationFramework` (OCAF). Both need enabling.

## Goals / Non-Goals

**Goals:**
- Round-trip STEP files preserving part names, whole-part colors (RGBA), and assembly tree structure
- Lisp-native tree data model (read-once from C++, rebuild on write) matching the existing `make-shape` pattern
- Minimal C wrapper surface (~15 functions) that maps directly to XDE operations
- All new public API follows existing conventions (nil propagation, `%`-prefixed CFFI, `tg:finalize` GC)

**Non-Goals:**
- Per-face colors (out of scope for this change)
- Layer or material round-tripping (can be layered on later)
- DAG integration (models producing assembly trees — future work)
- Graphical visualization of colors

## Decisions

### Decision 1: Read-once native Lisp tree (not XDE doc mirror)

**Chosen**: Extract all data from the XDE document on read, build a native Lisp tree, free the C++ document. On write, recreate the XDE document from the Lisp tree.

**Alternatives considered:**
- *Mirror XDE doc*: Keep the C++ document alive, expose opaque label references through CFFI. More complex memory management, many CFFI round-trips per access, doesn't match existing codebase patterns.
- *Lazy bridge*: Keep XDE doc alive, cache attributes in Lisp slots. Worst of both worlds — dual ownership complexity.

**Rationale**: Matches the existing `shape` pattern (extract from C++, free C++, Lisp owns the data). Simpler memory model. The XDE doc is cheap to recreate on write.

### Decision 2: Single `assembly` class (not separate `part`/`assembly` types)

**Chosen**: One `assembly` class. A leaf node has `shape` but no `children`; a branch node has `children` but no `shape`; a combined node can have both (a compound shape with sub-labels).

```lisp
(defclass assembly ()
  ((%shape    :initarg :shape    :initform nil)
   (%name     :initarg :name     :initform nil)
   (%color    :initarg :color    :initform nil)
   (%location :initarg :location :initform nil)
   (%children :initarg :children :initform nil)))
```

**Alternatives considered:**
- *Separate `part` and `assembly` classes*: More type safety but more classes, more predicates, awkward when a node is both (compound with geometry AND children).

**Rationale**: Simpler API surface. `make-part` and `make-assembly` become factory functions that produce `assembly` instances with different slot combinations. Predicates like `assembly-leaf-p` and `assembly-branch-p` provide the distinction.

### Decision 3: Flat location as 4×4 matrix (not gp_Trsf)

**Chosen**: Represent locations as a 4×4 homogeneous transformation matrix `#(a0 a1 a2 a3 b0 b1 b2 b3 c0 c1 c2 c3 d0 d1 d2 d3)` (row-major, 16 double-floats).

**Alternatives considered:**
- *gp_Trsf struct*: Maps directly to OCCT but requires complex CFFI struct handling.
- *TRS decomposition*: Translation + rotation + scale. Cleaner for humans but adds conversion complexity.

**Rationale**: 4×4 matrix is the universal interchange format for 3D transforms. Easy to convert to/from gp_Trsf in C wrapper. Users can apply them with standard matrix math. `nil` means identity (no location).

### Decision 4: Color as keyword-initarg plist, not struct

**Chosen**: Colors as `(:generic r g b a)` or `(:surf r g b a)` or `(:curv r g b a)` — a plist with type keyword and 4 double-float components in [0,1].

**Alternatives considered:**
- *Custom color struct*: More type safety but another CFFI type to define.
- *RGB tuple only*: Simpler but loses color type distinction (generic vs surface vs curve).

**Rationale**: Plist is flexible, extensible, and requires no CFFI serialization. The color type keyword lets us round-trip the `XCAFDoc_ColorGen`/`ColorSurf`/`ColorCurv` distinction. `nil` means no color assigned.

## Risks / Trade-offs

- **OCAF build cost**: Enabling `ApplicationFramework` increases OCCT build time and library size. Existing `.local/` needs a full rebuild (`just clean && just setup`).
- **OCAF link complexity**: `TKCAF`, `TKXCAF`, `TKXDESTEP` add ~3 shared libs. Must verify no symbol conflicts with existing link.
- **Shape lifecycle on write**: When writing, shapes referenced in the assembly tree must still be alive (not GC'd). The Lisp tree holds references so `tg:finalize` won't fire while the tree is reachable.
- **Multi-root STEP files**: Existing `read-step` returns `nil` for files with >1 root. This is a breaking change. Mitigation: document clearly; `read-step-assembly` handles all cases.
